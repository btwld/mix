import 'package:meta/meta.dart';

import 'attribute.dart';
import 'mix_element.dart';
import 'prop_utility.dart';

abstract class MixUtility<Attr extends Attribute, Value> {
  final Attr Function(Value) builder;

  const MixUtility(this.builder);

  static T selfBuilder<T>(T value) => value;
}

abstract class DtoUtility<A extends Attribute, D extends Mix<Value>, Value>
    extends MixUtility<A, D> {
  final D Function(Value) fromValue;
  const DtoUtility(super.builder, {required D Function(Value) valueToDto})
    : fromValue = valueToDto;

  A only();

  A as(Value value) => builder(fromValue(value));
}

/// Utility base class for spec utilities
abstract class SpecUtility<T extends Attribute, V> {
  @protected
  @visibleForTesting
  final T Function(V) attributeBuilder;

  T? _attributeValue;

  SpecUtility(this.attributeBuilder);

  static T selfBuilder<T>(T value) => value;

  T? get attributeValue => _attributeValue;

  Object get mergeKey => runtimeType;

  List<Object?> get props => [attributeValue];

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
          _attributeValue?.merge(other._attributeValue!) as T? ??
          other._attributeValue;
    }

    return this;
  }
}

class GenericUtility<Attr extends Attribute, Value>
    extends MixUtility<Attr, Value> {
  const GenericUtility(super.builder);

  Attr call(Value value) => builder(value);
}

base class ListUtility<T extends Attribute, V> extends MixUtility<T, List<V>> {
  const ListUtility(super.builder);

  T call(List<V> values) => builder(values);
}

final class StringUtility<T extends Attribute> extends PropUtility<T, String> {
  const StringUtility(super.builder);
}

/// A utility class for creating [Attribute] instances from [double] values.
///
/// This class extends [PropUtility] and provides methods to create [Attribute] instances
/// from predefined [double] values or custom [double] values.
final class DoubleUtility<T extends Attribute> extends PropUtility<T, double> {
  const DoubleUtility(super.builder);

  /// Creates an [Attribute] instance with a value of 0.
  T zero() => call(0);

  /// Creates an [Attribute] instance with a value of [double.infinity].
  T infinity() => call(double.infinity);
}

/// A utility class for creating [Attribute] instances from [int] values.
///
/// This class extends [PropUtility] and provides methods to create [Attribute] instances
/// from predefined [int] values or custom [int] values.
final class IntUtility<T extends Attribute> extends PropUtility<T, int> {
  const IntUtility(super.builder);

  /// Creates an [Attribute] instance with a value of 0.
  T zero() => call(0);
}

/// A utility class for creating [Attribute] instances from [bool] values.
///
/// This class extends [PropUtility] and provides methods to create [Attribute] instances
/// from predefined [bool] values or custom [bool] values.
final class BoolUtility<T extends Attribute> extends PropUtility<T, bool> {
  const BoolUtility(super.builder);

  /// Creates an [Attribute] instance with a value of `true`.
  T on() => call(true);

  /// Creates an [Attribute] instance with a value of `false`.
  T off() => call(false);
}

/// An abstract utility class for creating [Attribute] instances from [double] values representing sizes.
///
/// This class extends [PropUtility] and serves as a base for more specific sizing utilities.
abstract base class SizingUtility<T extends Attribute>
    extends PropUtility<T, double> {
  const SizingUtility(super.builder);
}
