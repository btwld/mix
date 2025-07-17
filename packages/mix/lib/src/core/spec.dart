import 'package:flutter/widgets.dart';

import '../internal/compare_mixin.dart';
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

/// An abstract class representing a resolvable attribute.
///
// This class extends the [Mix] class and provides a generic type [Value].
/// The [Value] type represents the resolvable value.
///
/// SpecAttributes are pure data classes - they contain only attribute-specific fields
/// without cross-cutting concerns like animation or modifiers.
abstract class SpecAttribute<Value> extends Mix<Value> {
  const SpecAttribute();

  /// Resolves this attribute to its concrete value using the provided [BuildContext].
  @override
  Value resolve(BuildContext context);

  /// Merges this attribute with another attribute of the same type.
  @override
  SpecAttribute<Value> merge(covariant SpecAttribute<Value>? other);

  /// Default implementation uses runtimeType as the merge key
  Object get mergeKey => runtimeType;
}

abstract class SpecUtility<T extends SpecAttribute, V> {
  @protected
  @visibleForTesting
  final T Function(V) attributeBuilder;

  T? _attributeValue;

  SpecUtility(this.attributeBuilder);

  static T selfBuilder<T>(T value) => value;

  T? get attributeValue => _attributeValue;

  T builder(V v) {
    final attribute = attributeBuilder(v);
    // Accumulate state in attributeValue
    _attributeValue = _attributeValue?.merge(attribute) as T? ?? attribute;

    return attribute;
  }

  T only();

  SpecUtility<T, V> merge(covariant SpecUtility<T, V> other) {
    if (other._attributeValue != null) {
      _attributeValue =
          _attributeValue?.merge(other._attributeValue) as T? ??
          other._attributeValue;
    }

    return this;
  }

  Object get mergeKey => runtimeType;

  List<Object?> get props => [attributeValue];
}
