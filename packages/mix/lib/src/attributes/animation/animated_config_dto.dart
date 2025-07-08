import 'package:flutter/animation.dart';

import '../../core/element.dart';
import '../../core/factory/mix_context.dart';
import '../../internal/constants.dart';
import 'animation_config.dart';

@Deprecated(
  'Use AnimationConfigDto instead. This will be removed in version 2.0',
)
typedef AnimatedDataDto = AnimationConfigDto;

class AnimationConfigDto extends Mix<AnimationConfig> {
  // Properties use MixableProperty for cleaner merging
  final MixProperty<Duration> duration;
  final MixProperty<Curve> curve;
  final MixProperty<VoidCallback> onEnd;

  // Main constructor accepts real values
  factory AnimationConfigDto({
    Duration? duration,
    Curve? curve,
    VoidCallback? onEnd,
  }) {
    return AnimationConfigDto.raw(
      duration: MixProperty.prop(duration),
      curve: MixProperty.prop(curve),
      onEnd: MixProperty.prop(onEnd),
    );
  }

  // Factory that accepts MixableProperty instances
  const AnimationConfigDto.raw({
    required this.duration,
    required this.curve,
    required this.onEnd,
  });

  factory AnimationConfigDto.withDefaults() {
    return AnimationConfigDto(
      duration: kDefaultAnimationDuration,
      curve: Curves.linear,
      onEnd: null,
    );
  }

  // Factory from AnimationConfig
  factory AnimationConfigDto.from(AnimationConfig config) {
    return AnimationConfigDto(
      duration: config.duration,
      curve: config.curve,
      onEnd: config.onEnd,
    );
  }

  // Nullable factory from AnimationConfig
  static AnimationConfigDto? maybeFrom(AnimationConfig? config) {
    return config != null ? AnimationConfigDto.from(config) : null;
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

    return AnimationConfigDto.raw(
      duration: duration.merge(other.duration),
      curve: curve.merge(other.curve),
      onEnd: onEnd.merge(other.onEnd),
    );
  }

  @override
  get props => [duration, curve];
}
