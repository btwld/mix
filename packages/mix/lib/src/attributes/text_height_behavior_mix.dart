// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Mix-compatible representation of [TextHeightBehavior] for text styling.
///
/// Configures how text height is applied to the first ascent and last descent.
class TextHeightBehaviorMix extends Mix<TextHeightBehavior> {
  final Prop<bool>? $applyHeightToFirstAscent;
  final Prop<bool>? $applyHeightToLastDescent;
  final Prop<TextLeadingDistribution>? $leadingDistribution;

  TextHeightBehaviorMix.only({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) : this(
         applyHeightToFirstAscent: Prop.maybe(applyHeightToFirstAscent),
         applyHeightToLastDescent: Prop.maybe(applyHeightToLastDescent),
         leadingDistribution: Prop.maybe(leadingDistribution),
       );

  /// Constructor that accepts a [TextHeightBehavior] value and extracts its properties.
  ///
  /// This is useful for converting existing [TextHeightBehavior] instances to [TextHeightBehaviorMix].
  ///
  /// ```dart
  /// const behavior = TextHeightBehavior(applyHeightToFirstAscent: false);
  /// final dto = TextHeightBehaviorMix.value(behavior);
  /// ```
  TextHeightBehaviorMix.value(TextHeightBehavior behavior)
    : this.only(
        applyHeightToFirstAscent: behavior.applyHeightToFirstAscent,
        applyHeightToLastDescent: behavior.applyHeightToLastDescent,
        leadingDistribution: behavior.leadingDistribution,
      );

  const TextHeightBehaviorMix({
    Prop<bool>? applyHeightToFirstAscent,
    Prop<bool>? applyHeightToLastDescent,
    Prop<TextLeadingDistribution>? leadingDistribution,
  }) : $applyHeightToFirstAscent = applyHeightToFirstAscent,
       $applyHeightToLastDescent = applyHeightToLastDescent,
       $leadingDistribution = leadingDistribution;

  /// Constructor that accepts a nullable [TextHeightBehavior] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [TextHeightBehaviorMix.value].
  ///
  /// ```dart
  /// const TextHeightBehavior? behavior = TextHeightBehavior(applyHeightToFirstAscent: false);
  /// final dto = TextHeightBehaviorMix.maybeValue(behavior); // Returns TextHeightBehaviorMix or null
  /// ```
  factory TextHeightBehaviorMix.applyHeightToFirstAscent(bool value) {
    return TextHeightBehaviorMix.only(applyHeightToFirstAscent: value);
  }

  factory TextHeightBehaviorMix.applyHeightToLastDescent(bool value) {
    return TextHeightBehaviorMix.only(applyHeightToLastDescent: value);
  }

  factory TextHeightBehaviorMix.leadingDistribution(
    TextLeadingDistribution value,
  ) {
    return TextHeightBehaviorMix.only(leadingDistribution: value);
  }

  static TextHeightBehaviorMix? maybeValue(TextHeightBehavior? behavior) {
    return behavior != null ? TextHeightBehaviorMix.value(behavior) : null;
  }

  /// Creates a new [TextHeightBehaviorMix] with the provided applyHeightToFirstAscent,
  /// merging it with the current instance.
  TextHeightBehaviorMix applyHeightToFirstAscent(bool value) {
    return merge(TextHeightBehaviorMix.only(applyHeightToFirstAscent: value));
  }

  /// Creates a new [TextHeightBehaviorMix] with the provided applyHeightToLastDescent,
  /// merging it with the current instance.
  TextHeightBehaviorMix applyHeightToLastDescent(bool value) {
    return merge(TextHeightBehaviorMix.only(applyHeightToLastDescent: value));
  }

  /// Creates a new [TextHeightBehaviorMix] with the provided leadingDistribution,
  /// merging it with the current instance.
  TextHeightBehaviorMix leadingDistribution(TextLeadingDistribution value) {
    return merge(TextHeightBehaviorMix.only(leadingDistribution: value));
  }

  /// Resolves to [TextHeightBehavior] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final textHeightBehavior = TextHeightBehaviorMix(...).resolve(mix);
  /// ```
  @override
  TextHeightBehavior resolve(BuildContext context) {
    return TextHeightBehavior(
      applyHeightToFirstAscent:
          MixHelpers.resolve(context, $applyHeightToFirstAscent) ?? true,
      applyHeightToLastDescent:
          MixHelpers.resolve(context, $applyHeightToLastDescent) ?? true,
      leadingDistribution:
          MixHelpers.resolve(context, $leadingDistribution) ??
          TextLeadingDistribution.proportional,
    );
  }

  /// Merges the properties of this [TextHeightBehaviorMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TextHeightBehaviorMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TextHeightBehaviorMix merge(TextHeightBehaviorMix? other) {
    if (other == null) return this;

    return TextHeightBehaviorMix(
      applyHeightToFirstAscent: MixHelpers.merge(
        $applyHeightToFirstAscent,
        other.$applyHeightToFirstAscent,
      ),
      applyHeightToLastDescent: MixHelpers.merge(
        $applyHeightToLastDescent,
        other.$applyHeightToLastDescent,
      ),
      leadingDistribution: MixHelpers.merge(
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
