import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../modifiers/widget_modifier_config.dart';
import '../variants/variant.dart';
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

/// Field metadata exposed by Styler classes produced by Mix's generator.
///
/// Protocols and tooling can use this capability to inspect a Styler's complete
/// field surface without duplicating generated field names. Handwritten Stylers
/// can implement this interface when they want to expose the same metadata.
abstract interface class StylerFieldMetadata {
  /// Names of every field represented by the Styler's [Mix.props].
  Set<String> get $stylerFieldNames;
}

/// Base class for style classes that can be resolved to specifications.
///
/// Provides variant support, modifiers, and animation configuration for styled elements.
abstract class Style<S extends Spec<S>> extends Mix<StyleSpec<S>>
    implements StyleElement {
  final List<VariantStyle<S>>? $variants;

  final WidgetModifierConfig? $modifier;
  final AnimationConfig? $animation;

  const Style({
    required List<VariantStyle<S>>? variants,
    required WidgetModifierConfig? modifier,
    required AnimationConfig? animation,
  }) : $modifier = modifier,
       $animation = animation,
       $variants = variants;

  /// Gets the closest [Style] from the widget tree.
  ///
  /// Throws a [FlutterError] if no [Style] is found in the widget tree.
  static Style<S> of<S extends Spec<S>>(BuildContext context) {
    final style = maybeOf<S>(context);
    if (style == null) {
      throw FlutterError.fromParts([
        ErrorSummary(
          'Style.of() called with a context that does not contain a Style of type $S.',
        ),
        ErrorDescription(
          'No Style<$S> ancestor could be found starting from the context that was passed to Style.of().',
        ),
        context.describeElement('The context used was'),
        ErrorHint(
          'If you are using StyleBuilder, set inheritable: true to provide the style to descendant widgets.',
        ),
      ]);
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
    final states = <WidgetState>{};
    // Identity, not equality, and it earns its keep twice over:
    //  1. Cycles. `$variants` is stored by reference, so a caller can pass a
    //     list to a styler constructor and then append the styler to that same
    //     list. Value equality would also recurse forever comparing the cycle.
    //  2. Sharing. A style instance can be shared between multiple context-
    //     variant branches, so identity avoids visiting it more than once.
    final visited = Set<Style<S>>.identity();

    void collectDependencies(Style<S> style) {
      if (!visited.add(style)) return;

      final variants = style.$variants;
      if (variants == null) return;

      for (final variantStyle in variants) {
        // Only ContextVariant-headed entries can activate through StyleBuilder,
        // which always resolves with empty namedVariants: NamedVariant branches
        // are inert until applyVariants hoists their value to the top level, and
        // ContextVariantBuilder ignores its stored placeholder value at
        // resolution. Walking them would mount the interaction detector for
        // states that can never fire.
        if (variantStyle.variant case final ContextVariant variant) {
          states.addAll(variant.widgetStateDependencies);
          collectDependencies(variantStyle.value);
        }
      }
    }

    collectDependencies(this);

    return states;
  }

  /// Merges all active variants with their nested variants recursively.
  ///
  /// Evaluates which variants are active in [context] and against
  /// [namedVariants], then recursively resolves the nested variants inside each
  /// active variant's style.
  ///
  /// Active variants apply in two priority groups, lowest first: those that
  /// declare no [ContextVariant.widgetStateDependencies], then those that do.
  /// Within a group, the variant declared last merges last and so wins on the
  /// properties they share.
  @visibleForTesting
  Style<S> mergeActiveVariants(
    BuildContext context, {
    required Set<NamedVariant> namedVariants,
  }) {
    final variants = $variants;
    if (variants == null) return this;

    // Partition, don't sort: declaration order inside a group is load-bearing,
    // and List.sort is only stable by accident of the insertion sort it falls
    // back to below 32 elements.
    final lowPriority = <VariantStyle<S>>[];
    final highPriority = <VariantStyle<S>>[];

    for (final variantAttr in variants) {
      final variant = variantAttr.variant;

      final isActive = switch (variant) {
        ContextVariant() => variant.when(context),
        NamedVariant() => namedVariants.contains(variant),
        ContextVariantBuilder() => true,
      };
      if (!isActive) continue;

      // Keyed off the declaration, not the class: FocusVisibleVariant is not a
      // WidgetStateVariant yet reads WidgetState.focused just the same, and
      // NotVariant forwards whatever its inner variant reads.
      //
      // The getter stays on ContextVariant rather than moving up to Variant
      // because ContextVariant is also the only kind widgetStates walks, so a
      // dependency declared on any other kind would never get tracking
      // installed.
      final readsWidgetState =
          variant is ContextVariant &&
          variant.widgetStateDependencies.isNotEmpty;

      (readsWidgetState ? highPriority : lowPriority).add(variantAttr);
    }

    // Extract the style from each active variant
    final stylesToMerge = <(Style<S>, bool)>[]; // (style, isFromStyleVariation)

    for (final variantAttr in lowPriority.followedBy(highPriority)) {
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
          // For regular variants, recursively resolve any nested variants
          : variantStyle.mergeActiveVariants(
              context,
              namedVariants: namedVariants,
            );
      mergedStyle = _mergeStyles(mergedStyle, fullyResolvedStyle);
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

Style<S> _mergeStyles<S extends Spec<S>>(Style<S> current, Style<S> other) {
  if (current is IdentityStyle<S>) {
    return other;
  }

  if (other is IdentityStyle<S>) {
    return current;
  }

  return current.merge(other);
}

/// A no-op [Style] that resolves to a provided [Spec].
///
/// This is useful for widget defaults where a concrete generated styler should
/// not be required just to identify the default resolved spec.
final class IdentityStyle<S extends Spec<S>> extends Style<S>
    with Diagnosticable {
  /// The spec used when this identity style is resolved.
  final S spec;

  /// Creates an identity style that resolves to [spec].
  const IdentityStyle(this.spec)
    : super(variants: null, modifier: null, animation: null);

  @override
  Style<S> merge(covariant Style<S>? other) {
    return other ?? this;
  }

  @override
  StyleSpec<S> resolve(BuildContext context) {
    return StyleSpec(spec: spec);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<S>('spec', spec));
  }

  @override
  List<Object?> get props => [spec];
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

enum _VariantMergeNamespace { named, context, builder }

// Keep diagnostic labels out of semantic identity. Record equality delegates
// to the value semantics already defined by each supported variant kind.
Object _variantMergeKey(Variant variant) {
  return switch (variant) {
    NamedVariant(:final name) => (_VariantMergeNamespace.named, name),
    ContextVariantBuilder(:final fn) => (_VariantMergeNamespace.builder, fn),
    ContextVariant() => (_VariantMergeNamespace.context, variant),
  };
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

    if (mergeKey != other.mergeKey) {
      throw ArgumentError(
        'Cannot merge VariantStyle with different variants. '
        '${variant.runtimeType}(key: "${variant.key}") and '
        '${other.variant.runtimeType}(key: "${other.variant.key}") do not '
        'have the same semantic merge identity.',
      );
    }

    return VariantStyle(variant, _mergeStyles(_style, other._style));
  }

  @override
  List<Object?> get props => [variant, _style];

  /// Opaque semantic identity used when merging variant style fragments.
  @override
  Object get mergeKey => _variantMergeKey(variant);
}
