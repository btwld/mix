import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../core/spec.dart';
import '../core/style_spec.dart';
import 'animation_config.dart';

/// Tween that uses TweenSequence for phased animations.
class _PhasedSpecTween<S extends Spec<S>> extends Tween<StyleSpec<S>?> {
  final TweenSequence<StyleSpec<S>?> _tweenSequence;

  _PhasedSpecTween(this._tweenSequence);

  @override
  StyleSpec<S>? lerp(double t) {
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

  final StyleSpec<S> _initialSpec;

  /// The animation that drives spec changes using Flutter's Tween system.
  @protected
  late Animation<StyleSpec<S>?> _animation;

  bool _reducedMotion;

  StyleAnimationDriver({
    required this.vsync,
    required StyleSpec<S> initialSpec,
    bool unbounded = false,
    bool reducedMotion = false,
  }) : _initialSpec = initialSpec,
       _reducedMotion = reducedMotion {
    _controller = unbounded
        ? AnimationController.unbounded(vsync: vsync)
        : AnimationController(vsync: vsync);
  }

  /// Gets the current animation controller.
  @visibleForTesting
  AnimationController get controller => _controller;

  /// Gets the animation that drives spec changes.
  Animation<StyleSpec<S>?> get animation => _animation;

  /// Whether `MediaQuery.disableAnimations` is set for this driver's subtree.
  ///
  /// It applies from the next transition. A running curve or spring
  /// transition finishes; a loop stops on its first frame and resumes when
  /// the flag clears.
  bool get reducedMotion => _reducedMotion;

  /// Set by `StyleAnimationBuilder` from `MediaQuery.disableAnimations`.
  @internal
  set reducedMotion(bool value) {
    if (_reducedMotion == value) return;
    _reducedMotion = value;
    didChangeReducedMotion();
  }

  /// Called after [reducedMotion] changes.
  @protected
  // ignore: no-empty-block
  void didChangeReducedMotion() {}

  // ignore: no-empty-block
  void didUpdateSpec(StyleSpec<S> oldSpec, StyleSpec<S> newSpec) {}
  void updateDriver(AnimationConfig config);

  /// Execute the animation (curve vs spring).
  @protected
  Future<void> executeAnimation();

  /// Stops the current animation.
  void stop() => _controller.stop();

  /// Resets the animation to the beginning.
  void reset() {
    _controller.reset();
  }

  void dispose() {
    _controller.dispose();
  }
}

abstract class ImplicitAnimationDriver<
  S extends Spec<S>,
  C extends AnimationConfig
>
    extends StyleAnimationDriver<S> {
  C config;

  /// Mutable tween for animating between specs.
  @protected
  final _tween = SpecTween<StyleSpec<S>>();

  ImplicitAnimationDriver({
    required super.vsync,
    required this.config,
    required super.initialSpec,
    super.unbounded,
    super.reducedMotion,
  }) {
    _tween.begin = _initialSpec;
    _tween.end = _initialSpec;

    _animation = _controller.drive(_tween);

    _animation.addStatusListener(_onAnimationComplete);
  }

  /// Animates to the given target spec.
  Future<void> _animateTo(StyleSpec<S> targetSpec) async {
    if (_skipsMotion) {
      _jumpTo(targetSpec);

      return;
    }
    final currentValue = _animation.value ?? _initialSpec;

    _tween.begin = currentValue;
    _tween.end = targetSpec;
    // A jump may have replaced the animation; drive the tween again.
    _animation = _controller.drive(_tween);

    await executeAnimation();
  }

  /// Shows [targetSpec] without a transition.
  ///
  /// [onCompleteAnimation] runs once, after the frame. The builder jumps
  /// while it updates, so that is the current frame; outside a frame, one is
  /// scheduled.
  void _jumpTo(StyleSpec<S> targetSpec) {
    _controller.stop();
    _tween.begin = targetSpec;
    _tween.end = targetSpec;
    _animation = _controller.drive(ConstantTween(targetSpec));
    SchedulerBinding.instance
      ..addPostFrameCallback((_) => onCompleteAnimation())
      ..ensureVisualUpdate();
  }

  void _onAnimationComplete(AnimationStatus status) {
    if (status == .completed) {
      onCompleteAnimation();
    }
  }

  bool get _skipsMotion => reducedMotion;

  void onCompleteAnimation();

  @override
  void dispose() {
    _animation.removeStatusListener(_onAnimationComplete);
    super.dispose();
  }

  @override
  void reset() {
    _controller.reset();
    _tween.begin = _initialSpec;
    _tween.end = _initialSpec;
    _animation = _controller.drive(_tween);
  }

  @override
  void updateDriver(covariant C config) {
    this.config = config;
  }

  @override
  void didUpdateSpec(StyleSpec<S> oldSpec, StyleSpec<S> newSpec) {
    super.didUpdateSpec(oldSpec, newSpec);

    _animateTo(newSpec);
  }
}

/// A driver for curve-based animations with fixed duration.
class CurveAnimationDriver<S extends Spec<S>>
    extends ImplicitAnimationDriver<S, CurveAnimationConfig> {
  CurveAnimationDriver({
    required super.vsync,
    required super.config,
    required super.initialSpec,
    super.reducedMotion,
  }) : super(unbounded: false) {
    _tween.begin = _initialSpec;
    _tween.end = _initialSpec;

    _animation = _controller.drive(_tween);
  }

  /// Weights are in microseconds, so sub-millisecond durations keep a
  /// positive weight.
  Animatable<StyleSpec<S>?> _createAnimatable() {
    // A zero duration after a delay holds the start, then lands on the end.
    // A zero-weight [TweenSequenceItem] would assert.
    if (config.duration <= .zero) {
      return _tween.chain(CurveTween(curve: const Threshold(1.0)));
    }

    return TweenSequence([
      if (config.delay > .zero)
        TweenSequenceItem(
          tween: ConstantTween(_initialSpec),
          weight: config.delay.inMicroseconds.toDouble(),
        ),
      TweenSequenceItem(
        tween: _tween.chain(CurveTween(curve: config.curve)),
        weight: config.duration.inMicroseconds.toDouble(),
      ),
    ]);
  }

  /// A transition with no delay and no duration jumps.
  @override
  bool get _skipsMotion => super._skipsMotion || config.totalDuration <= .zero;

  @override
  void onCompleteAnimation() {
    if (config.onEnd case final onEnd?) {
      onEnd();
    }
  }

  @override
  Future<void> executeAnimation() async {
    controller.duration = config.totalDuration;
    _animation = controller.drive(_createAnimatable());

    try {
      await controller.forward(from: 0.0);
    } on TickerCanceled {
      // Animation was cancelled - this is normal
    }
  }
}

/// A driver for spring-based physics animations.
class SpringAnimationDriver<S extends Spec<S>>
    extends ImplicitAnimationDriver<S, SpringAnimationConfig> {
  SpringAnimationDriver({
    required super.vsync,
    required super.config,
    required super.initialSpec,
    super.reducedMotion,
  }) : super(unbounded: true) {
    _tween.begin = _initialSpec;
    _tween.end = _initialSpec;

    _animation = _controller.drive(_tween);
  }

  @override
  Future<void> executeAnimation() async {
    final simulation = SpringSimulation(config.spring, 0.0, 1.0, 0.0);

    try {
      await controller.animateWith(simulation);
    } on TickerCanceled {
      // Animation was cancelled - this is normal
    }
  }

  @override
  void onCompleteAnimation() {
    if (config.onEnd case final onEnd?) {
      onEnd();
    }
  }
}

/// A driver for multi-phase animations that cycle through multiple specs.
///
/// This driver animates through a sequence of styles based on curve configurations
/// and responds to trigger events to start the animation sequence.
class PhaseAnimationDriver<S extends Spec<S>> extends StyleAnimationDriver<S> {
  PhaseAnimationConfig config;
  final BuildContext context;

  late TweenSequence<StyleSpec<S>?> _tweenSequence;

  PhaseAnimationDriver({
    required super.vsync,
    required this.config,
    required super.initialSpec,
    required this.context,
    super.reducedMotion,
  }) {
    _setUpAnimation();
    if (config.isLooping && !reducedMotion) {
      _startLoopingAnimation();
    }
  }

  void _setUpAnimation() {
    final specs = config.styles
        .map((e) => e.resolve(context) as StyleSpec<S>)
        .toList();

    _tweenSequence = _createTweenSequence(specs, config.curveConfigs);

    // Override the animation to use TweenSequence wrapped in a tween
    _animation = controller.drive(_PhasedSpecTween(_tweenSequence));

    config.trigger?.addListener(_onTriggerChanged);

    // Add status listener for onEnd callback
    if (config.curveConfigs.last.onEnd != null) {
      _animation.addStatusListener((status) {
        if (status == .completed) {
          config.curveConfigs.last.onEnd!();
        }
      });
    }
  }

  void _onTriggerChanged() {
    executeAnimation();
  }

  TweenSequence<StyleSpec<S>?> _createTweenSequence(
    List<StyleSpec<S>> specs,
    List<CurveAnimationConfig> configs,
  ) {
    final items = <TweenSequenceItem<StyleSpec<S>?>>[];
    for (int i = 0; i < specs.length; i++) {
      final currentIndex = i % specs.length;
      final nextIndex = (i + 1) % specs.length;

      if (configs[currentIndex].delay > .zero) {
        items.add(
          TweenSequenceItem(
            tween: ConstantTween(specs[currentIndex]),
            weight: configs[nextIndex].delay.inMilliseconds.toDouble(),
          ),
        );
      }

      final tween = SpecTween<StyleSpec<S>>(
        begin: specs[currentIndex],
        end: specs[nextIndex],
      );

      final item = TweenSequenceItem(
        tween: tween.chain(CurveTween(curve: configs[nextIndex].curve)),
        weight: configs[nextIndex].duration.inMilliseconds.toDouble(),
      );

      items.add(item);
    }

    return TweenSequence(items);
  }

  void _startLoopingAnimation() {
    controller.duration = totalDuration;
    controller.repeat();
  }

  /// Gets the total duration of all animation phases combined.
  Duration get totalDuration {
    return config.curveConfigs.fold(
      Duration.zero,
      (acc, config) => acc + config.totalDuration,
    );
  }

  @override
  void didChangeReducedMotion() {
    if (!config.isLooping) return;
    if (reducedMotion) {
      controller
        ..stop()
        ..value = 0;
    } else {
      _startLoopingAnimation();
    }
  }

  @override
  void dispose() {
    config.trigger?.removeListener(_onTriggerChanged);
    controller.stop();
    super.dispose();
  }

  @override
  Future<void> executeAnimation() async {
    controller.duration = reducedMotion ? .zero : totalDuration;

    await controller.forward(from: 0.0);
  }

  @override
  void updateDriver(covariant PhaseAnimationConfig config) {
    this.config.trigger?.removeListener(_onTriggerChanged);
    if (config != this.config) {
      controller.reset();
    }

    this.config = config;
    _setUpAnimation();

    if (config.isLooping && !reducedMotion) {
      _startLoopingAnimation();
    }
  }
}

/// A driver for keyframe-based animations with complex timeline control.
class KeyframeAnimationDriver<S extends Spec<S>>
    extends StyleAnimationDriver<S> {
  final BuildContext context;

  KeyframeAnimationConfig<S> _config;
  late Map<String, Animatable> _sequenceMap;

  KeyframeAnimationDriver({
    required super.vsync,
    required KeyframeAnimationConfig<S> config,
    required super.initialSpec,
    required this.context,
    super.reducedMotion,
  }) : _config = config {
    _setUpAnimation();
    if (config.isLooping && !reducedMotion) {
      _startLoopingAnimation();
    }
  }

  void _onTriggerChanged() {
    executeAnimation();
  }

  void _setUpAnimation() {
    _sequenceMap = {
      for (final track in _config.timeline)
        track.id: track.createAnimatable(duration),
    };

    _animation = controller.drive(
      _KeyframeAnimatable(_sequenceMap, _config, context),
    );

    _config.trigger?.addListener(_onTriggerChanged);
  }

  void _startLoopingAnimation() {
    controller.duration = duration;
    controller.repeat();
  }

  Duration get duration {
    if (_config.timeline.isEmpty) return .zero;

    return _config.timeline.fold(
      Duration.zero,
      (max, t) => t.totalDuration > max ? t.totalDuration : max,
    );
  }

  @override
  void didChangeReducedMotion() {
    if (!_config.isLooping) return;
    if (reducedMotion) {
      controller
        ..stop()
        ..value = 0;
    } else {
      _startLoopingAnimation();
    }
  }

  @override
  void dispose() {
    _config.trigger?.removeListener(_onTriggerChanged);
    controller.stop();
    super.dispose();
  }

  @override
  Future<void> executeAnimation() async {
    controller.duration = reducedMotion ? .zero : duration;

    try {
      await controller.forward(from: 0.0);
    } on TickerCanceled {
      // Animation was cancelled - this is normal
    }
  }

  @override
  void updateDriver(covariant KeyframeAnimationConfig<S> config) {
    _config.trigger?.removeListener(_onTriggerChanged);
    if (_config != config) {
      controller.reset();
    }

    _config = config;
    _setUpAnimation();

    if (config.isLooping && !reducedMotion) {
      _startLoopingAnimation();
    }
  }
}

class _KeyframeAnimatable<S extends Spec<S>> extends Animatable<StyleSpec<S>?> {
  final Map<String, Animatable> _sequenceMap;
  final KeyframeAnimationConfig<S> _config;
  final BuildContext _context;

  const _KeyframeAnimatable(this._sequenceMap, this._config, this._context);

  @override
  StyleSpec<S> transform(double t) {
    Map<String, Object> result = {};
    for (final entry in _sequenceMap.entries) {
      final value = entry.value.transform(t);
      result[entry.key] = value;
    }

    return _config
        .styleBuilder(KeyframeAnimationResult(result), _config.initialStyle)
        .resolve(_context);
  }
}

/// A driver that bypasses all animation and immediately applies spec changes.
///
/// This driver provides instant spec updates without any interpolation,
/// timers, or animation lifecycle. Useful for testing or when animations
/// should be disabled (e.g., for accessibility).
class NoAnimationDriver<S extends Spec<S>> extends StyleAnimationDriver<S> {
  NoAnimationDriver({
    required super.vsync,
    required super.initialSpec,
    super.reducedMotion,
  }) {
    _animation = AlwaysStoppedAnimation<StyleSpec<S>?>(_initialSpec);
  }

  @override
  Future<void> executeAnimation() async {
    // Immediately complete the animation without any delay
    _controller.value = 1.0;
  }

  @override
  void didUpdateSpec(StyleSpec<S> oldSpec, StyleSpec<S> newSpec) {
    // Update the animation value to the new spec.
    _animation = AlwaysStoppedAnimation<StyleSpec<S>?>(newSpec);
  }

  @override
  // ignore: no-empty-block
  void updateDriver(AnimationConfig config) {}
}
