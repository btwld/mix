import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../theme/mix/mix_theme.dart';
import '../theme/tokens/mix_token.dart';
import 'animation_config.dart';
import 'directive.dart';
import 'mix_element.dart';

/// Unified Prop implementation that handles all property types including Mix
///
/// Key design principles:
/// - Single Prop class for all types
/// - T can be any type, including Mix<V>
/// - When T extends Mix, tokens should be MixToken<Mix<V>>
/// - Merge always creates AccumulativePropSource
/// - Resolution decides accumulation vs replacement strategy
@immutable
class Prop<T> extends Mixable<T> with Resolvable<T> {
  /// The source of the property value
  final PropSource<T>? source;

  /// Directives to apply to the resolved value
  final List<MixDirective<T>>? directives;

  /// Animation configuration for this property
  final AnimationConfig? animation;

  const Prop._({this.source, this.directives, this.animation});

  /// Creates a Prop with a direct value
  factory Prop(T value) {
    return Prop._(source: ValueSource(value));
  }

  /// Creates a Prop with a token reference
  ///
  /// For Mix types, the token should be MixToken<Mix<V>>, not MixToken<V>
  factory Prop.token(MixToken<T> token) {
    return Prop._(source: TokenSource(token));
  }

  /// Creates a Prop with only directives
  factory Prop.directives(List<MixDirective<T>> directives) {
    return Prop._(directives: directives);
  }

  /// Creates a Prop with only animation configuration
  factory Prop.animation(AnimationConfig animation) {
    return Prop._(animation: animation);
  }

  static Prop<T>? maybe<T>(T? value) {
    return value != null ? Prop(value) : null;
  }

  /// Applies directives to the resolved value
  T _applyDirectives(T value) {
    if (directives == null || directives!.isEmpty) return value;

    var result = value;
    for (final directive in directives!) {
      result = directive.apply(result);
    }

    return result;
  }

  PropSource<T>? _mergePropSource(PropSource<T>? a, PropSource<T>? b) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;

    if (a is ValueSource<T> && b is ValueSource<T>) {
      final thisValue = a.value;
      final otherValue = b.value;
      if (thisValue is Mix && otherValue is Mix) {
        // If both values are Mix, merge them
        return ValueSource(thisValue.merge(otherValue) as T);
      }
    }

    return AccumulativePropSource([a, b]);
  }

  bool get hasToken {
    final source = this.source;

    return source is TokenSource<T>;
  }

  bool get hasValue {
    final source = this.source;

    return source is ValueSource<T>;
  }

  T getValue() {
    final source = this.source;
    if (source == null) {
      throw FlutterError(
        'Prop<$T> could not be resolved: No source exists to resolve',
      );
    }

    if (source is ValueSource<T>) {
      // Direct value source, no need to resolve
      return (source).value;
    }

    throw FlutterError('Prop<$T> could not be resolved: No valid source found');
  }

  MixToken<T> getToken() {
    final source = this.source;
    if (source == null) {
      throw FlutterError(
        'Prop<$T> could not be resolved: No source exists to resolve',
      );
    }
    if (source is TokenSource<T>) {
      return (source).token;
    }

    throw FlutterError(
      'Prop<$T> is not a token source: Cannot get token from $source',
    );
  }

  /// Merges this Prop with another
  ///
  /// Sources are merged using their merge methods, which always
  /// results in AccumulativePropSource for proper handling of both
  /// accumulation (Mix types) and replacement (non-Mix types).
  @override
  Prop<T> merge(Prop<T>? other) {
    if (other == null) return this;

    // Merge directives
    final mergedDirectives = switch ((directives, other.directives)) {
      (null, null) => null,
      (final a?, null) => a,
      (null, final b?) => b,
      (final a?, final b?) => [...a, ...b],
    };

    return Prop._(
      source: _mergePropSource(source, other.source),
      directives: mergedDirectives,
      animation: other.animation ?? animation, // Other's animation wins
    );
  }

  /// Resolves the property value using the provided context
  @override
  T resolve(BuildContext context) {
    if (source == null) {
      throw FlutterError(
        'Prop<$T> could not be resolved: No source exists to resolve',
      );
    }

    final resolved = source!.resolve(context);

    return _applyDirectives(resolved);
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

    buffer.write(parts.isEmpty ? 'empty' : parts.join(', '));
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
  int get hashCode => Object.hash(source, directives, animation);
}

/// Base interface for all property sources
abstract class PropSource<T> {
  const PropSource();

  /// Resolves this source to a value of type T
  T resolve(BuildContext context);
}

/// Source for direct values
@immutable
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
@immutable
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

/// Accumulative source for Mix types that merges all sources
@immutable
class AccumulativePropSource<T> extends PropSource<T> {
  final List<PropSource<T>> sources;
  @protected
  const AccumulativePropSource._(this.sources);

  factory AccumulativePropSource(List<PropSource<T>> sources) {
    final sourceList = <PropSource<T>>[];

    for (final source in sources) {
      if (source is AccumulativePropSource<T>) {
        sourceList.addAll(source.sources);
      } else {
        sourceList.add(source);
      }
    }

    return AccumulativePropSource._(sourceList);
  }

  AccumulativePropSource<T> merge(AccumulativePropSource<T>? other) {
    return AccumulativePropSource._([...sources, ...?other?.sources]);
  }

  @override
  T resolve(BuildContext context) {
    if (sources.isEmpty) {
      throw StateError('AccumulativePropSource has no sources to resolve');
    }

    final resolveValues = sources.map((s) {
      return switch (s) {
        ValueSource<T> valueSource => valueSource.value,
        TokenSource<T> tokenSource => tokenSource.resolve(context),
        _ => throw FlutterError(
          'Unsupported PropSource type: ${s.runtimeType}',
        ),
      };
    }).toList();

    if (resolveValues.length == 1) {
      // If there's only one value, return it directly
      return resolveValues.first;
    }

    final firstValue = resolveValues.first;

    if (firstValue is Mix) {
      // If the first value is a Mix, merge all values
      return (resolveValues as List<Mix>).reduce((a, b) => a.merge(b)) as T;
    }

    // If all sources are Mix, merge them
    return resolveValues.last;
  }

  @override
  String toString() => 'AccumulativePropSource(${sources.length} sources)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccumulativePropSource<T> &&
        listEquals(other.sources, sources);
  }

  @override
  int get hashCode => Object.hashAll(sources);
}

typedef MixProp<T> = Prop<Mix<T>>;
