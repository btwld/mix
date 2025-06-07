import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../attributes/animated/animated_data.dart';
import '../core/animated_spec_widget.dart';
import '../core/factory/mix_provider.dart';
import '../core/factory/style_mix.dart';
import '../core/spec.dart';

typedef SpecAnimatorWidgetBuilder = Widget Function(
  BuildContext context,
  Style style,
);

class SpecPhaseAnimationData extends AnimatedData {
  final Duration delay;

  const SpecPhaseAnimationData({
    required super.duration,
    required super.curve,
    this.delay = Duration.zero,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SpecPhaseAnimationData &&
            super == other &&
            delay == other.delay;
  }

  @override
  int get hashCode => super.hashCode ^ delay.hashCode;
}

class SpecPhaseAnimator<Phase extends Object, A extends SpecAttribute,
    S extends Spec<S>> extends StatelessWidget {
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
  final SpecAnimatorWidgetBuilder builder;
  final Object? trigger;

  _PhaseData<Phase, A> _buildPhaseData() {
    final phaseData = <Phase, _PhaseDataUnit<A>>{};
    for (final phase in phases) {
      phaseData[phase] = (
        attribute: phaseBuilder(phase).styles.values.firstWhere(
              (e) => e is A,
            ) as A,
        animation: animation(phase),
      );
    }

    return _PhaseData(phaseData: phaseData);
  }

  @override
  Widget build(BuildContext context) {
    return _SpecPhaseAnimatorScope<Phase, A, S>(
      data: _buildPhaseData(),
      trigger: trigger,
      child: _SpecPhaseAnimator<Phase, A, S>(
        phases: phases,
        builder: builder,
        trigger: trigger,
      ),
    );
  }
}

class _SpecPhaseAnimatorScope<Phase extends Object, A extends SpecAttribute,
    S extends Spec<S>> extends InheritedWidget {
  const _SpecPhaseAnimatorScope({
    required this.data,
    required this.trigger,
    required super.child,
  });

  static _SpecPhaseAnimatorScope<Phase, A, S>
      of<Phase extends Object, A extends SpecAttribute, S extends Spec<S>>(
    BuildContext context,
  ) {
    final scope = context.dependOnInheritedWidgetOfExactType<
        _SpecPhaseAnimatorScope<Phase, A, S>>();
    assert(scope != null, 'No _SpecPhaseAnimatorScope found in context');

    return scope!;
  }

  final _PhaseData<Phase, A> data;
  final Object? trigger;

  @override
  bool updateShouldNotify(_SpecPhaseAnimatorScope<Phase, A, S> oldWidget) {
    return data != oldWidget.data || trigger != oldWidget.trigger;
  }
}

class _SpecPhaseAnimator<Phase extends Object, A extends SpecAttribute,
    S extends Spec<S>> extends StatefulWidget {
  const _SpecPhaseAnimator({
    required this.phases,
    required this.builder,
    this.trigger,
  });

  final List<Phase> phases;
  final SpecAnimatorWidgetBuilder builder;

  final Object? trigger;

  @override
  State<_SpecPhaseAnimator<Phase, A, S>> createState() =>
      _SpecPhaseAnimatorState<Phase, A, S>();
}

class _SpecPhaseAnimatorState<Phase extends Object, A extends SpecAttribute,
        S extends Spec<S>> extends State<_SpecPhaseAnimator<Phase, A, S>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
  );

  late Object? _cachedTrigger = widget.trigger;
  _PhaseData<Phase, A>? _cachedData;

  TweenSequence<S?>? _sequence;

  @override
  void initState() {
    super.initState();

    final shouldRepeat = widget.trigger == null;

    if (shouldRepeat) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.repeat();
      });
    }
  }

  void _configureAnimation(_PhaseData<Phase, A> phaseData) {
    final items = <TweenSequenceItem<S?>>[];
    _controller.duration = phaseData.totalDuration;

    for (var i = 0; i < phaseData.length; i++) {
      final mixData = Mix.of(context);

      final currentPhase = widget.phases[i];
      final currentPhaseData = phaseData[currentPhase];
      final currentSpec = currentPhaseData.attribute.resolve(mixData);

      final nextPhase = widget.phases[(i + 1) % widget.phases.length];
      final nextSpec = phaseData[nextPhase].attribute.resolve(mixData);
      final nextDelayWeight = phaseData.delayWeightFor(nextPhase);

      items.addAll([
        if (nextDelayWeight > 0)
          TweenSequenceItem(
            tween: ConstantTween(currentSpec),
            weight: nextDelayWeight,
          ),
        TweenSequenceItem(
          tween: SpecTween<S>(begin: currentSpec, end: nextSpec)
              .chain(CurveTween(curve: currentPhaseData.animation.curve)),
          weight: phaseData.weightFor(currentPhase),
        ),
      ]);
    }

    _sequence = TweenSequence(items);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = _SpecPhaseAnimatorScope.of<Phase, A, S>(context);

    if (_cachedData != scope.data) {
      _cachedData = scope.data;
      _configureAnimation(scope.data);
    }

    if (_cachedTrigger != scope.trigger) {
      _cachedTrigger = scope.trigger;
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final style = Style(_sequence?.evaluate(_controller)?.toAttribute());

        return widget.builder(context, style);
      },
    );
  }
}

class _PhaseData<Phase extends Object, A extends SpecAttribute> {
  final Map<Phase, _PhaseDataUnit<A>> phaseData;

  const _PhaseData({required this.phaseData});

  Duration get totalDuration {
    return phaseData.values.map((e) => e.totalDuration).reduce((a, b) => a + b);
  }

  int get length => phaseData.length;

  double delayWeightFor(Phase phase) {
    final animation = phaseData[phase]!.animation;

    return animation.delay.inMilliseconds / totalDuration.inMilliseconds;
  }

  double weightFor(Phase phase) {
    final animation = phaseData[phase]!.animation;

    return animation.duration.inMilliseconds / totalDuration.inMilliseconds;
  }

  _PhaseDataUnit<A> operator [](Phase phase) {
    return phaseData[phase]!;
  }

  @override
  bool operator ==(Object other) {
    return other is _PhaseData<Phase, A> &&
        mapEquals(phaseData, other.phaseData);
  }

  @override
  int get hashCode => phaseData.hashCode;
}

typedef _PhaseDataUnit<A extends SpecAttribute> = ({
  A attribute,
  SpecPhaseAnimationData animation,
});

extension on _PhaseDataUnit {
  Duration get totalDuration => animation.duration + animation.delay;
}
