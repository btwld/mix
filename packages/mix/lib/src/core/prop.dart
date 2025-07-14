import 'package:flutter/foundation.dart';

import '../internal/compare_mixin.dart';
import '../theme/tokens/mix_token.dart';
import 'factory/mix_context.dart';
import 'mix_element.dart';

/// Simplified Prop that can hold values or tokens with optional directives
@immutable
class Prop<T> with EqualityMixin, ResolvableMixin<T?> {
  final T? _value;
  final MixableToken<T>? _token;
  final List<MixDirective<T>> _directives;

  const Prop._internal(this._value, this._token, this._directives);

  /// Creates a prop with a direct value
  const Prop.value(T value)
    : _value = value,
      _token = null,
      _directives = const [];

  /// Creates a prop with a token
  const Prop.token(MixableToken<T> token)
    : _value = null,
      _token = token,
      _directives = const [];

  /// Creates a prop with directives only
  const Prop.directives(List<MixDirective<T>> directives)
    : _value = null,
      _token = null,
      _directives = directives;

  static Prop<T>? maybeValue<T>(T? value) {
    if (value == null) return null;

    return Prop.value(value);
  }

  T? get value => _value;

  MixableToken<T>? get token => _token;

  /// Whether this prop has any content
  bool get isEmpty => _value == null && _token == null && _directives.isEmpty;

  /// Whether this prop has a value
  bool get hasValue => _value != null;

  /// Whether this prop has a token
  bool get hasToken => _token != null;

  /// Get the directives
  List<MixDirective<T>> get directives => _directives;

  /// CENTRALIZED MERGE LOGIC
  /// Merge behavior:
  /// - Empty + Anything = other wins
  /// - Anything + Empty = this wins
  /// - Other's value/token wins when present, directives always accumulate
  /// - If other has only directives, this value/token wins, directives accumulate
  Prop<T> merge(Prop<T>? other) {
    if (other == null || other.isEmpty) return this;
    if (isEmpty) return other;

    final mergedDirectives = [..._directives, ...other._directives];

    // Other's base value/token wins when present, but directives accumulate
    if (other._value != null) {
      return Prop._internal(other._value, null, mergedDirectives);
    }
    if (other._token != null) {
      return Prop._internal(null, other._token, mergedDirectives);
    }

    // Other has only directives, keep this value/token, accumulate directives
    return Prop._internal(_value, _token, mergedDirectives);
  }

  /// Resolves the value using the provided context
  @override
  T? resolve(MixContext context) {
    T? result;

    if (_value != null) {
      result = _value;
    } else if (_token != null) {
      result = context.getToken(_token);
    }

    // Apply directives to resolved value
    if (result != null) {
      T current = result;
      for (final directive in _directives) {
        current = directive.apply(current);
      }
      result = current;
    }

    return result;
  }

  @override
  List<Object?> get props => [_value, _token, _directives];
}

/// MixProp for handling Mix objects (DTOs) with simplified logic
@immutable
class MixProp<V, T extends Mix<V>> with EqualityMixin, ResolvableMixin<V> {
  final T? _value;
  final MixableToken<V>? _token;
  final T Function(V)? _valueToDto;

  /// Creates a MixProp with a direct value
  const MixProp.value(T value)
    : _value = value,
      _token = null,
      _valueToDto = null;

  /// Creates a MixProp with a token
  const MixProp.token(MixableToken<V> token, T Function(V) valueToDto)
    : _value = null,
      _token = token,
      _valueToDto = valueToDto;

  static MixProp<V, T>? maybeValue<V, T extends Mix<V>>(T? value) {
    if (value == null) return null;

    return MixProp.value(value);
  }

  /// Whether this mix prop has any content
  bool get isEmpty => _value == null && _token == null;

  /// Whether this prop has a value
  bool get hasValue => _value != null;

  /// Whether this prop has a token
  bool get hasToken => _token != null;

  /// Get the value directly (null if token-based)
  T? get value => _value;

  /// Get the token directly (null if value-based)
  MixableToken<V>? get token => _token;

  /// CENTRALIZED MERGE LOGIC
  /// Other's value/token wins, merge DTOs if both have values
  MixProp<V, T> merge(MixProp<V, T>? other) {
    if (other == null || other.isEmpty) return this;
    if (isEmpty) return other;

    // If both have values, merge the DTOs
    if (other._value != null && _value != null) {
      final merged = _value.merge(other._value) as T;

      return MixProp.value(merged);
    }

    // Other's value/token wins
    if (other._value != null) {
      return MixProp.value(other._value);
    } else if (other._token != null) {
      return MixProp.token(other._token, other._valueToDto!);
    }

    return this;
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
        dto = _valueToDto!(tokenValue);
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

    final result = dto.resolve(context);
    if (result == null) {
      throw FlutterError(
        'MixProp resolved to null: DTO ${dto.runtimeType} returned null from resolve()',
      );
    }

    return result;
  }

  @override
  List<Object?> get props => [_value, _token, _valueToDto];
}
