import 'package:flutter/widgets.dart';

import '../attributes/animation/animation_config.dart';
import '../internal/compare_mixin.dart';
import '../variants/variant_attribute.dart';
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
  T resolve(BuildContext context);
}

// Mixin that provides Mix helper methods to StyleElement classes
mixin MixHelperMixin {
  @protected
  V? resolveProp<V>(BuildContext context, Prop<V>? prop) {
    return prop?.resolve(context);
  }

  @protected
  Prop<V>? mergeProp<V>(Prop<V>? a, Prop<V>? b) {
    return a?.merge(b) ?? b;
  }

  @protected
  List<V>? resolvePropList<V>(BuildContext context, List<Prop<V>>? list) {
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
    BuildContext context,
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
    BuildContext context,
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
  Object get mergeKey => runtimeType;

  StyleElement merge(covariant StyleElement? other);
}

abstract class SpecStyle<V, T extends SpecAttribute<V>> extends StyleElement {
  final T attribute;
  final List<VariantAttribute<T>> variants;
  final AnimationConfig? animation;
  final List<WidgetModifierSpecAttribute>? modifiers;

  const SpecStyle({
    required this.attribute,
    this.variants = const [],
    this.animation,
    this.modifiers,
  });

  /// Get matching context variants sorted by priority
  List<SpecStyle<V, T>> _getMatchingContextVariants(BuildContext context) {
    final contextVariants = variants
        .where(
          (variantAttr) => switch (variantAttr.variant) {
            (ContextVariant contextVariant) => contextVariant.when(context),
            (ContextVariantBuilder _) => true,
            _ => false,
          },
        )
        .toList();

    contextVariants.sort(
      (a, b) => Comparable.compare(
        a.variant is WidgetStateVariant ? 1 : 0,
        b.variant is WidgetStateVariant ? 1 : 0,
      ),
    );

    return contextVariants
        .map((variantAttr) => variantAttr.value as SpecStyle<V, T>)
        .toList();
  }

  /// Protected helper to merge SpecStyle data - for use by concrete implementations
  @protected
  ({
    T attribute,
    List<VariantAttribute<T>> variants,
    AnimationConfig? animation,
    List<WidgetModifierSpecAttribute>? modifiers,
  })
  mergeData(SpecStyle<V, T>? other) {
    if (other == null) {
      return (
        attribute: attribute,
        variants: variants,
        animation: animation,
        modifiers: modifiers,
      );
    }

    return (
      attribute: attribute.merge(other.attribute) as T,
      variants: mergeStyleElementsByKey(variants, other.variants),
      animation: other.animation ?? animation,
      modifiers: other.modifiers == null
          ? modifiers
          : modifiers == null
          ? other.modifiers
          : mergeStyleElementsByKey(modifiers, other.modifiers),
    );
  }

  @protected
  /// Abstract factory method for creating new instances
  SpecStyle<V, T> createStyle({
    required T attribute,
    AnimationConfig? animation,
    List<WidgetModifierSpecAttribute>? modifiers,
    Map<Variant, SpecStyle<V, T>> variants,
  });

  /// Resolve style by applying context variants and resolving to final specs
  ResolvedStyleElement<V> resolve(BuildContext context) {
    final resolvedStyle = _getMatchingContextVariants(
      context,
    ).fold(this, (current, variant) => current.merge(variant));

    return ResolvedStyleElement(
      spec: resolvedStyle.attribute.resolve(context),
      animation: resolvedStyle.animation,
      modifiers: resolvedStyle.modifiers
          ?.map((e) => e.resolve(context))
          .toList()
          .cast<WidgetModifierSpec>(),
    );
  }

  /// Apply named variants by merging matching variant styles
  SpecStyle<V, T> withNamedVariants(Set<NamedVariant> appliedVariants) {
    if (appliedVariants.isEmpty) return this;

    return appliedVariants.fold(this, (current, variant) {
      final variantAttr = variants
          .where((v) => v.variant == variant)
          .firstOrNull;

      return variantAttr != null
          ? current.merge(variantAttr.value as SpecStyle<V, T>)
          : current;
    });
  }

  @override
  SpecStyle<V, T> merge(covariant SpecStyle<V, T>? other);

  @override
  Object get mergeKey => runtimeType;
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
  T resolve(BuildContext context);
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

List<T> mergeStyleElementsByKey<T extends StyleElement>(
  List<T>? current,
  List<T>? other,
) {
  if (current == null && other == null) return [];
  if (current == null) return List<T>.of(other!);
  if (other == null) return List<T>.of(current);

  final Map<Object, T> merged = {};

  // Add current elements
  for (final element in current) {
    merged[element.mergeKey] = element;
  }

  // Merge or add other elements
  for (final element in other) {
    final existing = merged[element.mergeKey];
    if (existing != null) {
      merged[element.mergeKey] = existing.merge(element) as T;
    } else {
      merged[element.mergeKey] = element;
    }
  }

  return merged.values.toList();
}
