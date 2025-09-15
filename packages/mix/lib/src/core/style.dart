import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../modifiers/widget_modifier_config.dart';
import '../specs/box/box_style.dart';
import '../specs/flex/flex_style.dart';
import '../specs/flexbox/flexbox_style.dart';
import '../specs/icon/icon_style.dart';
import '../specs/image/image_style.dart';
import '../specs/stack/stack_box_style.dart';
import '../specs/stack/stack_style.dart';
import '../specs/text/text_style.dart';
import '../variants/variant.dart';
import 'mix_element.dart';
import 'spec.dart';
import 'style_spec.dart';
import 'widget_modifier.dart';

/// Marker interface for style-related elements.
@internal
sealed class StyleElement {
  const StyleElement();
}

/// Base class for style classes that can be resolved to specifications.
///
/// Provides variant support, modifiers, and animation configuration for styled elements.
abstract class Style<S extends Spec<S>> extends Mix<StyleSpec<S>>
    implements StyleElement {
  final List<Variant<S>>? $variants;

  final WidgetModifierConfig? $modifier;
  final AnimationConfig? $animation;

  static final box = BoxStyler.new;
  static final text = TextStyler.new;
  static final icon = IconStyler.new;
  static final image = ImageStyler.new;
  static final stack = StackStyler.new;
  static final flex = FlexStyler.new;
  static final flexbox = FlexBoxStyler.new;
  static final stackbox = StackBoxStyler.new;

  const Style({
    required List<Variant<S>>? variants,
    required WidgetModifierConfig? modifier,
    required AnimationConfig? animation,
  }) : $modifier = modifier,
       $animation = animation,
       $variants = variants;

  @internal
  Set<WidgetState> get widgetStates {
    return ($variants ?? [])
        .whereType<TriggerVariant<S>>()
        .where((v) => v.trigger is WidgetStateTrigger)
        .map((v) => (v.trigger as WidgetStateTrigger).state)
        .toSet();
  }

  Style<S> withVariants(List<Variant<S>> value);

  ///
  /// This method evaluates which variants should be active based on the current
  /// context and named variants, then recursively processes nested variants
  /// within each active variant's style. The result is a fully merged style
  /// with all applicable variants applied.
  ///
  /// Variant priority order (lowest to highest):
  /// 1. StyleVariantMixin (applied first, lowest priority)
  /// 2. TriggerVariant and VariantBuilder (applied second)
  /// 3. WidgetStateVariant (applied last, highest priority)
  @visibleForTesting
  Style<S> mergeActiveVariants(
    BuildContext context, {
    required Set<String> namedVariants,
  }) {
    // Start with current style as base
    Style<S> mergedStyle = this;

    // 1. Filter variants that should be active in this context
    final activeVariants = ($variants ?? []).where((variantStyle) {
      if (variantStyle is TriggerVariant<S>) {
        return variantStyle.isActive(context);
      } else if (variantStyle is VariantBuilder<S>) {
        return true; // Always active
      }

      return false;
    }).toList();

    // 2. Aggregate ALL variant keys for context
    final aggregatedKeys = <String>{};

    // Add namedVariants (external activation)
    aggregatedKeys.addAll(namedVariants);

    // Add current style's key if it implements StyleVariantMixin
    if (this is StyleVariantMixin) {
      final styleVariant = this as StyleVariantMixin;
      aggregatedKeys.add(styleVariant.variantKey);
    }

    // Add keys from all active variants
    for (final variant in activeVariants) {
      aggregatedKeys.add(variant.variantKey);
    }

    // Add keys from StyleVariantMixin styles within variants (for context only)
    for (final variant in activeVariants) {
      if (variant is TriggerVariant<S>) {
        final style = variant.style;
        if (style is StyleVariantMixin) {
          final styleVariantMixin = style as StyleVariantMixin;
          aggregatedKeys.add(styleVariantMixin.variantKey);
        }
      } else if (variant is VariantBuilder<S>) {
        final style = variant.resolve(context);
        if (style is StyleVariantMixin) {
          final styleVariantMixin = style as StyleVariantMixin;
          aggregatedKeys.add(styleVariantMixin.variantKey);
        }
      }
    }

    // 3. Apply StyleVariantMixin at top level ONLY if not being handled by variants
    // Check if this StyleVariantMixin is already being handled by a variant
    final isInVariants = activeVariants.any((variant) {
      final variantStyle = variant is TriggerVariant<S>
          ? variant.style
          : variant is VariantBuilder<S>
              ? variant.resolve(context)
              : null;
      return variantStyle == this;
    });

    if (this is StyleVariantMixin && !isInVariants) {
      final styleVariant = this as StyleVariantMixin;
      // Pass aggregated keys MINUS its own key
      final keysForThis = Set<String>.of(aggregatedKeys)..remove(styleVariant.variantKey);
      final resultStyle = styleVariant.buildStyle(keysForThis);
      mergedStyle = resultStyle as Style<S>;
    }

    // 4. Sort by priority: TriggerVariant with WidgetStateTrigger gets applied last (highest priority)
    activeVariants.sort(
      (a, b) => Comparable.compare(
        (a is TriggerVariant<S> && a.trigger is WidgetStateTrigger) ? 1 : 0,
        (b is TriggerVariant<S> && b.trigger is WidgetStateTrigger) ? 1 : 0,
      ),
    );

    // 5. Merge variant styles with StyleVariantMixin support
    for (final variant in activeVariants) {
      Style<S> variantStyle;

      if (variant is TriggerVariant<S>) {
        variantStyle = variant.style;
      } else if (variant is VariantBuilder<S>) {
        variantStyle = variant.resolve(context);
      } else {
        continue; // Should not happen with our filtering above
      }

      // Process StyleVariantMixin inside variants by calling buildStyle()
      if (variantStyle is StyleVariantMixin) {
        final styleVariantMixin = variantStyle as StyleVariantMixin;
        // Pass aggregated keys MINUS its own key
        final keysForVariant = Set<String>.of(aggregatedKeys)..remove(styleVariantMixin.variantKey);
        variantStyle = styleVariantMixin.buildStyle(keysForVariant) as Style<S>;

        // StyleVariantMixin has already processed variants, merge directly
        mergedStyle = mergedStyle.merge(variantStyle);
      } else {
        // Continue with normal recursive processing for non-StyleVariantMixin
        final fullyResolvedStyle = variantStyle.mergeActiveVariants(
          context,
          namedVariants: namedVariants,
        );
        mergedStyle = mergedStyle.merge(fullyResolvedStyle);
      }
    }

    return mergedStyle;
  }

  /// Resolves this attribute to its concrete value using the provided [BuildContext].
  @override
  StyleSpec<S> resolve(BuildContext context);

  /// Merges this attribute with another attribute of the same type.
  @override
  Style<S> merge(covariant Style<S>? other);

  /// Builds the style into a fully resolved spec with metadata.
  ///
  /// This method resolves the style, which now includes animation and modifiers metadata.
  StyleSpec<S> build(
    BuildContext context, {
    Set<String> namedVariants = const {},
  }) {
    final styleData = mergeActiveVariants(
      context,
      namedVariants: namedVariants,
    );

    return styleData.resolve(context);
  }
}

abstract class ModifierMix<S extends WidgetModifier<S>> extends Mix<S>
    implements StyleElement {
  const ModifierMix();

  Type get mergeKey => S;

  @override
  ModifierMix<S> merge(covariant ModifierMix<S>? other);

  @override
  S resolve(BuildContext context);
}
