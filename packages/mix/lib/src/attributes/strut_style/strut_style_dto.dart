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

  /// Constructor that accepts a [StrutStyle] value and extracts its properties.
  ///
  /// This is useful for converting existing [StrutStyle] instances to [StrutStyleDto].
  ///
  /// ```dart
  /// const strutStyle = StrutStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  /// final dto = StrutStyleDto.value(strutStyle);
  /// ```
  factory StrutStyleDto.value(StrutStyle strutStyle) {
    return StrutStyleDto._(
      fontFamily: Prop.maybeValue(strutStyle.fontFamily),
      fontFamilyFallback: Prop.maybeValue(strutStyle.fontFamilyFallback),
      fontSize: Prop.maybeValue(strutStyle.fontSize),
      fontWeight: Prop.maybeValue(strutStyle.fontWeight),
      fontStyle: Prop.maybeValue(strutStyle.fontStyle),
      height: Prop.maybeValue(strutStyle.height),
      leading: Prop.maybeValue(strutStyle.leading),
      forceStrutHeight: Prop.maybeValue(strutStyle.forceStrutHeight),
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

  /// Constructor that accepts a nullable [StrutStyle] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StrutStyleDto.value].
  ///
  /// ```dart
  /// const StrutStyle? strutStyle = StrutStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  /// final dto = StrutStyleDto.maybeValue(strutStyle); // Returns StrutStyleDto or null
  /// ```
  static StrutStyleDto? maybeValue(StrutStyle? strutStyle) {
    return strutStyle != null ? StrutStyleDto.value(strutStyle) : null;
  }

  @override
  StrutStyle resolve(MixContext context) {
    return StrutStyle(
      fontFamily: resolveProp(context, fontFamily),
      fontFamilyFallback: resolveProp(context, fontFamilyFallback),
      fontSize: resolveProp(context, fontSize),
      height: resolveProp(context, height),
      leading: resolveProp(context, leading),
      fontWeight: resolveProp(context, fontWeight),
      fontStyle: resolveProp(context, fontStyle),
      forceStrutHeight: resolveProp(context, forceStrutHeight),
    );
  }

  @override
  StrutStyleDto merge(StrutStyleDto? other) {
    if (other == null) return this;

    return StrutStyleDto._(
      fontFamily: mergeProp(fontFamily, other.fontFamily),
      fontFamilyFallback: mergeProp(
        fontFamilyFallback,
        other.fontFamilyFallback,
      ),
      fontSize: mergeProp(fontSize, other.fontSize),
      fontWeight: mergeProp(fontWeight, other.fontWeight),
      fontStyle: mergeProp(fontStyle, other.fontStyle),
      height: mergeProp(height, other.height),
      leading: mergeProp(leading, other.leading),
      forceStrutHeight: mergeProp(forceStrutHeight, other.forceStrutHeight),
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
