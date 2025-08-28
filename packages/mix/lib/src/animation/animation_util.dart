import 'package:flutter/widgets.dart';

import '../core/style.dart';
import '../core/utility.dart';
import 'animation_config.dart';

class AnimationConfigUtility<T extends Style<Object?>>
    extends MixUtility<T, AnimationConfig> {
  const AnimationConfigUtility(super.utilityBuilder);

  T implicit({required Duration duration, Curve curve = Curves.linear}) {
    return utilityBuilder(
      CurveAnimationConfig(duration: duration, curve: curve),
    );
  }

  T call({required Duration duration, Curve curve = Curves.linear}) {
    return implicit(duration: duration, curve: curve);
  }
}
