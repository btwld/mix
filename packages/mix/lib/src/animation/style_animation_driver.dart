import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../core/spec.dart';
import '../core/widget_spec.dart';
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

  /// Mutable tween for animating between specs.
  @protected
  final _tween = SpecTween<StyleSpec<S>>();

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
  Animation<StyleSpec<S>?> get animation => _animation;

  /// Whether the animation should automatically animate to the new spec when the spec changes.
  bool get autoAnimateOnUpdate;

  /// Animates to the given target spec.
  @nonVirtual
  Future<void> animateTo(StyleSpec<S> targetSpec) async {
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
class CurveAnimationDriver<S extends Spec<S>> extends StyleAnimationDriver<S> {
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

  TweenSequence<StyleSpec<S>?> _createTweenSequence() => TweenSequence([
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

  @override
  bool get autoAnimateOnUpdate => true;
}

/// A driver for spring-based physics animations.
class SpringAnimationDriver<S extends Spec<S>> extends StyleAnimationDriver<S> {
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

  @override
  bool get autoAnimateOnUpdate => true;
}

class PhaseAnimationDriver<S extends Spec<S>> extends StyleAnimationDriver<S> {
  final List<StyleSpec<S>> specs;
  final List<CurveAnimationConfig> curveConfigs;
  final Listenable trigger;

  late final TweenSequence<StyleSpec<S>?> _tweenSequence;

  PhaseAnimationDriver({
    required super.vsync,
    required this.curveConfigs,
    required this.specs,
    required super.initialSpec,
    required this.trigger,
  }) {
    _tweenSequence = _createTweenSequence(specs, curveConfigs);

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

  TweenSequence<StyleSpec<S>?> _createTweenSequence(
    List<StyleSpec<S>> specs,
    List<CurveAnimationConfig> configs,
  ) {
    final items = <TweenSequenceItem<StyleSpec<S>?>>[];
    for (int i = 0; i < specs.length; i++) {
      final currentIndex = i % specs.length;
      final nextIndex = (i + 1) % specs.length;

      if (configs[currentIndex].delay > Duration.zero) {
        items.add(
          TweenSequenceItem(
            tween: ConstantTween(specs[currentIndex]),
            weight: configs[currentIndex].delay.inMilliseconds.toDouble(),
          ),
        );
      }

      final tween = SpecTween<StyleSpec<S>>(
        begin: specs[currentIndex],
        end: specs[nextIndex],
      );
      final item = TweenSequenceItem(
        tween: tween.chain(CurveTween(curve: configs[currentIndex].curve)),
        weight: configs[currentIndex].duration.inMilliseconds.toDouble(),
      );

      items.add(item);
    }

    return TweenSequence(items);
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

  @override
  bool get autoAnimateOnUpdate => false;
}

/// A driver for keyframe-based animations with complex timeline control.
class KeyframeAnimationDriver<S extends Spec<S>>
    extends StyleAnimationDriver<S> {
  final BuildContext context;

  final KeyframeAnimationConfig<S> _config;
  late final Map<String, Animatable> _sequenceMap;

  KeyframeAnimationDriver({
    required super.vsync,
    required KeyframeAnimationConfig<S> config,
    required super.initialSpec,
    required this.context,
  }) : _config = config {
    _sequenceMap = {
      for (final track in _config.timeline)
        track.id: track.createSequenceTween(duration),
    };

    _animation = controller.drive(
      _KeyframeAnimatable(_sequenceMap, _config, context),
    );

    // Listen to the trigger
    _config.trigger.addListener(_onTriggerChanged);
  }

  void _onTriggerChanged() {
    executeAnimation();
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
  bool get autoAnimateOnUpdate => false;
}

class _KeyframeAnimatable<S extends Spec<S>>
    extends Animatable<StyleSpec<S>?> {
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
