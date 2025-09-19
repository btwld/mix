import 'package:flutter/widgets.dart';

import 'internal/compare_mixin.dart';

/// Mixin for types that can be resolved to a value using a [BuildContext].
///
/// Provides the ability to resolve context-dependent values like tokens,
/// responsive properties, or theme-dependent values.
mixin Resolvable<V> {
  /// Resolves this to a concrete value using the provided [context].
  V resolve(BuildContext context);
}

/// Base class for types that can be merged together.
///
/// Provides the ability to combine two instances of the same type,
/// typically used for combining style properties.
abstract class Mixable<T> {
  const Mixable();

  /// The key used to identify compatible types for merging.
  Object get mergeKey => runtimeType;

  /// Merges this instance with [other], with [other] taking precedence.
  Mixable<T> merge(covariant Mixable<T>? other);
}

/// Base class for Mix-compatible styling elements that are both mixable and resolvable.
///
/// Combines the abilities to merge with other instances and resolve to concrete values
/// using a [BuildContext]. This is the foundation for all styling elements in Mix.
abstract class Mix<T> extends Mixable<T> with Resolvable<T>, Equatable {
  const Mix();

  @override
  Mix<T> merge(covariant Mix<T>? other);

  @override
  T resolve(BuildContext context);
}

/// Mixin for types that have default values.
///
/// Provides a way to specify default values that can be used when
/// no explicit value is provided or when resolution returns null.
mixin DefaultValue<Value> {
  /// The default value to use when no explicit value is available.
  @protected
  Value get defaultValue;
}
