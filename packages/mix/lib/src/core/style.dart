import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../modifiers/modifier_config.dart';
import '../specs/box/box_style.dart';
import '../specs/flex/flex_style.dart';
import '../specs/flexbox/flexbox_style.dart';
import '../specs/icon/icon_style.dart';
import '../specs/image/image_style.dart';
import '../specs/stack/stack_box_style.dart';
import '../specs/stack/stack_style.dart';
import '../specs/text/text_style.dart';
import '../variants/variant.dart';
import 'internal/compare_mixin.dart';
import 'mix_element.dart';
import 'modifier.dart';
import 'spec.dart';
import 'style_spec.dart';

/// This is used just to pass all the values into one place if needed
@internal
sealed class StyleElement {
  const StyleElement();
}

/// Base class for style classes that can be resolved to specifications.
///
/// Provides variant support, modifiers, and animation configuration for styled elements.
abstract class Style<S extends Spec<S>> extends Mix<StyleSpec<S>>
    implements StyleElement {
  final List<VariantStyle<S>>? $variants;

  final ModifierConfig? $modifier;
  final AnimationConfig? $animation;

  const Style({
    required List<VariantStyle<S>>? variants,
    required ModifierConfig? modifier,
    required AnimationConfig? animation,
  }) : $modifier = modifier,
       $animation = animation,
       $variants = variants;

  static BoxStyler box(BoxStyler value) => value;

  static TextStyler text(TextStyler value) => value;
  static IconStyler icon(IconStyler value) => value;
  static ImageStyler image(ImageStyler value) => value;
  static StackStyler stack(StackStyler value) => value;
  static FlexStyler flex(FlexStyler value) => value;
  static FlexBoxStyler flexbox(FlexBoxStyler value) => value;
  static StackBoxStyler stackbox(StackBoxStyler value) => value;

  @internal
  Set<WidgetState> get widgetStates {
    return ($variants ?? [])
        .where((v) => v.variant is WidgetStateVariant)
        .map((v) => (v.variant as WidgetStateVariant).state)
        .toSet();
  }


  /// Merges all active variants with their nested variants recursively.
  ///
  /// This method evaluates which variants should be active based on the current
  /// context and named variants, then recursively processes nested variants
  /// within each active variant's style. The result is a fully merged style
  /// with all applicable variants applied.
  ///
  /// Variant priority order (lowest to highest):
  /// 1. ContextVariant and NamedVariant (applied first)
  /// 2. WidgetStateVariant (applied last, highest priority)
  @visibleForTesting
  Style<S> mergeActiveVariants(
    BuildContext context, {
    required Set<NamedVariant> namedVariants,
  }) {
    // Filter variants that should be active in this context
    final activeVariants = ($variants ?? [])
        .where(
          (variantAttr) => switch (variantAttr.variant) {
            (ContextVariant variant) => variant.when(context),
            (NamedVariant variant) => namedVariants.contains(variant),
            (ContextVariantBuilder _) => true,
          },
        )
        .toList();

    // Sort by priority: WidgetStateVariant gets applied last (highest priority)
    activeVariants.sort(
      (a, b) => Comparable.compare(
        a.variant is WidgetStateVariant ? 1 : 0,
        b.variant is WidgetStateVariant ? 1 : 0,
      ),
    );

    // Extract the style from each active variant
    final stylesToMerge = activeVariants.map((variantAttr) {
      return switch (variantAttr.variant) {
        ContextVariantBuilder variant => variant.build(context) as Style<S>,
        (ContextVariant() || NamedVariant()) => variantAttr.value,
      };
    }).toList();

    // Start with current style as base
    Style<S> mergedStyle = this;

    // Merge each variant style, recursively resolving nested variants
    for (final variantStyle in stylesToMerge) {
      // Recursively resolve any nested variants within this variant's style
      final fullyResolvedStyle = variantStyle.mergeActiveVariants(
        context,
        namedVariants: namedVariants,
      );
      mergedStyle = mergedStyle.merge(fullyResolvedStyle);
    }

    return mergedStyle;
  }


  /// Resolves this attribute to its concrete value using the provided [BuildContext].
  @override
  StyleSpec<S> resolve(BuildContext context);

  /// Merges this attribute with another attribute of the same type.
  @override
  Style<S> merge(covariant Style<S>? other);

  /// Default implementation uses runtimeType as the merge key
  @override
  Object get mergeKey => S;

  /// Builds the style into a fully resolved spec with metadata.
  ///
  /// This method resolves the style, which now includes animation and modifiers metadata.
  StyleSpec<S> build(
    BuildContext context, {
    Set<NamedVariant> namedVariants = const {},
  }) {
    final styleData = mergeActiveVariants(
      context,
      namedVariants: namedVariants,
    );

    return styleData.resolve(context);
  }
}

abstract class ModifierMix<S extends Modifier<S>> extends Mix<S>
    implements StyleElement {
  const ModifierMix();

  @override
  ModifierMix<S> merge(covariant ModifierMix<S>? other);

  @override
  S resolve(BuildContext context);

  @override
  Type get mergeKey => S;
}

/// Variant wrapper for conditional styling
final class VariantStyle<S extends Spec<S>> extends Mixable<StyleSpec<S>>
    with Equatable
    implements StyleElement {
  final Variant variant;
  final Style<S> _style;

  const VariantStyle(this.variant, Style<S> style) : _style = style;

  Style<S> get value => _style;

  bool matches(Iterable<Variant> otherVariants) =>
      otherVariants.contains(variant);

  VariantStyle<S>? removeVariants(Iterable<Variant> variantsToRemove) {
    if (!variantsToRemove.contains(variant)) {
      return this;
    }

    return null;
  }

  @override
  VariantStyle<S> merge(covariant VariantStyle<S>? other) {
    if (other == null) {
      return VariantStyle(variant, _style);
    }
    
    if (variant != other.variant) {
      throw ArgumentError(
        'Cannot merge VariantStyle with different variants. '
        'Attempted to merge variant "${variant.key}" with "${other.variant.key}".',
      );
    }
    
    return VariantStyle(variant, _style.merge(other._style));
  }

  @override
  List<Object?> get props => [variant, _style];

  @override
  Object get mergeKey => variant.key;
}
