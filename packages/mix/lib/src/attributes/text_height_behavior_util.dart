import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/prop.dart';
import '../core/utility.dart';
import 'scalar_util.dart';
import 'text_height_behavior_dto.dart';

final class TextHeightBehaviorUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, TextHeightBehavior> {
  late final heightToFirstAscent = BoolUtility<T>(
    (prop) => call(TextHeightBehaviorDto(applyHeightToFirstAscent: prop)),
  );
  late final heightToLastDescent = BoolUtility<T>(
    (prop) => call(TextHeightBehaviorDto(applyHeightToLastDescent: prop)),
  );

  late final leadingDistribution = TextLeadingDistributionUtility<T>(
    (v) => call(TextHeightBehaviorDto(leadingDistribution: v)),
  );

  TextHeightBehaviorUtility(super.builder)
    : super(convertToMix: TextHeightBehaviorDto.value);

  @override
  T call(TextHeightBehaviorDto value) => builder(MixProp(value));
}
