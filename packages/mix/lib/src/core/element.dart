import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Color, Radius;

import '../internal/compare_mixin.dart';
import '../theme/tokens/mix_token.dart';
import 'factory/mix_context.dart';

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
      _ValueMix<Value>;

  const factory Mix.token(
    MixableToken<Value> token, {
    List<MixDirective<Value>> directives,
  }) = _TokenMix<Value>;

  const factory Mix.composite(
    List<Mix<Value>> items, {
    List<MixDirective<Value>> directives,
  }) = _CompositeMix<Value>;

  static Mix<T>? maybeValue<T>(T? value) {
    if (value == null) return null;

    return Mix.value(value);
  }

  /// Gets the underlying value if this is a ValueMixable, otherwise returns null
  Value? get value =>
      this is _ValueMix<Value> ? (this as _ValueMix<Value>).value : null;

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
      (_, _CompositeMix(:var items)) => Mix.composite([
        ...items,
        this,
      ], directives: allDirectives),
      _ => Mix.composite([this, other], directives: allDirectives),
    };
  }
}

// Private implementations for Mixable<T>
@immutable
class _ValueMix<T> extends Mix<T> {
  @override
  final T value;

  const _ValueMix(this.value, {super.directives});

  @override
  T resolve(MixContext mix) => applyDirectives(value);

  @override
  List<Object?> get props => [value, directives];
}

@immutable
class _TokenMix<T> extends Mix<T> {
  final MixableToken<T> token;

  const _TokenMix(this.token, {super.directives});

  @override
  T resolve(MixContext mix) =>
      applyDirectives(mix.scope.getToken(token, mix.context));

  @override
  List<Object?> get props => [token, directives];
}

@immutable
class _CompositeMix<T> extends Mix<T> {
  final List<Mix<T>> items;

  const _CompositeMix(this.items, {super.directives});

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

// Specific Mix implementations for common types
@immutable
class StringMix extends _ValueMix<String> {
  const StringMix(super.value, {super.directives});
}

@immutable
class DoubleMix extends _ValueMix<double> {
  const DoubleMix(super.value, {super.directives});
}

@immutable
class IntMix extends _ValueMix<int> {
  const IntMix(super.value, {super.directives});
}

@immutable
class BoolMix extends _ValueMix<bool> {
  const BoolMix(super.value, {super.directives});
}

@immutable
class ColorMix extends _ValueMix<Color> {
  const ColorMix(super.value, {super.directives});
}

// RadiusMix and EnumMix only support values, not tokens
@immutable
class RadiusMix extends _ValueMix<Radius> {
  const RadiusMix(super.value, {super.directives});
}

@immutable
class EnumMix<T extends Enum> extends _ValueMix<T> {
  const EnumMix(super.value, {super.directives});
}

/// A wrapper around Mix that provides cleaner merge APIs for DTO properties.
/// This encapsulates value/token/composite logic and simplifies DTO implementations.
/// MixProperty always contains at least one Mix internally.
/// When used in DTOs and SpecAttributes, the property itself should be nullable (MixProperty<T>?)
@immutable
class MixProperty<T extends Object> with EqualityMixin {
  final Mix<T> _mixable;

  /// Creates a MixProperty with the given Mix.
  /// If no Mix is provided, creates an empty composite Mix.
  const MixProperty([Mix<T>? mixable])
    : _mixable = mixable ?? const Mix.composite([]);

  /// Creates a MixProperty from a concrete value (can be null)
  factory MixProperty.value(T? value) {
    return value == null ? const MixProperty() : MixProperty(Mix.value(value));
  }

  factory MixProperty.prop(T? value) {
    return value == null ? const MixProperty() : MixProperty(Mix.value(value));
  }

  /// Creates a MixProperty from a token
  factory MixProperty.token(MixableToken<T> token) {
    return MixProperty(Mix.token(token));
  }

  /// Gets the underlying value if this wraps a ValueMix
  T? get value => _mixable.value;

  /// Resolves the value using the MixContext - always returns nullable
  T? resolve(MixContext mix) => _mixable.resolve(mix);

  /// Merges this property with another, creating a composite
  MixProperty<T> merge(MixProperty<T> other) {
    return MixProperty(_mixable.merge(other._mixable));
  }

  @override
  List<Object?> get props => [_mixable];
}
