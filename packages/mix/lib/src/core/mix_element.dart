import 'package:flutter/widgets.dart';

import '../internal/compare_mixin.dart';
import 'helpers.dart';

// Generic directive for modifying values
@immutable
abstract class MixDirective<T> {
  const MixDirective();

  /// Debug label for the directive
  String? get debugLabel;

  /// Applies the transformation to the given value
  T apply(T value);
}

mixin Resolvable<T> {
  /// Resolves the current instance to a [T] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final resolved = instance.resolve(mix);
  /// ```
  T resolve(BuildContext context);
}

mixin Mergeable {
  /// Merges this instance with another instance of the same type.
  ///
  /// If [other] is null, returns this instance unchanged.
  /// Otherwise, returns a new instance with properties from [other] taking precedence.
  Mergeable merge(covariant Mergeable? other);
}

/// Simple value Mix - holds a direct value
@immutable
abstract class Mix<T> with EqualityMixin, MixHelperMixin {
  const Mix();

  /// Resolves to the concrete value using the provided context
  T resolve(BuildContext context);

  /// Merges this mix with another mix, returning a new mix.
  Mix<T> merge(covariant Mix<T>? other);
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

// Define a mixin for properties that have default values
// TODO: Rename this to DefaultValueMixin or similar
mixin HasDefaultValue<Value> {
  @protected
  Value get defaultValue;
}
