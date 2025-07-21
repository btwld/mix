import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/utility.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import 'strut_style_dto.dart';

final class StrutStyleUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, StrutStyle> {
  late final fontWeight = FontWeightUtility<T>(
    (prop) => call(StrutStyleDto(fontWeight: prop)),
  );

  late final fontStyle = FontStyleUtility<T>(
    (v) => call(StrutStyleDto(fontStyle: v)),
  );

  late final fontSize = FontSizeUtility<T>(
    (prop) => call(StrutStyleDto(fontSize: prop)),
  );

  late final fontFamily = FontFamilyUtility<T>(
    (v) => call(StrutStyleDto(fontFamily: v)),
  );

  StrutStyleUtility(super.builder) : super(valueToMix: StrutStyleDto.value);

  @override
  T call(StrutStyleDto value) => builder(MixProp(value));
}
