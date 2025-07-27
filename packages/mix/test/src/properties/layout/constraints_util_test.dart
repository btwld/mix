import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxConstraintsUtility', () {
    final utility = BoxConstraintsUtility(UtilityTestAttribute.new);

    test('call() creates BoxConstraintsMix from value', () {
      const constraints = BoxConstraints(
        minWidth: 100.0,
        maxWidth: 200.0,
        minHeight: 50.0,
        maxHeight: 150.0,
      );

      final result = utility(BoxConstraintsMix.value(constraints));
      expect(result, isA<UtilityTestAttribute>());
      expect(result.value, isA<MixProp<BoxConstraints>>());

      final mix = result.value.value as BoxConstraintsMix;
      expectProp(mix.$minWidth, 100.0);
      expectProp(mix.$maxWidth, 200.0);
      expectProp(mix.$minHeight, 50.0);
      expectProp(mix.$maxHeight, 150.0);
    });

    group('individual constraint utilities', () {
      test('minWidth creates BoxConstraintsMix with minWidth', () {
        final result = utility.minWidth(100.0);

        expect(result, isA<UtilityTestAttribute>());
        final mix = result.value.value as BoxConstraintsMix;
        expectProp(mix.$minWidth, 100.0);
        expect(mix.$maxWidth, isNull);
        expect(mix.$minHeight, isNull);
        expect(mix.$maxHeight, isNull);
      });

      test('maxWidth creates BoxConstraintsMix with maxWidth', () {
        final result = utility.maxWidth(200.0);

        expect(result, isA<UtilityTestAttribute>());
        final mix = result.value.value as BoxConstraintsMix;
        expect(mix.$minWidth, isNull);
        expectProp(mix.$maxWidth, 200.0);
        expect(mix.$minHeight, isNull);
        expect(mix.$maxHeight, isNull);
      });

      test('minHeight creates BoxConstraintsMix with minHeight', () {
        final result = utility.minHeight(50.0);

        expect(result, isA<UtilityTestAttribute>());
        final mix = result.value.value as BoxConstraintsMix;
        expect(mix.$minWidth, isNull);
        expect(mix.$maxWidth, isNull);
        expectProp(mix.$minHeight, 50.0);
        expect(mix.$maxHeight, isNull);
      });

      test('maxHeight creates BoxConstraintsMix with maxHeight', () {
        final result = utility.maxHeight(150.0);

        expect(result, isA<UtilityTestAttribute>());
        final mix = result.value.value as BoxConstraintsMix;
        expect(mix.$minWidth, isNull);
        expect(mix.$maxWidth, isNull);
        expect(mix.$minHeight, isNull);
        expectProp(mix.$maxHeight, 150.0);
      });
    });

    group('token support', () {
      test('minWidth supports tokens', () {
        const token = MixToken<double>('spacing.minWidth');
        final result = utility.minWidth.token(token);

        expect(result, isA<UtilityTestAttribute>());
        final mix = result.value.value as BoxConstraintsMix;
        expectProp(mix.$minWidth, token);
      });

      test('maxWidth supports tokens', () {
        const token = MixToken<double>('spacing.maxWidth');
        final result = utility.maxWidth.token(token);

        expect(result, isA<UtilityTestAttribute>());
        final mix = result.value.value as BoxConstraintsMix;
        expectProp(mix.$maxWidth, token);
      });

      test('minHeight supports tokens', () {
        const token = MixToken<double>('spacing.minHeight');
        final result = utility.minHeight.token(token);

        expect(result, isA<UtilityTestAttribute>());
        final mix = result.value.value as BoxConstraintsMix;
        expectProp(mix.$minHeight, token);
      });

      test('maxHeight supports tokens', () {
        const token = MixToken<double>('spacing.maxHeight');
        final result = utility.maxHeight.token(token);

        expect(result, isA<UtilityTestAttribute>());
        final mix = result.value.value as BoxConstraintsMix;
        expectProp(mix.$maxHeight, token);
      });
    });

    group('edge cases', () {
      test('creates tight constraints', () {
        const constraints = BoxConstraints.tightFor(
          width: 100.0,
          height: 100.0,
        );

        final result = utility(BoxConstraintsMix.value(constraints));
        final mix = result.value.value as BoxConstraintsMix;

        expectProp(mix.$minWidth, 100.0);
        expectProp(mix.$maxWidth, 100.0);
        expectProp(mix.$minHeight, 100.0);
        expectProp(mix.$maxHeight, 100.0);
      });

      test('creates loose constraints', () {
        final constraints = BoxConstraints.loose(const Size(200.0, 150.0));

        final result = utility(BoxConstraintsMix.value(constraints));
        final mix = result.value.value as BoxConstraintsMix;

        expectProp(mix.$minWidth, 0.0);
        expectProp(mix.$maxWidth, 200.0);
        expectProp(mix.$minHeight, 0.0);
        expectProp(mix.$maxHeight, 150.0);
      });

      test('creates expand constraints', () {
        const constraints = BoxConstraints.expand(width: 300.0, height: 400.0);

        final result = utility(BoxConstraintsMix.value(constraints));
        final mix = result.value.value as BoxConstraintsMix;

        expectProp(mix.$minWidth, 300.0);
        expectProp(mix.$maxWidth, 300.0);
        expectProp(mix.$minHeight, 400.0);
        expectProp(mix.$maxHeight, 400.0);
      });

      test('handles infinity values', () {
        const constraints = BoxConstraints(
          minWidth: 0.0,
          maxWidth: double.infinity,
          minHeight: 0.0,
          maxHeight: double.infinity,
        );

        final result = utility(BoxConstraintsMix.value(constraints));
        final mix = result.value.value as BoxConstraintsMix;

        expectProp(mix.$minWidth, 0.0);
        expectProp(mix.$maxWidth, double.infinity);
        expectProp(mix.$minHeight, 0.0);
        expectProp(mix.$maxHeight, double.infinity);
      });
    });

    group('resolution', () {
      test('resolves to BoxConstraints correctly', () {
        final result = utility
            .minWidth(100.0)
            .merge(utility.maxWidth(200.0))
            .merge(utility.minHeight(50.0))
            .merge(utility.maxHeight(150.0));

        final mix = result.value.value as BoxConstraintsMix;
        const resolvedValue = BoxConstraints(
          minWidth: 100.0,
          maxWidth: 200.0,
          minHeight: 50.0,
          maxHeight: 150.0,
        );

        expect(mix, resolvesTo(resolvedValue));
      });

      test('uses default values for null properties', () {
        final result = utility.minWidth(100.0);

        final mix = result.value.value as BoxConstraintsMix;
        const resolvedValue = BoxConstraints(
          minWidth: 100.0,
          maxWidth: double.infinity,
          minHeight: 0.0,
          maxHeight: double.infinity,
        );

        expect(mix, resolvesTo(resolvedValue));
      });
    });
  });
}
