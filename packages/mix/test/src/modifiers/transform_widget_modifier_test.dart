import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('TransformModifierSpec', () {
    test('lerp', () {
      final spec = TransformModifierSpec(transform: Matrix4.rotationX(0.5));
      final other = TransformModifierSpec(transform: Matrix4.rotationX(1.0));
      final result = spec.lerp(other, 0.5);
      expect(
          result.transform,
          Matrix4Tween(
            begin: Matrix4.rotationX(0.5),
            end: Matrix4.rotationX(1.0),
          ).lerp(0.5));
    });

    test('copyWith', () {
      final spec = TransformModifierSpec(transform: Matrix4.rotationX(0.5));
      final result = spec.copyWith(
        transform: Matrix4.rotationX(0.1),
      );
      expect(result, isA<TransformModifierSpec>());
      expect(result.transform, Matrix4.rotationX(0.1));
    });

    testWidgets('build', (tester) async {
      const modifier = TransformModifierSpec();

      await tester.pumpMaterialApp(modifier.build(Container()));

      final Transform transform = tester.widget(find.byType(Transform));

      expect(find.byType(Transform), findsOneWidget);

      expect(transform.child, isA<Container>());
    });

    // equality
    test('equality', () {
      final spec = TransformModifierSpec(transform: Matrix4.rotationX(0.5));
      final other = TransformModifierSpec(transform: Matrix4.rotationX(0.5));
      expect(spec, other);
    });

    test('inequality', () {
      final spec = TransformModifierSpec(transform: Matrix4.rotationX(0.5));
      final other = TransformModifierSpec(transform: Matrix4.rotationX(1.0));
      expect(spec, isNot(other));
    });
  });
  group(
    'TransformModifierSpecAttribute',
    () {
      test('merge', () {
        const modifier = TransformModifierSpecAttribute();
        const other = TransformModifierSpecAttribute();
        final result = modifier.merge(other);
        expect(result, modifier);
      });

      test('resolve', () {
        final modifier =
            TransformModifierSpecAttribute(transform: Matrix4.rotationX(0.5));
        expect(modifier, resolvesTo(
          TransformModifierSpec(transform: Matrix4.rotationX(0.5)),
        ));
      });

      // equality
      test('equality', () {
        final modifier =
            TransformModifierSpecAttribute(transform: Matrix4.rotationX(0.5));
        final other =
            TransformModifierSpecAttribute(transform: Matrix4.rotationX(0.5));
        expect(modifier, other);
      });

      test('merge with null', () {
        final modifier =
            TransformModifierSpecAttribute(transform: Matrix4.rotationX(0.5));
        final result = modifier.merge(null);
        expect(result, modifier);
      });

      test('equality', () {
        final modifier1 =
            TransformModifierSpecAttribute(transform: Matrix4.rotationX(0.5));
        final modifier2 =
            TransformModifierSpecAttribute(transform: Matrix4.rotationX(0.5));
        expect(modifier1, modifier2);
      });

      test('inequality', () {
        final modifier1 =
            TransformModifierSpecAttribute(transform: Matrix4.rotationX(0.5));
        final modifier2 =
            TransformModifierSpecAttribute(transform: Matrix4.rotationX(1.0));
        expect(modifier1, isNot(modifier2));
      });

      test('inequality', () {
        final modifier =
            TransformModifierSpecAttribute(transform: Matrix4.rotationX(0.5));
        final other =
            TransformModifierSpecAttribute(transform: Matrix4.rotationX(1.0));
        expect(modifier, isNot(equals(other)));
      });
    },
  );

  group('TransformUtility', () {
    test('call', () {
      final utility =
          TransformModifierSpecUtility<TransformModifierSpecAttribute>(
              (attr) => attr);
      final matrix = Matrix4.rotationX(0.5);
      final result = utility(matrix);
      expect(result.transform, matrix);
    });

    test('scale', () {
      final utility =
          TransformModifierSpecUtility<TransformModifierSpecAttribute>(
              (attr) => attr);
      final result = utility.scale(2.0);
      expect(result.transform, Matrix4.diagonal3Values(2.0, 2.0, 1.0));
      expect(result.alignment, Alignment.center);
    });

    test('rotate', () {
      final utility =
          TransformModifierSpecUtility<TransformModifierSpecAttribute>(
              (attr) => attr);
      final result = utility.rotate.d90();

      expect(result.transform, Matrix4.rotationZ(math.pi / 2));
      expect(result.alignment, Alignment.center);

      expect(result, resolvesTo(
        TransformModifierSpec(
          transform: Matrix4.rotationZ(math.pi / 2),
          alignment: Alignment.center,
        ),
      ));
    });

    test('translate', () {
      final utility =
          TransformModifierSpecUtility<TransformModifierSpecAttribute>(
              (attr) => attr);

      final result = utility.translate(10, 20);

      expect(result.transform, Matrix4.translationValues(10, 20, 0));
      expect(result.alignment, Alignment.center);

      expect(result, resolvesTo(
        TransformModifierSpec(
          transform: Matrix4.translationValues(10, 20, 0),
          alignment: Alignment.center,
        ),
      ));
    });
  });

  group('TransformRotateModifierSpecUtility', () {
    late TransformRotateModifierSpecUtility<TransformModifierSpecAttribute>
        utility;

    setUp(() {
      utility = TransformRotateModifierSpecUtility(
        (value) => TransformModifierSpecAttribute(
          transform: value,
          alignment: Alignment.center,
        ),
      );
    });

    test('d90 returns correct rotation', () {
      final result = utility.d90();
      expect(result.transform, Matrix4.rotationZ(math.pi / 2));
    });

    test('d180 returns correct rotation', () {
      final result = utility.d180();
      expect(result.transform, Matrix4.rotationZ(math.pi));
    });

    test('d270 returns correct rotation', () {
      final result = utility.d270();
      expect(result.transform, Matrix4.rotationZ(3 * math.pi / 2));
    });

    test('call with custom value returns correct rotation', () {
      final result = utility.call(math.pi / 4);
      expect(result.transform, Matrix4.rotationZ(math.pi / 4));
    });

    test('call with zero returns identity matrix', () {
      final result = utility.call(0);
      expect(result.transform, Matrix4.identity());
    });

    test('call with negative value returns correct rotation', () {
      final result = utility.call(-math.pi / 2);
      expect(result.transform, Matrix4.rotationZ(-math.pi / 2));
    });
  });
}
