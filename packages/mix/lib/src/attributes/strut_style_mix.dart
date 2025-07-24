// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../internal/diagnostic_properties_builder_ext.dart';

/// A Data transfer object that represents a [StrutStyle] value.
@immutable
class StrutStyleMix extends Mix<StrutStyle> with Diagnosticable {
  // Properties use MixableProperty for cleaner merging
  final Prop<String>? fontFamily;
  final List<Prop<String>>? fontFamilyFallback;
  final Prop<double>? fontSize;
  final Prop<FontWeight>? fontWeight;
  final Prop<FontStyle>? fontStyle;
  final Prop<double>? height;
  final Prop<double>? leading;
  final Prop<bool>? forceStrutHeight;

  StrutStyleMix.only({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    double? leading,
    bool? forceStrutHeight,
  }) : this(
         fontFamily: Prop.maybe(fontFamily),
         fontFamilyFallback: fontFamilyFallback?.map(Prop.new).toList(),
         fontSize: Prop.maybe(fontSize),
         fontWeight: Prop.maybe(fontWeight),
         fontStyle: Prop.maybe(fontStyle),
         height: Prop.maybe(height),
         leading: Prop.maybe(leading),
         forceStrutHeight: Prop.maybe(forceStrutHeight),
       );

  const StrutStyleMix({
    this.fontFamily,
    this.fontFamilyFallback,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.height,
    this.leading,
    this.forceStrutHeight,
  });

  /// Constructor that accepts a [StrutStyle] value and extracts its properties.
  ///
  /// This is useful for converting existing [StrutStyle] instances to [StrutStyleMix].
  ///
  /// ```dart
  /// const strutStyle = StrutStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  /// final dto = StrutStyleMix.value(strutStyle);
  /// ```
  StrutStyleMix.value(StrutStyle strutStyle)
    : this.only(
        fontFamily: strutStyle.fontFamily,
        fontFamilyFallback: strutStyle.fontFamilyFallback,
        fontSize: strutStyle.fontSize,
        fontWeight: strutStyle.fontWeight,
        fontStyle: strutStyle.fontStyle,
        height: strutStyle.height,
        leading: strutStyle.leading,
        forceStrutHeight: strutStyle.forceStrutHeight,
      );

  /// Constructor that accepts a nullable [StrutStyle] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StrutStyleMix.value].
  ///
  /// ```dart
  /// const StrutStyle? strutStyle = StrutStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  /// final dto = StrutStyleMix.maybeValue(strutStyle); // Returns StrutStyleMix or null
  /// ```
  static StrutStyleMix? maybeValue(StrutStyle? strutStyle) {
    return strutStyle != null ? StrutStyleMix.value(strutStyle) : null;
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
  StrutStyleMix merge(StrutStyleMix? other) {
    if (other == null) return this;

    return StrutStyleMix(
      fontFamily: MixHelpers.merge(fontFamily, other.fontFamily),
      fontFamilyFallback: MixHelpers.mergeList(
        fontFamilyFallback,
        other.fontFamilyFallback,
        strategy: ListMergeStrategy.append,
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
