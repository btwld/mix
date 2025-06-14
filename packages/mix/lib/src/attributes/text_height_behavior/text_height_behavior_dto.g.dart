// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_height_behavior_dto.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides DTO functionality for [TextHeightBehaviorDto].
mixin _$TextHeightBehaviorDto on Mixable<TextHeightBehavior> {
  /// Resolves to [TextHeightBehavior] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final textHeightBehavior = TextHeightBehaviorDto(...).resolve(mix);
  /// ```
  @override
  TextHeightBehavior resolve(MixData mix) {
    return TextHeightBehavior(
      applyHeightToFirstAscent: _$this.applyHeightToFirstAscent ?? true,
      applyHeightToLastDescent: _$this.applyHeightToLastDescent ?? true,
      leadingDistribution:
          _$this.leadingDistribution ?? TextLeadingDistribution.proportional,
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
    if (other == null) return _$this;

    return TextHeightBehaviorDto(
      applyHeightToFirstAscent:
          other.applyHeightToFirstAscent ?? _$this.applyHeightToFirstAscent,
      applyHeightToLastDescent:
          other.applyHeightToLastDescent ?? _$this.applyHeightToLastDescent,
      leadingDistribution:
          other.leadingDistribution ?? _$this.leadingDistribution,
    );
  }

  /// The list of properties that constitute the state of this [TextHeightBehaviorDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextHeightBehaviorDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.applyHeightToFirstAscent,
        _$this.applyHeightToLastDescent,
        _$this.leadingDistribution,
      ];

  /// Returns this instance as a [TextHeightBehaviorDto].
  TextHeightBehaviorDto get _$this => this as TextHeightBehaviorDto;
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
