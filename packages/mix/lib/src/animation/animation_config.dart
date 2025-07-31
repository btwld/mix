import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/internal/constants.dart';
import '../core/spec.dart';
import '../core/style.dart';

/// Configuration data for animated styles in the Mix framework.
///
/// This sealed class provides different types of animation configurations
/// for use with animated widgets and style transitions.
sealed class AnimationConfig {
  factory AnimationConfig.curve({
    required Duration duration,
    required Curve curve,
    VoidCallback? onEnd,
  }) => CurveAnimationConfig(duration: duration, curve: curve, onEnd: onEnd);

  factory AnimationConfig.decelerate(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.decelerate(duration, onEnd: onEnd);
  factory AnimationConfig.fastLinearToSlowEaseIn(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.fastLinearToSlowEaseIn(duration, onEnd: onEnd);
  factory AnimationConfig.fastEaseInToSlowEaseOut(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.fastEaseInToSlowEaseOut(duration, onEnd: onEnd);
  factory AnimationConfig.ease(Duration duration, {VoidCallback? onEnd}) =>
      CurveAnimationConfig.ease(duration, onEnd: onEnd);
  factory AnimationConfig.easeIn(Duration duration, {VoidCallback? onEnd}) =>
      CurveAnimationConfig.easeIn(duration, onEnd: onEnd);
  factory AnimationConfig.easeInToLinear(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInToLinear(duration, onEnd: onEnd);
  factory AnimationConfig.easeInSine(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInSine(duration, onEnd: onEnd);
  factory AnimationConfig.easeInQuad(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInQuad(duration, onEnd: onEnd);
  factory AnimationConfig.easeInCubic(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInCubic(duration, onEnd: onEnd);
  factory AnimationConfig.easeInQuart(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInQuart(duration, onEnd: onEnd);
  factory AnimationConfig.easeInQuint(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInQuint(duration, onEnd: onEnd);
  factory AnimationConfig.easeInExpo(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInExpo(duration, onEnd: onEnd);
  factory AnimationConfig.easeInCirc(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInCirc(duration, onEnd: onEnd);
  factory AnimationConfig.easeInBack(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInBack(duration, onEnd: onEnd);
  factory AnimationConfig.easeOut(Duration duration, {VoidCallback? onEnd}) =>
      CurveAnimationConfig.easeOut(duration, onEnd: onEnd);
  factory AnimationConfig.linearToEaseOut(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.linearToEaseOut(duration, onEnd: onEnd);
  factory AnimationConfig.easeOutSine(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutSine(duration, onEnd: onEnd);
  factory AnimationConfig.easeOutQuad(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutQuad(duration, onEnd: onEnd);
  factory AnimationConfig.easeOutCubic(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutCubic(duration, onEnd: onEnd);
  factory AnimationConfig.easeOutQuart(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutQuart(duration, onEnd: onEnd);
  factory AnimationConfig.easeOutQuint(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutQuint(duration, onEnd: onEnd);
  factory AnimationConfig.easeOutExpo(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutExpo(duration, onEnd: onEnd);
  factory AnimationConfig.easeOutCirc(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutCirc(duration, onEnd: onEnd);
  factory AnimationConfig.easeOutBack(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeOutBack(duration, onEnd: onEnd);
  factory AnimationConfig.easeInOut(Duration duration, {VoidCallback? onEnd}) =>
      CurveAnimationConfig.easeInOut(duration, onEnd: onEnd);
  factory AnimationConfig.easeInOutSine(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInOutSine(duration, onEnd: onEnd);
  factory AnimationConfig.easeInOutQuad(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInOutQuad(duration, onEnd: onEnd);
  factory AnimationConfig.easeInOutCubic(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInOutCubic(duration, onEnd: onEnd);
  factory AnimationConfig.easeInOutCubicEmphasized(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInOutCubicEmphasized(duration, onEnd: onEnd);
  factory AnimationConfig.easeInOutQuart(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInOutQuart(duration, onEnd: onEnd);
  factory AnimationConfig.easeInOutQuint(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInOutQuint(duration, onEnd: onEnd);
  factory AnimationConfig.easeInOutExpo(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInOutExpo(duration, onEnd: onEnd);
  factory AnimationConfig.easeInOutCirc(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInOutCirc(duration, onEnd: onEnd);
  factory AnimationConfig.easeInOutBack(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.easeInOutBack(duration, onEnd: onEnd);
  factory AnimationConfig.fastOutSlowIn(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.fastOutSlowIn(duration, onEnd: onEnd);
  factory AnimationConfig.slowMiddle(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.slowMiddle(duration, onEnd: onEnd);
  factory AnimationConfig.bounceIn(Duration duration, {VoidCallback? onEnd}) =>
      CurveAnimationConfig.bounceIn(duration, onEnd: onEnd);
  factory AnimationConfig.bounceOut(Duration duration, {VoidCallback? onEnd}) =>
      CurveAnimationConfig.bounceOut(duration, onEnd: onEnd);
  factory AnimationConfig.bounceInOut(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.bounceInOut(duration, onEnd: onEnd);
  factory AnimationConfig.elasticIn(Duration duration, {VoidCallback? onEnd}) =>
      CurveAnimationConfig.elasticIn(duration, onEnd: onEnd);
  factory AnimationConfig.elasticOut(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.elasticOut(duration, onEnd: onEnd);
  factory AnimationConfig.elasticInOut(
    Duration duration, {
    VoidCallback? onEnd,
  }) => CurveAnimationConfig.elasticInOut(duration, onEnd: onEnd);
  factory AnimationConfig.linear(Duration duration, {VoidCallback? onEnd}) =>
      CurveAnimationConfig.linear(duration, onEnd: onEnd);

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
  final VoidCallback? onEnd;

  const CurveAnimationConfig({
    required this.duration,
    required this.curve,
    this.onEnd,
  });

  const CurveAnimationConfig.linear(this.duration, {this.onEnd})
    : curve = Curves.linear;

  const CurveAnimationConfig.decelerate(this.duration, {this.onEnd})
    : curve = Curves.decelerate;

  const CurveAnimationConfig.fastLinearToSlowEaseIn(this.duration, {this.onEnd})
    : curve = Curves.fastLinearToSlowEaseIn;

  const CurveAnimationConfig.fastEaseInToSlowEaseOut(
    this.duration, {
    this.onEnd,
  }) : curve = Curves.fastEaseInToSlowEaseOut;

  const CurveAnimationConfig.ease(this.duration, {this.onEnd})
    : curve = Curves.ease;

  const CurveAnimationConfig.easeIn(this.duration, {this.onEnd})
    : curve = Curves.easeIn;

  const CurveAnimationConfig.easeInToLinear(this.duration, {this.onEnd})
    : curve = Curves.easeInToLinear;

  const CurveAnimationConfig.easeInSine(this.duration, {this.onEnd})
    : curve = Curves.easeInSine;

  const CurveAnimationConfig.easeInQuad(this.duration, {this.onEnd})
    : curve = Curves.easeInQuad;

  const CurveAnimationConfig.easeInCubic(this.duration, {this.onEnd})
    : curve = Curves.easeInCubic;

  const CurveAnimationConfig.easeInQuart(this.duration, {this.onEnd})
    : curve = Curves.easeInQuart;

  const CurveAnimationConfig.easeInQuint(this.duration, {this.onEnd})
    : curve = Curves.easeInQuint;

  const CurveAnimationConfig.easeInExpo(this.duration, {this.onEnd})
    : curve = Curves.easeInExpo;

  const CurveAnimationConfig.easeInCirc(this.duration, {this.onEnd})
    : curve = Curves.easeInCirc;

  const CurveAnimationConfig.easeInBack(this.duration, {this.onEnd})
    : curve = Curves.easeInBack;

  const CurveAnimationConfig.easeOut(this.duration, {this.onEnd})
    : curve = Curves.easeOut;

  const CurveAnimationConfig.linearToEaseOut(this.duration, {this.onEnd})
    : curve = Curves.linearToEaseOut;

  const CurveAnimationConfig.easeOutSine(this.duration, {this.onEnd})
    : curve = Curves.easeOutSine;

  const CurveAnimationConfig.easeOutQuad(this.duration, {this.onEnd})
    : curve = Curves.easeOutQuad;

  const CurveAnimationConfig.easeOutCubic(this.duration, {this.onEnd})
    : curve = Curves.easeOutCubic;

  const CurveAnimationConfig.easeOutQuart(this.duration, {this.onEnd})
    : curve = Curves.easeOutQuart;

  const CurveAnimationConfig.easeOutQuint(this.duration, {this.onEnd})
    : curve = Curves.easeOutQuint;

  const CurveAnimationConfig.easeOutExpo(this.duration, {this.onEnd})
    : curve = Curves.easeOutExpo;

  const CurveAnimationConfig.easeOutCirc(this.duration, {this.onEnd})
    : curve = Curves.easeOutCirc;

  const CurveAnimationConfig.easeOutBack(this.duration, {this.onEnd})
    : curve = Curves.easeOutBack;

  const CurveAnimationConfig.easeInOut(this.duration, {this.onEnd})
    : curve = Curves.easeInOut;

  const CurveAnimationConfig.easeInOutSine(this.duration, {this.onEnd})
    : curve = Curves.easeInOutSine;

  const CurveAnimationConfig.easeInOutQuad(this.duration, {this.onEnd})
    : curve = Curves.easeInOutQuad;

  const CurveAnimationConfig.easeInOutCubic(this.duration, {this.onEnd})
    : curve = Curves.easeInOutCubic;

  const CurveAnimationConfig.easeInOutCubicEmphasized(
    this.duration, {
    this.onEnd,
  }) : curve = Curves.easeInOutCubicEmphasized;
  const CurveAnimationConfig.easeInOutQuart(this.duration, {this.onEnd})
    : curve = Curves.easeInOutQuart;

  const CurveAnimationConfig.easeInOutQuint(this.duration, {this.onEnd})
    : curve = Curves.easeInOutQuint;

  const CurveAnimationConfig.easeInOutExpo(this.duration, {this.onEnd})
    : curve = Curves.easeInOutExpo;

  const CurveAnimationConfig.easeInOutCirc(this.duration, {this.onEnd})
    : curve = Curves.easeInOutCirc;

  const CurveAnimationConfig.easeInOutBack(this.duration, {this.onEnd})
    : curve = Curves.easeInOutBack;

  const CurveAnimationConfig.fastOutSlowIn(this.duration, {this.onEnd})
    : curve = Curves.fastOutSlowIn;

  const CurveAnimationConfig.slowMiddle(this.duration, {this.onEnd})
    : curve = Curves.slowMiddle;

  const CurveAnimationConfig.bounceIn(this.duration, {this.onEnd})
    : curve = Curves.bounceIn;

  const CurveAnimationConfig.bounceOut(this.duration, {this.onEnd})
    : curve = Curves.bounceOut;

  const CurveAnimationConfig.bounceInOut(this.duration, {this.onEnd})
    : curve = Curves.bounceInOut;

  const CurveAnimationConfig.elasticIn(this.duration, {this.onEnd})
    : curve = Curves.elasticIn;

  const CurveAnimationConfig.elasticOut(this.duration, {this.onEnd})
    : curve = Curves.elasticOut;

  const CurveAnimationConfig.elasticInOut(this.duration, {this.onEnd})
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
  final List<CurveAnimationConfig> curvesAndDurations;
  final ValueNotifier trigger;
  final VoidCallback? onEnd;

  const PhaseAnimationConfig({
    required this.styles,
    required this.curvesAndDurations,
    required this.trigger,
    this.onEnd,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhaseAnimationConfig &&
        trigger == other.trigger &&
        listEquals(styles, other.styles) &&
        listEquals(curvesAndDurations, other.curvesAndDurations);
  }

  @override
  int get hashCode => Object.hash(styles, trigger, curvesAndDurations);
}
