import 'package:flutter/widgets.dart';

import '../internal/compare_mixin.dart';
import 'factory/mix_context.dart';
import 'mix_value.dart';

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
  V? resolveValue<V>(MixContext context, Mixable<V>? mix) {
    return mix?.resolve(context);
  }

  @protected
  Mixable<V>? mergeValue<V>(Mixable<V>? a, Mixable<V>? b) {
    return (a?.merge(b) ?? b);
  }

  @protected
  List<V>? resolveList<V>(MixContext context, List<Mixable<V>>? list) {
    if (list == null || list.isEmpty) return null;

    final resolved = <V>[];
    for (final item in list) {
      final value = item.resolve(context);
      if (value != null) resolved.add(value);
    }

    return resolved.isEmpty ? null : resolved;
  }

  @protected
  List<W>? resolveDtoList<X extends MixableDto<V, W>, V extends Mix<W>, W>(
    MixContext context,
    List<X>? list,
  ) {
    return list?.map((dto) => dto.resolve(context)).whereType<W>().toList();
  }

  @protected
  List<Mixable<V>>? mergeValueList<V>(
    List<Mixable<V>>? a,
    List<Mixable<V>>? b, {
    ListMergeStrategy strategy = ListMergeStrategy.append,
  }) {
    if (a == null) return b;
    if (b == null) return a;

    switch (strategy) {
      case ListMergeStrategy.append:
        return [...a, ...b];

      case ListMergeStrategy.replace:
        // Merge in place - b items override a items at same index
        final result = List<Mixable<V>>.of(a);
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
  List<X>? mergeDtoList<X extends MixableDto<V, W>, V extends Mix<W>, W>(
    List<X>? a,
    List<X>? b, {
    ListMergeStrategy strategy = ListMergeStrategy.append,
  }) {
    if (a == null) return b;
    if (b == null) return a;

    switch (strategy) {
      case ListMergeStrategy.append:
        return [...a, ...b];

      case ListMergeStrategy.replace:
        final result = List<X>.of(a);
        for (int i = 0; i < b.length; i++) {
          if (i < result.length) {
            result[i] = result[i].merge(b[i]) as X;
          } else {
            result.add(b[i]);
          }
        }

        return result;

      case ListMergeStrategy.override:
        return b;
    }
  }
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
// TODO: Rename this to MixableDefaultValueMixin or similar
mixin HasDefaultValue<Value> {
  @protected
  Value get defaultValue;
}
