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

/// Provides mutable utility for text styling with cascade notation support.
///
/// Supports the same API as [TextMix] but maintains mutable internal state
/// enabling fluid styling: `$text..color.red()..fontSize(16)`.
class TextSpecUtility extends StyleMutableBuilder<TextSpec> {
  late final textOverflow = MixUtility(mutable.overflow);

  late final strutStyle = StrutStyleUtility(mutable.strutStyle);

  late final textAlign = MixUtility(mutable.textAlign);

  late final textScaler = MixUtility(mutable.textScaler);

  late final style = TextStyleUtility(
    (prop) => mutable.merge(TextMix.create(style: prop)),
  );
  late final textWidthBasis = MixUtility(mutable.textWidthBasis);
  late final textHeightBehavior = TextHeightBehaviorUtility<TextMix>(
    mutable.textHeightBehavior,
  );
  late final textDirection = MixUtility(mutable.textDirection);
  late final directives = MixUtility(mutable.textDirective);
  late final selectionColor = ColorUtility<TextMix>(
    (prop) => mutable.merge(TextMix.create(selectionColor: prop)),
  );
  late final locale = MixUtility(mutable.locale);
  late final on = OnContextVariantUtility<TextSpec, TextMix>(
    (v) => mutable.variants([v]),
  );
  late final wrap = WidgetModifierUtility(
    (prop) => mutable.wrap(ModifierConfig(modifiers: [prop])),
  );

  // Direct access to commonly used style properties
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

  /// Internal mutable state for accumulating text styling properties.
  @override
  @protected
  late final MutableTextMix mutable;
  TextSpecUtility([TextMix? attribute]) {
    mutable = MutableTextMix(attribute ?? TextMix());
  }

  TextMix maxLines(int v) => mutable.maxLines(v);
  TextMix softWrap(bool v) => mutable.softWrap(v);
  TextMix semanticsLabel(String v) => mutable.semanticsLabel(v);

  /// Makes the text bold by setting font weight to bold.
  TextMix bold() => style.bold();

  /// Makes the text italic by setting font style to italic.
  TextMix italic() => style.italic();

  /// Applies animation configuration to the text styling.
  TextMix animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  TextSpecUtility merge(Style<TextSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is TextSpecUtility) {
      return TextSpecUtility(mutable.value.merge(other.mutable.value));
    }
    if (other is TextMix) {
      return TextSpecUtility(mutable.value.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  TextSpec resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  /// The accumulated [TextMix] with all applied styling properties.
  @override
  TextMix get value => mutable.value;
}

class MutableTextMix extends TextMix with Mutable<TextSpec, TextMix> {
  MutableTextMix(TextMix style) {
    value = style;
  }
}
