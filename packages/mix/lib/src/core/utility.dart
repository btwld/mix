import 'spec.dart';
import 'style.dart';

/// Base class for Mix utilities that convert values to styled elements.
///
/// Utilities provide a fluent API for building styled elements from various value types.
class MixUtility<S extends Style<Object?>, Value> {
  /// The builder function that converts values to styled elements.
  final S Function(Value) builder;

  const MixUtility(this.builder);
}


/// Utility base class for spec utilities
abstract class SpecUtility<S extends Spec<S>> {
  const SpecUtility();

  Style<S>? get attribute;

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! SpecUtility<S>) return false;

    return attribute == other.attribute;
  }

  @override
  int get hashCode => Object.hash(attribute, runtimeType);
}
