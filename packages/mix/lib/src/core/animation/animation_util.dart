import 'package:flutter/widgets.dart';

import '../animation_config.dart';
import '../style.dart';
import '../utility.dart';

class AnimationConfigUtility<T extends StyleAttribute<Object?>>
    extends MixUtility<T, AnimationConfig> {
  const AnimationConfigUtility(super.builder);

  T implicit({required Duration duration, Curve curve = Curves.linear}) {
    return builder(CurveAnimationConfig(duration: duration, curve: curve));
  }

  T call({required Duration duration, Curve curve = Curves.linear}) {
    return implicit(duration: duration, curve: curve);
  }
}
