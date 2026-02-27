import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/animation/animation_config.dart';

import '../../helpers/testing_utils.dart';

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

          final copy = original.copyWith(duration: const Duration(seconds: 2));

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
          final config = AnimationConfig.withDefaults() as CurveAnimationConfig;

          expect(config.duration, const Duration(milliseconds: 200));
        });

        test('creates config with linear curve', () {
          final config = AnimationConfig.withDefaults() as CurveAnimationConfig;

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
        final config =
            AnimationConfig.springDescription(
                  mass: 2.0,
                  stiffness: 100.0,
                  damping: 10.0,
                )
                as SpringAnimationConfig;

        expect(config, isA<SpringAnimationConfig>());
        expect(config.spring.mass, 2.0);
        expect(config.spring.stiffness, 100.0);
        expect(config.spring.damping, 10.0);
      });

      test('creates with custom SpringDescription', () {
        final config =
            AnimationConfig.springDescription(
                  mass: 3.0,
                  stiffness: 150.0,
                  damping: 15.0,
                )
                as SpringAnimationConfig;

        expect(config.spring.mass, 3.0);
        expect(config.spring.stiffness, 150.0);
        expect(config.spring.damping, 15.0);
      });

      test('creates critically damped spring', () {
        final config =
            AnimationConfig.springDescription(mass: 2.0, stiffness: 200.0)
                as SpringAnimationConfig;

        expect(config, isA<SpringAnimationConfig>());
        expect(config.spring.mass, 2.0);
        expect(config.spring.stiffness, 200.0);
      });

      test('creates underdamped spring', () {
        final config =
            AnimationConfig.springDescription(mass: 1.5, stiffness: 250.0)
                as SpringAnimationConfig;

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
        final config =
            AnimationConfig.springDescription(onEnd: () => called = true)
                as SpringAnimationConfig;

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

      group('AnimationConfig factory wrappers', () {
        test('spring creates SpringAnimationConfig', () {
          final config = AnimationConfig.spring(
            const Duration(milliseconds: 500),
          );

          expect(config, isA<SpringAnimationConfig>());
        });

        test('springWithDampingRatio creates SpringAnimationConfig', () {
          final config = AnimationConfig.springWithDampingRatio(
            dampingRatio: 0.5,
          );

          expect(config, isA<SpringAnimationConfig>());
        });

        test('springDurationBased creates CurveAnimationConfig', () {
          final config = AnimationConfig.springDurationBased(
            const Duration(milliseconds: 500),
            bounce: 0.6,
          );

          expect(config, isA<CurveAnimationConfig>());
        });

        test('curveSpring creates CurveAnimationConfig', () {
          final config = AnimationConfig.curveSpring(
            const Duration(milliseconds: 500),
          );

          expect(config, isA<CurveAnimationConfig>());
        });

        test('curveSpringWithDampingRatio creates CurveAnimationConfig', () {
          final config = AnimationConfig.curveSpringWithDampingRatio(
            const Duration(milliseconds: 500),
          );

          expect(config, isA<CurveAnimationConfig>());
        });

        test('springStandard creates SpringAnimationConfig', () {
          final config = AnimationConfig.springStandard();

          expect(config, isA<SpringAnimationConfig>());
        });

        test('springWithDurationAndBounce creates SpringAnimationConfig', () {
          final config = AnimationConfig.springWithDurationAndBounce();

          expect(config, isA<SpringAnimationConfig>());
        });

        test('springCriticallyDamped creates SpringAnimationConfig', () {
          final config = AnimationConfig.springCriticallyDamped();

          expect(config, isA<SpringAnimationConfig>());
        });

        test('springUnderdamped creates SpringAnimationConfig', () {
          final config = AnimationConfig.springUnderdamped();

          expect(config, isA<SpringAnimationConfig>());
        });

        test('spring propagates duration and bounce parameters', () {
          final config = AnimationConfig.spring(
            const Duration(milliseconds: 750),
            bounce: 0.4,
          ) as SpringAnimationConfig;

          expect(config.spring, isNotNull);
          // SpringDescription.withDurationAndBounce uses the duration and bounce
          // to compute physics params, so verify the spring object was created
          expect(config.spring.mass, isPositive);
          expect(config.spring.stiffness, isPositive);
        });

        test('springWithDampingRatio propagates parameters', () {
          final config = AnimationConfig.springWithDampingRatio(
            mass: 2.0,
            stiffness: 300.0,
            dampingRatio: 0.5,
          ) as SpringAnimationConfig;

          expect(config.spring.mass, 2.0);
          expect(config.spring.stiffness, 300.0);
        });

        test('springDurationBased propagates duration', () {
          final config = AnimationConfig.springDurationBased(
            const Duration(milliseconds: 600),
            bounce: 0.3,
          ) as CurveAnimationConfig;

          expect(config.duration, const Duration(milliseconds: 600));
        });

        test('curveSpring propagates duration and physics params', () {
          final config = AnimationConfig.curveSpring(
            const Duration(milliseconds: 400),
            mass: 2.0,
            stiffness: 200.0,
            damping: 15.0,
          ) as CurveAnimationConfig;

          expect(config.duration, const Duration(milliseconds: 400));
        });
      });
    });
  });

  group('PhaseAnimationConfig', () {
    test('stores all required parameters', () {
      final trigger = ValueNotifier(false);
      final styles = [MockStyle(0.0), MockStyle(1.0)];
      final curveConfigs = [
        const CurveAnimationConfig(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeIn,
        ),
        const CurveAnimationConfig(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        ),
      ];

      final config = PhaseAnimationConfig<MockSpec<double>, MockStyle<double>>(
        styles: styles,
        curveConfigs: curveConfigs,
        trigger: trigger,
      );

      expect(config.styles, styles);
      expect(config.curveConfigs, curveConfigs);
      expect(config.trigger, trigger);
      expect(config.onEnd, isNull);

      trigger.dispose();
    });

    test('stores optional onEnd callback', () {
      var called = false;
      final trigger = ValueNotifier(false);

      final config = PhaseAnimationConfig<MockSpec<double>, MockStyle<double>>(
        styles: [MockStyle(0.0)],
        curveConfigs: [
          const CurveAnimationConfig(
            duration: Duration(milliseconds: 100),
            curve: Curves.linear,
          ),
        ],
        trigger: trigger,
        onEnd: () => called = true,
      );

      expect(config.onEnd, isNotNull);
      config.onEnd!();
      expect(called, true);

      trigger.dispose();
    });

    test('props contains styles, trigger, and curveConfigs for equality', () {
      final trigger = ValueNotifier(false);
      final styles = [MockStyle(0.0)];
      final curveConfigs = [
        const CurveAnimationConfig(
          duration: Duration(milliseconds: 100),
          curve: Curves.linear,
        ),
      ];

      final config = PhaseAnimationConfig<MockSpec<double>, MockStyle<double>>(
        styles: styles,
        curveConfigs: curveConfigs,
        trigger: trigger,
      );

      expect(config.props, contains(styles));
      expect(config.props, contains(trigger));
      expect(config.props, contains(curveConfigs));

      trigger.dispose();
    });

    test('equal configs have same props', () {
      final trigger = ValueNotifier(false);
      final styles = [MockStyle(0.0)];
      final curveConfigs = [
        const CurveAnimationConfig(
          duration: Duration(milliseconds: 100),
          curve: Curves.linear,
        ),
      ];

      final config1 = PhaseAnimationConfig<MockSpec<double>, MockStyle<double>>(
        styles: styles,
        curveConfigs: curveConfigs,
        trigger: trigger,
      );

      final config2 = PhaseAnimationConfig<MockSpec<double>, MockStyle<double>>(
        styles: styles,
        curveConfigs: curveConfigs,
        trigger: trigger,
      );

      expect(config1.props, equals(config2.props));

      trigger.dispose();
    });

    test('different triggers produce different configs', () {
      final trigger1 = ValueNotifier(false);
      final trigger2 = ValueNotifier(false);
      final styles = [MockStyle(0.0)];
      final curveConfigs = [
        const CurveAnimationConfig(
          duration: Duration(milliseconds: 100),
          curve: Curves.linear,
        ),
      ];

      final config1 = PhaseAnimationConfig<MockSpec<double>, MockStyle<double>>(
        styles: styles,
        curveConfigs: curveConfigs,
        trigger: trigger1,
      );

      final config2 = PhaseAnimationConfig<MockSpec<double>, MockStyle<double>>(
        styles: styles,
        curveConfigs: curveConfigs,
        trigger: trigger2,
      );

      expect(config1, isNot(equals(config2)));

      trigger1.dispose();
      trigger2.dispose();
    });
  });
}
