import 'package:flutter/widgets.dart';

import '../core/internal/constants.dart';

/// Configuration data for animated styles in the Mix framework.
///
/// This sealed class provides different types of animation configurations
/// for use with animated widgets and style transitions.
sealed class AnimationConfig {
  static const curve = CurveAnimationConfig.new;
  static const linear = CurveAnimationConfig.linear;
  static const decelerate = CurveAnimationConfig.decelerate;
  static const fastLinearToSlowEaseIn =
      CurveAnimationConfig.fastLinearToSlowEaseIn;
  static const fastEaseInToSlowEaseOut =
      CurveAnimationConfig.fastEaseInToSlowEaseOut;
  static const ease = CurveAnimationConfig.ease;
  static const easeIn = CurveAnimationConfig.easeIn;
  static const easeInToLinear = CurveAnimationConfig.easeInToLinear;
  static const easeInSine = CurveAnimationConfig.easeInSine;
  static const easeInQuad = CurveAnimationConfig.easeInQuad;
  static const easeInCubic = CurveAnimationConfig.easeInCubic;
  static const easeInQuart = CurveAnimationConfig.easeInQuart;
  static const easeInQuint = CurveAnimationConfig.easeInQuint;
  static const easeInExpo = CurveAnimationConfig.easeInExpo;
  static const easeInCirc = CurveAnimationConfig.easeInCirc;
  static const easeInBack = CurveAnimationConfig.easeInBack;
  static const easeOut = CurveAnimationConfig.easeOut;
  static const linearToEaseOut = CurveAnimationConfig.linearToEaseOut;
  static const easeOutSine = CurveAnimationConfig.easeOutSine;
  static const easeOutQuad = CurveAnimationConfig.easeOutQuad;
  static const easeOutCubic = CurveAnimationConfig.easeOutCubic;
  static const easeOutQuart = CurveAnimationConfig.easeOutQuart;
  static const easeOutQuint = CurveAnimationConfig.easeOutQuint;
  static const easeOutExpo = CurveAnimationConfig.easeOutExpo;
  static const easeOutCirc = CurveAnimationConfig.easeOutCirc;
  static const easeOutBack = CurveAnimationConfig.easeOutBack;
  static const easeInOut = CurveAnimationConfig.easeInOut;
  static const easeInOutSine = CurveAnimationConfig.easeInOutSine;
  static const easeInOutQuad = CurveAnimationConfig.easeInOutQuad;
  static const easeInOutCubic = CurveAnimationConfig.easeInOutCubic;
  static const easeInOutCubicEmphasized =
      CurveAnimationConfig.easeInOutCubicEmphasized;
  static const easeInOutQuart = CurveAnimationConfig.easeInOutQuart;
  static const easeInOutQuint = CurveAnimationConfig.easeInOutQuint;
  static const easeInOutExpo = CurveAnimationConfig.easeInOutExpo;
  static const easeInOutCirc = CurveAnimationConfig.easeInOutCirc;
  static const easeInOutBack = CurveAnimationConfig.easeInOutBack;
  static const fastOutSlowIn = CurveAnimationConfig.fastOutSlowIn;
  static const slowMiddle = CurveAnimationConfig.slowMiddle;
  static const bounceIn = CurveAnimationConfig.bounceIn;
  static const bounceOut = CurveAnimationConfig.bounceOut;
  static const bounceInOut = CurveAnimationConfig.bounceInOut;
  static const elasticIn = CurveAnimationConfig.elasticIn;
  static const elasticOut = CurveAnimationConfig.elasticOut;
  static const elasticInOut = CurveAnimationConfig.elasticInOut;

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
  static SpringAnimationConfig spring({
    double mass = 1.0,
    double stiffness = 180.0,
    double damping = 12.0,
    VoidCallback? onEnd,
  }) => SpringAnimationConfig(
    spring: SpringDescription(
      mass: mass,
      stiffness: stiffness,
      damping: damping,
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
  final VoidCallback? onEnd;

  const CurveAnimationConfig({
    required this.duration,
    required this.curve,
    this.onEnd,
  });

  const CurveAnimationConfig.linear({required this.duration, this.onEnd})
    : curve = Curves.linear;

  const CurveAnimationConfig.decelerate({required this.duration, this.onEnd})
    : curve = Curves.decelerate;

  const CurveAnimationConfig.fastLinearToSlowEaseIn({
    required this.duration,
    this.onEnd,
  }) : curve = Curves.fastLinearToSlowEaseIn;

  const CurveAnimationConfig.fastEaseInToSlowEaseOut({
    required this.duration,
    this.onEnd,
  }) : curve = Curves.fastEaseInToSlowEaseOut;

  const CurveAnimationConfig.ease({required this.duration, this.onEnd})
    : curve = Curves.ease;

  const CurveAnimationConfig.easeIn({required this.duration, this.onEnd})
    : curve = Curves.easeIn;

  const CurveAnimationConfig.easeInToLinear({
    required this.duration,
    this.onEnd,
  }) : curve = Curves.easeInToLinear;

  const CurveAnimationConfig.easeInSine({required this.duration, this.onEnd})
    : curve = Curves.easeInSine;

  const CurveAnimationConfig.easeInQuad({required this.duration, this.onEnd})
    : curve = Curves.easeInQuad;

  const CurveAnimationConfig.easeInCubic({required this.duration, this.onEnd})
    : curve = Curves.easeInCubic;

  const CurveAnimationConfig.easeInQuart({required this.duration, this.onEnd})
    : curve = Curves.easeInQuart;

  const CurveAnimationConfig.easeInQuint({required this.duration, this.onEnd})
    : curve = Curves.easeInQuint;

  const CurveAnimationConfig.easeInExpo({required this.duration, this.onEnd})
    : curve = Curves.easeInExpo;

  const CurveAnimationConfig.easeInCirc({required this.duration, this.onEnd})
    : curve = Curves.easeInCirc;

  const CurveAnimationConfig.easeInBack({required this.duration, this.onEnd})
    : curve = Curves.easeInBack;

  const CurveAnimationConfig.easeOut({required this.duration, this.onEnd})
    : curve = Curves.easeOut;

  const CurveAnimationConfig.linearToEaseOut({
    required this.duration,
    this.onEnd,
  }) : curve = Curves.linearToEaseOut;

  const CurveAnimationConfig.easeOutSine({required this.duration, this.onEnd})
    : curve = Curves.easeOutSine;

  const CurveAnimationConfig.easeOutQuad({required this.duration, this.onEnd})
    : curve = Curves.easeOutQuad;

  const CurveAnimationConfig.easeOutCubic({required this.duration, this.onEnd})
    : curve = Curves.easeOutCubic;

  const CurveAnimationConfig.easeOutQuart({required this.duration, this.onEnd})
    : curve = Curves.easeOutQuart;

  const CurveAnimationConfig.easeOutQuint({required this.duration, this.onEnd})
    : curve = Curves.easeOutQuint;

  const CurveAnimationConfig.easeOutExpo({required this.duration, this.onEnd})
    : curve = Curves.easeOutExpo;

  const CurveAnimationConfig.easeOutCirc({required this.duration, this.onEnd})
    : curve = Curves.easeOutCirc;

  const CurveAnimationConfig.easeOutBack({required this.duration, this.onEnd})
    : curve = Curves.easeOutBack;

  const CurveAnimationConfig.easeInOut({required this.duration, this.onEnd})
    : curve = Curves.easeInOut;

  const CurveAnimationConfig.easeInOutSine({required this.duration, this.onEnd})
    : curve = Curves.easeInOutSine;

  const CurveAnimationConfig.easeInOutQuad({required this.duration, this.onEnd})
    : curve = Curves.easeInOutQuad;

  const CurveAnimationConfig.easeInOutCubic({
    required this.duration,
    this.onEnd,
  }) : curve = Curves.easeInOutCubic;

  const CurveAnimationConfig.easeInOutCubicEmphasized({
    required this.duration,
    this.onEnd,
  }) : curve = Curves.easeInOutCubicEmphasized;

  const CurveAnimationConfig.easeInOutQuart({
    required this.duration,
    this.onEnd,
  }) : curve = Curves.easeInOutQuart;

  const CurveAnimationConfig.easeInOutQuint({
    required this.duration,
    this.onEnd,
  }) : curve = Curves.easeInOutQuint;

  const CurveAnimationConfig.easeInOutExpo({required this.duration, this.onEnd})
    : curve = Curves.easeInOutExpo;

  const CurveAnimationConfig.easeInOutCirc({required this.duration, this.onEnd})
    : curve = Curves.easeInOutCirc;

  const CurveAnimationConfig.easeInOutBack({required this.duration, this.onEnd})
    : curve = Curves.easeInOutBack;

  const CurveAnimationConfig.fastOutSlowIn({required this.duration, this.onEnd})
    : curve = Curves.fastOutSlowIn;

  const CurveAnimationConfig.slowMiddle({required this.duration, this.onEnd})
    : curve = Curves.slowMiddle;

  const CurveAnimationConfig.bounceIn({required this.duration, this.onEnd})
    : curve = Curves.bounceIn;

  const CurveAnimationConfig.bounceOut({required this.duration, this.onEnd})
    : curve = Curves.bounceOut;

  const CurveAnimationConfig.bounceInOut({required this.duration, this.onEnd})
    : curve = Curves.bounceInOut;

  const CurveAnimationConfig.elasticIn({required this.duration, this.onEnd})
    : curve = Curves.elasticIn;

  const CurveAnimationConfig.elasticOut({required this.duration, this.onEnd})
    : curve = Curves.elasticOut;

  const CurveAnimationConfig.elasticInOut({required this.duration, this.onEnd})
    : curve = Curves.elasticInOut;

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
