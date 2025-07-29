import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../properties/painting/decoration_mix.dart';
import '../properties/painting/shape_border_mix.dart';
import '../theme/mix_theme.dart';
import '../theme/tokens/mix_token.dart';
import 'decoration_merge.dart';
import 'directive.dart';
import 'helpers.dart';
import 'mix_element.dart';
import 'shape_border_merge.dart';

/// Base class for property value sources.
///
/// Defines the source of a property value, which can be a direct value,
/// a token reference, or a mix value.
@immutable
abstract class PropSource<T> {
  const PropSource();
}

/// Source for direct values (used by Prop).
@immutable
class ValuePropSource<T> extends PropSource<T> {
  final T value;

  const ValuePropSource(this.value);

  @override
  String toString() => 'ValuePropSource($value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValuePropSource<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// Source for token references (used by Prop).
@immutable
class TokenPropSource<T> extends PropSource<T> {
  final MixToken<T> token;

  const TokenPropSource(this.token);

  @override
  String toString() => 'TokenPropSource($token)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokenPropSource<T> && other.token == token;
  }

  @override
  int get hashCode => token.hashCode;
}

// ====== Prop Types ======

/// Base class for property values that can be resolved and merged.
///
/// Properties are the foundation of the Mix system, providing value resolution,
/// merging capabilities, directive application, and animation support.
@immutable
sealed class PropBase<V> extends Mixable<V> with Resolvable<V> {
  /// Directives to apply to the resolved value
  final List<MixDirective<V>>? $directives;

  /// Animation configuration for this property
  final AnimationConfig? $animation;

  const PropBase({
    List<MixDirective<V>>? directives,
    AnimationConfig? animation,
  }) : $directives = directives,
       $animation = animation;

  Type get type => V;

  /// Applies directives to the resolved value
  @protected
  V applyDirectives(V value) {
    if ($directives == null || $directives!.isEmpty) return value;

    var result = value;
    for (final directive in $directives!) {
      result = directive.apply(result);
    }

    return result;
  }

  // Helper methods for merging directives and animation
  @protected
  List<MixDirective<V>>? mergeDirectives(List<MixDirective<V>>? other) {
    return switch (($directives, other)) {
      (null, null) => null,
      (final a?, null) => a,
      (null, final b?) => b,
      (final a?, final b?) => [...a, ...b],
    };
  }

  @protected
  AnimationConfig? mergeAnimation(AnimationConfig? other) {
    return other ?? $animation; // Other's animation wins
  }

  /// Resolves the property value using the provided context
  @override
  V resolve(BuildContext context);
}

/// Prop for regular types - uses replacement merge strategy
@immutable
class Prop<V> extends PropBase<V> {
  final PropSource<V>? source;

  const Prop._({this.source, super.directives, super.animation});

  // Named constructors for clarity
  Prop(V value, {List<MixDirective<V>>? directives, AnimationConfig? animation})
    : this._(
        source: ValuePropSource(value),
        directives: directives,
        animation: animation,
      );

  Prop.token(
    MixToken<V> token, {
    List<MixDirective<V>>? directives,
    AnimationConfig? animation,
  }) : this._(
         source: TokenPropSource(token),
         directives: directives,
         animation: animation,
       );

  const Prop.directives(
    List<MixDirective<V>> directives, {
    AnimationConfig? animation,
  }) : this._(source: null, directives: directives, animation: animation);

  const Prop.animation(AnimationConfig animation)
    : this._(source: null, directives: null, animation: animation);

  static Prop<V>? maybe<V>(V? value) {
    if (value == null) return null;

    return Prop(value);
  }

  // Helper methods for Prop
  bool get hasValue => source is ValuePropSource<V>;

  bool get hasToken => source is TokenPropSource<V>;

  V get value {
    if (source is! ValuePropSource<V>) {
      throw FlutterError('Prop<$V> does not have a direct value source');
    }

    return (source as ValuePropSource<V>).value;
  }

  MixToken<V> get token {
    if (source is! TokenPropSource<V>) {
      throw FlutterError('Prop<$V> does not have a token source');
    }

    return (source as TokenPropSource<V>).token;
  }

  Prop<V> directives(List<MixDirective<V>> directives) {
    return merge(Prop.directives(directives));
  }

  Prop<V> animation(AnimationConfig animation) {
    return merge(Prop.animation(animation));
  }

  @override
  Prop<V> merge(Prop<V>? other) {
    if (other == null) return this;

    // For static props, the other source replaces this source
    return Prop._(
      source: other.source ?? source,
      directives: mergeDirectives(other.$directives),
      animation: mergeAnimation(other.$animation),
    );
  }

  @override
  V resolve(BuildContext context) {
    if (source == null) {
      throw FlutterError('Prop<$V> has no source defined');
    }

    // Resolve the value from the source
    final resolvedValue = switch (source) {
      ValuePropSource<V> valueSource => valueSource.value,
      TokenPropSource<V> tokenSource => MixScope.tokenOf(
        tokenSource.token,
        context,
      ),
      _ => throw FlutterError(
        'Unsupported PropSource type: ${source ?? 'null'}',
      ),
    };

    // Apply directives if any
    return applyDirectives(resolvedValue);
  }

  @override
  String toString() {
    final parts = <String>[];
    parts.add('source: ${source ?? 'null'}');
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
        other.source == source &&
        listEquals(other.$directives, $directives) &&
        other.$animation == $animation;
  }

  @override
  int get hashCode => Object.hash(source, $directives, $animation);
}

/// Mix prop for Mix types - uses accumulation merge strategy
@immutable
class MixProp<V> extends PropBase<V> {
  final Mix<V>? value;

  const MixProp._({this.value, super.directives, super.animation});

  // Named constructors for clarity
  const MixProp(Mix<V> value)
    : this._(value: value, directives: null, animation: null);

  // directives
  const MixProp.directives(List<MixDirective<V>> directives)
    : this._(value: null, directives: directives, animation: null);

  const MixProp.animation(AnimationConfig animation)
    : this._(value: null, directives: null, animation: animation);

  static MixProp<T>? maybe<T>(Mix<T>? value) {
    if (value == null) return null;

    return MixProp(value);
  }

  M? _mergeMixes<M extends Mix<V>>(M? a, M? b) {
    if (b == null) return a;
    if (a == null) return b;
    if (a is DecorationMix && b is DecorationMix) {
      return DecorationMerger().tryMerge(
            a as DecorationMix,
            b as DecorationMix,
          )!
          as M;
    }

    if (a is ShapeBorderMix && b is ShapeBorderMix) {
      return ShapeBorderMerger.tryMerge(
            a as ShapeBorderMix,
            b as ShapeBorderMix,
          )!
          as M;
    }

    return a.merge(b) as M;
  }

  MixProp<V> directives(List<MixDirective<V>> directives) {
    return merge(MixProp.directives(directives));
  }

  MixProp<V> animation(AnimationConfig animation) {
    return merge(MixProp.animation(animation));
  }

  @override
  V resolve(BuildContext context) {
    if (value == null) {
      throw FlutterError('MixProp<$V> has no source defined');
    }

    final resolvedValue = value!.resolve(context);

    // Apply directives if any
    return applyDirectives(resolvedValue);
  }

  @override
  MixProp<V> merge(MixProp<V>? other) {
    if (other == null) return this;

    // Merge sources using accumulation strategy
    final mergedSource = _mergeMixes(value, other.value);

    return MixProp._(
      value: mergedSource,
      directives: mergeDirectives(other.$directives),
      animation: mergeAnimation(other.$animation),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixProp<V> &&
        other.value == value &&
        listEquals(other.$directives, $directives) &&
        other.$animation == $animation;
  }

  @override
  int get hashCode => Object.hash(value, $directives, $animation);
}

extension PropExt<T> on Prop<T>? {
  Prop<T>? tryMerge(Prop<T>? other) {
    if (this == null) return other;
    if (other == null) return this;

    return this!.merge(other);
  }
}

extension ListPropExt<T> on List<Prop<T>> {
  List<Prop<T>>? tryMerge(List<Prop<T>>? other, {ListMergeStrategy? strategy}) {
    if (other == null) return this;

    return MixHelpers.mergeList(this, other, strategy: strategy);
  }
}

extension MixPropExt<T> on MixProp<T>? {
  MixProp<T>? tryMerge(MixProp<T>? other) {
    if (this == null) return other;
    if (other == null) return this;

    return this!.merge(other);
  }
}

extension ListMixPropExt<T> on List<MixProp<T>> {
  List<MixProp<T>>? tryMerge(
    List<MixProp<T>>? other, {
    ListMergeStrategy? strategy,
  }) {
    if (other == null) return this;

    return MixHelpers.mergeList(this, other, strategy: strategy);
  }
}
