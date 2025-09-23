import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/animation/animation_config.dart';

void main() {
  group('AnimationConfig', () {
    group('CurveAnimationConfig', () {
      test('creates with implicit factory', () {
        final config = AnimationConfig.curve(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );

        expect(config, isA<CurveAnimationConfig>());
        expect(
          (config as CurveAnimationConfig).duration,
          const Duration(milliseconds: 300),
        );
        expect(config.curve, Curves.easeIn);
      });

      test('supports equality', () {
        final config1 = AnimationConfig.curve(
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
        final config2 = AnimationConfig.curve(
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
        final config3 = AnimationConfig.curve(
          duration: const Duration(seconds: 1),
          curve: Curves.ease,
        );

        expect(config1, equals(config2));
        expect(config1, isNot(equals(config3)));
      });

      test('has correct hashCode', () {
        final config1 = AnimationConfig.curve(
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
        final config2 = AnimationConfig.curve(
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );

        expect(config1.hashCode, equals(config2.hashCode));
      });

      test('handles onEnd callback', () {
        bool called = false;
        final config = AnimationConfig.curve(
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
          onEnd: () => called = true,
        );

        expect((config as CurveAnimationConfig).onEnd, isNotNull);
        config.onEnd!();
        expect(called, true);
      });
    });

    group('SpringAnimationConfig', () {
      test('creates with spring factory', () {
        final config = AnimationConfig.springDescription(
          mass: 2.0,
          stiffness: 100.0,
          damping: 10.0,
        );

        expect(config, isA<SpringAnimationConfig>());
        expect(config.spring.mass, 2.0);
        expect(config.spring.stiffness, 100.0);
        expect(config.spring.damping, 10.0);
      });

      test('creates with custom SpringDescription', () {
        final config = AnimationConfig.springDescription(
          mass: 3.0,
          stiffness: 150.0,
          damping: 15.0,
        );

        expect(config.spring.mass, 3.0);
        expect(config.spring.stiffness, 150.0);
        expect(config.spring.damping, 15.0);
      });

      test('creates critically damped spring', () {
        final config = AnimationConfig.springDescription(
          mass: 2.0,
          stiffness: 200.0,
        );

        expect(config, isA<SpringAnimationConfig>());
        expect(config.spring.mass, 2.0);
        expect(config.spring.stiffness, 200.0);
        // Critically damped has specific damping ratio
      });

      test('creates underdamped spring', () {
        final config = AnimationConfig.springDescription(
          mass: 1.5,
          stiffness: 250.0,
        );

        expect(config, isA<SpringAnimationConfig>());
        expect(config.spring.mass, 1.5);
        expect(config.spring.stiffness, 250.0);
      });

      test('supports equality', () {
        final config1 = AnimationConfig.springDescription(
          mass: 1.0,
          stiffness: 180.0,
          damping: 12.0,
        );
        final config2 = AnimationConfig.springDescription(
          mass: 1.0,
          stiffness: 180.0,
          damping: 12.0,
        );
        final config3 = AnimationConfig.springDescription(
          mass: 2.0,
          stiffness: 180.0,
          damping: 12.0,
        );

        expect(config1, equals(config2));
        expect(config1, isNot(equals(config3)));
      });

      test('handles onEnd callback', () {
        bool called = false;
        final config = AnimationConfig.springDescription(
          onEnd: () => called = true,
        );

        expect(config.onEnd, isNotNull);
        config.onEnd!();
        expect(called, true);
      });

      test('creates with standard constructor', () {
        final config = SpringAnimationConfig.standard();

        expect(config.spring.mass, 1.0);
        expect(config.spring.stiffness, 180.0);
        expect(config.spring.damping, 12.0);
      });

      test('creates with critically damped constructor', () {
        final config = SpringAnimationConfig.criticallyDamped();

        expect(config.spring.mass, 1.0);
        expect(config.spring.stiffness, 180.0);
      });

      test('creates with underdamped constructor', () {
        final config = SpringAnimationConfig.underdamped();

        expect(config.spring.mass, 1.0);
        expect(config.spring.stiffness, 180.0);
      });
    });

    group('Predefined Curve Factories', () {
      test('should create ease animation', () {
        final config = AnimationConfig.ease(const Duration(milliseconds: 300));

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.ease));
        expect(curveConfig.duration, equals(const Duration(milliseconds: 300)));
      });

      test('should create easeIn animation', () {
        final config = AnimationConfig.easeIn(
          const Duration(milliseconds: 250),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeIn));
      });

      test('should create easeOut animation', () {
        final config = AnimationConfig.easeOut(
          const Duration(milliseconds: 400),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeOut));
      });

      test('should create easeInOut animation', () {
        final config = AnimationConfig.easeInOut(
          const Duration(milliseconds: 500),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInOut));
      });

      test('should create fastOutSlowIn animation', () {
        final config = AnimationConfig.fastOutSlowIn(
          const Duration(milliseconds: 350),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.fastOutSlowIn));
      });

      test('should create bounceIn animation', () {
        final config = AnimationConfig.bounceIn(
          const Duration(milliseconds: 600),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.bounceIn));
      });

      test('should create bounceOut animation', () {
        final config = AnimationConfig.bounceOut(
          const Duration(milliseconds: 450),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.bounceOut));
      });

      test('should create elasticIn animation', () {
        final config = AnimationConfig.elasticIn(
          const Duration(milliseconds: 700),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.elasticIn));
      });

      test('should create elasticOut animation', () {
        final config = AnimationConfig.elasticOut(
          const Duration(milliseconds: 550),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.elasticOut));
      });

      test('should create linear animation', () {
        final config = AnimationConfig.linear(
          const Duration(milliseconds: 200),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.linear));
      });
    });

    group('Specialized Curve Factories', () {
      test('should create decelerate animation', () {
        final config = AnimationConfig.decelerate(
          const Duration(milliseconds: 300),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.decelerate));
      });

      test('should create fastLinearToSlowEaseIn animation', () {
        final config = AnimationConfig.fastLinearToSlowEaseIn(
          const Duration(milliseconds: 400),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.fastLinearToSlowEaseIn));
      });

      test('should create fastEaseInToSlowEaseOut animation', () {
        final config = AnimationConfig.fastEaseInToSlowEaseOut(
          const Duration(milliseconds: 350),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.fastEaseInToSlowEaseOut));
      });

      test('should create linearToEaseOut animation', () {
        final config = AnimationConfig.linearToEaseOut(
          const Duration(milliseconds: 280),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.linearToEaseOut));
      });

      test('should create slowMiddle animation', () {
        final config = AnimationConfig.slowMiddle(
          const Duration(milliseconds: 500),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.slowMiddle));
      });
    });

    group('Sine Curve Factories', () {
      test('should create easeInSine animation', () {
        final config = AnimationConfig.easeInSine(
          const Duration(milliseconds: 300),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInSine));
      });

      test('should create easeOutSine animation', () {
        final config = AnimationConfig.easeOutSine(
          const Duration(milliseconds: 400),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeOutSine));
      });

      test('should create easeInOutSine animation', () {
        final config = AnimationConfig.easeInOutSine(
          const Duration(milliseconds: 350),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInOutSine));
      });
    });

    group('Quad Curve Factories', () {
      test('should create easeInQuad animation', () {
        final config = AnimationConfig.easeInQuad(
          const Duration(milliseconds: 250),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInQuad));
      });

      test('should create easeOutQuad animation', () {
        final config = AnimationConfig.easeOutQuad(
          const Duration(milliseconds: 300),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeOutQuad));
      });

      test('should create easeInOutQuad animation', () {
        final config = AnimationConfig.easeInOutQuad(
          const Duration(milliseconds: 400),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInOutQuad));
      });
    });

    group('Cubic Curve Factories', () {
      test('should create easeInCubic animation', () {
        final config = AnimationConfig.easeInCubic(
          const Duration(milliseconds: 350),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInCubic));
      });

      test('should create easeOutCubic animation', () {
        final config = AnimationConfig.easeOutCubic(
          const Duration(milliseconds: 275),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeOutCubic));
      });

      test('should create easeInOutCubic animation', () {
        final config = AnimationConfig.easeInOutCubic(
          const Duration(milliseconds: 450),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInOutCubic));
      });

      test('should create easeInOutCubicEmphasized animation', () {
        final config = AnimationConfig.easeInOutCubicEmphasized(
          const Duration(milliseconds: 400),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInOutCubicEmphasized));
      });
    });

    group('Additional Curve Families', () {
      test('should create easeInQuart animation', () {
        final config = AnimationConfig.easeInQuart(
          const Duration(milliseconds: 320),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInQuart));
      });

      test('should create easeInQuint animation', () {
        final config = AnimationConfig.easeInQuint(
          const Duration(milliseconds: 380),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInQuint));
      });

      test('should create easeInExpo animation', () {
        final config = AnimationConfig.easeInExpo(
          const Duration(milliseconds: 420),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInExpo));
      });

      test('should create easeInCirc animation', () {
        final config = AnimationConfig.easeInCirc(
          const Duration(milliseconds: 290),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInCirc));
      });

      test('should create easeInBack animation', () {
        final config = AnimationConfig.easeInBack(
          const Duration(milliseconds: 340),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInBack));
      });
    });

    group('Additional Out Curves', () {
      test('should create easeOutQuart animation', () {
        final config = AnimationConfig.easeOutQuart(
          const Duration(milliseconds: 310),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeOutQuart));
      });

      test('should create easeOutQuint animation', () {
        final config = AnimationConfig.easeOutQuint(
          const Duration(milliseconds: 360),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeOutQuint));
      });

      test('should create easeOutExpo animation', () {
        final config = AnimationConfig.easeOutExpo(
          const Duration(milliseconds: 410),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeOutExpo));
      });

      test('should create easeOutCirc animation', () {
        final config = AnimationConfig.easeOutCirc(
          const Duration(milliseconds: 270),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeOutCirc));
      });

      test('should create easeOutBack animation', () {
        final config = AnimationConfig.easeOutBack(
          const Duration(milliseconds: 330),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeOutBack));
      });
    });

    group('Additional InOut Curves', () {
      test('should create easeInOutQuart animation', () {
        final config = AnimationConfig.easeInOutQuart(
          const Duration(milliseconds: 375),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInOutQuart));
      });

      test('should create easeInOutQuint animation', () {
        final config = AnimationConfig.easeInOutQuint(
          const Duration(milliseconds: 425),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInOutQuint));
      });

      test('should create easeInOutExpo animation', () {
        final config = AnimationConfig.easeInOutExpo(
          const Duration(milliseconds: 480),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInOutExpo));
      });

      test('should create easeInOutCirc animation', () {
        final config = AnimationConfig.easeInOutCirc(
          const Duration(milliseconds: 320),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInOutCirc));
      });

      test('should create easeInOutBack animation', () {
        final config = AnimationConfig.easeInOutBack(
          const Duration(milliseconds: 390),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInOutBack));
      });
    });

    group('Bounce and Elastic Curves', () {
      test('should create bounceInOut animation', () {
        final config = AnimationConfig.bounceInOut(
          const Duration(milliseconds: 500),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.bounceInOut));
      });

      test('should create elasticInOut animation', () {
        final config = AnimationConfig.elasticInOut(
          const Duration(milliseconds: 600),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.elasticInOut));
      });

      test('should create easeInToLinear animation', () {
        final config = AnimationConfig.easeInToLinear(
          const Duration(milliseconds: 300),
        );

        expect(config, isA<CurveAnimationConfig>());
        final curveConfig = config as CurveAnimationConfig;
        expect(curveConfig.curve, equals(Curves.easeInToLinear));
      });
    });

    group('Callback and Delay Support', () {
      test('should support onEnd callback in all factory methods', () {
        bool callbackExecuted = false;
        void testCallback() => callbackExecuted = true;

        final configs = [
          AnimationConfig.ease(
            const Duration(milliseconds: 300),
            onEnd: testCallback,
          ),
          AnimationConfig.easeIn(
            const Duration(milliseconds: 300),
            onEnd: testCallback,
          ),
          AnimationConfig.bounceOut(
            const Duration(milliseconds: 300),
            onEnd: testCallback,
          ),
          AnimationConfig.elasticIn(
            const Duration(milliseconds: 300),
            onEnd: testCallback,
          ),
        ];

        for (final config in configs) {
          expect(config, isA<CurveAnimationConfig>());
          final curveConfig = config as CurveAnimationConfig;
          expect(curveConfig.onEnd, isNotNull);

          curveConfig.onEnd!();
          expect(callbackExecuted, isTrue);
          callbackExecuted = false; // Reset for next iteration
        }
      });

      test('should support delay in all factory methods', () {
        const delay = Duration(milliseconds: 150);

        final configs = [
          AnimationConfig.ease(const Duration(milliseconds: 300), delay: delay),
          AnimationConfig.linear(
            const Duration(milliseconds: 300),
            delay: delay,
          ),
          AnimationConfig.fastOutSlowIn(
            const Duration(milliseconds: 300),
            delay: delay,
          ),
        ];

        for (final config in configs) {
          expect(config, isA<CurveAnimationConfig>());
          final curveConfig = config as CurveAnimationConfig;
          expect(curveConfig.delay, equals(delay));
        }
      });
    });

    group('Comprehensive Factory Coverage', () {
      test(
        'should verify all factory methods create proper configurations',
        () {
          const duration = Duration(milliseconds: 300);

          // Test a representative sample of all factory types
          final factoryTests = [
            () => AnimationConfig.ease(duration),
            () => AnimationConfig.easeIn(duration),
            () => AnimationConfig.easeOut(duration),
            () => AnimationConfig.easeInOut(duration),
            () => AnimationConfig.linear(duration),
            () => AnimationConfig.decelerate(duration),
            () => AnimationConfig.fastOutSlowIn(duration),
            () => AnimationConfig.bounceIn(duration),
            () => AnimationConfig.bounceOut(duration),
            () => AnimationConfig.bounceInOut(duration),
            () => AnimationConfig.elasticIn(duration),
            () => AnimationConfig.elasticOut(duration),
            () => AnimationConfig.elasticInOut(duration),
            () => AnimationConfig.easeInSine(duration),
            () => AnimationConfig.easeOutSine(duration),
            () => AnimationConfig.easeInOutSine(duration),
            () => AnimationConfig.easeInQuad(duration),
            () => AnimationConfig.easeOutQuad(duration),
            () => AnimationConfig.easeInOutQuad(duration),
            () => AnimationConfig.easeInCubic(duration),
            () => AnimationConfig.easeOutCubic(duration),
            () => AnimationConfig.easeInOutCubic(duration),
            () => AnimationConfig.easeInOutCubicEmphasized(duration),
          ];

          for (final factoryTest in factoryTests) {
            final config = factoryTest();
            expect(config, isA<CurveAnimationConfig>());

            final curveConfig = config as CurveAnimationConfig;
            expect(curveConfig.duration, equals(duration));
            expect(curveConfig.curve, isA<Curve>());
            expect(curveConfig.delay, equals(Duration.zero)); // Default delay
          }
        },
      );
    });
  });
}
