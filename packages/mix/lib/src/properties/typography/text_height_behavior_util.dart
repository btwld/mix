import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'text_height_behavior_mix.dart';

final class TextHeightBehaviorUtility<T extends Style<Object?>>
    extends MixUtility<T, TextHeightBehaviorMix> {
  late final leadingDistribution = MixUtility<T, TextLeadingDistribution>(
    (prop) => call(leadingDistribution: prop),
  );

  TextHeightBehaviorUtility(super.utilityBuilder);

  T heightToFirstAscent(bool v) => call(applyHeightToFirstAscent: v);

  T heightToLastDescent(bool v) => call(applyHeightToLastDescent: v);

  T call({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) {
    return utilityBuilder(
      TextHeightBehaviorMix(
        applyHeightToFirstAscent: applyHeightToFirstAscent,
        applyHeightToLastDescent: applyHeightToLastDescent,
        leadingDistribution: leadingDistribution,
      ),
    );
  }

  T as(TextHeightBehavior value) {
    return utilityBuilder(TextHeightBehaviorMix.value(value));
  }
}
