import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

/// Mix-compatible representation of Flutter's [TextHeightBehavior] with token support.
///
/// Configures text height application behavior including ascent, descent, and leading
/// distribution with resolvable tokens and merging capabilities.
class TextHeightBehaviorMix extends Mix<TextHeightBehavior> {
  final Prop<bool>? $applyHeightToFirstAscent;
  final Prop<bool>? $applyHeightToLastDescent;
  final Prop<TextLeadingDistribution>? $leadingDistribution;

  TextHeightBehaviorMix({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) : this.raw(
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

  const TextHeightBehaviorMix.raw({
    Prop<bool>? applyHeightToFirstAscent,
    Prop<bool>? applyHeightToLastDescent,
    Prop<TextLeadingDistribution>? leadingDistribution,
  }) : $applyHeightToFirstAscent = applyHeightToFirstAscent,
       $applyHeightToLastDescent = applyHeightToLastDescent,
       $leadingDistribution = leadingDistribution;

  /// Creates a text height behavior with height applied to first ascent enabled or disabled.
  factory TextHeightBehaviorMix.applyHeightToFirstAscent(bool value) {
    return TextHeightBehaviorMix(applyHeightToFirstAscent: value);
  }

  /// Creates a text height behavior with height applied to last descent enabled or disabled.
  factory TextHeightBehaviorMix.applyHeightToLastDescent(bool value) {
    return TextHeightBehaviorMix(applyHeightToLastDescent: value);
  }

  /// Creates a text height behavior with the specified leading distribution.
  factory TextHeightBehaviorMix.leadingDistribution(
    TextLeadingDistribution value,
  ) {
    return TextHeightBehaviorMix(leadingDistribution: value);
  }

  /// Creates a [TextHeightBehaviorMix] from a nullable [TextHeightBehavior].
  ///
  /// Returns null if the input is null.
  static TextHeightBehaviorMix? maybeValue(TextHeightBehavior? behavior) {
    return behavior != null ? TextHeightBehaviorMix.value(behavior) : null;
  }

  /// Returns a copy with height applied to first ascent enabled or disabled.
  TextHeightBehaviorMix applyHeightToFirstAscent(bool value) {
    return merge(TextHeightBehaviorMix.applyHeightToFirstAscent(value));
  }

  /// Returns a copy with height applied to last descent enabled or disabled.
  TextHeightBehaviorMix applyHeightToLastDescent(bool value) {
    return merge(TextHeightBehaviorMix.applyHeightToLastDescent(value));
  }

  /// Returns a copy with the specified leading distribution.
  TextHeightBehaviorMix leadingDistribution(TextLeadingDistribution value) {
    return merge(TextHeightBehaviorMix.leadingDistribution(value));
  }

  /// Resolves to [TextHeightBehavior] using the provided [BuildContext].
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

  /// Merges this text height behavior with another, with other taking precedence.
  @override
  TextHeightBehaviorMix merge(TextHeightBehaviorMix? other) {
    if (other == null) return this;

    return TextHeightBehaviorMix.raw(
      applyHeightToFirstAscent: $applyHeightToFirstAscent.tryMerge(
        other.$applyHeightToFirstAscent,
      ),
      applyHeightToLastDescent: $applyHeightToLastDescent.tryMerge(
        other.$applyHeightToLastDescent,
      ),
      leadingDistribution: $leadingDistribution.tryMerge(
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
