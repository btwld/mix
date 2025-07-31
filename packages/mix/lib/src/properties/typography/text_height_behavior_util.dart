import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'text_height_behavior_mix.dart';

final class TextHeightBehaviorUtility<T extends Style<Object?>>
    extends MixPropUtility<T, TextHeightBehaviorMix, TextHeightBehavior> {
  late final heightToFirstAscent = MixUtility<T, bool>(
    (prop) => only(applyHeightToFirstAscent: prop),
  );
  late final heightToLastDescent = MixUtility<T, bool>(
    (prop) => only(applyHeightToLastDescent: prop),
  );

  late final leadingDistribution = MixUtility<T, TextLeadingDistribution>(
    (prop) => only(leadingDistribution: prop),
  );

  TextHeightBehaviorUtility(super.builder);

  T only({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) {
    return builder(
      TextHeightBehaviorMix(
        applyHeightToFirstAscent: applyHeightToFirstAscent,
        applyHeightToLastDescent: applyHeightToLastDescent,
        leadingDistribution: leadingDistribution,
      ),
    );
  }

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
  T as(TextHeightBehavior value) {
    return builder(TextHeightBehaviorMix.value(value));
  }
}
