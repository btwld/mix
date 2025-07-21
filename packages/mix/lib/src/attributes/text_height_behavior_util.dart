import 'package:flutter/widgets.dart';

import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import 'scalar_util.dart';
import 'text_height_behavior_mix.dart';

final class TextHeightBehaviorUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, TextHeightBehavior> {
  late final heightToFirstAscent = BoolUtility<T>(
    (prop) => call(TextHeightBehaviorMix(applyHeightToFirstAscent: prop)),
  );
  late final heightToLastDescent = BoolUtility<T>(
    (prop) => call(TextHeightBehaviorMix(applyHeightToLastDescent: prop)),
  );

  late final leadingDistribution = TextLeadingDistributionUtility<T>(
    (v) => call(TextHeightBehaviorMix(leadingDistribution: v)),
  );

  TextHeightBehaviorUtility(super.builder)
    : super(convertToMix: TextHeightBehaviorMix.value);

  @override
  T call(TextHeightBehaviorMix value) => builder(MixProp(value));
}
