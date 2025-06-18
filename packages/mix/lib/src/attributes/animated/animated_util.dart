import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../scalars/scalar_util.dart';
import 'animated_data.dart';
import 'animated_data_dto.dart';

final class AnimatedUtility<T extends StyleElement>
    extends DtoUtility<T, AnimatedDataDto, AnimatedData> {
  AnimatedUtility(super.builder) : super(valueToDto: (value) => value.toDto());

  DurationUtility<T> get duration => DurationUtility((v) => only(duration: v));

  CurveUtility<T> get curve => CurveUtility((v) => only(curve: v));

  T linear(Duration duration) => only(duration: duration, curve: Curves.linear);
  T ease(Duration duration) => only(duration: duration, curve: Curves.ease);
  T easeIn(Duration duration) => only(duration: duration, curve: Curves.easeIn);
  T easeOut(Duration duration) =>
      only(duration: duration, curve: Curves.easeOut);
  T easeInOut(Duration duration) =>
      only(duration: duration, curve: Curves.easeInOut);
  T fastOutSlowIn(Duration duration) =>
      only(duration: duration, curve: Curves.fastOutSlowIn);
  T bounceIn(Duration duration) =>
      only(duration: duration, curve: Curves.bounceIn);
  T bounceOut(Duration duration) =>
      only(duration: duration, curve: Curves.bounceOut);
  T bounceInOut(Duration duration) =>
      only(duration: duration, curve: Curves.bounceInOut);
  T elasticIn(Duration duration) =>
      only(duration: duration, curve: Curves.elasticIn);
  T elasticOut(Duration duration) =>
      only(duration: duration, curve: Curves.elasticOut);
  T elasticInOut(Duration duration) =>
      only(duration: duration, curve: Curves.elasticInOut);

  @override
  T only({Duration? duration, Curve? curve}) {
    return builder(AnimatedDataDto(duration: duration, curve: curve));
  }
}
