import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/internal/constants.dart';
import '../core/spec.dart';
import '../core/style.dart';
import '../core/widget_spec.dart';

/// Configuration data for animated styles in the Mix framework.
///
/// This sealed class provides different types of animation configurations
/// for use with animated widgets and style transitions.
sealed class AnimationConfig {
  factory AnimationConfig.curve({
    required Duration duration,
    required Curve curve,
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig(
    duration: duration,
    curve: curve,
    delay: delay,
    onEnd: onEnd,
  );

  factory AnimationConfig.decelerate(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.decelerate(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.fastLinearToSlowEaseIn(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.fastLinearToSlowEaseIn(
    duration,
    onEnd: onEnd,
    delay: delay,
  );

  factory AnimationConfig.fastEaseInToSlowEaseOut(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.fastEaseInToSlowEaseOut(
    duration,
    onEnd: onEnd,
    delay: delay,
  );

  factory AnimationConfig.ease(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.ease(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeIn(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeIn(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInToLinear(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) =>
      CurveAnimationConfig.easeInToLinear(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInSine(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInSine(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInQuad(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInQuad(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInCubic(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInCubic(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInQuart(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInQuart(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInQuint(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInQuint(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInExpo(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInExpo(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInCirc(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInCirc(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInBack(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInBack(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeOut(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOut(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.linearToEaseOut(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.linearToEaseOut(
    duration,
    onEnd: onEnd,
    delay: delay,
  );

  factory AnimationConfig.easeOutSine(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutSine(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeOutQuad(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutQuad(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeOutCubic(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutCubic(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeOutQuart(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutQuart(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeOutQuint(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutQuint(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeOutExpo(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutExpo(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeOutCirc(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutCirc(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeOutBack(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutBack(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInOut(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInOut(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInOutSine(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) =>
      CurveAnimationConfig.easeInOutSine(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInOutQuad(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) =>
      CurveAnimationConfig.easeInOutQuad(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInOutCubic(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) =>
      CurveAnimationConfig.easeInOutCubic(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInOutCubicEmphasized(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInOutCubicEmphasized(
    duration,
    onEnd: onEnd,
    delay: delay,
  );

  factory AnimationConfig.easeInOutQuart(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) =>
      CurveAnimationConfig.easeInOutQuart(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInOutQuint(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) =>
      CurveAnimationConfig.easeInOutQuint(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInOutExpo(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) =>
      CurveAnimationConfig.easeInOutExpo(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInOutCirc(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) =>
      CurveAnimationConfig.easeInOutCirc(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.easeInOutBack(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) =>
      CurveAnimationConfig.easeInOutBack(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.fastOutSlowIn(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) =>
      CurveAnimationConfig.fastOutSlowIn(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.slowMiddle(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.slowMiddle(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.bounceIn(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.bounceIn(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.bounceOut(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.bounceOut(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.bounceInOut(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.bounceInOut(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.elasticIn(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.elasticIn(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.elasticOut(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.elasticOut(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.elasticInOut(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.elasticInOut(duration, onEnd: onEnd, delay: delay);

  factory AnimationConfig.linear(
    Duration duration, {
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.linear(duration, onEnd: onEnd, delay: delay);

  const AnimationConfig();

  /// Creates a spring animation configuration with the specified parameters.

  /// Creates animation data with default settings.
  static CurveAnimationConfig withDefaults() {
    return const CurveAnimationConfig(
      duration: kDefaultAnimationDuration,
      curve: Curves.linear,
    );
  }

  /// Creates a spring animation configuration with standard spring physics.
  static SpringAnimationConfig springDescription({
    double mass = 1.0,
    double stiffness = 180.0,
    double damping = 12.0,
    // Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => SpringAnimationConfig(
    spring: SpringDescription(
      mass: mass,
      stiffness: stiffness,
      damping: damping,
    ),
    onEnd: onEnd,
  );

  static SpringAnimationConfig spring(
    Duration duration, {
    double bounce = 0,
    // Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => SpringAnimationConfig(
    spring: SpringDescription.withDurationAndBounce(
      duration: duration,
      bounce: bounce,
    ),
    onEnd: onEnd,
  );

  static SpringAnimationConfig springWithDampingRatio({
    double mass = 1.0,
    double stiffness = 180.0,
    double dampingRatio = 0.8,
    // Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) => SpringAnimationConfig(
    spring: SpringDescription.withDampingRatio(
      mass: mass,
      stiffness: stiffness,
      ratio: dampingRatio,
    ),
    onEnd: onEnd,
  );
}

/// Curve-based animation configuration with fixed duration.
///
/// This configuration provides duration, curve, and optional completion callback
/// for animations that follow a specific curve over a fixed time period.
final class CurveAnimationConfig extends AnimationConfig {
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final VoidCallback? onEnd;

  const CurveAnimationConfig({
    required this.duration,
    required this.curve,
    this.delay = Duration.zero,
    this.onEnd,
  });

  const CurveAnimationConfig.linear(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.linear;

  const CurveAnimationConfig.decelerate(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.decelerate;

  const CurveAnimationConfig.fastLinearToSlowEaseIn(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.fastLinearToSlowEaseIn;

  const CurveAnimationConfig.fastEaseInToSlowEaseOut(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.fastEaseInToSlowEaseOut;

  const CurveAnimationConfig.ease(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.ease;

  const CurveAnimationConfig.easeIn(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeIn;

  const CurveAnimationConfig.easeInToLinear(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInToLinear;

  const CurveAnimationConfig.easeInSine(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInSine;

  const CurveAnimationConfig.easeInQuad(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInQuad;

  const CurveAnimationConfig.easeInCubic(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInCubic;

  const CurveAnimationConfig.easeInQuart(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInQuart;

  const CurveAnimationConfig.easeInQuint(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInQuint;

  const CurveAnimationConfig.easeInExpo(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInExpo;

  const CurveAnimationConfig.easeInCirc(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInCirc;

  const CurveAnimationConfig.easeInBack(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInBack;

  const CurveAnimationConfig.easeOut(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeOut;

  const CurveAnimationConfig.linearToEaseOut(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.linearToEaseOut;

  const CurveAnimationConfig.easeOutSine(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeOutSine;

  const CurveAnimationConfig.easeOutQuad(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeOutQuad;

  const CurveAnimationConfig.easeOutCubic(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeOutCubic;

  const CurveAnimationConfig.easeOutQuart(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeOutQuart;

  const CurveAnimationConfig.easeOutQuint(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeOutQuint;

  const CurveAnimationConfig.easeOutExpo(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeOutExpo;

  const CurveAnimationConfig.easeOutCirc(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeOutCirc;

  const CurveAnimationConfig.easeOutBack(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeOutBack;

  const CurveAnimationConfig.easeInOut(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInOut;

  const CurveAnimationConfig.easeInOutSine(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInOutSine;

  const CurveAnimationConfig.easeInOutQuad(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInOutQuad;

  const CurveAnimationConfig.easeInOutCubic(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInOutCubic;

  const CurveAnimationConfig.easeInOutCubicEmphasized(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInOutCubicEmphasized;

  const CurveAnimationConfig.easeInOutQuart(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInOutQuart;
  const CurveAnimationConfig.easeInOutQuint(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInOutQuint;

  const CurveAnimationConfig.easeInOutExpo(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInOutExpo;

  const CurveAnimationConfig.easeInOutCirc(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInOutCirc;

  const CurveAnimationConfig.easeInOutBack(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.easeInOutBack;

  const CurveAnimationConfig.fastOutSlowIn(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.fastOutSlowIn;

  const CurveAnimationConfig.slowMiddle(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.slowMiddle;

  const CurveAnimationConfig.bounceIn(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.bounceIn;

  const CurveAnimationConfig.bounceOut(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.bounceOut;

  const CurveAnimationConfig.bounceInOut(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.bounceInOut;

  const CurveAnimationConfig.elasticIn(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.elasticIn;

  const CurveAnimationConfig.elasticOut(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.elasticOut;

  const CurveAnimationConfig.elasticInOut(
    this.duration, {
    this.onEnd,
    this.delay = Duration.zero,
  }) : curve = Curves.elasticInOut;

  CurveAnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig(
    duration: duration ?? this.duration,
    curve: curve ?? this.curve,
    delay: delay ?? this.delay,
    onEnd: onEnd ?? this.onEnd,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurveAnimationConfig &&
        other.duration == duration &&
        other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(duration, curve);
}

/// Spring-based animation configuration for physics-based animations.
///
/// This configuration provides spring physics parameters for animations
/// that follow natural physics behavior rather than fixed curves.
final class SpringAnimationConfig extends AnimationConfig {
  final SpringDescription spring;
  final VoidCallback? onEnd;

  const SpringAnimationConfig({required this.spring, this.onEnd});

  /// Creates a spring configuration with standard parameters.
  SpringAnimationConfig.standard({
    double mass = 1.0,
    double stiffness = 180.0,
    double damping = 12.0,
    this.onEnd,
  }) : spring = SpringDescription(
         mass: mass,
         stiffness: stiffness,
         damping: damping,
       );

  /// Creates a spring configuration with standard parameters.
  SpringAnimationConfig.withDurationAndBounce({
    Duration duration = const Duration(milliseconds: 500),
    double bounce = 0.0,
    this.onEnd,
  }) : spring = SpringDescription.withDurationAndBounce(
         duration: duration,
         bounce: bounce,
       );

  /// Creates a critically damped spring configuration.
  SpringAnimationConfig.criticallyDamped({
    double mass = 1.0,
    double stiffness = 180.0,
    this.onEnd,
  }) : spring = SpringDescription.withDampingRatio(
         mass: mass,
         stiffness: stiffness,
         ratio: 1.0,
       );

  /// Creates an under-damped (bouncy) spring configuration.
  SpringAnimationConfig.underdamped({
    double mass = 1.0,
    double stiffness = 180.0,
    double ratio = 0.5,
    this.onEnd,
  }) : spring = SpringDescription.withDampingRatio(
         mass: mass,
         stiffness: stiffness,
         ratio: ratio,
       );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpringAnimationConfig &&
        other.spring.mass == spring.mass &&
        other.spring.stiffness == spring.stiffness &&
        other.spring.damping == spring.damping;
  }

  @override
  int get hashCode =>
      Object.hash(spring.mass, spring.stiffness, spring.damping);
}

sealed class PhaseAnimationMode {
  /// The animation will start from the first style go through all the styles and end with the first style.
  static const simpleLoop = SimpleLoopPhaseAnimationMode();

  /// The animation will start from the first style and end with the last style.
  static const oneShot = OneShotPhaseAnimationMode();

  const PhaseAnimationMode();

  TweenSequence<S?> createTweenSequence<S extends Spec<S>>(
    List<S> specs,
    List<CurveAnimationConfig> configs,
  );

  TweenSequenceItem<S?> createTweenSequenceItem<S extends Spec<S>>({
    required S begin,
    required S end,
    required CurveAnimationConfig config,
  }) {
    final tween = SpecTween<S>(begin: begin, end: end);

    return TweenSequenceItem(
      tween: tween.chain(CurveTween(curve: config.curve)),
      weight: config.duration.inMilliseconds.toDouble(),
    );
  }
}

class SimpleLoopPhaseAnimationMode extends PhaseAnimationMode {
  const SimpleLoopPhaseAnimationMode();

  @override
  TweenSequence<S?> createTweenSequence<S extends Spec<S>>(
    List<S> specs,
    List<CurveAnimationConfig> configs,
  ) {
    final items = <TweenSequenceItem<S?>>[];
    for (int i = 0; i < specs.length; i++) {
      final currentIndex = i % specs.length;
      final nextIndex = (i + 1) % specs.length;

      if (configs[currentIndex].delay > Duration.zero) {
        items.add(
          TweenSequenceItem(
            tween: ConstantTween(specs[currentIndex]),
            weight: configs[currentIndex].delay.inMilliseconds.toDouble(),
          ),
        );
      }

      items.add(
        createTweenSequenceItem(
          begin: specs[currentIndex],
          end: specs[nextIndex],
          config: configs[currentIndex],
        ),
      );
    }

    return TweenSequence(items);
  }
}

class OneShotPhaseAnimationMode extends PhaseAnimationMode {
  const OneShotPhaseAnimationMode();

  @override
  TweenSequence<S?> createTweenSequence<S extends Spec<S>>(
    List<S> specs,
    List<CurveAnimationConfig> configs,
  ) {
    final items = <TweenSequenceItem<S?>>[];
    for (int i = 0; i < specs.length - 1; i++) {
      final tween = SpecTween<S>(begin: specs[i], end: specs[i + 1]);
      final weight = configs[i].duration.inMilliseconds.toDouble();

      if (configs[i].delay > Duration.zero) {
        items.add(
          TweenSequenceItem(
            tween: ConstantTween(specs[i]),
            weight: configs[i].delay.inMilliseconds.toDouble(),
          ),
        );
      }

      items.add(
        TweenSequenceItem(
          tween: tween.chain(CurveTween(curve: configs[i].curve)),
          weight: weight,
        ),
      );
    }

    return TweenSequence(items);
  }
}

class PhaseAnimationConfig<T extends WidgetSpec<T>, U extends Style<T>>
    extends AnimationConfig {
  final List<U> styles;
  final List<CurveAnimationConfig> curveConfigs;
  final Listenable trigger;
  final VoidCallback? onEnd;
  final PhaseAnimationMode mode;

  const PhaseAnimationConfig({
    required this.styles,
    required this.curveConfigs,
    required this.trigger,
    this.onEnd,
    this.mode = PhaseAnimationMode.simpleLoop,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhaseAnimationConfig &&
        trigger == other.trigger &&
        listEquals(styles, other.styles) &&
        listEquals(curveConfigs, other.curveConfigs);
  }

  @override
  int get hashCode => Object.hash(styles, trigger, curveConfigs);
}
