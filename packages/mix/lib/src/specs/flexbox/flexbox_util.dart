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
import '../box/box_attribute.dart';
import '../flex/flex_attribute.dart';
import 'flexbox_spec.dart';

/// Mutable utility class for flexbox styling using composition over inheritance.
///
/// Same API as FlexBoxSpecAttribute but with mutable internal state
/// for cascade notation support: `$flexbox..color.red()..width(100)`
class FlexBoxSpecUtility extends StyleAttributeBuilder<FlexBoxSpec> {
  // BOX UTILITIES - Same as BoxSpecUtility but return FlexBoxSpecUtility for cascade

  late final padding = EdgeInsetsGeometryUtility<FlexBoxSpecUtility>(
    (prop) =>
        _build(FlexBoxSpecAttribute(box: BoxSpecAttribute.raw(padding: prop))),
  );

  late final margin = EdgeInsetsGeometryUtility<FlexBoxSpecUtility>(
    (prop) =>
        _build(FlexBoxSpecAttribute(box: BoxSpecAttribute.raw(margin: prop))),
  );

  late final constraints = BoxConstraintsUtility<FlexBoxSpecUtility>(
    (prop) => _build(
      FlexBoxSpecAttribute(box: BoxSpecAttribute.raw(constraints: prop)),
    ),
  );

  late final decoration = DecorationUtility<FlexBoxSpecUtility>(
    (prop) => _build(
      FlexBoxSpecAttribute(box: BoxSpecAttribute.raw(decoration: prop)),
    ),
  );

  late final on = OnContextVariantUtility<FlexBoxSpec, FlexBoxSpecUtility>(
    (v) => _build(FlexBoxSpecAttribute(variants: [v])),
  );

  late final wrap = ModifierUtility<FlexBoxSpecUtility>(
    (prop) => _build(FlexBoxSpecAttribute(modifiers: [prop])),
  );

  // FLATTENED ACCESS - Same as BoxSpecUtility but for FlexBox
  late final border = decoration.box.border;

  late final borderRadius = decoration.box.borderRadius;
  late final color = decoration.box.color;
  late final gradient = decoration.box.gradient;
  late final shape = decoration.box.shape; // BOX CONVENIENCE SHORTCUTS
  late final width = constraints.width;

  late final height = constraints.height;
  late final minWidth = constraints.minWidth;
  late final maxWidth = constraints.maxWidth;
  late final minHeight = constraints.minHeight;
  late final maxHeight = constraints.maxHeight; // BOX PROP UTILITIES
  late final transform = PropUtility<FlexBoxSpecUtility, Matrix4>(
    (prop) => _build(
      FlexBoxSpecAttribute(box: BoxSpecAttribute.raw(transform: prop)),
    ),
  );

  late final transformAlignment =
      PropUtility<FlexBoxSpecUtility, AlignmentGeometry>(
        (prop) => _build(
          FlexBoxSpecAttribute(
            box: BoxSpecAttribute.raw(transformAlignment: prop),
          ),
        ),
      );

  late final clipBehavior = PropUtility<FlexBoxSpecUtility, Clip>(
    (prop) => _build(
      FlexBoxSpecAttribute(box: BoxSpecAttribute.raw(clipBehavior: prop)),
    ),
  );

  late final alignment = PropUtility<FlexBoxSpecUtility, AlignmentGeometry>(
    (prop) => _build(
      FlexBoxSpecAttribute(box: BoxSpecAttribute.raw(alignment: prop)),
    ),
  );

  // FLEX UTILITIES
  late final direction = PropUtility<FlexBoxSpecUtility, Axis>(
    (prop) => _build(
      FlexBoxSpecAttribute(flex: FlexSpecAttribute.raw(direction: prop)),
    ),
  );

  late final mainAxisAlignment =
      PropUtility<FlexBoxSpecUtility, MainAxisAlignment>(
        (prop) => _build(
          FlexBoxSpecAttribute(
            flex: FlexSpecAttribute.raw(mainAxisAlignment: prop),
          ),
        ),
      );

  late final crossAxisAlignment =
      PropUtility<FlexBoxSpecUtility, CrossAxisAlignment>(
        (prop) => _build(
          FlexBoxSpecAttribute(
            flex: FlexSpecAttribute.raw(crossAxisAlignment: prop),
          ),
        ),
      );

  late final mainAxisSize = PropUtility<FlexBoxSpecUtility, MainAxisSize>(
    (prop) => _build(
      FlexBoxSpecAttribute(flex: FlexSpecAttribute.raw(mainAxisSize: prop)),
    ),
  );

  late final verticalDirection =
      PropUtility<FlexBoxSpecUtility, VerticalDirection>(
        (prop) => _build(
          FlexBoxSpecAttribute(
            flex: FlexSpecAttribute.raw(verticalDirection: prop),
          ),
        ),
      );

  late final flexTextDirection = PropUtility<FlexBoxSpecUtility, TextDirection>(
    (prop) => _build(
      FlexBoxSpecAttribute(flex: FlexSpecAttribute.raw(textDirection: prop)),
    ),
  );

  late final textBaseline = PropUtility<FlexBoxSpecUtility, TextBaseline>(
    (prop) => _build(
      FlexBoxSpecAttribute(flex: FlexSpecAttribute.raw(textBaseline: prop)),
    ),
  );

  late final flexClipBehavior = PropUtility<FlexBoxSpecUtility, Clip>(
    (prop) => _build(
      FlexBoxSpecAttribute(flex: FlexSpecAttribute.raw(clipBehavior: prop)),
    ),
  );

  late final gap = PropUtility<FlexBoxSpecUtility, double>(
    (prop) =>
        _build(FlexBoxSpecAttribute(flex: FlexSpecAttribute.raw(gap: prop))),
  );

  FlexBoxSpecAttribute _baseAttribute;

  FlexBoxSpecUtility([FlexBoxSpecAttribute? attribute])
    : _baseAttribute = attribute ?? const FlexBoxSpecAttribute();

  /// Mutable builder - updates internal state and returns this for cascade
  FlexBoxSpecUtility _build(FlexBoxSpecAttribute newAttribute) {
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  static FlexBoxSpecUtility get self => FlexBoxSpecUtility();

  /// Animation
  FlexBoxSpecUtility animate(AnimationConfig animation) =>
      _build(FlexBoxSpecAttribute(animation: animation));

  // StyleAttribute interface implementation

  @override
  FlexBoxSpecUtility merge(StyleAttribute<FlexBoxSpec>? other) {
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is FlexBoxSpecUtility) {
      return FlexBoxSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is FlexBoxSpecAttribute) {
      return FlexBoxSpecUtility(_baseAttribute.merge(other));
    }

    return FlexBoxSpecUtility(_baseAttribute);
  }

  @override
  FlexBoxSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  FlexBoxSpecAttribute get attribute => _baseAttribute;
}
