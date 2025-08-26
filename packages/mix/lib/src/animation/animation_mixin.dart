import 'package:flutter/widgets.dart';

import '../core/style.dart';
import '../core/widget_spec.dart';
import 'animation_config.dart';

mixin StyleAnimationMixin<S extends WidgetSpec<S>, T extends Style<S>>
    on Style<S> {
  @protected
  T animate(AnimationConfig config);

  T keyframes({
    required Listenable trigger,
    required List<KeyframeTrack> timeline,
    required KeyframeStyleBuilder<S, Style<S>> styleBuilder,
  }) {
    return animate(
      KeyframeAnimationConfig<S>(
        trigger: trigger,
        timeline: timeline,
        styleBuilder: styleBuilder,
        initialStyle: this,
      ),
    );
  }

  T phaseAnimation<P>({
    required Listenable trigger,
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
