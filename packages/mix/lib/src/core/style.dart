import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../modifiers/widget_modifier_config.dart';
import '../variants/variant.dart';
import 'internal/compare_mixin.dart';
import 'mix_element.dart';
import 'providers/style_provider.dart';
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
  final InlineStyleBuilder<S>? $inlineBuilder;

  const Style({
    required List<VariantStyle<S>>? variants,
    required WidgetModifierConfig? modifier,
    required AnimationConfig? animation,
    InlineStyleBuilder<S>? inlineBuilder,
  }) : $modifier = modifier,
       $animation = animation,
       $variants = variants,
       $inlineBuilder = inlineBuilder;

  /// Gets the closest [Style] from the widget tree.
  ///
  /// Throws a [FlutterError] if no [Style] is found in the widget tree.
  static Style<S> of<S extends Spec<S>>(BuildContext context) {
    final style = maybeOf<S>(context);
    if (style == null) {
      throw FlutterError(
        'Style.of() called with a context that does not contain a Style of type $S.\n'
        'No Style<$S> ancestor could be found starting from the context that was passed to Style.of().\n\n'
        'If you are using StyleBuilder, make sure to set inheritable: true to provide the style to descendant widgets.\n\n'
        'The context used was:\n'
        '  $context',
      );
    }

    return style;
  }

  /// Gets the closest [Style] from the widget tree, or null if not found.
  static Style<S>? maybeOf<S extends Spec<S>>(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<StyleProvider<S>>();

    return provider?.style;
  }

  @internal
  Set<WidgetState> get widgetStates {
    return {
      ...($variants ?? [])
          .where((v) => v.variant is WidgetStateVariant)
          .map((v) => (v.variant as WidgetStateVariant).state),
      ...?$inlineBuilder?.tail?.widgetStates,
    };
  }

  /// Rebuilds this style with `$inlineBuilder` cleared.
  ///
  /// Used by [resolveInlineBuilders] to produce the "root" style that precedes
  /// the inline builder's output. Concrete stylers generate this via the
  /// `_$XStylerMixin` (see `styler_mixin_builder.dart`).
  @protected
  Style<S> copyWithoutInlineBuilder();

  /// Expands any [InlineStyleBuilder] attached to this style (and to any
  /// nested variant styles) so that the final merge order reflects the
  /// original fluent-call order.
  ///
  /// Must be called before [mergeActiveVariants] so the expanded styles
  /// participate in normal variant resolution.
  @visibleForTesting
  Style<S> resolveInlineBuilders(BuildContext context) {
    final inline = $inlineBuilder;
    if (inline == null) return this;

    final base = copyWithoutInlineBuilder();
    final built = inline.build(context).resolveInlineBuilders(context);
    final tail = inline.tail?.resolveInlineBuilders(context);

    var result = base.merge(built);
    if (tail != null) result = result.merge(tail);

    return result;
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
  /// 2. StyleVariation (applied second)
  /// 3. WidgetStateVariant (applied last, highest priority)
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
    final stylesToMerge = <(Style<S>, bool)>[]; // (style, isFromStyleVariation)

    for (final variantAttr in activeVariants) {
      final result = switch (variantAttr.variant) {
        ContextVariantBuilder variant => (
          variant.build(context) as Style<S>,
          false,
        ),
        (ContextVariant() || NamedVariant()) => () {
          // Check if the value is a StyleVariation
          // ignore: avoid-unrelated-type-assertions
          if (variantAttr.value is StyleVariation<S>) {
            // ignore: avoid-unrelated-type-casts
            final styleVariation = variantAttr.value as StyleVariation<S>;
            // Only apply if this variant is active
            if (namedVariants.contains(styleVariation.variantType)) {
              return (
                styleVariation.styleBuilder(this, namedVariants, context),
                true,
              );
            }
          }

          return (variantAttr.value, false);
        }(),
      };
      stylesToMerge.add(result);
    }

    // Start with current style as base
    Style<S> mergedStyle = this;

    // Merge each variant style, recursively resolving nested variants
    for (final (variantStyle, isFromStyleVariation) in stylesToMerge) {
      final fullyResolvedStyle = isFromStyleVariation
          // For StyleVariation results, we don't recursively resolve variants
          // since StyleVariation.styleBuilder should handle its own variant logic
          // and return a final style. This prevents infinite recursion.
          ? variantStyle
          // For regular variants, expand inline builders then recursively
          // resolve any nested variants.
          : variantStyle
                .resolveInlineBuilders(context)
                .mergeActiveVariants(context, namedVariants: namedVariants);
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
    final expanded = resolveInlineBuilders(context);
    final styleData = expanded.mergeActiveVariants(
      context,
      namedVariants: namedVariants,
    );

    return styleData.resolve(context);
  }
}

/// Carries a lazy, context-dependent style plus any styles that should be
/// merged *after* the builder's result.
///
/// This is what powers in-place `.onBuilder(...)` resolution: chain calls that
/// follow an `.onBuilder` accumulate into [tail], so the final merge order is
/// preserved as `baseRoot -> builder(context) -> tail`.
@immutable
final class InlineStyleBuilder<S extends Spec<S>> {
  final Style<S> Function(BuildContext context) build;
  final Style<S>? tail;

  const InlineStyleBuilder(this.build, {this.tail});

  InlineStyleBuilder<S> append(Style<S> other) {
    return InlineStyleBuilder(
      build,
      tail: tail == null ? other : tail!.merge(other),
    );
  }
}

abstract class ModifierMix<S extends WidgetModifier<S>> extends Mix<S>
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

    if (variant.key != other.variant.key) {
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
