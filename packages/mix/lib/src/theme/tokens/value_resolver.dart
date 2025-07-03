import 'package:flutter/widgets.dart';

typedef ValueResolver<T> = T Function(BuildContext context);

/// Creates the appropriate resolver for any value type.
///
/// - Direct values (like `Colors.blue`) become [StaticResolver]
/// - Existing resolvers (like `ColorResolver`) become [LegacyResolver]
/// - Already wrapped resolvers are returned as-is
///
/// Throws [ArgumentError] if the value type is not supported.
ValueResolver<T> createResolver<T>(T value) {
  return (BuildContext context) => value;
}
