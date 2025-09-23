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
  final List<VariantStyle<S>>? $variants;

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
    required List<VariantStyle<S>>? variants,
    required WidgetModifierConfig? modifier,
    required AnimationConfig? animation,
  }) : $modifier = modifier,
       $animation = animation,
       $variants = variants;

  @internal
  Set<WidgetState> get widgetStates {
    return ($variants ?? [])
        .whereType<ContextVariantStyle<S>>()
        .where((v) => v.trigger is WidgetStateTrigger)
        .map((v) => (v.trigger as WidgetStateTrigger).state)
        .toSet();
  }

  Style<S> withVariants(List<VariantStyle<S>> value);

  /// Resolves variant-driven styling before producing a concrete spec.
  ///
  /// The resolution flow:
  /// * Determine which variants are active either because their context trigger
  ///   evaluates to true or because the caller manually requested them through
  ///   [namedVariants].
  /// * Ensure widget-state driven variants run last so they override any
  ///   lower-priority styling.
  /// * Recursively merge the resolved variant styles to build a single style
  ///   tree that reflects every active variant.
  @visibleForTesting
  Style<S> mergeActiveVariants(
    BuildContext context, {
    required Set<String> namedVariants,
  }) {
    // Start with current style as base
    Style<S> mergedStyle = this;

    // 1. Gather variants that should be applied for the current context/input
    final activeVariants = ($variants ?? []).where((variantStyle) {
      if (variantStyle is ContextVariantStyle<S>) {
        return variantStyle.isActive(context) ||
            namedVariants.contains(variantStyle.variantKey);
      } else if (variantStyle is VariantStyleBuilder<S>) {
        return true; // Always active
      }

      return false;
    }).toList();

    // 2. Widget state variants have the highest priority and should merge last
    activeVariants.sort(
      (a, b) => Comparable.compare(
        (a is ContextVariantStyle<S> && a.trigger is WidgetStateTrigger)
            ? 1
            : 0,
        (b is ContextVariantStyle<S> && b.trigger is WidgetStateTrigger)
            ? 1
            : 0,
      ),
    );

    // 3. Merge the styles contributed by each active variant
    for (final variant in activeVariants) {
      final variantStyle = switch (variant) {
        ContextVariantStyle<S> contextVariant => contextVariant.style,
        VariantStyleBuilder<S> builderVariant => builderVariant.resolve(context),
      };

      if (identical(variantStyle, this)) {
        continue; // Should not happen with our filtering above
      }

      mergedStyle = mergedStyle.merge(
        variantStyle.mergeActiveVariants(
          context,
          namedVariants: namedVariants,
        ),
      );
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
