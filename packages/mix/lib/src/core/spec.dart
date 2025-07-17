import 'package:flutter/widgets.dart';

import '../internal/compare_mixin.dart';
import 'factory/mix_context.dart';
import 'mix_element.dart';

@immutable
abstract class Spec<T extends Spec<T>> with EqualityMixin {
  const Spec();

  Type get type => T;

  /// Creates a copy of this spec with the given fields
  /// replaced by the non-null parameter values.
  T copyWith();

  /// Linearly interpolate with another [Spec] object.
  T lerp(covariant T? other, double t);
}

@Deprecated(
  'Use SpecMix instead. This class is deprecated and will be removed in future versions.',
)
typedef SpecAttribute<V> = SpecMix<V>;

/// An abstract class representing a resolvable attribute.
///
// This class extends the [Mix] class and provides a generic type [Value].
/// The [Value] type represents the resolvable value.
///
/// SpecAttributes are pure data classes - they contain only attribute-specific fields
/// without cross-cutting concerns like animation or modifiers.
abstract class SpecMix<Value> extends Mix<Value> {
  const SpecMix();

  /// Resolves this attribute to its concrete value using the provided [MixContext].
  @override
  Value resolve(MixContext context);

  /// Merges this attribute with another attribute of the same type.
  @override
  SpecMix<Value> merge(covariant SpecMix<Value>? other);
}

@Deprecated(
  'Use SpecStyle instead. This class is deprecated and will be removed in future versions.',
)
typedef SpecUtility<T extends SpecMix<V>, V> = SpecStyle<T, V>;

/// Base class for creating spec utilities that generate SpecAttributes.
///
/// This class provides a fluent API for building SpecAttributes with a specific
/// value type. It handles the creation and merging of attributes internally.
abstract class SpecStyle<T extends SpecMix<V>, V> extends StyleElement<V, T> {
  const SpecStyle({
    required super.attribute,
    super.variants = const {},
    super.animation,
    super.modifiers,
  });
}
