import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/prop.dart';
import '../core/utility.dart';
import 'scalar_util.dart';
import 'strut_style_dto.dart';

final class StrutStyleUtility<T extends SpecAttribute<Object?>>
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

  StrutStyleUtility(super.builder) : super(convertToMix: StrutStyleDto.value);

  @override
  T call(StrutStyleDto value) => builder(MixProp(value));
}
