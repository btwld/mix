import 'package:flutter/animation.dart';

import '../../internal/constants.dart';
import 'animated_data_dto.dart';

/// Configuration data for animated styles in the Mix framework.
///
/// Encapsulates animation parameters including duration, curve, and completion
/// callback for use with animated widgets and style transitions.
//TODO: Consider chainging this to AnimationConfig, as it will be more descriptive for the new animation system
class AnimatedData {
  final VoidCallback? _onEnd;
  final Curve? _curve;
  final Duration? _duration;

  /// Creates animation data with the specified parameters.
  const AnimatedData({
    required Duration? duration,
    required Curve? curve,
    VoidCallback? onEnd,
  })  : _curve = curve,
        _duration = duration,
        _onEnd = onEnd;

  /// Creates animation data with default settings.
  const AnimatedData.withDefaults()
      : _duration = kDefaultAnimationDuration,
        _curve = Curves.linear,
        _onEnd = null;

  /// Duration of the animation, defaults to [kDefaultAnimationDuration] if not specified.
  Duration get duration => _duration ?? kDefaultAnimationDuration;

  /// Animation curve, defaults to [Curves.linear] if not specified.
  Curve get curve => _curve ?? Curves.linear;

  VoidCallback? get onEnd => _onEnd;

  AnimatedDataDto toDto() {
    return AnimatedDataDto(duration: duration, curve: curve, onEnd: _onEnd);
  }

  AnimatedData copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onEnd,
  }) {
    return AnimatedData(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onEnd: onEnd ?? this.onEnd,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnimatedData &&
        other._curve == _curve &&
        other._duration == _duration;
  }

  @override
  int get hashCode => _curve.hashCode ^ _duration.hashCode;
}
