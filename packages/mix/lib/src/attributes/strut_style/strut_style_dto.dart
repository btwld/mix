// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';

/// A Data transfer object that represents a [StrutStyle] value.
@immutable
class StrutStyleDto extends Mix<StrutStyle> with Diagnosticable {
  // Properties use MixableProperty for cleaner merging
  final Prop<String>? fontFamily;
  final Prop<List<String>>? fontFamilyFallback;
  final Prop<double>? fontSize;
  final Prop<FontWeight>? fontWeight;
  final Prop<FontStyle>? fontStyle;
  final Prop<double>? height;
  final Prop<double>? leading;
  final Prop<bool>? forceStrutHeight;

  // Main constructor accepts raw values
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
    return StrutStyleDto._(
      fontFamily: Prop.maybeValue(fontFamily),
      fontFamilyFallback: Prop.maybeValue(fontFamilyFallback),
      fontSize: Prop.maybeValue(fontSize),
      fontWeight: Prop.maybeValue(fontWeight),
      fontStyle: Prop.maybeValue(fontStyle),
      height: Prop.maybeValue(height),
      leading: Prop.maybeValue(leading),
      forceStrutHeight: Prop.maybeValue(forceStrutHeight),
    );
  }

  // Private constructor that accepts MixableProperty instances
  const StrutStyleDto._({
    this.fontFamily,
    this.fontFamilyFallback,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.height,
    this.leading,
    this.forceStrutHeight,
  });

  @override
  StrutStyle resolve(MixContext mix) {
    return StrutStyle(
      fontFamily: resolveValue(mix, fontFamily),
      fontFamilyFallback: resolveValue(mix, fontFamilyFallback),
      fontSize: resolveValue(mix, fontSize),
      height: resolveValue(mix, height),
      leading: resolveValue(mix, leading),
      fontWeight: resolveValue(mix, fontWeight),
      fontStyle: resolveValue(mix, fontStyle),
      forceStrutHeight: resolveValue(mix, forceStrutHeight),
    );
  }

  @override
  StrutStyleDto merge(StrutStyleDto? other) {
    if (other == null) return this;

    return StrutStyleDto._(
      fontFamily: mergeValue(fontFamily, other.fontFamily),
      fontFamilyFallback: mergeValue(
        fontFamilyFallback,
        other.fontFamilyFallback,
      ),
      fontSize: mergeValue(fontSize, other.fontSize),
      fontWeight: mergeValue(fontWeight, other.fontWeight),
      fontStyle: mergeValue(fontStyle, other.fontStyle),
      height: mergeValue(height, other.height),
      leading: mergeValue(leading, other.leading),
      forceStrutHeight: mergeValue(forceStrutHeight, other.forceStrutHeight),
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
