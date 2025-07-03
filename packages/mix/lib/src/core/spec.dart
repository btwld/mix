import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../attributes/animation/animated_config_dto.dart';
import '../attributes/animation/animation_config.dart';
import '../attributes/modifiers/widget_modifiers_config.dart';
import '../attributes/modifiers/widget_modifiers_config_dto.dart';
import '../internal/compare_mixin.dart';
import 'element.dart';
import 'factory/mix_context.dart';

@immutable
abstract class Spec<T extends Spec<T>> with EqualityMixin {
  final AnimationConfig? animated;

  @MixableField(
    utilities: [MixableFieldUtility(alias: 'wrap')],
    isLerpable: false,
  )
  final WidgetModifiersConfig? modifiers;

  const Spec({this.animated, this.modifiers});

  Type get type => T;

  bool get isAnimated => animated != null;

  /// Creates a copy of this spec with the given fields
  /// replaced by the non-null parameter values.
  T copyWith();

  /// Linearly interpolate with another [Spec] object.
  T lerp(covariant T? other, double t);
}

/// An abstract class representing a resolvable attribute.
///
/// This class extends the [StyleElement] class and provides a generic type [Self] and [Value].
/// The [Self] type represents the concrete implementation of the attribute, while the [Value] type represents the resolvable value.
abstract class SpecAttribute<Value> extends StyleElement
    implements Mixable<Value> {
  final AnimationConfigDto? animated;
  final WidgetModifiersConfigDto? modifiers;

  const SpecAttribute({this.animated, this.modifiers});

  @override
  Value resolve(MixContext mix);

  @override
  SpecAttribute<Value> merge(covariant SpecAttribute<Value>? other);
}
