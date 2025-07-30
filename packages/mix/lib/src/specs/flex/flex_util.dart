import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/prop.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show Style, VariantStyleAttribute;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
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
    (prop) => buildProps(direction: prop),
  );

  late final mainAxisAlignment =
      PropUtility<FlexSpecUtility, MainAxisAlignment>(
        (prop) => buildProps(mainAxisAlignment: prop),
      );

  late final crossAxisAlignment =
      PropUtility<FlexSpecUtility, CrossAxisAlignment>(
        (prop) => buildProps(crossAxisAlignment: prop),
      );

  late final mainAxisSize = PropUtility<FlexSpecUtility, MainAxisSize>(
    (prop) => buildProps(mainAxisSize: prop),
  );

  late final verticalDirection =
      PropUtility<FlexSpecUtility, VerticalDirection>(
        (prop) => buildProps(verticalDirection: prop),
      );

  late final textDirection = PropUtility<FlexSpecUtility, TextDirection>(
    (prop) => buildProps(textDirection: prop),
  );

  late final textBaseline = PropUtility<FlexSpecUtility, TextBaseline>(
    (prop) => buildProps(textBaseline: prop),
  );

  late final clipBehavior = PropUtility<FlexSpecUtility, Clip>(
    (prop) => buildProps(clipBehavior: prop),
  );

  late final gap = PropUtility<FlexSpecUtility, double>(
    (prop) => buildProps(gap: prop),
  );

  late final on = OnContextVariantUtility<FlexSpec, FlexSpecUtility>(
    (v) => buildProps(variants: [v]),
  );

  late final wrap = ModifierUtility<FlexSpecUtility>(
    (prop) => buildProps(modifierConfig: ModifierConfig.modifier(prop)),
  );

  FlexMix _baseAttribute;

  FlexSpecUtility([FlexMix? attribute])
    : _baseAttribute = attribute ?? FlexMix();

  @protected
  FlexSpecUtility buildProps({
    Prop<Axis>? direction,
    Prop<MainAxisAlignment>? mainAxisAlignment,
    Prop<CrossAxisAlignment>? crossAxisAlignment,
    Prop<MainAxisSize>? mainAxisSize,
    Prop<VerticalDirection>? verticalDirection,
    Prop<TextDirection>? textDirection,
    Prop<TextBaseline>? textBaseline,
    Prop<Clip>? clipBehavior,
    Prop<double>? gap,
    AnimationConfig? animation,
    ModifierConfig? modifierConfig,
    List<VariantStyleAttribute<FlexSpec>>? variants,
  }) {
    final newAttribute = FlexMix.raw(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      gap: gap,
      animation: animation,
      modifierConfig: modifierConfig,
      variants: variants,
    );
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  // Convenience methods
  FlexSpecUtility row() => buildProps(direction: Prop(Axis.horizontal));
  FlexSpecUtility column() => buildProps(direction: Prop(Axis.vertical));

  /// Animation
  FlexSpecUtility animate(AnimationConfig animation) =>
      buildProps(animation: animation);

  // StyleAttribute interface implementation

  @override
  FlexSpecUtility merge(Style<FlexSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is FlexSpecUtility) {
      return FlexSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is FlexMix) {
      return FlexSpecUtility(_baseAttribute.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  FlexSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  FlexMix get attribute => _baseAttribute;
}
