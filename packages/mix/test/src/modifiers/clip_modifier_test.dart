import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('ClipPathModifier', () {
    const clipper = _PathClipper();
    const clipper2 = _OtherPathClipper();
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    group('Constructor', () {
      test('creates with null values by default', () {
        const modifier = ClipPathModifier();

        expect(modifier.clipper, isNull);
        expect(modifier.clipBehavior, isNull);
      });

      test('assigns all parameters correctly', () {
        const modifier = ClipPathModifier(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        expect(modifier.clipper, clipper);
        expect(modifier.clipBehavior, clipBehavior);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = ClipPathModifier(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        final updated = original.copyWith(
          clipper: clipper2,
          clipBehavior: clipBehavior2,
        );

        expect(updated.clipper, clipper2);
        expect(updated.clipBehavior, clipBehavior2);
        expect(updated, isNot(same(original)));
      });

      test('preserves original values when parameters are null', () {
        const original = ClipPathModifier(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        final updated = original.copyWith();

        expect(updated.clipper, original.clipper);
        expect(updated.clipBehavior, original.clipBehavior);
        expect(updated, isNot(same(original)));
      });

      test('allows partial updates', () {
        const original = ClipPathModifier(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        final updatedClipper = original.copyWith(clipper: clipper2);
        expect(updatedClipper.clipper, clipper2);
        expect(updatedClipper.clipBehavior, original.clipBehavior);

        final updatedBehavior = original.copyWith(clipBehavior: clipBehavior2);
        expect(updatedBehavior.clipper, original.clipper);
        expect(updatedBehavior.clipBehavior, clipBehavior2);
      });
    });

    group('lerp', () {
      test('interpolates clipper correctly', () {
        const start = ClipPathModifier(clipper: clipper);
        const end = ClipPathModifier(clipper: clipper2);
        final result = start.lerp(end, 0.5);

        expect(result.clipper, clipper2);
      });

      test('interpolates clipBehavior correctly', () {
        const start = ClipPathModifier(clipBehavior: clipBehavior);
        const end = ClipPathModifier(clipBehavior: clipBehavior2);
        final result = start.lerp(end, 0.5);

        expect(result.clipBehavior, clipBehavior2);
      });

      test('handles null other parameter', () {
        const start = ClipPathModifier(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles extreme t values', () {
        const start = ClipPathModifier(clipper: clipper);
        const end = ClipPathModifier(clipper: clipper2);

        final result0 = start.lerp(end, 0.0);
        expect(result0.clipper, clipper);

        final result1 = start.lerp(end, 1.0);
        expect(result1.clipper, clipper2);
      });
    });

    group('equality and hashCode', () {
      test('equal when all properties match', () {
        const modifier1 = ClipPathModifier(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );
        const modifier2 = ClipPathModifier(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when clipper differs', () {
        const modifier1 = ClipPathModifier(clipper: clipper);
        const modifier2 = ClipPathModifier(clipper: clipper2);

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('not equal when clipBehavior differs', () {
        const modifier1 = ClipPathModifier(clipBehavior: clipBehavior);
        const modifier2 = ClipPathModifier(clipBehavior: clipBehavior2);

        expect(modifier1, isNot(equals(modifier2)));
      });
    });

    group('props', () {
      test('contains all properties', () {
        const modifier = ClipPathModifier(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        expect(modifier.props, [clipper, clipBehavior]);
      });

      test('contains null values', () {
        const modifier = ClipPathModifier();

        expect(modifier.props, [null, null]);
      });
    });

    group('build', () {
      testWidgets('creates ClipPath widget with correct properties', (
        WidgetTester tester,
      ) async {
        const modifier = ClipPathModifier(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
        expect(clipPath.clipper, clipper);
        expect(clipPath.clipBehavior, clipBehavior);
        expect(clipPath.child, same(child));
      });

      testWidgets('creates ClipPath widget with default behavior', (
        WidgetTester tester,
      ) async {
        const modifier = ClipPathModifier();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
        expect(clipPath.clipper, isNull);
        expect(clipPath.clipBehavior, Clip.antiAlias);
        expect(clipPath.child, same(child));
      });
    });
  });

  group('ClipPathModifierMix', () {
    const clipper = _PathClipper();
    const clipper2 = _OtherPathClipper();
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    group('Constructor', () {
      test('creates with null values by default', () {
        final attribute = ClipPathModifierMix();

        expect(attribute.clipper, isNull);
        expect(attribute.clipBehavior, isNull);
      });
    });

    group('only constructor', () {
      test('creates from direct values', () {
        final attribute = ClipPathModifierMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        expect(attribute.clipper, resolvesTo(clipper));
        expect(attribute.clipBehavior, resolvesTo(clipBehavior));
      });

      test('handles null values correctly', () {
        final attribute = ClipPathModifierMix();

        expect(attribute.clipper, isNull);
        expect(attribute.clipBehavior, isNull);
      });

      test('handles partial values', () {
        final attribute1 = ClipPathModifierMix(clipper: clipper);
        expect(attribute1.clipper, resolvesTo(clipper));
        expect(attribute1.clipBehavior, isNull);

        final attribute2 = ClipPathModifierMix(
          clipBehavior: clipBehavior,
        );
        expect(attribute2.clipper, isNull);
        expect(attribute2.clipBehavior, resolvesTo(clipBehavior));
      });
    });

    group('resolve', () {
      test('resolves to ClipPathModifier with resolved values', () {
        final attribute = ClipPathModifierMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        const expectedModifier = ClipPathModifier(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );
        expect(attribute, resolvesTo(expectedModifier));
      });

      test('resolves with null values', () {
        final attribute = ClipPathModifierMix();

        const expectedModifier = ClipPathModifier();
        expect(attribute, resolvesTo(expectedModifier));
      });
    });

    group('merge', () {
      test('merges with other ClipPathModifierMix', () {
        final attribute1 = ClipPathModifierMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );
        final attribute2 = ClipPathModifierMix(
          clipper: clipper2,
          clipBehavior: clipBehavior2,
        );

        final merged = attribute1.merge(attribute2);

        expect(merged.clipper, resolvesTo(clipper2)); // overridden
        expect(merged.clipBehavior, resolvesTo(clipBehavior2)); // overridden
      });

      test('returns original when other is null', () {
        final attribute = ClipPathModifierMix(clipper: clipper);

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = ClipPathModifierMix();
        final attribute2 = ClipPathModifierMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        final merged = attribute1.merge(attribute2);

        expect(merged.clipper, resolvesTo(clipper));
        expect(merged.clipBehavior, resolvesTo(clipBehavior));
      });
    });

    group('equality and props', () {
      test('equal when all values match', () {
        final attribute1 = ClipPathModifierMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );
        final attribute2 = ClipPathModifierMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        expect(attribute1, equals(attribute2));
      });

      test('not equal when values differ', () {
        final attribute1 = ClipPathModifierMix(clipper: clipper);
        final attribute2 = ClipPathModifierMix(clipper: clipper2);

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains all values', () {
        final attribute = ClipPathModifierMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        final props = attribute.props;
        expect(props.length, 2);
        expect(props[0], attribute.clipper);
        expect(props[1], attribute.clipBehavior);
      });
    });
  });

  group('ClipTriangleModifier', () {
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    group('Constructor', () {
      test('creates with default clip behavior', () {
        const modifier = ClipTriangleModifier();

        expect(modifier.clipBehavior, isNull);
      });

      test('assigns clipBehavior correctly', () {
        const modifier = ClipTriangleModifier(clipBehavior: clipBehavior);

        expect(modifier.clipBehavior, clipBehavior);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = ClipTriangleModifier(clipBehavior: clipBehavior);

        final updated = original.copyWith(clipBehavior: clipBehavior2);

        expect(updated.clipBehavior, clipBehavior2);
        expect(updated, isNot(same(original)));
      });
    });

    group('lerp', () {
      test('interpolates clipBehavior correctly', () {
        const start = ClipTriangleModifier(clipBehavior: clipBehavior);
        const end = ClipTriangleModifier(clipBehavior: clipBehavior2);
        final result = start.lerp(end, 0.5);

        expect(result.clipBehavior, clipBehavior2);
      });
    });

    group('equality and props', () {
      test('equal when all properties match', () {
        const modifier1 = ClipTriangleModifier(clipBehavior: clipBehavior);
        const modifier2 = ClipTriangleModifier(clipBehavior: clipBehavior);

        expect(modifier1, equals(modifier2));
      });

      test('props contains clipBehavior', () {
        const modifier = ClipTriangleModifier(clipBehavior: clipBehavior);

        expect(modifier.props, [clipBehavior]);
      });
    });

    group('build', () {
      testWidgets('creates ClipPath widget with TriangleClipper', (
        WidgetTester tester,
      ) async {
        const modifier = ClipTriangleModifier(clipBehavior: clipBehavior);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
        expect(clipPath.clipper, isA<TriangleClipper>());
        expect(clipPath.clipBehavior, clipBehavior);
        expect(clipPath.child, same(child));
      });
    });
  });

  group('ClipTriangleModifierMix', () {
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    group('Constructor', () {
      test('creates with null clipBehavior by default', () {
        final attribute = ClipTriangleModifierMix();

        expect(attribute.clipBehavior, isNull);
      });
    });

    group('only constructor', () {
      test('creates from direct value', () {
        final attribute = ClipTriangleModifierMix(
          clipBehavior: clipBehavior,
        );

        expect(attribute.clipBehavior, resolvesTo(clipBehavior));
      });

      test('handles null values correctly', () {
        final attribute = ClipTriangleModifierMix();

        expect(attribute.clipBehavior, isNull);
      });
    });

    group('resolve', () {
      test('resolves to ClipTriangleModifier with resolved values', () {
        final attribute = ClipTriangleModifierMix(
          clipBehavior: clipBehavior,
        );

        const expectedModifier = ClipTriangleModifier(
          clipBehavior: clipBehavior,
        );
        expect(attribute, resolvesTo(expectedModifier));
      });
    });

    group('merge', () {
      test('merges with other ClipTriangleModifierMix', () {
        final attribute1 = ClipTriangleModifierMix(
          clipBehavior: clipBehavior,
        );
        final attribute2 = ClipTriangleModifierMix(
          clipBehavior: clipBehavior2,
        );

        final merged = attribute1.merge(attribute2);

        expect(merged.clipBehavior, resolvesTo(clipBehavior2));
      });

      test('returns original when other is null', () {
        final attribute = ClipTriangleModifierMix(
          clipBehavior: clipBehavior,
        );

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });
    });

    group('equality and props', () {
      test('equal when all values match', () {
        final attribute1 = ClipTriangleModifierMix(
          clipBehavior: clipBehavior,
        );
        final attribute2 = ClipTriangleModifierMix(
          clipBehavior: clipBehavior,
        );

        expect(attribute1, equals(attribute2));
      });

      test('props contains clipBehavior', () {
        final attribute = ClipTriangleModifierMix(
          clipBehavior: clipBehavior,
        );

        final props = attribute.props;
        expect(props.length, 1);
        expect(props[0], attribute.clipBehavior);
      });
    });
  });

  group('Integration tests', () {
    const clipper = _PathClipper();
    const clipBehavior = Clip.antiAlias;

    testWidgets('ClipPathModifierMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = ClipPathModifierMix(
        clipper: clipper,
        clipBehavior: clipBehavior,
      );

      const expectedModifier = ClipPathModifier(
        clipper: clipper,
        clipBehavior: clipBehavior,
      );
      expect(attribute, resolvesTo(expectedModifier));

      final modifier = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 100);

      await tester.pumpWidget(modifier.build(child));

      final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
      expect(clipPath.clipper, clipper);
      expect(clipPath.clipBehavior, clipBehavior);
      expect(clipPath.child, same(child));
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      const clipper3 = _PathClipper();

      final base = ClipPathModifierMix(
        clipper: clipper,
        clipBehavior: clipBehavior,
      );

      final override1 = ClipPathModifierMix(
        clipBehavior: Clip.antiAliasWithSaveLayer,
      );

      final override2 = ClipPathModifierMix(clipper: clipper3);

      final result = base.merge(override1).merge(override2);

      expect(result.clipper, resolvesTo(clipper3));
      expect(result.clipBehavior, resolvesTo(Clip.antiAliasWithSaveLayer));
    });

    test('Lerp produces expected values', () {
      const start = ClipPathModifier(clipper: clipper);
      const end = ClipPathModifier(clipper: _OtherPathClipper());

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      // For non-interpolable values like clipper, t < 0.5 uses start, t >= 0.5 uses end
      expect(quarter.clipper, isA<_PathClipper>());
      expect(half.clipper, isA<_OtherPathClipper>());
      expect(threeQuarter.clipper, isA<_OtherPathClipper>());
    });
  });
}

class _PathClipper extends CustomClipper<Path> {
  const _PathClipper();
  @override
  Path getClip(Size size) {
    return Path();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _OtherPathClipper extends _PathClipper {
  const _OtherPathClipper();
}