import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show StyleAttribute;
import '../../core/utility.dart';
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
/// Same API as TextSpecAttribute but with mutable internal state
/// for cascade notation support: `$text..color.red()..fontSize(16)`
class TextSpecUtility extends StyleAttributeBuilder<TextSpec> {
  // TEXT UTILITIES - Same as TextSpecAttribute but return TextSpecUtility for cascade

  late final textOverflow = PropUtility<TextSpecUtility, TextOverflow>(
    (prop) => _build(TextSpecAttribute.raw(overflow: prop)),
  );

  late final strutStyle = StrutStyleUtility<TextSpecUtility>(
    (prop) => _build(TextSpecAttribute.raw(strutStyle: prop)),
  );

  late final textAlign = PropUtility<TextSpecUtility, TextAlign>(
    (prop) => _build(TextSpecAttribute.raw(textAlign: prop)),
  );

  late final textScaler = PropUtility<TextSpecUtility, TextScaler>(
    (prop) => _build(TextSpecAttribute.raw(textScaler: prop)),
  );

  late final maxLines = PropUtility<TextSpecUtility, int>(
    (prop) => _build(TextSpecAttribute.raw(maxLines: prop)),
  );

  late final style = TextStyleUtility<TextSpecUtility>(
    (prop) => _build(TextSpecAttribute.raw(style: prop)),
  );

  late final textWidthBasis = PropUtility<TextSpecUtility, TextWidthBasis>(
    (prop) => _build(TextSpecAttribute.raw(textWidthBasis: prop)),
  );

  late final textHeightBehavior = TextHeightBehaviorUtility<TextSpecUtility>(
    (prop) => _build(TextSpecAttribute.raw(textHeightBehavior: prop)),
  );

  late final textDirection = PropUtility<TextSpecUtility, TextDirection>(
    (prop) => _build(TextSpecAttribute.raw(textDirection: prop)),
  );

  late final softWrap = PropUtility<TextSpecUtility, bool>(
    (prop) => _build(TextSpecAttribute.raw(softWrap: prop)),
  );

  late final directive = TextDirectiveUtility<TextSpecUtility>(
    (prop) => _build(TextSpecAttribute.raw(directives: [prop])),
  );

  late final on = OnContextVariantUtility<TextSpec, TextSpecUtility>(
    (v) => _build(TextSpecAttribute.raw(variants: [v])),
  );

  late final wrap = ModifierUtility<TextSpecUtility>(
    (prop) => _build(TextSpecAttribute(modifiers: [prop])),
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
  TextSpecAttribute _baseAttribute;

  TextSpecUtility([TextSpecAttribute? attribute])
    : _baseAttribute = attribute ?? TextSpecAttribute(),
      super();

  /// Mutable builder - updates internal state and returns this for cascade
  TextSpecUtility _build(TextSpecAttribute newAttribute) {
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  // Convenience methods
  TextSpecUtility bold() => style.bold();
  TextSpecUtility italic() => style.italic();

  /// Animation
  TextSpecUtility animate(AnimationConfig animation) =>
      _build(TextSpecAttribute(animation: animation));

  // StyleAttribute interface implementation

  @override
  TextSpecUtility merge(StyleAttribute<TextSpec>? other) {
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is TextSpecUtility) {
      return TextSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is TextSpecAttribute) {
      return TextSpecUtility(_baseAttribute.merge(other));
    }

    return TextSpecUtility(_baseAttribute);
  }

  @override
  TextSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  TextSpecAttribute get attribute => _baseAttribute;
}
