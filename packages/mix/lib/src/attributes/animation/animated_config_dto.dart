import 'package:flutter/animation.dart';

import '../../core/factory/mix_context.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../internal/constants.dart';
import 'animation_config.dart';

@Deprecated(
  'Use AnimationConfigDto instead. This will be removed in version 2.0',
)
typedef AnimatedDataDto = AnimationConfigDto;

class AnimationConfigDto extends Mix<AnimationConfig> {
  // Properties use MixableProperty for cleaner merging
  final Prop<Duration>? duration;
  final Prop<Curve>? curve;
  final Prop<VoidCallback>? onEnd;

  // Main constructor accepts raw values
  factory AnimationConfigDto({
    Duration? duration,
    Curve? curve,
    VoidCallback? onEnd,
  }) {
    return AnimationConfigDto._(
      duration: Prop.maybeValue(duration),
      curve: Prop.maybeValue(curve),
      onEnd: Prop.maybeValue(onEnd),
    );
  }

  // Private constructor that accepts MixableProperty instances
  const AnimationConfigDto._({this.duration, this.curve, this.onEnd});

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
      duration: resolveProp(mix, duration),
      curve: resolveProp(mix, curve),
      onEnd: resolveProp(mix, onEnd),
    );
  }

  @override
  AnimationConfigDto merge(AnimationConfigDto? other) {
    if (other == null) return this;

    return AnimationConfigDto._(
      duration: mergeProp(duration, other.duration),
      curve: mergeProp(curve, other.curve),
      onEnd: mergeProp(onEnd, other.onEnd),
    );
  }

  @override
  get props => [duration, curve];
}
