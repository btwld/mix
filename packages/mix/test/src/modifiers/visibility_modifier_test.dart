import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/modifiers/visibility_modifier.dart';

void main() {
  group('VisibilityModifier', () {
    test('lerp keeps visible during transition', () {
      const start = VisibilityModifier(false);
      const end = VisibilityModifier(true);

      final mid = start.lerp(end, 0.5);

      expect(mid.visible, isTrue);
    });

    test('lerp respects endpoints', () {
      const start = VisibilityModifier(false);
      const end = VisibilityModifier(true);

      final atStart = start.lerp(end, 0.0);
      final atEnd = start.lerp(end, 1.0);

      expect(identical(atStart, start), isTrue);
      expect(identical(atEnd, end), isTrue);
    });

    test('lerp returns self when visibility does not change', () {
      const start = VisibilityModifier(true);
      const end = VisibilityModifier(true);

      final mid = start.lerp(end, 0.5);

      expect(identical(mid, start), isTrue);
    });
  });
}
