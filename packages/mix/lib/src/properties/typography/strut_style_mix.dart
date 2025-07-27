// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../core/internal/diagnostic_properties_builder_ext.dart';

/// Mix-compatible representation of Flutter's [StrutStyle] with token support.
///
/// Provides strut styling properties for text layout including font family, size, 
/// weight, height, and spacing with resolvable tokens and merging capabilities.
@immutable
class StrutStyleMix extends Mix<StrutStyle> with Diagnosticable {
  // Properties use MixableProperty for cleaner merging
  final Prop<String>? $fontFamily;
  final List<Prop<String>>? $fontFamilyFallback;
  final Prop<double>? $fontSize;
  final Prop<FontWeight>? $fontWeight;
  final Prop<FontStyle>? $fontStyle;
  final Prop<double>? $height;
  final Prop<double>? $leading;
  final Prop<bool>? $forceStrutHeight;

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
    Prop<String>? fontFamily,
    List<Prop<String>>? fontFamilyFallback,
    Prop<double>? fontSize,
    Prop<FontWeight>? fontWeight,
    Prop<FontStyle>? fontStyle,
    Prop<double>? height,
    Prop<double>? leading,
    Prop<bool>? forceStrutHeight,
  }) : $fontFamily = fontFamily,
       $fontFamilyFallback = fontFamilyFallback,
       $fontSize = fontSize,
       $fontWeight = fontWeight,
       $fontStyle = fontStyle,
       $height = height,
       $leading = leading,
       $forceStrutHeight = forceStrutHeight;

  /// Creates a [StrutStyleMix] from an existing [StrutStyle].
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

  /// Creates a strut style with the specified font family.
  factory StrutStyleMix.fontFamily(String value) {
    return StrutStyleMix.only(fontFamily: value);
  }

  /// Creates a strut style with the specified font family fallback list.
  factory StrutStyleMix.fontFamilyFallback(List<String> value) {
    return StrutStyleMix.only(fontFamilyFallback: value);
  }

  /// Creates a strut style with the specified font size.
  factory StrutStyleMix.fontSize(double value) {
    return StrutStyleMix.only(fontSize: value);
  }

  /// Creates a strut style with the specified font weight.
  factory StrutStyleMix.fontWeight(FontWeight value) {
    return StrutStyleMix.only(fontWeight: value);
  }

  /// Creates a strut style with the specified font style.
  factory StrutStyleMix.fontStyle(FontStyle value) {
    return StrutStyleMix.only(fontStyle: value);
  }

  /// Creates a strut style with the specified line height.
  factory StrutStyleMix.height(double value) {
    return StrutStyleMix.only(height: value);
  }

  /// Creates a strut style with the specified leading space.
  factory StrutStyleMix.leading(double value) {
    return StrutStyleMix.only(leading: value);
  }

  /// Creates a strut style with forced strut height enabled or disabled.
  factory StrutStyleMix.forceStrutHeight(bool value) {
    return StrutStyleMix.only(forceStrutHeight: value);
  }

  /// Creates a [StrutStyleMix] from a nullable [StrutStyle].
  ///
  /// Returns null if the input is null.
  static StrutStyleMix? maybeValue(StrutStyle? strutStyle) {
    return strutStyle != null ? StrutStyleMix.value(strutStyle) : null;
  }

  /// Returns a copy with the specified font family.
  StrutStyleMix fontFamily(String value) {
    return merge(StrutStyleMix.only(fontFamily: value));
  }

  /// Returns a copy with the specified font family fallback list.
  StrutStyleMix fontFamilyFallback(List<String> value) {
    return merge(StrutStyleMix.only(fontFamilyFallback: value));
  }

  /// Returns a copy with the specified font size.
  StrutStyleMix fontSize(double value) {
    return merge(StrutStyleMix.only(fontSize: value));
  }

  /// Returns a copy with the specified font weight.
  StrutStyleMix fontWeight(FontWeight value) {
    return merge(StrutStyleMix.only(fontWeight: value));
  }

  /// Returns a copy with the specified font style.
  StrutStyleMix fontStyle(FontStyle value) {
    return merge(StrutStyleMix.only(fontStyle: value));
  }

  /// Returns a copy with the specified line height.
  StrutStyleMix height(double value) {
    return merge(StrutStyleMix.only(height: value));
  }

  /// Returns a copy with the specified leading space.
  StrutStyleMix leading(double value) {
    return merge(StrutStyleMix.only(leading: value));
  }

  /// Returns a copy with forced strut height enabled or disabled.
  StrutStyleMix forceStrutHeight(bool value) {
    return merge(StrutStyleMix.only(forceStrutHeight: value));
  }

  @override
  StrutStyle resolve(BuildContext context) {
    return StrutStyle(
      fontFamily: MixHelpers.resolve(context, $fontFamily),
      fontFamilyFallback: MixHelpers.resolveList(context, $fontFamilyFallback),
      fontSize: MixHelpers.resolve(context, $fontSize),
      height: MixHelpers.resolve(context, $height),
      leading: MixHelpers.resolve(context, $leading),
      fontWeight: MixHelpers.resolve(context, $fontWeight),
      fontStyle: MixHelpers.resolve(context, $fontStyle),
      forceStrutHeight: MixHelpers.resolve(context, $forceStrutHeight),
    );
  }

  @override
  StrutStyleMix merge(StrutStyleMix? other) {
    if (other == null) return this;

    return StrutStyleMix(
      fontFamily: MixHelpers.merge($fontFamily, other.$fontFamily),
      fontFamilyFallback: MixHelpers.mergeList(
        $fontFamilyFallback,
        other.$fontFamilyFallback,
        strategy: ListMergeStrategy.append,
      ),
      fontSize: MixHelpers.merge($fontSize, other.$fontSize),
      fontWeight: MixHelpers.merge($fontWeight, other.$fontWeight),
      fontStyle: MixHelpers.merge($fontStyle, other.$fontStyle),
      height: MixHelpers.merge($height, other.$height),
      leading: MixHelpers.merge($leading, other.$leading),
      forceStrutHeight: MixHelpers.merge(
        $forceStrutHeight,
        other.$forceStrutHeight,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.addUsingDefault('fontFamily', $fontFamily);
    properties.addUsingDefault('fontFamilyFallback', $fontFamilyFallback);
    properties.addUsingDefault('fontSize', $fontSize);
    properties.addUsingDefault('fontWeight', $fontWeight);
    properties.addUsingDefault('fontStyle', $fontStyle);
    properties.addUsingDefault('height', $height);
    properties.addUsingDefault('leading', $leading);
    properties.addUsingDefault('forceStrutHeight', $forceStrutHeight);
  }

  @override
  List<Object?> get props => [
    $fontFamily,
    $fontFamilyFallback,
    $fontSize,
    $fontWeight,
    $fontStyle,
    $height,
    $leading,
    $forceStrutHeight,
  ];
}
