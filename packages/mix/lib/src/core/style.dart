import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../animation/animation_config.dart';
import '../specs/box/box_attribute.dart';
import '../specs/flex/flex_attribute.dart';
import '../specs/flexbox/flexbox_attribute.dart';
import '../specs/icon/icon_attribute.dart';
import '../specs/stack/stack_attribute.dart';
import '../specs/stack/stack_box_attribute.dart';
import '../specs/text/text_attribute.dart';
import '../variants/variant.dart';
import 'internal/compare_mixin.dart';
import 'internal/constants.dart';
import 'mix_element.dart';
import 'modifier.dart';
import 'spec.dart';

/// This is used just to pass all the values into one place if needed
@internal
sealed class StyleElement {
  const StyleElement();
}

/// Base class for style containers that can be resolved to specifications.
///
/// Provides variant support, modifiers, and animation configuration for styled elements.
abstract class Style<S extends Spec<S>> extends Mixable<Style<S>>
    with Equatable, Resolvable<S>
    implements StyleElement {
  final List<VariantStyleAttribute<S>>? $variants;
  final List<ModifierAttribute>? $modifiers;
  final AnimationConfig? $animation;
  final List<Type> $orderOfModifiers;
  final bool? $inherit;

  static final box = BoxMix.new;
  static final icon = IconMix.new;
  static final text = TextMix.new;
  static final flexbox = FlexBoxMix.new;
  static final stack = StackMix.new;
  static final stackBox = StackBoxMix.new;
  static final flex = FlexMix.new;

  const Style({
    required List<VariantStyleAttribute<S>>? variants,
    required List<ModifierAttribute>? modifiers,
    required AnimationConfig? animation,
    required List<Type>? orderOfModifiers,
    required bool? inherit,
  }) : $modifiers = modifiers,
       $animation = animation,
       $variants = variants,
       $inherit = inherit,
       $orderOfModifiers = orderOfModifiers ?? const [];

  @internal
  Set<WidgetState> get widgetStates {
    return ($variants ?? [])
        .where((v) => v.variant is WidgetStateVariant)
        .map((v) => (v.variant as WidgetStateVariant).state)
        .toSet();
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
  Style<S> getAllStyleVariants(
    BuildContext context, {
    required Set<NamedVariant> namedVariants,
  }) {
    final variants = ($variants ?? [])
        .where(
          (variantAttr) => switch (variantAttr.variant) {
            (ContextVariant variant) => variant.when(context),
            (NamedVariant variant) => namedVariants.contains(variant),
            (ContextVariantBuilder _) => true,
          },
        )
        .toList();

    // Sort by priority: WidgetStateVariant gets applied last
    variants.sort(
      (a, b) => Comparable.compare(
        a.variant is WidgetStateVariant ? 1 : 0,
        b.variant is WidgetStateVariant ? 1 : 0,
      ),
    );

    final variantStyles = variants.map((variantAttr) {
      return switch (variantAttr.variant) {
        ContextVariantBuilder variant => variant.build(context) as Style<S>,
        (ContextVariant() || NamedVariant()) => variantAttr.value,
      };
    }).toList();

    Style<S> styleData = this;

    for (final style in variantStyles) {
      styleData = styleData.merge(style);
    }

    return styleData;
  }

  @protected
  List<VariantStyleAttribute<S>> mergeVariantLists(
    List<VariantStyleAttribute<S>>? current,
    List<VariantStyleAttribute<S>>? other,
  ) {
    if (current == null && other == null) return [];
    if (current == null) return List<VariantStyleAttribute<S>>.of(other!);
    if (other == null) return List<VariantStyleAttribute<S>>.of(current);

    final Map<Object, VariantStyleAttribute<S>> merged = {};

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
  Style<S> merge(covariant Style<S>? other);

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

    final resolvedSpec = styleData.resolve(context);
    final resolvedAnimation = styleData.$animation;
    final resolvedModifiers = styleData.$modifiers
        ?.map((modifier) => modifier.resolve(context))
        .whereType<Modifier>()
        .toList();

    return ResolvedStyle(
      spec: resolvedSpec,
      animation: resolvedAnimation,
      modifiers: resolvedModifiers,
      orderOfModifiers: styleData.$orderOfModifiers,
      inherit: styleData.$inherit,
    );
  }
}

abstract class ModifierAttribute<S extends Modifier<S>> extends Mix<S>
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
final class VariantStyleAttribute<S extends Spec<S>> extends Mixable<S>
    with Equatable
    implements StyleElement {
  final Variant variant;
  final Style<S> _style;

  const VariantStyleAttribute(this.variant, Style<S> style) : _style = style;

  Style<S> get value => _style;

  bool matches(Iterable<Variant> otherVariants) =>
      otherVariants.contains(variant);

  VariantStyleAttribute<S>? removeVariants(Iterable<Variant> variantsToRemove) {
    if (!variantsToRemove.contains(variant)) {
      return this;
    }

    return null;
  }

  @override
  VariantStyleAttribute<S> merge(covariant VariantStyleAttribute<S>? other) {
    if (other == null || other.variant != variant) return this;

    return VariantStyleAttribute(variant, _style.merge(other._style));
  }

  @override
  List<Object?> get props => [variant, _style];

  @override
  Object get mergeKey => variant.key;
}

/// Result of Style.resolve() containing fully resolved styling data
/// Generic type parameter T for the resolved SpecAttribute
class ResolvedStyle<V extends Spec<V>> with Equatable {
  final V? spec;
  final AnimationConfig? animation;
  final List<Modifier>? modifiers;
  final List<Type>? orderOfModifiers;
  final bool? inherit;

  const ResolvedStyle({
    this.spec,
    this.animation,
    this.modifiers,
    this.orderOfModifiers,
    this.inherit,
  });

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

  @override
  List<Object?> get props => [spec, animation, modifiers, orderOfModifiers];
}

class CompoundStyle extends Style<MultiSpec> {
  final Map<Object, Style> _attributes;

  CompoundStyle._({
    required List<Style> attributes,
    super.animation,
    super.modifiers,
    super.variants,
    super.orderOfModifiers,
    super.inherit,
  }) : _attributes = {for (var attr in attributes) attr.mergeKey: attr};

  /// Creates a new `Style` instance with specified list of [Style]s.
  ///
  /// This factory constructor initializes a `Style` with a list of
  /// style elements provided as individual parameters. Only non-null elements
  /// are included in the resulting `Style`. Since Attribute extends StyleAttribute,
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
  factory CompoundStyle([
    Style? p1,
    Style? p2,
    Style? p3,
    Style? p4,
    Style? p5,
    Style? p6,
    Style? p7,
    Style? p8,
    Style? p9,
    Style? p10,
    Style? p11,
    Style? p12,
    Style? p13,
    Style? p14,
    Style? p15,
    Style? p16,
    Style? p17,
    Style? p18,
    Style? p19,
    Style? p20,
  ]) {
    final params = [
      p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, //
      p11, p12, p13, p14, p15, p16, p17, p18, p19, p20,
    ].whereType<Style>();

    return CompoundStyle.create(params);
  }

  /// Constructs a `Style` from an iterable of [Style] instances.
  ///
  /// This factory constructor segregates the style elements into attributes
  /// and variants, initializing a new `MultiSpecAttribute` with these collections.
  /// Since Attribute extends StyleAttribute, this is backward compatible.
  ///
  /// Example:
  /// ```dart
  /// final style = Style.create([attribute1, attribute2]);
  /// ```
  factory CompoundStyle.create(Iterable<StyleElement> elements) {
    final styleList = <Style>[];
    final modifierList = <ModifierAttribute>[];
    final variants = <VariantStyleAttribute>[];

    AnimationConfig? animationConfig;

    for (final element in elements) {
      switch (element) {
        case VariantStyleAttribute():
          variants.add(element);
          break;

        case ModifierAttribute():
          modifierList.add(element);
        case Style():
          // Handle MultiSpecAttribute by merging it later
          if (element is! CompoundStyle) {
            styleList.add(element);
          }
      }
    }

    // Create the base MultiSpecAttribute
    CompoundStyle result = CompoundStyle._(
      attributes: styleList,
      animation: animationConfig,
      modifiers: modifierList.isEmpty ? null : modifierList,
      variants: null,
    );

    // Now handle MultiSpecAttribute elements by merging them
    for (final element in elements) {
      if (element is CompoundStyle) {
        result = result.merge(element);
      }
      // Skip VariantSpecAttribute for now - needs proper generic handling
    }

    return result;
  }

  CompoundStyle.empty()
    : this._(attributes: [], animation: null, modifiers: null, variants: null);

  /// Returns the list of attributes in this style
  List<Style> get attributes => _attributes.values.toList();

  CompoundStyle animate({Duration? duration, Curve? curve}) {
    return CompoundStyle._(
      attributes: _attributes.values.toList(),
      animation: AnimationConfig.curve(
        curve: curve ?? Curves.linear,
        duration: duration ?? kDefaultAnimationDuration,
      ),
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
  CompoundStyle merge(CompoundStyle? other) {
    if (other == null) return this;

    final mergedAttributes = <Style>[];

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

    return CompoundStyle._(
      attributes: mergedAttributes,
      animation: other.$animation ?? $animation,
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      variants: mergeVariantLists($variants, other.$variants),
    );
  }

  @override
  get props => [_attributes];
}
