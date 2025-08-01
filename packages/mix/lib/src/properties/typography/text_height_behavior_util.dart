import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'text_height_behavior_mix.dart';

final class TextHeightBehaviorUtility<T extends Style<Object?>>
    extends MixPropUtility<T, TextHeightBehaviorMix, TextHeightBehavior> {
  @Deprecated('Use call(leadingDistribution: value) instead')
  late final leadingDistribution = MixUtility<T, TextLeadingDistribution>(
    (prop) => call(leadingDistribution: prop),
  );

  @Deprecated('Use call(...) instead')
  late final only = call;

  TextHeightBehaviorUtility(super.builder);

  @Deprecated('Use call(applyHeightToFirstAscent: value) instead')
  T heightToFirstAscent(bool v) => call(applyHeightToFirstAscent: v);

  @Deprecated('Use call(applyHeightToLastDescent: value) instead')
  T heightToLastDescent(bool v) => call(applyHeightToLastDescent: v);

  T call({
    TextHeightBehavior? as,
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) {
    if (as != null) {
      return builder(TextHeightBehaviorMix.value(as));
    }

    return builder(
      TextHeightBehaviorMix(
        applyHeightToFirstAscent: applyHeightToFirstAscent,
        applyHeightToLastDescent: applyHeightToLastDescent,
        leadingDistribution: leadingDistribution,
      ),
    );
  }

  @override
  @Deprecated('Use call(as: value) instead')
  T as(TextHeightBehavior value) {
    return builder(TextHeightBehaviorMix.value(value));
  }
}
