import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/properties/layout/constraints_mix.dart';

import '../../../helpers/testing_utils.dart';

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

        expect(constraintsMix.$minWidth, resolvesTo(50.0));
        expect(constraintsMix.$maxWidth, resolvesTo(150.0));
        expect(constraintsMix.$minHeight, resolvesTo(100.0));
        expect(constraintsMix.$maxHeight, resolvesTo(200.0));
      });

      test('value constructor extracts properties from BoxConstraints', () {
        const constraints = BoxConstraints(
          minWidth: 25.0,
          maxWidth: 125.0,
          minHeight: 75.0,
          maxHeight: 175.0,
        );

        final constraintsMix = BoxConstraintsMix.value(constraints);

        expect(constraintsMix.$minWidth, resolvesTo(25.0));
        expect(constraintsMix.$maxWidth, resolvesTo(125.0));
        expect(constraintsMix.$minHeight, resolvesTo(75.0));
        expect(constraintsMix.$maxHeight, resolvesTo(175.0));
      });

      test('maybeValue returns null for null input', () {
        final result = BoxConstraintsMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns BoxConstraintsMix for non-null input', () {
        const constraints = BoxConstraints(minWidth: 10.0);
        final result = BoxConstraintsMix.maybeValue(constraints);

        expect(result, isNotNull);
        expect(result!.$minWidth, resolvesTo(10.0));
      });

      test('named constructors work correctly', () {
        final minWidthMix = BoxConstraintsMix.minWidth(50.0);
        expect(minWidthMix.$minWidth, resolvesTo(50.0));
        expect(minWidthMix.$maxWidth, isNull);

        final maxWidthMix = BoxConstraintsMix.maxWidth(150.0);
        expect(maxWidthMix.$maxWidth, resolvesTo(150.0));
        expect(maxWidthMix.$minWidth, isNull);

        final minHeightMix = BoxConstraintsMix.minHeight(100.0);
        expect(minHeightMix.$minHeight, resolvesTo(100.0));
        expect(minHeightMix.$maxHeight, isNull);

        final maxHeightMix = BoxConstraintsMix.maxHeight(200.0);
        expect(maxHeightMix.$maxHeight, resolvesTo(200.0));
        expect(maxHeightMix.$minHeight, isNull);
      });
    });

    group('Factory Constructors', () {
      test('minWidth factory creates BoxConstraintsMix with minWidth', () {
        final constraintsMix = BoxConstraintsMix.minWidth(100.0);

        expect(constraintsMix.$minWidth, resolvesTo(100.0));
        expect(constraintsMix.$maxWidth, isNull);
        expect(constraintsMix.$minHeight, isNull);
        expect(constraintsMix.$maxHeight, isNull);
      });

      test('maxWidth factory creates BoxConstraintsMix with maxWidth', () {
        final constraintsMix = BoxConstraintsMix.maxWidth(200.0);

        expect(constraintsMix.$maxWidth, resolvesTo(200.0));
        expect(constraintsMix.$minWidth, isNull);
        expect(constraintsMix.$minHeight, isNull);
        expect(constraintsMix.$maxHeight, isNull);
      });

      test('minHeight factory creates BoxConstraintsMix with minHeight', () {
        final constraintsMix = BoxConstraintsMix.minHeight(150.0);

        expect(constraintsMix.$minHeight, resolvesTo(150.0));
        expect(constraintsMix.$minWidth, isNull);
        expect(constraintsMix.$maxWidth, isNull);
        expect(constraintsMix.$maxHeight, isNull);
      });

      test('maxHeight factory creates BoxConstraintsMix with maxHeight', () {
        final constraintsMix = BoxConstraintsMix.maxHeight(250.0);

        expect(constraintsMix.$maxHeight, resolvesTo(250.0));
        expect(constraintsMix.$minWidth, isNull);
        expect(constraintsMix.$maxWidth, isNull);
        expect(constraintsMix.$minHeight, isNull);
      });

      test('width factory creates BoxConstraintsMix with fixed width', () {
        final constraintsMix = BoxConstraintsMix.width(120.0);

        expect(constraintsMix.$minWidth, resolvesTo(120.0));
        expect(constraintsMix.$maxWidth, resolvesTo(120.0));
        expect(constraintsMix.$minHeight, isNull);
        expect(constraintsMix.$maxHeight, isNull);
      });

      test('height factory creates BoxConstraintsMix with fixed height', () {
        final constraintsMix = BoxConstraintsMix.height(180.0);

        expect(constraintsMix.$minHeight, resolvesTo(180.0));
        expect(constraintsMix.$maxHeight, resolvesTo(180.0));
        expect(constraintsMix.$minWidth, isNull);
        expect(constraintsMix.$maxWidth, isNull);
      });

      test('size factory creates BoxConstraintsMix with fixed size', () {
        final constraintsMix = BoxConstraintsMix.size(const Size(100.0, 200.0));

        expect(constraintsMix.$minWidth, resolvesTo(100.0));
        expect(constraintsMix.$maxWidth, resolvesTo(100.0));
        expect(constraintsMix.$minHeight, resolvesTo(200.0));
        expect(constraintsMix.$maxHeight, resolvesTo(200.0));
      });
    });

    group('Utility Methods', () {
      test('minWidth utility works correctly', () {
        final constraintsMix = BoxConstraintsMix().minWidth(80.0);

        expect(constraintsMix.$minWidth, resolvesTo(80.0));
      });

      test('maxWidth utility works correctly', () {
        final constraintsMix = BoxConstraintsMix().maxWidth(160.0);

        expect(constraintsMix.$maxWidth, resolvesTo(160.0));
      });

      test('minHeight utility works correctly', () {
        final constraintsMix = BoxConstraintsMix().minHeight(90.0);

        expect(constraintsMix.$minHeight, resolvesTo(90.0));
      });

      test('maxHeight utility works correctly', () {
        final constraintsMix = BoxConstraintsMix().maxHeight(180.0);

        expect(constraintsMix.$maxHeight, resolvesTo(180.0));
      });

      test('width utility works correctly', () {
        final constraintsMix = BoxConstraintsMix().width(100.0);

        expect(constraintsMix.$minWidth, resolvesTo(100.0));
        expect(constraintsMix.$maxWidth, resolvesTo(100.0));
      });

      test('height utility works correctly', () {
        final constraintsMix = BoxConstraintsMix().height(150.0);

        expect(constraintsMix.$minHeight, resolvesTo(150.0));
        expect(constraintsMix.$maxHeight, resolvesTo(150.0));
      });

      test('width utility merges correctly with existing properties', () {
        final initial = BoxConstraintsMix(minHeight: 50.0, maxHeight: 100.0);
        final result = initial.width(75.0);

        expect(result.$minWidth, resolvesTo(75.0));
        expect(result.$maxWidth, resolvesTo(75.0));
        expect(result.$minHeight, resolvesTo(50.0)); // Should preserve existing
        expect(
          result.$maxHeight,
          resolvesTo(100.0),
        ); // Should preserve existing
      });

      test('height utility merges correctly with existing properties', () {
        final initial = BoxConstraintsMix(minWidth: 50.0, maxWidth: 100.0);
        final result = initial.height(75.0);

        expect(result.$minHeight, resolvesTo(75.0));
        expect(result.$maxHeight, resolvesTo(75.0));
        expect(result.$minWidth, resolvesTo(50.0)); // Should preserve existing
        expect(result.$maxWidth, resolvesTo(100.0)); // Should preserve existing
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
      test('returns equivalent instance when other is null', () {
        final constraintsMix = BoxConstraintsMix(minWidth: 50.0);
        final merged = constraintsMix.merge(null);

        expect(identical(merged, constraintsMix), isFalse);
        expect(merged, equals(constraintsMix));
      });

      test('merges properties correctly', () {
        final first = BoxConstraintsMix(
          minWidth: 50.0,
          maxWidth: 150.0,
          minHeight: 100.0,
        );

        final second = BoxConstraintsMix(maxWidth: 200.0, maxHeight: 250.0);

        final merged = first.merge(second);

        expect(merged.$minWidth, resolvesTo(50.0));
        expect(merged.$maxWidth, resolvesTo(200.0));
        expect(merged.$minHeight, resolvesTo(100.0));
        expect(merged.$maxHeight, resolvesTo(250.0));
      });

      test('merges named constructor results correctly', () {
        final width = BoxConstraintsMix.minWidth(100.0);
        final height = BoxConstraintsMix.maxHeight(200.0);
        final merged = width.merge(height);

        expect(merged.$minWidth, resolvesTo(100.0));
        expect(merged.$maxHeight, resolvesTo(200.0));
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

    group('Props getter', () {
      test('props includes all properties', () {
        final constraintsMix = BoxConstraintsMix(
          minWidth: 50.0,
          maxWidth: 150.0,
          minHeight: 100.0,
          maxHeight: 200.0,
        );

        expect(constraintsMix.props.length, 4);
        expect(constraintsMix.props, contains(constraintsMix.$minWidth));
        expect(constraintsMix.props, contains(constraintsMix.$maxWidth));
        expect(constraintsMix.props, contains(constraintsMix.$minHeight));
        expect(constraintsMix.props, contains(constraintsMix.$maxHeight));
      });
    });

    group('Default Value', () {
      test('has correct default value', () {
        final constraintsMix = BoxConstraintsMix();

        expect(constraintsMix.defaultValue, const BoxConstraints());
      });
    });
  });
}
