import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../theme/mix/mix_theme.dart';
import '../theme/tokens/mix_token.dart';
import 'animation_config.dart';
import 'directive.dart';
import 'mix_element.dart';

/// Base class for property value sources.
///
/// Defines the source of a property value, which can be a direct value,
/// a token reference, or a mix value.
@immutable
abstract class PropSource<T> {
  const PropSource();
}

/// Source for direct values (used by StaticProp).
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

/// Source for token references (used by StaticProp).
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

/// Base class for Mix property sources that can be resolved to Mix types.
@immutable
sealed class MixPropSource<V> extends PropSource<V> {
  const MixPropSource();
}

/// Mix value source - stores a Mix value directly.
@immutable
class MixPropValueSource<V> extends MixPropSource<V> {
  final Mix<V> value;

  const MixPropValueSource(this.value);

  @override
  String toString() => 'MixPropValueSource($value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixPropValueSource<V> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// Mix token source - resolves token and converts to Mix type.
@immutable
class MixPropTokenSource<V> extends MixPropSource<V> {
  final MixToken<V> token;
  final Mix<V> Function(V) convertToMix;

  const MixPropTokenSource(this.token, this.convertToMix);

  @override
  String toString() => 'MixPropTokenSource($token)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixPropTokenSource<V> &&
        other.token == token &&
        other.convertToMix == convertToMix;
  }

  @override
  int get hashCode => Object.hash(token, convertToMix);
}

/// Accumulative source - only accepts MixPropSource types.
@immutable
class MixPropAccumulativeSource<V> extends MixPropSource<V> {
  final List<MixPropSource<V>> sources;

  const MixPropAccumulativeSource(this.sources);

  @override
  String toString() => 'MixPropAccumulativeSource(${sources.length} sources)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixPropAccumulativeSource<V> &&
        listEquals(other.sources, sources);
  }

  @override
  int get hashCode => Object.hashAll(sources);
}

// ====== Prop Types ======

/// Base class for property values that can be resolved and merged.
///
/// Properties are the foundation of the Mix system, providing value resolution,
/// merging capabilities, directive application, and animation support.
@immutable
sealed class PropBase<T> extends Mixable<T> with Resolvable<T> {
  /// Directives to apply to the resolved value
  final List<MixDirective<T>>? directives;

  /// Animation configuration for this property
  final AnimationConfig? animation;

  const PropBase({this.directives, this.animation});

  /// The source of the property value
  PropSource<T>? get source;

  /// Applies directives to the resolved value
  @protected
  T applyDirectives(T value) {
    if (directives == null || directives!.isEmpty) return value;

    var result = value;
    for (final directive in directives!) {
      result = directive.apply(result);
    }

    return result;
  }

  // Helper methods for merging directives and animation
  @protected
  List<MixDirective<T>>? mergeDirectives(List<MixDirective<T>>? other) {
    return switch ((directives, other)) {
      (null, null) => null,
      (final a?, null) => a,
      (null, final b?) => b,
      (final a?, final b?) => [...a, ...b],
    };
  }

  @protected
  AnimationConfig? mergeAnimation(AnimationConfig? other) {
    return other ?? animation; // Other's animation wins
  }

  /// Resolves the property value using the provided context
  @override
  T resolve(BuildContext context);
}

/// Static prop for regular types - uses replacement merge strategy
@immutable
class Prop<T> extends PropBase<T> {
  @override
  final PropSource<T>? source;

  const Prop._({this.source, super.directives, super.animation});

  // Named constructors for clarity
  Prop(T value, {List<MixDirective<T>>? directives, AnimationConfig? animation})
    : this._(
        source: ValuePropSource(value),
        directives: directives,
        animation: animation,
      );

  Prop.token(
    MixToken<T> token, {
    List<MixDirective<T>>? directives,
    AnimationConfig? animation,
  }) : this._(
         source: TokenPropSource(token),
         directives: directives,
         animation: animation,
       );

  const Prop.directives(
    List<MixDirective<T>> directives, {
    AnimationConfig? animation,
  }) : this._(source: null, directives: directives, animation: animation);

  const Prop.animation(AnimationConfig animation)
    : this._(source: null, directives: null, animation: animation);

  static Prop<T>? maybe<T>(
    T? value, {
    List<MixDirective<T>>? directives,
    AnimationConfig? animation,
  }) {
    if (value == null) return null;

    return Prop(value, directives: directives, animation: animation);
  }

  // Helper methods for StaticProp
  bool get hasValue => source is ValuePropSource<T>;

  bool get hasToken => source is TokenPropSource<T>;
  T get value {
    if (source is! ValuePropSource<T>) {
      throw FlutterError('StaticProp<$T> does not have a direct value source');
    }

    return (source as ValuePropSource<T>).value;
  }

  MixToken<T> get token {
    if (source is! TokenPropSource<T>) {
      throw FlutterError('StaticProp<$T> does not have a token source');
    }

    return (source as TokenPropSource<T>).token;
  }

  @override
  Prop<T> merge(Prop<T>? other) {
    if (other == null) return this;

    // For static props, the other source replaces this source
    return Prop._(
      source: other.source ?? source,
      directives: mergeDirectives(other.directives),
      animation: mergeAnimation(other.animation),
    );
  }

  @override
  T resolve(BuildContext context) {
    if (source == null) {
      throw FlutterError('Prop<$T> has no source defined');
    }

    // Resolve the value from the source
    final resolvedValue = switch (source) {
      ValuePropSource<T> valueSource => valueSource.value,
      TokenPropSource<T> tokenSource => MixScope.tokenOf(
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
    if (directives != null && directives!.isNotEmpty) {
      parts.add('directives: ${directives!.length}');
    }
    if (animation != null) parts.add('animated');

    return 'Prop(${parts.join(', ')})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Prop<T> &&
        other.source == source &&
        listEquals(other.directives, directives) &&
        other.animation == animation;
  }

  @override
  int get hashCode => Object.hash(source, directives, animation);
}

/// Mix prop for Mix types - uses accumulation merge strategy
@immutable
class MixProp<V> extends PropBase<V> {
  @override
  final MixPropSource<V>? source;
  const MixProp._({this.source, super.directives, super.animation});

  // Named constructors for clarity
  MixProp(
    Mix<V> value, {
    List<MixDirective<V>>? directives,
    AnimationConfig? animation,
  }) : this._(
         source: MixPropValueSource(value),
         directives: directives,
         animation: animation,
       );

  MixProp.token(
    MixToken<V> token,
    Mix<V> Function(V) convertToMix, {
    List<MixDirective<V>>? directives,
    AnimationConfig? animation,
  }) : this._(
         source: MixPropTokenSource(token, convertToMix),
         directives: directives,
         animation: animation,
       );

  // directives
  const MixProp.directives(List<MixDirective<V>> directives)
    : this._(source: null, directives: directives, animation: null);

  const MixProp.animation(AnimationConfig animation)
    : this._(source: null, directives: null, animation: animation);

  static MixProp<V>? maybe<V>(
    Mix<V>? value, {
    List<MixDirective<V>>? directives,
    AnimationConfig? animation,
  }) {
    if (value == null) return null;

    return MixProp._(
      source: MixPropValueSource(value),
      directives: directives,
      animation: animation,
    );
  }

  /// Special merge logic for Mix sources - accumulates values
  MixPropSource<V>? _mergeMixSources(MixPropSource<V>? a, MixPropSource<V>? b) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;

    // Special optimization: if both are value sources, merge directly
    if (a is MixPropValueSource<V> && b is MixPropValueSource<V>) {
      return MixPropValueSource(a.value.merge(b.value));
    }

    // Otherwise, create accumulative source
    final sources = <MixPropSource<V>>[];

    // Flatten existing accumulative sourcesd
    if (a is MixPropAccumulativeSource<V>) {
      sources.addAll(a.sources);
    } else {
      sources.add(a);
    }

    if (b is MixPropAccumulativeSource<V>) {
      sources.addAll(b.sources);
    } else {
      sources.add(b);
    }

    return MixPropAccumulativeSource(sources);
  }

  Mix<V> get value {
    if (source is! MixPropValueSource<V>) {
      throw FlutterError('MixProp<$V> does not have a direct value source');
    }

    return (source as MixPropValueSource<V>).value;
  }

  MixToken<V> get token {
    if (source is! MixPropTokenSource<V>) {
      throw FlutterError('MixProp<$V> does not have a token source');
    }

    return (source as MixPropTokenSource<V>).token;
  }

  // Helper methods for MixProp

  bool get hasValue => source is MixPropValueSource<V>;

  bool get hasToken => source is MixPropTokenSource<V>;
  @visibleForTesting
  V resolveFromMixSources(
    List<MixPropSource<V>> sources,
    BuildContext context,
  ) {
    return sources
        .map(
          (source) => switch (source) {
            MixPropValueSource<V> valueSource => valueSource.value,
            MixPropTokenSource<V> tokenSource => tokenSource.convertToMix(
              MixScope.tokenOf(tokenSource.token, context),
            ),
            _ => throw FlutterError('Unsupported MixPropSource type: $source'),
          },
        )
        .toList()
        .reduce((a, b) => a.merge(b))
        .resolve(context);
  }

  @override
  V resolve(BuildContext context) {
    if (source == null) {
      throw FlutterError('MixProp<$V> has no source defined');
    }

    // Resolve the value from the source
    final resolvedValue = switch (source) {
      MixPropValueSource<V> valueSource => valueSource.value.resolve(context),
      MixPropTokenSource<V> tokenSource => MixScope.tokenOf(
        tokenSource.token,
        context,
      ),
      MixPropAccumulativeSource<V> accumulativeSource => resolveFromMixSources(
        accumulativeSource.sources,
        context,
      ),
      _ => throw FlutterError(
        'Unsupported MixPropSource type: ${source ?? 'null'}',
      ),
    };

    // Apply directives if any
    return applyDirectives(resolvedValue);
  }

  @override
  MixProp<V> merge(MixProp<V>? other) {
    if (other == null) return this;

    // Type-safe: we know other must be a MixProp
    final otherMixProp = other;

    // Merge sources using accumulation strategy
    final mergedSource = _mergeMixSources(source, otherMixProp.source);

    return MixProp._(
      source: mergedSource,
      directives: mergeDirectives(other.directives),
      animation: mergeAnimation(other.animation),
    );
  }

  @override
  String toString() {
    final parts = <String>[];
    if (source != null) parts.add('source: $source');
    if (directives?.isNotEmpty == true) {
      parts.add('directives: ${directives!.length}');
    }
    if (animation != null) parts.add('animated');

    return 'MixProp(${parts.join(', ')})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixProp<V> &&
        other.source == source &&
        listEquals(other.directives, directives) &&
        other.animation == animation;
  }

  @override
  int get hashCode => Object.hash(source, directives, animation);
}
