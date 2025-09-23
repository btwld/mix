import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test style implementation for testing animation utility
class TestAnimationStyle extends Style<BoxSpec>
    with AnimationStyleMixin<BoxSpec, TestAnimationStyle> {
  final AnimationConfig? testAnimation;

  TestAnimationStyle({
    this.testAnimation,
    super.variants,
    super.modifier,
    AnimationConfig? animation,
  }) : super(animation: animation ?? testAnimation);

  @override
  TestAnimationStyle withVariants(List<VariantStyle<BoxSpec>> variants) {
    return TestAnimationStyle(
      testAnimation: testAnimation,
      variants: variants,
      modifier: $modifier,
      animation: $animation,
    );
  }

  @override
  TestAnimationStyle animate(AnimationConfig animation) {
    return TestAnimationStyle(
      testAnimation: animation,
      variants: $variants,
      modifier: $modifier,
      animation: animation,
    );
  }

  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: BoxSpec(),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  TestAnimationStyle merge(TestAnimationStyle? other) {
    return TestAnimationStyle(
      testAnimation: other?.testAnimation ?? testAnimation,
      variants: $variants,
      modifier: $modifier,
      animation: $animation,
    );
  }

  @override
  List<Object?> get props => [testAnimation, $animation, $modifier, $variants];
}

void main() {
  group('AnimationConfigUtility', () {
    late AnimationConfigUtility<TestAnimationStyle> animationUtility;

    setUp(() {
      animationUtility = AnimationConfigUtility<TestAnimationStyle>(
        (config) => TestAnimationStyle(testAnimation: config),
      );
    });

    group('constructor', () {
      test('should create with utility builder', () {
        final utility = AnimationConfigUtility<TestAnimationStyle>(
          (config) => TestAnimationStyle(testAnimation: config),
        );

        expect(utility, isA<AnimationConfigUtility<TestAnimationStyle>>());
        expect(utility, isA<MixUtility<TestAnimationStyle, AnimationConfig>>());
      });
    });

    group('implicit', () {
      test('should create CurveAnimationConfig with required duration', () {
        const duration = Duration(milliseconds: 300);
        final result = animationUtility.implicit(duration: duration);

        expect(result, isA<TestAnimationStyle>());
        expect(result.testAnimation, isA<CurveAnimationConfig>());

        final config = result.testAnimation as CurveAnimationConfig;
        expect(config.duration, equals(duration));
        expect(config.curve, equals(Curves.linear)); // Default curve
        expect(config.delay, equals(Duration.zero)); // Default delay
      });

      test('should create CurveAnimationConfig with custom curve', () {
        const duration = Duration(milliseconds: 500);
        const curve = Curves.easeInOut;

        final result = animationUtility.implicit(
          duration: duration,
          curve: curve,
        );

        expect(result, isA<TestAnimationStyle>());
        expect(result.testAnimation, isA<CurveAnimationConfig>());

        final config = result.testAnimation as CurveAnimationConfig;
        expect(config.duration, equals(duration));
        expect(config.curve, equals(curve));
      });

      test('should work with different curve types', () {
        const duration = Duration(milliseconds: 400);
        final curves = [
          Curves.linear,
          Curves.easeIn,
          Curves.easeOut,
          Curves.easeInOut,
          Curves.fastOutSlowIn,
          Curves.bounceIn,
          Curves.elasticOut,
        ];

        for (final curve in curves) {
          final result = animationUtility.implicit(
            duration: duration,
            curve: curve,
          );

          expect(result.testAnimation, isA<CurveAnimationConfig>());
          final config = result.testAnimation as CurveAnimationConfig;
          expect(config.curve, equals(curve));
        }
      });

      test('should work with different durations', () {
        final durations = [
          const Duration(milliseconds: 100),
          const Duration(milliseconds: 300),
          const Duration(milliseconds: 500),
          const Duration(seconds: 1),
          const Duration(milliseconds: 1500),
        ];

        for (final duration in durations) {
          final result = animationUtility.implicit(duration: duration);

          expect(result.testAnimation, isA<CurveAnimationConfig>());
          final config = result.testAnimation as CurveAnimationConfig;
          expect(config.duration, equals(duration));
        }
      });

      test('should handle zero duration', () {
        final result = animationUtility.implicit(duration: Duration.zero);

        expect(result.testAnimation, isA<CurveAnimationConfig>());
        final config = result.testAnimation as CurveAnimationConfig;
        expect(config.duration, equals(Duration.zero));
      });

      test('should handle very long duration', () {
        const longDuration = Duration(minutes: 5);
        final result = animationUtility.implicit(duration: longDuration);

        expect(result.testAnimation, isA<CurveAnimationConfig>());
        final config = result.testAnimation as CurveAnimationConfig;
        expect(config.duration, equals(longDuration));
      });
    });

    group('call method (alias)', () {
      test('should work identical to implicit method', () {
        const duration = Duration(milliseconds: 250);
        const curve = Curves.ease;

        final implicitResult = animationUtility.implicit(
          duration: duration,
          curve: curve,
        );

        final callResult = animationUtility.call(
          duration: duration,
          curve: curve,
        );

        expect(callResult, isA<TestAnimationStyle>());
        expect(callResult.testAnimation, isA<CurveAnimationConfig>());

        final implicitConfig =
            implicitResult.testAnimation as CurveAnimationConfig;
        final callConfig = callResult.testAnimation as CurveAnimationConfig;

        expect(callConfig.duration, equals(implicitConfig.duration));
        expect(callConfig.curve, equals(implicitConfig.curve));
        expect(callConfig.delay, equals(implicitConfig.delay));
      });

      test('should use default curve when not specified', () {
        const duration = Duration(milliseconds: 300);

        final result = animationUtility.call(duration: duration);

        expect(result.testAnimation, isA<CurveAnimationConfig>());
        final config = result.testAnimation as CurveAnimationConfig;
        expect(config.curve, equals(Curves.linear));
      });

      test('should support function call syntax', () {
        const duration = Duration(milliseconds: 350);

        // This tests that the call method allows using the utility like a function
        final result = animationUtility(duration: duration);

        expect(result, isA<TestAnimationStyle>());
        expect(result.testAnimation, isA<CurveAnimationConfig>());
      });
    });

    group('utility builder', () {
      test('should call utility builder with created config', () {
        AnimationConfig? receivedConfig;

        final testUtility = AnimationConfigUtility<TestAnimationStyle>((
          config,
        ) {
          receivedConfig = config;
          return TestAnimationStyle(testAnimation: config);
        });

        const duration = Duration(milliseconds: 200);
        const curve = Curves.decelerate;

        testUtility.implicit(duration: duration, curve: curve);

        expect(receivedConfig, isNotNull);
        expect(receivedConfig, isA<CurveAnimationConfig>());

        final config = receivedConfig as CurveAnimationConfig;
        expect(config.duration, equals(duration));
        expect(config.curve, equals(curve));
      });

      test('should allow custom style creation', () {
        final customUtility = AnimationConfigUtility<TestAnimationStyle>(
          (config) => TestAnimationStyle(
            testAnimation: config,
            // Could add custom properties here
          ),
        );

        const duration = Duration(milliseconds: 400);
        final result = customUtility.implicit(duration: duration);

        expect(result, isA<TestAnimationStyle>());
        expect(result.testAnimation, isA<CurveAnimationConfig>());
      });
    });

    group('method chaining compatibility', () {
      test('should work with style methods', () {
        const duration = Duration(milliseconds: 300);
        final style = animationUtility.implicit(duration: duration);

        // Test that the result can be used with other style methods
        final withVariants = style.withVariants([]);
        expect(withVariants, isA<TestAnimationStyle>());

        final animated = style.animate(
          CurveAnimationConfig(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          ),
        );
        expect(animated, isA<TestAnimationStyle>());
      });

      test('should preserve animation config in style operations', () {
        const duration = Duration(milliseconds: 250);
        const curve = Curves.fastOutSlowIn;

        final style = animationUtility.implicit(
          duration: duration,
          curve: curve,
        );
        final modifiedStyle = style.withVariants([]);

        expect(modifiedStyle.testAnimation, isA<CurveAnimationConfig>());
        final config = modifiedStyle.testAnimation as CurveAnimationConfig;
        expect(config.duration, equals(duration));
        expect(config.curve, equals(curve));
      });
    });

    group('integration with different style types', () {
      test('should work with different style implementations', () {
        final anotherUtility = AnimationConfigUtility<TestAnimationStyle>(
          (config) => TestAnimationStyle(testAnimation: config),
        );

        const duration = Duration(milliseconds: 300);
        final result = anotherUtility.implicit(duration: duration);

        expect(result, isA<TestAnimationStyle>());
      });
    });

    group('error handling', () {
      test('should handle null utility builder gracefully', () {
        // This test ensures the utility behaves correctly even in edge cases
        expect(() {
          final utility = AnimationConfigUtility<TestAnimationStyle>(
            (config) => TestAnimationStyle(testAnimation: config),
          );
          utility.implicit(duration: const Duration(milliseconds: 100));
        }, returnsNormally);
      });
    });

    group('comprehensive usage', () {
      test('should support all common animation scenarios', () {
        final scenarios = [
          // Quick animations
          {
            'duration': const Duration(milliseconds: 150),
            'curve': Curves.easeOut,
          },
          // Standard animations
          {'duration': const Duration(milliseconds: 300), 'curve': Curves.ease},
          // Slow animations
          {
            'duration': const Duration(milliseconds: 600),
            'curve': Curves.easeInOut,
          },
          // Bouncy animations
          {
            'duration': const Duration(milliseconds: 400),
            'curve': Curves.bounceOut,
          },
          // Elastic animations
          {
            'duration': const Duration(milliseconds: 500),
            'curve': Curves.elasticOut,
          },
        ];

        for (final scenario in scenarios) {
          final duration = scenario['duration'] as Duration;
          final curve = scenario['curve'] as Curve;

          final result = animationUtility.implicit(
            duration: duration,
            curve: curve,
          );

          expect(result, isA<TestAnimationStyle>());
          expect(result.testAnimation, isA<CurveAnimationConfig>());

          final config = result.testAnimation as CurveAnimationConfig;
          expect(config.duration, equals(duration));
          expect(config.curve, equals(curve));
        }
      });
    });
  });
}
