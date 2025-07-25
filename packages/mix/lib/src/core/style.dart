import 'package:flutter/widgets.dart';

import '../internal/compare_mixin.dart';
import 'animation_config.dart';
import 'mix_element.dart';
import 'modifier.dart';
import 'spec.dart';
import 'variant.dart';

/// Base interface for all style elements in the Mix framework.
sealed class StyleElement {
  const StyleElement();
}

abstract class SpecStyle<S extends Spec<S>> extends Mixable<SpecStyle<S>>
    with EqualityMixin, Resolvable<S>
    implements StyleElement {
  final List<VariantSpecAttribute<S>>? $variants;
  final List<ModifierAttribute>? $modifiers;
  final AnimationConfig? $animation;

  const SpecStyle({
    List<VariantSpecAttribute<S>>? variants,
    List<ModifierAttribute>? modifiers,
    AnimationConfig? animation,
  }) : $modifiers = modifiers,
       $animation = animation,
       $variants = variants;

  bool get hasWidgetState {
    return $variants?.any((m) => m.variant is WidgetStateVariant) ?? false;
  }

  @protected
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
  SpecStyle<S> getAllStyleVariants(
    BuildContext context, {
    Set<NamedVariant>? namedVariants,
  }) {
    final contextVariants = $variants
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

    SpecStyle<S> styleData = this;

    for (final style in variantStyles) {
      styleData = styleData.merge(style);
    }

    return styleData;
  }

  @protected
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
  @override
  S resolve(BuildContext context);

  /// Merges this attribute with another attribute of the same type.
  @override
  SpecStyle<S> merge(covariant SpecStyle<S>? other);

  /// Default implementation uses runtimeType as the merge key
  @override
  Object get mergeKey => S;

  ResolvedStyle<S> build(
    BuildContext context, {
    Set<NamedVariant> namedVariants = const {},
  }) {
    final styleData = getAllStyleVariants(
      context,
      namedVariants: namedVariants,
    );

    final resolvedSpec = resolve(context);
    final resolvedAnimation = styleData.$animation;
    final resolvedModifiers = styleData.$modifiers
        ?.map((modifier) => modifier.resolve(context))
        .whereType<Modifier>()
        .toList();

    return ResolvedStyle(
      spec: resolvedSpec,
      animation: resolvedAnimation,
      modifiers: resolvedModifiers,
    );
  }
}

abstract class ModifierAttribute<S extends Modifier<S>> extends SpecStyle<S>
    implements StyleElement {
  const ModifierAttribute();

  @override
  ModifierAttribute<S> merge(covariant ModifierAttribute<S>? other);

  @override
  S resolve(BuildContext context);

  @override
  Type get mergeKey => S;
}

/// Variant wrapper for conditional styling
final class VariantSpecAttribute<S extends Spec<S>> extends SpecStyle<S> {
  final Variant variant;
  final SpecStyle<S> _style;

  const VariantSpecAttribute(this.variant, SpecStyle<S> style) : _style = style;

  SpecStyle<S> get value => _style;

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
  S resolve(BuildContext context) {
    return _style.resolve(context);
  }

  @override
  VariantSpecAttribute<S> merge(covariant VariantSpecAttribute<S>? other) {
    if (other == null || other.variant != variant) return this;

    return VariantSpecAttribute(variant, _style.merge(other._style));
  }

  @override
  List<Object?> get props => [variant, _style];

  @override
  Object get mergeKey => variant.key;
}

class Style extends SpecStyle<MultiSpec> {
  final Map<Object, SpecStyle> _attributes;

  Style._({
    required List<SpecStyle> attributes,
    super.animation,
    super.modifiers,
    super.variants,
  }) : _attributes = {for (var attr in attributes) attr.mergeKey: attr};

  /// Creates a new `Style` instance with specified list of [StyleElement]s.
  ///
  /// This factory constructor initializes a `Style` with a list of
  /// style elements provided as individual parameters. Only non-null elements
  /// are included in the resulting `Style`. Since Attribute extends StyleElement,
  /// this is backward compatible with existing code.
  ///
  /// There is no specific reason for only 20 parameters. This is just a
  /// reasonable number of parameters to support. If you need more than 20,
  /// consider breaking up your mixes into many style mixes that can be applied
  /// or use the `Style.create` constructor.
  ///
  /// Example:
  /// ```dart
  /// final style = Style(attribute1, attribute2, attribute3);
  /// ```
  factory Style([
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

    return Style.create(params);
  }

  /// Constructs a `Style` from an iterable of [StyleElement] instances.
  ///
  /// This factory constructor segregates the style elements into attributes
  /// and variants, initializing a new `MultiSpecAttribute` with these collections.
  /// Since Attribute extends StyleElement, this is backward compatible.
  ///
  /// Example:
  /// ```dart
  /// final style = Style.create([attribute1, attribute2]);
  /// ```
  factory Style.create(Iterable<StyleElement> elements) {
    final styleList = <SpecStyle>[];
    final modifierList = <ModifierAttribute>[];
    final variants = <VariantSpecAttribute>[];

    AnimationConfig? animationConfig;

    for (final element in elements) {
      switch (element) {
        case VariantSpecAttribute():
          variants.add(element);
          break;

        case ModifierAttribute():
          modifierList.add(element);
        case SpecStyle():
          // Handle MultiSpecAttribute by merging it later
          if (element is! Style) {
            styleList.add(element);
          }
      }
    }

    // Create the base MultiSpecAttribute
    Style result = Style._(
      attributes: styleList,
      animation: animationConfig,
      modifiers: modifierList.isEmpty ? null : modifierList,
      variants: null,
    );

    // Now handle MultiSpecAttribute elements by merging them
    for (final element in elements) {
      if (element is Style) {
        result = result.merge(element);
      }
      // Skip VariantSpecAttribute for now - needs proper generic handling
    }

    return result;
  }

  Style.empty()
    : this._(attributes: [], animation: null, modifiers: null, variants: null);

  /// Returns the list of attributes in this style
  List<SpecStyle> get attributes => _attributes.values.toList();

  Style animate({Duration? duration, Curve? curve}) {
    return Style._(
      attributes: _attributes.values.toList(),
      animation: AnimationConfig.implicit(duration: duration, curve: curve),
      modifiers: $modifiers,
      variants: $variants,
    );
  }

  @override
  MultiSpec resolve(BuildContext context) {
    final resolvedSpecs = _attributes.values
        .map((attr) => attr.resolve(context))
        .cast<Spec>()
        .toList();

    return MultiSpec(resolvedSpecs);
  }

  @override
  Style merge(Style? other) {
    if (other == null) return this;

    final mergedAttributes = <SpecStyle>[];

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

    return Style._(
      attributes: mergedAttributes,
      animation: other.$animation ?? $animation,
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      variants: mergeVariantLists($variants, other.$variants),
    );
  }

  @override
  get props => [_attributes];
}

/// Result of Style.resolve() containing fully resolved styling data
/// Generic type parameter T for the resolved SpecAttribute
class ResolvedStyle<V extends Spec<V>> {
  final V? spec; // Resolved spec
  final AnimationConfig? animation; // Animation config
  final List<Modifier>? modifiers; // Modifiers config

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
