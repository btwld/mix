import 'package:flutter/animation.dart';

import '../../core/factory/mix_context.dart';
import '../../core/mix_element.dart';
import '../../core/mix_value.dart';
import '../../internal/constants.dart';
import 'animation_config.dart';

@Deprecated(
  'Use AnimationConfigDto instead. This will be removed in version 2.0',
)
typedef AnimatedDataDto = AnimationConfigDto;

class AnimationConfigDto extends Mix<AnimationConfig> {
  // Properties use MixableProperty for cleaner merging
  final Mixable<Duration> duration;
  final Mixable<Curve> curve;
  final Mixable<VoidCallback> onEnd;

  // Main constructor accepts Mix values
  factory AnimationConfigDto({
    Mix<Duration>? duration,
    Mix<Curve>? curve,
    Mix<VoidCallback>? onEnd,
  }) {
    return AnimationConfigDto._(
      duration: Mixable(duration),
      curve: Mixable(curve),
      onEnd: Mixable(onEnd),
    );
  }

  // Private constructor that accepts MixProp instances
  const AnimationConfigDto._({
    required this.duration,
    required this.curve,
    required this.onEnd,
  });

  factory AnimationConfigDto.withDefaults() {
    return AnimationConfigDto(
      duration: const DurationMix(kDefaultAnimationDuration),
      curve: const CurveMix(Curves.linear),
      onEnd: null,
    );
  }

  @override
  AnimationConfig resolve(MixContext mix) {
    return AnimationConfig(
      duration: duration.resolve(mix),
      curve: curve.resolve(mix),
      onEnd: onEnd.resolve(mix),
    );
  }

  @override
  AnimationConfigDto merge(AnimationConfigDto? other) {
    if (other == null) return this;

    return AnimationConfigDto._(
      duration: duration.merge(other.duration),
      curve: curve.merge(other.curve),
      onEnd: onEnd.merge(other.onEnd),
    );
  }

  @override
  get props => [duration, curve];
}
