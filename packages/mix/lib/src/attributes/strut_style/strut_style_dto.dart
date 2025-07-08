// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';

/// A Data transfer object that represents a [StrutStyle] value.
@immutable
class StrutStyleDto extends Mix<StrutStyle> with Diagnosticable {
  // Properties use MixableProperty for cleaner merging
  final MixProperty<String> fontFamily;
  final MixProperty<List<String>> fontFamilyFallback;
  final MixProperty<double> fontSize;
  final MixProperty<FontWeight> fontWeight;
  final MixProperty<FontStyle> fontStyle;
  final MixProperty<double> height;
  final MixProperty<double> leading;
  final MixProperty<bool> forceStrutHeight;

  // Main constructor accepts real values
  factory StrutStyleDto({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    double? leading,
    bool? forceStrutHeight,
  }) {
    return StrutStyleDto.raw(
      fontFamily: MixProperty.prop(fontFamily),
      fontFamilyFallback: MixProperty.prop(fontFamilyFallback),
      fontSize: MixProperty.prop(fontSize),
      fontWeight: MixProperty.prop(fontWeight),
      fontStyle: MixProperty.prop(fontStyle),
      height: MixProperty.prop(height),
      leading: MixProperty.prop(leading),
      forceStrutHeight: MixProperty.prop(forceStrutHeight),
    );
  }

  // Factory that accepts MixableProperty instances
  const StrutStyleDto.raw({
    required this.fontFamily,
    required this.fontFamilyFallback,
    required this.fontSize,
    required this.fontWeight,
    required this.fontStyle,
    required this.height,
    required this.leading,
    required this.forceStrutHeight,
  });

  // Factory from StrutStyle
  factory StrutStyleDto.from(StrutStyle style) {
    return StrutStyleDto(
      fontFamily: style.fontFamily,
      fontFamilyFallback: style.fontFamilyFallback,
      fontSize: style.fontSize,
      fontWeight: style.fontWeight,
      fontStyle: style.fontStyle,
      height: style.height,
      leading: style.leading,
      forceStrutHeight: style.forceStrutHeight,
    );
  }

  /// Creates a StrutStyleDto from a nullable StrutStyle value
  /// Returns null if the value is null, otherwise uses StrutStyleDto.from
  static StrutStyleDto? maybeFrom(StrutStyle? value) {
    return value != null ? StrutStyleDto.from(value) : null;
  }

  @override
  StrutStyle resolve(MixContext mix) {
    return StrutStyle(
      fontFamily: fontFamily.resolve(mix),
      fontFamilyFallback: fontFamilyFallback.resolve(mix),
      fontSize: fontSize.resolve(mix),
      height: height.resolve(mix),
      leading: leading.resolve(mix),
      fontWeight: fontWeight.resolve(mix),
      fontStyle: fontStyle.resolve(mix),
      forceStrutHeight: forceStrutHeight.resolve(mix),
    );
  }

  @override
  StrutStyleDto merge(StrutStyleDto? other) {
    if (other == null) return this;

    return StrutStyleDto.raw(
      fontFamily: fontFamily.merge(other.fontFamily),
      fontFamilyFallback: fontFamilyFallback.merge(other.fontFamilyFallback),
      fontSize: fontSize.merge(other.fontSize),
      fontWeight: fontWeight.merge(other.fontWeight),
      fontStyle: fontStyle.merge(other.fontStyle),
      height: height.merge(other.height),
      leading: leading.merge(other.leading),
      forceStrutHeight: forceStrutHeight.merge(other.forceStrutHeight),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.addUsingDefault('fontFamily', fontFamily);
    properties.addUsingDefault('fontFamilyFallback', fontFamilyFallback);
    properties.addUsingDefault('fontSize', fontSize);
    properties.addUsingDefault('fontWeight', fontWeight);
    properties.addUsingDefault('fontStyle', fontStyle);
    properties.addUsingDefault('height', height);
    properties.addUsingDefault('leading', leading);
    properties.addUsingDefault('forceStrutHeight', forceStrutHeight);
  }

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
