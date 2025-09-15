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

  ///
  /// This method evaluates which variants should be active based on the current
  /// context and named variants, then recursively processes nested variants
  /// within each active variant's style. The result is a fully merged style
  /// with all applicable variants applied.
  ///
  /// Variant priority order (lowest to highest):
  /// 1. EventVariantStyle and VariantStyleBuilder (applied first)
  /// 2. WidgetStateVariant (applied last, highest priority)
  @visibleForTesting
  Style<S> mergeActiveVariants(
    BuildContext context, {
    required Set<String> namedVariants,
  }) {
    // Start with current style as base
    Style<S> mergedStyle = this;

    // 1. Filter variants that should be active in this context
    final activeVariants = ($variants ?? []).where((variantStyle) {
      if (variantStyle is ContextVariantStyle<S>) {
        return variantStyle.isActive(context) ||
            namedVariants.contains(variantStyle.variantKey);
      } else if (variantStyle is VariantStyleBuilder<S>) {
        return true; // Always active
      }

      return false;
    }).toList();

    // 2. Sort by priority: EventVariantStyle with WidgetStateTrigger gets applied last (highest priority)
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

    // 3. Merge variant styles recursively
    for (final variant in activeVariants) {
      Style<S>? variantStyle;

      if (variant is ContextVariantStyle<S>) {
        variantStyle = variant.style;
      } else if (variant is VariantStyleBuilder<S>) {
        variantStyle = variant.resolve(context);
      }

      if (variantStyle == null || identical(variantStyle, this)) {
        continue; // Should not happen with our filtering above
      }

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
