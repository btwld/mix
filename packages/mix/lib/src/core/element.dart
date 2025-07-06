import 'package:flutter/foundation.dart';

import '../internal/compare_mixin.dart';
import '../theme/tokens/mix_token.dart';
import 'factory/mix_context.dart';
import 'utility.dart';

// Generic directive for modifying values
@immutable
class MixableDirective<T> {
  final T Function(T) modify;
  final String? debugLabel;

  const MixableDirective(this.modify, {this.debugLabel});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MixableDirective<T> &&
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

abstract class Mixable<Value> with EqualityMixin {
  final List<MixableDirective<Value>> directives;

  const Mixable({this.directives = const []});

  const factory Mixable.value(
    Value value, {
    List<MixableDirective<Value>> directives,
  }) = _ValueMixable<Value>;

  const factory Mixable.token(
    MixableToken<Value> token, {
    List<MixableDirective<Value>> directives,
  }) = _TokenMixable<Value>;

  const factory Mixable.composite(
    List<Mixable<Value>> items, {
    List<MixableDirective<Value>> directives,
  }) = _CompositeMixable<Value>;

  static Mixable<T>? maybeValue<T>(T? value) {
    if (value == null) return null;

    return Mixable.value(value);
  }

  /// Resolves token value if present, otherwise returns null
  Value resolve(MixContext mix);

  /// Merges this mixable with another
  Mixable<Value> merge(covariant Mixable<Value>? other);

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
  List<MixableDirective<Value>> mergeDirectives(
    List<MixableDirective<Value>> other,
  ) {
    return [...directives, ...other];
  }
}

// Private implementations for Mixable<T>
@immutable
class _ValueMixable<T> extends Mixable<T> {
  final T value;

  const _ValueMixable(this.value, {super.directives});

  @override
  T resolve(MixContext mix) => applyDirectives(value);

  @override
  Mixable<T> merge(Mixable<T>? other) {
    if (other == null) return this;

    final allDirectives = mergeDirectives(other.directives);

    return switch ((this, other)) {
      (_, _CompositeMixable(:var items)) => Mixable.composite([
        ...items,
        this,
      ], directives: allDirectives),
      _ => Mixable.composite([this, other], directives: allDirectives),
    };
  }

  @override
  List<Object?> get props => [value, directives];
}

@immutable
class _TokenMixable<T> extends Mixable<T> {
  final MixableToken<T> token;

  const _TokenMixable(this.token, {super.directives});

  @override
  T resolve(MixContext mix) =>
      applyDirectives(mix.scope.getToken(token, mix.context));

  @override
  Mixable<T> merge(Mixable<T>? other) {
    if (other == null) return this;

    final allDirectives = mergeDirectives(other.directives);

    return switch ((this, other)) {
      (_, _CompositeMixable(:var items)) => Mixable.composite([
        ...items,
        this,
      ], directives: allDirectives),
      _ => Mixable.composite([this, other], directives: allDirectives),
    };
  }

  @override
  List<Object?> get props => [token, directives];
}

@immutable
class _CompositeMixable<T> extends Mixable<T> {
  final List<Mixable<T>> items;

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
  Mixable<T> merge(Mixable<T>? other) {
    if (other == null) return this;

    final allDirectives = mergeDirectives(other.directives);

    return Mixable.composite([...items, other], directives: allDirectives);
  }

  @override
  List<Object?> get props => [items, directives];
}

// Define a mixin for properties that have default values
mixin HasDefaultValue<Value> {
  @protected
  Value get defaultValue;
}

abstract class DtoUtility<
  A extends StyleElement,
  D extends Mixable<Value>,
  Value
>
    extends MixUtility<A, D> {
  final D Function(Value) fromValue;
  const DtoUtility(super.builder, {required D Function(Value) valueToDto})
    : fromValue = valueToDto;

  A only();

  A as(Value value) => builder(fromValue(value));
}

/// A unified utility base class that works with Mixable<Value>.
///
/// This class provides a consistent API for all utilities by working directly
/// with Mixable<Value> instead of raw values or custom DTOs.
abstract class NewMixUtility<A extends StyleElement, Value>
    extends MixUtility<A, Mixable<Value>> {
  const NewMixUtility(super.builder);

  /// Creates a StyleElement from a raw value by wrapping it in Mixable.value()
  A call(Value value) => builder(Mixable.value(value));

  /// Creates a StyleElement from a token by wrapping it in Mixable.token()
  A token(MixableToken<Value> token) => builder(Mixable.token(token));

  /// Creates a StyleElement from a composite of mixables
  A composite(List<Mixable<Value>> items) => builder(Mixable.composite(items));

  /// For complex utilities with multiple properties - should be overridden
  /// when the utility needs to support partial construction
  A only() => throw UnimplementedError(
    'only() method not implemented for $runtimeType. '
    'Override this method if the utility supports partial construction.',
  );
}
