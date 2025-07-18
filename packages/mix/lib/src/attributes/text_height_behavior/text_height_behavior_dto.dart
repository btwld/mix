// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../internal/compare_mixin.dart';

class TextHeightBehaviorDto extends Mix<TextHeightBehavior> with EqualityMixin {
  // Properties use MixProp for cleaner merging
  final Prop<bool>? applyHeightToFirstAscent;
  final Prop<bool>? applyHeightToLastDescent;
  final Prop<TextLeadingDistribution>? leadingDistribution;

  // Main constructor accepts raw values
  factory TextHeightBehaviorDto({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) {
    return TextHeightBehaviorDto.props(
      applyHeightToFirstAscent: Prop.maybeValue(applyHeightToFirstAscent),
      applyHeightToLastDescent: Prop.maybeValue(applyHeightToLastDescent),
      leadingDistribution: Prop.maybeValue(leadingDistribution),
    );
  }

  /// Constructor that accepts a [TextHeightBehavior] value and extracts its properties.
  ///
  /// This is useful for converting existing [TextHeightBehavior] instances to [TextHeightBehaviorDto].
  ///
  /// ```dart
  /// const behavior = TextHeightBehavior(applyHeightToFirstAscent: false);
  /// final dto = TextHeightBehaviorDto.value(behavior);
  /// ```
  factory TextHeightBehaviorDto.value(TextHeightBehavior behavior) {
    return TextHeightBehaviorDto(
      applyHeightToFirstAscent: behavior.applyHeightToFirstAscent,
      applyHeightToLastDescent: behavior.applyHeightToLastDescent,
      leadingDistribution: behavior.leadingDistribution,
    );
  }

  // Private constructor that accepts MixProp instances
  const TextHeightBehaviorDto.props({
    this.applyHeightToFirstAscent,
    this.applyHeightToLastDescent,
    this.leadingDistribution,
  });

  /// Constructor that accepts a nullable [TextHeightBehavior] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [TextHeightBehaviorDto.value].
  ///
  /// ```dart
  /// const TextHeightBehavior? behavior = TextHeightBehavior(applyHeightToFirstAscent: false);
  /// final dto = TextHeightBehaviorDto.maybeValue(behavior); // Returns TextHeightBehaviorDto or null
  /// ```
  static TextHeightBehaviorDto? maybeValue(TextHeightBehavior? behavior) {
    return behavior != null ? TextHeightBehaviorDto.value(behavior) : null;
  }

  /// Resolves to [TextHeightBehavior] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final textHeightBehavior = TextHeightBehaviorDto(...).resolve(mix);
  /// ```
  @override
  TextHeightBehavior resolve(BuildContext context) {
    return TextHeightBehavior(
      applyHeightToFirstAscent:
          MixHelpers.resolve(context, applyHeightToFirstAscent) ?? true,
      applyHeightToLastDescent:
          MixHelpers.resolve(context, applyHeightToLastDescent) ?? true,
      leadingDistribution:
          MixHelpers.resolve(context, leadingDistribution) ??
          TextLeadingDistribution.proportional,
    );
  }

  /// Merges the properties of this [TextHeightBehaviorDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TextHeightBehaviorDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TextHeightBehaviorDto merge(TextHeightBehaviorDto? other) {
    if (other == null) return this;

    return TextHeightBehaviorDto.props(
      applyHeightToFirstAscent: MixHelpers.merge(
        applyHeightToFirstAscent,
        other.applyHeightToFirstAscent,
      ),
      applyHeightToLastDescent: MixHelpers.merge(
        applyHeightToLastDescent,
        other.applyHeightToLastDescent,
      ),
      leadingDistribution: MixHelpers.merge(
        leadingDistribution,
        other.leadingDistribution,
      ),
    );
  }

  /// The list of properties that constitute the state of this [TextHeightBehaviorDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextHeightBehaviorDto] instances for equality.
  @override
  List<Object?> get props => [
    applyHeightToFirstAscent,
    applyHeightToLastDescent,
    leadingDistribution,
  ];
}
