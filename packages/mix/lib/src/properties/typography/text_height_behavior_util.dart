import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'text_height_behavior_mix.dart';

final class TextHeightBehaviorUtility<T extends Style<Object?>>
    extends MixPropUtility<T, TextHeightBehavior> {
  late final heightToFirstAscent = PropUtility<T, bool>(
    (prop) => onlyProps(applyHeightToFirstAscent: prop),
  );
  late final heightToLastDescent = PropUtility<T, bool>(
    (prop) => onlyProps(applyHeightToLastDescent: prop),
  );

  late final leadingDistribution = PropUtility<T, TextLeadingDistribution>(
    (prop) => onlyProps(leadingDistribution: prop),
  );

  TextHeightBehaviorUtility(super.builder)
    : super(convertToMix: TextHeightBehaviorMix.value);

  @protected
  T onlyProps({
    Prop<bool>? applyHeightToFirstAscent,
    Prop<bool>? applyHeightToLastDescent,
    Prop<TextLeadingDistribution>? leadingDistribution,
  }) {
    return builder(
      MixProp(
        TextHeightBehaviorMix.raw(
          applyHeightToFirstAscent: applyHeightToFirstAscent,
          applyHeightToLastDescent: applyHeightToLastDescent,
          leadingDistribution: leadingDistribution,
        ),
      ),
    );
  }

  T only({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) {
    return onlyProps(
      applyHeightToFirstAscent: Prop.maybe(applyHeightToFirstAscent),
      applyHeightToLastDescent: Prop.maybe(applyHeightToLastDescent),
      leadingDistribution: Prop.maybe(leadingDistribution),
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

  T mix(TextHeightBehaviorMix value) => builder(MixProp(value));
}
