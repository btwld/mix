// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

base class TextHeightBehaviorDto extends Mix<TextHeightBehavior> {
  // Properties use MixableProperty for cleaner merging
  final MixProperty<bool> applyHeightToFirstAscent;
  final MixProperty<bool> applyHeightToLastDescent;
  final MixProperty<TextLeadingDistribution> leadingDistribution;

  // Main constructor accepts real values
  factory TextHeightBehaviorDto({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) {
    return TextHeightBehaviorDto.raw(
      applyHeightToFirstAscent: MixProperty.prop(applyHeightToFirstAscent),
      applyHeightToLastDescent: MixProperty.prop(applyHeightToLastDescent),
      leadingDistribution: MixProperty.prop(leadingDistribution),
    );
  }

  // Factory that accepts MixableProperty instances
  const TextHeightBehaviorDto.raw({
    required this.applyHeightToFirstAscent,
    required this.applyHeightToLastDescent,
    required this.leadingDistribution,
  });

  // Factory from TextHeightBehavior
  factory TextHeightBehaviorDto.from(TextHeightBehavior behavior) {
    return TextHeightBehaviorDto(
      applyHeightToFirstAscent: behavior.applyHeightToFirstAscent,
      applyHeightToLastDescent: behavior.applyHeightToLastDescent,
      leadingDistribution: behavior.leadingDistribution,
    );
  }

  /// Creates a TextHeightBehaviorDto from a nullable TextHeightBehavior value
  /// Returns null if the value is null, otherwise uses TextHeightBehaviorDto.from
  static TextHeightBehaviorDto? maybeFrom(TextHeightBehavior? value) {
    return value != null ? TextHeightBehaviorDto.from(value) : null;
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

    return TextHeightBehaviorDto.raw(
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

final class TextHeightBehaviorUtility<T extends StyleElement>
    extends DtoUtility<T, TextHeightBehaviorDto, TextHeightBehavior> {
  late final heightToFirstAscent = BoolUtility(
    (v) => only(applyHeightToFirstAscent: Mix.value(v)),
  );
  late final heightToLastDescent = BoolUtility(
    (v) => only(applyHeightToLastDescent: Mix.value(v)),
  );

  late final leadingDistribution = TextLeadingDistributionUtility(
    (v) => only(leadingDistribution: Mix.value(v)),
  );

  TextHeightBehaviorUtility(super.builder)
    : super(valueToDto: (v) => TextHeightBehaviorDto.from(v));

  T call({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) {
    return builder(
      TextHeightBehaviorDto(
        applyHeightToFirstAscent: applyHeightToFirstAscent,
        applyHeightToLastDescent: applyHeightToLastDescent,
        leadingDistribution: leadingDistribution,
      ),
    );
  }

  @override
  T only({
    Mix<bool>? applyHeightToFirstAscent,
    Mix<bool>? applyHeightToLastDescent,
    Mix<TextLeadingDistribution>? leadingDistribution,
  }) => builder(
    TextHeightBehaviorDto.raw(
      applyHeightToFirstAscent: MixProperty(applyHeightToFirstAscent),
      applyHeightToLastDescent: MixProperty(applyHeightToLastDescent),
      leadingDistribution: MixProperty(leadingDistribution),
    ),
  );
}
