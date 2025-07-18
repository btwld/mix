import 'package:flutter/widgets.dart';

import '../attributes/animation/animation_config.dart';
import '../internal/compare_mixin.dart';
import '../theme/mix/mix_theme.dart';
import '../theme/tokens/mix_token.dart';
import 'mix_element.dart';

/// Base class for all property sources
sealed class PropSource<T> {
  const PropSource();
}

/// Source for regular values
class ValueSource<T> extends PropSource<T> {
  final T value;
  const ValueSource(this.value);

  @override
  String toString() => 'ValueSource($value)';
}

/// Source for token references
class TokenSource<T> extends PropSource<T> {
  final MixToken<T> token;
  const TokenSource(this.token);

  @override
  String toString() => 'TokenSource($token)';
}

/// Source for Mix types that can accumulate and merge
class MixPropSource<V> extends PropSource<V> {
  final List<_MixSource<V>> _sources;

  const MixPropSource._(this._sources);

  /// Creates a MixPropSource with a direct Mix value
  factory MixPropSource.value(Mixable<V> value) {
    return MixPropSource._([_MixValueSource(value)]);
  }

  /// Creates a MixPropSource with a token and converter
  factory MixPropSource.token(
    MixToken<V> token,
    Mixable<V> Function(V) converter,
  ) {
    return MixPropSource._([_MixTokenSource(token, converter)]);
  }

  V _resolveToken(MixToken<V> token, BuildContext context) {
    final value = MixScope.tokenOf(token, context);
    if (value == null) {
      throw FlutterError(
        'MixPropSource could not resolve token: $token was not found in context',
      );
    }

    return value;
  }

  /// Merges two MixPropSources by accumulating their sources
  MixPropSource<V> merge(MixPropSource<V> other) {
    return MixPropSource._([..._sources, ...other._sources]);
  }

  /// Resolves all accumulated sources and merges them into a single value
  V resolve(BuildContext context) {
    if (_sources.isEmpty) {
      throw FlutterError('MixPropSource has no sources to resolve');
    }

    Mixable<V>? result;

    for (final source in _sources) {
      final value = switch (source) {
        _MixValueSource(:final value) => value,
        _MixTokenSource(:final token, :final converter) => converter(
          _resolveToken(token, context),
        ),
      };

      result = result == null ? value : result.merge(value);
    }

    if (result == null) {
      throw StateError('MixPropSource resolved to null');
    }

    return result.resolve(context);
  }

  @override
  String toString() => 'MixPropSource(${_sources.length} sources)';
}

// Internal Mix source types
sealed class _MixSource<V> {}

class _MixValueSource<V> extends _MixSource<V> {
  final Mixable<V> value;
  _MixValueSource(this.value);
}

class _MixTokenSource<V> extends _MixSource<V> {
  final MixToken<V> token;
  final Mixable<V> Function(V) converter;
  _MixTokenSource(this.token, this.converter);
}

/// Represents a property that can hold values, tokens, directives, and animations
@immutable
class Prop<T> with EqualityMixin, Resolvable<T> {
  final PropSource<T>? source;
  final List<MixDirective<T>>? directives;
  final AnimationConfig? animation;

  const Prop._({this.source, this.directives, this.animation});

  /// Creates a Prop with a direct value
  factory Prop(T value) {
    return Prop._(source: ValueSource(value));
  }

  /// Creates a Prop with a token reference
  factory Prop.token(MixToken<T> token) {
    return Prop._(source: TokenSource(token));
  }

  /// Creates a Prop with a Mix value that can be merged
  /// Note: T must be Mix<V> for some V
  factory Prop.mix(Mixable<T> value) {
    return Prop._(source: MixPropSource.value(value));
  }

  /// Creates a Prop with a Mix token and converter
  /// Note: T must be Mix<V>
  factory Prop.mixToken(MixToken<T> token, Mixable<T> Function(T) converter) {
    return Prop._(
      source: MixPropSource.token(token, converter) as PropSource<T>,
    );
  }

  /// Creates a Prop with directives only
  factory Prop.directives(List<MixDirective<T>> directives) {
    return Prop._(directives: directives);
  }

  /// Creates a Prop with animation configuration only
  factory Prop.animation(AnimationConfig animation) {
    return Prop._(animation: animation);
  }

  /// Creates a Prop from a nullable value, returning null if value is null
  static Prop<T>? maybe<T>(T? value) {
    return value != null ? Prop(value) : null;
  }

  /// Creates a Prop from a nullable Mix value, returning null if value is null
  static Prop<T>? maybeMix<T>(Mixable<T>? value) {
    if (value == null) return null;

    return Prop.mix(value);
  }

  T _resolveToken(MixToken<T> token, BuildContext context) {
    return MixScope.tokenOf(token, context);
  }

  /// Whether this prop has a value source
  bool get hasValue => source is ValueSource<T>;

  /// Whether this prop has a token source
  bool get hasToken => source is TokenSource<T>;

  /// Whether this prop has a Mix source
  bool get hasMixSource => source is MixPropSource;

  T getValue() => source is ValueSource<T>
      ? (source as ValueSource<T>).value
      : throw StateError('Prop does not have a value source');

  MixToken<T> getToken() => source is TokenSource<T>
      ? (source as TokenSource<T>).token
      : throw StateError('Prop does not have a token source');

  MixPropSource<T> getMixSource() => source is MixPropSource<T>
      ? (source as MixPropSource<T>)
      : throw StateError('Prop does not have a Mix source');

  /// Merges this Prop with another, handling different merge strategies
  Prop<T> merge(Prop<T>? other) {
    if (other == null) return this;

    // Merge directives - always accumulate
    final mergedDirectives = switch ((directives, other.directives)) {
      (null, null) => null,
      (final a?, null) => a,
      (null, final b?) => b,
      (final a?, final b?) => [...a, ...b],
    };

    // Animation - other wins if present
    final mergedAnimation = other.animation ?? animation;

    var result = this.source;

    if (source is MixPropSource<T> && other.source is MixPropSource<T>) {
      result = (source as MixPropSource<T>).merge(
        other.source as MixPropSource<T>,
      );
    }

    return Prop._(
      source: result,
      directives: mergedDirectives,
      animation: mergedAnimation,
    );
  }

  /// Resolves the property value using the provided context
  @override
  T resolve(BuildContext context) {
    if (source == null) {
      throw FlutterError(
        'Prop could not be resolved: No source exists to resolve',
      );
    }

    // Resolve the base value from source
    final base = switch (source!) {
      ValueSource(:final value) => value,
      TokenSource(:final token) => _resolveToken(token, context),
      MixPropSource<T> mixSource => mixSource.resolve(context),
    };

    var result = base;

    // Apply directives to the resolved value
    for (var directive in directives ?? []) {
      if (directive is MixDirective<T>) {
        result = directive.apply(result);
      } else {
        throw FlutterError(
          'Prop encountered an unsupported directive type: ${directive.runtimeType}',
        );
      }
    }

    return result;
  }

  @override
  String toString() {
    final buffer = StringBuffer('Prop<$T>(');
    final parts = <String>[];

    if (source != null) {
      parts.add('source: $source');
    }
    if (directives != null && directives!.isNotEmpty) {
      parts.add('directives: ${directives!.length}');
    }
    if (animation != null) {
      parts.add('animated');
    }

    if (parts.isEmpty) {
      parts.add('empty');
    }

    buffer.write(parts.join(', '));
    buffer.write(')');

    return buffer.toString();
  }

  @override
  List<Object?> get props => [source, directives, animation];
}
