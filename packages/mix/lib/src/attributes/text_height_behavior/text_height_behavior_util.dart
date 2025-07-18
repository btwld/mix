import 'package:flutter/widgets.dart';

import '../../core/attribute.dart';
import '../../core/utility.dart';
import '../enum/enum_util.dart';
import 'text_height_behavior_dto.dart';

final class TextHeightBehaviorUtility<T extends Attribute>
    extends DtoUtility<T, TextHeightBehaviorDto, TextHeightBehavior> {
  late final heightToFirstAscent = BoolUtility(
    (prop) => only(applyHeightToFirstAscent: prop.value),
  );
  late final heightToLastDescent = BoolUtility(
    (prop) => only(applyHeightToLastDescent: prop.value),
  );

  late final leadingDistribution = TextLeadingDistributionUtility(
    (v) => only(leadingDistribution: v),
  );

  TextHeightBehaviorUtility(super.builder)
    : super(valueToDto: TextHeightBehaviorDto.value);

  T call({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) {
    return only(
      applyHeightToFirstAscent: applyHeightToFirstAscent,
      applyHeightToLastDescent: applyHeightToLastDescent,
      leadingDistribution: leadingDistribution,
    );
  }

  @override
  T only({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) => builder(
    TextHeightBehaviorDto(
      applyHeightToFirstAscent: applyHeightToFirstAscent,
      applyHeightToLastDescent: applyHeightToLastDescent,
      leadingDistribution: leadingDistribution,
    ),
  );
}
