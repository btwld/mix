// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';

/// A Data transfer object that represents a [StrutStyle] value.
@immutable
class StrutStyleDto extends Mix<StrutStyle> with Diagnosticable {
  // Properties use MixableProperty for cleaner merging
  final Mixable<String> fontFamily;
  final Mixable<List<String>> fontFamilyFallback;
  final Mixable<double> fontSize;
  final Mixable<FontWeight> fontWeight;
  final Mixable<FontStyle> fontStyle;
  final Mixable<double> height;
  final Mixable<double> leading;
  final Mixable<bool> forceStrutHeight;

  // Main constructor accepts Mix values
  factory StrutStyleDto({
    Mix<String>? fontFamily,
    Mix<List<String>>? fontFamilyFallback,
    Mix<double>? fontSize,
    Mix<FontWeight>? fontWeight,
    Mix<FontStyle>? fontStyle,
    Mix<double>? height,
    Mix<double>? leading,
    Mix<bool>? forceStrutHeight,
  }) {
    return StrutStyleDto._(
      fontFamily: Mixable(fontFamily),
      fontFamilyFallback: Mixable(fontFamilyFallback),
      fontSize: Mixable(fontSize),
      fontWeight: Mixable(fontWeight),
      fontStyle: Mixable(fontStyle),
      height: Mixable(height),
      leading: Mixable(leading),
      forceStrutHeight: Mixable(forceStrutHeight),
    );
  }

  // Private constructor that accepts MixProp instances
  const StrutStyleDto._({
    required this.fontFamily,
    required this.fontFamilyFallback,
    required this.fontSize,
    required this.fontWeight,
    required this.fontStyle,
    required this.height,
    required this.leading,
    required this.forceStrutHeight,
  });

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

    return StrutStyleDto._(
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
