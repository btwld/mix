import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/internal/compare_mixin.dart';
import '../core/internal/constants.dart';
import '../core/spec.dart';
import '../core/style.dart';
import 'spring_curves.dart';

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

  factory CurveAnimationConfig.spring({
    double mass = 1.0,
    double stiffness = 180.0,
    double damping = 12.0,
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback? onEnd,
  }) {
    final curve = SpringCurve(
      mass: mass,
      stiffness: stiffness,
      damping: damping,
    );

    return CurveAnimationConfig(
      duration: duration,
      curve: curve,
      delay: delay,
      onEnd: onEnd,
    );
  }

  factory CurveAnimationConfig.springWithDampingRatio({
    double mass = 1.0,
    double stiffness = 180.0,
    double ratio = 0.8,
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback? onEnd,
  }) {
    final curve = SpringCurve.withDampingRatio(
      mass: mass,
      stiffness: stiffness,
      ratio: ratio,
    );

    return CurveAnimationConfig(
      duration: duration,
      curve: curve,
      delay: delay,
      onEnd: onEnd,
    );
  }

  factory CurveAnimationConfig.springDurationBased({
    Duration duration = const Duration(milliseconds: 500),
    double bounce = 0.0,
    Duration delay = Duration.zero,
    VoidCallback? onEnd,
  }) {
    return CurveAnimationConfig(
      duration: duration,
      curve: SpringCurve.withDurationAndBounce(
        duration: duration,
        bounce: bounce,
      ),
      delay: delay,
      onEnd: onEnd,
    );
  }

  Duration get totalDuration => duration + delay;

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

class PhaseAnimationConfig<T extends Spec<T>, U extends Style<T>>
    extends AnimationConfig {
  final List<U> styles;
  final List<CurveAnimationConfig> curveConfigs;
  final Listenable trigger;
  final VoidCallback? onEnd;

  const PhaseAnimationConfig({
    required this.styles,
    required this.curveConfigs,
    required this.trigger,
    this.onEnd,
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

class Keyframe<T> with Equatable {
  final Duration duration;
  final T value;
  final Curve curve;

  const Keyframe(this.value, this.duration, {required this.curve});

  const Keyframe.linear(T value, Duration duration)
    : this(value, duration, curve: Curves.linear);

  const Keyframe.decelerate(T value, Duration duration)
    : this(value, duration, curve: Curves.decelerate);

  const Keyframe.ease(T value, Duration duration)
    : this(value, duration, curve: Curves.ease);

  const Keyframe.easeIn(T value, Duration duration)
    : this(value, duration, curve: Curves.easeIn);

  const Keyframe.easeInToLinear(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInToLinear);

  const Keyframe.easeInSine(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInSine);

  const Keyframe.easeInQuad(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInQuad);

  const Keyframe.easeInCubic(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInCubic);

  const Keyframe.easeInQuart(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInQuart);

  const Keyframe.easeInQuint(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInQuint);

  const Keyframe.easeInExpo(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInExpo);

  const Keyframe.easeInCirc(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInCirc);

  const Keyframe.easeInBack(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInBack);

  const Keyframe.easeOut(T value, Duration duration)
    : this(value, duration, curve: Curves.easeOut);

  const Keyframe.linearToEaseOut(T value, Duration duration)
    : this(value, duration, curve: Curves.linearToEaseOut);

  const Keyframe.easeOutSine(T value, Duration duration)
    : this(value, duration, curve: Curves.easeOutSine);

  const Keyframe.easeOutQuad(T value, Duration duration)
    : this(value, duration, curve: Curves.easeOutQuad);

  const Keyframe.easeOutCubic(T value, Duration duration)
    : this(value, duration, curve: Curves.easeOutCubic);

  const Keyframe.easeOutQuart(T value, Duration duration)
    : this(value, duration, curve: Curves.easeOutQuart);

  const Keyframe.easeOutQuint(T value, Duration duration)
    : this(value, duration, curve: Curves.easeOutQuint);

  const Keyframe.easeOutExpo(T value, Duration duration)
    : this(value, duration, curve: Curves.easeOutExpo);

  const Keyframe.easeOutCirc(T value, Duration duration)
    : this(value, duration, curve: Curves.easeOutCirc);

  const Keyframe.easeOutBack(T value, Duration duration)
    : this(value, duration, curve: Curves.easeOutBack);

  const Keyframe.easeInOut(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInOut);

  const Keyframe.easeInOutSine(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInOutSine);

  const Keyframe.easeInOutQuad(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInOutQuad);

  const Keyframe.easeInOutCubic(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInOutCubic);

  const Keyframe.easeInOutQuart(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInOutQuart);

  const Keyframe.easeInOutQuint(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInOutQuint);

  const Keyframe.easeInOutExpo(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInOutExpo);

  const Keyframe.easeInOutCirc(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInOutCirc);

  const Keyframe.easeInOutBack(T value, Duration duration)
    : this(value, duration, curve: Curves.easeInOutBack);

  const Keyframe.fastOutSlowIn(T value, Duration duration)
    : this(value, duration, curve: Curves.fastOutSlowIn);

  const Keyframe.slowMiddle(T value, Duration duration)
    : this(value, duration, curve: Curves.slowMiddle);

  const Keyframe.bounceIn(T value, Duration duration)
    : this(value, duration, curve: Curves.bounceIn);

  const Keyframe.bounceOut(T value, Duration duration)
    : this(value, duration, curve: Curves.bounceOut);

  const Keyframe.bounceInOut(T value, Duration duration)
    : this(value, duration, curve: Curves.bounceInOut);

  const Keyframe.elasticIn(T value, Duration duration)
    : this(value, duration, curve: Curves.elasticIn);

  const Keyframe.elasticOut(T value, Duration duration)
    : this(value, duration, curve: Curves.elasticOut);

  const Keyframe.elasticInOut(T value, Duration duration)
    : this(value, duration, curve: Curves.elasticInOut);

  Keyframe.springWithBounce(T value, Duration duration, {double bounce = 0.0})
    : this(
        value,
        duration,
        curve: SpringCurve.withDurationAndBounce(
          duration: duration,
          bounce: bounce,
        ),
      );

  Keyframe.springWithDampingRatio(
    T value,
    Duration duration, {
    double mass = 1.0,
    double stiffness = 180.0,
    double ratio = 1.0,
  }) : this(
         value,
         duration,
         curve: SpringCurve.withDampingRatio(
           mass: mass,
           stiffness: stiffness,
           ratio: ratio,
         ),
       );

  Keyframe.spring(
    T value,
    Duration duration, {
    double mass = 1.0,
    double stiffness = 180.0,
    double damping = 12.0,
  }) : this(
         value,
         duration,
         curve: SpringCurve(mass: mass, stiffness: stiffness, damping: damping),
       );

  @override
  List<Object?> get props => [duration, value, curve];
}

typedef TweenBuilder<T> = Tween<T> Function({T? begin, T? end});

class KeyframeTrack<T> with Equatable {
  final String id;
  final List<Keyframe<T>> segments;
  final T initial;
  final TweenBuilder<T?> tweenBuilder;

  KeyframeTrack(
    this.id,
    this.segments, {
    required this.initial,
    TweenBuilder<T?>? tweenBuilder,
  }) : tweenBuilder = tweenBuilder ?? Tween<T>.new;

  Duration get totalDuration {
    return segments.fold(
      Duration.zero,
      (total, segment) => total + segment.duration,
    );
  }

  /// Creates a tween for interpolating between two values.
  /// Uses the custom tweenBuilder if provided, otherwise falls back to default behavior.
  Animatable<T?> createSequenceTween(Duration timelineDuration) {
    final items = <TweenSequenceItem<T?>>[];
    T current = initial;

    for (final segment in segments) {
      final end = segment.value;
      final tween = tweenBuilder(begin: current, end: end);

      items.add(
        TweenSequenceItem(
          tween: tween.chain(CurveTween(curve: segment.curve)),
          weight: segment.duration.inMilliseconds.toDouble(),
        ),
      );
      current = end;
    }

    return TweenSequence(items).chain(
      CurveTween(
        curve: Interval(
          0.0,
          totalDuration.inMilliseconds.toDouble() /
              timelineDuration.inMilliseconds,
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [id, segments, tweenBuilder];
}

typedef KeyframeStyleBuilder<T extends Spec<T>, U extends Style<T>> =
    U Function(KeyframeAnimationResult result, U style);

class KeyframeAnimationResult {
  final Map<String, Object> _result;

  const KeyframeAnimationResult(this._result);

  T get<T>(String key) {
    if (!_result.containsKey(key)) {
      throw ArgumentError('Key "$key" not found in KeyframeAnimationResult.');
    }
    final value = _result[key];
    if (value is! T) {
      throw StateError(
        'Value for key "$key" is not of expected type $T. '
        'Actual type: ${value.runtimeType}',
      );
    }

    return value;
  }
}

class KeyframeAnimationConfig<S extends Spec<S>> extends AnimationConfig
    with Equatable {
  final Listenable trigger;
  final List<KeyframeTrack> timeline;
  final KeyframeStyleBuilder<S, Style<S>> styleBuilder;
  final Style<S> initialStyle;

  const KeyframeAnimationConfig({
    required this.trigger,
    required this.timeline,
    required this.styleBuilder,
    required this.initialStyle,
  });

  @override
  List<Object?> get props => [trigger, timeline, styleBuilder];
}
