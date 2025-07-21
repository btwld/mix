import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../theme/mix/mix_theme.dart';
import '../theme/tokens/mix_token.dart';
import 'animation_config.dart';
import 'directive.dart';
import 'mix_element.dart';

/// Base class for all property sources
sealed class PropSource<T> {
  const PropSource();

  /// Resolves this source to a value
  T resolve(BuildContext context);
}

/// Source for regular values
class ValueSource<T> extends PropSource<T> {
  final T value;
  const ValueSource(this.value);

  @override
  T resolve(BuildContext context) => value;

  @override
  String toString() => 'ValueSource($value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueSource<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// Source for token references
class TokenSource<T> extends PropSource<T> {
  final MixToken<T> token;
  const TokenSource(this.token);

  @override
  T resolve(BuildContext context) {
    final value = MixScope.tokenOf(token, context);
    if (value == null) {
      throw FlutterError(
        'Could not resolve token: $token was not found in context',
      );
    }

    return value;
  }

  @override
  String toString() => 'TokenSource($token)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokenSource<T> && other.token == token;
  }

  @override
  int get hashCode => token.hashCode;
}

/// Source for Mix types that can accumulate and merge
class MixPropSource<V> extends PropSource<V> {
  final List<_MixSource<V>> _sources;

  const MixPropSource._(this._sources);

  /// Creates a MixPropSource with a direct Mix value
  factory MixPropSource.value(Mix<V> value) {
    return MixPropSource._([_MixValueSource(value)]);
  }

  /// Creates a MixPropSource with a token and converter
  factory MixPropSource.token(MixToken<V> token, Mix<V> Function(V) converter) {
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
  @override
  V resolve(BuildContext context) {
    if (_sources.isEmpty) {
      throw FlutterError('MixPropSource has no sources to resolve');
    }

    Mix<V>? result;

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixPropSource<V> && listEquals(other._sources, _sources);
  }

  @override
  int get hashCode => Object.hashAll(_sources);
}

// Internal Mix source types
sealed class _MixSource<V> {
  const _MixSource();
}

class _MixValueSource<V> extends _MixSource<V> {
  final Mix<V> value;
  const _MixValueSource(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _MixValueSource<V> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

class _MixTokenSource<V> extends _MixSource<V> {
  final MixToken<V> token;
  final Mix<V> Function(V) converter;
  const _MixTokenSource(this.token, this.converter);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _MixTokenSource<V> &&
          other.token == token &&
          other.converter == converter;

  @override
  int get hashCode => Object.hash(token, converter);
}

/// Base sealed class for all properties
@immutable
sealed class PropBase<T> extends Mixable<T> with Resolvable<T> {
  final List<MixDirective<T>>? directives;
  final AnimationConfig? animation;

  const PropBase({this.directives, this.animation});

  /// Helper for merging directives
  @protected
  static List<MixDirective<T>>? mergeDirectives<T>(
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
  Type get valueType => T;

  /// Applies directives to a resolved value
  @protected
  T applyDirectives(T value) {
    var result = value;
    for (final directive in directives ?? []) {
      result = directive.apply(result);
    }

    return result;
  }

  /// Creates string representation with common formatting
  @protected
  String toStringHelper(String typeName, {String? sourceInfo}) {
    final buffer = StringBuffer('$typeName<$T>(');
    final parts = <String>[];

    if (sourceInfo != null) {
      parts.add(sourceInfo);
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
      directives: PropBase.mergeDirectives(directives, other.directives),
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
    final base = source!.resolve(context);

    // Apply directives to the resolved value
    return applyDirectives(base);
  }

  @override
  String toString() {
    return toStringHelper('Prop', sourceInfo: source?.toString());
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

/// Specialized Prop for Mix types
@immutable
class MixProp<V> extends PropBase<V> {
  final MixPropSource<V>? source;

  const MixProp._({this.source, super.directives, super.animation});

  /// Creates a MixProp with a Mix value
  factory MixProp(Mix<V> value) {
    return MixProp._(source: MixPropSource.value(value));
  }

  /// Creates a MixProp with a token and converter
  factory MixProp.token(MixToken<V> token, Mix<V> Function(V) converter) {
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

  /// Creates a MixProp from a nullable Mix value
  static MixProp<V>? maybe<V>(Mix<V>? value) {
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
      directives: PropBase.mergeDirectives(directives, other.directives),
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
    return applyDirectives(base);
  }

  @override
  String toString() {
    return toStringHelper('MixProp', sourceInfo: source?.toString());
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
