import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show StyleAttribute;
import '../../core/utility.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/layout/constraints_util.dart';
import '../../properties/layout/edge_insets_geometry_util.dart';
import '../../properties/painting/decoration_util.dart';
import '../../variants/variant_util.dart';
import 'box_attribute.dart';
import 'box_spec.dart';

/// Mutable utility class for box styling using composition over inheritance.
///
/// Same API as BoxSpecAttribute but with mutable internal state
/// for cascade notation support: `$box..color.red()..width(100)`
class BoxSpecUtility extends StyleAttributeBuilder<BoxSpec> {
  // SAME UTILITIES AS BoxSpecAttribute - but return BoxSpecUtility for cascade

  late final padding = EdgeInsetsGeometryUtility<BoxSpecUtility>(
    (prop) => _build(BoxSpecAttribute(padding: prop)),
  );

  late final margin = EdgeInsetsGeometryUtility<BoxSpecUtility>(
    (prop) => _build(BoxSpecAttribute(margin: prop)),
  );

  late final constraints = BoxConstraintsUtility<BoxSpecUtility>(
    (prop) => _build(BoxSpecAttribute(constraints: prop)),
  );

  late final decoration = DecorationUtility<BoxSpecUtility>(
    (prop) => _build(BoxSpecAttribute(decoration: prop)),
  );

  late final on = OnContextVariantUtility<BoxSpec, BoxSpecUtility>(
    (v) => _build(BoxSpecAttribute(variants: [v])),
  );

  late final wrap = ModifierUtility<BoxSpecUtility>(
    (prop) => _build(BoxSpecAttribute.only(modifiers: [prop])),
  );

  // FLATTENED ACCESS - Same as BoxSpecAttribute
  late final border = decoration.box.border;

  late final borderRadius = decoration.box.borderRadius;
  late final color = decoration.box.color;
  late final gradient = decoration.box.gradient;
  late final shape =
      decoration.box.shape; // CONVENIENCE SHORTCUTS - Same as BoxSpecAttribute
  late final width = constraints.width;

  late final height = constraints.height;
  late final minWidth = constraints.minWidth;
  late final maxWidth = constraints.maxWidth;
  late final minHeight = constraints.minHeight;
  late final maxHeight =
      constraints.maxHeight; // PROP UTILITIES - Same as BoxSpecAttribute
  late final transform = PropUtility<BoxSpecUtility, Matrix4>(
    (prop) => _build(BoxSpecAttribute(transform: prop)),
  );

  late final transformAlignment =
      PropUtility<BoxSpecUtility, AlignmentGeometry>(
        (prop) => _build(BoxSpecAttribute(transformAlignment: prop)),
      );

  late final clipBehavior = PropUtility<BoxSpecUtility, Clip>(
    (prop) => _build(BoxSpecAttribute(clipBehavior: prop)),
  );

  late final alignment = PropUtility<BoxSpecUtility, AlignmentGeometry>(
    (prop) => _build(BoxSpecAttribute(alignment: prop)),
  );

  BoxSpecAttribute _baseAttribute;

  BoxSpecUtility([BoxSpecAttribute? attribute])
    : _baseAttribute = attribute ?? BoxSpecAttribute();

  /// Mutable builder - updates internal state and returns this for cascade
  BoxSpecUtility _build(BoxSpecAttribute newAttribute) {
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  /// Animation
  BoxSpecUtility animate(AnimationConfig animation) =>
      _build(BoxSpecAttribute.animation(animation));

  // StyleAttribute interface implementation

  @override
  BoxSpecUtility merge(StyleAttribute<BoxSpec>? other) {
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is BoxSpecUtility) {
      return BoxSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is BoxSpecAttribute) {
      return BoxSpecUtility(_baseAttribute.merge(other));
    }

    return BoxSpecUtility(_baseAttribute);
  }

  @override
  BoxSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  BoxSpecAttribute get attribute => _baseAttribute;
}
