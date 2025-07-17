import 'package:flutter/material.dart';

import '../attributes/animation/animation_config.dart';
import '../theme/tokens/mix_token.dart';
import 'mix_element.dart';
import 'prop.dart';
import 'spec.dart';

/// Base utility for simple value properties that use Prop<T>
///
/// This utility provides a consistent API for working with:
/// - Direct values: call(value)
/// - Tokens: token(token)
/// - Directives: directive(directive)
///
/// Used for simple types like Color, double, FontWeight, etc.
@immutable
abstract class PropUtility<Return extends SpecAttribute, Value> {
  @protected
  final Return Function(Prop<Value>) builder;
  const PropUtility(this.builder);

  /// Direct value
  Return call(Value value) => builder(Prop.fromValue(value));

  /// Token support
  Return token(MixToken<Value> token) => builder(Prop.fromToken(token));

  /// Single directive support
  Return directive(MixDirective<Value> directive) =>
      builder(Prop.fromDirectives([directive]));

  /// Multiple directives support
  Return directives(List<MixDirective<Value>> directives) =>
      builder(Prop.fromDirectives(directives));

  /// Animation support
  Return animate(AnimationConfig animation) =>
      builder(Prop.fromAnimation(animation));
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
abstract class MixPropUtility<S extends SpecAttribute, M extends Mix<V>, V> {
  @protected
  final M Function(V) convertToMix;

  const MixPropUtility({required this.convertToMix});

  /// Direct DTO value
  S call(M dto) => build(MixProp.fromValue(dto));

  /// Flutter value with auto-conversion to DTO
  S value(V value) => call(convertToMix(value));

  /// Token support with conversion
  S token(MixToken<V> token) => build(MixProp.fromToken(token, convertToMix));

  /// Single directive support
  S directive(MixDirective<M> directive) =>
      build(MixProp.fromDirectives([directive]));

  /// Multiple directives support
  S directives(List<MixDirective<M>> directives) =>
      build(MixProp.fromDirectives(directives));

  /// Animation support
  S animate(AnimationConfig animation) =>
      build(MixProp.fromAnimation(animation));

  S build(MixProp<V, M> prop);
}
