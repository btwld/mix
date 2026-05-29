import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/modifiers/visibility_modifier.dart';

void main() {
  group('VisibilityModifier', () {
    test('lerp snaps at midpoint', () {
      const start = VisibilityModifier(false);
      const end = VisibilityModifier(true);

      // lerpSnap: t < 0.5 returns start, t >= 0.5 returns end
      expect(start.lerp(end, 0.0).visible, isFalse);
      expect(start.lerp(end, 0.49).visible, isFalse);
      expect(start.lerp(end, 0.5).visible, isTrue);
      expect(start.lerp(end, 1.0).visible, isTrue);
    });

    test('lerp returns self when other is null', () {
      const start = VisibilityModifier(true);

      final result = start.lerp(null, 0.5);

      expect(identical(result, start), isTrue);
    });

    test('lerp preserves value when both are same', () {
      const start = VisibilityModifier(true);
      const end = VisibilityModifier(true);

      final mid = start.lerp(end, 0.5);

      expect(mid.visible, isTrue);
    });
  });
}
