// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'text_height_behavior_dto.g.dart';

@MixableType(components: GeneratedPropertyComponents.skipUtility)
base class TextHeightBehaviorDto extends Mixable<TextHeightBehavior>
    with _$TextHeightBehaviorDto {
  final bool? applyHeightToFirstAscent;
  final bool? applyHeightToLastDescent;
  final TextLeadingDistribution? leadingDistribution;

  const TextHeightBehaviorDto({
    this.applyHeightToFirstAscent,
    this.applyHeightToLastDescent,
    this.leadingDistribution,
  });
}

final class TextHeightBehaviorUtility<T extends Attribute>
    extends DtoUtility<T, TextHeightBehaviorDto, TextHeightBehavior> {
  late final heightToFirstAscent = BoolUtility(
    (v) => only(applyHeightToFirstAscent: v),
  );
  late final heightToLastDescent = BoolUtility(
    (v) => only(applyHeightToLastDescent: v),
  );

  late final leadingDistribution = TextLeadingDistributionUtility(
    (v) => only(leadingDistribution: v),
  );

  TextHeightBehaviorUtility(super.builder)
      : super(valueToDto: (v) => v.toDto());

  @Deprecated("Use the utilities instead")
  T call(TextHeightBehavior value) => builder(value.toDto());

  @override
  T only({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) =>
      builder(
        TextHeightBehaviorDto(
          applyHeightToFirstAscent: applyHeightToFirstAscent,
          applyHeightToLastDescent: applyHeightToLastDescent,
          leadingDistribution: leadingDistribution,
        ),
      );
}
