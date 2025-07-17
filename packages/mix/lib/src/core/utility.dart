import 'mix_element.dart';
import 'prop_utility.dart';
import 'spec.dart';

abstract class MixUtility<Attr extends SpecAttribute, Value> {
  final Attr Function(Value) builder;

  const MixUtility(this.builder);

  static T selfBuilder<T>(T value) => value;
}

abstract class DtoUtility<A extends SpecAttribute, D extends Mix<Value>, Value>
    extends MixUtility<A, D> {
  final D Function(Value) fromValue;
  const DtoUtility(super.builder, {required D Function(Value) valueToDto})
    : fromValue = valueToDto;

  A only();

  A as(Value value) => builder(fromValue(value));
}

class GenericUtility<Attr extends SpecAttribute, Value>
    extends MixUtility<Attr, Value> {
  const GenericUtility(super.builder);

  Attr call(Value value) => builder(value);
}

base class ListUtility<T extends SpecAttribute, V>
    extends MixUtility<T, List<V>> {
  const ListUtility(super.builder);

  T call(List<V> values) => builder(values);
}

final class StringUtility<T extends SpecAttribute>
    extends PropUtility<T, String> {
  const StringUtility(super.builder);
}

/// A utility class for creating [SpecAttribute] instances from [double] values.
///
/// This class extends [PropUtility] and provides methods to create [SpecAttribute] instances
/// from predefined [double] values or custom [double] values.
final class DoubleUtility<T extends SpecAttribute>
    extends PropUtility<T, double> {
  const DoubleUtility(super.builder);

  /// Creates an [SpecAttribute] instance with a value of 0.
  T zero() => call(0);

  /// Creates an [SpecAttribute] instance with a value of [double.infinity].
  T infinity() => call(double.infinity);
}

/// A utility class for creating [SpecAttribute] instances from [int] values.
///
/// This class extends [PropUtility] and provides methods to create [SpecAttribute] instances
/// from predefined [int] values or custom [int] values.
final class IntUtility<T extends SpecAttribute> extends PropUtility<T, int> {
  const IntUtility(super.builder);

  /// Creates an [SpecAttribute] instance with a value of 0.
  T zero() => call(0);
}

/// A utility class for creating [SpecAttribute] instances from [bool] values.
///
/// This class extends [PropUtility] and provides methods to create [SpecAttribute] instances
/// from predefined [bool] values or custom [bool] values.
final class BoolUtility<T extends SpecAttribute> extends PropUtility<T, bool> {
  const BoolUtility(super.builder);

  /// Creates an [SpecAttribute] instance with a value of `true`.
  T on() => call(true);

  /// Creates an [SpecAttribute] instance with a value of `false`.
  T off() => call(false);
}

/// An abstract utility class for creating [SpecAttribute] instances from [double] values representing sizes.
///
/// This class extends [PropUtility] and serves as a base for more specific sizing utilities.
abstract base class SizingUtility<T extends SpecAttribute>
    extends PropUtility<T, double> {
  const SizingUtility(super.builder);
}
