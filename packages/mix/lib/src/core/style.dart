import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../animation/animation_config.dart';
import '../modifiers/modifier_config.dart';
import '../specs/box/box_attribute.dart';
import '../specs/flex/flex_attribute.dart';
import '../specs/flexbox/flexbox_attribute.dart';
import '../specs/icon/icon_attribute.dart';
import '../specs/image/image_attribute.dart';
import '../specs/stack/stack_attribute.dart';
import '../specs/stack/stack_box_attribute.dart';
import '../specs/text/text_attribute.dart';
import '../variants/variant.dart';
import 'internal/compare_mixin.dart';
import 'mix_element.dart';
import 'modifier.dart';
import 'widget_spec.dart';

/// This is used just to pass all the values into one place if needed
@internal
sealed class StyleElement {
  const StyleElement();
}

/// Base class for style containers that can be resolved to specifications.
///
/// Provides variant support, modifiers, and animation configuration for styled elements.
abstract class Style<S extends WidgetSpec<S>> extends Mix<S> implements StyleElement {
  final List<VariantStyle<S>>? $variants;

  final ModifierConfig? $modifier;
  final AnimationConfig? $animation;

  final bool? $inherit;

  const Style({
    required List<VariantStyle<S>>? variants,
    required ModifierConfig? modifier,
    required AnimationConfig? animation,
    required bool? inherit,
  }) : $modifier = modifier,
       $animation = animation,
       $variants = variants,
       $inherit = inherit;

  static BoxMix box(BoxMix value) => value;
  static TextMix text(TextMix value) => value;
  static IconMix icon(IconMix value) => value;
  static ImageMix image(ImageMix value) => value;
  static StackMix stack(StackMix value) => value;
  static FlexMix flex(FlexMix value) => value;
  static FlexBoxMix flexbox(FlexBoxMix value) => value;
  static StackBoxMix stackbox(StackBoxMix value) => value;

  @internal
  Set<WidgetState> get widgetStates {
    return ($variants ?? [])
        .where((v) => v.variant is WidgetStateVariant)
        .map((v) => (v.variant as WidgetStateVariant).state)
        .toSet();
  }

  @protected
  List<ModifierMix>? mergeModifierLists(
    List<ModifierMix>? current,
    List<ModifierMix>? other,
  ) {
    if (current == null && other == null) return null;
    if (current == null) return List.of(other!);
    if (other == null) return List.of(current);

    final Map<Object, ModifierMix> merged = {};

    for (final modifier in current) {
      merged[modifier.mergeKey] = modifier;
    }

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
  List<VariantStyle<S>>? mergeVariantLists(
    List<VariantStyle<S>>? current,
    List<VariantStyle<S>>? other,
  ) {
    if (current == null && other == null) return null;
    if (current == null) return List<VariantStyle<S>>.of(other!);
    if (other == null) return List<VariantStyle<S>>.of(current);

    final Map<Object, VariantStyle<S>> merged = {};

    for (final variant in current) {
      merged[variant.mergeKey] = variant;
    }

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

  /// Builds the style into a fully resolved spec with metadata.
  ///
  /// This method resolves the style, which now includes animation, modifiers, and inherit metadata.
  S build(
    BuildContext context, {
    Set<NamedVariant> namedVariants = const {},
  }) {
    final styleData = getAllStyleVariants(
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
final class VariantStyle<S extends WidgetSpec<S>> extends Mixable<S>
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
    if (other == null || other.variant != variant) return this;

    return VariantStyle(variant, _style.merge(other._style));
  }

  @override
  List<Object?> get props => [variant, _style];

  @override
  Object get mergeKey => variant.key;
}
