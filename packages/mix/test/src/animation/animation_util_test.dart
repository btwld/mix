import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('AnimationConfigUtility', () {
    late AnimationConfigUtility<MockStyle<AnimationConfig>> utility;

    setUp(() {
      utility = AnimationConfigUtility(MockStyle.new);
    });

    group('implicit', () {
      test('creates CurveAnimationConfig with duration', () {
        final result = utility.implicit(
          duration: const Duration(milliseconds: 300),
        );

        final config = result.value as CurveAnimationConfig;
        expect(config.duration, const Duration(milliseconds: 300));
      });

      test('uses Curves.linear as default curve', () {
        final result = utility.implicit(
          duration: const Duration(milliseconds: 300),
        );

        final config = result.value as CurveAnimationConfig;
        expect(config.curve, Curves.linear);
      });

      test('accepts custom curve', () {
        final result = utility.implicit(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );

        final config = result.value as CurveAnimationConfig;
        expect(config.curve, Curves.easeInOut);
      });
    });

    group('call', () {
      test('is an alias for implicit', () {
        final implicitResult = utility.implicit(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );

        final callResult = utility(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );

        final implicitConfig = implicitResult.value as CurveAnimationConfig;
        final callConfig = callResult.value as CurveAnimationConfig;

        expect(callConfig.duration, implicitConfig.duration);
        expect(callConfig.curve, implicitConfig.curve);
      });

      test('requires duration parameter', () {
        // This should compile - duration is required
        final result = utility(duration: const Duration(milliseconds: 100));

        expect(result.value, isA<CurveAnimationConfig>());
      });
    });
  });
}
