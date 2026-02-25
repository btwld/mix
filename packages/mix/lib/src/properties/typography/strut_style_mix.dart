import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

part 'strut_style_mix.g.dart';

/// Mix representation of [StrutStyle].
///
/// Text layout properties with tokens.
@mixable
@immutable
class StrutStyleMix extends Mix<StrutStyle>
    with Diagnosticable, _$StrutStyleMixMixin {
  // Properties use MixableProperty for cleaner merging
  @override
  final Prop<String>? $fontFamily;
  @override
  final Prop<List<String>>? $fontFamilyFallback;
  @override
  final Prop<double>? $fontSize;
  @override
  final Prop<FontWeight>? $fontWeight;
  @override
  final Prop<FontStyle>? $fontStyle;
  @override
  final Prop<double>? $height;
  @override
  final Prop<double>? $leading;
  @override
  final Prop<bool>? $forceStrutHeight;

  StrutStyleMix({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    double? leading,
    bool? forceStrutHeight,
  }) : this.create(
         fontFamily: Prop.maybe(fontFamily),
         fontFamilyFallback: Prop.maybe(fontFamilyFallback),
         fontSize: Prop.maybe(fontSize),
         fontWeight: Prop.maybe(fontWeight),
         fontStyle: Prop.maybe(fontStyle),
         height: Prop.maybe(height),
         leading: Prop.maybe(leading),
         forceStrutHeight: Prop.maybe(forceStrutHeight),
       );

  const StrutStyleMix.create({
    Prop<String>? fontFamily,
    Prop<List<String>>? fontFamilyFallback,
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
    : this(
        fontFamily: strutStyle.fontFamily,
        fontFamilyFallback: strutStyle.fontFamilyFallback,
        fontSize: strutStyle.fontSize,
        fontWeight: strutStyle.fontWeight,
        fontStyle: strutStyle.fontStyle,
        height: strutStyle.height,
        leading: strutStyle.leading,
        forceStrutHeight: strutStyle.forceStrutHeight,
      );

  /// Creates with font family.
  factory StrutStyleMix.fontFamily(String value) {
    return StrutStyleMix(fontFamily: value);
  }

  /// Creates with font family fallback.
  factory StrutStyleMix.fontFamilyFallback(List<String> value) {
    return StrutStyleMix(fontFamilyFallback: value);
  }

  /// Creates with font size.
  factory StrutStyleMix.fontSize(double value) {
    return StrutStyleMix(fontSize: value);
  }

  /// Creates with font weight.
  factory StrutStyleMix.fontWeight(FontWeight value) {
    return StrutStyleMix(fontWeight: value);
  }

  /// Creates with font style.
  factory StrutStyleMix.fontStyle(FontStyle value) {
    return StrutStyleMix(fontStyle: value);
  }

  /// Creates with line height.
  factory StrutStyleMix.height(double value) {
    return StrutStyleMix(height: value);
  }

  /// Creates with leading space.
  factory StrutStyleMix.leading(double value) {
    return StrutStyleMix(leading: value);
  }

  /// Creates with forced strut height.
  factory StrutStyleMix.forceStrutHeight(bool value) {
    return StrutStyleMix(forceStrutHeight: value);
  }

  /// Creates from nullable [StrutStyle].
  static StrutStyleMix? maybeValue(StrutStyle? strutStyle) {
    return strutStyle != null ? StrutStyleMix.value(strutStyle) : null;
  }

  /// Returns a copy with the specified font family.
  StrutStyleMix fontFamily(String value) {
    return merge(StrutStyleMix.fontFamily(value));
  }

  /// Returns a copy with the specified font family fallback list.
  StrutStyleMix fontFamilyFallback(List<String> value) {
    return merge(StrutStyleMix.fontFamilyFallback(value));
  }

  /// Returns a copy with the specified font size.
  StrutStyleMix fontSize(double value) {
    return merge(StrutStyleMix.fontSize(value));
  }

  /// Returns a copy with the specified font weight.
  StrutStyleMix fontWeight(FontWeight value) {
    return merge(StrutStyleMix.fontWeight(value));
  }

  /// Returns a copy with the specified font style.
  StrutStyleMix fontStyle(FontStyle value) {
    return merge(StrutStyleMix.fontStyle(value));
  }

  /// Returns a copy with the specified line height.
  StrutStyleMix height(double value) {
    return merge(StrutStyleMix.height(value));
  }

  /// Returns a copy with the specified leading space.
  StrutStyleMix leading(double value) {
    return merge(StrutStyleMix.leading(value));
  }

  /// Returns a copy with forced strut height enabled or disabled.
  StrutStyleMix forceStrutHeight(bool value) {
    return merge(StrutStyleMix.forceStrutHeight(value));
  }
}
