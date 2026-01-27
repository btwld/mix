import 'package:flutter/physics.dart';
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

  StyleAnimationDriver({
    required this.vsync,
    required StyleSpec<S> initialSpec,
    bool unbounded = false,
  }) : _initialSpec = initialSpec {
    _controller = unbounded
        ? AnimationController.unbounded(vsync: vsync)
        : AnimationController(vsync: vsync);
  }

  /// Gets the current animation controller.
  @visibleForTesting
  AnimationController get controller => _controller;

  /// Gets the animation that drives spec changes.
  Animation<StyleSpec<S>?> get animation => _animation;

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
  }) {
    _tween.begin = _initialSpec;
    _tween.end = _initialSpec;

    _animation = _controller.drive(_tween);

    _animation.addStatusListener(_onAnimationComplete);
  }

  /// Animates to the given target spec.
  Future<void> _animateTo(StyleSpec<S> targetSpec) async {
    final currentValue = _animation.value ?? _initialSpec;

    _tween.begin = currentValue;
    _tween.end = targetSpec;

    await executeAnimation();
  }

  void _onAnimationComplete(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      onCompleteAnimation();
    }
  }

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
  }) : super(unbounded: false) {
    _tween.begin = _initialSpec;
    _tween.end = _initialSpec;

    _animation = _controller.drive(_tween);
  }

  TweenSequence<StyleSpec<S>?> _createTweenSequence() => TweenSequence([
    if (config.delay > Duration.zero)
      TweenSequenceItem(
        tween: ConstantTween(_initialSpec),
        weight: config.delay.inMilliseconds.toDouble(),
      ),
    TweenSequenceItem(
      tween: _tween.chain(CurveTween(curve: config.curve)),
      weight: config.duration.inMilliseconds.toDouble(),
    ),
  ]);

  @override
  void onCompleteAnimation() {
    if (config.onEnd case final onEnd?) {
      onEnd();
    }
  }

  @override
  Future<void> executeAnimation() async {
    controller.duration = config.totalDuration;
    final tweenSequence = _createTweenSequence();

    _animation = controller.drive(tweenSequence);

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
  }) {
    _setUpAnimation();
  }

  void _setUpAnimation() {
    final specs = config.styles
        .map((e) => e.resolve(context) as StyleSpec<S>)
        .toList();

    _tweenSequence = _createTweenSequence(specs, config.curveConfigs);

    // Override the animation to use TweenSequence wrapped in a tween
    _animation = controller.drive(_PhasedSpecTween(_tweenSequence));

    config.trigger.addListener(_onTriggerChanged);

    // Add status listener for onEnd callback and repeat handling
    _animation.addStatusListener(_onAnimationStatusChanged);
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Call onEnd callback if provided
      config.onEnd?.call();

      // If repeat is enabled, restart the animation
      if (config.repeat) {
        controller.forward(from: 0.0);
      }
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

    // Calculate number of transitions: specs.length - 1 for non-wrapping,
    // or specs.length if repeat/wrap is enabled
    final transitionCount = config.repeat ? specs.length : specs.length - 1;

    for (int i = 0; i < transitionCount; i++) {
      final currentIndex = i;
      final nextIndex = (i + 1) % specs.length;

      // Use currentIndex config for the transition FROM currentIndex TO nextIndex
      final transitionConfig = configs[currentIndex];

      if (transitionConfig.delay > Duration.zero) {
        items.add(
          TweenSequenceItem(
            tween: ConstantTween(specs[currentIndex]),
            weight: transitionConfig.delay.inMilliseconds.toDouble(),
          ),
        );
      }

      final tween = SpecTween<StyleSpec<S>>(
        begin: specs[currentIndex],
        end: specs[nextIndex],
      );

      final item = TweenSequenceItem(
        tween: tween.chain(CurveTween(curve: transitionConfig.curve)),
        weight: transitionConfig.duration.inMilliseconds.toDouble(),
      );

      items.add(item);
    }

    return TweenSequence(items);
  }

  /// Gets the total duration of all animation phases combined.
  ///
  /// When [repeat] is false, only the first N-1 configs are used (for N phases).
  /// When [repeat] is true, all N configs are used (including wrap-around).
  Duration get totalDuration {
    final transitionCount =
        config.repeat ? config.curveConfigs.length : config.curveConfigs.length - 1;

    var total = Duration.zero;
    for (var i = 0; i < transitionCount; i++) {
      total += config.curveConfigs[i].totalDuration;
    }
    return total;
  }

  @override
  void dispose() {
    config.trigger.removeListener(_onTriggerChanged);
    _animation.removeStatusListener(_onAnimationStatusChanged);
    super.dispose();
  }

  @override
  Future<void> executeAnimation() async {
    controller.duration = totalDuration;

    await controller.forward(from: 0.0);
  }

  @override
  void updateDriver(covariant PhaseAnimationConfig config) {
    // Remove listeners from OLD config before replacing
    this.config.trigger.removeListener(_onTriggerChanged);
    _animation.removeStatusListener(_onAnimationStatusChanged);
    this.config = config;
    _setUpAnimation();
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
  }) : _config = config {
    _setUpAnimation();
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

    _config.trigger.addListener(_onTriggerChanged);
  }

  Duration get duration {
    if (_config.timeline.isEmpty) return Duration.zero;

    return _config.timeline.fold(
      Duration.zero,
      (max, t) => t.totalDuration > max ? t.totalDuration : max,
    );
  }

  @override
  void dispose() {
    _config.trigger.removeListener(_onTriggerChanged);
    super.dispose();
  }

  @override
  Future<void> executeAnimation() async {
    controller.duration = duration;

    try {
      await controller.forward(from: 0.0);
    } on TickerCanceled {
      // Animation was cancelled - this is normal
    }
  }

  @override
  void updateDriver(covariant KeyframeAnimationConfig<S> config) {
    _config.trigger.removeListener(_onTriggerChanged);
    _config = config;
    _setUpAnimation();
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
  NoAnimationDriver({required super.vsync, required super.initialSpec}) {
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
