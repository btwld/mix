import 'package:flutter/widgets.dart';

import '../core/spec.dart';
import '../core/style.dart';
import 'animation_config.dart';

mixin StyleAnimationMixin<S extends Spec<S>, T extends Style<S>> on Style<S> {
  @protected
  T animate(AnimationConfig config);

  T phaseAnimation<P>({
    required ValueNotifier trigger,
    required List<P> phases,
    required T Function(P phase, T style) styleBuilder,
    required CurveAnimationConfig Function(P phase) configBuilder,
    PhaseAnimationMode mode = PhaseAnimationMode.simpleLoop,
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
        mode: mode,
      ),
    );
  }
}
