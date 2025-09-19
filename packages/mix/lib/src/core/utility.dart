import 'style.dart';

/// Base class for Mix utilities that convert values to styled elements.
///
/// Utilities provide a fluent API for building styled elements from various value types.
class MixUtility<S extends Style<Object?>, Value> {
  /// The utilityBuilder function that converts values to styled elements.
  final S Function(Value) utilityBuilder;

  const MixUtility(this.utilityBuilder);
}
