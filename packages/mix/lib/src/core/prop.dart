import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../theme/mix/mix_theme.dart';
import '../theme/tokens/mix_token.dart';
import 'animation_config.dart';
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
sealed class _MixSource<V> {
  const _MixSource();
}

class _MixValueSource<V> extends _MixSource<V> {
  final Mixable<V> value;
  const _MixValueSource(this.value);
}

class _MixTokenSource<V> extends _MixSource<V> {
  final MixToken<V> token;
  final Mixable<V> Function(V) converter;
  const _MixTokenSource(this.token, this.converter);
}

/// Base sealed class for all properties
@immutable
sealed class PropBase<T> with Resolvable<T>, Mergeable {
  final List<MixDirective<T>>? directives;
  final AnimationConfig? animation;

  const PropBase({this.directives, this.animation});

  /// Helper for merging directives
  static List<MixDirective<T>>? _mergeDirectives<T>(
    List<MixDirective<T>>? a,
    List<MixDirective<T>>? b,
  ) {
    return switch ((a, b)) {
      (null, null) => null,
      (final a?, null) => a,
      (null, final b?) => b,
      (final a?, final b?) => [...a, ...b],
    };
  }

  /// Returns the value type for this property
  /// For Prop<T>, this returns T
  /// For MixProp<V>, this returns V (the resolved type)
  Type get valueType => T;
}

/// Regular Prop for non-Mix values
@immutable
class Prop<T> extends PropBase<T> {
  final PropSource<T>? source;

  const Prop._({this.source, super.directives, super.animation});

  /// Creates a Prop with a direct value
  factory Prop(T value) {
    return Prop._(source: ValueSource(value));
  }

  /// Creates a Prop with a token reference
  factory Prop.token(MixToken<T> token) {
    return Prop._(source: TokenSource(token));
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

  T _resolveToken(MixToken<T> token, BuildContext context) {
    final value = MixScope.tokenOf(token, context);
    if (value == null) {
      throw FlutterError(
        'Prop could not resolve token: $token was not found in context',
      );
    }

    return value;
  }

  /// Whether this prop has a value source
  bool get hasValue => source is ValueSource<T>;

  /// Whether this prop has a token source
  bool get hasToken => source is TokenSource<T>;

  /// Gets the value if source is ValueSource, throws otherwise
  T getValue() => source is ValueSource<T>
      ? (source as ValueSource<T>).value
      : throw StateError('Prop does not have a value source');

  /// Gets the token if source is TokenSource, throws otherwise
  MixToken<T> getToken() => source is TokenSource<T>
      ? (source as TokenSource<T>).token
      : throw StateError('Prop does not have a token source');

  /// Merges this Prop with another
  @override
  Prop<T> merge(Prop<T>? other) {
    if (other == null) return this;

    return Prop._(
      source: other.source ?? source, // Other's source wins
      directives: PropBase._mergeDirectives(directives, other.directives),
      animation: other.animation ?? animation,
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
      _ => throw FlutterError('Unknown source type: ${source.runtimeType}'),
    };

    // Apply directives to the resolved value
    var result = base;
    for (final directive in directives ?? []) {
      result = directive.apply(result);
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Prop<T> &&
        other.source == source &&
        listEquals(other.directives, directives) &&
        other.animation == animation;
  }

  @override
  int get hashCode =>
      source.hashCode ^ directives.hashCode ^ animation.hashCode;
}

/// Specialized Prop for Mix types
@immutable
class MixProp<V> extends PropBase<V> {
  final MixPropSource<V>? source;

  const MixProp._({this.source, super.directives, super.animation});

  /// Creates a MixProp with a Mixable value
  factory MixProp(Mixable<V> value) {
    return MixProp._(source: MixPropSource.value(value));
  }

  /// Creates a MixProp with a token and converter
  factory MixProp.token(MixToken<V> token, Mixable<V> Function(V) converter) {
    return MixProp._(source: MixPropSource.token(token, converter));
  }

  /// Creates a MixProp with directives only
  factory MixProp.directives(List<MixDirective<V>> directives) {
    return MixProp._(directives: directives);
  }

  /// Creates a MixProp with animation configuration only
  factory MixProp.animation(AnimationConfig animation) {
    return MixProp._(animation: animation);
  }

  /// Creates a MixProp from a nullable Mixable value
  static MixProp<V>? maybe<V>(Mixable<V>? value) {
    return value != null ? MixProp(value) : null;
  }

  /// Whether this prop has a source
  bool get hasSource => source != null;

  /// Gets the MixPropSource if available, throws otherwise
  MixPropSource<V> getMixSource() => source != null
      ? source!
      : throw StateError('MixProp does not have a source');

  /// Merges this MixProp with another
  @override
  MixProp<V> merge(MixProp<V>? other) {
    if (other == null) return this;

    // MixPropSource handles its own merging
    final mergedSource = switch ((source, other.source)) {
      (final a?, final b?) => a.merge(b),
      (_, final b?) => b,
      (final a, null) => a,
    };

    return MixProp._(
      source: mergedSource,
      directives: PropBase._mergeDirectives(directives, other.directives),
      animation: other.animation ?? animation,
    );
  }

  /// Resolves the property value using the provided context
  @override
  V resolve(BuildContext context) {
    if (source == null) {
      throw FlutterError(
        'MixProp could not be resolved: No source exists to resolve',
      );
    }

    // MixPropSource handles all the merging and resolution
    final base = source!.resolve(context);

    // Apply directives to the resolved value
    var result = base;
    for (final directive in directives ?? []) {
      result = directive.apply(result);
    }

    return result;
  }

  @override
  String toString() {
    final buffer = StringBuffer('MixProp<$V>(');
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixProp<V> &&
        other.source == source &&
        listEquals(other.directives, directives) &&
        other.animation == animation;
  }

  @override
  int get hashCode =>
      source.hashCode ^ directives.hashCode ^ animation.hashCode;
}
