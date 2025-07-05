import 'package:flutter/animation.dart';

import '../../internal/constants.dart';
import 'animation_config_dto.dart';

@Deprecated('Use AnimationConfig instead. This will be removed in version 2.0')
typedef AnimatedData = AnimationConfig;

/// Configuration data for animated styles in the Mix framework.
///
/// Encapsulates animation parameters including duration, curve, and completion
/// callback for use with animated widgets and style transitions.
class AnimationConfig {
  final VoidCallback? _onEnd;
  final Curve? _curve;
  final Duration? _duration;

  /// Creates animation data with the specified parameters.
  const AnimationConfig({
    required Duration? duration,
    required Curve? curve,
    VoidCallback? onEnd,
  })  : _curve = curve,
        _duration = duration,
        _onEnd = onEnd;

  /// Creates animation data with default settings.
  const AnimationConfig.withDefaults()
      : _duration = kDefaultAnimationDuration,
        _curve = Curves.linear,
        _onEnd = null;

  /// Duration of the animation, defaults to [kDefaultAnimationDuration] if not specified.
  Duration get duration => _duration ?? kDefaultAnimationDuration;

  /// Animation curve, defaults to [Curves.linear] if not specified.
  Curve get curve => _curve ?? Curves.linear;

  VoidCallback? get onEnd => _onEnd;

  AnimationConfigDto toDto() {
    return AnimationConfigDto(duration: duration, curve: curve, onEnd: _onEnd);
  }

  AnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onEnd,
  }) {
    return AnimationConfig(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onEnd: onEnd ?? this.onEnd,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnimationConfig &&
        other._curve == _curve &&
        other._duration == _duration;
  }

  @override
  int get hashCode => _curve.hashCode ^ _duration.hashCode;
}
