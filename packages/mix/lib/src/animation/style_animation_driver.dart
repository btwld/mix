import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../core/spec.dart';
import '../core/style.dart';
import 'animation_config.dart';

/// Tween for ResolvedStyle interpolation.
class ResolvedStyleTween<S extends Spec<S>> extends Tween<ResolvedStyle<S>?> {
  ResolvedStyleTween({super.begin, super.end});

  @override
  ResolvedStyle<S>? lerp(double t) {
    if (begin == null) return end;
    if (end == null) return begin;

    return begin!.lerp(end!, t);
  }
}

/// Tween that converts Spec to ResolvedStyle for PhaseAnimationDriver.
class _SpecToResolvedStyleTween<S extends Spec<S>>
    extends Tween<ResolvedStyle<S>?> {
  final TweenSequence<S?> _tweenSequence;

  _SpecToResolvedStyleTween(this._tweenSequence);

  @override
  ResolvedStyle<S>? lerp(double t) {
    final spec = _tweenSequence.transform(t);
    if (spec == null) return null;

    return ResolvedStyle(spec: spec);
  }
}

/// Base class for animation drivers that handle style interpolation.
///
/// Animation drivers define how styles should be animated between changes.
/// This base class provides lifecycle management and common animation control methods.
abstract class StyleAnimationDriver<S extends Spec<S>> {
  /// The ticker provider for animations.
  final TickerProvider vsync;

  /// The animation controller managing the animation.
  late final AnimationController _controller;

  final ResolvedStyle<S> _initialStyle;

  /// Mutable tween for animating between styles.
  @protected
  final _tween = ResolvedStyleTween<S>();

  /// The animation that drives style changes using Flutter's Tween system.
  @protected
  late Animation<ResolvedStyle<S>?> _animation;

  StyleAnimationDriver({
    required this.vsync,
    required ResolvedStyle<S> initialStyle,
    bool unbounded = false,
  }) : _initialStyle = initialStyle {
    _controller = unbounded
        ? AnimationController.unbounded(vsync: vsync)
        : AnimationController(vsync: vsync);

    // Initialize tween with initial style
    _tween.begin = initialStyle;
    _tween.end = initialStyle;

    // Create the animation once - it will use the mutable tween
    _animation = _controller.drive(_tween);

    // Create the animation - no need for listeners since we expose it directly
  }

  /// Gets the current animation controller.
  @visibleForTesting
  AnimationController get controller => _controller;

  /// Gets the animation that drives style changes.
  Animation<ResolvedStyle<S>?> get animation => _animation;

  /// Animates to the given target style.
  @nonVirtual
  Future<void> animateTo(ResolvedStyle<S> targetStyle) async {
    if (_tween.end == targetStyle && !_controller.isAnimating) return;

    final currentValue = _animation.value ?? _initialStyle;
    if (currentValue == targetStyle) {
      _tween.end = targetStyle;

      return;
    }

    _tween.begin = currentValue;
    _tween.end = targetStyle;
    await executeAnimation();
  }

  /// Execute the animation (curve vs spring).
  @protected
  Future<void> executeAnimation();

  /// Stops the current animation.
  void stop() => _controller.stop();

  /// Resets the animation to the beginning.
  void reset() {
    _controller.reset();
    _tween.begin = _initialStyle;
    _tween.end = _initialStyle;
  }

  void dispose() {
    _controller.dispose();
  }
}

/// A driver for curve-based animations with fixed duration.
class CurveAnimationDriver<S extends Spec<S>> extends StyleAnimationDriver<S> {
  final CurveAnimationConfig _config;

  CurveAnimationDriver({
    required super.vsync,
    required CurveAnimationConfig config,
    required super.initialStyle,
  }) : _config = config {
    // Override the animation with curve applied
    _animation = CurvedAnimation(
      parent: controller,
      curve: _config.curve,
    ).drive(_tween);

    // Add status listener for onEnd callback
    if (config.onEnd != null) {
      _animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          config.onEnd!();
        }
      });
    }
  }

  @override
  Future<void> executeAnimation() async {
    controller.duration = _config.duration;

    try {
      await Future.delayed(_config.delay);
      await controller.forward(from: 0.0);
    } on TickerCanceled {
      // Animation was cancelled - this is normal
    }
  }
}

/// A driver for spring-based physics animations.
class SpringAnimationDriver<S extends Spec<S>> extends StyleAnimationDriver<S> {
  final SpringAnimationConfig _config;

  SpringAnimationDriver({
    required super.vsync,
    required SpringAnimationConfig config,
    required super.initialStyle,
  }) : _config = config,
       super(unbounded: true) {
    // Add status listener for onEnd callback
    if (config.onEnd != null) {
      _animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          config.onEnd!();
        }
      });
    }
  }

  @override
  Future<void> executeAnimation() async {
    final simulation = SpringSimulation(_config.spring, 0.0, 1.0, 0.0);

    try {
      await controller.animateWith(simulation);
    } on TickerCanceled {
      // Animation was cancelled - this is normal
    }
  }
}

class PhaseAnimationDriver<S extends Spec<S>> extends StyleAnimationDriver<S> {
  final List<S> specs;
  final List<CurveAnimationConfig> curveConfigs;
  final Listenable trigger;
  final PhaseAnimationMode mode;

  late final TweenSequence<S?> _tweenSequence;

  PhaseAnimationDriver({
    required super.vsync,
    required this.curveConfigs,
    required this.specs,
    required super.initialStyle,
    required this.trigger,
    required this.mode,
  }) {
    _tweenSequence = mode.createTweenSequence(specs, curveConfigs);

    // Override the animation to use TweenSequence wrapped in a tween
    _animation = controller.drive(_SpecToResolvedStyleTween(_tweenSequence));

    trigger.addListener(_onTriggerChanged);

    // Add status listener for onEnd callback
    if (curveConfigs.last.onEnd != null) {
      _animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          curveConfigs.last.onEnd!();
        }
      });
    }
  }

  void _onTriggerChanged() {
    executeAnimation();
  }

  Duration get totalDuration {
    return curveConfigs.fold(
      Duration.zero,
      (acc, config) => acc + config.duration + config.delay,
    );
  }

  @override
  void dispose() {
    trigger.removeListener(_onTriggerChanged);
    super.dispose();
  }

  @override
  Future<void> executeAnimation() async {
    controller.duration = totalDuration;

    await controller.forward(from: 0.0);
  }
}
