import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';
import 'package:mix/src/properties/layout/constraints_mix.dart';

void main() {
  group('BoxConstraintsMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final constraintsMix = BoxConstraintsMix(
          minWidth: 50.0,
          maxWidth: 150.0,
          minHeight: 100.0,
          maxHeight: 200.0,
        );

        expectProp(constraintsMix.$minWidth, 50.0);
        expectProp(constraintsMix.$maxWidth, 150.0);
        expectProp(constraintsMix.$minHeight, 100.0);
        expectProp(constraintsMix.$maxHeight, 200.0);
      });

      test('value constructor extracts properties from BoxConstraints', () {
        const constraints = BoxConstraints(
          minWidth: 25.0,
          maxWidth: 125.0,
          minHeight: 75.0,
          maxHeight: 175.0,
        );

        final constraintsMix = BoxConstraintsMix.value(constraints);

        expectProp(constraintsMix.$minWidth, 25.0);
        expectProp(constraintsMix.$maxWidth, 125.0);
        expectProp(constraintsMix.$minHeight, 75.0);
        expectProp(constraintsMix.$maxHeight, 175.0);
      });

      test('maybeValue returns null for null input', () {
        final result = BoxConstraintsMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns BoxConstraintsMix for non-null input', () {
        const constraints = BoxConstraints(minWidth: 10.0);
        final result = BoxConstraintsMix.maybeValue(constraints);

        expect(result, isNotNull);
        expectProp(result!.$minWidth, 10.0);
      });

      test('named constructors work correctly', () {
        final minWidthMix = BoxConstraintsMix.minWidth(50.0);
        expectProp(minWidthMix.$minWidth, 50.0);
        expect(minWidthMix.$maxWidth, isNull);

        final maxWidthMix = BoxConstraintsMix.maxWidth(150.0);
        expectProp(maxWidthMix.$maxWidth, 150.0);
        expect(maxWidthMix.$minWidth, isNull);

        final minHeightMix = BoxConstraintsMix.minHeight(100.0);
        expectProp(minHeightMix.$minHeight, 100.0);
        expect(minHeightMix.$maxHeight, isNull);

        final maxHeightMix = BoxConstraintsMix.maxHeight(200.0);
        expectProp(maxHeightMix.$maxHeight, 200.0);
        expect(maxHeightMix.$minHeight, isNull);
      });
    });

    group('resolve', () {
      test('resolves to BoxConstraints with correct properties', () {
        final constraintsMix = BoxConstraintsMix(
          minWidth: 50.0,
          maxWidth: 150.0,
          minHeight: 100.0,
          maxHeight: 200.0,
        );

        const resolvedValue = BoxConstraints(
          minWidth: 50.0,
          maxWidth: 150.0,
          minHeight: 100.0,
          maxHeight: 200.0,
        );

        expect(constraintsMix, resolvesTo(resolvedValue));
      });

      test('uses default values for null properties', () {
        final constraintsMix = BoxConstraintsMix(
          minWidth: 50.0,
          minHeight: 100.0,
        );

        const resolvedValue = BoxConstraints(
          minWidth: 50.0,
          maxWidth: double.infinity,
          minHeight: 100.0,
          maxHeight: double.infinity,
        );

        expect(constraintsMix, resolvesTo(resolvedValue));
      });

      test('handles infinity and zero values correctly', () {
        final constraintsMix = BoxConstraintsMix(
          minWidth: 0.0,
          maxWidth: double.infinity,
          minHeight: 0.0,
          maxHeight: double.infinity,
        );

        const resolvedValue = BoxConstraints(
          minWidth: 0.0,
          maxWidth: double.infinity,
          minHeight: 0.0,
          maxHeight: double.infinity,
        );

        expect(constraintsMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final constraintsMix = BoxConstraintsMix(minWidth: 50.0);
        final merged = constraintsMix.merge(null);

        expect(merged, same(constraintsMix));
      });

      test('merges properties correctly', () {
        final first = BoxConstraintsMix(
          minWidth: 50.0,
          maxWidth: 150.0,
          minHeight: 100.0,
        );

        final second = BoxConstraintsMix(
          maxWidth: 200.0,
          maxHeight: 250.0,
        );

        final merged = first.merge(second);

        expectProp(merged.$minWidth, 50.0);
        expectProp(merged.$maxWidth, 200.0);
        expectProp(merged.$minHeight, 100.0);
        expectProp(merged.$maxHeight, 250.0);
      });

      test('merges named constructor results correctly', () {
        final width = BoxConstraintsMix.minWidth(100.0);
        final height = BoxConstraintsMix.maxHeight(200.0);
        final merged = width.merge(height);

        expectProp(merged.$minWidth, 100.0);
        expectProp(merged.$maxHeight, 200.0);
        expect(merged.$maxWidth, isNull);
        expect(merged.$minHeight, isNull);
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final constraintsMix1 = BoxConstraintsMix(
          minWidth: 50.0,
          maxWidth: 150.0,
        );

        final constraintsMix2 = BoxConstraintsMix(
          minWidth: 50.0,
          maxWidth: 150.0,
        );

        expect(constraintsMix1, constraintsMix2);
        expect(constraintsMix1.hashCode, constraintsMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final constraintsMix1 = BoxConstraintsMix(minWidth: 50.0);
        final constraintsMix2 = BoxConstraintsMix(minWidth: 100.0);

        expect(constraintsMix1, isNot(constraintsMix2));
      });
    });
  });
}
