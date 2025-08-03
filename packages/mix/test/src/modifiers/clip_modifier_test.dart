import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('ClipPathWidgetDecorator', () {
    const clipper = _PathClipper();
    const clipper2 = _OtherPathClipper();
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    group('Constructor', () {
      test('creates with null values by default', () {
        const modifier = ClipPathWidgetDecorator();

        expect(modifier.clipper, isNull);
        expect(modifier.clipBehavior, isNull);
      });

      test('assigns all parameters correctly', () {
        const modifier = ClipPathWidgetDecorator(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        expect(modifier.clipper, clipper);
        expect(modifier.clipBehavior, clipBehavior);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = ClipPathWidgetDecorator(
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
        const original = ClipPathWidgetDecorator(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        final updated = original.copyWith();

        expect(updated.clipper, original.clipper);
        expect(updated.clipBehavior, original.clipBehavior);
        expect(updated, isNot(same(original)));
      });

      test('allows partial updates', () {
        const original = ClipPathWidgetDecorator(
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
        const start = ClipPathWidgetDecorator(clipper: clipper);
        const end = ClipPathWidgetDecorator(clipper: clipper2);
        final result = start.lerp(end, 0.5);

        expect(result.clipper, clipper2);
      });

      test('interpolates clipBehavior correctly', () {
        const start = ClipPathWidgetDecorator(clipBehavior: clipBehavior);
        const end = ClipPathWidgetDecorator(clipBehavior: clipBehavior2);
        final result = start.lerp(end, 0.5);

        expect(result.clipBehavior, clipBehavior2);
      });

      test('handles null other parameter', () {
        const start = ClipPathWidgetDecorator(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles extreme t values', () {
        const start = ClipPathWidgetDecorator(clipper: clipper);
        const end = ClipPathWidgetDecorator(clipper: clipper2);

        final result0 = start.lerp(end, 0.0);
        expect(result0.clipper, clipper);

        final result1 = start.lerp(end, 1.0);
        expect(result1.clipper, clipper2);
      });
    });

    group('equality and hashCode', () {
      test('equal when all properties match', () {
        const modifier1 = ClipPathWidgetDecorator(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );
        const modifier2 = ClipPathWidgetDecorator(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when clipper differs', () {
        const modifier1 = ClipPathWidgetDecorator(clipper: clipper);
        const modifier2 = ClipPathWidgetDecorator(clipper: clipper2);

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('not equal when clipBehavior differs', () {
        const modifier1 = ClipPathWidgetDecorator(clipBehavior: clipBehavior);
        const modifier2 = ClipPathWidgetDecorator(clipBehavior: clipBehavior2);

        expect(modifier1, isNot(equals(modifier2)));
      });
    });

    group('props', () {
      test('contains all properties', () {
        const modifier = ClipPathWidgetDecorator(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        expect(modifier.props, [clipper, clipBehavior]);
      });

      test('contains null values', () {
        const modifier = ClipPathWidgetDecorator();

        expect(modifier.props, [null, null]);
      });
    });

    group('build', () {
      testWidgets('creates ClipPath widget with correct properties', (
        WidgetTester tester,
      ) async {
        const modifier = ClipPathWidgetDecorator(
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
        const modifier = ClipPathWidgetDecorator();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
        expect(clipPath.clipper, isNull);
        expect(clipPath.clipBehavior, Clip.antiAlias);
        expect(clipPath.child, same(child));
      });
    });
  });

  group('ClipPathWidgetDecoratorMix', () {
    const clipper = _PathClipper();
    const clipper2 = _OtherPathClipper();
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    group('Constructor', () {
      test('creates with null values by default', () {
        final attribute = ClipPathWidgetDecoratorMix();

        expect(attribute.clipper, isNull);
        expect(attribute.clipBehavior, isNull);
      });
    });

    group('only constructor', () {
      test('creates from direct values', () {
        final attribute = ClipPathWidgetDecoratorMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        expectProp(attribute.clipper, clipper);
        expectProp(attribute.clipBehavior, clipBehavior);
      });

      test('handles null values correctly', () {
        final attribute = ClipPathWidgetDecoratorMix();

        expect(attribute.clipper, isNull);
        expect(attribute.clipBehavior, isNull);
      });

      test('handles partial values', () {
        final attribute1 = ClipPathWidgetDecoratorMix(clipper: clipper);
        expectProp(attribute1.clipper, clipper);
        expect(attribute1.clipBehavior, isNull);

        final attribute2 = ClipPathWidgetDecoratorMix(
          clipBehavior: clipBehavior,
        );
        expect(attribute2.clipper, isNull);
        expectProp(attribute2.clipBehavior, clipBehavior);
      });
    });

    group('resolve', () {
      test('resolves to ClipPathWidgetDecorator with resolved values', () {
        final attribute = ClipPathWidgetDecoratorMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        const expectedModifier = ClipPathWidgetDecorator(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );
        expect(attribute, resolvesTo(expectedModifier));
      });

      test('resolves with null values', () {
        final attribute = ClipPathWidgetDecoratorMix();

        const expectedModifier = ClipPathWidgetDecorator();
        expect(attribute, resolvesTo(expectedModifier));
      });
    });

    group('merge', () {
      test('merges with other ClipPathWidgetDecoratorMix', () {
        final attribute1 = ClipPathWidgetDecoratorMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );
        final attribute2 = ClipPathWidgetDecoratorMix(
          clipper: clipper2,
          clipBehavior: clipBehavior2,
        );

        final merged = attribute1.merge(attribute2);

        expectProp(merged.clipper, clipper2); // overridden
        expectProp(merged.clipBehavior, clipBehavior2); // overridden
      });

      test('returns original when other is null', () {
        final attribute = ClipPathWidgetDecoratorMix(clipper: clipper);

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = ClipPathWidgetDecoratorMix();
        final attribute2 = ClipPathWidgetDecoratorMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        final merged = attribute1.merge(attribute2);

        expectProp(merged.clipper, clipper);
        expectProp(merged.clipBehavior, clipBehavior);
      });
    });

    group('equality and props', () {
      test('equal when all values match', () {
        final attribute1 = ClipPathWidgetDecoratorMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );
        final attribute2 = ClipPathWidgetDecoratorMix(
          clipper: clipper,
          clipBehavior: clipBehavior,
        );

        expect(attribute1, equals(attribute2));
      });

      test('not equal when values differ', () {
        final attribute1 = ClipPathWidgetDecoratorMix(clipper: clipper);
        final attribute2 = ClipPathWidgetDecoratorMix(clipper: clipper2);

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains all values', () {
        final attribute = ClipPathWidgetDecoratorMix(
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

  group('ClipTriangleWidgetDecorator', () {
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    group('Constructor', () {
      test('creates with default clip behavior', () {
        const modifier = ClipTriangleWidgetDecorator();

        expect(modifier.clipBehavior, isNull);
      });

      test('assigns clipBehavior correctly', () {
        const modifier = ClipTriangleWidgetDecorator(clipBehavior: clipBehavior);

        expect(modifier.clipBehavior, clipBehavior);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = ClipTriangleWidgetDecorator(clipBehavior: clipBehavior);

        final updated = original.copyWith(clipBehavior: clipBehavior2);

        expect(updated.clipBehavior, clipBehavior2);
        expect(updated, isNot(same(original)));
      });
    });

    group('lerp', () {
      test('interpolates clipBehavior correctly', () {
        const start = ClipTriangleWidgetDecorator(clipBehavior: clipBehavior);
        const end = ClipTriangleWidgetDecorator(clipBehavior: clipBehavior2);
        final result = start.lerp(end, 0.5);

        expect(result.clipBehavior, clipBehavior2);
      });
    });

    group('equality and props', () {
      test('equal when all properties match', () {
        const modifier1 = ClipTriangleWidgetDecorator(clipBehavior: clipBehavior);
        const modifier2 = ClipTriangleWidgetDecorator(clipBehavior: clipBehavior);

        expect(modifier1, equals(modifier2));
      });

      test('props contains clipBehavior', () {
        const modifier = ClipTriangleWidgetDecorator(clipBehavior: clipBehavior);

        expect(modifier.props, [clipBehavior]);
      });
    });

    group('build', () {
      testWidgets('creates ClipPath widget with TriangleClipper', (
        WidgetTester tester,
      ) async {
        const modifier = ClipTriangleWidgetDecorator(clipBehavior: clipBehavior);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
        expect(clipPath.clipper, isA<TriangleClipper>());
        expect(clipPath.clipBehavior, clipBehavior);
        expect(clipPath.child, same(child));
      });
    });
  });

  group('ClipTriangleWidgetDecoratorMix', () {
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    group('Constructor', () {
      test('creates with null clipBehavior by default', () {
        final attribute = ClipTriangleWidgetDecoratorMix();

        expect(attribute.clipBehavior, isNull);
      });
    });

    group('only constructor', () {
      test('creates from direct value', () {
        final attribute = ClipTriangleWidgetDecoratorMix(
          clipBehavior: clipBehavior,
        );

        expectProp(attribute.clipBehavior, clipBehavior);
      });

      test('handles null values correctly', () {
        final attribute = ClipTriangleWidgetDecoratorMix();

        expect(attribute.clipBehavior, isNull);
      });
    });

    group('resolve', () {
      test('resolves to ClipTriangleWidgetDecorator with resolved values', () {
        final attribute = ClipTriangleWidgetDecoratorMix(
          clipBehavior: clipBehavior,
        );

        const expectedModifier = ClipTriangleWidgetDecorator(
          clipBehavior: clipBehavior,
        );
        expect(attribute, resolvesTo(expectedModifier));
      });
    });

    group('merge', () {
      test('merges with other ClipTriangleWidgetDecoratorMix', () {
        final attribute1 = ClipTriangleWidgetDecoratorMix(
          clipBehavior: clipBehavior,
        );
        final attribute2 = ClipTriangleWidgetDecoratorMix(
          clipBehavior: clipBehavior2,
        );

        final merged = attribute1.merge(attribute2);

        expectProp(merged.clipBehavior, clipBehavior2);
      });

      test('returns original when other is null', () {
        final attribute = ClipTriangleWidgetDecoratorMix(
          clipBehavior: clipBehavior,
        );

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });
    });

    group('equality and props', () {
      test('equal when all values match', () {
        final attribute1 = ClipTriangleWidgetDecoratorMix(
          clipBehavior: clipBehavior,
        );
        final attribute2 = ClipTriangleWidgetDecoratorMix(
          clipBehavior: clipBehavior,
        );

        expect(attribute1, equals(attribute2));
      });

      test('props contains clipBehavior', () {
        final attribute = ClipTriangleWidgetDecoratorMix(
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

    testWidgets('ClipPathWidgetDecoratorMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = ClipPathWidgetDecoratorMix(
        clipper: clipper,
        clipBehavior: clipBehavior,
      );

      const expectedModifier = ClipPathWidgetDecorator(
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

      final base = ClipPathWidgetDecoratorMix(
        clipper: clipper,
        clipBehavior: clipBehavior,
      );

      final override1 = ClipPathWidgetDecoratorMix(
        clipBehavior: Clip.antiAliasWithSaveLayer,
      );

      final override2 = ClipPathWidgetDecoratorMix(clipper: clipper3);

      final result = base.merge(override1).merge(override2);

      expectProp(result.clipper, clipper3);
      expectProp(result.clipBehavior, Clip.antiAliasWithSaveLayer);
    });

    test('Lerp produces expected values', () {
      const start = ClipPathWidgetDecorator(clipper: clipper);
      const end = ClipPathWidgetDecorator(clipper: _OtherPathClipper());

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
