import 'package:flutter/widgets.dart';

import 'mix_token.dart';

/// Interface for resolving token values using BuildContext.
///
/// This replaces the old pattern of runtime type checking. All token values
/// (direct values, resolvers, etc.) implement this interface.
abstract class ValueResolver<T> {
  /// Resolves this value using the given [context].
  T resolve(BuildContext context);
}

/// A resolver that wraps a static value.
///
/// Used for concrete values like `Colors.blue` or `16.0` that don't need
/// context-dependent resolution.
class StaticResolver<T> implements ValueResolver<T> {
  final T value;

  const StaticResolver(this.value);

  @override
  T resolve(BuildContext context) => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaticResolver<T> && other.value == value);

  @override
  String toString() => 'StaticResolver<$T>($value)';

  @override
  int get hashCode => value.hashCode;
}

/// Adapter for existing resolver implementations.
///
/// Wraps objects that implement [WithTokenResolver] (like [ColorResolver],
/// [RadiusResolver], etc.) to work with the unified resolver system.
class LegacyResolver<T> implements ValueResolver<T> {
  final WithTokenResolver<T> legacyResolver;

  const LegacyResolver(this.legacyResolver);

  @override
  T resolve(BuildContext context) => legacyResolver.resolve(context);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyResolver<T> && other.legacyResolver == legacyResolver);

  @override
  String toString() => 'LegacyResolver<$T>($legacyResolver)';

  @override
  int get hashCode => legacyResolver.hashCode;
}

/// Creates the appropriate resolver for any value type.
///
/// - Direct values (like `Colors.blue`) become [StaticResolver]
/// - Existing resolvers (like `ColorResolver`) become [LegacyResolver]
/// - Already wrapped resolvers are returned as-is
///
/// Throws [ArgumentError] if the value type is not supported.
ValueResolver<T> createResolver<T>(dynamic value) {
  // Direct value
  if (value is T) {
    return StaticResolver<T>(value);
  }

  // Existing resolver pattern
  if (value is WithTokenResolver<T>) {
    return LegacyResolver<T>(value);
  }

  // Already a resolver
  if (value is ValueResolver<T>) {
    return value;
  }

  throw ArgumentError.value(
    value,
    'value',
    'Cannot create ValueResolver<$T> for type ${value.runtimeType}',
  );
}
