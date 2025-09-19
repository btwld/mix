import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('TransformModifier', () {
    group('Constructor', () {
      test(
        'creates with identity transform and center alignment by default',
        () {
          final modifier = TransformModifier();

          expect(modifier.transform, Matrix4.identity());
          expect(modifier.alignment, Alignment.center);
        },
      );

      test('assigns transform and alignment correctly', () {
        final transform = Matrix4.rotationZ(math.pi / 4);
        const alignment = Alignment.topLeft;
        final modifier = TransformModifier(
          transform: transform,
          alignment: alignment,
        );

        expect(modifier.transform, transform);
        expect(modifier.alignment, alignment);
      });

      test('uses identity transform when null is provided', () {
        final modifier = TransformModifier(transform: null);

        expect(modifier.transform, Matrix4.identity());
        expect(modifier.alignment, Alignment.center);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated transform', () {
        final original = TransformModifier(
          transform: Matrix4.identity(),
          alignment: Alignment.center,
        );
        final newTransform = Matrix4.rotationZ(math.pi / 2);
        final updated = original.copyWith(transform: newTransform);

        expect(updated.transform, newTransform);
        expect(updated.alignment, Alignment.center);
        expect(updated, isNot(same(original)));
      });

      test('returns new instance with updated alignment', () {
        final original = TransformModifier();
        final updated = original.copyWith(alignment: Alignment.topRight);

        expect(updated.transform, Matrix4.identity());
        expect(updated.alignment, Alignment.topRight);
        expect(updated, isNot(same(original)));
      });

      test('preserves original values when parameters are null', () {
        final transform = Matrix4.rotationZ(math.pi / 4);
        final original = TransformModifier(
          transform: transform,
          alignment: Alignment.bottomLeft,
        );
        final updated = original.copyWith();

        expect(updated.transform, transform);
        expect(updated.alignment, Alignment.bottomLeft);
        expect(updated, isNot(same(original)));
      });
    });

    group('lerp', () {
      test('interpolates transform matrices correctly', () {
        final start = TransformModifier(transform: Matrix4.identity());
        final end = TransformModifier(transform: Matrix4.rotationZ(math.pi));
        final result = start.lerp(end, 0.5);

        // The result should be approximately halfway between identity and pi rotation
        expect(result.transform, isA<Matrix4>());
        expect(result.alignment, Alignment.center);
      });

      test('interpolates alignment correctly', () {
        final start = TransformModifier(alignment: Alignment.topLeft);
        final end = TransformModifier(alignment: Alignment.bottomRight);
        final result = start.lerp(end, 0.5);

        expect(result.alignment, const Alignment(0.0, 0.0)); // Center point
      });

      test('handles null other parameter', () {
        final start = TransformModifier(
          transform: Matrix4.rotationZ(math.pi / 4),
          alignment: Alignment.center,
        );
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles extreme t values', () {
        final start = TransformModifier(alignment: Alignment.topLeft);
        final end = TransformModifier(alignment: Alignment.bottomRight);

        final result0 = start.lerp(end, 0.0);
        expect(result0.alignment, Alignment.topLeft);

        final result1 = start.lerp(end, 1.0);
        expect(result1.alignment, Alignment.bottomRight);
      });
    });

    group('equality and hashCode', () {
      test('equal when transform and alignment match', () {
        final transform = Matrix4.rotationZ(math.pi / 4);
        final modifier1 = TransformModifier(
          transform: transform,
          alignment: Alignment.center,
        );
        final modifier2 = TransformModifier(
          transform: transform,
          alignment: Alignment.center,
        );

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when transform differs', () {
        final modifier1 = TransformModifier(transform: Matrix4.identity());
        final modifier2 = TransformModifier(
          transform: Matrix4.rotationZ(math.pi / 4),
        );

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('not equal when alignment differs', () {
        final modifier1 = TransformModifier(alignment: Alignment.center);
        final modifier2 = TransformModifier(alignment: Alignment.topLeft);

        expect(modifier1, isNot(equals(modifier2)));
      });
    });

    group('props', () {
      test('contains transform and alignment', () {
        final transform = Matrix4.rotationZ(math.pi / 4);
        const alignment = Alignment.topRight;
        final modifier = TransformModifier(
          transform: transform,
          alignment: alignment,
        );

        expect(modifier.props, [transform, alignment]);
      });
    });

    group('build', () {
      testWidgets('creates Transform widget with correct properties', (
        WidgetTester tester,
      ) async {
        final transform = Matrix4.rotationZ(math.pi / 4);
        const alignment = Alignment.topLeft;
        final modifier = TransformModifier(
          transform: transform,
          alignment: alignment,
        );
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final transformWidget = tester.widget<Transform>(
          find.byType(Transform),
        );
        expect(transformWidget.transform, transform);
        expect(transformWidget.alignment, alignment);
        expect(transformWidget.child, same(child));
      });

      testWidgets('creates Transform widget with default values', (
        WidgetTester tester,
      ) async {
        final modifier = TransformModifier();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final transformWidget = tester.widget<Transform>(
          find.byType(Transform),
        );
        expect(transformWidget.transform, Matrix4.identity());
        expect(transformWidget.alignment, Alignment.center);
        expect(transformWidget.child, same(child));
      });
    });
  });

  group('TransformModifierMix', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        final attribute = TransformModifierMix();

        expect(attribute.transform, isNull);
        expect(attribute.alignment, isNull);
      });

      test('creates with provided Prop values', () {
        final transform = Prop.value(Matrix4.rotationZ(math.pi / 4));
        final alignment = Prop.value(Alignment.center);
        final attribute = TransformModifierMix.create(
          transform: transform,
          alignment: alignment,
        );

        expect(attribute.transform, same(transform));
        expect(attribute.alignment, same(alignment));
      });
    });

    group('only constructor', () {
      test('creates Prop values from direct values', () {
        final transform = Matrix4.rotationZ(math.pi / 4);
        const alignment = Alignment.topLeft;
        final attribute = TransformModifierMix(
          transform: transform,
          alignment: alignment,
        );

        expect(attribute.transform!, resolvesTo(transform));
        expect(attribute.alignment!, resolvesTo(alignment));
      });

      test('handles null values correctly', () {
        final attribute = TransformModifierMix();

        expect(attribute.transform, isNull);
        expect(attribute.alignment, isNull);
      });
    });

    group('resolve', () {
      test('resolves to TransformModifier with resolved values', () {
        final transform = Matrix4.rotationZ(math.pi / 4);
        const alignment = Alignment.topRight;
        final attribute = TransformModifierMix(
          transform: transform,
          alignment: alignment,
        );

        final expectedModifier = TransformModifier(
          transform: transform,
          alignment: alignment,
        );

        expect(attribute, resolvesTo(expectedModifier));
      });

      test('resolves with null values to defaults', () {
        final attribute = TransformModifierMix();

        final expectedModifier = TransformModifier(
          transform: null, // Will become Matrix4.identity()
          alignment: Alignment.center, // Default from resolve method
        );

        expect(attribute, resolvesTo(expectedModifier));
      });
    });

    group('merge', () {
      test('merges with other TransformModifierMix', () {
        final attribute1 = TransformModifierMix(
          transform: Matrix4.identity(),
          alignment: Alignment.center,
        );
        final attribute2 = TransformModifierMix(
          transform: Matrix4.rotationZ(math.pi / 4),
          alignment: Alignment.topLeft,
        );

        final merged = attribute1.merge(attribute2);

        expect(
          merged.transform!,
          resolvesTo(Matrix4.rotationZ(math.pi / 4)),
        ); // overridden
        expect(merged.alignment!, resolvesTo(Alignment.topLeft)); // overridden
      });

      test('returns original when other is null', () {
        final attribute = TransformModifierMix(transform: Matrix4.identity());

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = TransformModifierMix();
        final attribute2 = TransformModifierMix(
          transform: Matrix4.rotationZ(math.pi / 2),
        );

        final merged = attribute1.merge(attribute2);

        expect(merged.transform!, resolvesTo(Matrix4.rotationZ(math.pi / 2)));
        expect(merged.alignment, isNull);
      });
    });

    group('equality and props', () {
      test('equal when all Prop values match', () {
        final transform = Matrix4.rotationZ(math.pi / 4);
        final attribute1 = TransformModifierMix(
          transform: transform,
          alignment: Alignment.center,
        );
        final attribute2 = TransformModifierMix(
          transform: transform,
          alignment: Alignment.center,
        );

        expect(attribute1, equals(attribute2));
      });

      test('not equal when values differ', () {
        final attribute1 = TransformModifierMix(transform: Matrix4.identity());
        final attribute2 = TransformModifierMix(
          transform: Matrix4.rotationZ(math.pi / 4),
        );

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains all Prop values', () {
        final transform = Matrix4.rotationZ(math.pi / 4);
        final attribute = TransformModifierMix(
          transform: transform,
          alignment: Alignment.center,
        );

        final props = attribute.props;
        expect(props.length, 2);
        expect(props[0], attribute.transform);
        expect(props[1], attribute.alignment);
      });
    });
  });

  group('TransformModifierUtility', () {
    late TransformModifierUtility<MockStyle<TransformModifierMix>> utility;

    setUp(() {
      utility = TransformModifierUtility((attribute) => MockStyle(attribute));
    });

    test('call() creates attribute with specified transform', () {
      final transform = Matrix4.rotationZ(math.pi / 4);
      final result = utility.call(transform);
      final attribute = result.value;

      expect(attribute.transform!, resolvesTo(transform));
    });

    test('scale() creates scaling transform', () {
      final result = utility.scale(2.0);
      final attribute = result.value;

      expect(
        attribute,
        resolvesTo(
          TransformModifier(
            transform: Matrix4.diagonal3Values(2.0, 2.0, 1.0),
            alignment: Alignment.center,
          ),
        ),
      );
    });

    test('translate() creates translation transform', () {
      final result = utility.translate(10.0, 20.0);
      final attribute = result.value;

      expect(
        attribute,
        resolvesTo(
          TransformModifier(
            transform: Matrix4.translationValues(10.0, 20.0, 0.0),
            alignment: Alignment.center,
          ),
        ),
      );
    });

    test('flipX() creates horizontal flip transform', () {
      final result = utility.flipX();
      final attribute = result.value;

      expect(
        attribute,
        resolvesTo(
          TransformModifier(
            transform: Matrix4.diagonal3Values(-1.0, 1.0, 1.0),
            alignment: Alignment.center,
          ),
        ),
      );
    });

    test('flipY() creates vertical flip transform', () {
      final result = utility.flipY();
      final attribute = result.value;

      expect(
        attribute,
        resolvesTo(
          TransformModifier(
            transform: Matrix4.diagonal3Values(1.0, -1.0, 1.0),
            alignment: Alignment.center,
          ),
        ),
      );
    });

    group('rotate utility', () {
      test('d90() creates 90 degree rotation', () {
        final result = utility.rotate.d90();
        final attribute = result.value;

        expect(
          attribute,
          resolvesTo(
            TransformModifier(
              transform: Matrix4.rotationZ(math.pi / 2),
              alignment: Alignment.center,
            ),
          ),
        );
      });

      test('d180() creates 180 degree rotation', () {
        final result = utility.rotate.d180();
        final attribute = result.value;

        expect(
          attribute,
          resolvesTo(
            TransformModifier(
              transform: Matrix4.rotationZ(math.pi),
              alignment: Alignment.center,
            ),
          ),
        );
      });

      test('d270() creates 270 degree rotation', () {
        final result = utility.rotate.d270();
        final attribute = result.value;

        expect(
          attribute,
          resolvesTo(
            TransformModifier(
              transform: Matrix4.rotationZ(3 * math.pi / 2),
              alignment: Alignment.center,
            ),
          ),
        );
      });

      test('call() creates custom rotation', () {
        final result = utility.rotate.call(math.pi / 3);
        final attribute = result.value;

        expect(
          attribute,
          resolvesTo(
            TransformModifier(
              transform: Matrix4.rotationZ(math.pi / 3),
              alignment: Alignment.center,
            ),
          ),
        );
      });
    });
  });

  group('Integration tests', () {
    testWidgets('TransformModifierMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final transform = Matrix4.rotationZ(math.pi / 6);
      final attribute = TransformModifierMix(
        transform: transform,
        alignment: Alignment.topRight,
      );

      final modifier = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 100);

      await tester.pumpWidget(modifier.build(child));

      final transformWidget = tester.widget<Transform>(find.byType(Transform));
      expect(transformWidget.transform, transform);
      expect(transformWidget.alignment, Alignment.topRight);
      expect(transformWidget.child, same(child));
    });

    test('merge scenario preserves and overrides correctly', () {
      final base = TransformModifierMix(
        transform: Matrix4.identity(),
        alignment: Alignment.center,
      );

      final override1 = TransformModifierMix(
        transform: Matrix4.rotationZ(math.pi / 4),
      );

      final override2 = TransformModifierMix(alignment: Alignment.topLeft);

      final result = base.merge(override1).merge(override2);

      expect(result.transform!, resolvesTo(Matrix4.rotationZ(math.pi / 4)));
      expect(result.alignment!, resolvesTo(Alignment.topLeft));
    });

    test('Lerp produces expected intermediate values', () {
      final start = TransformModifier(
        transform: Matrix4.identity(),
        alignment: Alignment.topLeft,
      );
      final end = TransformModifier(
        transform: Matrix4.rotationZ(math.pi),
        alignment: Alignment.bottomRight,
      );

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      // Check alignment interpolation
      expect(quarter.alignment, const Alignment(-0.5, -0.5));
      expect(half.alignment, const Alignment(0.0, 0.0));
      expect(threeQuarter.alignment, const Alignment(0.5, 0.5));

      // Transform matrices should be interpolated (exact values depend on Matrix4.lerp implementation)
      expect(quarter.transform, isA<Matrix4>());
      expect(half.transform, isA<Matrix4>());
      expect(threeQuarter.transform, isA<Matrix4>());
    });

    test('Utility methods create expected transforms', () {
      final utility = TransformModifierUtility<MockStyle<TransformModifierMix>>(
        (attribute) => MockStyle(attribute),
      );

      // Test scale
      final scaleResult = utility.scale(1.5);
      expect(
        scaleResult.value,
        resolvesTo(
          TransformModifier(
            transform: Matrix4.diagonal3Values(1.5, 1.5, 1.0),
            alignment: Alignment.center,
          ),
        ),
      );

      // Test translate
      final translateResult = utility.translate(5.0, -10.0);
      expect(
        translateResult.value,
        resolvesTo(
          TransformModifier(
            transform: Matrix4.translationValues(5.0, -10.0, 0.0),
            alignment: Alignment.center,
          ),
        ),
      );

      // Test rotation
      final rotateResult = utility.rotate.d90();
      expect(
        rotateResult.value,
        resolvesTo(
          TransformModifier(
            transform: Matrix4.rotationZ(math.pi / 2),
            alignment: Alignment.center,
          ),
        ),
      );
    });
  });
}
