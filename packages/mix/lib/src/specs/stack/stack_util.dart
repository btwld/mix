import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart'
    show StyleAttribute, VariantStyleAttribute, ModifierAttribute;
import '../../core/utility.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant_util.dart';
import 'stack_attribute.dart';
import 'stack_spec.dart';

/// Mutable utility class for stack styling using composition over inheritance.
///
/// Same API as StackSpecAttribute but with mutable internal state
/// for cascade notation support: `$stack..alignment(Alignment.center)..fit(StackFit.expand)`
class StackSpecUtility extends StyleAttributeBuilder<StackSpec> {
  // STACK UTILITIES - Same as StackSpecAttribute but return StackSpecUtility for cascade

  late final alignment = PropUtility<StackSpecUtility, AlignmentGeometry>(
    (prop) => _build(StackSpecAttribute(alignment: prop)),
  );

  late final fit = PropUtility<StackSpecUtility, StackFit>(
    (prop) => _build(StackSpecAttribute(fit: prop)),
  );

  late final textDirection = PropUtility<StackSpecUtility, TextDirection>(
    (prop) => _build(StackSpecAttribute(textDirection: prop)),
  );

  late final clipBehavior = PropUtility<StackSpecUtility, Clip>(
    (prop) => _build(StackSpecAttribute(clipBehavior: prop)),
  );

  late final on = OnContextVariantUtility<StackSpec, StackSpecUtility>(
    (v) => _build(StackSpecAttribute(variants: [v])),
  );

  late final wrap = ModifierUtility<StackSpecUtility>(
    (prop) => _build(StackSpecAttribute(modifiers: [prop])),
  );

  StackSpecAttribute _baseAttribute;

  StackSpecUtility([StackSpecAttribute? attribute])
    : _baseAttribute = attribute ?? StackSpecAttribute(),
      super();

  /// Mutable builder - updates internal state and returns this for cascade
  StackSpecUtility _build(StackSpecAttribute newAttribute) {
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  /// Animation
  StackSpecUtility animate(AnimationConfig animation) =>
      _build(StackSpecAttribute(animation: animation));

  // StyleAttribute interface implementation

  @override
  StackSpecUtility merge(StyleAttribute<StackSpec>? other) {
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is StackSpecUtility) {
      return StackSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is StackSpecAttribute) {
      return StackSpecUtility(_baseAttribute.merge(other));
    }

    return StackSpecUtility(_baseAttribute);
  }

  @override
  StackSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }


  /// Access to internal attribute
  @override
  StackSpecAttribute get attribute => _baseAttribute;
}
