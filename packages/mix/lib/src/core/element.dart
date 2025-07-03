import 'package:flutter/foundation.dart';

import '../internal/compare_mixin.dart';
import '../theme/tokens/mix_token.dart';
import 'factory/mix_context.dart';
import 'utility.dart';

abstract class StyleElement with EqualityMixin {
  const StyleElement();

  // Used as the key to determine how
  // attributes get merged
  Object get mergeKey => runtimeType;

  /// Merges this object with [other], returning a new object of type [T].
  StyleElement merge(covariant StyleElement? other);
}

// Deprecated typedefs moved to src/core/deprecated.dart

abstract class Mixable<Value> with EqualityMixin {
  /// Optional token for resolving values from the theme
  final MixableToken<Value>? token;

  const Mixable({this.token});

  /// Resolves token value if present, otherwise returns null
  /// Subclasses MUST call super.resolve() and handle the result
  @mustCallSuper
  Value? resolve(MixContext mix) {
    return token != null ? mix.scope.getToken(token!, mix.context) : null;
  }

  /// Merges this mixable with another
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
