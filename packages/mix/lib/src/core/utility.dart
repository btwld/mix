import 'package:meta/meta.dart';

import '../animation/animation_config.dart';
import '../theme/tokens/mix_token.dart';
import 'directive.dart';
import 'mix_element.dart';
import 'prop.dart';
import 'spec.dart';
import 'style.dart';

/// Base class for Mix utilities that convert values to styled elements.
///
/// Utilities provide a fluent API for building styled elements from various value types.
abstract class MixUtility<U extends Style<Object?>, Value> {
  /// The builder function that converts values to styled elements.
  final U Function(Value) builder;

  const MixUtility(this.builder);
}

/// Interface for utilities that work with property-based values.
///
/// Provides common methods for working with tokens, directives, and animations.
abstract interface class PropBaseUtility<U extends Style<Object?>, Value> {
  const PropBaseUtility();

  /// Creates a styled element using a token reference.
  U token(MixToken<Value> token);

  /// Creates a styled element with an applied directive.
  U directive(MixDirective<Value> directive);

  /// Creates a styled element with animation configuration.
  U animate(AnimationConfig animation);
}

/// Base utility for simple value properties that use [Prop<T>]
///
/// This utility provides a consistent API for working with:
/// - Direct values: call(value)
/// - Tokens: token(token)
/// - Directives: directive(directive)
///
/// Used for simple types like Color, double, FontWeight, etc.
@immutable
class PropUtility<U extends Style<Object?>, Value>
    extends PropBaseUtility<U, Value> {
  final U Function(Prop<Value>) builder;
  const PropUtility(this.builder);

  /// Creates a Prop with a direct value
  U call(Value value) => builder(Prop(value));

  /// Token support - creates Prop with token
  @override
  U token(MixToken<Value> token) => builder(Prop.token(token));

  @override
  U directive(MixDirective<Value> directive) {
    return builder(Prop.directives([directive]));
  }

  /// Animation support - creates animated Prop (requires token for now)
  @override
  U animate(AnimationConfig animation) {
    // Note: This creates an animated Prop without a source
    // The actual source will need to be provided later via merge
    return builder(Prop.animation(animation));
  }
}

@immutable
abstract class MixPropUtility<U extends Style<Object?>, Value>
    extends PropBaseUtility<U, Value> {
  final Mix<Value> Function(Value) convertToMix;
  @protected
  final U Function(MixProp<Value>) builder;

  const MixPropUtility(this.builder, {required this.convertToMix});

  /// Creates a MixProp with a Mix value
  U call(covariant Mix<Value> value) => builder(MixProp(value));

  /// Creates a MixProp from a raw value (converts to Mix)
  U as(Value value) => builder(MixProp(convertToMix(value)));

  @Deprecated('use token(value) instead')
  U ref(MixToken<Value> value) => token(value);

  /// Token support - expects `MixToken<Value>` (raw type)
  /// Uses MixProp.token with conversion function
  @override
  U token(MixToken<Value> token) => builder(MixProp.token(token, convertToMix));

  @override
  U directive(MixDirective<Value> directive) {
    return builder(MixProp.directives([directive]));
  }

  /// Animation support - creates animated MixProp
  @override
  U animate(AnimationConfig animation) {
    // Note: This creates an animated MixProp without a source
    // The actual source will need to be provided later via merge
    return builder(MixProp.animation(animation));
  }
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

/// Generic ListUtility for `Prop<V>` lists
///
/// This utility provides a clean approach for working with lists of `Prop<V>`
/// by extending MixUtility and accepting any builder function.
///
/// Usage:
/// ```dart
/// final colorUtil = ColorUtility<TestAttribute>((prop) => TestAttribute(prop));
/// final colorListUtil = colorUtil.list((propList) => TestListAttribute(propList));
/// final attr = colorListUtil([Colors.red, Colors.blue]);
/// ```
@immutable
final class PropListUtility<T extends Style<Object?>, V>
    extends MixUtility<T, List<Prop<V>>> {
  const PropListUtility(super.builder);

  /// Creates a list attribute from a list of values
  /// Each value is wrapped in a `Prop<V>` and passed to the builder
  T call(List<V> values) {
    final propList = values.map((v) => Prop(v)).toList();

    return builder(propList);
  }

  T tokens(List<MixToken<V>> tokens) {
    final propList = tokens.map((t) => Prop.token(t)).toList();

    return builder(propList);
  }
}

/// Generic ListUtility for `MixProp<V>` lists
///
/// This utility provides support for working with lists of `MixProp<V>`
/// for complex types that implement `Mix<V>`.
///
/// Usage:
/// ```dart
/// final boxShadows = MixPropListUtility<TestAttribute, BoxShadow, BoxShadowMix>(
///   (mixPropList) => TestAttribute(boxShadow: mixPropList),
///   BoxShadowMix.value,
/// );
///
/// // Usage with different methods:
/// final attr1 = boxShadows([BoxShadowMix(...), BoxShadowMix(...)]);  // call()
/// final attr2 = boxShadows.as([BoxShadow(...), BoxShadow(...)]);     // as()
/// final attr3 = boxShadows.tokens([token1, token2]);                 // tokens()
/// final attr4 = boxShadows.directives([directive1, directive2]);     // directives()
/// ```
@immutable
final class MixPropListUtility<T extends Style<Object?>, V>
    extends MixUtility<T, List<MixProp<V>>> {
  final Mix<V> Function(V) convertToMix;
  const MixPropListUtility(super.builder, this.convertToMix);

  /// Creates a list attribute from a list of Mix values
  T call(List<Mix<V>> values) {
    final props = values.map((v) => MixProp(v)).toList();

    return builder(props);
  }

  /// Creates a list from raw values (converts to Mix)
  T as(List<V> values) {
    final props = values.map(convertToMix).map((v) => MixProp(v)).toList();

    return builder(props);
  }

  /// Creates a list from tokens that store V (need conversion)
  T tokens(List<MixToken<V>> tokens) {
    final propList = tokens.map((t) => MixProp.token(t, convertToMix)).toList();

    return builder(propList);
  }
}
