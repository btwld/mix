import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../theme/tokens/mix_token.dart';
import 'helpers.dart';
import 'mix_element.dart';
import 'modifier.dart';
import 'prop_source.dart';

// ====== Prop Types ======

/// Base class for property values that can be resolved and merged.
///
/// Properties are the foundation of the Mix system, providing value resolution,
/// merging capabilities, modifier application, and animation support.
@immutable
sealed class PropBase<V> {
  /// Modifiers to apply to the resolved value
  final List<Modifier<V>>? $modifiers;

  /// Animation configuration for this property
  final AnimationConfig? $animation;

  const PropBase({List<Modifier<V>>? modifiers, AnimationConfig? animation})
    : $modifiers = modifiers,
      $animation = animation;

  Type get type => V;

  bool get hasToken;

  PropBase<V> mergeProp(covariant PropBase<V>? other);

  /// Resolves the property value using the provided context
  V resolveProp(BuildContext context);
}

/// Prop for regular types - uses replacement merge strategy
@immutable
class Prop<V> extends PropBase<V> {
  final V? $value;
  final MixToken<V>? $token;

  @protected
  const Prop({V? value, MixToken<V>? token, super.modifiers, super.animation})
    : $value = value,
      $token = token;

  const Prop.token(
    MixToken<V> token, {
    List<Modifier<V>>? modifiers,
    AnimationConfig? animation,
  }) : this(token: token, modifiers: modifiers, animation: animation);

  Prop.fromProp(Prop<V> other)
    : this(
        value: other.$value,
        token: other.$token,
        modifiers: other.$modifiers,
        animation: other.$animation,
      );

  const Prop.modifiers(
    List<Modifier<V>> modifiers, {
    AnimationConfig? animation,
  }) : this(modifiers: modifiers, animation: animation);

  const Prop.animation(AnimationConfig animation)
    : this(modifiers: null, animation: animation);

  static Prop<V> value<V>(V value) {
    if (value is Prop<V>) return value;

    return Prop(value: value);
  }

  static Prop<V>? maybe<V>(V? value) {
    if (value == null) return null;

    return Prop.value(value);
  }

  // Helper methods for Prop
  bool get hasValue => $value != null;

  Prop<V> modifiers(List<Modifier<V>> modifiers) {
    return mergeProp(Prop.modifiers(modifiers));
  }

  Prop<V> animation(AnimationConfig animation) {
    return mergeProp(Prop.animation(animation));
  }

  @override
  Prop<V> mergeProp(covariant Prop<V>? other) {
    return PropOps.merge(this, other);
  }

  @override
  V resolveProp(BuildContext context) {
    return PropOps.resolve(this, context);
  }

  @override
  String toString() {
    final parts = <String>[];
    if ($token != null) {
      parts.add('token: ${$token!.name}');
    } else {
      parts.add('value: ${$value ?? 'null'}');
    }
    if ($modifiers != null && $modifiers!.isNotEmpty) {
      parts.add('modifiers: ${$modifiers!.length}');
    }
    if ($animation != null) parts.add('animated');

    return 'Prop(${parts.join(', ')})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Prop<V> &&
        other.$token == $token &&
        other.$value == $value &&
        listEquals(other.$modifiers, $modifiers) &&
        other.$animation == $animation;
  }

  @override
  bool get hasToken => $token != null;

  @override
  int get hashCode => Object.hash($token, $value, $modifiers, $animation);
}

/// Mix prop for Mix types - uses accumulation merge strategy
@immutable
class MixProp<V> extends PropBase<V> {
  final List<MixSource<V>> sources;

  const MixProp._({required this.sources, super.modifiers, super.animation});

  // Factory for internal use only

  factory MixProp.create({
    required List<MixSource<V>> sources,
    List<Modifier<V>>? modifiers,
    AnimationConfig? animation,
  }) {
    return MixProp._(
      sources: sources,
      modifiers: modifiers,
      animation: animation,
    );
  }

  // Named constructors for clarity
  MixProp(Mix<V> value)
    : this._(
        sources: [MixValueSource(value)],
        modifiers: null,
        animation: null,
      );

  // Token constructor
  MixProp.token(MixToken<V> token, Mix<V> Function(V) converter)
    : this._(
        sources: [MixTokenSource(token, converter)],
        modifiers: null,
        animation: null,
      );

  // modifiers
  const MixProp.modifiers(List<Modifier<V>> modifiers)
    : this._(sources: const [], modifiers: modifiers, animation: null);

  const MixProp.animation(AnimationConfig animation)
    : this._(sources: const [], modifiers: null, animation: animation);

  static MixProp<T>? maybe<T>(Mix<T>? value) {
    if (value == null) return null;

    return MixProp(value);
  }

  // Backward compatibility getter
  Mix<V>? get value {
    if (sources.isEmpty) return null;

    // Collect all value sources (ignore token sources for backward compatibility)
    final valueSources = sources
        .whereType<MixValueSource<V>>()
        .map((source) => source.value)
        .toList();

    if (valueSources.isEmpty) {
      // Cannot provide value for tokens without context
      return null;
    }

    return valueSources.reduce((a, b) => PropOps.mergeMixes(a, b));
  }

  MixProp<V> modifiers(List<Modifier<V>> modifiers) {
    return mergeProp(MixProp.modifiers(modifiers));
  }

  MixProp<V> animation(AnimationConfig animation) {
    return mergeProp(MixProp.animation(animation));
  }

  @override
  V resolveProp(BuildContext context) {
    return PropOps.resolveMix(this, context);
  }

  @override
  MixProp<V> mergeProp(MixProp<V>? other) {
    return PropOps.mergeMix(this, other);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixProp<V> &&
        listEquals(other.sources, sources) &&
        listEquals(other.$modifiers, $modifiers) &&
        other.$animation == $animation;
  }

  @override
  bool get hasToken => sources.any((source) => source is MixTokenSource<V>);

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(sources), $modifiers, $animation);
}
