import 'package:meta/meta.dart';

import '../theme/tokens/mix_token.dart';
import 'animation_config.dart';
import 'attribute.dart';
import 'mix_element.dart';
import 'prop.dart';
import 'spec.dart';

abstract class MixUtility<U extends SpecUtility<Object?>, Value> {
  final U Function(Value) builder;

  const MixUtility(this.builder);
}

abstract interface class PropBaseUtility<
  U extends SpecUtility<Object?>,
  Value
> {
  const PropBaseUtility();

  U token(MixToken<Value> token);

  U directive(MixDirective<Value> directive);

  U animate(AnimationConfig animation);
}

/// Base utility for simple value properties that use Prop<T>
///
/// This utility provides a consistent API for working with:
/// - Direct values: call(value)
/// - Tokens: token(token)
/// - Directives: directive(directive)
///
/// Used for simple types like Color, double, FontWeight, etc.
@immutable
abstract class PropUtility<U extends SpecUtility<Object?>, Value>
    extends PropBaseUtility<U, Value> {
  final U Function(Prop<Value>) builder;
  const PropUtility(this.builder);

  U call(Value value) => builder(Prop(value));

  /// Token support
  @override
  U token(MixToken<Value> token) => builder(Prop.token(token));

  /// Single directive support
  @override
  U directive(MixDirective<Value> directive) =>
      builder(Prop.directives([directive]));

  /// Animation support
  @override
  U animate(AnimationConfig animation) => builder(Prop.animation(animation));
}

@immutable
abstract class MixPropUtility<U extends SpecUtility<Object?>, Value>
    extends PropBaseUtility<U, Value> {
  final Mixable<Value> Function(Value) valueToMix;
  @protected
  final U Function(MixProp<Value>) builder;

  const MixPropUtility(this.builder, {required this.valueToMix});

  U call(covariant Mixable<Value> value);

  U as(Value value) => call(valueToMix(value));

  @override
  U token(MixToken<Value> token) => builder(MixProp.token(token, valueToMix));

  @override
  U directive(MixDirective<Value> directive) =>
      builder(MixProp.directives([directive]));

  @override
  U animate(AnimationConfig animation) => builder(MixProp.animation(animation));
}

/// Utility base class for spec utilities
abstract class SpecUtility<S extends Spec<S>> {
  const SpecUtility();

  SpecAttribute<S>? get attribute;

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! SpecUtility<S>) return false;

    return attribute == other.attribute;
  }

  @override
  int get hashCode => Object.hash(attribute, runtimeType);
}
