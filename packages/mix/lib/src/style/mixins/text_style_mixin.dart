import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/typography/text_style_mix.dart';

/// Provides convenient text styling methods for spec attributes.
mixin TextStyleMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T style(TextStyleMix value);

  /// Sets text color
  T color(Color value) {
    return style(TextStyleMix.color(value));
  }

  /// Sets background color
  T backgroundColor(Color value) {
    return style(TextStyleMix.backgroundColor(value));
  }

  /// Sets font size
  T fontSize(double value) {
    return style(TextStyleMix.fontSize(value));
  }

  /// Sets font weight
  T fontWeight(FontWeight value) {
    return style(TextStyleMix.fontWeight(value));
  }

  /// Sets font style
  T fontStyle(FontStyle value) {
    return style(TextStyleMix.fontStyle(value));
  }

  /// Sets letter spacing
  T letterSpacing(double value) {
    return style(TextStyleMix.letterSpacing(value));
  }

  /// Sets word spacing
  T wordSpacing(double value) {
    return style(TextStyleMix.wordSpacing(value));
  }

  /// Sets line height
  T height(double value) {
    return style(TextStyleMix.height(value));
  }

  /// Sets text baseline
  T textBaseline(TextBaseline value) {
    return style(TextStyleMix.textBaseline(value));
  }

  /// Sets text decoration
  T decoration(TextDecoration value) {
    return style(TextStyleMix.decoration(value));
  }

  /// Sets decoration color
  T decorationColor(Color value) {
    return style(TextStyleMix.decorationColor(value));
  }

  /// Sets decoration style
  T decorationStyle(TextDecorationStyle value) {
    return style(TextStyleMix.decorationStyle(value));
  }

  /// Sets decoration thickness
  T decorationThickness(double value) {
    return style(TextStyleMix.decorationThickness(value));
  }

  /// Sets font family
  T fontFamily(String value) {
    return style(TextStyleMix.fontFamily(value));
  }

  /// Sets font family fallback
  T fontFamilyFallback(List<String> value) {
    return style(TextStyleMix.fontFamilyFallback(value));
  }

  /// Sets text shadows
  T shadows(List<ShadowMix> value) {
    return style(TextStyleMix.shadows(value));
  }

  /// Sets font features
  T fontFeatures(List<FontFeature> value) {
    return style(TextStyleMix.fontFeatures(value));
  }

  /// Sets font variations
  T fontVariations(List<FontVariation> value) {
    return style(TextStyleMix.fontVariations(value));
  }

  /// Sets foreground paint
  T foreground(Paint value) {
    return style(TextStyleMix.foreground(value));
  }

  /// Sets background paint
  T background(Paint value) {
    return style(TextStyleMix.background(value));
  }

  /// Sets debug label
  T debugLabel(String value) {
    return style(TextStyleMix.debugLabel(value));
  }

  /// Sets inherit property
  T inherit(bool value) {
    return style(TextStyleMix.inherit(value));
  }
}