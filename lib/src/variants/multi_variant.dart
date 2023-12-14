import 'package:flutter/material.dart';

import '../attributes/variant_attribute.dart';
import '../core/attribute.dart';
import '../factory/style_mix.dart';
import 'context_variant.dart';
import 'variant.dart';

enum MultiVariantOperator { and, or }

/// `MultiVariant` is a specialized form of `Variant` that allows combining multiple
/// variants together, using logical operations. This enables complex style definitions
/// that depend on multiple conditions.
///
/// The class supports two types of combinations:
/// - `MultiVariantType.and`: Applies styles when all included variants are active.
/// - `MultiVariantType.or`: Applies styles when any of the included variants are active.
///
/// `MultiVariant` also incorporates context-aware variants, allowing styles to adapt
/// based on the build context. This feature is especially useful for responsive
/// design or theming.
///
/// Example Usage:
/// ```dart
/// final variantA = Variant('A');
/// final variantB = Variant('B');
/// final combinedAndVariant = MultiVariant.and([variantA, variantB]);
/// final combinedOrVariant = MultiVariant.or([variantA, variantB]);
///
/// final style = Style(
///   text.style(fontSize: 16),
///   combinedAndVariant(
///     text.style(color: Colors.blue),
///   ),
///   combinedOrVariant(
///     text.style(color: Colors.green),
///   ),
/// );
/// ```
///
/// In this example, `combinedAndVariant` applies its styles only when both `variantA`
/// and `variantB` are active, while `combinedOrVariant` applies its styles if either
/// `variantA` or `variantB` is active. This allows for flexible and dynamic styling
/// based on multiple conditions.

@immutable
class MultiVariant extends Variant {
  /// A list of [Variant] instances contained within this `MultiVariant`.
  final List<Variant> variants;

  /// The type operator of this `MultiVariant`, defining its category or specific behavior.
  ///
  /// This field is crucial in differentiating various `MultiVariant` instances and
  /// understanding and applying their behavior.
  final MultiVariantOperator operatorType;

  const MultiVariant._(super.name, this.variants, {required this.operatorType});

  factory MultiVariant(
    Iterable<Variant> variants, {
    required MultiVariantOperator type,
  }) {
    final sortedVariants = variants.toList()
      ..sort(((a, b) => a.name.compareTo(b.name)));
    final combinedName = sortedVariants.map((e) => e.name).join('-');

    return MultiVariant._(combinedName, sortedVariants, operatorType: type);
  }

  /// Factory constructor to create a `MultiVariant` where all provided variants need to be active (`MultiVariantType.and`).
  ///
  /// It initializes a `MultiVariant` with the given [variants] and sets the type to `MultiVariantType.and`.
  factory MultiVariant.and(Iterable<Variant> variants) {
    return MultiVariant(variants, type: MultiVariantOperator.and);
  }

  /// Factory constructor to create a `MultiVariant` where any one of the provided variants needs to be active (`MultiVariantType.or`).
  ///
  /// It initializes a `MultiVariant` with the given [variants] and sets the type to `MultiVariantType.or`.
  factory MultiVariant.or(Iterable<Variant> variants) {
    return MultiVariant(variants, type: MultiVariantOperator.or);
  }

  bool get hasGestureVariant {
    return variants.any((variant) => variant is GestureVariant);
  }

  /// Removes specified variants from this `MultiVariant`.
  ///
  /// This method returns a new variant after removing the specified [variantsToRemove].
  /// If only one variant remains after removal, it returns that single variant instead of a `MultiVariant`.
  /// This is useful for dynamically adjusting styles by excluding certain variants.
  ///
  /// Example:
  /// ```dart
  /// final combinedVariant = MultiVariant.and([variantA, variantB, variantC]);
  /// final updatedVariant = combinedVariant.remove([variantA]);
  /// ```
  /// In this example, `updatedVariant` will be a combination of `variantB` and `variantC`.
  /// This is useful for procedurally applying variants based on runtime conditions.
  Variant remove(Iterable<Variant> variantsToRemove) {
    final updatedVariants = variants..removeWhere(variantsToRemove.contains);

    return updatedVariants.length == 1
        ? updatedVariants.first
        : MultiVariant(updatedVariants, type: operatorType);
  }

  /// Determines if the current `MultiVariant` matches a set of provided variants.
  ///
  /// This method evaluates whether the variants within this `MultiVariant` align with the given [matchVariants] based on its `type`:
  /// - `MultiVariantType.and`: Returns true if every variant in this `MultiVariant` is present in [matchVariants].
  /// - `MultiVariantType.or`: Returns true if at least one of the variants in this `MultiVariant` is present in [matchVariants].
  ///
  /// This method is particularly useful for checking if a composite style, represented by this `MultiVariant`,
  /// should be applied based on a specific set of active variants.
  ///
  /// Example:
  /// ```dart
  /// final combinedVariant = MultiVariant.and([variantA, variantB]);
  /// bool isMatched = combinedVariant.matches([variantA, variantB, variantC]);
  /// ```
  /// Here, `isMatched` will be true for `MultiVariantType.and` if both `variantA` and `variantB` are included in the provided list.
  /// For `MultiVariantType.or`, `isMatched` would be true if either `variantA` or `variantB` is in the list.
  bool matches(Iterable<Variant> matchVariants) {
    final matchSet = matchVariants.toSet();
    final variantSet = variants.toSet();

    return operatorType == MultiVariantOperator.and
        ? variantSet.difference(matchSet).isEmpty
        : variantSet.intersection(matchSet).isNotEmpty;
  }

  /// Evaluates if the `MultiVariant` should be applied based on the build context.
  ///
  /// For `MultiVariantType.or`, it returns true if any of the context-aware variants (`ContextVariant`)
  /// evaluates true in the given [context]. For `MultiVariantType.and`, it returns true only if all context-aware
  /// variants evaluate true, and if all variants in the `MultiVariant` are context-aware.
  ///
  /// This method enables context-sensitive styling, allowing the application of styles based on runtime
  /// conditions like screen size, orientation, or theme.
  ///
  /// Example:
  /// ```dart
  /// final combinedVariant = MultiVariant.or([contextVariantA, contextVariantB]);
  /// bool isApplicable = combinedVariant.when(context);
  /// ```
  /// `isApplicable` will be true if either `contextVariantA` or `contextVariantB` is applicable in the given context.
  bool when(BuildContext context) {
    final contextVariants = variants.whereType<ContextVariant>();

    return operatorType == MultiVariantOperator.or
        ? contextVariants.any((variant) => variant.when(context))
        : contextVariants.length == variants.length &&
            contextVariants.every((variant) => variant.when(context));
  }

  /// A method for creating a new `MultiVariantAttribute` instance.
  ///
  /// It takes up to 20 optional [Attribute] parameters and creates a new `MultiVariantAttribute` using these attributes.
  /// This method allows for easy creation of a `MultiVariantAttribute` with custom attributes.
  @override
  MultiVariantAttribute call([
    Attribute? p1,
    Attribute? p2,
    Attribute? p3,
    Attribute? p4,
    Attribute? p5,
    Attribute? p6,
    Attribute? p7,
    Attribute? p8,
    Attribute? p9,
    Attribute? p10,
    Attribute? p11,
    Attribute? p12,
    Attribute? p13,
    Attribute? p14,
    Attribute? p15,
    Attribute? p16,
    Attribute? p17,
    Attribute? p18,
    Attribute? p19,
    Attribute? p20,
  ]) {
    final params = [
      p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, //
      p11, p12, p13, p14, p15, p16, p17, p18, p19, p20,
    ].whereType<Attribute>();

    return MultiVariantAttribute(this, Style.create(params));
  }

  @override
  get props => [name, variants];
}
