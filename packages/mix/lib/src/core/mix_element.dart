import 'package:flutter/widgets.dart';

import '../attributes/animation/animation_config.dart';
import '../internal/compare_mixin.dart';
import '../variants/variant_attribute.dart';
import 'helpers.dart';
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

mixin ResolvableMixin<T> {
  /// Resolves the current instance to a [T] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final resolved = instance.resolve(mix);
  /// ```
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
    return MixHelpers.resolvePropList(context, list);
  }

  @protected
  List<R>? resolveMixPropList<R, D extends Mix<R>>(
    BuildContext context,
    List<MixProp<R, D>>? list,
  ) {
    return MixHelpers.resolveMixPropList(context, list);
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
    return MixHelpers.mergePropList(a, b, strategy: strategy);
  }

  @protected
  List<MixProp<R, D>>? mergeMixPropList<R, D extends Mix<R>>(
    List<MixProp<R, D>>? a,
    List<MixProp<R, D>>? b, {
    ListMergeStrategy strategy = ListMergeStrategy.replace,
  }) {
    return MixHelpers.mergeMixPropList(a, b, strategy: strategy);
  }
}

abstract class StyleElement<V> with EqualityMixin, MixHelperMixin {
  // Instance fields
  final List<VariantAttribute<V>> variants;
  final AnimationConfig? animation;
  final List<WidgetModifierSpecAttribute>? modifiers;

  const StyleElement({
    this.variants = const [],
    this.animation,
    this.modifiers,
  });

  // Abstract getters and methods
  SpecAttribute<V> get attribute;

  /// Unique key used for merging elements of the same type
  Object get mergeKey => runtimeType;

  @protected
  List<VariantAttribute<V>> mergeVariantLists(
    List<VariantAttribute<V>>? current,
    List<VariantAttribute<V>>? other,
  ) {
    if (current == null && other == null) return [];
    if (current == null) return List<VariantAttribute<V>>.of(other!);
    if (other == null) return List<VariantAttribute<V>>.of(current);

    final Map<Object, VariantAttribute<V>> merged = {};

    // Add current variants
    for (final variant in current) {
      merged[variant.mergeKey] = variant;
    }

    // Merge or add other variants
    for (final variant in other) {
      final key = variant.mergeKey;
      final existing = merged[key];
      merged[key] = existing != null ? existing.merge(variant) : variant;
    }

    return merged.values.toList();
  }

  @protected
  List<WidgetModifierSpecAttribute>? mergeModifierLists(
    List<WidgetModifierSpecAttribute>? current,
    List<WidgetModifierSpecAttribute>? other,
  ) {
    if (current == null && other == null) return null;
    if (current == null) return List.of(other!);
    if (other == null) return List.of(current);

    final Map<Object, WidgetModifierSpecAttribute> merged = {};

    // Add current modifiers
    for (final modifier in current) {
      merged[modifier.mergeKey] = modifier;
    }

    // Merge or add other modifiers
    for (final modifier in other) {
      final key = modifier.mergeKey;
      final existing = merged[key];
      merged[key] = existing != null
          ? existing.merge(modifier) as WidgetModifierSpecAttribute
          : modifier;
    }

    return merged.values.toList();
  }

  /// Each subclass implements its own merge logic
  StyleElement<V> merge(covariant StyleElement<V>? other);

  /// REUSABLE HELPER: Get context variants that match current context
  @protected
  List<StyleElement<V>> getMatchingContextVariants(BuildContext context) {
    final contextVariants = variants
        .where(
          (variantAttr) => switch (variantAttr.variant) {
            (ContextVariant contextVariant) => contextVariant.when(context),
            (ContextVariantBuilder _) => true,
            _ => false,
          },
        )
        .toList();

    // Sort by priority: WidgetStateVariant gets applied last
    contextVariants.sort(
      (a, b) => Comparable.compare(
        a.variant is WidgetStateVariant ? 1 : 0,
        b.variant is WidgetStateVariant ? 1 : 0,
      ),
    );

    return contextVariants.map((variantAttr) => variantAttr.value).toList();
  }

  /// REUSABLE LOGIC: Resolve with context variants
  ResolvedStyleElement<V> resolve(BuildContext context) {
    final resolvedStyle = getMatchingContextVariants(
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

  /// REUSABLE LOGIC: Apply named variants
  StyleElement<V> withNamedVariants(Set<NamedVariant> appliedVariants) {
    if (appliedVariants.isEmpty) return this;

    return appliedVariants.fold(this, (current, variant) {
      final variantAttr = variants
          .where((v) => v.variant == variant)
          .firstOrNull;

      return variantAttr != null ? current.merge(variantAttr.value) : current;
    });
  }
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
abstract class Mix<T> with EqualityMixin, MixHelperMixin {
  const Mix();

  /// Merges this mix with another mix, returning a new mix.
  Mix<T> merge(covariant Mix<T>? other);

  /// Resolves to the concrete value using the provided context

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
