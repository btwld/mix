// ignore_for_file: non_constant_identifier_names, constant_identifier_names, long-parameter-list, prefer-named-boolean-parameters

import 'package:flutter/widgets.dart';

import '../../attributes/animation/animation_config.dart';
import '../../internal/compare_mixin.dart';
import '../attribute.dart';
import '../modifier.dart';
import '../spec.dart';
import '../variant.dart';

abstract class Style<S extends Spec<S>> with EqualityMixin {
  // Instance fields
  final List<VariantAttribute<S>> variants;
  final AnimationConfig? animation;
  final List<WidgetModifierSpecAttribute>? modifiers;

  const Style({this.variants = const [], this.animation, this.modifiers});

  // Abstract getters and methods
  SpecAttribute<S> get attribute;

  /// Unique key used for merging elements of the same type
  Object get mergeKey => runtimeType;

  @protected
  List<VariantAttribute<S>> mergeVariantLists(
    List<VariantAttribute<S>>? current,
    List<VariantAttribute<S>>? other,
  ) {
    if (current == null && other == null) return [];
    if (current == null) return List<VariantAttribute<S>>.of(other!);
    if (other == null) return List<VariantAttribute<S>>.of(current);

    final Map<Object, VariantAttribute<S>> merged = {};

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
      merged[key] = existing != null ? existing.merge(modifier) : modifier;
    }

    return merged.values.toList();
  }

  /// Each subclass implements its own merge logic
  Style<S> merge(covariant Style<S>? other);

  /// REUSABLE HELPER: Get context variants that match current context
  @protected
  List<Style<S>> getMatchingContextVariants(BuildContext context) {
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
  ResolvedStyle<S> resolve(BuildContext context) {
    final resolvedStyle = getMatchingContextVariants(
      context,
    ).fold(this, (current, variant) => current.merge(variant));

    return ResolvedStyle(
      spec: resolvedStyle.attribute.resolve(context),
      animation: resolvedStyle.animation,
      modifiers: resolvedStyle.modifiers
          ?.map((e) => e.resolve(context))
          .toList()
          .cast<ModifierSpec>(),
    );
  }

  Style<S> withAttribute(SpecAttribute<S> attribute);

  /// REUSABLE LOGIC: Apply named variants
  Style<S> applyVariants(Set<NamedVariant> appliedVariants) {
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
class ResolvedStyle<V extends Spec<V>> {
  final V spec; // Resolved spec
  final AnimationConfig? animation; // Animation config
  final List<ModifierSpec>? modifiers; // Modifiers config

  const ResolvedStyle({required this.spec, this.animation, this.modifiers});

  /// Linearly interpolate between two ResolvedStyles
  ResolvedStyle<V> lerp(ResolvedStyle<V>? other, double t) {
    if (other == null || t == 0.0) return this;
    if (t == 1.0) return other;

    // Lerp the spec if it's a Spec type
    final lerpedSpec = (spec as Spec<V>).lerp(other.spec, t);

    // For modifiers and animation, use the target (end) values
    // We can't meaningfully interpolate these
    return ResolvedStyle(
      spec: lerpedSpec,
      animation: other.animation ?? animation,
      modifiers: t < 0.5 ? modifiers : other.modifiers,
    );
  }
}

// /// A style class that handles multiple specs through MultiSpec and MultiSpecAttribute
// class Style extends StyleElement<MultiSpec> {
//   @override
//   final MultiSpecAttribute attribute;

//   const Style.empty()
//     : attribute = const MultiSpecAttribute.empty(),
//       super(variants: const [], animation: null, modifiers: null);

//   const Style._({
//     required this.attribute,
//     super.variants,
//     super.animation,
//     super.modifiers,
//   });

//   /// Creates a new `Style` instance from a [BaseStyle].
//   ///
//   /// This factory constructor creates a new `Style` instance from a [BaseStyle] instance.
//   /// If the [BaseStyle] is an [AnimatedStyle], it creates an [AnimatedStyle] instance.
//   /// If the [BaseStyle] is a [Style], it returns the [Style] instance.
//   /// Otherwise, it creates a new [Style] instance with the styles and variants from the [BaseStyle].

//   /// Creates a new `Style` instance with a specified list of [StyleElement]s.
//   ///
//   /// This factory constructor initializes a `Style` with a list of
//   /// style elements provided as individual parameters. Only non-null elements
//   /// are included in the resulting `Style`. Since Attribute extends StyleElement,
//   /// this is backward compatible with existing code.
//   ///
//   /// There is no specific reason for only 20 parameters. This is just a
//   /// reasonable number of parameters to support. If you need more than 20,
//   /// consider breaking up your mixes into many style mixes that can be applied
//   /// or use the `Style.create` constructor.
//   ///
//   /// Example:
//   /// ```dart
//   /// final style = Style(attribute1, attribute2, attribute3);
//   /// ```
//   factory Style([
//     Attribute? p1,
//     Attribute? p2,
//     Attribute? p3,
//     Attribute? p4,
//     Attribute? p5,
//     Attribute? p6,
//     Attribute? p7,
//     Attribute? p8,
//     Attribute? p9,
//     Attribute? p10,
//     Attribute? p11,
//     Attribute? p12,
//     Attribute? p13,
//     Attribute? p14,
//     Attribute? p15,
//     Attribute? p16,
//     Attribute? p17,
//     Attribute? p18,
//     Attribute? p19,
//     Attribute? p20,
//   ]) {
//     final params = [
//       p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, //
//       p11, p12, p13, p14, p15, p16, p17, p18, p19, p20,
//     ].whereType<Attribute>();

//     return Style.create(params);
//   }

//   factory Style.create(Iterable<Attribute> attributes) {
//     final multiSpecAttribute = MultiSpecAttribute(
//       attributes.whereType<SpecAttribute>().toList(),
//     );

//     final modifiers = attributes
//         .whereType<WidgetModifierSpecAttribute>()
//         .toList();

//     final variants = attributes
//         .whereType<VariantAttribute<MultiSpec>>()
//         .toList();

//     return Style._(
//       attribute: multiSpecAttribute,
//       variants: variants,
//       animation: null, // Animation is not supported in Style
//       modifiers: modifiers,
//     );
//   }

//   @override
//   Style merge(Style? other) {
//     if (other == null) return this;

//     return Style._(
//       attribute: attribute.merge(other.attribute),
//       variants: mergeVariantLists(variants, other.variants),
//       animation: other.animation ?? animation,
//       modifiers: mergeModifierLists(modifiers, other.modifiers),
//     );
//   }

//   @override
//   List<Object?> get props => [attribute, variants, animation, modifiers];
// }
