import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('AnimatedUtility', () {
    final animatedUtility = AnimatedUtility(UtilityTestAttribute.new);

    group('constructor', () {
      test('creates instance correctly', () {
        expect(animatedUtility, isA<AnimatedUtility<UtilityTestAttribute>>());
      });

      test('valueToDto function works correctly', () {
        const animatedData = AnimatedData.withDefaults();
        final dto = animatedData.toDto();

        // Verify the valueToDto function works
        expect(dto, isA<AnimatedDataDto>());
        expect(dto.duration, animatedData.duration);
        expect(dto.curve, animatedData.curve);
      });
    });

    group('duration utility', () {
      test('returns DurationUtility instance', () {
        expect(animatedUtility.duration,
            isA<DurationUtility<UtilityTestAttribute>>());
      });

      test('duration utility creates correct attribute', () {
        const testDuration = Duration(seconds: 2);
        final result = animatedUtility.duration.seconds(2);

        expect(result, isA<UtilityTestAttribute>());
        expect(result.value, isA<AnimatedDataDto>());
        expect(result.value.duration, testDuration);
        expect(result.value.curve, isNull);
      });

      test('duration utility methods work correctly', () {
        // Test microseconds
        final microResult = animatedUtility.duration.microseconds(500);
        expect(microResult.value.duration, const Duration(microseconds: 500));

        // Test milliseconds
        final milliResult = animatedUtility.duration.milliseconds(250);
        expect(milliResult.value.duration, const Duration(milliseconds: 250));

        // Test seconds
        final secondsResult = animatedUtility.duration.seconds(3);
        expect(secondsResult.value.duration, const Duration(seconds: 3));

        // Test minutes
        final minutesResult = animatedUtility.duration.minutes(1);
        expect(minutesResult.value.duration, const Duration(minutes: 1));
      });
    });

    group('curve utility', () {
      test('returns CurveUtility instance', () {
        expect(
            animatedUtility.curve, isA<CurveUtility<UtilityTestAttribute>>());
      });

      test('curve utility creates correct attribute', () {
        final result = animatedUtility.curve.easeIn();

        expect(result, isA<UtilityTestAttribute>());
        expect(result.value, isA<AnimatedDataDto>());
        expect(result.value.curve, Curves.easeIn);
        expect(result.value.duration, isNull);
      });

      test('curve utility methods work correctly', () {
        // Test predefined curves
        final easeInResult = animatedUtility.curve.easeIn();
        expect(easeInResult.value.curve, Curves.easeIn);

        final easeOutResult = animatedUtility.curve.easeOut();
        expect(easeOutResult.value.curve, Curves.easeOut);

        final linearResult = animatedUtility.curve.linear();
        expect(linearResult.value.curve, Curves.linear);

        // Test custom curve
        final customResult = animatedUtility.curve.as(Curves.bounceIn);
        expect(customResult.value.curve, Curves.bounceIn);
      });

      test('curve utility spring method works correctly', () {
        final springResult = animatedUtility.curve.spring(
          stiffness: 2.0,
          dampingRatio: 0.8,
          mass: 1.5,
        );

        expect(springResult.value.curve, isA<SpringCurve>());
      });
    });

    group('only method', () {
      test('creates attribute with duration only', () {
        const testDuration = Duration(seconds: 1);
        final result = animatedUtility.only(duration: testDuration);

        expect(result, isA<UtilityTestAttribute>());
        expect(result.value, isA<AnimatedDataDto>());
        expect(result.value.duration, testDuration);
        expect(result.value.curve, isNull);
      });

      test('creates attribute with curve only', () {
        const testCurve = Curves.easeInOut;
        final result = animatedUtility.only(curve: testCurve);

        expect(result, isA<UtilityTestAttribute>());
        expect(result.value, isA<AnimatedDataDto>());
        expect(result.value.duration, isNull);
        expect(result.value.curve, testCurve);
      });

      test('creates attribute with both duration and curve', () {
        const testDuration = Duration(milliseconds: 500);
        const testCurve = Curves.elasticOut;
        final result = animatedUtility.only(
          duration: testDuration,
          curve: testCurve,
        );

        expect(result, isA<UtilityTestAttribute>());
        expect(result.value, isA<AnimatedDataDto>());
        expect(result.value.duration, testDuration);
        expect(result.value.curve, testCurve);
      });

      test('creates attribute with null values', () {
        final result = animatedUtility.only();

        expect(result, isA<UtilityTestAttribute>());
        expect(result.value, isA<AnimatedDataDto>());
        expect(result.value.duration, isNull);
        expect(result.value.curve, isNull);
      });
    });

    group('fluent chaining', () {
      test('duration and curve utilities can be chained conceptually', () {
        // Test that both utilities work independently and can be used together
        final durationResult = animatedUtility.duration.seconds(2);
        final curveResult = animatedUtility.curve.easeIn();

        expect(durationResult.value.duration, const Duration(seconds: 2));
        expect(curveResult.value.curve, Curves.easeIn);

        // Test combined usage through only method
        final combinedResult = animatedUtility.only(
          duration: const Duration(seconds: 2),
          curve: Curves.easeIn,
        );

        expect(combinedResult.value.duration, const Duration(seconds: 2));
        expect(combinedResult.value.curve, Curves.easeIn);
      });
    });

    group('immutability', () {
      test('each call creates new attribute instance', () {
        final result1 =
            animatedUtility.only(duration: const Duration(seconds: 1));
        final result2 =
            animatedUtility.only(duration: const Duration(seconds: 2));

        expect(result1, isNot(same(result2)));
        expect(result1.value.duration, const Duration(seconds: 1));
        expect(result2.value.duration, const Duration(seconds: 2));
      });

      test('utility instances are independent', () {
        final duration1 = animatedUtility.duration.seconds(1);
        final duration2 = animatedUtility.duration.seconds(2);

        expect(duration1, isNot(same(duration2)));
        expect(duration1.value.duration, const Duration(seconds: 1));
        expect(duration2.value.duration, const Duration(seconds: 2));
      });
    });

    group('integration', () {
      test('works with Style creation', () {
        // Create a style with animated utility
        final attribute = animatedUtility.only(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );

        expect(attribute, isA<UtilityTestAttribute>());
        expect(attribute.value, isA<AnimatedDataDto>());
        expect(attribute.value.duration, const Duration(milliseconds: 300));
        expect(attribute.value.curve, Curves.easeInOut);
      });

      test('resolves correctly through MixData', () {
        final attribute = animatedUtility.only(
          duration: const Duration(seconds: 1),
          curve: Curves.bounceIn,
        );

        expect(attribute.value, isA<AnimatedDataDto>());
        expect(attribute.value.duration, const Duration(seconds: 1));
        expect(attribute.value.curve, Curves.bounceIn);

        // Test that the DTO can be resolved
        final resolved = attribute.value.resolve(EmptyMixData);
        expect(resolved, isA<AnimatedData>());
        expect(resolved.duration, const Duration(seconds: 1));
        expect(resolved.curve, Curves.bounceIn);
      });
    });
  });
}
