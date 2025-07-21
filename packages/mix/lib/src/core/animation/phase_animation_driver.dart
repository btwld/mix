import 'package:flutter/widgets.dart';

import '../spec.dart';
import '../style_mix.dart';
import 'animation_driver.dart';

/// A driver for phase-based animations similar to SwiftUI's PhaseAnimator.
///
/// This driver animates through a sequence of phases, where each phase
/// represents a different style configuration.
class PhaseAnimationDriver<S extends Spec<S>, P> extends AnimationDriver<S> {
  final List<P> phases;
  final Style<S> Function(P phase) phaseBuilder;
  final Duration duration;
  final Curve curve;
  final bool repeat;

  const PhaseAnimationDriver({
    required this.phases,
    required this.phaseBuilder,
    required this.duration,
    this.curve = Curves.linear,
    this.repeat = false,
  });

  @override
  Widget build({
    required BuildContext context,
    required Style<S> style,
    required Widget Function(BuildContext context, ResolvedStyle<S> resolved)
    builder,
  }) {
    return _PhaseAnimationWidget<S, P>(
      phases: phases,
      phaseBuilder: phaseBuilder,
      duration: duration,
      curve: curve,
      repeat: repeat,
      builder: builder,
    );
  }
}

// Internal widget for phase animations
class _PhaseAnimationWidget<S extends Spec<S>, P> extends StatefulWidget {
  const _PhaseAnimationWidget({
    super.key,
    required this.phases,
    required this.phaseBuilder,
    required this.duration,
    required this.curve,
    required this.repeat,
    required this.builder,
  });

  final List<P> phases;
  final Style<S> Function(P phase) phaseBuilder;
  final Duration duration;
  final Curve curve;
  final bool repeat;
  final Widget Function(BuildContext context, ResolvedStyle<S> resolved)
  builder;

  @override
  State<_PhaseAnimationWidget<S, P>> createState() =>
      _PhaseAnimationWidgetState<S, P>();
}

class _PhaseAnimationWidgetState<S extends Spec<S>, P>
    extends State<_PhaseAnimationWidget<S, P>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _currentPhaseIndex;
  late int _nextPhaseIndex;

  @override
  void initState() {
    super.initState();
    _currentPhaseIndex = 0;
    _nextPhaseIndex = 1 % widget.phases.length;

    _controller = AnimationController(duration: widget.duration, vsync: this);

    _controller.addStatusListener(_handleAnimationStatus);
    _controller.forward();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _currentPhaseIndex = _nextPhaseIndex;
        _nextPhaseIndex = (_currentPhaseIndex + 1) % widget.phases.length;
      });

      if (widget.repeat || _currentPhaseIndex != 0) {
        _controller.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final currentPhase = widget.phases[_currentPhaseIndex];
        final nextPhase = widget.phases[_nextPhaseIndex];

        final currentStyle = widget.phaseBuilder(currentPhase);
        final nextStyle = widget.phaseBuilder(nextPhase);

        final currentResolved = currentStyle.resolve(context);
        final nextResolved = nextStyle.resolve(context);

        final t = widget.curve.transform(_controller.value);
        final interpolatedResolved = currentResolved.lerp(nextResolved, t);

        return widget.builder(context, interpolatedResolved);
      },
    );
  }
}
