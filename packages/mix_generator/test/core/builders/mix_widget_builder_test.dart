import 'package:mix_generator/src/core/builders/mix_widget_builder.dart';
import 'package:mix_generator/src/core/models/mix_widget_model.dart';
import 'package:test/test.dart';

void main() {
  group('MixWidgetBuilder', () {
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
      expect(code, contains('key: this.key,'));
      expect(code, contains('child: this.child,'));
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
        contains(
          'return badgeStyle(color: this.color, style: this.style).call(',
        ),
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
      expect(code, contains('return labelStyle(color: this.color).call('));
      expect(code, contains('      this.text,\n      key: this.key,'));
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
      expect(code, contains('onPressed: this.onPressed,'));
      expect(code, contains('child: this.child,'));
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
      expect(code, isNot(contains('key: this.key')));
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
  });
}
