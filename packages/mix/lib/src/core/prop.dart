import 'package:flutter/foundation.dart';

import '../attributes/animation/animation_config.dart';
import '../internal/compare_mixin.dart';
import '../theme/tokens/mix_token.dart';
import 'factory/mix_context.dart';
import 'mix_element.dart';

/// Simplified Prop that can hold values or tokens with optional directives
@immutable
class Prop<T> with EqualityMixin, ResolvableMixin<T> {
  final T? _value;
  final MixToken<T>? _token;
  final List<MixDirective<T>>? _directives;
  final AnimationConfig? _animation;

  /// Private constructor with all optional parameters
  const Prop._({
    T? value,
    MixToken<T>? token,
    List<MixDirective<T>>? directives,
    AnimationConfig? animation,
  }) : _value = value,
       _token = token,
       _directives = directives,
       _animation = animation;

  /// Creates a prop with a direct value
  const Prop.fromValue(T value, {AnimationConfig? animation})
    : this._(value: value, animation: animation);

  /// Creates a prop with a token
  const Prop.fromToken(MixToken<T> token, {AnimationConfig? animation})
    : this._(token: token, animation: animation);

  /// Creates a prop with directives only
  const Prop.fromDirectives(
    List<MixDirective<T>> directives, {
    AnimationConfig? animation,
  }) : this._(directives: directives, animation: animation);

  /// Creates a prop with animation only
  const Prop.fromAnimation(AnimationConfig animation)
    : this._(animation: animation);

  static Prop<T>? maybeValue<T>(T? value) {
    if (value == null) return null;

    return Prop.fromValue(value);
  }

  T? get value => _value;
  MixToken<T>? get token => _token;

  /// Whether this prop has a value
  bool get hasValue => _value != null;

  /// Whether this prop has a token
  bool get hasToken => _token != null;

  /// Get the directives
  List<MixDirective<T>>? get directives => _directives;

  /// Get the animation configuration
  AnimationConfig? get animation => _animation;

  /// CENTRALIZED MERGE LOGIC
  /// Merge behavior:
  /// - Empty + Anything = other wins
  /// - Anything + Empty = this wins
  /// - Other's value/token wins when present, directives always accumulate
  /// - If other has only directives, this value/token wins, directives accumulate
  Prop<T> merge(Prop<T>? other) {
    if (other == null) return this;

    final mergedDirectives = switch ((_directives, other._directives)) {
      (null, null) => null,
      (final a?, null) => a, // Only this has directives
      (null, final b?) => b, // Only other has directives
      (final a?, final b?) => [...a, ...b], // Both have directives
    };

    // Animation merging: other's animation wins if present, otherwise keep this one
    final mergedAnimation = other._animation ?? _animation;

    // Other's base value/token wins when present, but directives accumulate
    if (other._value != null) {
      return Prop._(
        value: other._value,
        directives: mergedDirectives,
        animation: mergedAnimation,
      );
    }
    if (other._token != null) {
      return Prop._(
        token: other._token,
        directives: mergedDirectives,
        animation: mergedAnimation,
      );
    }

    // Other has only directives, keep this value/token, accumulate directives
    return Prop._(
      value: _value,
      token: _token,
      directives: mergedDirectives,
      animation: mergedAnimation,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('Prop<${T.toString()}>(');
    if (_value != null) {
      buffer.write('value: $_value');
    } else if (_token != null) {
      buffer.write('token: $_token');
    }
    if (_directives != null && _directives.isNotEmpty) {
      if (buffer.length > 5) buffer.write(', ');
      buffer.write('directives: $_directives');
    }
    buffer.write(')');

    return buffer.toString();
  }

  /// Resolves the value using the provided context
  /// Throws FlutterError if unable to resolve
  @override
  T resolve(MixContext context) {
    T? result;

    if (_value != null) {
      result = _value;
    } else if (_token != null) {
      result = context.getToken(_token);
    }

    if (result == null) {
      if (hasToken) {
        throw FlutterError(
          'Prop could not be resolved: Token ${_token ?? 'unknown'} was not found in context',
        );
      }

      throw FlutterError(
        'Prop could not be resolved: No value or token exists to resolve',
      );
    }

    // Apply directives to resolved value
    T current = result;
    for (final directive in _directives ?? []) {
      current = directive.apply(current);
    }

    return current;
  }

  @override
  List<Object?> get props => [_value, _token, _directives, _animation];
}

/// MixProp for handling Mix objects (DTOs) with simplified logic
@immutable
class MixProp<V, T extends Mix<V>> with EqualityMixin, ResolvableMixin<V> {
  final T? _value;
  final MixToken<V>? _token;
  final T Function(V)? _mixConverter;
  final List<MixDirective<T>>? _directives;
  final AnimationConfig? _animation;

  /// Private constructor with all optional parameters
  const MixProp._({
    T? value,
    MixToken<V>? token,
    T Function(V)? mixConverter,
    List<MixDirective<T>>? directives,
    AnimationConfig? animation,
  }) : _value = value,
       _token = token,
       _mixConverter = mixConverter,
       _directives = directives,
       _animation = animation;

  /// Creates a MixProp with a direct value
  const MixProp.fromValue(T value, {AnimationConfig? animation})
    : this._(value: value, animation: animation);

  /// Creates a MixProp with a token
  const MixProp.fromToken(
    MixToken<V> token,
    T Function(V) valueToDto, {
    AnimationConfig? animation,
  }) : this._(token: token, mixConverter: valueToDto, animation: animation);

  /// Creates a MixProp with directives only
  const MixProp.fromDirectives(
    List<MixDirective<T>> directives, {
    AnimationConfig? animation,
  }) : this._(directives: directives, animation: animation);

  /// Creates a MixProp with animation only
  const MixProp.fromAnimation(AnimationConfig animation)
    : this._(animation: animation);

  static MixProp<V, T>? maybeValue<V, T extends Mix<V>>(T? value) {
    if (value == null) return null;

    return MixProp.fromValue(value);
  }

  /// Whether this prop has a value
  bool get hasValue => _value != null;

  /// Whether this prop has a token
  bool get hasToken => _token != null;

  /// Get the value directly (null if token-based)
  T? get mixValue => _value;

  /// Get the token directly (null if value-based)
  MixToken<V>? get mixToken => _token;

  /// Get the directives
  List<MixDirective<T>>? get directives => _directives;

  /// Get the animation configuration
  AnimationConfig? get animation => _animation;

  /// CENTRALIZED MERGE LOGIC
  /// Other's value/token wins, merge DTOs if both have values, directives accumulate
  MixProp<V, T> merge(MixProp<V, T>? other) {
    if (other == null) return this;

    final mergedDirectives = switch ((_directives, other._directives)) {
      (null, null) => null,
      (final a?, null) => a, // Only this has directives
      (null, final b?) => b, // Only other has directives
      (final a?, final b?) => [...a, ...b], // Both have directives
    };

    // Animation merging: other's animation wins if present, otherwise keep this one
    final mergedAnimation = other._animation ?? _animation;

    // If both have values, merge the DTOs
    if (other._value != null && _value != null) {
      final merged = _value.merge(other._value) as T;

      return MixProp._(
        value: merged,
        directives: mergedDirectives,
        animation: mergedAnimation,
      );
    }

    // Other's value/token wins
    if (other._value != null) {
      return MixProp._(
        value: other._value,
        directives: mergedDirectives,
        animation: mergedAnimation,
      );
    } else if (other._token != null) {
      return MixProp._(
        token: other._token,
        mixConverter: other._mixConverter,
        directives: mergedDirectives,
        animation: mergedAnimation,
      );
    }

    // Other has only directives, keep this value/token, accumulate directives
    return MixProp._(
      value: _value,
      token: _token,
      mixConverter: _mixConverter,
      directives: mergedDirectives,
      animation: mergedAnimation,
    );
  }

  /// Resolves the value using the provided context
  /// Throws FlutterError if unable to resolve
  @override
  V resolve(MixContext context) {
    T? dto;

    if (_value != null) {
      dto = _value;
    } else if (_token != null) {
      final tokenValue = context.getToken(_token);
      if (tokenValue != null) {
        dto = _mixConverter!(tokenValue);
      }
    }

    if (dto == null) {
      if (hasToken) {
        throw FlutterError(
          'MixProp could not be resolved: Token ${_token ?? 'unknown'} was not found in context',
        );
      }

      throw FlutterError(
        'MixProp could not be resolved: No value or token exists to resolve',
      );
    }

    // Apply directives to DTO before resolving
    T current = dto;
    for (final directive in _directives ?? []) {
      current = directive.apply(current);
    }

    final result = current.resolve(context);
    if (result == null) {
      throw FlutterError(
        'MixProp resolved to null: DTO ${current.runtimeType} returned null from resolve()',
      );
    }

    return result;
  }

  @override
  String toString() {
    final buffer = StringBuffer('MixProp<${V.toString()}, ${T.toString()}>(');
    if (_value != null) {
      buffer.write('$_value');
    } else if (_token != null) {
      buffer.write('token: $_token');
    }
    buffer.write(')');

    return buffer.toString();
  }

  @override
  List<Object?> get props => [
    _value,
    _token,
    _mixConverter,
    _directives,
    _animation,
  ];
}
