import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('BoxConstraintsMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final constraintsMix = BoxConstraintsMix.only(
          minWidth: 50.0,
          maxWidth: 150.0,
          minHeight: 100.0,
          maxHeight: 200.0,
        );

        expect(constraintsMix.minWidth, isProp(50.0));
        expect(constraintsMix.maxWidth, isProp(150.0));
        expect(constraintsMix.minHeight, isProp(100.0));
        expect(constraintsMix.maxHeight, isProp(200.0));
      });

      test('value constructor extracts properties from BoxConstraints', () {
        const constraints = BoxConstraints(
          minWidth: 25.0,
          maxWidth: 125.0,
          minHeight: 75.0,
          maxHeight: 175.0,
        );

        final constraintsMix = BoxConstraintsMix.value(constraints);

        expect(constraintsMix.minWidth, isProp(25.0));
        expect(constraintsMix.maxWidth, isProp(125.0));
        expect(constraintsMix.minHeight, isProp(75.0));
        expect(constraintsMix.maxHeight, isProp(175.0));
      });

      test('maybeValue returns null for null input', () {
        final result = BoxConstraintsMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns BoxConstraintsMix for non-null input', () {
        const constraints = BoxConstraints(minWidth: 10.0);
        final result = BoxConstraintsMix.maybeValue(constraints);

        expect(result, isNotNull);
        expect(result!.minWidth, isProp(10.0));
      });

      test('named constructors work correctly', () {
        final minWidthMix = BoxConstraintsMix.minWidth(50.0);
        expect(minWidthMix.minWidth, isProp(50.0));
        expect(minWidthMix.maxWidth, isNull);

        final maxWidthMix = BoxConstraintsMix.maxWidth(150.0);
        expect(maxWidthMix.maxWidth, isProp(150.0));
        expect(maxWidthMix.minWidth, isNull);

        final minHeightMix = BoxConstraintsMix.minHeight(100.0);
        expect(minHeightMix.minHeight, isProp(100.0));
        expect(minHeightMix.maxHeight, isNull);

        final maxHeightMix = BoxConstraintsMix.maxHeight(200.0);
        expect(maxHeightMix.maxHeight, isProp(200.0));
        expect(maxHeightMix.minHeight, isNull);
      });
    });

    group('resolve', () {
      test('resolves to BoxConstraints with correct properties', () {
        final constraintsMix = BoxConstraintsMix.only(
          minWidth: 50.0,
          maxWidth: 150.0,
          minHeight: 100.0,
          maxHeight: 200.0,
        );

        final context = MockBuildContext();
        final resolved = constraintsMix.resolve(context);

        expect(resolved.minWidth, 50.0);
        expect(resolved.maxWidth, 150.0);
        expect(resolved.minHeight, 100.0);
        expect(resolved.maxHeight, 200.0);
      });

      test('uses default values for null properties', () {
        final constraintsMix = BoxConstraintsMix.only(
          minWidth: 50.0,
          minHeight: 100.0,
        );

        final context = MockBuildContext();
        final resolved = constraintsMix.resolve(context);

        expect(resolved.minWidth, 50.0);
        expect(resolved.maxWidth, double.infinity);
        expect(resolved.minHeight, 100.0);
        expect(resolved.maxHeight, double.infinity);
      });

      test('handles infinity and zero values correctly', () {
        final constraintsMix = BoxConstraintsMix.only(
          minWidth: 0.0,
          maxWidth: double.infinity,
          minHeight: 0.0,
          maxHeight: double.infinity,
        );

        final context = MockBuildContext();
        final resolved = constraintsMix.resolve(context);

        expect(resolved.minWidth, 0.0);
        expect(resolved.maxWidth, double.infinity);
        expect(resolved.minHeight, 0.0);
        expect(resolved.maxHeight, double.infinity);
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final constraintsMix = BoxConstraintsMix.only(minWidth: 50.0);
        final merged = constraintsMix.merge(null);

        expect(merged, same(constraintsMix));
      });

      test('merges properties correctly', () {
        final first = BoxConstraintsMix.only(
          minWidth: 50.0,
          maxWidth: 150.0,
          minHeight: 100.0,
        );

        final second = BoxConstraintsMix.only(
          maxWidth: 200.0,
          maxHeight: 250.0,
        );

        final merged = first.merge(second);

        expect(merged.minWidth, isProp(50.0));
        expect(merged.maxWidth, isProp(200.0));
        expect(merged.minHeight, isProp(100.0));
        expect(merged.maxHeight, isProp(250.0));
      });

      test('merges named constructor results correctly', () {
        final width = BoxConstraintsMix.minWidth(100.0);
        final height = BoxConstraintsMix.maxHeight(200.0);
        final merged = width.merge(height);

        expect(merged.minWidth, isProp(100.0));
        expect(merged.maxHeight, isProp(200.0));
        expect(merged.maxWidth, isNull);
        expect(merged.minHeight, isNull);
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final constraintsMix1 = BoxConstraintsMix.only(
          minWidth: 50.0,
          maxWidth: 150.0,
        );

        final constraintsMix2 = BoxConstraintsMix.only(
          minWidth: 50.0,
          maxWidth: 150.0,
        );

        expect(constraintsMix1, constraintsMix2);
        expect(constraintsMix1.hashCode, constraintsMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final constraintsMix1 = BoxConstraintsMix.only(minWidth: 50.0);
        final constraintsMix2 = BoxConstraintsMix.only(minWidth: 100.0);

        expect(constraintsMix1, isNot(constraintsMix2));
      });
    });
  });
}
