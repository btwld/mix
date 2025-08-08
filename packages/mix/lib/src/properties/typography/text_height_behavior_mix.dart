import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

/// Mix representation of [TextHeightBehavior].
///
/// Controls text height behavior with tokens.
class TextHeightBehaviorMix extends Mix<TextHeightBehavior> {
  final Prop<bool>? $applyHeightToFirstAscent;
  final Prop<bool>? $applyHeightToLastDescent;
  final Prop<TextLeadingDistribution>? $leadingDistribution;

  TextHeightBehaviorMix({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) : this.create(
         applyHeightToFirstAscent: Prop.maybe(applyHeightToFirstAscent),
         applyHeightToLastDescent: Prop.maybe(applyHeightToLastDescent),
         leadingDistribution: Prop.maybe(leadingDistribution),
       );

  /// Creates a [TextHeightBehaviorMix] from an existing [TextHeightBehavior].
  TextHeightBehaviorMix.value(TextHeightBehavior behavior)
    : this(
        applyHeightToFirstAscent: behavior.applyHeightToFirstAscent,
        applyHeightToLastDescent: behavior.applyHeightToLastDescent,
        leadingDistribution: behavior.leadingDistribution,
      );

  const TextHeightBehaviorMix.create({
    Prop<bool>? applyHeightToFirstAscent,
    Prop<bool>? applyHeightToLastDescent,
    Prop<TextLeadingDistribution>? leadingDistribution,
  }) : $applyHeightToFirstAscent = applyHeightToFirstAscent,
       $applyHeightToLastDescent = applyHeightToLastDescent,
       $leadingDistribution = leadingDistribution;

  /// Creates with first ascent setting.
  factory TextHeightBehaviorMix.applyHeightToFirstAscent(bool value) {
    return TextHeightBehaviorMix(applyHeightToFirstAscent: value);
  }

  /// Creates with last descent setting.
  factory TextHeightBehaviorMix.applyHeightToLastDescent(bool value) {
    return TextHeightBehaviorMix(applyHeightToLastDescent: value);
  }

  /// Creates with leading distribution.
  factory TextHeightBehaviorMix.leadingDistribution(
    TextLeadingDistribution value,
  ) {
    return TextHeightBehaviorMix(leadingDistribution: value);
  }

  /// Creates from nullable [TextHeightBehavior].
  static TextHeightBehaviorMix? maybeValue(TextHeightBehavior? behavior) {
    return behavior != null ? TextHeightBehaviorMix.value(behavior) : null;
  }

  /// Copy with first ascent setting.
  TextHeightBehaviorMix applyHeightToFirstAscent(bool value) {
    return merge(TextHeightBehaviorMix.applyHeightToFirstAscent(value));
  }

  /// Copy with last descent setting.
  TextHeightBehaviorMix applyHeightToLastDescent(bool value) {
    return merge(TextHeightBehaviorMix.applyHeightToLastDescent(value));
  }

  /// Copy with leading distribution.
  TextHeightBehaviorMix leadingDistribution(TextLeadingDistribution value) {
    return merge(TextHeightBehaviorMix.leadingDistribution(value));
  }

  /// Resolves to [TextHeightBehavior].
  @override
  TextHeightBehavior resolve(BuildContext context) {
    return TextHeightBehavior(
      applyHeightToFirstAscent:
          MixOps.resolve(context, $applyHeightToFirstAscent) ?? true,
      applyHeightToLastDescent:
          MixOps.resolve(context, $applyHeightToLastDescent) ?? true,
      leadingDistribution:
          MixOps.resolve(context, $leadingDistribution) ??
          TextLeadingDistribution.proportional,
    );
  }

  /// Merges with another text height behavior.
  @override
  TextHeightBehaviorMix merge(TextHeightBehaviorMix? other) {
    if (other == null) return this;

    return TextHeightBehaviorMix.create(
      applyHeightToFirstAscent: MixOps.merge(
        $applyHeightToFirstAscent,
        other.$applyHeightToFirstAscent,
      ),
      applyHeightToLastDescent: MixOps.merge(
        $applyHeightToLastDescent,
        other.$applyHeightToLastDescent,
      ),
      leadingDistribution: MixOps.merge(
        $leadingDistribution,
        other.$leadingDistribution,
      ),
    );
  }

  @override
  List<Object?> get props => [
    $applyHeightToFirstAscent,
    $applyHeightToLastDescent,
    $leadingDistribution,
  ];
}
