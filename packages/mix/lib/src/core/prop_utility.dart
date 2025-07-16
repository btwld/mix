import 'package:flutter/material.dart';

import '../theme/tokens/mix_token.dart';
import 'mix_element.dart';
import 'prop.dart';

/// Base utility for simple value properties that use Prop<T>
///
/// This utility provides a consistent API for working with:
/// - Direct values: call(value)
/// - Tokens: token(token)
/// - Directives: directive(directive)
///
/// Used for simple types like Color, double, FontWeight, etc.
@immutable
abstract class PropUtility<Return extends StyleElement, Value> {
  @protected
  final Return Function(Prop<Value>) builder;
  const PropUtility(this.builder);

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
abstract class MixPropUtility<S extends StyleElement, V, M extends Mix<V>> {
  @protected
  final M Function(V) convertToMix;
  @protected
  final S Function(MixProp<V, M> prop) builder;

  const MixPropUtility(this.builder, {required this.convertToMix});

  /// Direct DTO value
  S call(M dto) => builder(MixProp.value(dto));

  /// Flutter value with auto-conversion to DTO
  S value(V value) => call(convertToMix(value));

  /// Token support with conversion
  S token(MixableToken<V> token) => builder(MixProp.token(token, convertToMix));
}
