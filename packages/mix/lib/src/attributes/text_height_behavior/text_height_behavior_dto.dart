// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

base class TextHeightBehaviorDto extends Mix<TextHeightBehavior> {
  // Properties use MixProp for cleaner merging
  final MixValue<bool> applyHeightToFirstAscent;
  final MixValue<bool> applyHeightToLastDescent;
  final MixValue<TextLeadingDistribution> leadingDistribution;

  // Main constructor accepts Mix values
  factory TextHeightBehaviorDto({
    Mix<bool>? applyHeightToFirstAscent,
    Mix<bool>? applyHeightToLastDescent,
    Mix<TextLeadingDistribution>? leadingDistribution,
  }) {
    return TextHeightBehaviorDto._(
      applyHeightToFirstAscent: MixValue(applyHeightToFirstAscent),
      applyHeightToLastDescent: MixValue(applyHeightToLastDescent),
      leadingDistribution: MixValue(leadingDistribution),
    );
  }

  // Private constructor that accepts MixProp instances
  const TextHeightBehaviorDto._({
    required this.applyHeightToFirstAscent,
    required this.applyHeightToLastDescent,
    required this.leadingDistribution,
  });

  /// Resolves to [TextHeightBehavior] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final textHeightBehavior = TextHeightBehaviorDto(...).resolve(mix);
  /// ```
  @override
  TextHeightBehavior resolve(MixContext mix) {
    return TextHeightBehavior(
      applyHeightToFirstAscent: applyHeightToFirstAscent.resolve(mix) ?? true,
      applyHeightToLastDescent: applyHeightToLastDescent.resolve(mix) ?? true,
      leadingDistribution:
          leadingDistribution.resolve(mix) ??
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

    return TextHeightBehaviorDto._(
      applyHeightToFirstAscent: applyHeightToFirstAscent.merge(
        other.applyHeightToFirstAscent,
      ),
      applyHeightToLastDescent: applyHeightToLastDescent.merge(
        other.applyHeightToLastDescent,
      ),
      leadingDistribution: leadingDistribution.merge(other.leadingDistribution),
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
