import 'package:flutter/widgets.dart';

mixin Resolvable<V> {
  V resolve(BuildContext context);
}

mixin Mergeable {
  /// Merges this instance with another instance of the same type.
  ///
  /// If [other] is null, returns this instance unchanged.
  /// Otherwise, returns a new instance with properties from [other] taking precedence.
  Mergeable merge(covariant Mergeable? other);
}

mixin Mixable<T> implements Mergeable, Resolvable<T> {
  /// Merges this instance with another instance of the same type.
  ///
  /// If [other] is null, returns this instance unchanged.
  /// Otherwise, returns a new instance with properties from [other] taking precedence.
  @override
  Mixable<T> merge(covariant Mixable<T>? other);
}

/// Merge strategy for lists
enum ListMergeStrategy {
  /// Append items from other list (default)
  append,

  /// Replace items at same index
  replace,

  /// Override entire list
  override,
}

abstract class Mix<T> with Mixable<T> {
  const Mix();

  @override
  Mix<T> merge(covariant Mix<T>? other);
}

// Define a mixin for properties that have default values
// TODO: Rename this to DefaultValueMixin or similar
mixin MixDefaultValue<Value> on Mix<Value> {
  @protected
  Value get defaultValue;
}
