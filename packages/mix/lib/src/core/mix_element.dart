import 'package:flutter/widgets.dart';

import '../attributes/animation/animation_config.dart';
import '../internal/compare_mixin.dart';
import 'factory/mix_context.dart';
import 'modifier.dart';
import 'prop.dart';
import 'spec.dart';
import 'variant.dart';

// Generic directive for modifying values
@immutable
abstract class MixDirective<T> {
  const MixDirective();

  /// Debug label for the directive
  String? get debugLabel;

  /// Applies the transformation to the given value
  T apply(T value);
}

/// Mixin for classes that can resolve to a value using MixContext
mixin ResolvableMixin<T> {
  /// Resolves this instance to a value using the provided context
  T resolve(MixContext context);
}

// Mixin that provides Mix helper methods to StyleElement classes
mixin MixHelperMixin {
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

  // mergeMixProp merges two V extend Mix
  @protected
  MixProp<V, D>? mergeMixProp<V, D extends Mix<V>>(
    MixProp<V, D>? a,
    MixProp<V, D>? b,
  ) {
    if (a == null) return b;
    if (b == null) return a;

    return a.merge(b);
  }

  // resolve mix prop to value
  @protected
  V? resolveMixProp<V, D extends Mix<V>>(
    MixContext context,
    MixProp<V, D>? prop,
  ) {
    return prop?.resolve(context);
  }

  @protected
  List<Prop<V>>? mergePropList<V>(
    List<Prop<V>>? a,
    List<Prop<V>>? b, {
    ListMergeStrategy strategy = ListMergeStrategy.replace,
  }) {
    if (a == null) return b;
    if (b == null) return a;

    switch (strategy) {
      case ListMergeStrategy.append:
        return [...a, ...b];
      case ListMergeStrategy.replace:
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
    ListMergeStrategy strategy = ListMergeStrategy.replace,
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
}

abstract class StyleElement {
  const StyleElement();

  /// Unique key used for merging elements of the same type
  Object get mergeKey;

  StyleElement merge(covariant StyleElement? other);
}

abstract class SpecStyle<V, T extends SpecAttribute<V>> extends StyleElement {
  final T attribute;
  final Map<Variant, SpecStyle<V, T>> variants;
  final AnimationConfig? animation;
  final List<WidgetModifierSpecAttribute>? modifiers;

  const SpecStyle({
    required this.attribute,
    this.variants = const {},
    this.animation,
    this.modifiers,
  });

  @override
  Object get mergeKey => runtimeType;

  /// Get matching context variants sorted by priority
  List<SpecStyle<V, T>> _getMatchingContextVariants(MixContext context) {
    final contextVariants = variants.entries
        .where(
          (entry) =>
              entry.key is ContextVariant &&
              (entry.key as ContextVariant).when(context.context),
        )
        .toList();

    // Sort by priority: normal (0) first, then high (1)
    contextVariants.sort((a, b) {
      final aPriority = a.key is WidgetStateVariant ? 1 : 0;
      final bPriority = b.key is WidgetStateVariant ? 1 : 0;

      return aPriority.compareTo(bPriority);
    });

    return contextVariants.map((entry) => entry.value).toList();
  }

  /// Merge modifiers helper
  List<WidgetModifierSpecAttribute>? _mergeModifiers(
    List<WidgetModifierSpecAttribute>? current,
    List<WidgetModifierSpecAttribute>? other,
  ) {
    if (other == null) return current;
    if (current == null) return other;

    return [...current, ...other];
  }

  @protected
  /// Abstract factory method for creating new instances
  SpecStyle<V, T> createStyle({
    required T attribute,
    AnimationConfig? animation,
    List<WidgetModifierSpecAttribute>? modifiers,
    Map<Variant, SpecStyle<V, T>> variants,
  });

  /// Generic resolve method that applies context variants recursively
  ResolvedStyleElement<V> resolve(MixContext context) {
    SpecStyle<V, T> currentStyle = this;

    // Get matching context variants sorted by priority
    final styleVariants = _getMatchingContextVariants(context);

    // Apply each matching context variant
    for (final style in styleVariants) {
      currentStyle = currentStyle.merge(style);
    }

    return ResolvedStyleElement(
      spec: currentStyle.attribute.resolve(context),
      animation: currentStyle.animation,
      modifiers:
          currentStyle.modifiers?.map((e) => e.resolve(context)).toList()
              as List<WidgetModifierSpec>?,
    );
  }

  /// Generic withNamedVariants method - reusable across all SpecStyle types
  SpecStyle<V, T> withNamedVariants(Set<NamedVariant> appliedVariants) {
    if (appliedVariants.isEmpty) return this;

    // Start with current style
    SpecStyle<V, T> result = this;

    // Apply each matching named variant by merging the entire style
    for (final variant in appliedVariants) {
      final variantStyle = variants[variant];
      if (variantStyle != null) {
        // Merge the entire variant style, not individual properties
        result = result.merge(variantStyle);
      }
    }

    return result;
  }

  @override
  SpecStyle<V, T> merge(covariant SpecStyle<V, T>? other);
}

/// Result of Style.resolve() containing fully resolved styling data
/// Generic type parameter T for the resolved SpecAttribute
class ResolvedStyleElement<V> {
  final V spec; // Resolved spec
  final AnimationConfig? animation; // Animation config
  final List<WidgetModifierSpec>? modifiers; // Modifiers config

  const ResolvedStyleElement({
    required this.spec,
    this.animation,
    this.modifiers,
  });
}

/// Simple value Mix - holds a direct value
@immutable
abstract class Mix<T> with EqualityMixin, MixHelperMixin, ResolvableMixin<T> {
  const Mix();

  /// Merges this mix with another mix, returning a new mix.
  Mix<T> merge(covariant Mix<T>? other);

  /// Resolves to the concrete value using the provided context
  @override
  T resolve(MixContext context);
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
