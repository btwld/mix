import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant_util.dart';
import 'stack_attribute.dart';
import 'stack_spec.dart';

/// Mutable utility class for stack styling using composition over inheritance.
///
/// Same API as StackMix but with mutable internal state
/// for cascade notation support: `$stack..alignment(Alignment.center)..fit(StackFit.expand)`
class StackSpecUtility extends StyleAttributeBuilder<StackSpec> {
  // STACK UTILITIES - Same as StackMix but return StackSpecUtility for cascade

  late final alignment = PropUtility<StackSpecUtility, AlignmentGeometry>(
    (prop) => _build(StackMix.raw(alignment: prop)),
  );

  late final fit = PropUtility<StackSpecUtility, StackFit>(
    (prop) => _build(StackMix.raw(fit: prop)),
  );

  late final textDirection = PropUtility<StackSpecUtility, TextDirection>(
    (prop) => _build(StackMix.raw(textDirection: prop)),
  );

  late final clipBehavior = PropUtility<StackSpecUtility, Clip>(
    (prop) => _build(StackMix.raw(clipBehavior: prop)),
  );

  late final on = OnContextVariantUtility<StackSpec, StackSpecUtility>(
    (v) => _build(StackMix(variants: [v])),
  );

  late final wrap = ModifierUtility<StackSpecUtility>(
    (prop) => _build(StackMix(modifierConfig: ModifierConfig.modifier(prop))),
  );

  StackMix _baseAttribute;

  StackSpecUtility([StackMix? attribute])
    : _baseAttribute = attribute ?? StackMix(),
      super();

  /// Mutable builder - updates internal state and returns this for cascade
  StackSpecUtility _build(StackMix newAttribute) {
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  /// Animation
  StackSpecUtility animate(AnimationConfig animation) =>
      _build(StackMix(animation: animation));

  // StyleAttribute interface implementation

  @override
  StackSpecUtility merge(Style<StackSpec>? other) {
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is StackSpecUtility) {
      return StackSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is StackMix) {
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
  StackMix get attribute => _baseAttribute;
}
