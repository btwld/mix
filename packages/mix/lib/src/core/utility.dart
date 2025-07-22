import 'package:meta/meta.dart';

import '../theme/tokens/mix_token.dart';
import 'animation_config.dart';
import 'directive.dart';
import 'mix_element.dart';
import 'prop.dart';
import 'spec.dart';
import 'style.dart';

abstract class MixUtility<U extends SpecStyle<Object?>, Value> {
  final U Function(Value) builder;

  const MixUtility(this.builder);
}

abstract interface class PropBaseUtility<U extends SpecStyle<Object?>, Value> {
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
abstract class PropUtility<U extends SpecStyle<Object?>, Value>
    extends PropBaseUtility<U, Value> {
  final U Function(Prop<Value>) builder;
  const PropUtility(this.builder);

  U call(Value value) => builder(Prop(value));

  /// Creates a list utility that can work with lists of this utility's value type
  ///
  /// Usage:
  /// ```dart
  /// final colorUtil = ColorUtility<TestAttribute>((prop) => TestAttribute(prop));
  /// final colorListUtil = colorUtil.list((propList) => TestListAttribute(propList));
  /// final attr = colorListUtil([Colors.red, Colors.blue]);
  /// ```
  PropListUtility<U, Value> list(U Function(List<Prop<Value>>) listBuilder) {
    return PropListUtility(listBuilder);
  }

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
abstract class MixPropUtility<U extends SpecStyle<Object?>, Value>
    extends PropBaseUtility<U, Mix<Value>> {
  final Mix<Value> Function(Value) convertToMix;
  @protected
  final U Function(MixProp<Value>) builder;

  const MixPropUtility(this.builder, {required this.convertToMix});

  U call(covariant Mix<Value> value);

  U as(Value value) => call(convertToMix(value));

  @override
  U token(MixToken<Mix<Value>> token) => builder(Prop.token(token));

  @override
  U directive(MixDirective<Mix<Value>> directive) =>
      builder(Prop.directives([directive]));

  @override
  U animate(AnimationConfig animation) => builder(Prop.animation(animation));
}

/// Utility base class for spec utilities
abstract class SpecUtility<S extends Spec<S>> {
  const SpecUtility();

  SpecStyle<S>? get attribute;

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! SpecUtility<S>) return false;

    return attribute == other.attribute;
  }

  @override
  int get hashCode => Object.hash(attribute, runtimeType);
}

/// Generic ListUtility for Prop<V> lists
///
/// This utility provides a clean approach for working with lists of Prop<V>
/// by extending MixUtility and accepting any builder function.
///
/// Usage:
/// ```dart
/// final colorUtil = ColorUtility<TestAttribute>((prop) => TestAttribute(prop));
/// final colorListUtil = colorUtil.list((propList) => TestListAttribute(propList));
/// final attr = colorListUtil([Colors.red, Colors.blue]);
/// ```
@immutable
final class PropListUtility<T extends SpecStyle<Object?>, V>
    extends MixUtility<T, List<Prop<V>>> {
  const PropListUtility(super.builder);

  /// Creates a list attribute from a list of values
  /// Each value is wrapped in a Prop<V> and passed to the builder
  T call(List<V> values) {
    final propList = values.map(Prop.new).toList();

    return builder(propList);
  }

  T tokens(List<MixToken<V>> tokens) {
    final propList = tokens.map(Prop.token).toList();

    return builder(propList);
  }

  T directives(List<MixDirective<V>> directives) {
    final propList = directives
        .map((directive) => Prop.directives([directive]))
        .toList();

    return builder(propList);
  }
}

/// Generic ListUtility for MixProp<V> lists
///
/// This utility provides support for working with lists of MixProp<V>
/// for complex types that implement Mix<V>.
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
final class MixPropListUtility<
  T extends SpecStyle<Object?>,
  V,
  M extends Mix<V>
>
    extends MixUtility<T, List<Prop<M>>> {
  final M Function(V) convertToMix;
  const MixPropListUtility(super.builder, this.convertToMix);

  /// Creates a list attribute from a list of values
  /// Each value is converted to Mixable<V> then wrapped in MixProp<V>
  T call(List<M> values) {
    final props = values.map(Prop.new).toList();

    return builder(props);
  }

  T as(List<V> values) {
    final props = values.map(convertToMix).map(Prop.new).toList();

    return builder(props);
  }

  T tokens(List<MixToken<M>> tokens) {
    final propList = tokens.map((t) => Prop.token(t)).toList();

    return builder(propList);
  }

  T directives(List<MixDirective<M>> directives) {
    final propList = directives
        .map((directive) => Prop.directives([directive]))
        .toList();

    return builder(propList);
  }
}
