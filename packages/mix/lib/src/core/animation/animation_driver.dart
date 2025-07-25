import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../spec.dart';
import '../style.dart';

/// Base class for animation drivers that handle style interpolation.
///
/// Animation drivers define how styles should be animated between changes.
/// This base class provides lifecycle management, event callbacks, and
/// common animation control methods.
abstract class AnimationDriver<S extends Spec<S>> extends ChangeNotifier {
  /// The ticker provider for animations.
  final TickerProvider vsync;

  /// The animation controller managing the animation.
  late final AnimationController _controller;

  /// The current resolved style being displayed.
  ResolvedStyle<S>? _currentResolvedStyle;

  /// The target resolved style to animate to.
  ResolvedStyle<S>? _targetResolvedStyle;

  /// List of callbacks to invoke when animation starts.
  final List<VoidCallback> _onStartCallbacks = [];

  /// List of callbacks to invoke when animation completes.
  final List<VoidCallback> _onCompleteCallbacks = [];

  AnimationDriver({required this.vsync}) {
    _controller = AnimationController(vsync: vsync);
    _setupController();
  }

  /// Sets up the animation controller with listeners.
  void _setupController() {
    _controller.addListener(_onAnimationTick);
    _controller.addStatusListener(_onAnimationStatusChanged);
  }

  /// Called on each animation frame.
  void _onAnimationTick() {
    if (_targetResolvedStyle != null) {
      _currentResolvedStyle = interpolateAt(_controller.value);
      notifyListeners();
    }
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
  @protected
  AnimationController get controller => _controller;

  /// Gets the current resolved style.
  ResolvedStyle<S>? get currentResolvedStyle => _currentResolvedStyle;

  /// Gets the target resolved style.
  @protected
  ResolvedStyle<S>? get targetResolvedStyle => _targetResolvedStyle;

  /// Whether the animation is currently running.
  bool get isAnimating => _controller.isAnimating;

  /// The current animation status.
  AnimationStatus get status => _controller.status;

  /// The current animation progress (0.0 to 1.0).
  double get progress => _controller.value;

  /// Animates to the given target style.
  Future<void> animateTo(ResolvedStyle<S> targetStyle);

  /// Interpolates between current and target styles at the given progress.
  @protected
  ResolvedStyle<S> interpolateAt(double t);

  /// Stops the current animation.
  void stop() => _controller.stop();

  /// Resets the animation to the beginning.
  void reset() {
    _controller.reset();
    _currentResolvedStyle = null;
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

  /// Builds the animated widget with the given style and builder.
  /// This method is kept for backwards compatibility.
  Widget build({
    required BuildContext context,
    required SpecStyle<S> style,
    required Widget Function(BuildContext context, ResolvedStyle<S> resolved)
    builder,
  }) {
    // This will be implemented by the AnimationStyleWidget
    throw UnimplementedError('Use AnimationStyleWidget instead');
  }
}

/// A driver that performs no animation - just passes through the resolved style.
class NoAnimationDriver<S extends Spec<S>> extends AnimationDriver<S> {
  NoAnimationDriver({required super.vsync});

  @override
  Future<void> animateTo(ResolvedStyle<S> targetStyle) async {
    _currentResolvedStyle = targetStyle;
    notifyListeners();
  }

  @override
  ResolvedStyle<S> interpolateAt(double t) {
    return targetResolvedStyle ?? _currentResolvedStyle!;
  }

  @override
  Widget build({
    required BuildContext context,
    required SpecStyle<S> style,
    required Widget Function(BuildContext context, ResolvedStyle<S> resolved)
    builder,
  }) {
    final resolved = style.build(context);
    _currentResolvedStyle = resolved;

    return builder(context, resolved);
  }
}

/// A driver for curve-based animations with fixed duration.
class CurveAnimationDriver<S extends Spec<S>> extends AnimationDriver<S> {
  /// The duration of the animation.
  final Duration duration;

  /// The curve of the animation.
  final Curve curve;

  /// The starting style for interpolation.
  ResolvedStyle<S>? _fromStyle;

  CurveAnimationDriver({
    required super.vsync,
    required this.duration,
    this.curve = Curves.linear,
    VoidCallback? onEnd,
  }) {
    if (onEnd != null) {
      addOnCompleteListener(onEnd);
    }
  }

  @override
  Future<void> animateTo(ResolvedStyle<S> targetStyle) async {
    // Skip if already at target
    if (_targetResolvedStyle == targetStyle && !isAnimating) {
      return;
    }

    _fromStyle = _currentResolvedStyle ?? targetStyle;
    _targetResolvedStyle = targetStyle;

    controller.duration = duration;

    try {
      await controller.forward(from: 0.0);
    } on TickerCanceled {
      // Animation was cancelled - this is normal
    }
  }

  @override
  ResolvedStyle<S> interpolateAt(double t) {
    if (_fromStyle == null || _targetResolvedStyle == null) {
      return _targetResolvedStyle ?? _fromStyle!;
    }

    final curvedT = curve.transform(t);

    return _fromStyle!.lerp(_targetResolvedStyle!, curvedT);
  }
}

/// A driver for spring-based physics animations.
class SpringAnimationDriver<S extends Spec<S>> extends AnimationDriver<S> {
  /// The spring description for the animation.
  final SpringDescription spring;

  /// The starting style for interpolation.
  ResolvedStyle<S>? _fromStyle;

  SpringAnimationDriver({
    required super.vsync,
    SpringDescription? spring,
    double stiffness = 180.0,
    double damping = 12.0,
    double mass = 1.0,
    VoidCallback? onEnd,
  }) : spring =
           spring ??
           SpringDescription(
             mass: mass,
             stiffness: stiffness,
             damping: damping,
           ) {
    if (onEnd != null) {
      addOnCompleteListener(onEnd);
    }
  }

  @override
  Future<void> animateTo(ResolvedStyle<S> targetStyle) async {
    // Skip if already at target
    if (_targetResolvedStyle == targetStyle && !isAnimating) {
      return;
    }

    _fromStyle = _currentResolvedStyle ?? targetStyle;
    _targetResolvedStyle = targetStyle;

    final simulation = SpringSimulation(spring, 0.0, 1.0, 0.0);

    try {
      await controller.animateWith(simulation);
    } on TickerCanceled {
      // Animation was cancelled - this is normal
    }
  }

  @override
  ResolvedStyle<S> interpolateAt(double t) {
    if (_fromStyle == null || _targetResolvedStyle == null) {
      return _targetResolvedStyle ?? _fromStyle!;
    }

    return _fromStyle!.lerp(_targetResolvedStyle!, t);
  }
}

