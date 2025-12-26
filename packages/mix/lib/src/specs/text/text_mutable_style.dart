import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style, VariantStyle;
import '../../core/style_spec.dart';
import '../../core/utility.dart';
import '../../core/utility_variant_mixin.dart';
import '../../core/utility_widget_state_variant_mixin.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../modifiers/widget_modifier_util.dart';
import '../../properties/painting/color_util.dart';
import '../../properties/typography/strut_style_util.dart';
import '../../properties/typography/text_height_behavior_util.dart';
import '../../properties/typography/text_style_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'text_spec.dart';
import 'text_style.dart';

/// Provides mutable utility for text styling with cascade notation support.
///
/// Supports the same API as [TextStyler] but maintains mutable internal state
/// enabling fluid styling: `$text..color.red()..fontSize(16)`.
class TextMutableStyler extends StyleMutableBuilder<TextSpec>
    with
        UtilityVariantMixin<TextStyler, TextSpec>,
        UtilityWidgetStateVariantMixin<TextStyler, TextSpec> {
  late final textOverflow = MixUtility(mutable.overflow);

  late final strutStyle = StrutStyleUtility(mutable.strutStyle);

  late final textAlign = MixUtility(mutable.textAlign);

  late final textScaler = MixUtility(mutable.textScaler);

  late final style = TextStyleUtility(
    (prop) => mutable.merge(TextStyler.create(style: prop)),
  );
  late final textWidthBasis = MixUtility(mutable.textWidthBasis);
  late final textHeightBehavior = TextHeightBehaviorUtility<TextStyler>(
    mutable.textHeightBehavior,
  );
  late final textDirection = MixUtility(mutable.textDirection);
  late final directives = MixUtility(mutable.textDirective);
  late final selectionColor = ColorUtility<TextStyler>(
    (prop) => mutable.merge(TextStyler.create(selectionColor: prop)),
  );
  late final locale = MixUtility(mutable.locale);
  @Deprecated(
    'Use TextStyler().onHovered() and similar methods directly instead. '
    'This property was deprecated after Mix v2.0.0.',
  )
  late final on = OnContextVariantUtility<TextSpec, TextStyler>(
    (v) => mutable.variants([v]),
  );
  @Deprecated(
    'Use TextStyler().wrap() method directly instead. '
    'This property was deprecated after Mix v2.0.0.',
  )
  late final wrap = WidgetModifierUtility(
    (prop) => mutable.wrap(WidgetModifierConfig(modifiers: [prop])),
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
  late final TextMutableState mutable;
  TextMutableStyler([TextStyler? attribute]) {
    mutable = TextMutableState(attribute ?? TextStyler());
  }

  TextStyler maxLines(int v) => mutable.maxLines(v);

  TextStyler softWrap(bool v) => mutable.softWrap(v);

  TextStyler semanticsLabel(String v) => mutable.semanticsLabel(v);

  /// Makes the text bold by setting font weight to bold.
  TextStyler bold() => style.bold();

  /// Makes the text italic by setting font style to italic.
  TextStyler italic() => style.italic();

  /// Applies animation configuration to the text styling.
  TextStyler animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  TextStyler withVariant(Variant variant, TextStyler style) {
    return mutable.variant(variant, style);
  }

  @override
  TextStyler withVariants(List<VariantStyle<TextSpec>> variants) {
    return mutable.variants(variants);
  }

  @override
  TextMutableStyler merge(Style<TextSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is TextMutableStyler) {
      return TextMutableStyler(mutable.value.merge(other.mutable.value));
    }
    if (other is TextStyler) {
      return TextMutableStyler(mutable.value.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  StyleSpec<TextSpec> resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  @override
  TextStyler get currentValue => mutable.value;

  /// The accumulated [TextStyler] with all applied styling properties.
  @override
  TextStyler get value => mutable.value;
}

class TextMutableState extends TextStyler with Mutable<TextStyler, TextSpec> {
  TextMutableState(TextStyler style) {
    value = style;
  }
}
