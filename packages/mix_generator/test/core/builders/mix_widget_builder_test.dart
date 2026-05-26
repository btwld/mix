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
            MixWidgetParam(
              name: 'child',
              typeCode: 'Widget?',
              isPositional: false,
              isRequired: false,
              source: ParamSource.call,
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
            MixWidgetParam(
              name: 'color',
              typeCode: 'Color?',
              isPositional: false,
              isRequired: false,
              source: ParamSource.factory_,
            ),
            MixWidgetParam(
              name: 'style',
              typeCode: 'BoxStyler?',
              isPositional: false,
              isRequired: false,
              source: ParamSource.factory_,
            ),
          ],
          callParams: [
            MixWidgetParam(
              name: 'child',
              typeCode: 'Widget?',
              isPositional: false,
              isRequired: false,
              source: ParamSource.call,
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
      expect(code, contains('return badgeStyle(color: color, style: style).call('));
    });

    test('positional call param emits first in constructor', () {
      final builder = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'Label',
          factoryReference: 'labelStyle',
          isFunctionFactory: true,
          factoryParams: [
            MixWidgetParam(
              name: 'color',
              typeCode: 'Color?',
              isPositional: false,
              isRequired: false,
              source: ParamSource.factory_,
            ),
          ],
          callParams: [
            MixWidgetParam(
              name: 'text',
              typeCode: 'String',
              isPositional: true,
              isRequired: true,
              source: ParamSource.call,
            ),
          ],
          stylerCallForwardsKey: true,
        ),
      );

      final code = builder.build();

      expect(code, contains('class Label extends StatelessWidget'));
      expect(code, contains('const Label(this.text, {super.key, this.color});'));
      expect(code, contains('return labelStyle(color: color).call('));
    });

    test('required call params surface required keyword', () {
      final builder = MixWidgetBuilder(
        const MixWidgetModel(
          widgetName: 'PrimaryButton',
          factoryReference: 'primaryButtonStyle',
          isFunctionFactory: true,
          factoryParams: [
            MixWidgetParam(
              name: 'color',
              typeCode: 'Color',
              isPositional: false,
              isRequired: false,
              defaultValueCode: 'const Color(0xFF0000FF)',
              source: ParamSource.factory_,
            ),
          ],
          callParams: [
            MixWidgetParam(
              name: 'onPressed',
              typeCode: 'VoidCallback',
              isPositional: false,
              isRequired: true,
              source: ParamSource.call,
            ),
            MixWidgetParam(
              name: 'child',
              typeCode: 'Widget',
              isPositional: false,
              isRequired: true,
              source: ParamSource.call,
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
