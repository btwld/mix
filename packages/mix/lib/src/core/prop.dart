import 'package:flutter/foundation.dart';

import '../internal/compare_mixin.dart';
import '../theme/tokens/mix_token.dart';
import 'factory/mix_context.dart';
import 'mix_element.dart';

/// Simplified Prop that can hold values, tokens, or values with directives
@immutable
sealed class Prop<T> with EqualityMixin {
  const Prop();

  // Factory constructors for different types
  const factory Prop.value(T value) = _ValueProp<T>;
  const factory Prop.token(MixableToken<T> token) = _TokenProp<T>;
  const factory Prop.withDirectives(T value, List<MixDirective<T>> directives) =
      _DirectiveProp<T>;
  const factory Prop.empty() = _EmptyProp<T>;

  static Prop<T>? maybeValue<T>(T? value) {
    if (value == null) return null;

    return Prop.value(value);
  }

  /// Whether this prop has any content
  bool get isEmpty;

  /// Resolves the value using the provided context
  T? resolve(MixContext context);

  /// CENTRALIZED MERGE LOGIC
  /// Merge behavior:
  /// - Empty + Anything = other wins
  /// - Anything + Empty = this wins
  /// - Token + Anything = other wins (tokens are overridden)
  /// - Value + Value = other wins (override)
  /// - Directives accumulate when possible
  Prop<T> merge(Prop<T>? other) {
    if (other == null || other.isEmpty) return this;
    if (isEmpty) return other;

    return switch ((this, other)) {
      // Directive cases - complex merging
      (
        _DirectiveProp(:final baseValue, :final directives),
        _DirectiveProp(baseValue: final otherBase, directives: final otherDirs),
      ) =>
        Prop.withDirectives(otherBase ?? baseValue!, [
          ...directives,
          ...otherDirs,
        ]),

      (_DirectiveProp(:final directives), _ValueProp(:final value)) =>
        Prop.withDirectives(value, directives),

      (
        _ValueProp(:final value),
        _DirectiveProp(:final baseValue, :final directives),
      ) =>
        Prop.withDirectives(baseValue ?? value, directives),

      // Token cases and default case - other always wins
      (_TokenProp(), _) || _ => other,
    };
  }

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Private implementation for direct values
@immutable
final class _ValueProp<T> extends Prop<T> {
  final T value;

  const _ValueProp(this.value);

  @override
  T resolve(MixContext context) => value;

  @override
  get props => [value];

  @override
  bool get isEmpty => false;
}

/// Private implementation for tokens
@immutable
final class _TokenProp<T> extends Prop<T> {
  final MixableToken<T> token;

  const _TokenProp(this.token);

  @override
  T? resolve(MixContext context) => context.getToken(token);

  @override
  List<Object?> get props => [token];

  @override
  bool get isEmpty => false;
}

/// Private implementation for values with directives
@immutable
final class _DirectiveProp<T> extends Prop<T> {
  final T? baseValue;
  final List<MixDirective<T>> directives;

  const _DirectiveProp(this.baseValue, this.directives);

  @override
  T? resolve(MixContext context) {
    if (baseValue == null) return null;

    // Apply directives in order
    var result = baseValue;
    for (final directive in directives) {
      result = directive.apply(result as T);
    }

    return result;
  }

  @override
  bool get isEmpty => false;

  @override
  List<Object?> get props => [baseValue, directives];
}

/// Private implementation for empty/null-like behavior
@immutable
final class _EmptyProp<T> extends Prop<T> {
  const _EmptyProp();

  @override
  T? resolve(MixContext context) => null;

  @override
  List<Object?> get props => [];

  @override
  bool get isEmpty => true;
}

/// MixProp for handling Mix objects (DTOs) with smart merge logic
@immutable
sealed class MixProp<V, T extends Mix<V>> with EqualityMixin {
  const MixProp._();

  // Factory constructors
  const factory MixProp.value(T value) = _ValueMixProp<V, T>;
  const factory MixProp.token(MixableToken<V> token) = _TokenMixProp<V, T>;

  static MixProp<V, T>? maybeValue<V, T extends Mix<V>>(T? value) {
    if (value == null) return null;

    return MixProp.value(value);
  }

  /// Smart grouping: merge consecutive values at the end
  List<_MixPropItem<T, V>> _groupItems(List<_MixPropItem<T, V>> items) {
    if (items.length <= 1) return items;

    // Find last token
    int lastTokenIndex = -1;
    for (int i = items.length - 1; i >= 0; i--) {
      if (items[i] is _TokenPropItem<T, V>) {
        lastTokenIndex = i;
        break;
      }
    }

    // If no tokens, merge all values
    if (lastTokenIndex == -1) {
      final values = items
          .cast<_ValuePropItem<T, V>>()
          .map((e) => e.value)
          .toList();
      final merged = values.fold<T?>(
        null,
        (acc, dto) => (acc?.merge(dto) ?? dto) as T?,
      );

      return merged != null ? [_ValuePropItem(merged)] : [];
    }

    // Keep items up to last token, merge values after
    final beforeToken = items.sublist(0, lastTokenIndex + 1);
    final afterToken = items.sublist(lastTokenIndex + 1);

    if (afterToken.isEmpty) return beforeToken;

    // Merge values after last token
    final values = afterToken
        .cast<_ValuePropItem<T, V>>()
        .map((e) => e.value)
        .toList();
    final merged = values.fold<T?>(
      null,
      (acc, dto) => (acc?.merge(dto) ?? dto) as T?,
    );

    return merged != null
        ? [...beforeToken, _ValuePropItem(merged)]
        : beforeToken;
  }

  /// Internal items for aggregated DTOs
  List<_MixPropItem<T, V>> get _items;

  /// Whether this mix prop has any content
  bool get isEmpty => _items.isEmpty;

  /// Resolves the value using the provided context
  V? resolve(MixContext context) {
    final resolved = <T>[];

    for (final item in _items) {
      final value = item.resolve(context);
      if (value != null) resolved.add(value);
    }

    // Merge all resolved DTOs then resolve to final value
    final merged = resolved.fold<T?>(
      null,
      (acc, dto) => (acc?.merge(dto) ?? dto) as T?,
    );

    return merged?.resolve(context);
  }

  /// CENTRALIZED MERGE - with smart grouping
  MixProp<V, T> merge(MixProp<V, T>? other) {
    if (other == null || other.isEmpty) return this;
    if (isEmpty) return other;

    final newItems = [..._items, ...other._items];
    final groupedItems = _groupItems(newItems);

    return _AggregatedMixProp<V, T>(groupedItems);
  }
}

/// Internal item for MixProp - simplified
@immutable
sealed class _MixPropItem<T extends Mix<V>, V> with EqualityMixin {
  const _MixPropItem();
  T? resolve(MixContext context);
}

/// Private implementation for direct DTO values
@immutable
final class _ValueMixProp<V, T extends Mix<V>> extends MixProp<V, T> {
  final T value;

  const _ValueMixProp(this.value) : super._();

  @override
  List<_MixPropItem<T, V>> get _items => [_ValuePropItem(value)];

  @override
  List<Object?> get props => [value];
}

/// Private implementation for tokens
@immutable
final class _TokenMixProp<V, T extends Mix<V>> extends MixProp<V, T> {
  final MixableToken<V> token;

  const _TokenMixProp(this.token) : super._();

  @override
  List<_MixPropItem<T, V>> get _items => [_TokenPropItem(token)];

  @override
  List<Object?> get props => [token];
}

/// Private implementation for aggregated DTOs
@immutable
final class _AggregatedMixProp<V, T extends Mix<V>> extends MixProp<V, T> {
  final List<_MixPropItem<T, V>> items;

  const _AggregatedMixProp(this.items) : super._();

  @override
  List<_MixPropItem<T, V>> get _items => items;

  @override
  List<Object?> get props => [items];
}

/// Value item implementation
@immutable
final class _ValuePropItem<T extends Mix<V>, V> extends _MixPropItem<T, V> {
  final T value;

  const _ValuePropItem(this.value);

  @override
  T resolve(MixContext context) => value;
  @override
  List<Object?> get props => [value];
}

/// Token item implementation
@immutable
final class _TokenPropItem<T extends Mix<V>, V> extends _MixPropItem<T, V> {
  final MixableToken<V> token;

  const _TokenPropItem(this.token);

  @override
  T? resolve(MixContext context) {
    final value = context.getToken(token);
    if (value == null) return null;

    // Wrap the resolved token value in a Mix object
    return Mix.value(value) as T;
  }

  @override
  List<Object?> get props => [token];
}
