import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/directive.dart';
import '../../core/prop.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show Style, VariantStyleAttribute;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/typography/strut_style_util.dart';
import '../../properties/typography/text_height_behavior_util.dart';
import '../../properties/typography/text_style_util.dart';
import '../../variants/variant_util.dart';
import 'text_attribute.dart';
import 'text_directives_util.dart';
import 'text_spec.dart';

/// Mutable utility class for text styling using composition over inheritance.
///
/// Same API as TextMix but with mutable internal state
/// for cascade notation support: `$text..color.red()..fontSize(16)`
class TextSpecUtility extends StyleAttributeBuilder<TextSpec> {
  // TEXT UTILITIES - Same as TextMix but return TextSpecUtility for cascade

  late final textOverflow = PropUtility(_baseAttribute.overflow);

  late final strutStyle = StrutStyleUtility<TextSpecUtility>(
    (prop) => buildProps(strutStyle: prop),
  );

  late final textAlign = PropUtility<TextSpecUtility, TextAlign>(
    (prop) => buildProps(textAlign: prop),
  );

  late final textScaler = PropUtility<TextSpecUtility, TextScaler>(
    (prop) => buildProps(textScaler: prop),
  );

  late final maxLines = PropUtility<TextSpecUtility, int>(
    (prop) => buildProps(maxLines: prop),
  );

  late final style = TextStyleUtility<TextSpecUtility>(
    (prop) => buildProps(style: prop),
  );

  late final textWidthBasis = PropUtility<TextSpecUtility, TextWidthBasis>(
    (prop) => buildProps(textWidthBasis: prop),
  );

  late final textHeightBehavior = TextHeightBehaviorUtility<TextSpecUtility>(
    (prop) => buildProps(textHeightBehavior: prop),
  );

  late final textDirection = PropUtility<TextSpecUtility, TextDirection>(
    (prop) => buildProps(textDirection: prop),
  );

  late final softWrap = PropUtility<TextSpecUtility, bool>(
    (prop) => buildProps(softWrap: prop),
  );

  late final directive = TextDirectiveUtility<TextSpecUtility>(
    (prop) => buildProps(directives: [prop]),
  );

  late final on = OnContextVariantUtility<TextSpec, TextSpecUtility>(
    (v) => buildProps(variants: [v]),
  );

  late final wrap = ModifierUtility<TextSpecUtility>(
    (prop) => buildProps(modifierConfig: ModifierConfig.modifier(prop)),
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
  TextMix _baseAttribute;

  TextSpecUtility([TextMix? attribute])
    : _baseAttribute = attribute ?? TextMix();

  @protected
  TextSpecUtility buildProps({
    Prop<TextOverflow>? overflow,
    MixProp<StrutStyle>? strutStyle,
    Prop<TextAlign>? textAlign,
    Prop<TextScaler>? textScaler,
    Prop<int>? maxLines,
    MixProp<TextStyle>? style,
    Prop<TextWidthBasis>? textWidthBasis,
    MixProp<TextHeightBehavior>? textHeightBehavior,
    Prop<TextDirection>? textDirection,
    Prop<bool>? softWrap,
    AnimationConfig? animation,
    ModifierConfig? modifierConfig,
    List<MixDirective<String>>? directives,
    List<VariantStyleAttribute<TextSpec>>? variants,
  }) {
    final newAttribute = TextMix.raw(
      overflow: overflow,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textScaler: textScaler,
      maxLines: maxLines,
      style: style,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      textDirection: textDirection,
      softWrap: softWrap,
      directives: directives,
      animation: animation,
      modifierConfig: modifierConfig,
      variants: variants,
    );
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  // Convenience methods
  TextSpecUtility bold() => style.bold();
  TextSpecUtility italic() => style.italic();

  /// Animation
  TextSpecUtility animate(AnimationConfig animation) =>
      buildProps(animation: animation);

  // StyleAttribute interface implementation

  @override
  TextSpecUtility merge(Style<TextSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is TextSpecUtility) {
      return TextSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is TextMix) {
      return TextSpecUtility(_baseAttribute.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  TextSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  TextMix get attribute => _baseAttribute;
}
