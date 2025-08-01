import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxConstraintsUtility', () {
    late BoxConstraintsUtility<MockStyle<BoxConstraintsMix>> util;

    setUp(() {
      util = BoxConstraintsUtility<MockStyle<BoxConstraintsMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('minWidth is now a method', () {
        expect(util.minWidth, isA<Function>());
      });

      test('maxWidth is now a method', () {
        expect(util.maxWidth, isA<Function>());
      });

      test('minHeight is now a method', () {
        expect(util.minHeight, isA<Function>());
      });

      test('maxHeight is now a method', () {
        expect(util.maxHeight, isA<Function>());
      });

      test('height is now a method', () {
        expect(util.height, isA<Function>());
      });

      test('width is now a method', () {
        expect(util.width, isA<Function>());
      });
    });

    group('property setters', () {
      test('minWidth sets minimum width constraint', () {
        final result = util.minWidth(100.0);

        final constraints = result.value.resolve(MockBuildContext());

        expect(
          constraints,
          const BoxConstraints(minWidth: 100.0),
        );
      });

      test('maxWidth sets maximum width constraint', () {
        final result = util.maxWidth(200.0);

        final constraints = result.value.resolve(MockBuildContext());

        expect(
          constraints,
          const BoxConstraints(maxWidth: 200.0),
        );
      });

      test('minHeight sets minimum height constraint', () {
        final result = util.minHeight(50.0);

        final constraints = result.value.resolve(MockBuildContext());

        expect(
          constraints,
          const BoxConstraints(minHeight: 50.0),
        );
      });

      test('maxHeight sets maximum height constraint', () {
        final result = util.maxHeight(150.0);

        final constraints = result.value.resolve(MockBuildContext());

        expect(
          constraints,
          const BoxConstraints(maxHeight: 150.0),
        );
      });

      test('height sets both min and max height constraints', () {
        final result = util.height(100.0);

        final constraints = result.value.resolve(MockBuildContext());

        expect(
          constraints,
          const BoxConstraints(minHeight: 100.0, maxHeight: 100.0),
        );
      });

      test('width sets both min and max width constraints', () {
        final result = util.width(200.0);

        final constraints = result.value.resolve(MockBuildContext());

        expect(
          constraints,
          const BoxConstraints(minWidth: 200.0, maxWidth: 200.0),
        );
      });
    });

    group('only method', () {
      test('sets specific constraints', () {
        final result = util.only(
          minWidth: 50.0,
          maxWidth: 200.0,
          minHeight: 30.0,
          maxHeight: 100.0,
        );

        final constraints = result.value.resolve(MockBuildContext());

        expect(
          constraints,
          const BoxConstraints(
            minWidth: 50.0,
            maxWidth: 200.0,
            minHeight: 30.0,
            maxHeight: 100.0,
          ),
        );
      });

      test('sets partial constraints', () {
        final result = util.only(
          minWidth: 100.0,
          maxHeight: 200.0,
        );

        final constraints = result.value.resolve(MockBuildContext());

        expect(
          constraints,
          const BoxConstraints(
            minWidth: 100.0,
            maxHeight: 200.0,
          ),
        );
      });

      test('handles null values', () {
        final result = util.only();

        final constraints = result.value.resolve(MockBuildContext());

        expect(constraints, const BoxConstraints());
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        final result = util(
          minWidth: 75.0,
          maxWidth: 300.0,
          minHeight: 50.0,
          maxHeight: 150.0,
        );

        final constraints = result.value.resolve(MockBuildContext());

        expect(
          constraints,
          const BoxConstraints(
            minWidth: 75.0,
            maxWidth: 300.0,
            minHeight: 50.0,
            maxHeight: 150.0,
          ),
        );
      });

      test('handles partial parameters', () {
        final result = util(
          minWidth: 80.0,
          maxHeight: 120.0,
        );

        final constraints = result.value.resolve(MockBuildContext());

        expect(
          constraints,
          const BoxConstraints(
            minWidth: 80.0,
            maxHeight: 120.0,
          ),
        );
      });
    });

    group('as method', () {
      test('accepts BoxConstraints', () {
        const constraints = BoxConstraints(
          minWidth: 100.0,
          maxWidth: 400.0,
          minHeight: 50.0,
          maxHeight: 200.0,
        );
        final result = util.as(constraints);

        expect(
          result.value,
          BoxConstraintsMix(
            minWidth: 100.0,
            maxWidth: 400.0,
            minHeight: 50.0,
            maxHeight: 200.0,
          ),
        );
      });

      test('handles tight constraints', () {
        const constraints = BoxConstraints.tightFor(width: 200.0, height: 100.0);
        final result = util.as(constraints);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, constraints);
      });

      test('handles expand constraints', () {
        const constraints = BoxConstraints.expand();
        final result = util.as(constraints);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, constraints);
      });
    });

    group('constraint combinations', () {
      test('can combine different constraint utilities', () {
        final widthResult = util.width(200.0);
        final heightResult = util.height(100.0);

        final widthConstraints = widthResult.value.resolve(MockBuildContext());
        final heightConstraints = heightResult.value.resolve(MockBuildContext());

        expect(
          widthConstraints,
          const BoxConstraints(minWidth: 200.0, maxWidth: 200.0),
        );
        expect(
          heightConstraints,
          const BoxConstraints(minHeight: 100.0, maxHeight: 100.0),
        );
      });
    });
  });
}