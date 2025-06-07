import 'package:flutter/widgets.dart';

import '../attributes/animated/animated_data.dart';
import '../core/animated_spec_widget.dart';
import '../core/factory/mix_provider.dart';
import '../core/factory/style_mix.dart';
import '../core/spec.dart';

typedef SpecAnimatorWidgetBuilder<Phase extends Object> = Widget Function(
  BuildContext context,
  Style style,
  Phase phase,
);

class SpecPhaseAnimationData extends AnimatedData {
  final Duration delay;

  const SpecPhaseAnimationData({
    required super.duration,
    required super.curve,
    this.delay = Duration.zero,
  });
}

class SpecPhaseAnimator<Phase extends Object, A extends SpecAttribute,
    S extends Spec<S>> extends StatefulWidget {
  const SpecPhaseAnimator({
    super.key,
    required this.phases,
    required this.phaseBuilder,
    required this.builder,
    required this.animation,
    this.trigger,
  });

  final List<Phase> phases;
  final Style Function(Phase phase) phaseBuilder;
  final SpecPhaseAnimationData Function(Phase phase) animation;
  final SpecAnimatorWidgetBuilder<Phase> builder;
  final Object? trigger;

  @override
  State<SpecPhaseAnimator<Phase, A, S>> createState() =>
      _SpecPhaseAnimatorState<Phase, A, S>();
}

class _SpecPhaseAnimatorState<Phase extends Object, A extends SpecAttribute,
        S extends Spec<S>> extends State<SpecPhaseAnimator<Phase, A, S>>
    with SingleTickerProviderStateMixin {
  final Map<Phase, _PhaseData<A>> _phaseData = {};
  final Map<Phase, ({double min, double max})> _phaseWeights = {};
  late final AnimationController _controller = AnimationController(
    vsync: this,
  );
  bool get _isInfinite => widget.trigger == null;

  TweenSequence<S?>? _sequence;

  @override
  void initState() {
    super.initState();

    _setUpInternalMaps();
    if (_isInfinite) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.repeat();
      });
    }
  }

  void _setUpInternalMaps() {
    for (final phase in widget.phases) {
      _phaseData[phase] = _PhaseData(
        attribute: widget.phaseBuilder(phase).styles.values.firstWhere(
              (e) => e is A,
            ) as A,
        animation: widget.animation(phase),
      );
    }
  }

  void _buildSequence() {
    final items = <TweenSequenceItem<S?>>[];

    double accumulatedWeight = 0.0;
    for (var i = 0; i < _phaseData.length; i++) {
      final mixData = Mix.of(context);

      final currentPhase = widget.phases[i];
      final currentSpec = _phaseData[currentPhase]!.attribute.resolve(mixData);

      final nextPhase = widget.phases[(i + 1) % widget.phases.length];
      final nextSpec = _phaseData[nextPhase]!.attribute.resolve(mixData);

      final currentAnimation = _phaseData[currentPhase]!.animation;
      final weight = currentAnimation.duration.inMilliseconds /
          _phaseData.totalDuration.inMilliseconds;

      final nextAnimation = _phaseData[nextPhase]!.animation;
      final delayWeight = nextAnimation.delay.inMilliseconds /
          _phaseData.totalDuration.inMilliseconds;

      items.addAll(
        [
          if (nextAnimation.delay > Duration.zero)
            TweenSequenceItem(
              tween: ConstantTween(currentSpec),
              weight: delayWeight,
            ),
          TweenSequenceItem(
            tween: SpecTween<S>(begin: currentSpec, end: nextSpec)
                .chain(CurveTween(curve: currentAnimation.curve)),
            weight: weight,
          ),
        ],
      );

      _phaseWeights[currentPhase] = (
        min: accumulatedWeight,
        max: accumulatedWeight + weight,
      );

      accumulatedWeight += weight;
    }

    _sequence = TweenSequence<S?>(items);
  }

  Phase _getCurrentPhase(AnimationController controller) {
    final t = controller.value;
    for (final phase in _phaseWeights.keys) {
      final (:min, :max) = _phaseWeights[phase]!;
      if (t >= min && t < max) {
        return phase;
      }
    }

    return _phaseWeights.keys.last;
  }

  @override
  void didUpdateWidget(SpecPhaseAnimator<Phase, A, S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.trigger != widget.trigger) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.forward(from: 0);
      });
    }
    _sequence = null;
    _setUpInternalMaps();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sequence == null) {
      _controller.duration = _phaseData.totalDuration;
      _buildSequence();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final style = Style(_sequence?.evaluate(_controller)?.toAttribute());

        return widget.builder(context, style, _getCurrentPhase(_controller));
      },
    );
  }
}

extension _PhaseDataMapExtension on Map<Object, _PhaseData> {
  Duration get totalDuration {
    return values.map((e) => e.totalDuration).reduce((a, b) => a + b);
  }
}

class _PhaseData<A extends SpecAttribute> {
  final A attribute;
  final SpecPhaseAnimationData animation;

  const _PhaseData({required this.attribute, required this.animation});

  Duration get totalDuration => animation.duration + animation.delay;
}
