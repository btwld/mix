import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/painting/color_util.dart';
import '../../properties/typography/strut_style_util.dart';
import '../../properties/typography/text_height_behavior_util.dart';
import '../../properties/typography/text_style_util.dart';
import '../../variants/variant_util.dart';
import 'text_attribute.dart';
import 'text_spec.dart';

/// Mutable utility class for text styling using composition over inheritance.
///
/// Same API as TextMix but with mutable internal state
/// for cascade notation support: `$text..color.red()..fontSize(16)`
class TextSpecUtility extends StyleMutableBuilder<TextSpec> {
  // TEXT UTILITIES - Same as TextMix but return TextSpecUtility for cascade
  @override
  late final MutableTextMix value;

  late final textOverflow = MixUtility(value.overflow);

  late final strutStyle = StrutStyleUtility(value.strutStyle);

  late final textAlign = MixUtility(value.textAlign);
  late final textScaler = MixUtility(value.textScaler);
  late final maxLines = MixUtility(value.maxLines);
  late final style = TextStyleUtility(
    (prop) => value.merge(TextMix.raw(style: prop)),
  );
  late final textWidthBasis = MixUtility(value.textWidthBasis);
  late final textHeightBehavior = TextHeightBehaviorUtility<TextMix>(
    value.textHeightBehavior,
  );
  late final textDirection = MixUtility(value.textDirection);
  late final softWrap = MixUtility(value.softWrap);
  late final directives = MixUtility(value.contentModifier);
  late final selectionColor = ColorUtility<TextMix>(
    (prop) => value.merge(TextMix.raw(selectionColor: prop)),
  );
  late final semanticsLabel = MixUtility(value.semanticsLabel);
  late final locale = MixUtility(value.locale);

  late final on = OnContextVariantUtility<TextSpec, TextMix>(
    (v) => value.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => value.modifier(ModifierConfig(modifiers: [prop])),
  );

  // FLATTENED ACCESS - Direct access to commonly used style properties
  late final color = style.color;
  late final fontFamily = style.fontFamily;
  late final fontSize = style.fontSize;
  late final fontWeight = style.fontWeight;
  late final fontStyle = style.fontStyle;
  late final decoration = style.decoration;
  late final backgroundColor = style.backgroundColor;
  late final decorationColor = style.decorationColor;
  late final decorationStyle = style.decorationStyle;
  late final textBaseline = style.textBaseline;
  late final height = style.height;
  late final letterSpacing = style.letterSpacing;
  late final wordSpacing = style.wordSpacing;
  late final fontVariations = style.fontVariations;
  late final shadows = style.shadows;
  late final foreground = style.foreground;
  late final background = style.background;
  late final fontFeatures = style.fontFeatures;
  late final debugLabel = style.debugLabel;
  late final decorationThickness = style.decorationThickness;
  late final fontFamilyFallback = style.fontFamilyFallback;
  // ignore: prefer_final_fields

  TextSpecUtility([TextMix? attribute]) {
    value = MutableTextMix(attribute ?? TextMix());
  }

  // Convenience methods
  TextMix bold() => style.bold();
  TextMix italic() => style.italic();

  /// Animation
  TextMix animate(AnimationConfig animation) => value.animate(animation);

  // StyleAttribute interface implementation

  @override
  TextSpecUtility merge(Style<TextSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is TextSpecUtility) {
      return TextSpecUtility(value.merge(other.value));
    }
    if (other is TextMix) {
      return TextSpecUtility(value.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  TextSpec resolve(BuildContext context) {
    return value.resolve(context);
  }
}

class MutableTextMix extends TextMix with Mutable<TextSpec, TextMix> {
  MutableTextMix([TextMix? attribute]) {
    merge(attribute);
  }
}
