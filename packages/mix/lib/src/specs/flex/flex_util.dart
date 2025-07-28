import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant_util.dart';
import 'flex_attribute.dart';
import 'flex_spec.dart';

/// Mutable utility class for flex styling using composition over inheritance.
///
/// Same API as FlexMix but with mutable internal state
/// for cascade notation support: `$flex..direction(Axis.horizontal)..gap(8)`
class FlexSpecUtility extends StyleAttributeBuilder<FlexSpec> {
  // FLEX UTILITIES - Same as FlexMix but return FlexSpecUtility for cascade

  late final direction = PropUtility<FlexSpecUtility, Axis>(
    (prop) => _build(FlexMix.raw(direction: prop)),
  );

  late final mainAxisAlignment =
      PropUtility<FlexSpecUtility, MainAxisAlignment>(
        (prop) => _build(FlexMix.raw(mainAxisAlignment: prop)),
      );

  late final crossAxisAlignment =
      PropUtility<FlexSpecUtility, CrossAxisAlignment>(
        (prop) => _build(FlexMix.raw(crossAxisAlignment: prop)),
      );

  late final mainAxisSize = PropUtility<FlexSpecUtility, MainAxisSize>(
    (prop) => _build(FlexMix.raw(mainAxisSize: prop)),
  );

  late final verticalDirection =
      PropUtility<FlexSpecUtility, VerticalDirection>(
        (prop) => _build(FlexMix.raw(verticalDirection: prop)),
      );

  late final textDirection = PropUtility<FlexSpecUtility, TextDirection>(
    (prop) => _build(FlexMix.raw(textDirection: prop)),
  );

  late final textBaseline = PropUtility<FlexSpecUtility, TextBaseline>(
    (prop) => _build(FlexMix.raw(textBaseline: prop)),
  );

  late final clipBehavior = PropUtility<FlexSpecUtility, Clip>(
    (prop) => _build(FlexMix.raw(clipBehavior: prop)),
  );

  late final gap = PropUtility<FlexSpecUtility, double>(
    (prop) => _build(FlexMix.raw(gap: prop)),
  );

  late final on = OnContextVariantUtility<FlexSpec, FlexSpecUtility>(
    (v) => _build(FlexMix(variants: [v])),
  );

  late final wrap = ModifierUtility<FlexSpecUtility>(
    (prop) => _build(FlexMix(modifiers: [prop])),
  );

  FlexMix _baseAttribute;

  FlexSpecUtility([FlexMix? attribute])
    : _baseAttribute = attribute ?? FlexMix(),
      super();

  /// Mutable builder - updates internal state and returns this for cascade
  FlexSpecUtility _build(FlexMix newAttribute) {
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  // Convenience methods
  FlexSpecUtility row() => _build(FlexMix(direction: Axis.horizontal));
  FlexSpecUtility column() => _build(FlexMix(direction: Axis.vertical));

  /// Animation
  FlexSpecUtility animate(AnimationConfig animation) =>
      _build(FlexMix(animation: animation));

  // StyleAttribute interface implementation

  @override
  FlexSpecUtility merge(Style<FlexSpec>? other) {
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is FlexSpecUtility) {
      return FlexSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is FlexMix) {
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
  FlexMix get attribute => _baseAttribute;
}
