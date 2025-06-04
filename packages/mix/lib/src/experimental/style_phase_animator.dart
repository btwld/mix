import 'dart:async';

import 'package:flutter/widgets.dart';

import '../core/factory/style_mix.dart';
import '../core/styled_widget.dart';
import '../core/variant.dart';

/// Configuration data for a single phase animation.
///
/// Defines the [duration], [curve] and [delay] for transitioning to a phase.
class PhaseAnimationData {
  /// The duration of the animation.
  final Duration duration;

  /// The curve to use for the animation.
  final Curve curve;

  /// Optional delay before starting the animation.
  final Duration delay;

  /// Creates animation data with the specified parameters.
  const PhaseAnimationData({
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.delay = Duration.zero,
  });

  /// Creates animation data with zero duration and delay.
  const PhaseAnimationData.zero()
      : duration = Duration.zero,
        curve = Curves.easeInOut,
        delay = Duration.zero;
}

typedef PhaseAnimatorWidgetBuilder = Widget Function(
  BuildContext context,
  Style style,
  Variant variant,
);

abstract class PhaseVariant {
  const PhaseVariant();

  Variant get variant;
}

/// A widget that animates through style phases when its trigger changes.
class StylePhaseAnimator<V extends PhaseVariant> extends StatefulWidget {
  /// Creates a StylePhaseAnimator.
  ///
  /// The [phases], [animation], [child] and [trigger] parameters must not be null.
  const StylePhaseAnimator({
    super.key,
    required this.phases,
    required this.animation,
    required this.builder,
    this.trigger,
  }) : assert(phases.length > 1, 'Phases map must have at least 2 phases');

  /// The map of variants to their corresponding styles.
  final Map<V, Style> phases;

  /// Function that returns animation configuration for each phase.
  final PhaseAnimationData Function(V phase) animation;

  /// The widget to apply the animated styles to.
  final PhaseAnimatorWidgetBuilder builder;

  /// Object that triggers the animation cycle when it changes.
  /// The trigger is used to restart the animation when it changes.
  final Object? trigger;

  @override
  State<StylePhaseAnimator<V>> createState() => _StylePhaseAnimatorState<V>();
}

class _StylePhaseAnimatorState<V extends PhaseVariant>
    extends State<StylePhaseAnimator<V>> {
  Style get _definitiveStyle => Style.create(
        widget.phases.entries.map((e) => e.key.variant(e.value())),
      );

  List<V> get _variants => widget.phases.keys.toList();

  int _currentIndex = 0;
  V get _currentVariant => _variants[_currentIndex];

  bool get _hasTrigger => widget.trigger != null;
  bool _firstAnimation = true;

  Timer? _animationTimer;
  @override
  void initState() {
    super.initState();
    if (!_hasTrigger) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _runInfiniteAnimation();
      });
    }
  }

  void _next() {
    final int nextIndex;
    if (_currentIndex == _variants.length - 1) {
      nextIndex = 0;
    } else {
      nextIndex = (_currentIndex + 1);
    }

    setState(() {
      _currentIndex = nextIndex;
    });
  }

  Future<void> _runAnimation() async {
    for (var i = 0; i < _variants.length; i++) {
      final variant = _variants[i];
      final delay = widget.animation(variant).delay;
      final duration = widget.animation(variant).duration;

      if (i == 0) {
        _next();
        continue;
      }

      await _waitForTimer(delay + duration).then((_) {
        if (mounted) _next();
      });
    }
  }

  void _runInfiniteAnimation() async {
    _animationTimer?.cancel();
    while (true) {
      for (var i = 0; i < _variants.length; i++) {
        final variant = _variants[i];
        final delay = widget.animation(variant).delay;
        final duration = widget.animation(variant).duration;

        if (i == 0 && _firstAnimation) {
          _firstAnimation = false;
          _next();
          continue;
        }

        await _waitForTimer(delay + duration).then((_) {
          if (mounted) _next();
        });
      }
    }
  }

  Future<void> _waitForTimer(Duration duration) {
    final completer = Completer<void>();
    _animationTimer = Timer(duration, () => completer.complete());

    return completer.future;
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _animationTimer = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant StylePhaseAnimator<V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_hasTrigger && oldWidget.trigger != widget.trigger) {
      _currentIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animationTimer?.cancel();
        _runAnimation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final animation = widget.animation(_currentVariant);
    final style =
        _definitiveStyle.applyVariant(_currentVariant.variant).animate(
              duration: animation.duration,
              curve: animation.curve,
            );

    return SpecBuilder(
      style: style,
      builder: (context) {
        return widget.builder(context, style, _currentVariant.variant);
      },
    );
  }
}
