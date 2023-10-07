import 'dart:ui';

import 'package:flutter/material.dart';

import '../../attributes/text_style/text_style_attribute.dart';
import 'text.attributes.dart';
import 'text_directives/text_directives.dart';

const kDeprecationMessage = 'Will be removed in the future';

@Deprecated('Use TextUtility instead')
class LegacyTextUtility {
  const LegacyTextUtility._();

  @Deprecated(kDeprecationMessage)
  static TextAttributes style(TextStyle? style) {
    if (style == null) return const TextAttributes();

    return TextAttributes(style: TextStyleAttribute.from(style));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes strutStyle(StrutStyle strutStyle) {
    return TextAttributes(strutStyle: strutStyle);
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes textAlign(TextAlign textAlign) {
    return TextAttributes(textAlign: textAlign);
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes locale(Locale locale) {
    return TextAttributes(locale: locale);
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes softWrap(bool softWrap) {
    return TextAttributes(softWrap: softWrap);
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes overflow(TextOverflow overflow) {
    return TextAttributes(overflow: overflow);
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes textScaleFactor(double textScaleFactor) {
    return TextAttributes(textScaleFactor: textScaleFactor);
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes maxLines(int maxLines) {
    return TextAttributes(maxLines: maxLines);
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes textWidthBasis(TextWidthBasis textWidthBasis) {
    return TextAttributes(textWidthBasis: textWidthBasis);
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes directives(List<TextDirective> directives) {
    return TextAttributes(directives: directives);
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes directive(TextDirective directive) {
    return TextAttributes(directives: [directive]);
  }
}

@Deprecated(kDeprecationMessage)
class LegacyTextStyleUtility {
  const LegacyTextStyleUtility._();

  @Deprecated(kDeprecationMessage)
  static TextAttributes background(Paint? background) {
    return LegacyTextUtility.style(TextStyle(background: background));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes backgroundColor(Color? backgroundColor) {
    return LegacyTextUtility.style(
      TextStyle(backgroundColor: backgroundColor),
    );
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes color(Color? color) {
    return LegacyTextUtility.style(TextStyle(color: color));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes debugLabel(String? debugLabel) {
    return LegacyTextUtility.style(TextStyle(debugLabel: debugLabel));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes decoration(TextDecoration? decoration) {
    return LegacyTextUtility.style(TextStyle(decoration: decoration));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes decorationColor(Color? decorationColor) {
    return LegacyTextUtility.style(
      TextStyle(decorationColor: decorationColor),
    );
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes decorationStyle(
    TextDecorationStyle? decorationStyle,
  ) {
    return LegacyTextUtility.style(
      TextStyle(decorationStyle: decorationStyle),
    );
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes decorationThickness(double? decorationThickness) {
    return LegacyTextUtility.style(
      TextStyle(decorationThickness: decorationThickness),
    );
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes fontFamily(String? fontFamily) {
    return LegacyTextUtility.style(TextStyle(fontFamily: fontFamily));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes fontFamilyFallback(List<String>? fontFamilyFallback) {
    return LegacyTextUtility.style(
      TextStyle(fontFamilyFallback: fontFamilyFallback),
    );
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes fontFeatures(List<FontFeature>? fontFeatures) {
    return LegacyTextUtility.style(TextStyle(fontFeatures: fontFeatures));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes fontSize(double? fontSize) {
    return LegacyTextUtility.style(TextStyle(fontSize: fontSize));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes fontStyle(FontStyle? fontStyle) {
    return LegacyTextUtility.style(TextStyle(fontStyle: fontStyle));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes fontWeight(FontWeight? fontWeight) {
    return LegacyTextUtility.style(TextStyle(fontWeight: fontWeight));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes foreground(Paint? foreground) {
    return LegacyTextUtility.style(TextStyle(foreground: foreground));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes height(double? height) {
    return LegacyTextUtility.style(TextStyle(height: height));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes inherit({inherit = true}) {
    return LegacyTextUtility.style(TextStyle(inherit: inherit));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes letterSpacing(double? letterSpacing) {
    return LegacyTextUtility.style(TextStyle(letterSpacing: letterSpacing));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes locale(Locale? locale) {
    return LegacyTextUtility.style(TextStyle(locale: locale));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes shadows(List<Shadow> shadows) {
    return LegacyTextUtility.style(TextStyle(shadows: shadows));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes textBaseline(TextBaseline? textBaseline) {
    return LegacyTextUtility.style(TextStyle(textBaseline: textBaseline));
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes wordSpacing(double? wordSpacing) {
    return LegacyTextUtility.style(TextStyle(wordSpacing: wordSpacing));
  }
}

@Deprecated(kDeprecationMessage)
class LegacyTextFriendlyUtility {
  const LegacyTextFriendlyUtility._();

  @Deprecated(kDeprecationMessage)
  static TextAttributes textStyle({
    Paint? background,
    Color? backgroundColor,
    Color? color,
    String? debugLabel,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? family,
    List<String>? fontFamilyFallback,
    Paint? foreground,
    double? height,
    bool inherit = true,
    double? letterSpacing,
    Locale? locale,
    Shadow? shadow,
    List<Shadow>? shadows,
    double? size,
    FontStyle? style,
    TextBaseline? textBaseline,
    FontWeight? weight,
    double? wordSpacing,
  }) {
    combineShadows() {
      final s = shadows ?? [];
      if (shadow != null) s.add(shadow);

      return s;
    }

    return LegacyTextUtility.style(
      TextStyle(
        inherit: inherit,
        color: color,
        backgroundColor: backgroundColor,
        fontSize: size,
        fontWeight: weight,
        fontStyle: style,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        locale: locale,
        foreground: foreground,
        background: background,
        shadows: combineShadows(),
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        debugLabel: debugLabel,
        fontFamily: family,
        fontFamilyFallback: fontFamilyFallback,
      ),
    );
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes bold() {
    return LegacyTextStyleUtility.fontWeight(FontWeight.bold);
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes italic() {
    return LegacyTextStyleUtility.fontStyle(FontStyle.italic);
  }

  @Deprecated(kDeprecationMessage)
  static TextAttributes textShadow({
    double blurRadius = 0.0,
    Color color = const Color(0x33000000),
    Offset offset = Offset.zero,
  }) {
    return LegacyTextStyleUtility.shadows([
      Shadow(color: color, offset: offset, blurRadius: blurRadius),
    ]);
  }
}
