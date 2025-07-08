import 'package:flutter/foundation.dart';

import '../internal/compare_mixin.dart';
import '../theme/tokens/mix_token.dart';
import 'factory/mix_context.dart';
import 'utility.dart';

// Generic directive for modifying values
@immutable
class MixDirective<T> {
  final T Function(T) modify;
  final String? debugLabel;

  const MixDirective(this.modify, {this.debugLabel});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MixDirective<T> &&
          runtimeType == other.runtimeType &&
          debugLabel == other.debugLabel;

  @override
  int get hashCode => debugLabel.hashCode;
}

abstract class StyleElement with EqualityMixin {
  const StyleElement();

  // Used as the key to determine how
  // attributes get merged
  Object get mergeKey => runtimeType;

  /// Merges this object with [other], returning a new object of type [T].
  StyleElement merge(covariant StyleElement? other);
}

// Deprecated typedefs moved to src/core/deprecated.dart

abstract class Mix<Value> with EqualityMixin {
  final List<MixDirective<Value>> directives;

  const Mix({this.directives = const []});

  const factory Mix.value(Value value, {List<MixDirective<Value>> directives}) =
      _ValueMixable<Value>;

  const factory Mix.token(
    MixableToken<Value> token, {
    List<MixDirective<Value>> directives,
  }) = _TokenMixable<Value>;

  const factory Mix.composite(
    List<Mix<Value>> items, {
    List<MixDirective<Value>> directives,
  }) = _CompositeMixable<Value>;

  static Mix<T>? maybeValue<T>(T? value) {
    if (value == null) return null;

    return Mix.value(value);
  }

  /// Gets the underlying value if this is a ValueMixable, otherwise returns null
  Value? get value => this is _ValueMixable<Value>
      ? (this as _ValueMixable<Value>).value
      : null;

  /// Resolves token value if present, otherwise returns null
  Value resolve(MixContext mix);

  /// Apply all directives to the resolved value
  @protected
  Value applyDirectives(Value value) {
    Value result = value;
    for (final directive in directives) {
      result = directive.modify(result);
    }

    return result;
  }

  /// Helper method to merge directives
  @protected
  List<MixDirective<Value>> mergeDirectives(List<MixDirective<Value>> other) {
    return [...directives, ...other];
  }

  Mix<Value> merge(covariant Mix<Value>? other) {
    if (other == null) return this;

    final allDirectives = mergeDirectives(other.directives);

    return switch ((this, other)) {
      (_, _CompositeMixable(:var items)) => Mix.composite([
        ...items,
        this,
      ], directives: allDirectives),
      _ => Mix.composite([this, other], directives: allDirectives),
    };
  }
}

// Private implementations for Mixable<T>
@immutable
class _ValueMixable<T> extends Mix<T> {
  @override
  final T value;

  const _ValueMixable(this.value, {super.directives});

  @override
  T resolve(MixContext mix) => applyDirectives(value);

  @override
  List<Object?> get props => [value, directives];
}

@immutable
class _TokenMixable<T> extends Mix<T> {
  final MixableToken<T> token;

  const _TokenMixable(this.token, {super.directives});

  @override
  T resolve(MixContext mix) =>
      applyDirectives(mix.scope.getToken(token, mix.context));

  @override
  List<Object?> get props => [token, directives];
}

@immutable
class _CompositeMixable<T> extends Mix<T> {
  final List<Mix<T>> items;

  const _CompositeMixable(this.items, {super.directives});

  @override
  T resolve(MixContext mix) {
    // For scalar types, last value wins
    T? result;
    for (final item in items) {
      result = item.resolve(mix);
    }

    if (result == null) {
      throw StateError('CompositeMixable resolved to null - no items provided');
    }

    return applyDirectives(result);
  }

  @override
  Mix<T> merge(Mix<T>? other) {
    if (other == null) return this;

    final allDirectives = mergeDirectives(other.directives);

    return Mix.composite([...items, other], directives: allDirectives);
  }

  @override
  List<Object?> get props => [items, directives];
}

final class MixableList<T extends Mix<Value>, Value> extends Mix<List<Value>> {
  final List<T> _items;

  const MixableList(this._items);

  int get length => _items.length;

  @override
  List<Value> resolve(MixContext mix) {
    return _items.map((item) => item.resolve(mix)).toList();
  }

  // merge
  @override
  MixableList<T, Value> merge(MixableList<T, Value>? other) {
    if (other == null) return this;

    return MixableList([..._items, ...other._items]);
  }

  @override
  List<Object?> get props => [_items];
}

// Define a mixin for properties that have default values
// TODO: Rename this to MixableDefaultValueMixin or similar
mixin HasDefaultValue<Value> {
  @protected
  Value get defaultValue;
}

abstract class DtoUtility<A extends StyleElement, D extends Mix<Value>, Value>
    extends MixUtility<A, D> {
  final D Function(Value) fromValue;
  const DtoUtility(super.builder, {required D Function(Value) valueToDto})
    : fromValue = valueToDto;

  A only();

  A as(Value value) => builder(fromValue(value));
}

/// A wrapper around Mixable that provides cleaner merge APIs for DTO properties.
/// This encapsulates value/token/composite logic and simplifies DTO implementations.
/// MixableProperty is always nullable - resolve() always returns T?
@immutable
class MixProperty<T extends Object> with EqualityMixin {
  final Mix<T>? _mixable;

  const MixProperty([this._mixable]);

  /// Creates a MixableProperty from a concrete value (can be null)
  factory MixProperty.prop(T? value) => MixProperty(Mix.maybeValue(value));

  /// Creates a MixableProperty from a token
  /// Note: We need a nullable token wrapper to handle the type mismatch
  factory MixProperty.token(MixableToken<T> token) {
    return MixProperty(Mix.token(token));
  }

  /// Creates a MixableProperty from a nullable value

  /// Gets the underlying value if this wraps a ValueMixable
  T? get value => _mixable?.value;

  /// Resolves the value using the MixContext - always returns nullable
  T? resolve(MixContext mix) => _mixable?.resolve(mix);

  /// Merges this property with another, creating a composite
  MixProperty<T> merge(MixProperty<T> other) {
    return MixProperty(_mixable?.merge(other._mixable));
  }

  @override
  List<Object?> get props => [_mixable];
}
