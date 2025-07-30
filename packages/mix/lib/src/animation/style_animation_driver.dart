import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../core/spec.dart';
import '../core/style.dart';
import 'animation_config.dart';

/// Base class for animation drivers that handle style interpolation.
///
/// Animation drivers define how styles should be animated between changes.
/// This base class provides lifecycle management, event callbacks, and
/// common animation control methods.
abstract class StyleAnimationDriver<S extends Spec<S>> extends ChangeNotifier {
  /// The ticker provider for animations.
  final TickerProvider vsync;

  /// The animation controller managing the animation.
  late final AnimationController _controller;

  /// The current resolved style being displayed.
  late ResolvedStyle<S> _currentResolvedStyle = _initialStyle;

  /// The target resolved style to animate to.
  late ResolvedStyle<S> _targetResolvedStyle = _initialStyle;

  /// List of callbacks to invoke when animation starts.
  final List<VoidCallback> _onStartCallbacks = [];

  /// List of callbacks to invoke when animation completes.
  final List<VoidCallback> _onCompleteCallbacks = [];

  final ResolvedStyle<S> _initialStyle;

  /// The starting style for interpolation.
  @protected
  late ResolvedStyle<S> _fromStyle = _initialStyle;

  StyleAnimationDriver({
    required this.vsync,
    required ResolvedStyle<S> initialStyle,
    bool unbounded = false,
  }) : _initialStyle = initialStyle {
    _controller = unbounded
        ? AnimationController.unbounded(vsync: vsync)
        : AnimationController(vsync: vsync);

    _controller.addListener(_onAnimationTick);
    _controller.addStatusListener(_onAnimationStatusChanged);
  }

  /// Called on each animation frame.
  void _onAnimationTick() {
    _currentResolvedStyle = interpolateAt(_controller.value);
    notifyListeners();
  }

  /// Called when animation status changes.
  void _onAnimationStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        for (final callback in _onStartCallbacks) {
          callback();
        }
        break;
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        for (final callback in _onCompleteCallbacks) {
          callback();
        }
        break;
    }
  }

  /// Gets the current animation controller.
  @visibleForTesting
  AnimationController get controller => _controller;

  /// Gets the current resolved style.
  ResolvedStyle<S> get currentResolvedStyle => _currentResolvedStyle;

  /// Gets the target resolved style.
  @protected
  ResolvedStyle<S> get targetResolvedStyle => _targetResolvedStyle;

  /// Whether the animation is currently running.
  bool get isAnimating => _controller.isAnimating;

  /// The current animation status.
  AnimationStatus get status => _controller.status;

  /// The current animation progress (0.0 to 1.0).
  double get progress => _controller.value;

  /// Animates to the given target style.
  @nonVirtual
  Future<void> animateTo(ResolvedStyle<S> targetStyle) async {
    // Skip if already at target
    if (_targetResolvedStyle == targetStyle && !isAnimating) {
      return;
    }

    _fromStyle = _currentResolvedStyle;
    _targetResolvedStyle = targetStyle;

    // Execute subclass-specific animation
    await executeAnimation();
  }

  /// Execute the animation (curve vs spring).
  @protected
  Future<void> executeAnimation();

  /// Interpolates between current and target styles at the given progress.
  @visibleForTesting
  @nonVirtual
  ResolvedStyle<S> interpolateAt(double t) {
    // Apply any value transformation (e.g., curve)
    final transformedT = transformProgress(t);

    return _fromStyle.lerp(_targetResolvedStyle, transformedT);
  }

  /// Transform progress value (e.g., apply curve).
  @protected
  double transformProgress(double t) => t;

  /// Stops the current animation.
  void stop() => _controller.stop();

  /// Resets the animation to the beginning.
  void reset() {
    _controller.reset();
    _currentResolvedStyle = _initialStyle;
  }

  /// Adds a callback to be invoked when animation starts.
  void addOnStartListener(VoidCallback callback) {
    _onStartCallbacks.add(callback);
  }

  /// Removes a start callback.
  void removeOnStartListener(VoidCallback callback) {
    _onStartCallbacks.remove(callback);
  }

  /// Adds a callback to be invoked when animation completes.
  void addOnCompleteListener(VoidCallback callback) {
    _onCompleteCallbacks.add(callback);
  }

  /// Removes a complete callback.
  void removeOnCompleteListener(VoidCallback callback) {
    _onCompleteCallbacks.remove(callback);
  }

  @override
  void dispose() {
    _controller.removeListener(_onAnimationTick);
    _controller.removeStatusListener(_onAnimationStatusChanged);
    _controller.dispose();
    _onStartCallbacks.clear();
    _onCompleteCallbacks.clear();
    super.dispose();
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
    if (config.onEnd != null) {
      addOnCompleteListener(config.onEnd!);
    }
  }

  @override
  Future<void> executeAnimation() async {
    controller.duration = _config.duration;

    try {
      await controller.forward(from: 0.0);
    } on TickerCanceled {
      // Animation was cancelled - this is normal
    }
  }

  @override
  double transformProgress(double t) => _config.curve.transform(t);
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
    if (config.onEnd != null) {
      addOnCompleteListener(config.onEnd!);
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
  final List<CurveAnimationConfig> curvesAndDurations;
  int _currentIndex = 0;

  PhaseAnimationDriver({
    required super.vsync,
    required this.curvesAndDurations,
    required this.specs,
    required super.initialStyle,
  }) {
    if (curvesAndDurations.last.onEnd != null) {
      addOnCompleteListener(curvesAndDurations.last.onEnd!);
    }
  }

  @override
  Future<void> executeAnimation() async {
    for (int i = 0; i < specs.length; i++) {
      _currentIndex = i % specs.length;
      final nextIndex = (i + 1) % specs.length;

      controller.duration = curvesAndDurations[_currentIndex].duration;

      _fromStyle = ResolvedStyle(spec: specs[_currentIndex]);
      _targetResolvedStyle = ResolvedStyle(spec: specs[nextIndex]);
      await controller.forward(from: 0.0);
    }
  }

  @override
  double transformProgress(double t) =>
      curvesAndDurations[_currentIndex].curve.transform(t);
}
