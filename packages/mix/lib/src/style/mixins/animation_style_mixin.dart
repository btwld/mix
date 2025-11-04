import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/spec.dart';
import '../../core/style.dart';

mixin AnimationStyleMixin<T extends Style<S>, S extends Spec<S>> on Style<S> {
  @protected
  T animate(AnimationConfig config);

  /// Creates a keyframe animation. It will animate through the given timeline.
  T keyframeAnimation({
    required Listenable trigger,
    required List<KeyframeTrack> timeline,
    required KeyframeStyleBuilder<S, T> styleBuilder,
  }) {
    return animate(
      KeyframeAnimationConfig<S>(
        trigger: trigger,
        timeline: timeline,
        styleBuilder: (values, style) => styleBuilder(values, style as T),
        initialStyle: this,
      ),
    );
  }

  /// Creates a phase animation. It will animate through the given phases.
  T phaseAnimation<P>({
    required Listenable trigger,
    required List<P> phases,
    required T Function(P phase, T style) styleBuilder,
    required CurveAnimationConfig Function(P phase) configBuilder,
  }) {
    final styles = <T>[];
    final configs = <CurveAnimationConfig>[];

    for (final phase in phases) {
      styles.add(styleBuilder(phase, this as T));
      configs.add(configBuilder(phase));
    }

    return animate(
      PhaseAnimationConfig<S, T>(
        styles: styles,
        curveConfigs: configs,
        trigger: trigger,
      ),
    );
  }
}
