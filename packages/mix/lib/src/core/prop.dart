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
import 'prop_source.dart';
import 'shape_border_merge.dart';

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

  bool get hasToken;

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

  const Prop.raw({this.source, super.directives, super.animation});

  // Named constructors for clarity
  Prop(V value, {List<MixDirective<V>>? directives, AnimationConfig? animation})
    : this.raw(
        source: ValuePropSource(value),
        directives: directives,
        animation: animation,
      );

  Prop.token(
    MixToken<V> token, {
    List<MixDirective<V>>? directives,
    AnimationConfig? animation,
  }) : this.raw(
         source: TokenPropSource(token),
         directives: directives,
         animation: animation,
       );

  const Prop.directives(
    List<MixDirective<V>> directives, {
    AnimationConfig? animation,
  }) : this.raw(source: null, directives: directives, animation: animation);

  const Prop.animation(AnimationConfig animation)
    : this.raw(source: null, directives: null, animation: animation);

  static Prop<V>? maybe<V>(V? value) {
    if (value == null) return null;

    return Prop(value);
  }

  // Helper methods for Prop
  bool get hasValue => source is ValuePropSource<V>;

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
    return Prop.raw(
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
  bool get hasToken => source is TokenPropSource<V>;

  @override
  int get hashCode => Object.hash(source, $directives, $animation);
}

/// Mix prop for Mix types - uses accumulation merge strategy
@immutable
class MixProp<V> extends PropBase<V> {
  final List<MixSource<V>> sources;

  const MixProp._({required this.sources, super.directives, super.animation});

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
  const MixProp.directives(List<MixDirective<V>> directives)
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

    return valueSources.reduce(mergeMixes);
  }

  @visibleForTesting
  Mix<V> mergeMixes(Mix<V> a, Mix<V> b) {
    if (a is DecorationMix && b is DecorationMix) {
      return DecorationMerger().tryMerge(
            a as DecorationMix,
            b as DecorationMix,
          )!
          as Mix<V>;
    }

    if (a is ShapeBorderMix && b is ShapeBorderMix) {
      return ShapeBorderMerger.tryMerge(
            a as ShapeBorderMix,
            b as ShapeBorderMix,
          )!
          as Mix<V>;
    }

    return a.merge(b);
  }

  /// Consolidates consecutive MixValueSource instances in the sources list
  @visibleForTesting
  List<MixSource<V>> consolidateSources(List<MixSource<V>> sources) {
    if (sources.length <= 1) return sources;

    final consolidated = <MixSource<V>>[];
    MixValueSource<V>? pendingValueSource;

    for (final source in sources) {
      if (source is MixValueSource<V>) {
        if (pendingValueSource != null) {
          // Merge with pending value source
          final mergedMix = mergeMixes(pendingValueSource.value, source.value);
          pendingValueSource = MixValueSource(mergedMix);
        } else {
          // Start accumulating
          pendingValueSource = source;
        }
      } else {
        // Not a value source, flush any pending and add this source
        if (pendingValueSource != null) {
          consolidated.add(pendingValueSource);
          pendingValueSource = null;
        }
        consolidated.add(source);
      }
    }

    // Don't forget to add any remaining pending value source
    if (pendingValueSource != null) {
      consolidated.add(pendingValueSource);
    }

    return consolidated;
  }

  MixProp<V> directives(List<MixDirective<V>> directives) {
    return merge(MixProp.directives(directives));
  }

  MixProp<V> animation(AnimationConfig animation) {
    return merge(MixProp.animation(animation));
  }

  @override
  V resolve(BuildContext context) {
    if (sources.isEmpty) {
      throw FlutterError('MixProp<$V> has no sources defined');
    }

    // Resolve all sources to Mix values
    final mixValues = <Mix<V>>[];
    for (final source in sources) {
      final mixValue = switch (source) {
        MixValueSource<V>(:final value) => value,
        MixTokenSource<V>(:final token, :final converter) => converter(
          MixScope.tokenOf(token, context),
        ),
      };
      mixValues.add(mixValue);
    }

    // Merge all Mix values into one
    Mix<V> mergedMix = mixValues.first;
    for (int i = 1; i < mixValues.length; i++) {
      mergedMix = mergeMixes(mergedMix, mixValues[i]);
    }

    final resolvedValue = mergedMix.resolve(context);

    // Apply directives if any
    return applyDirectives(resolvedValue);
  }

  @override
  MixProp<V> merge(MixProp<V>? other) {
    if (other == null) return this;

    // Accumulate sources from both props
    final accumulatedSources = [...sources, ...other.sources];

    // Consolidate consecutive MixValueSource instances
    final mergedSources = consolidateSources(accumulatedSources);

    return MixProp._(
      sources: mergedSources,
      directives: mergeDirectives(other.$directives),
      animation: mergeAnimation(other.$animation),
    );
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
