import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../theme/tokens/mix_token.dart';
import 'helpers.dart';
import 'mix_element.dart';
import 'directive.dart';
import 'prop_source.dart';

// ====== Prop Types ======

/// Base class for property values that can be resolved and merged.
///
/// Properties are the foundation of the Mix system, providing value resolution,
/// merging capabilities, directive application, and animation support.
@immutable
sealed class PropBase<V> {
  /// Directives to apply to the resolved value
  final List<Directive<V>>? $directives;

  /// Animation configuration for this property
  final AnimationConfig? $animation;

  const PropBase({List<Directive<V>>? directives, AnimationConfig? animation})
    : $directives = directives,
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
  const Prop({V? value, MixToken<V>? token, super.directives, super.animation})
    : $value = value,
      $token = token;

  const Prop.token(
    MixToken<V> token, {
    List<Directive<V>>? directives,
    AnimationConfig? animation,
  }) : this(token: token, directives: directives, animation: animation);

  Prop.fromProp(Prop<V> other)
    : this(
        value: other.$value,
        token: other.$token,
        directives: other.$directives,
        animation: other.$animation,
      );

  const Prop.directives(
    List<Directive<V>> directives, {
    AnimationConfig? animation,
  }) : this(directives: directives, animation: animation);

  const Prop.animation(AnimationConfig animation)
    : this(directives: null, animation: animation);

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

  Prop<V> directives(List<Directive<V>> directives) {
    return mergeProp(Prop.directives(directives));
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
    if ($directives != null && $directives!.isNotEmpty) {
      parts.add('directives: ${$directives!.length}');
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
        listEquals(other.$directives, $directives) &&
        other.$animation == $animation;
  }

  @override
  bool get hasToken => $token != null;

  @override
  int get hashCode => Object.hash($token, $value, $directives, $animation);
}

/// Mix prop for Mix types - uses accumulation merge strategy
@immutable
class MixProp<V> extends PropBase<V> {
  final List<MixSource<V>> sources;

  const MixProp._({required this.sources, super.directives, super.animation});

  // Factory for internal use only

  factory MixProp.create({
    required List<MixSource<V>> sources,
    List<Directive<V>>? directives,
    AnimationConfig? animation,
  }) {
    return MixProp._(
      sources: sources,
      directives: directives,
      animation: animation,
    );
  }

  // Named constructors for clarity
  MixProp(Mix<V> value)
    : this._(
        sources: [MixValueSource(value)],
        directives: null,
        animation: null,
      );

  // Token constructor
  MixProp.token(MixToken<V> token, Mix<V> Function(V) converter)
    : this._(
        sources: [MixTokenSource(token, converter)],
        directives: null,
        animation: null,
      );

  // directives
  const MixProp.directives(List<Directive<V>> directives)
    : this._(sources: const [], directives: directives, animation: null);

  const MixProp.animation(AnimationConfig animation)
    : this._(sources: const [], directives: null, animation: animation);

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

  MixProp<V> directives(List<Directive<V>> directives) {
    return mergeProp(MixProp.create(sources: [], directives: directives));
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
        listEquals(other.$directives, $directives) &&
        other.$animation == $animation;
  }

  @override
  bool get hasToken => sources.any((source) => source is MixTokenSource<V>);

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(sources), $directives, $animation);
}
