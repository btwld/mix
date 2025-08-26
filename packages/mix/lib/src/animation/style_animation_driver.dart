import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../core/spec.dart';
import '../core/widget_spec.dart';
import 'animation_config.dart';

/// Tween that uses TweenSequence for phased animations.
class _PhasedSpecTween<S extends WidgetSpec<S>> extends Tween<S?> {
  final TweenSequence<S?> _tweenSequence;

  _PhasedSpecTween(this._tweenSequence);

  @override
  S? lerp(double t) {
    return _tweenSequence.transform(t);
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

  final S _initialSpec;

  /// Mutable tween for animating between specs.
  @protected
  final _tween = SpecTween<S>();

  /// The animation that drives spec changes using Flutter's Tween system.
  @protected
  late Animation<S?> _animation;

  StyleAnimationDriver({
    required this.vsync,
    required S initialSpec,
    bool unbounded = false,
  }) : _initialSpec = initialSpec {
    _controller = unbounded
        ? AnimationController.unbounded(vsync: vsync)
        : AnimationController(vsync: vsync);

    // Initialize tween with initial spec
    _tween.begin = initialSpec;
    _tween.end = initialSpec;

    // Create the animation once - it will use the mutable tween
    _animation = _controller.drive(_tween);

    // Create the animation - no need for listeners since we expose it directly
  }

  /// Gets the current animation controller.
  @visibleForTesting
  AnimationController get controller => _controller;

  /// Gets the animation that drives spec changes.
  Animation<S?> get animation => _animation;

  /// Animates to the given target spec.
  @nonVirtual
  Future<void> animateTo(S targetSpec) async {
    if (_tween.end == targetSpec && !_controller.isAnimating) return;

    final currentValue = _animation.value ?? _initialSpec;
    if (currentValue == targetSpec) {
      _tween.end = targetSpec;

      return;
    }

    // Reset controller to 0 before updating tween
    _controller.reset();

    _tween.begin = currentValue;
    _tween.end = targetSpec;

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
    _tween.begin = _initialSpec;
    _tween.end = _initialSpec;
  }

  void dispose() {
    _controller.dispose();
  }
}

/// A driver for curve-based animations with fixed duration.
class CurveAnimationDriver<S extends WidgetSpec<S>>
    extends StyleAnimationDriver<S> {
  final CurveAnimationConfig _config;

  CurveAnimationDriver({
    required super.vsync,
    required CurveAnimationConfig config,
    required super.initialSpec,
  }) : _config = config {
    // Add status listener for onEnd callback
    if (config.onEnd != null) {
      _animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          config.onEnd!();
        }
      });
    }
  }

  TweenSequence<S?> _createTweenSequence() => TweenSequence([
    if (_config.delay > Duration.zero)
      TweenSequenceItem(
        tween: ConstantTween(_tween.begin),
        weight: _config.delay.inMilliseconds.toDouble(),
      ),
    TweenSequenceItem(
      tween: _tween.chain(CurveTween(curve: _config.curve)),
      weight: _config.duration.inMilliseconds.toDouble(),
    ),
  ]);

  @override
  Future<void> executeAnimation() async {
    controller.duration = _config.totalDuration;

    _animation = controller.drive(_createTweenSequence());

    try {
      await controller.forward(from: 0.0);
    } on TickerCanceled {
      // Animation was cancelled - this is normal
    }
  }
}

/// A driver for spring-based physics animations.
class SpringAnimationDriver<S extends WidgetSpec<S>>
    extends StyleAnimationDriver<S> {
  final SpringAnimationConfig _config;

  SpringAnimationDriver({
    required super.vsync,
    required SpringAnimationConfig config,
    required super.initialSpec,
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

class PhaseAnimationDriver<S extends WidgetSpec<S>>
    extends StyleAnimationDriver<S> {
  final List<S> specs;
  final List<CurveAnimationConfig> curveConfigs;
  final Listenable trigger;
  final PhaseAnimationMode mode;

  late final TweenSequence<S?> _tweenSequence;

  PhaseAnimationDriver({
    required super.vsync,
    required this.curveConfigs,
    required this.specs,
    required super.initialSpec,
    required this.trigger,
    required this.mode,
  }) {
    _tweenSequence = mode.createTweenSequence(specs, curveConfigs);

    // Override the animation to use TweenSequence wrapped in a tween
    _animation = controller.drive(_PhasedSpecTween(_tweenSequence));

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
      (acc, config) => acc + config.totalDuration,
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
