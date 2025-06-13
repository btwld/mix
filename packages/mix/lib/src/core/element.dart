import 'package:flutter/foundation.dart';

import '../internal/compare_mixin.dart';
import 'factory/mix_data.dart';
import 'spec.dart';
import 'utility.dart';

abstract class StyleElement with EqualityMixin {
  const StyleElement();

  // Used as the key to determine how
  // attributes get merged
  Object get mergeKey => runtimeType;

  /// Merges this object with [other], returning a new object of type [T].
  StyleElement merge(covariant StyleElement? other);
}

@Deprecated('Use StyleElement instead')
typedef Attribute = StyleElement;

@Deprecated('Use StyleAttribute instead')
typedef StyledAttribute = SpecAttribute;

@Deprecated('Use Mixable instead')
typedef Dto<Value> = Mixable<Value>;

abstract class Mixable<Value> with EqualityMixin {
  const Mixable();

  Value resolve(MixContext mix);
  Mixable<Value> merge(covariant Mixable<Value>? other);
}

// Define a mixin for properties that have default values
mixin HasDefaultValue<Value> {
  @protected
  Value get defaultValue;
}

abstract class DtoUtility<A extends StyleElement, D extends Mixable<Value>,
    Value> extends MixUtility<A, D> {
  final D Function(Value) _fromValue;
  const DtoUtility(super.builder, {required D Function(Value) valueToDto})
      : _fromValue = valueToDto;

  A only();

  A as(Value value) => builder(_fromValue(value));
}

// /// Provides the ability to merge this object with another of the same type.
// ///
// /// Defines a single method, [merge], which takes another object of type [T]
// /// and returns a new object representing the merged result.
// ///
// /// Typically used by classes like [MixableDto] or [StyleAttribute] that need to merge
// /// instances of the same type.
// mixin MergeableMixin<T> {
//   /// Merges this object with [other], returning a new object of type [T].
//   T merge(covariant T? other);
//   // Used as the key to determine how
//   // attributes get merged
//   Object get mergeKey => runtimeType;
// }
