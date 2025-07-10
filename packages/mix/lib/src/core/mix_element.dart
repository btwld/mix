import 'package:flutter/widgets.dart';

import '../internal/compare_mixin.dart';
import 'factory/mix_context.dart';
import 'prop.dart';

// Generic directive for modifying values
@immutable
class MixDirective<T> {
  final T Function(T) apply;
  final String? debugLabel;

  const MixDirective(this.apply, {this.debugLabel});

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

mixin MergeableMixin<Self> {
  /// Merges this object with [other], returning a new object of type [Self].
  Self merge(covariant Self? other);
}

mixin ResolvableMixin<T> {
  /// Resolves to the concrete value using the provided context.
  T resolve(MixContext mix);
}

/// Simple value Mix - holds a direct value
@immutable
abstract class Mix<T> with EqualityMixin {
  const Mix();

  /// Resolves to the concrete value using the provided context
  T resolve(MixContext mix);

  /// Merges this mix with another mix, returning a new mix.
  Mix<T> merge(covariant Mix<T>? other);

  @protected
  V? resolveProp<V>(MixContext context, Prop<V>? prop) {
    return prop?.resolve(context);
  }

  @protected
  Prop<V>? mergeProp<V>(Prop<V>? a, Prop<V>? b) {
    return a?.merge(b) ?? b;
  }

  @protected
  List<V>? resolvePropList<V>(MixContext context, List<Prop<V>>? list) {
    if (list == null || list.isEmpty) return null;

    final resolved = <V>[];
    for (final item in list) {
      final value = item.resolve(context);
      if (value != null) resolved.add(value);
    }

    return resolved.isEmpty ? null : resolved;
  }

  @protected
  List<R>? resolveMixPropList<R, D extends Mix<R>>(
    MixContext context,
    List<MixProp<R, D>>? list,
  ) {
    if (list == null || list.isEmpty) return null;

    final resolved = <R>[];
    for (final mixProp in list) {
      final value = mixProp.resolve(context);
      if (value != null) resolved.add(value);
    }

    return resolved.isEmpty ? null : resolved;
  }

  @protected
  List<Prop<V>>? mergePropList<V>(
    List<Prop<V>>? a,
    List<Prop<V>>? b, {
    ListMergeStrategy strategy = ListMergeStrategy.append,
  }) {
    if (a == null) return b;
    if (b == null) return a;

    switch (strategy) {
      case ListMergeStrategy.append:
        return [...a, ...b];

      case ListMergeStrategy.replace:
        // Merge in place - b items override a items at same index
        final result = List<Prop<V>>.of(a);
        for (int i = 0; i < b.length; i++) {
          if (i < result.length) {
            result[i] = result[i].merge(b[i]);
          } else {
            result.add(b[i]);
          }
        }

        return result;

      case ListMergeStrategy.override:
        return b;
    }
  }

  @protected
  List<MixProp<R, D>>? mergeMixPropList<R, D extends Mix<R>>(
    List<MixProp<R, D>>? a,
    List<MixProp<R, D>>? b, {
    ListMergeStrategy strategy = ListMergeStrategy.append,
  }) {
    if (a == null) return b;
    if (b == null) return a;

    switch (strategy) {
      case ListMergeStrategy.append:
        return [...a, ...b];

      case ListMergeStrategy.replace:
        final result = List<MixProp<R, D>>.of(a);
        for (int i = 0; i < b.length; i++) {
          if (i < result.length) {
            result[i] = result[i].merge(b[i]);
          } else {
            result.add(b[i]);
          }
        }

        return result;

      case ListMergeStrategy.override:
        return b;
    }
  }

  /// Creates a Mix that wraps the given value
  static Mix<T> value<T>(T value) => _MixableValue(value);
}

/// Simple Mix implementation that wraps a value
@immutable
final class _MixableValue<T> extends Mix<T> {
  final T _value;

  const _MixableValue(this._value);

  @override
  T resolve(MixContext mix) => _value;

  @override
  Mix<T> merge(covariant Mix<T>? other) => other ?? this;

  @override
  List<Object?> get props => [_value];
}

/// Merge strategy for lists
enum ListMergeStrategy {
  /// Append items from other list (default)
  append,

  /// Replace items at same index
  replace,

  /// Override entire list
  override,
}

// Define a mixin for properties that have default values
// TODO: Rename this to DefaultValueMixin or similar
mixin HasDefaultValue<Value> {
  @protected
  Value get defaultValue;
}
