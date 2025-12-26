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

      group('delay', () {
        test('defaults to Duration.zero', () {
          final config = AnimationConfig.curve(
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
          );

          expect((config as CurveAnimationConfig).delay, Duration.zero);
        });

        test('stores custom delay value', () {
          final config = AnimationConfig.curve(
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
            delay: const Duration(milliseconds: 500),
          );

          expect(
            (config as CurveAnimationConfig).delay,
            const Duration(milliseconds: 500),
          );
        });

        test('delay is included in equality check', () {
          final config1 = AnimationConfig.curve(
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
            delay: const Duration(milliseconds: 100),
          );
          final config2 = AnimationConfig.curve(
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
            delay: const Duration(milliseconds: 200),
          );

          expect(config1, isNot(equals(config2)));
        });
      });

      group('totalDuration', () {
        test('equals duration when no delay', () {
          const config = CurveAnimationConfig(
            duration: Duration(seconds: 1),
            curve: Curves.linear,
          );

          expect(config.totalDuration, const Duration(seconds: 1));
        });

        test('equals duration plus delay', () {
          const config = CurveAnimationConfig(
            duration: Duration(milliseconds: 500),
            curve: Curves.linear,
            delay: Duration(milliseconds: 200),
          );

          expect(config.totalDuration, const Duration(milliseconds: 700));
        });
      });

      group('copyWith', () {
        test('returns new instance with same values when no args', () {
          const original = CurveAnimationConfig(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            delay: Duration(milliseconds: 100),
          );

          final copy = original.copyWith();

          expect(copy.duration, original.duration);
          expect(copy.curve, original.curve);
          expect(copy.delay, original.delay);
          expect(copy, isNot(same(original)));
        });

        test('updates duration only', () {
          const original = CurveAnimationConfig(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
          );

          final copy = original.copyWith(
            duration: const Duration(seconds: 2),
          );

          expect(copy.duration, const Duration(seconds: 2));
          expect(copy.curve, Curves.easeIn);
        });

        test('updates curve only', () {
          const original = CurveAnimationConfig(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
          );

          final copy = original.copyWith(curve: Curves.bounceOut);

          expect(copy.duration, const Duration(seconds: 1));
          expect(copy.curve, Curves.bounceOut);
        });

        test('updates delay only', () {
          const original = CurveAnimationConfig(
            duration: Duration(seconds: 1),
            curve: Curves.linear,
          );

          final copy = original.copyWith(
            delay: const Duration(milliseconds: 500),
          );

          expect(copy.delay, const Duration(milliseconds: 500));
        });

        test('updates onEnd callback', () {
          bool called = false;
          const original = CurveAnimationConfig(
            duration: Duration(seconds: 1),
            curve: Curves.linear,
          );

          final copy = original.copyWith(onEnd: () => called = true);

          expect(copy.onEnd, isNotNull);
          copy.onEnd!();
          expect(called, true);
        });
      });

      group('withDefaults', () {
        test('creates config with default duration', () {
          final config = AnimationConfig.withDefaults();

          expect(config.duration, const Duration(milliseconds: 200));
        });

        test('creates config with linear curve', () {
          final config = AnimationConfig.withDefaults();

          expect(config.curve, Curves.linear);
        });
      });

      group('spring factory methods', () {
        test('spring creates CurveAnimationConfig with SpringCurve', () {
          final config = CurveAnimationConfig.spring(
            const Duration(milliseconds: 500),
            mass: 1.0,
            stiffness: 200.0,
            damping: 15.0,
          );

          expect(config.duration, const Duration(milliseconds: 500));
          expect(config.curve, isNotNull);
        });

        test('springWithDampingRatio creates config with ratio', () {
          final config = CurveAnimationConfig.springWithDampingRatio(
            const Duration(milliseconds: 500),
            ratio: 0.8,
          );

          expect(config.duration, const Duration(milliseconds: 500));
        });

        test('springDurationBased creates config with bounce', () {
          final config = CurveAnimationConfig.springDurationBased(
            const Duration(milliseconds: 500),
            bounce: 0.3,
          );

          expect(config.duration, const Duration(milliseconds: 500));
        });
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
  });
}
