import 'package:flutter/widgets.dart';

import '../internal/constants.dart';

/// Configuration data for animated styles in the Mix framework.
///
/// This sealed class provides different types of animation configurations
/// for use with animated widgets and style transitions.
sealed class AnimationConfig {
  const AnimationConfig();

  /// Creates animation data with the specified parameters.
  static CurveAnimationConfig implicit({
    required Duration? duration,
    required Curve? curve,
    VoidCallback? onEnd,
  }) {
    return CurveAnimationConfig(
      duration: duration ?? kDefaultAnimationDuration,
      curve: curve ?? Curves.linear,
      onEnd: onEnd,
    );
  }

  /// Creates animation data with default settings.
  static CurveAnimationConfig withDefaults() {
    return const CurveAnimationConfig(
      duration: kDefaultAnimationDuration,
      curve: Curves.linear,
    );
  }



  /// Creates a spring animation configuration with standard spring physics.
  static SpringAnimationConfig spring({
    SpringDescription? spring,
    double mass = 1.0,
    double stiffness = 180.0,
    double damping = 12.0,
    VoidCallback? onEnd,
  }) => SpringAnimationConfig(
    spring:
        spring ??
        SpringDescription(mass: mass, stiffness: stiffness, damping: damping),
    onEnd: onEnd,
  );

  /// Creates a critically damped spring animation configuration.
  static SpringAnimationConfig criticallyDamped({
    double mass = 1.0,
    double stiffness = 180.0,
    VoidCallback? onEnd,
  }) => SpringAnimationConfig.criticallyDamped(
    mass: mass,
    stiffness: stiffness,
    onEnd: onEnd,
  );

  /// Creates an under-damped (bouncy) spring animation configuration.
  static SpringAnimationConfig underdamped({
    double mass = 1.0,
    double stiffness = 180.0,
    double ratio = 0.5,
    VoidCallback? onEnd,
  }) => SpringAnimationConfig.underdamped(
    mass: mass,
    stiffness: stiffness,
    ratio: ratio,
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
  int get hashCode => Object.hash(spring.mass, spring.stiffness, spring.damping);
}
