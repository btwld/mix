import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/painting/color_util.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/painting/shadow_util.dart';
import '../../variants/variant_util.dart';
import 'icon_attribute.dart';
import 'icon_spec.dart';

/// Mutable utility class for icon styling using composition over inheritance.
///
/// Same API as IconSpecAttribute but with mutable internal state
/// for cascade notation support: `$icon..color(Colors.blue)..size(24)..weight(400)`
class IconSpecUtility extends StyleAttributeBuilder<IconSpec> {
  // ICON UTILITIES - Same as IconSpecAttribute but return IconSpecUtility for cascade

  late final color = ColorUtility<IconSpecUtility>(
    (prop) => _build(IconSpecAttribute.raw(color: prop)),
  );

  late final size = PropUtility<IconSpecUtility, double>(
    (prop) => _build(IconSpecAttribute.raw(size: prop)),
  );

  late final weight = PropUtility<IconSpecUtility, double>(
    (prop) => _build(IconSpecAttribute.raw(weight: prop)),
  );

  late final grade = PropUtility<IconSpecUtility, double>(
    (prop) => _build(IconSpecAttribute.raw(grade: prop)),
  );

  late final opticalSize = PropUtility<IconSpecUtility, double>(
    (prop) => _build(IconSpecAttribute.raw(opticalSize: prop)),
  );

  late final shadow = ShadowUtility<IconSpecUtility>(
    (v) => _build(IconSpecAttribute.raw(shadows: [v])),
  );

  late final textDirection = PropUtility<IconSpecUtility, TextDirection>(
    (prop) => _build(IconSpecAttribute.raw(textDirection: prop)),
  );

  late final applyTextScaling = PropUtility<IconSpecUtility, bool>(
    (prop) => _build(IconSpecAttribute.raw(applyTextScaling: prop)),
  );

  late final fill = PropUtility<IconSpecUtility, double>(
    (prop) => _build(IconSpecAttribute.raw(fill: prop)),
  );

  late final on = OnContextVariantUtility<IconSpec, IconSpecUtility>(
    (v) => _build(IconSpecAttribute(variants: [v])),
  );

  late final wrap = ModifierUtility<IconSpecUtility>(
    (prop) => _build(IconSpecAttribute(modifiers: [prop])),
  );

  IconSpecAttribute _baseAttribute;

  IconSpecUtility([IconSpecAttribute? attribute])
    : _baseAttribute = attribute ?? IconSpecAttribute(),
      super();

  /// Mutable builder - updates internal state and returns this for cascade
  IconSpecUtility _build(IconSpecAttribute newAttribute) {
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  // Instance method for multiple shadows
  IconSpecUtility shadows(List<ShadowMix> value) =>
      _build(IconSpecAttribute(shadows: value));

  /// Animation
  IconSpecUtility animate(AnimationConfig animation) =>
      _build(IconSpecAttribute(animation: animation));

  // StyleAttribute interface implementation

  @override
  IconSpecUtility merge(Style<IconSpec>? other) {
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is IconSpecUtility) {
      return IconSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is IconSpecAttribute) {
      return IconSpecUtility(_baseAttribute.merge(other));
    }

    return IconSpecUtility(_baseAttribute);
  }

  @override
  IconSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  IconSpecAttribute get attribute => _baseAttribute;
}
