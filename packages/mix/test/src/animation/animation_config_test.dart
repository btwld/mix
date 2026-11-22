import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

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
        test('spring forwards duration, bounce, and onEnd', () {
          var called = false;
          final config =
              AnimationConfig.spring(
                    const Duration(milliseconds: 750),
                    bounce: 0.4,
                    onEnd: () => called = true,
                  )
                  as SpringAnimationConfig;

          final expected = SpringDescription.withDurationAndBounce(
            duration: const Duration(milliseconds: 750),
            bounce: 0.4,
          );
          expect(config.spring.mass, expected.mass);
          expect(config.spring.stiffness, expected.stiffness);
          expect(config.spring.damping, expected.damping);
          config.onEnd!();
          expect(called, true);
        });

        test('springWithDampingRatio forwards parameters and onEnd', () {
          var called = false;
          final config =
              AnimationConfig.springWithDampingRatio(
                    mass: 2.0,
                    stiffness: 300.0,
                    dampingRatio: 0.5,
                    onEnd: () => called = true,
                  )
                  as SpringAnimationConfig;

          final expected = SpringDescription.withDampingRatio(
            mass: 2.0,
            stiffness: 300.0,
            ratio: 0.5,
          );
          expect(config.spring.mass, 2.0);
          expect(config.spring.stiffness, 300.0);
          expect(config.spring.damping, expected.damping);
          config.onEnd!();
          expect(called, true);
        });

        test('springDurationBased forwards duration, delay, and onEnd', () {
          var called = false;
          final config =
              AnimationConfig.springDurationBased(
                    const Duration(milliseconds: 600),
                    bounce: 0.3,
                    delay: const Duration(milliseconds: 50),
                    onEnd: () => called = true,
                  )
                  as CurveAnimationConfig;

          expect(config.duration, const Duration(milliseconds: 600));
          expect(config.delay, const Duration(milliseconds: 50));
          expect(config.curve, isA<SpringCurve>());
          config.onEnd!();
          expect(called, true);
        });

        test('curveSpring forwards duration, physics params, and onEnd', () {
          var called = false;
          final config =
              AnimationConfig.curveSpring(
                    const Duration(milliseconds: 400),
                    mass: 2.0,
                    stiffness: 200.0,
                    damping: 15.0,
                    delay: const Duration(milliseconds: 25),
                    onEnd: () => called = true,
                  )
                  as CurveAnimationConfig;

          expect(config.duration, const Duration(milliseconds: 400));
          expect(config.delay, const Duration(milliseconds: 25));
          expect(
            config.curve,
            equals(SpringCurve(mass: 2.0, stiffness: 200.0, damping: 15.0)),
          );
          config.onEnd!();
          expect(called, true);
        });

        test(
          'curveSpringWithDampingRatio forwards duration, params, and onEnd',
          () {
            var called = false;
            final config =
                AnimationConfig.curveSpringWithDampingRatio(
                      const Duration(milliseconds: 350),
                      mass: 2.0,
                      stiffness: 250.0,
                      ratio: 0.6,
                      delay: const Duration(milliseconds: 10),
                      onEnd: () => called = true,
                    )
                    as CurveAnimationConfig;

            expect(config.duration, const Duration(milliseconds: 350));
            expect(config.delay, const Duration(milliseconds: 10));
            expect(
              config.curve,
              equals(
                SpringCurve.withDampingRatio(
                  mass: 2.0,
                  stiffness: 250.0,
                  ratio: 0.6,
                ),
              ),
            );
            config.onEnd!();
            expect(called, true);
          },
        );

        test('springCriticallyDamped forwards parameters and onEnd', () {
          var called = false;
          final config =
              AnimationConfig.springCriticallyDamped(
                    mass: 2.0,
                    stiffness: 200.0,
                    onEnd: () => called = true,
                  )
                  as SpringAnimationConfig;

          final expected = SpringDescription.withDampingRatio(
            mass: 2.0,
            stiffness: 200.0,
            ratio: 1.0,
          );
          expect(config.spring.mass, 2.0);
          expect(config.spring.stiffness, 200.0);
          expect(config.spring.damping, expected.damping);
          config.onEnd!();
          expect(called, true);
        });

        test('springUnderdamped forwards parameters and onEnd', () {
          var called = false;
          final config =
              AnimationConfig.springUnderdamped(
                    mass: 2.0,
                    stiffness: 200.0,
                    ratio: 0.4,
                    onEnd: () => called = true,
                  )
                  as SpringAnimationConfig;

          final expected = SpringDescription.withDampingRatio(
            mass: 2.0,
            stiffness: 200.0,
            ratio: 0.4,
          );
          expect(config.spring.mass, 2.0);
          expect(config.spring.stiffness, 200.0);
          expect(config.spring.damping, expected.damping);
          config.onEnd!();
          expect(called, true);
        });

        test('curve-spring configs with identical args are equal', () {
          final a = AnimationConfig.springDurationBased(
            const Duration(milliseconds: 600),
            bounce: 0.3,
          );
          final b = AnimationConfig.springDurationBased(
            const Duration(milliseconds: 600),
            bounce: 0.3,
          );

          expect(a, equals(b));
          expect(a.hashCode, equals(b.hashCode));
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

  group('reversible', () {
    const curve = CurveAnimationConfig.linear(Duration(milliseconds: 100));
    const exit = CurveAnimationConfig.easeOut(Duration(milliseconds: 200));

    test('returns a curve or spring config with the forward values', () {
      void onEnd() {}
      final forward = CurveAnimationConfig.easeIn(
        const Duration(milliseconds: 120),
        delay: const Duration(milliseconds: 10),
        onEnd: onEnd,
      );
      final config = AnimationConfig.reversible(forward, reverse: exit);

      expect(config, isA<CurveAnimationConfig>());
      config as CurveAnimationConfig;
      expect(config.duration, const Duration(milliseconds: 120));
      expect(config.curve, Curves.easeIn);
      expect(config.delay, const Duration(milliseconds: 10));
      expect(config.onEnd, onEnd);
      expect(config.totalDuration, const Duration(milliseconds: 130));
      expect(AnimationConfig.reverseOf(config), same(exit));

      final spring = SpringAnimationConfig.standard(onEnd: onEnd);
      final springConfig = AnimationConfig.reversible(spring, reverse: exit);

      expect(springConfig, isA<SpringAnimationConfig>());
      springConfig as SpringAnimationConfig;
      expect(springConfig.spring, spring.spring);
      expect(springConfig.onEnd, onEnd);
      expect(AnimationConfig.reverseOf(springConfig), same(exit));
    });

    test('leaves plain configs as they were in 2.4.0', () {
      final spring = SpringAnimationConfig.standard();

      expect(curve.props, [
        const Duration(milliseconds: 100),
        Curves.linear,
        Duration.zero,
      ]);
      expect(spring.props, [
        spring.spring.mass,
        spring.spring.stiffness,
        spring.spring.damping,
      ]);
      expect(AnimationConfig.reverseOf(curve), isNull);
      expect(AnimationConfig.reverseOf(spring), isNull);
      expect(AnimationConfig.reverseOf(null), isNull);
      expect(_kind(curve), 'curve');
      expect(_kind(AnimationConfig.reversible(curve, reverse: exit)), 'curve');
      expect(
        _kind(AnimationConfig.reversible(spring, reverse: exit)),
        'spring',
      );
      expect(const _CurveAdapter(curve).duration, curve.duration);
    });

    test('takes part in equality', () {
      final config = AnimationConfig.reversible(curve, reverse: exit);
      final same = AnimationConfig.reversible(
        const CurveAnimationConfig.linear(Duration(milliseconds: 100)),
        reverse: const CurveAnimationConfig.easeOut(
          Duration(milliseconds: 200),
        ),
      );

      expect(config, same);
      expect(config.hashCode, same.hashCode);
      expect(config, isNot(equals(curve)));
      expect(curve, isNot(equals(config)));
      expect(
        config,
        isNot(equals(AnimationConfig.reversible(curve, reverse: curve))),
      );
    });

    test('copyWith preserves reverse', () {
      final config =
          AnimationConfig.reversible(curve, reverse: exit)
              as CurveAnimationConfig;
      final copy = config.copyWith(duration: const Duration(seconds: 1));

      expect(AnimationConfig.reverseOf(copy), same(exit));
      expect(copy.duration, const Duration(seconds: 1));
      expect(config.copyWith(), config);
    });

    test('replaces a prior reverse', () {
      final first = AnimationConfig.reversible(curve, reverse: exit);
      final second = AnimationConfig.reversible(first, reverse: curve);

      expect(AnimationConfig.reverseOf(second), same(curve));
      expect(second, AnimationConfig.reversible(curve, reverse: curve));
    });

    test('strips a nested reverse', () {
      final nested = AnimationConfig.reversible(exit, reverse: curve);
      final config = AnimationConfig.reversible(curve, reverse: nested);
      final reverse = AnimationConfig.reverseOf(config);

      expect(reverse, same(exit));
      expect(AnimationConfig.reverseOf(reverse), isNull);

      final spring = SpringAnimationConfig.standard();
      final springNested = AnimationConfig.reversible(spring, reverse: curve);
      final springConfig = AnimationConfig.reversible(
        curve,
        reverse: springNested,
      );

      expect(AnimationConfig.reverseOf(springConfig), same(spring));
    });

    test('keeps the behavior of a curve subclass in both directions', () {
      const slow = _SlowCurve();
      final config = AnimationConfig.reversible(slow, reverse: slow);

      expect(
        (config as CurveAnimationConfig).totalDuration,
        const Duration(milliseconds: 200),
      );
      expect(AnimationConfig.reverseOf(config), same(slow));
    });

    test('rejects timeline configs in either direction', () {
      const phase = PhaseAnimationConfig<BoxSpec, BoxStyler>(
        styles: [BoxStyler.create()],
        curveConfigs: [curve],
        trigger: null,
      );
      final keyframe = KeyframeAnimationConfig<BoxSpec>(
        trigger: null,
        timeline: [],
        styleBuilder: (_, style) => style,
        initialStyle: const BoxStyler.create(),
      );
      for (final timeline in <AnimationConfig>[phase, keyframe]) {
        expect(
          () => AnimationConfig.reversible(timeline, reverse: curve),
          throwsA(
            isA<ArgumentError>().having((e) => e.name, 'name', 'forward'),
          ),
        );
        expect(
          () => AnimationConfig.reversible(curve, reverse: timeline),
          throwsA(
            isA<ArgumentError>().having((e) => e.name, 'name', 'reverse'),
          ),
        );
      }
    });
  });
}

/// An exhaustive switch over the four 2.4.0 subtypes. It must keep compiling.
String _kind(AnimationConfig config) => switch (config) {
  CurveAnimationConfig() => 'curve',
  SpringAnimationConfig() => 'spring',
  PhaseAnimationConfig() => 'phase',
  KeyframeAnimationConfig() => 'keyframe',
};

/// Reports twice its nominal duration, as a downstream subclass might.
class _SlowCurve extends CurveAnimationConfig {
  const _SlowCurve()
    : super(duration: const Duration(milliseconds: 100), curve: Curves.linear);

  @override
  Duration get totalDuration => const Duration(milliseconds: 200);
}

/// Implements every member `CurveAnimationConfig` had in 2.4.0 and nothing
/// else. A new instance member on the class would stop this compiling.
class _CurveAdapter implements CurveAnimationConfig {
  const _CurveAdapter(this._inner);

  final CurveAnimationConfig _inner;

  @override
  Duration get duration => _inner.duration;
  @override
  Curve get curve => _inner.curve;
  @override
  Duration get delay => _inner.delay;
  @override
  VoidCallback? get onEnd => _inner.onEnd;
  @override
  Duration get totalDuration => _inner.totalDuration;
  @override
  CurveAnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onEnd,
  }) => _inner.copyWith(
    duration: duration,
    curve: curve,
    delay: delay,
    onEnd: onEnd,
  );
  @override
  List<Object?> get props => _inner.props;
  @override
  bool get stringify => _inner.stringify;
  @override
  // ignore: invalid_use_of_visible_for_testing_member
  Map<String, String> getDiff(Equatable other) => _inner.getDiff(other);
}
