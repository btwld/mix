import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/prop.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show Style, VariantStyleAttribute;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/layout/constraints_util.dart';
import '../../properties/layout/edge_insets_geometry_util.dart';
import '../../properties/painting/decoration_util.dart';
import '../../variants/variant_util.dart';
import 'box_attribute.dart';
import 'box_spec.dart';

/// Mutable utility class for box styling using composition over inheritance.
///
/// Same API as BoxMix but with mutable internal state
/// for cascade notation support: `$box..color.red()..width(100)`
class BoxSpecUtility extends StyleAttributeBuilder<BoxSpec> {
  // SAME UTILITIES AS BoxMix - but return BoxSpecUtility for cascade

  late final padding = EdgeInsetsGeometryUtility<BoxSpecUtility>(
    (prop) => buildProps(padding: prop),
  );

  late final margin = EdgeInsetsGeometryUtility<BoxSpecUtility>(
    (prop) => buildProps(margin: prop),
  );

  late final constraints = BoxConstraintsUtility<BoxSpecUtility>(
    (prop) => buildProps(constraints: prop),
  );

  late final decoration = DecorationUtility<BoxSpecUtility>(
    (prop) => buildProps(decoration: prop),
  );

  late final on = OnContextVariantUtility<BoxSpec, BoxSpecUtility>(
    (v) => buildProps(variants: [v]),
  );

  late final wrap = ModifierUtility<BoxSpecUtility>(
    (prop) => buildProps(modifierConfig: ModifierConfig.modifier(prop)),
  );

  // FLATTENED ACCESS - Same as BoxMix
  late final border = decoration.box.border;

  late final borderRadius = decoration.box.borderRadius;
  late final color = decoration.box.color;
  late final gradient = decoration.box.gradient;
  late final shape =
      decoration.box.shape; // CONVENIENCE SHORTCUTS - Same as BoxMix
  late final width = constraints.width;

  late final height = constraints.height;
  late final minWidth = constraints.minWidth;
  late final maxWidth = constraints.maxWidth;
  late final minHeight = constraints.minHeight;
  late final maxHeight =
      constraints.maxHeight; // PROP UTILITIES - Same as BoxMix
  late final transform = PropUtility<BoxSpecUtility, Matrix4>(
    (prop) => buildProps(transform: prop),
  );

  late final transformAlignment =
      PropUtility<BoxSpecUtility, AlignmentGeometry>(
        (prop) => buildProps(transformAlignment: prop),
      );

  late final clipBehavior = PropUtility<BoxSpecUtility, Clip>(
    (prop) => buildProps(clipBehavior: prop),
  );

  late final alignment = PropUtility<BoxSpecUtility, AlignmentGeometry>(
    (prop) => buildProps(alignment: prop),
  );

  BoxMix _baseAttribute;

  BoxSpecUtility([BoxMix? attribute]) : _baseAttribute = attribute ?? BoxMix();

  @protected
  BoxSpecUtility buildProps({
    Prop<AlignmentGeometry>? alignment,
    MixProp<EdgeInsetsGeometry>? padding,
    MixProp<EdgeInsetsGeometry>? margin,
    MixProp<BoxConstraints>? constraints,
    MixProp<Decoration>? decoration,
    MixProp<Decoration>? foregroundDecoration,
    Prop<Matrix4>? transform,
    Prop<AlignmentGeometry>? transformAlignment,
    Prop<Clip>? clipBehavior,
    AnimationConfig? animation,
    ModifierConfig? modifierConfig,
    List<VariantStyleAttribute<BoxSpec>>? variants,
  }) {
    final newAttribute = BoxMix.raw(
      alignment: alignment,
      padding: padding,
      margin: margin,
      constraints: constraints,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      variants: variants,
      modifierConfig: modifierConfig,
      animation: animation,
    );
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  BoxMix call() => _baseAttribute;

  /// Animation
  BoxSpecUtility animate(AnimationConfig animation) =>
      buildProps(animation: animation);

  // StyleAttribute interface implementation

  @override
  BoxSpecUtility merge(Style<BoxSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is BoxSpecUtility) {
      return BoxSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is BoxMix) {
      return BoxSpecUtility(_baseAttribute.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  BoxSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  BoxMix get attribute => _baseAttribute;
}
