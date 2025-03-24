import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../scalars/scalar_util.dart';
import 'animated_data.dart';
import 'mix_animated_data.dart';

final class AnimatedUtility<T extends Attribute>
    extends DtoUtility<T, AnimatedDataDto, AnimatedData> {
  AnimatedUtility(super.builder) : super(valueToDto: (value) => value.toDto());

  DurationUtility<T> get duration => DurationUtility((v) => only(duration: v));

  CurveUtility<T> get curve => CurveUtility((v) => only(curve: v));
  @override
  T only({Duration? duration, Curve? curve}) {
    return builder(AnimatedDataDto(duration: duration, curve: curve));
  }
}
