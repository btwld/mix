import 'package:flutter/animation.dart';

import '../internal/constants.dart';

/// Configuration data for animated styles in the Mix framework.
///
/// This sealed class provides different types of animation configurations
/// for use with animated widgets and style transitions.
sealed class AnimationConfig {
  const AnimationConfig();

  /// Creates animation data with the specified parameters.
  static ImplicitAnimationConfig implicit({
    required Duration? duration,
    required Curve? curve,
    VoidCallback? onEnd,
  }) {
    return ImplicitAnimationConfig(
      duration: duration ?? kDefaultAnimationDuration,
      curve: curve ?? Curves.linear,
      onEnd: onEnd,
    );
  }

  /// Creates animation data with default settings.
  static ImplicitAnimationConfig withDefaults() {
    return const ImplicitAnimationConfig(
      duration: kDefaultAnimationDuration,
      curve: Curves.linear,
    );
  }

  /// Creates an implicit animation configuration with linear curve.
  static ImplicitAnimationConfig linear(Duration duration) =>
      ImplicitAnimationConfig(duration: duration, curve: Curves.linear);

  /// Creates an implicit animation configuration with ease curve.
  static ImplicitAnimationConfig ease(Duration duration) =>
      ImplicitAnimationConfig(duration: duration, curve: Curves.ease);

  /// Creates an implicit animation configuration with ease-in curve.
  static ImplicitAnimationConfig easeIn(Duration duration) =>
      ImplicitAnimationConfig(duration: duration, curve: Curves.easeIn);

  /// Creates an implicit animation configuration with ease-out curve.
  static ImplicitAnimationConfig easeOut(Duration duration) =>
      ImplicitAnimationConfig(duration: duration, curve: Curves.easeOut);

  /// Creates an implicit animation configuration with ease-in-out curve.
  static ImplicitAnimationConfig easeInOut(Duration duration) =>
      ImplicitAnimationConfig(duration: duration, curve: Curves.easeInOut);

  /// Creates an implicit animation configuration with fast-out-slow-in curve.
  static ImplicitAnimationConfig fastOutSlowIn(Duration duration) =>
      ImplicitAnimationConfig(duration: duration, curve: Curves.fastOutSlowIn);

  /// Creates an implicit animation configuration with bounce-in curve.
  static ImplicitAnimationConfig bounceIn(Duration duration) =>
      ImplicitAnimationConfig(duration: duration, curve: Curves.bounceIn);

  /// Creates an implicit animation configuration with bounce-out curve.
  static ImplicitAnimationConfig bounceOut(Duration duration) =>
      ImplicitAnimationConfig(duration: duration, curve: Curves.bounceOut);

  /// Creates an implicit animation configuration with bounce-in-out curve.
  static ImplicitAnimationConfig bounceInOut(Duration duration) =>
      ImplicitAnimationConfig(duration: duration, curve: Curves.bounceInOut);

  /// Creates an implicit animation configuration with elastic-in curve.
  static ImplicitAnimationConfig elasticIn(Duration duration) =>
      ImplicitAnimationConfig(duration: duration, curve: Curves.elasticIn);

  /// Creates an implicit animation configuration with elastic-out curve.
  static ImplicitAnimationConfig elasticOut(Duration duration) =>
      ImplicitAnimationConfig(duration: duration, curve: Curves.elasticOut);

  /// Creates an implicit animation configuration with elastic-in-out curve.
  static ImplicitAnimationConfig elasticInOut(Duration duration) =>
      ImplicitAnimationConfig(duration: duration, curve: Curves.elasticInOut);

  /// Creates a controlled animation configuration for explicit animations.
  static ControlledAnimationConfig controller(AnimationController controller) =>
      ControlledAnimationConfig(controller: controller);
}

/// Implicit animation configuration for Flutter's ImplicitlyAnimatedWidget pattern.
///
/// This configuration provides duration, curve, and optional completion callback
/// for implicit animations where the framework manages the AnimationController.
final class ImplicitAnimationConfig extends AnimationConfig {
  final Duration duration;
  final Curve curve;
  final VoidCallback? onEnd;

  const ImplicitAnimationConfig({
    required this.duration,
    required this.curve,
    this.onEnd,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImplicitAnimationConfig &&
        other.duration == duration &&
        other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(duration, curve);
}

// TODO: Implement a sprint animation

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
