// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

base class TextHeightBehaviorDto extends Mixable<TextHeightBehavior> {
  final bool? applyHeightToFirstAscent;
  final bool? applyHeightToLastDescent;
  final TextLeadingDistribution? leadingDistribution;

  const TextHeightBehaviorDto({
    this.applyHeightToFirstAscent,
    this.applyHeightToLastDescent,
    this.leadingDistribution,
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
      applyHeightToFirstAscent: applyHeightToFirstAscent ?? true,
      applyHeightToLastDescent: applyHeightToLastDescent ?? true,
      leadingDistribution:
          leadingDistribution ?? TextLeadingDistribution.proportional,
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

    return TextHeightBehaviorDto(
      applyHeightToFirstAscent:
          other.applyHeightToFirstAscent ?? applyHeightToFirstAscent,
      applyHeightToLastDescent:
          other.applyHeightToLastDescent ?? applyHeightToLastDescent,
      leadingDistribution:
          other.leadingDistribution ?? leadingDistribution,
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
    (v) => only(applyHeightToFirstAscent: v),
  );
  late final heightToLastDescent = BoolUtility(
    (v) => only(applyHeightToLastDescent: v),
  );

  late final leadingDistribution = TextLeadingDistributionUtility(
    (v) => only(leadingDistribution: v),
  );

  TextHeightBehaviorUtility(super.builder)
      : super(valueToDto: (v) => v.toDto());

  @Deprecated("Use the utilities instead")
  T call(TextHeightBehavior value) => builder(value.toDto());

  @override
  T only({
    bool? applyHeightToFirstAscent,
    bool? applyHeightToLastDescent,
    TextLeadingDistribution? leadingDistribution,
  }) =>
      builder(
        TextHeightBehaviorDto(
          applyHeightToFirstAscent: applyHeightToFirstAscent,
          applyHeightToLastDescent: applyHeightToLastDescent,
          leadingDistribution: leadingDistribution,
        ),
      );
}

/// Extension methods to convert [TextHeightBehavior] to [TextHeightBehaviorDto].
extension TextHeightBehaviorMixExt on TextHeightBehavior {
  /// Converts this [TextHeightBehavior] to a [TextHeightBehaviorDto].
  TextHeightBehaviorDto toDto() {
    return TextHeightBehaviorDto(
      applyHeightToFirstAscent: applyHeightToFirstAscent,
      applyHeightToLastDescent: applyHeightToLastDescent,
      leadingDistribution: leadingDistribution,
    );
  }
}

/// Extension methods to convert List<[TextHeightBehavior]> to List<[TextHeightBehaviorDto]>.
extension ListTextHeightBehaviorMixExt on List<TextHeightBehavior> {
  /// Converts this List<[TextHeightBehavior]> to a List<[TextHeightBehaviorDto]>.
  List<TextHeightBehaviorDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}
