import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../core/mix_property.dart';
import '../../core/utility.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import 'text_height_behavior_dto.dart';

final class TextHeightBehaviorUtility<T extends StyleElement>
    extends DtoUtility<T, TextHeightBehaviorDto, TextHeightBehavior> {
  late final heightToFirstAscent = BoolUtility(
    (v) => only(applyHeightToFirstAscent: BoolMix(v)),
  );
  late final heightToLastDescent = BoolUtility(
    (v) => only(applyHeightToLastDescent: BoolMix(v)),
  );

  late final leadingDistribution = TextLeadingDistributionUtility(
    (v) => only(leadingDistribution: EnumMix(v)),
  );

  TextHeightBehaviorUtility(super.builder)
    : super(valueToDto: (v) => _textHeightBehaviorToDto(v));

  T call({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) {
    return only(
      applyHeightToFirstAscent: applyHeightToFirstAscent != null 
          ? BoolMix(applyHeightToFirstAscent) 
          : null,
      applyHeightToLastDescent: applyHeightToLastDescent != null 
          ? BoolMix(applyHeightToLastDescent) 
          : null,
      leadingDistribution: leadingDistribution != null 
          ? EnumMix(leadingDistribution) 
          : null,
    );
  }

  @override
  T only({
    Mix<bool>? applyHeightToFirstAscent,
    Mix<bool>? applyHeightToLastDescent,
    Mix<TextLeadingDistribution>? leadingDistribution,
  }) => builder(
    TextHeightBehaviorDto(
      applyHeightToFirstAscent: applyHeightToFirstAscent,
      applyHeightToLastDescent: applyHeightToLastDescent,
      leadingDistribution: leadingDistribution,
    ),
  );
}

// Helper function
TextHeightBehaviorDto _textHeightBehaviorToDto(TextHeightBehavior behavior) {
  return TextHeightBehaviorDto(
    applyHeightToFirstAscent: behavior.applyHeightToFirstAscent 
        ? const BoolMix(true) 
        : null,
    applyHeightToLastDescent: behavior.applyHeightToLastDescent 
        ? const BoolMix(true) 
        : null,
    leadingDistribution: behavior.leadingDistribution != TextLeadingDistribution.proportional
        ? EnumMix(behavior.leadingDistribution)
        : null,
  );
}