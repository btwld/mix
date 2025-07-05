import 'package:flutter/animation.dart';

import '../../core/element.dart';
import '../../core/factory/mix_context.dart';
import '../../internal/constants.dart';
import 'animation_config.dart';

@Deprecated('Use AnimationConfigDto instead. This will be removed in version 2.0')
typedef AnimatedDataDto = AnimationConfigDto;

class AnimationConfigDto extends Mixable<AnimationConfig> {
  final Duration? duration;
  final Curve? curve;
  final VoidCallback? onEnd;

  const AnimationConfigDto({
    required this.duration,
    required this.curve,
    this.onEnd,
  });

  const AnimationConfigDto.withDefaults()
      : duration = kDefaultAnimationDuration,
        curve = Curves.linear,
        onEnd = null;

  @override
  AnimationConfig resolve(MixContext mix) {
    return AnimationConfig(duration: duration, curve: curve, onEnd: onEnd);
  }

  @override
  AnimationConfigDto merge(AnimationConfigDto? other) {
    return AnimationConfigDto(
      duration: other?.duration ?? duration,
      curve: other?.curve ?? curve,
    );
  }

  @override
  get props => [duration, curve];
}
