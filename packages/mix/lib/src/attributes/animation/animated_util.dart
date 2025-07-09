import 'package:flutter/widgets.dart';

import '../../core/factory/mix_context.dart';
import '../../core/mix_element.dart';
import '../../core/utility.dart';
import '../scalars/curves.dart';
import '../scalars/scalar_util.dart';
import 'animated_config_dto.dart';
import 'animation_config.dart';

final class AnimatedUtility<T extends StyleElement>
    extends DtoUtility<T, AnimationConfigDto, AnimationConfig> {
  AnimatedUtility(super.builder)
    : super(valueToDto: (value) => AnimationConfigDto(
          duration: value.duration != null ? DurationMix(value.duration) : null,
          curve: value.curve != null ? CurveMix(value.curve) : null,
          onEnd: value.onEnd != null ? _VoidCallbackMix(value.onEnd!) : null,
        ));

  DurationUtility<T> get duration => DurationUtility((v) => only(duration: DurationMix(v)));

  CurveUtility<T> get curve => CurveUtility((v) => only(curve: CurveMix(v)));

  T linear(Duration duration) => only(duration: DurationMix(duration), curve: CurveMix(Curves.linear));
  T ease(Duration duration) => only(duration: DurationMix(duration), curve: CurveMix(Curves.ease));
  T easeIn(Duration duration) => only(duration: DurationMix(duration), curve: CurveMix(Curves.easeIn));
  T easeOut(Duration duration) =>
      only(duration: DurationMix(duration), curve: CurveMix(Curves.easeOut));
  T easeInOut(Duration duration) =>
      only(duration: DurationMix(duration), curve: CurveMix(Curves.easeInOut));
  T fastOutSlowIn(Duration duration) =>
      only(duration: DurationMix(duration), curve: CurveMix(Curves.fastOutSlowIn));
  T bounceIn(Duration duration) =>
      only(duration: DurationMix(duration), curve: CurveMix(Curves.bounceIn));
  T bounceOut(Duration duration) =>
      only(duration: DurationMix(duration), curve: CurveMix(Curves.bounceOut));
  T bounceInOut(Duration duration) =>
      only(duration: DurationMix(duration), curve: CurveMix(Curves.bounceInOut));
  T elasticIn(Duration duration) =>
      only(duration: DurationMix(duration), curve: CurveMix(Curves.elasticIn));
  T elasticOut(Duration duration) =>
      only(duration: DurationMix(duration), curve: CurveMix(Curves.elasticOut));
  T elasticInOut(Duration duration) =>
      only(duration: DurationMix(duration), curve: CurveMix(Curves.elasticInOut));

  T spring({
    double stiffness = 3.5,
    double dampingRatio = 1.0,
    double mass = 1.0,
    Duration duration = const Duration(milliseconds: 300),
  }) => only(
    duration: DurationMix(duration),
    curve: CurveMix(SpringCurve(
      stiffness: stiffness,
      dampingRatio: dampingRatio,
      mass: mass,
    )),
  );

  @override
  T only({Mix<Duration>? duration, Mix<Curve>? curve}) {
    return builder(AnimationConfigDto(duration: duration, curve: curve));
  }
}

// Helper class for VoidCallback
class _VoidCallbackMix extends Mix<VoidCallback> {
  final VoidCallback value;
  const _VoidCallbackMix(this.value);

  @override
  VoidCallback resolve(MixContext mix) => value;

  @override
  Mix<VoidCallback> merge(Mix<VoidCallback>? other) {
    return other ?? this;
  }

  @override
  get props => [value];
}
