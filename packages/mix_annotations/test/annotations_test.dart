import 'package:mix_annotations/mix_annotations.dart';
import 'package:test/test.dart';

void main() {
  group('MixableSpec', () {
    test('defaults extraStylerMixins to empty list', () {
      const annotation = MixableSpec();
      expect(annotation.extraStylerMixins, isEmpty);
    });

    test('preserves explicit extraStylerMixins', () {
      const annotation = MixableSpec(extraStylerMixins: [String, int]);
      expect(annotation.extraStylerMixins, [String, int]);
    });
  });

  group('MixableField', () {
    test('defaults skipMixin to false', () {
      const annotation = MixableField();
      expect(annotation.skipMixin, isFalse);
    });

    test('defaults skipFactory to false', () {
      const annotation = MixableField();
      expect(annotation.skipFactory, isFalse);
    });

    test('defaults nested styler forwarding to disabled', () {
      const annotation = MixableField();
      expect(annotation.forwardStyler, isFalse);
      expect(annotation.stylerSurface, isNull);
    });

    test('preserves mixin and factoryName overrides', () {
      const annotation = MixableField(mixin: String, factoryName: 'foo');
      expect(annotation.mixin, String);
      expect(annotation.factoryName, 'foo');
    });

    test('preserves nested styler forwarding configuration', () {
      const annotation = MixableField(
        forwardStyler: true,
        stylerSurface: String,
      );

      expect(annotation.forwardStyler, isTrue);
      expect(annotation.stylerSurface, String);
    });
  });

  group('MixWidget', () {
    test('defaults widgetParameters to all', () {
      const annotation = MixWidget();

      expect(annotation.widgetParameters.includesAll, isTrue);
      expect(annotation.widgetParameters.names, isEmpty);
    });

    test('preserves an explicit all selection', () {
      const annotation = MixWidget(widgetParameters: .all());

      expect(annotation.widgetParameters.includesAll, isTrue);
      expect(annotation.widgetParameters.names, isEmpty);
    });

    test('preserves selected widget parameters', () {
      const annotation = MixWidget(
        widgetParameters: .only({'controller', 'focusNode'}),
      );

      expect(annotation.widgetParameters.includesAll, isFalse);
      expect(annotation.widgetParameters.names, {'controller', 'focusNode'});
    });

    test('allows an empty widget parameter selection', () {
      const annotation = MixWidget(widgetParameters: .only({}));

      expect(annotation.widgetParameters.includesAll, isFalse);
      expect(annotation.widgetParameters.names, isEmpty);
    });
  });
}
