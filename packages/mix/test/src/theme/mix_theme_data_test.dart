import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('MixThemeData.copyWith', () {
    test('overrides defaultOrderOfModifiers when provided', () {
      final original = MixThemeData(defaultOrderOfModifiers: [Container]);
      final copy = original.copyWith(defaultOrderOfModifiers: [Padding]);

      expect(copy.defaultOrderOfModifiers, equals([Padding]));
    });
  });
}
