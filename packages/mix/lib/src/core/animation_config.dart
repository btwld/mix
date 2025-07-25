import 'package:flutter/widgets.dart';

import '../internal/constants.dart';
import 'spec.dart';
import 'style.dart';

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

  // Builder
  static AnimationBuilderConfig<S, V> builder<S extends Spec<S>, V>({
    required SpecStyle<S> Function(V) builder,
    Curve curve = Curves.linear,
    Duration delay = Duration.zero,
    Duration duration = kDefaultAnimationDuration,
  }) {
    return AnimationBuilderConfig(
      builder: builder,
      curve: curve,
      delay: delay,
      duration: duration,
    );
  }

  /// Creates an implicit animation configuration with linear curve.
  static CurveAnimationConfig linear(Duration duration) =>
      CurveAnimationConfig(duration: duration, curve: Curves.linear);

  /// Creates an implicit animation configuration with ease curve.
  static CurveAnimationConfig ease(Duration duration) =>
      CurveAnimationConfig(duration: duration, curve: Curves.ease);

  /// Creates an implicit animation configuration with ease-in curve.
  static CurveAnimationConfig easeIn(Duration duration) =>
      CurveAnimationConfig(duration: duration, curve: Curves.easeIn);

  /// Creates an implicit animation configuration with ease-out curve.
  static CurveAnimationConfig easeOut(Duration duration) =>
      CurveAnimationConfig(duration: duration, curve: Curves.easeOut);

  /// Creates an implicit animation configuration with ease-in-out curve.
  static CurveAnimationConfig easeInOut(Duration duration) =>
      CurveAnimationConfig(duration: duration, curve: Curves.easeInOut);

  /// Creates an implicit animation configuration with fast-out-slow-in curve.
  static CurveAnimationConfig fastOutSlowIn(Duration duration) =>
      CurveAnimationConfig(duration: duration, curve: Curves.fastOutSlowIn);

  /// Creates an implicit animation configuration with bounce-in curve.
  static CurveAnimationConfig bounceIn(Duration duration) =>
      CurveAnimationConfig(duration: duration, curve: Curves.bounceIn);

  /// Creates an implicit animation configuration with bounce-out curve.
  static CurveAnimationConfig bounceOut(Duration duration) =>
      CurveAnimationConfig(duration: duration, curve: Curves.bounceOut);

  /// Creates an implicit animation configuration with bounce-in-out curve.
  static CurveAnimationConfig bounceInOut(Duration duration) =>
      CurveAnimationConfig(duration: duration, curve: Curves.bounceInOut);

  /// Creates an implicit animation configuration with elastic-in curve.
  static CurveAnimationConfig elasticIn(Duration duration) =>
      CurveAnimationConfig(duration: duration, curve: Curves.elasticIn);

  /// Creates an implicit animation configuration with elastic-out curve.
  static CurveAnimationConfig elasticOut(Duration duration) =>
      CurveAnimationConfig(duration: duration, curve: Curves.elasticOut);

  /// Creates an implicit animation configuration with elastic-in-out curve.
  static CurveAnimationConfig elasticInOut(Duration duration) =>
      CurveAnimationConfig(duration: duration, curve: Curves.elasticInOut);

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

  /// Creates a controlled animation configuration for explicit animations.
  static ControlledAnimationConfig controller(AnimationController controller) =>
      ControlledAnimationConfig(controller: controller);
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

/// Type alias for backward compatibility
@Deprecated('Use CurveAnimationConfig instead')
typedef ImplicitAnimationConfig = CurveAnimationConfig;

/// Controlled animation configuration for explicit animations.
///
/// This configuration holds a reference to an AnimationController that you manage
/// yourself, providing full control over the animation lifecycle.
final class ControlledAnimationConfig extends AnimationConfig {
  final AnimationController controller;

  final VoidCallback? onEnd;

  const ControlledAnimationConfig({required this.controller, this.onEnd});

  /// Duration from the controller.
  Duration get duration => controller.duration ?? kDefaultAnimationDuration;

  /// Curve is not applicable for controlled animations - use CurvedAnimation instead.
  Curve get curve => Curves.linear;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ControlledAnimationConfig && other.controller == controller;
  }

  @override
  int get hashCode => controller.hashCode;
}

class AnimationBuilderConfig<S extends Spec<S>, V> extends AnimationConfig {
  final SpecStyle<S> Function(V) builder;
  final Curve curve;
  final Duration delay;
  final Duration duration;

  const AnimationBuilderConfig({
    required this.builder,
    this.curve = Curves.linear,
    this.delay = Duration.zero,
    this.duration = kDefaultAnimationDuration,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnimationBuilderConfig &&
        other.duration == duration &&
        other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(duration, curve);
}
