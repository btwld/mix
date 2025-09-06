import 'package:flutter/widgets.dart';

import '../core/style.dart';
import '../core/utility.dart';
import 'animation_config.dart';

/// A utility for creating [AnimationConfig] instances.
class AnimationConfigUtility<T extends Style<Object?>>
    extends MixUtility<T, AnimationConfig> {
  const AnimationConfigUtility(super.utilityBuilder);

  /// Creates an [AnimationConfig] with the given [duration] and [curve].
  ///
  /// This is used for implicit animations.
  T implicit({required Duration duration, Curve curve = Curves.linear}) {
    return utilityBuilder(
      CurveAnimationConfig(duration: duration, curve: curve),
    );
  }

  /// Creates an [AnimationConfig] with the given [duration] and [curve].
  ///
  /// This is used for implicit animations.
  T call({required Duration duration, Curve curve = Curves.linear}) {
    return implicit(duration: duration, curve: curve);
  }
}
