import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/prop.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show Style, VariantStyleAttribute;
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
    (prop) => buildProps(color: prop),
  );

  late final size = PropUtility<IconSpecUtility, double>(
    (prop) => buildProps(size: prop),
  );

  late final weight = PropUtility<IconSpecUtility, double>(
    (prop) => buildProps(weight: prop),
  );

  late final grade = PropUtility<IconSpecUtility, double>(
    (prop) => buildProps(grade: prop),
  );

  late final opticalSize = PropUtility<IconSpecUtility, double>(
    (prop) => buildProps(opticalSize: prop),
  );

  late final shadow = ShadowUtility<IconSpecUtility>(
    (v) => buildProps(shadows: [v]),
  );

  late final textDirection = PropUtility<IconSpecUtility, TextDirection>(
    (prop) => buildProps(textDirection: prop),
  );

  late final applyTextScaling = PropUtility<IconSpecUtility, bool>(
    (prop) => buildProps(applyTextScaling: prop),
  );

  late final fill = PropUtility<IconSpecUtility, double>(
    (prop) => buildProps(fill: prop),
  );

  late final on = OnContextVariantUtility<IconSpec, IconSpecUtility>(
    (v) => buildProps(variants: [v]),
  );

  late final wrap = ModifierUtility<IconSpecUtility>(
    (prop) => buildProps(modifierConfig: ModifierConfig.modifier(prop)),
  );

  IconMix _baseAttribute;

  IconSpecUtility([IconMix? attribute])
    : _baseAttribute = attribute ?? IconMix();

  @protected
  IconSpecUtility buildProps({
    Prop<Color>? color,
    Prop<double>? size,
    Prop<double>? weight,
    Prop<double>? grade,
    Prop<double>? opticalSize,
    List<MixProp<Shadow>>? shadows,
    Prop<TextDirection>? textDirection,
    Prop<bool>? applyTextScaling,
    Prop<double>? fill,
    AnimationConfig? animation,
    ModifierConfig? modifierConfig,
    List<VariantStyleAttribute<IconSpec>>? variants,
  }) {
    final newAttribute = IconMix.raw(
      color: color,
      size: size,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      shadows: shadows,
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      fill: fill,
      animation: animation,
      modifierConfig: modifierConfig,
      variants: variants,
    );
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  // Instance method for multiple shadows
  IconSpecUtility shadows(List<ShadowMix> value) =>
      buildProps(shadows: value.map(MixProp.new).toList());

  /// Animation
  IconSpecUtility animate(AnimationConfig animation) =>
      buildProps(animation: animation);

  // StyleAttribute interface implementation

  @override
  IconSpecUtility merge(Style<IconSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is IconSpecUtility) {
      return IconSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is IconMix) {
      return IconSpecUtility(_baseAttribute.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  IconSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  IconMix get mix => _baseAttribute;
}
