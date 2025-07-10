import 'package:flutter/foundation.dart';

import '../theme/tokens/mix_token.dart';
import 'factory/mix_context.dart';
import 'mix_element.dart';

/// Simplified MixValue that can hold values, tokens, or values with directives
@immutable
abstract class Prop<T> {
  const Prop();

  // Factory constructors for different types
  const factory Prop.value(T value) = _ValueMix<T>;
  const factory Prop.token(MixableToken<T> token) = _TokenMix<T>;
  const factory Prop.withDirectives(T value, List<MixDirective<T>> directives) =
      _DirectiveMix<T>;

  // Empty constructor for null-like behavior
  const factory Prop.empty() = _EmptyMix<T>;

  static Prop<T>? maybeValue<T>(T? value) {
    if (value == null) return null;

    return Prop.value(value);
  }

  /// Whether this mix value has any content
  bool get isEmpty;

  /// Resolves the value using the provided context
  T? resolve(MixContext context);

  /// Merges this MixValue with another
  ///
  /// Merge behavior:
  /// - Value + Value = other wins (override)
  /// - Token + Token = other wins (override)
  /// - Value + Token = other wins (token takes precedence)
  /// - Directives accumulate (both are applied)
  /// - Empty + Anything = other wins
  Prop<T> merge(Prop<T>? other);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Private implementation for direct values
@immutable
class _ValueMix<T> extends Prop<T> {
  final T value;

  const _ValueMix(this.value);

  @override
  T resolve(MixContext context) => value;

  @override
  Prop<T> merge(Prop<T>? other) {
    if (other == null || other.isEmpty) return this;

    // If other has directives and is value-based, merge them
    if (other is _DirectiveMix<T>) {
      return Prop.withDirectives(other.baseValue ?? value, other.directives);
    }

    // Otherwise, other wins
    return other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ValueMix<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  bool get isEmpty => false;

  @override
  int get hashCode => value.hashCode;
}

/// Private implementation for tokens
@immutable
class _TokenMix<T> extends Prop<T> {
  final MixableToken<T> token;

  const _TokenMix(this.token);

  @override
  T? resolve(MixContext context) {
    return context.getToken(token);
  }

  @override
  Prop<T> merge(Prop<T>? other) {
    if (other == null || other.isEmpty) return this;

    // Other always wins in token scenarios
    return other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TokenMix<T> &&
          runtimeType == other.runtimeType &&
          token == other.token;

  @override
  bool get isEmpty => false;

  @override
  int get hashCode => token.hashCode;
}

/// Private implementation for values with directives
@immutable
class _DirectiveMix<T> extends Prop<T> {
  final T? baseValue;
  final List<MixDirective<T>> directives;

  const _DirectiveMix(this.baseValue, this.directives);

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
  Prop<T> merge(Prop<T>? other) {
    if (other == null || other.isEmpty) return this;

    // If other also has directives, combine them
    if (other is _DirectiveMix<T>) {
      return Prop.withDirectives(other.baseValue ?? baseValue!, [
        ...directives,
        ...other.directives,
      ]);
    }

    // If other is a value, use it as new base with our directives
    if (other is _ValueMix<T>) {
      return Prop.withDirectives(other.value, directives);
    }

    // For tokens, other wins completely
    return other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _DirectiveMix<T> &&
          runtimeType == other.runtimeType &&
          baseValue == other.baseValue &&
          listEquals(directives, other.directives);

  @override
  bool get isEmpty => false;

  @override
  int get hashCode => Object.hash(baseValue, Object.hashAll(directives));
}

/// Private implementation for empty/null-like behavior
@immutable
class _EmptyMix<T> extends Prop<T> {
  const _EmptyMix();

  @override
  T? resolve(MixContext context) => null;

  @override
  Prop<T> merge(Prop<T>? other) => other ?? this;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _EmptyMix<T> && runtimeType == other.runtimeType;

  @override
  bool get isEmpty => true;

  @override
  int get hashCode => 0;
}

/// MixableDto for handling Mix objects (DTOs) with smart merge logic
@immutable
sealed class MixProp<T extends Mix<V>, V> {
  const MixProp._();

  // Factory constructors
  const factory MixProp.value(T value) = _ValueMixDto<T, V>;
  const factory MixProp.token(MixableToken<T> token) = _TokenMixDto<T, V>;

  static MixProp<T, V>? maybeValue<T extends Mix<V>, V>(T? value) {
    if (value == null) return null;

    return MixProp.value(value);
  }

  /// Smart grouping: merge consecutive values at the end
  List<_MixableItem<T>> _groupItems(List<_MixableItem<T>> items) {
    if (items.length <= 1) return items;

    // Find consecutive values at the end
    int lastTokenIndex = -1;
    for (int i = items.length - 1; i >= 0; i--) {
      if (items[i].isToken) {
        lastTokenIndex = i;
        break;
      }
    }

    // If no tokens found, or all items after last token are values
    if (lastTokenIndex == -1) {
      // All items are values - merge them all
      final values = items.cast<_ValueItem<T>>().map((e) => e.value).toList();
      final merged = values.fold<T?>(
        null,
        (acc, dto) => (acc?.merge(dto) ?? dto) as T?,
      );

      return merged != null ? [_ValueItem(merged)] : [];
    }

    // Keep items up to last token, merge values after
    final beforeToken = items.sublist(0, lastTokenIndex + 1);
    final afterToken = items.sublist(lastTokenIndex + 1);

    if (afterToken.isEmpty) {
      return beforeToken;
    }

    // Merge values after last token
    final values = afterToken
        .cast<_ValueItem<T>>()
        .map((e) => e.value)
        .toList();
    final merged = values.fold<T?>(
      null,
      (acc, dto) => (acc?.merge(dto) ?? dto) as T?,
    );

    return merged != null ? [...beforeToken, _ValueItem(merged)] : beforeToken;
  }

  /// Internal items for aggregated DTOs
  List<_MixableItem<T>> get _items;

  /// Whether this mix dto has any content
  bool get isEmpty => _items.isEmpty;

  /// Resolves the value using the provided context
  /// 1. Resolves all tokens to their DTO values
  /// 2. Merges all DTOs together
  /// 3. Resolves the final merged DTO
  T? resolve(MixContext context) {
    final resolved = <T>[];

    for (final item in _items) {
      final value = item.resolveItem(context);
      if (value != null) resolved.add(value);
    }

    // Merge all resolved DTOs
    return resolved.fold<T?>(
      null,
      (acc, dto) => (acc?.merge(dto) ?? dto) as T?,
    );
  }

  /// Merges this MixableDto with another using smart grouping
  /// Values at the end of the sequence are merged together
  /// Tokens remain separate for later resolution
  MixProp<T, V> merge(MixProp<T, V>? other) {
    if (other == null || other.isEmpty) return this;

    final newItems = [..._items, ...other._items];

    // Apply smart grouping: merge consecutive values at the end
    final groupedItems = _groupItems(newItems);

    return _AggregatedMixDto<T, V>(groupedItems);
  }
}

/// Internal item for MixableDto
@immutable
sealed class _MixableItem<T extends Mix> {
  const _MixableItem();

  bool get isToken;
  T? resolveItem(MixContext context);
}

/// Private implementation for direct DTO values
@immutable
class _ValueMixDto<T extends Mix<V>, V> extends MixProp<T, V> {
  final T value;

  const _ValueMixDto(this.value) : super._();

  @override
  List<_MixableItem<T>> get _items => [_ValueItem(value)];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ValueMixDto<T, V> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Private implementation for tokens
@immutable
class _TokenMixDto<T extends Mix<V>, V> extends MixProp<T, V> {
  final MixableToken<T> token;

  const _TokenMixDto(this.token) : super._();

  @override
  List<_MixableItem<T>> get _items => [_TokenItem(token)];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TokenMixDto<T, V> &&
          runtimeType == other.runtimeType &&
          token == other.token;

  @override
  int get hashCode => token.hashCode;
}

/// Private implementation for aggregated DTOs with smart grouping
@immutable
class _AggregatedMixDto<T extends Mix<V>, V> extends MixProp<T, V> {
  final List<_MixableItem<T>> items;

  const _AggregatedMixDto(this.items) : super._();

  @override
  List<_MixableItem<T>> get _items => items;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _AggregatedMixDto<T, V> &&
          runtimeType == other.runtimeType &&
          listEquals(items, other.items);

  @override
  int get hashCode => Object.hashAll(items);
}

/// Private implementation for value items
@immutable
class _ValueItem<T extends Mix> extends _MixableItem<T> {
  final T value;

  const _ValueItem(this.value);

  @override
  T resolveItem(MixContext context) => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ValueItem<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  bool get isToken => false;

  @override
  int get hashCode => value.hashCode;
}

/// Private implementation for token items
@immutable
class _TokenItem<T extends Mix> extends _MixableItem<T> {
  final MixableToken<T> token;

  const _TokenItem(this.token);

  @override
  T? resolveItem(MixContext context) => context.getToken(token);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TokenItem<T> &&
          runtimeType == other.runtimeType &&
          token == other.token;

  @override
  bool get isToken => true;

  @override
  int get hashCode => token.hashCode;
}
