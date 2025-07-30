import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/prop.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show Style, VariantStyleAttribute;
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
    (prop) => buildProps(alignment: prop),
  );

  late final fit = PropUtility<StackSpecUtility, StackFit>(
    (prop) => buildProps(fit: prop),
  );

  late final textDirection = PropUtility<StackSpecUtility, TextDirection>(
    (prop) => buildProps(textDirection: prop),
  );

  late final clipBehavior = PropUtility<StackSpecUtility, Clip>(
    (prop) => buildProps(clipBehavior: prop),
  );

  late final on = OnContextVariantUtility<StackSpec, StackSpecUtility>(
    (v) => buildProps(variants: [v]),
  );

  late final wrap = ModifierUtility<StackSpecUtility>(
    (prop) => buildProps(modifierConfig: ModifierConfig.modifier(prop)),
  );

  StackMix _baseAttribute;

  StackSpecUtility([StackMix? attribute])
    : _baseAttribute = attribute ?? StackMix();

  @protected
  StackSpecUtility buildProps({
    Prop<AlignmentGeometry>? alignment,
    Prop<StackFit>? fit,
    Prop<TextDirection>? textDirection,
    Prop<Clip>? clipBehavior,
    AnimationConfig? animation,
    ModifierConfig? modifierConfig,
    List<VariantStyleAttribute<StackSpec>>? variants,
  }) {
    final newAttribute = StackMix.raw(
      alignment: alignment,
      fit: fit,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
      animation: animation,
      modifierConfig: modifierConfig,
      variants: variants,
    );
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  /// Animation
  StackSpecUtility animate(AnimationConfig animation) =>
      buildProps(animation: animation);

  // StyleAttribute interface implementation

  @override
  StackSpecUtility merge(Style<StackSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is StackSpecUtility) {
      return StackSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is StackMix) {
      return StackSpecUtility(_baseAttribute.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  StackSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  StackMix get attribute => _baseAttribute;
}
