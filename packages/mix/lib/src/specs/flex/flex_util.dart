import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show StyleAttribute;
import '../../core/utility.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant_util.dart';
import 'flex_attribute.dart';
import 'flex_spec.dart';

/// Mutable utility class for flex styling using composition over inheritance.
///
/// Same API as FlexSpecAttribute but with mutable internal state
/// for cascade notation support: `$flex..direction(Axis.horizontal)..gap(8)`
class FlexSpecUtility extends StyleAttributeBuilder<FlexSpec> {
  // FLEX UTILITIES - Same as FlexSpecAttribute but return FlexSpecUtility for cascade

  late final direction = PropUtility<FlexSpecUtility, Axis>(
    (prop) => _build(FlexSpecAttribute.raw(direction: prop)),
  );

  late final mainAxisAlignment =
      PropUtility<FlexSpecUtility, MainAxisAlignment>(
        (prop) => _build(FlexSpecAttribute.raw(mainAxisAlignment: prop)),
      );

  late final crossAxisAlignment =
      PropUtility<FlexSpecUtility, CrossAxisAlignment>(
        (prop) => _build(FlexSpecAttribute.raw(crossAxisAlignment: prop)),
      );

  late final mainAxisSize = PropUtility<FlexSpecUtility, MainAxisSize>(
    (prop) => _build(FlexSpecAttribute.raw(mainAxisSize: prop)),
  );

  late final verticalDirection =
      PropUtility<FlexSpecUtility, VerticalDirection>(
        (prop) => _build(FlexSpecAttribute.raw(verticalDirection: prop)),
      );

  late final textDirection = PropUtility<FlexSpecUtility, TextDirection>(
    (prop) => _build(FlexSpecAttribute.raw(textDirection: prop)),
  );

  late final textBaseline = PropUtility<FlexSpecUtility, TextBaseline>(
    (prop) => _build(FlexSpecAttribute.raw(textBaseline: prop)),
  );

  late final clipBehavior = PropUtility<FlexSpecUtility, Clip>(
    (prop) => _build(FlexSpecAttribute.raw(clipBehavior: prop)),
  );

  late final gap = PropUtility<FlexSpecUtility, double>(
    (prop) => _build(FlexSpecAttribute.raw(gap: prop)),
  );

  late final on = OnContextVariantUtility<FlexSpec, FlexSpecUtility>(
    (v) => _build(FlexSpecAttribute(variants: [v])),
  );

  late final wrap = ModifierUtility<FlexSpecUtility>(
    (prop) => _build(FlexSpecAttribute(modifiers: [prop])),
  );

  FlexSpecAttribute _baseAttribute;

  FlexSpecUtility([FlexSpecAttribute? attribute])
    : _baseAttribute = attribute ?? FlexSpecAttribute(),
      super();

  /// Mutable builder - updates internal state and returns this for cascade
  FlexSpecUtility _build(FlexSpecAttribute newAttribute) {
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  // Convenience methods
  FlexSpecUtility row() =>
      _build(FlexSpecAttribute(direction: Axis.horizontal));
  FlexSpecUtility column() =>
      _build(FlexSpecAttribute(direction: Axis.vertical));

  /// Animation
  FlexSpecUtility animate(AnimationConfig animation) =>
      _build(FlexSpecAttribute(animation: animation));

  // StyleAttribute interface implementation

  @override
  FlexSpecUtility merge(StyleAttribute<FlexSpec>? other) {
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is FlexSpecUtility) {
      return FlexSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is FlexSpecAttribute) {
      return FlexSpecUtility(_baseAttribute.merge(other));
    }

    return FlexSpecUtility(_baseAttribute);
  }

  @override
  FlexSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  FlexSpecAttribute get attribute => _baseAttribute;
}
