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
    return AnimationConfigDto.props(
      duration: Prop.maybeValue(duration),
      curve: Prop.maybeValue(curve),
      onEnd: Prop.maybeValue(onEnd),
    );
  }

  /// Constructor that accepts an [AnimationConfig] value and extracts its properties.
  ///
  /// This is useful for converting existing [AnimationConfig] instances to [AnimationConfigDto].
  ///
  /// ```dart
  /// const config = AnimationConfig(duration: Duration(milliseconds: 300));
  /// final dto = AnimationConfigDto.value(config);
  /// ```
  factory AnimationConfigDto.value(AnimationConfig config) {
    return AnimationConfigDto(
      duration: config.duration,
      curve: config.curve,
      onEnd: config.onEnd,
    );
  }

  // Props constructor that accepts Prop instances
  const AnimationConfigDto.props({this.duration, this.curve, this.onEnd});

  factory AnimationConfigDto.withDefaults() {
    return AnimationConfigDto(
      duration: kDefaultAnimationDuration,
      curve: Curves.linear,
      onEnd: null,
    );
  }

  /// Constructor that accepts a nullable [AnimationConfig] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [AnimationConfigDto.value].
  ///
  /// ```dart
  /// const AnimationConfig? config = AnimationConfig(duration: Duration(milliseconds: 300));
  /// final dto = AnimationConfigDto.maybeValue(config); // Returns AnimationConfigDto or null
  /// ```
  static AnimationConfigDto? maybeValue(AnimationConfig? config) {
    return config != null ? AnimationConfigDto.value(config) : null;
  }

  @override
  AnimationConfig resolve(MixContext context) {
    return AnimationConfig(
      duration: resolveProp(context, duration),
      curve: resolveProp(context, curve),
      onEnd: resolveProp(context, onEnd),
    );
  }

  @override
  AnimationConfigDto merge(AnimationConfigDto? other) {
    if (other == null) return this;

    return AnimationConfigDto.props(
      duration: mergeProp(duration, other.duration),
      curve: mergeProp(curve, other.curve),
      onEnd: mergeProp(onEnd, other.onEnd),
    );
  }

  @override
  get props => [duration, curve];
}
