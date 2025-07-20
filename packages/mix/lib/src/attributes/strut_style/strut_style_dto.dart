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
  final List<Prop<String>>? fontFamilyFallback;
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
    return StrutStyleDto.props(
      fontFamily: Prop.maybe(fontFamily),
      fontFamilyFallback: fontFamilyFallback?.map(Prop.new).toList(),
      fontSize: Prop.maybe(fontSize),
      fontWeight: Prop.maybe(fontWeight),
      fontStyle: Prop.maybe(fontStyle),
      height: Prop.maybe(height),
      leading: Prop.maybe(leading),
      forceStrutHeight: Prop.maybe(forceStrutHeight),
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
    return StrutStyleDto(
      fontFamily: strutStyle.fontFamily,
      fontFamilyFallback: strutStyle.fontFamilyFallback,
      fontSize: strutStyle.fontSize,
      fontWeight: strutStyle.fontWeight,
      fontStyle: strutStyle.fontStyle,
      height: strutStyle.height,
      leading: strutStyle.leading,
      forceStrutHeight: strutStyle.forceStrutHeight,
    );
  }

  // Private constructor that accepts MixableProperty instances
  const StrutStyleDto.props({
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
  StrutStyle resolve(BuildContext context) {
    return StrutStyle(
      fontFamily: MixHelpers.resolve(context, fontFamily),
      fontFamilyFallback: MixHelpers.resolveList(context, fontFamilyFallback),
      fontSize: MixHelpers.resolve(context, fontSize),
      height: MixHelpers.resolve(context, height),
      leading: MixHelpers.resolve(context, leading),
      fontWeight: MixHelpers.resolve(context, fontWeight),
      fontStyle: MixHelpers.resolve(context, fontStyle),
      forceStrutHeight: MixHelpers.resolve(context, forceStrutHeight),
    );
  }

  @override
  StrutStyleDto merge(StrutStyleDto? other) {
    if (other == null) return this;

    return StrutStyleDto.props(
      fontFamily: MixHelpers.merge(fontFamily, other.fontFamily),
      fontFamilyFallback: MixHelpers.mergeList(
        fontFamilyFallback,
        other.fontFamilyFallback,
      ),
      fontSize: MixHelpers.merge(fontSize, other.fontSize),
      fontWeight: MixHelpers.merge(fontWeight, other.fontWeight),
      fontStyle: MixHelpers.merge(fontStyle, other.fontStyle),
      height: MixHelpers.merge(height, other.height),
      leading: MixHelpers.merge(leading, other.leading),
      forceStrutHeight: MixHelpers.merge(
        forceStrutHeight,
        other.forceStrutHeight,
      ),
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StrutStyleDto &&
        other.fontFamily == fontFamily &&
        listEquals(other.fontFamilyFallback, fontFamilyFallback) &&
        other.fontSize == fontSize &&
        other.fontWeight == fontWeight &&
        other.fontStyle == fontStyle &&
        other.height == height &&
        other.leading == leading &&
        other.forceStrutHeight == forceStrutHeight;
  }

  @override
  int get hashCode {
    return fontFamily.hashCode ^
        fontFamilyFallback.hashCode ^
        fontSize.hashCode ^
        fontWeight.hashCode ^
        fontStyle.hashCode ^
        height.hashCode ^
        leading.hashCode ^
        forceStrutHeight.hashCode;
  }
}
