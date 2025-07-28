import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/painting/color_util.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/painting/shadow_util.dart';
import '../../variants/variant_util.dart';
import 'icon_attribute.dart';
import 'icon_spec.dart';

/// Mutable utility class for icon styling using composition over inheritance.
///
/// Same API as IconMix but with mutable internal state
/// for cascade notation support: `$icon..color(Colors.blue)..size(24)..weight(400)`
class IconSpecUtility extends StyleAttributeBuilder<IconSpec> {
  // ICON UTILITIES - Same as IconMix but return IconSpecUtility for cascade

  late final color = ColorUtility<IconSpecUtility>(
    (prop) => _build(IconMix.raw(color: prop)),
  );

  late final size = PropUtility<IconSpecUtility, double>(
    (prop) => _build(IconMix.raw(size: prop)),
  );

  late final weight = PropUtility<IconSpecUtility, double>(
    (prop) => _build(IconMix.raw(weight: prop)),
  );

  late final grade = PropUtility<IconSpecUtility, double>(
    (prop) => _build(IconMix.raw(grade: prop)),
  );

  late final opticalSize = PropUtility<IconSpecUtility, double>(
    (prop) => _build(IconMix.raw(opticalSize: prop)),
  );

  late final shadow = ShadowUtility<IconSpecUtility>(
    (v) => _build(IconMix.raw(shadows: [v])),
  );

  late final textDirection = PropUtility<IconSpecUtility, TextDirection>(
    (prop) => _build(IconMix.raw(textDirection: prop)),
  );

  late final applyTextScaling = PropUtility<IconSpecUtility, bool>(
    (prop) => _build(IconMix.raw(applyTextScaling: prop)),
  );

  late final fill = PropUtility<IconSpecUtility, double>(
    (prop) => _build(IconMix.raw(fill: prop)),
  );

  late final on = OnContextVariantUtility<IconSpec, IconSpecUtility>(
    (v) => _build(IconMix(variants: [v])),
  );

  late final wrap = ModifierUtility<IconSpecUtility>(
    (prop) => _build(IconMix(modifierConfig: ModifierConfig.modifier(prop))),
  );

  IconMix _baseAttribute;

  IconSpecUtility([IconMix? attribute])
    : _baseAttribute = attribute ?? IconMix();

  /// Mutable builder - updates internal state and returns this for cascade
  IconSpecUtility _build(IconMix newAttribute) {
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  // Instance method for multiple shadows
  IconSpecUtility shadows(List<ShadowMix> value) =>
      _build(IconMix(shadows: value));

  /// Animation
  IconSpecUtility animate(AnimationConfig animation) =>
      _build(IconMix(animation: animation));

  // StyleAttribute interface implementation

  @override
  IconSpecUtility merge(Style<IconSpec>? other) {
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is IconSpecUtility) {
      return IconSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is IconMix) {
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
  IconMix get attribute => _baseAttribute;
}
