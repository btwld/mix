import 'package:flutter/widgets.dart';

import '../internal/compare_mixin.dart';
import '../variants/context_variant.dart';
import '../variants/variant_attribute.dart';
import 'element.dart';
import 'factory/style_mix.dart';

enum VariantPriority {
  low(0),
  normal(1),
  high(2),
  highest(3);

  final int value;

  const VariantPriority(this.value);
}

@immutable
abstract class IVariant with EqualityMixin {
  const IVariant();

  /// This is the priority at which the variants are applied.
  /// In the case of some context variants that are due to
  /// widget interactivity, they should be applied
  /// at a higher priority than media query variants, for example.
  VariantPriority get priority;

  /// This key determines how variants should be merged.
  /// For the most part, it's basically the runtimeType.
  /// However, for some context variants and multivariants, it is different
  /// as they can have different merge rules.
  Object get mergeKey;

  MultiVariant operator &(covariant IVariant variant) =>
      MultiVariant.and([this, variant]);

  MultiVariant operator |(covariant IVariant variant) =>
      MultiVariant.or([this, variant]);

  bool matches(Iterable<IVariant> matchVariants) =>
      matchVariants.contains(this);

  bool when(BuildContext context);
}

@immutable
class Variant extends IVariant {
  final String name;

  @override
  final priority = VariantPriority.normal;

  const Variant(this.name);

  VariantAttribute call([
    StyleElement? p1,
    StyleElement? p2,
    StyleElement? p3,
    StyleElement? p4,
    StyleElement? p5,
    StyleElement? p6,
    StyleElement? p7,
    StyleElement? p8,
    StyleElement? p9,
    StyleElement? p10,
    StyleElement? p11,
    StyleElement? p12,
    StyleElement? p13,
    StyleElement? p14,
    StyleElement? p15,
    StyleElement? p16,
    StyleElement? p17,
    StyleElement? p18,
    StyleElement? p19,
    StyleElement? p20,
  ]) {
    final params = [
      p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, //
      p11, p12, p13, p14, p15, p16, p17, p18, p19, p20,
    ].whereType<StyleElement>();

    return VariantAttribute(this, Style.create(params));
  }

  @override
  bool when(BuildContext context) => false;
  @override
  Object get mergeKey => '$runtimeType.$name';

  @override
  get props => [name];
}

enum MultiVariantOperator { and, or }

@immutable
class MultiVariant extends IVariant {
  final List<IVariant> variants;

  final MultiVariantOperator operatorType;

  const MultiVariant._(this.variants, {required this.operatorType});

  factory MultiVariant(
    Iterable<IVariant> variants, {
    required MultiVariantOperator type,
  }) {
    final multiVariants = <MultiVariant>[];
    final otherVariants = <IVariant>[];

    for (var variant in variants) {
      if (variant is MultiVariant) {
        if (variant.operatorType == type) {
          otherVariants.addAll(variant.variants);
        } else {
          multiVariants.add(variant);
        }
      } else {
        otherVariants.add(variant);
      }
    }

    final combinedVariants = [...multiVariants, ...otherVariants];

    return MultiVariant._(combinedVariants.toList(), operatorType: type);
  }

  factory MultiVariant.and(Iterable<IVariant> variants) {
    return MultiVariant(variants, type: MultiVariantOperator.and);
  }

  factory MultiVariant.or(Iterable<IVariant> variants) {
    return MultiVariant(variants, type: MultiVariantOperator.or);
  }

  IVariant? remove(Iterable<IVariant> variantsToRemove) {
    final remainingVariants = <IVariant>[];

    for (var variant in variants) {
      if (variant is MultiVariant) {
        final remaining = variant.remove(variantsToRemove);
        if (remaining != null) {
          remainingVariants.add(remaining);
        }
      } else {
        if (!variantsToRemove.contains(variant)) {
          remainingVariants.add(variant);
        }
      }
    }

    if (remainingVariants.isEmpty) {
      return null;
    }

    return remainingVariants.length == 1
        ? remainingVariants.first
        : MultiVariant(remainingVariants, type: operatorType);
  }

  VariantAttribute call([
    StyleElement? p1,
    StyleElement? p2,
    StyleElement? p3,
    StyleElement? p4,
    StyleElement? p5,
    StyleElement? p6,
    StyleElement? p7,
    StyleElement? p8,
    StyleElement? p9,
    StyleElement? p10,
    StyleElement? p11,
    StyleElement? p12,
    StyleElement? p13,
    StyleElement? p14,
    StyleElement? p15,
    StyleElement? p16,
    StyleElement? p17,
    StyleElement? p18,
    StyleElement? p19,
    StyleElement? p20,
  ]) {
    final params = [
      p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, //
      p11, p12, p13, p14, p15, p16, p17, p18, p19, p20,
    ].whereType<StyleElement>();

    return VariantAttribute(this, Style.create(params));
  }

  @override
  bool matches(Iterable<IVariant> matchVariants) {
    final list = variants.map((e) => e.matches(matchVariants)).toList();

    return operatorType == MultiVariantOperator.or
        ? list.contains(true)
        : list.every((e) => e);
  }

  @override
  bool when(BuildContext context) {
    var conditions = variants.map((e) => e.when(context));

    return operatorType == MultiVariantOperator.or
        ? conditions.contains(true)
        : conditions.every((e) => e);
  }

  @override
  Object get mergeKey =>
      '$runtimeType.$operatorType.${variants.map((e) => e.mergeKey)}';

  @override
  VariantPriority get priority {
    final priorities =
        variants.whereType<ContextVariant>().map((e) => e.priority).toList();

    // Return normal priority if no priorities are found
    if (priorities.isEmpty) {
      return VariantPriority.normal;
    }

    // get highest priority
    return priorities.reduce(
      (value, element) => value.value > element.value ? value : element,
    );
  }

  @override
  get props => [variants, operatorType];
}
