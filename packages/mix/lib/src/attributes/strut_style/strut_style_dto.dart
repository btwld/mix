// ignore_for_file: avoid-importing-entrypoint-exports, avoid-unused-ignores, prefer_relative_imports

import 'package:flutter/material.dart';

import '../../../mix.dart';

final class StrutStyleDto extends Mixable<StrutStyle> {
  final String? fontFamily;
  final List<String>? fontFamilyFallback;

  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? height;
  final double? leading;
  final bool? forceStrutHeight;

  const StrutStyleDto({
    this.fontFamily,
    this.fontFamilyFallback,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.height,
    this.leading,
    this.forceStrutHeight,
  });

  /// Resolves to [StrutStyle] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final strutStyle = StrutStyleDto(...).resolve(mix);
  /// ```
  @override
  StrutStyle resolve(MixContext mix) {
    return StrutStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: height,
      leading: leading,
      forceStrutHeight: forceStrutHeight,
    );
  }

  /// Merges the properties of this [StrutStyleDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [StrutStyleDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  StrutStyleDto merge(StrutStyleDto? other) {
    if (other == null) return this;

    return StrutStyleDto(
      fontFamily: other.fontFamily ?? fontFamily,
      fontFamilyFallback: MixHelpers.mergeList(
          fontFamilyFallback, other.fontFamilyFallback),
      fontSize: other.fontSize ?? fontSize,
      fontWeight: other.fontWeight ?? fontWeight,
      fontStyle: other.fontStyle ?? fontStyle,
      height: other.height ?? height,
      leading: other.leading ?? leading,
      forceStrutHeight: other.forceStrutHeight ?? forceStrutHeight,
    );
  }

  /// The list of properties that constitute the state of this [StrutStyleDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StrutStyleDto] instances for equality.
  @override
  List<Object?> get props => [
        fontFamily,
        fontFamilyFallback,
        fontSize,
        fontWeight,
        fontStyle,
        height,
        leading,
        forceStrutHeight,
      ];
}

/// Extension methods to convert [StrutStyle] to [StrutStyleDto].
extension StrutStyleMixExt on StrutStyle {
  /// Converts this [StrutStyle] to a [StrutStyleDto].
  StrutStyleDto toDto() {
    return StrutStyleDto(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: height,
      leading: leading,
      forceStrutHeight: forceStrutHeight,
    );
  }
}

/// Extension methods to convert List<[StrutStyle]> to List<[StrutStyleDto]>.
extension ListStrutStyleMixExt on List<StrutStyle> {
  /// Converts this List<[StrutStyle]> to a List<[StrutStyleDto]>.
  List<StrutStyleDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}
