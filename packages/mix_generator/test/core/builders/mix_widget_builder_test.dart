import 'dart:io';

import 'package:mix_generator/src/core/builders/mix_widget_builder.dart';
import 'package:mix_generator/src/core/models/mix_widget_model.dart';
import 'package:test/test.dart';

void main() {
  group('MixWidgetBuilder', () {
    test(
      'generated build is lint-clean and preserves a context field',
      () async {
        final code = MixWidgetBuilder(
          const MixWidgetModel(
            widgetName: 'Demo',
            factoryReference: 'demoStyle',
            isFunctionFactory: true,
            factoryParams: [
              WidgetCallParam(
                name: 'context',
                typeCode: 'String',
                isPositional: false,
                isRequired: true,
              ),
            ],
            callParams: [
              WidgetCallParam(
                name: 'label',
                typeCode: 'String',
                isPositional: false,
                isRequired: true,
              ),
            ],
            stylerCallForwardsKey: true,
          ),
        ).build();
        final directory = Directory.systemTemp.createTempSync(
          'mix-widget-lint-',
        );
        addTearDown(() => directory.deleteSync(recursive: true));
        File(
          '${directory.path}/analysis_options.yaml',
        ).writeAsStringSync('linter:\n  rules:\n    unnecessary_this: true\n');
        File('${directory.path}/example.dart').writeAsStringSync('''
class Key { const Key(); }
class BuildContext {}
class Widget { const Widget({this.key}); final Key? key; }
abstract class StatelessWidget extends Widget {
  const StatelessWidget({super.key});
  Widget build(BuildContext context);
}
class DemoStyle {
  Widget call({Key? key, required String label}) => Widget(key: key);
}
DemoStyle demoStyle({required String context}) => DemoStyle();
$code
''');
        final result = await Process.run(Platform.resolvedExecutable, [
          'analyze',
          '--fatal-infos',
          directory.path,
        ]);
        expect(
          result.exitCode,
          0,
          reason: '${result.stdout}\n${result.stderr}',
        );
      },
    );

    test('variable-backed style with child + key', () {
      final builder = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'Card',
          factoryReference: 'cardStyle',
          isFunctionFactory: false,
          factoryParams: [],
          callParams: [
            WidgetCallParam(
              name: 'child',
              typeCode: 'Widget?',
              isPositional: false,
              isRequired: false,
            ),
          ],
          stylerCallForwardsKey: true,
        ),
      );

      final code = builder.build();

      expect(code, contains('class Card extends StatelessWidget'));
      expect(code, contains('const Card({super.key, this.child});'));
      expect(code, contains('final Widget? child;'));
      expect(code, contains('return cardStyle.call('));
      expect(code, contains('key: key,'));
      expect(code, contains('child: child,'));
    });

    test('function-backed style threads factory args before call', () {
      final builder = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'Badge',
          factoryReference: 'badgeStyle',
          isFunctionFactory: true,
          factoryParams: [
            WidgetCallParam(
              name: 'color',
              typeCode: 'Color?',
              isPositional: false,
              isRequired: false,
            ),
            WidgetCallParam(
              name: 'style',
              typeCode: 'BoxStyler?',
              isPositional: false,
              isRequired: false,
            ),
          ],
          callParams: [
            WidgetCallParam(
              name: 'child',
              typeCode: 'Widget?',
              isPositional: false,
              isRequired: false,
            ),
          ],
          stylerCallForwardsKey: true,
        ),
      );

      final code = builder.build();

      expect(code, contains('class Badge extends StatelessWidget'));
      expect(code, contains('this.color'));
      expect(code, contains('this.style'));
      expect(code, contains('this.child'));
      expect(
        code,
        contains('return badgeStyle(color: color, style: style).call('),
      );
    });

    test('positional call param emits first in constructor', () {
      final builder = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'Label',
          factoryReference: 'labelStyle',
          isFunctionFactory: true,
          factoryParams: [
            WidgetCallParam(
              name: 'color',
              typeCode: 'Color?',
              isPositional: false,
              isRequired: false,
            ),
          ],
          callParams: [
            WidgetCallParam(
              name: 'text',
              typeCode: 'String',
              isPositional: true,
              isRequired: true,
            ),
          ],
          stylerCallForwardsKey: true,
        ),
      );

      final code = builder.build();

      expect(code, contains('class Label extends StatelessWidget'));
      expect(
        code,
        contains('const Label(this.text, {super.key, this.color});'),
      );
      expect(code, contains('return labelStyle(color: color).call('));
      expect(code, contains('      text,\n      key: key,'));
    });

    test('required call params surface required keyword', () {
      final builder = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'PrimaryButton',
          factoryReference: 'primaryButtonStyle',
          isFunctionFactory: true,
          factoryParams: [
            WidgetCallParam(
              name: 'color',
              typeCode: 'Color',
              isPositional: false,
              isRequired: false,
              defaultValueCode: 'const Color(0xFF0000FF)',
            ),
          ],
          callParams: [
            WidgetCallParam(
              name: 'onPressed',
              typeCode: 'VoidCallback',
              isPositional: false,
              isRequired: true,
            ),
            WidgetCallParam(
              name: 'child',
              typeCode: 'Widget',
              isPositional: false,
              isRequired: true,
            ),
          ],
          stylerCallForwardsKey: true,
        ),
      );

      final code = builder.build();

      expect(code, contains('required this.onPressed'));
      expect(code, contains('required this.child'));
      expect(code, contains('this.color = const Color(0xFF0000FF)'));
      expect(code, contains('onPressed: onPressed,'));
      expect(code, contains('child: child,'));
    });

    test('no Key? key on styler call → no key forwarding in build', () {
      final builder = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'KeyLess',
          factoryReference: 'keyLessStyle',
          isFunctionFactory: false,
          factoryParams: [],
          callParams: [],
          stylerCallForwardsKey: false,
        ),
      );

      final code = builder.build();

      expect(code, contains('return keyLessStyle.call();'));
      expect(code, isNot(contains('key: key')));
    });

    test('generic styler call emits generic widget and forwards type args', () {
      final builder = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'FortalRadio',
          factoryReference: 'fortalRadioStyle',
          isFunctionFactory: true,
          factoryParams: [],
          callParams: [
            WidgetCallParam(
              name: 'value',
              typeCode: 'T',
              isPositional: false,
              isRequired: true,
            ),
          ],
          callTypeParams: [WidgetCallTypeParam(name: 'T')],
          stylerCallForwardsKey: true,
        ),
      );

      final code = builder.build();

      expect(code, contains('class FortalRadio<T> extends StatelessWidget'));
      expect(code, contains('required this.value'));
      expect(code, contains('final T value;'));
      expect(code, contains('return fortalRadioStyle().call<T>('));
      expect(code, contains('value: value,'));
    });

    test('generic styler call preserves bounds', () {
      final builder = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'BoundedRadio',
          factoryReference: 'boundedRadioStyle',
          isFunctionFactory: false,
          factoryParams: [],
          callParams: [
            WidgetCallParam(
              name: 'value',
              typeCode: 'T',
              isPositional: false,
              isRequired: true,
            ),
          ],
          callTypeParams: [WidgetCallTypeParam(name: 'T', boundCode: 'Enum')],
          stylerCallForwardsKey: false,
        ),
      );

      final code = builder.build();

      expect(
        code,
        contains('class BoundedRadio<T extends Enum> extends StatelessWidget'),
      );
      expect(code, contains('return boundedRadioStyle.call<T>('));
    });

    test('doc comment carries over to the generated class', () {
      final builder = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'Card',
          factoryReference: 'cardStyle',
          isFunctionFactory: false,
          factoryParams: [],
          callParams: [],
          stylerCallForwardsKey: false,
          doc: '/// Documented card.',
        ),
      );

      expect(builder.build(), startsWith('/// Documented card.'));
    });

    test('variant constructors preserve params and pin the enum value', () {
      final builder = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'Button',
          factoryReference: 'buttonStyle',
          isFunctionFactory: true,
          factoryParams: [
            WidgetCallParam(
              name: 'variant',
              typeCode: 'ButtonVariant',
              isPositional: false,
              isRequired: false,
              defaultValueCode: 'ButtonVariant.solid',
            ),
            WidgetCallParam(
              name: 'size',
              typeCode: 'int',
              isPositional: false,
              isRequired: false,
              defaultValueCode: '2',
            ),
          ],
          callParams: [
            WidgetCallParam(
              name: 'label',
              typeCode: 'String',
              isPositional: false,
              isRequired: true,
            ),
            WidgetCallParam(
              name: 'child',
              typeCode: 'Widget?',
              isPositional: false,
              isRequired: false,
            ),
          ],
          stylerCallForwardsKey: true,
          variantParamName: 'variant',
          variantConstructors: [
            WidgetVariantConstructor(
              name: 'solid',
              valueCode: 'ButtonVariant.solid',
              doc: '/// High-emphasis filled button.\n/// Use sparingly.',
            ),
          ],
        ),
      );

      final code = builder.build();
      final constructor = RegExp(
        r'const Button\.solid\(([\s\S]*?)\)\s*:\s*'
        r'variant\s*=\s*ButtonVariant\.solid;',
      ).firstMatch(code);

      expect(constructor, isNotNull);
      expect(constructor!.group(1), isNot(contains('this.variant')));
      expect(constructor.group(1), contains('this.size = 2'));
      expect(constructor.group(1), contains('required this.label'));
      expect(constructor.group(1), contains('this.child'));
      expect(
        code,
        contains(
          '  /// High-emphasis filled button.\n'
          '  /// Use sparingly.\n'
          '  const Button.solid(',
        ),
      );
      expect(code, contains('final ButtonVariant variant;'));
    });

    test('deprecated variant annotates its generated constructor', () {
      final builder = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'Button',
          factoryReference: 'buttonStyle',
          isFunctionFactory: true,
          factoryParams: [
            WidgetCallParam(
              name: 'variant',
              typeCode: 'ButtonVariant',
              isPositional: false,
              isRequired: true,
            ),
          ],
          callParams: [],
          stylerCallForwardsKey: false,
          variantParamName: 'variant',
          variantConstructors: [
            WidgetVariantConstructor(
              name: 'legacy',
              valueCode: 'ButtonVariant.legacy',
              deprecationCode: "@Deprecated('Use solid instead.')",
            ),
          ],
        ),
      );

      expect(
        builder.build(),
        contains(
          "  @Deprecated('Use solid instead.')\n"
          '  const Button.legacy({super.key}) '
          ': variant = ButtonVariant.legacy;',
        ),
      );
    });

    test('empty variant metadata leaves output byte-identical', () {
      final code = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'Card',
          factoryReference: 'cardStyle',
          isFunctionFactory: false,
          factoryParams: [],
          callParams: [],
          stylerCallForwardsKey: false,
        ),
      ).build();

      expect(
        code,
        equals(
          '''
class Card extends StatelessWidget {
  const Card({super.key});

  @override
  Widget build(BuildContext _) {
    return cardStyle.call();
  }
}
'''
              .trimLeft(),
        ),
      );
    });
  });
}
