import 'package:flutter/widgets.dart';

import '../internal/compare_mixin.dart';
import 'factory/style_mix.dart';
import 'helpers.dart';
import 'mix_element.dart';
import 'modifier.dart';
import 'spec.dart';
import 'variant.dart';

/// Base interface for all attributes
sealed class Attribute with Mergeable, EqualityMixin {
  const Attribute();
  Object get mergeKey => runtimeType;

  @override
  Attribute merge(covariant Attribute? other);
}

abstract class SpecAttribute<S extends Spec<S>> extends Attribute
    with Resolvable<S>, MixHelperMixin {
  const SpecAttribute();

  /// Resolves this attribute to its concrete value using the provided [BuildContext].
  @override
  S resolve(BuildContext context);

  /// Merges this attribute with another attribute of the same type.
  @override
  SpecAttribute<S> merge(covariant SpecAttribute<S>? other);

  /// Default implementation uses runtimeType as the merge key
  @override
  Type get mergeKey => S;
}

abstract class WidgetModifierSpecAttribute<S extends WidgetModifierSpec<S>>
    extends Attribute
    with Resolvable<S>, MixHelperMixin {
  const WidgetModifierSpecAttribute();

  @override
  WidgetModifierSpecAttribute<S> merge(
    covariant WidgetModifierSpecAttribute<S>? other,
  );

  @override
  S resolve(BuildContext context);
}

/// Variant wrapper for conditional styling
final class VariantAttribute<S extends Spec<S>> extends Attribute {
  final Variant variant;
  final StyleElement<S> _style;

  const VariantAttribute(this.variant, StyleElement<S> style) : _style = style;

  StyleElement<S> get value => _style;

  bool matches(Iterable<Variant> otherVariants) =>
      otherVariants.contains(variant);

  VariantAttribute<S>? removeVariants(Iterable<Variant> variantsToRemove) {
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
        : VariantAttribute(remainingVariant, _style);
  }

  @override
  VariantAttribute<S> merge(covariant VariantAttribute<S>? other) {
    if (other == null || other.variant != variant) return this;

    return VariantAttribute(variant, _style.merge(other._style));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariantAttribute<S> &&
          other.variant == variant &&
          other._style == _style;

  @override
  Object get mergeKey => variant.key;

  @override
  int get hashCode => Object.hash(variant, _style);

  @override
  List<Object?> get props => [variant, _style];
}

class MultiSpecAttribute extends SpecAttribute<MultiSpec> {
  final Map<Type, SpecAttribute> _attributes;

  MultiSpecAttribute(List<SpecAttribute> attributes)
    : _attributes = {for (var attr in attributes) attr.mergeKey: attr};

  const MultiSpecAttribute.empty() : _attributes = const {};

  @override
  MultiSpec resolve(BuildContext context) {
    final resolvedSpecs = _attributes.values
        .map((attr) => attr.resolve(context))
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
