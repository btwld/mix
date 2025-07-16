import 'package:flutter/widgets.dart';

import '../attributes/modifiers/widget_modifiers_config.dart';
import '../attributes/modifiers/widget_modifiers_config_dto.dart';
import '../internal/compare_mixin.dart';
import 'factory/mix_context.dart';
import 'mix_element.dart';

@immutable
abstract class Spec<T extends Spec<T>> with EqualityMixin {
  final WidgetModifiersConfig? modifiers;

  const Spec({this.modifiers});

  Type get type => T;

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
abstract class SpecAttribute<Value> extends StyleElement implements Mix<Value> {
  final WidgetModifiersConfigDto? modifiers;
  const SpecAttribute({this.modifiers});

  /// Resolves this attribute to its concrete value using the provided [MixContext].
  @override
  Value resolve(MixContext context);

  /// Merges this attribute with another attribute of the same type.
  @override
  SpecAttribute<Value> merge(covariant SpecAttribute<Value>? other);
}
