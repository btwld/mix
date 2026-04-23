import 'package:mix_generator/src/core/builders/mix_widget_builder.dart';
import 'package:mix_generator/src/core/models/mix_widget_param_model.dart';
import 'package:test/test.dart';

void main() {
  group('MixWidgetBuilder', () {
    test('variable form with nullable child', () {
      final out = const MixWidgetBuilder(
        widgetName: 'Card',
        sourceKind: MixWidgetSourceKind.variable,
        sourceName: 'card',
        sourceParams: <MixWidgetParam>[],
        callParams: [
          MixWidgetParam(
            name: 'child',
            typeDisplay: 'Widget?',
            isPositional: false,
            isRequired: false,
            defaultValueCode: null,
          ),
        ],
        callHasPositional: false,
        stylable: false,
        stylerTypeDisplay: 'BoxStyler',
      ).build();

      expect(out, contains('class Card extends StatelessWidget'));
      expect(out, contains('final Widget? child;'));
      expect(out, contains('const Card({super.key, this.child});'));
      expect(
        out,
        contains('Widget build(BuildContext context) => card(child: child);'),
      );
    });

    test('function form with overlap merges to single field', () {
      final out = const MixWidgetBuilder(
        widgetName: 'Card1',
        sourceKind: MixWidgetSourceKind.function,
        sourceName: 'createCard',
        sourceParams: [
          MixWidgetParam(
            name: 'child',
            typeDisplay: 'Widget',
            isPositional: true,
            isRequired: true,
            defaultValueCode: null,
          ),
          MixWidgetParam(
            name: 'color',
            typeDisplay: 'Color',
            isPositional: false,
            isRequired: false,
            defaultValueCode: 'Colors.white',
          ),
        ],
        callParams: [
          MixWidgetParam(
            name: 'child',
            typeDisplay: 'Widget?',
            isPositional: false,
            isRequired: false,
            defaultValueCode: null,
          ),
        ],
        callHasPositional: false,
        stylable: false,
        stylerTypeDisplay: 'BoxStyler',
      ).build();

      expect(out, contains('class Card1 extends StatelessWidget'));
      expect(out, contains('final Widget child;'));
      expect(out, contains('final Color color;'));
      expect(
        out,
        contains(
          'const Card1({super.key, required this.child, this.color = Colors.white});',
        ),
      );
      expect(
        out,
        contains(
          'Widget build(BuildContext context) => createCard(child, color: color)(child: child);',
        ),
      );
    });

    test('stylable variable form adds style field and merge call', () {
      final out = const MixWidgetBuilder(
        widgetName: 'Card',
        sourceKind: MixWidgetSourceKind.variable,
        sourceName: 'card',
        sourceParams: <MixWidgetParam>[],
        callParams: [
          MixWidgetParam(
            name: 'child',
            typeDisplay: 'Widget?',
            isPositional: false,
            isRequired: false,
            defaultValueCode: null,
          ),
        ],
        callHasPositional: false,
        stylable: true,
        stylerTypeDisplay: 'BoxStyler',
      ).build();

      expect(out, contains('final BoxStyler? style;'));
      expect(out, contains('this.style'));
      expect(
        out,
        contains(
          'Widget build(BuildContext context) => card.merge(style)(child: child);',
        ),
      );
    });

    test('positional call signature passes argument positionally', () {
      final out = const MixWidgetBuilder(
        widgetName: 'Heading',
        sourceKind: MixWidgetSourceKind.variable,
        sourceName: 'heading',
        sourceParams: <MixWidgetParam>[],
        callParams: [
          MixWidgetParam(
            name: 'text',
            typeDisplay: 'String',
            isPositional: true,
            isRequired: true,
            defaultValueCode: null,
          ),
        ],
        callHasPositional: true,
        stylable: false,
        stylerTypeDisplay: 'TextStyler',
      ).build();

      expect(out, contains('final String text;'));
      expect(
        out,
        contains('const Heading({super.key, required this.text});'),
      );
      expect(
        out,
        contains('Widget build(BuildContext context) => heading(text);'),
      );
    });
  });
}
