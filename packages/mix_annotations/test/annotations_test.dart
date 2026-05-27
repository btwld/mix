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

    test('preserves mixin and factoryName overrides', () {
      const annotation = MixableField(mixin: String, factoryName: 'foo');
      expect(annotation.mixin, String);
      expect(annotation.factoryName, 'foo');
    });
  });
}
