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

/// A widget that animates through style phases when its trigger changes.
class StylePhaseAnimator extends StatefulWidget {
  /// Creates a StylePhaseAnimator.
  ///
  /// The [phases], [animation], [child] and [trigger] parameters must not be null.
  const StylePhaseAnimator({
    super.key,
    required this.phases,
    required this.animation,
    required this.child,
    required this.trigger,
  });

  /// The map of variants to their corresponding styles.
  final Map<Variant, Style> phases;

  /// Function that returns animation configuration for each phase.
  final PhaseAnimationData Function(Variant phase) animation;

  /// The widget to apply the animated styles to.
  final Widget child;

  /// Object that triggers the animation cycle when it changes.
  /// The trigger is used to restart the animation when it changes.
  final Object trigger;

  @override
  State<StylePhaseAnimator> createState() => _StylePhaseAnimatorState();
}

class _StylePhaseAnimatorState extends State<StylePhaseAnimator> {
  Style get _definitiveStyle => Style.create(
        widget.phases.entries.map((e) => e.key(e.value())),
      );

  List<Variant> get _variants => widget.phases.keys.toList();

  int _currentIndex = 0;
  Variant get _currentVariant => _variants[_currentIndex];

  void _next() {
    final int nextIndex;
    if (_currentIndex == _variants.length - 1) {
      nextIndex = 0;
    } else {
      nextIndex = (_currentIndex + 1).clamp(0, _variants.length - 1);
    }

    setState(() {
      _currentIndex = nextIndex;
    });
  }

  void _runAnimation() async {
    for (var i = 0; i < _variants.length; i++) {
      final variant = _variants[i];
      final delay = widget.animation(variant).delay;
      final duration = widget.animation(variant).duration;
      if (i == 0) {
        _next();
        continue;
      }
      await Future.delayed(delay + duration, () {
        if (mounted) _next();
      });
    }
  }

  @override
  void didUpdateWidget(covariant StylePhaseAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger != widget.trigger) {
      _currentIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _runAnimation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final animation = widget.animation(_currentVariant);

    return SpecBuilder(
      style: _definitiveStyle.applyVariant(_currentVariant).animate(
            duration: animation.duration,
            curve: animation.curve,
          ),
      builder: (context) {
        return widget.child;
      },
    );
  }
}
