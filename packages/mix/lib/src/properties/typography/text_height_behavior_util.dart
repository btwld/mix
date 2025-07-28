import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'text_height_behavior_mix.dart';

final class TextHeightBehaviorUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, TextHeightBehavior> {
  late final heightToFirstAscent = PropUtility<T, bool>(
    (prop) => call(TextHeightBehaviorMix.raw(applyHeightToFirstAscent: prop)),
  );
  late final heightToLastDescent = PropUtility<T, bool>(
    (prop) => call(TextHeightBehaviorMix.raw(applyHeightToLastDescent: prop)),
  );

  late final leadingDistribution = PropUtility<T, TextLeadingDistribution>(
    (prop) => call(TextHeightBehaviorMix.raw(leadingDistribution: prop)),
  );

  TextHeightBehaviorUtility(super.builder)
    : super(convertToMix: TextHeightBehaviorMix.value);

  @override
  T call(TextHeightBehaviorMix value) => builder(MixProp(value));
}
