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
}
