import 'package:flutter/widgets.dart';

import '../internal/compare_mixin.dart';
import 'animation_config.dart';
import 'mix_element.dart';
import 'modifier.dart';
import 'spec.dart';
import 'style_mix.dart';
import 'variant.dart';

/// Base interface for all attributes
sealed class Attribute with Mergeable {
  const Attribute();
  Object get mergeKey => runtimeType;

  @override
  Attribute merge(covariant Attribute? other);
}

abstract class SpecAttribute<S extends Spec<S>> extends Mix<ResolvedStyle<S>>
    with EqualityMixin
    implements Attribute {
  final List<VariantSpecAttribute<S>>? variants;
  final List<ModifierAttribute>? modifiers;
  final AnimationConfig? animation;
  const SpecAttribute({this.variants, this.modifiers, this.animation});

  @visibleForTesting
  List<ModifierAttribute>? mergeModifierLists(
    List<ModifierAttribute>? current,
    List<ModifierAttribute>? other,
  ) {
    if (current == null && other == null) return null;
    if (current == null) return List.of(other!);
    if (other == null) return List.of(current);

    final Map<Object, ModifierAttribute> merged = {};

    // Add current modifiers
    for (final modifier in current) {
      merged[modifier.mergeKey] = modifier;
    }

    // Merge or add other modifiers
    for (final modifier in other) {
      final key = modifier.mergeKey;
      final existing = merged[key];
      merged[key] = existing != null ? existing.merge(modifier) : modifier;
    }

    return merged.values.toList();
  }

  @visibleForTesting
  SpecAttribute<S> getAllStyleVariants(
    BuildContext context, {
    Set<NamedVariant>? namedVariants,
  }) {
    final contextVariants = variants
        ?.where(
          (variantAttr) => switch (variantAttr.variant) {
            (ContextVariant contextVariant) => contextVariant.when(context),
            (NamedVariant namedVariant) =>
              namedVariants?.contains(namedVariant) ?? false,
            (ContextVariantBuilder _) => true,
          },
        )
        .toList();

    // Sort by priority: WidgetStateVariant gets applied last
    contextVariants?.sort(
      (a, b) => Comparable.compare(
        a.variant is WidgetStateVariant ? 1 : 0,
        b.variant is WidgetStateVariant ? 1 : 0,
      ),
    );

    final variantStyles =
        contextVariants?.map((variantAttr) => variantAttr.value).toList() ?? [];

    SpecAttribute<S> styleData = this;

    for (final style in variantStyles) {
      styleData = styleData.merge(style);
    }

    return styleData;
  }

  @visibleForTesting
  List<VariantSpecAttribute<S>> mergeVariantLists(
    List<VariantSpecAttribute<S>>? current,
    List<VariantSpecAttribute<S>>? other,
  ) {
    if (current == null && other == null) return [];
    if (current == null) return List<VariantSpecAttribute<S>>.of(other!);
    if (other == null) return List<VariantSpecAttribute<S>>.of(current);

    final Map<Object, VariantSpecAttribute<S>> merged = {};

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

  /// Resolves this attribute to its concrete value using the provided [BuildContext].

  S resolveSpec(BuildContext context);

  /// Merges this attribute with another attribute of the same type.
  @override
  SpecAttribute<S> merge(covariant SpecAttribute<S>? other);

  @override
  ResolvedStyle<S> resolve(
    BuildContext context, {
    Set<NamedVariant> namedVariants = const {},
  }) {
    final styleData = getAllStyleVariants(
      context,
      namedVariants: namedVariants,
    );

    final resolvedSpec = resolveSpec(context);
    final resolvedAnimation = styleData.animation;
    final resolvedModifiers = styleData.modifiers
        ?.map((modifier) => modifier.resolve(context))
        .whereType<Modifier>()
        .toList();

    return ResolvedStyle(
      spec: resolvedSpec,
      animation: resolvedAnimation,
      modifiers: resolvedModifiers,
    );
  }

  /// Default implementation uses runtimeType as the merge key
  @override
  Type get mergeKey => S;
}

abstract class ModifierAttribute<S extends Modifier<S>> extends Mix<S>
    with EqualityMixin
    implements Attribute {
  const ModifierAttribute();

  @override
  ModifierAttribute<S> merge(covariant ModifierAttribute<S>? other);

  @override
  S resolve(BuildContext context);

  @override
  Type get mergeKey => S;
}

/// Variant wrapper for conditional styling
final class VariantSpecAttribute<S extends Spec<S>> implements Attribute {
  final Variant variant;
  final SpecAttribute<S> _style;

  const VariantSpecAttribute(this.variant, SpecAttribute<S> style)
    : _style = style;

  SpecAttribute<S> get value => _style;

  bool matches(Iterable<Variant> otherVariants) =>
      otherVariants.contains(variant);

  VariantSpecAttribute<S>? removeVariants(Iterable<Variant> variantsToRemove) {
    Variant? remainingVariant;
    if (variant is MultiVariant) {
      final multiVariant = variant as MultiVariant;
      final remainingVariants = multiVariant.variants
          .where((v) => !variantsToRemove.contains(v))
          .toList();

      if (remainingVariants.isEmpty) {
        return null;
      } else if (remainingVariants.length == 1) {
        remainingVariant = remainingVariants.first;
      } else {
        remainingVariant = multiVariant.operatorType == MultiVariantOperator.and
            ? MultiVariant.and(remainingVariants)
            : MultiVariant.or(remainingVariants);
      }
    } else {
      if (!variantsToRemove.contains(variant)) {
        return this;
      }
    }

    return remainingVariant == null
        ? null
        : VariantSpecAttribute(remainingVariant, _style);
  }

  @override
  VariantSpecAttribute<S> merge(covariant VariantSpecAttribute<S>? other) {
    if (other == null || other.variant != variant) return this;

    return VariantSpecAttribute(variant, _style.merge(other._style));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariantSpecAttribute<S> &&
          other.variant == variant &&
          other._style == _style;

  @override
  Object get mergeKey => variant.key;

  @override
  int get hashCode => Object.hash(variant, _style);
}

class MultiSpecAttribute extends SpecAttribute<MultiSpec> {
  final Map<Type, SpecAttribute> _attributes;

  MultiSpecAttribute(List<SpecAttribute> attributes)
    : _attributes = {for (var attr in attributes) attr.mergeKey: attr};

  const MultiSpecAttribute.empty() : _attributes = const {};

  @override
  MultiSpec resolveSpec(BuildContext context) {
    final resolvedSpecs = _attributes.values
        .map((attr) => attr.resolveSpec(context))
        .cast<Spec>()
        .toList();

    return MultiSpec(resolvedSpecs);
  }

  @override
  MultiSpecAttribute merge(MultiSpecAttribute? other) {
    if (other == null) return this;

    final mergedAttributes = <SpecAttribute>[];

    // Get all unique merge keys from both attributes
    final allKeys = {..._attributes.keys, ...other._attributes.keys};

    for (final key in allKeys) {
      final attr = _attributes[key];
      final otherAttr = other._attributes[key];

      if (attr != null && otherAttr != null) {
        // Both attributes have this key, merge them
        mergedAttributes.add(attr.merge(otherAttr));
      } else if (attr != null) {
        // Only this attribute has this key
        mergedAttributes.add(attr);
      } else if (otherAttr != null) {
        // Only other attribute has this key
        mergedAttributes.add(otherAttr);
      }
    }

    return MultiSpecAttribute(mergedAttributes);
  }

  @override
  get props => [_attributes];
}
