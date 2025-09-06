import 'package:flutter/material.dart';

import '../theme/tokens/mix_token.dart';
import 'mix_element.dart';
import 'prop.dart';
import 'utility.dart';

/// Base utility for simple value properties that use Prop<T>
///
/// This utility provides a consistent API for working with:
/// - Direct values: call(value)
/// - Tokens: token(token)
/// - Directives: directive(directive)
///
/// Used for simple types like Color, double, FontWeight, etc.
@immutable
class PropUtility<Return extends StyleElement, Value>
    extends MixUtility<Return, Prop<Value>> {
  const PropUtility(super.builder);

  /// Direct value
  Return call(Value value) => builder(Prop.value(value));

  /// Token support
  Return token(MixableToken<Value> token) => builder(Prop.token(token));

  /// Single directive support
  Return directive(MixDirective<Value> directive) =>
      builder(Prop.directives([directive]));

  /// Multiple directives support
  Return directives(List<MixDirective<Value>> directives) =>
      builder(Prop.directives(directives));

  /// Chaining support for adding directives
  PropUtility<Return, Value> withDirective(MixDirective<Value> directive) {
    return PropUtility(
      (prop) => builder(prop.merge(Prop.directives([directive]))),
    );
  }
}

/// Base utility for complex value properties that use MixProp<V, D>
///
/// This utility provides support for:
/// - Direct DTO values: call(dto)
/// - Flutter values with auto-conversion: value(flutterValue)
/// - Tokens with conversion: token(token)
///
/// Used for complex types that need DTOs like EdgeInsets, TextStyle, etc.
@immutable
class MixPropUtility<Return extends StyleElement, V, D extends Mix<V>>
    extends MixUtility<Return, MixProp<V, D>> {
  final D Function(V) _valueToDto;

  const MixPropUtility(super.builder, this._valueToDto);

  /// Direct DTO value
  Return call(D dto) => builder(MixProp.value(dto));

  /// Flutter value with auto-conversion to DTO
  Return value(V value) => call(_valueToDto(value));

  /// Token support with conversion
  Return token(MixableToken<V> token) =>
      builder(MixProp.token(token, _valueToDto));
}
