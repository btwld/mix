import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../animation/animation_config.dart';
import '../modifiers/align_modifier.dart';
import '../modifiers/aspect_ratio_modifier.dart';
import '../modifiers/clip_modifier.dart';
import '../modifiers/flexible_modifier.dart';
import '../modifiers/fractionally_sized_box_modifier.dart';
import '../modifiers/intrinsic_modifier.dart';
import '../modifiers/opacity_modifier.dart';
import '../modifiers/padding_modifier.dart';
import '../modifiers/rotated_box_modifier.dart';
import '../modifiers/sized_box_modifier.dart';
import '../modifiers/transform_modifier.dart';
import '../modifiers/visibility_modifier.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/painting/border_radius_mix.dart';
import '../variants/variant.dart';
import 'internal/compare_mixin.dart';
import 'internal/constants.dart';
import 'mix_element.dart';
import 'modifier.dart';
import 'spec.dart';

/// Base class for style containers that can be resolved to specifications.
///
/// Provides variant support, modifiers, and animation configuration for styled elements.
abstract class StyleAttribute<S extends Spec<S>>
    extends Mixable<StyleAttribute<S>>
    with EqualityMixin, Resolvable<S> {
  final List<VariantStyleAttribute<S>>? $variants;
  final List<ModifierAttribute>? $modifiers;
  final AnimationConfig? $animation;

  const StyleAttribute({
    List<VariantStyleAttribute<S>>? variants,
    List<ModifierAttribute>? modifiers,
    AnimationConfig? animation,
  }) : $modifiers = modifiers,
       $animation = animation,
       $variants = variants;

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
  StyleAttribute<S> getAllStyleVariants(
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

    final variantStyles = variants
        .map((variantAttr) => variantAttr.value)
        .toList();

    StyleAttribute<S> styleData = this;

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
  StyleAttribute<S> merge(covariant StyleAttribute<S>? other);

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

/// Mixin that provides modifiers and variants methods for spec attributes
mixin SpecAttributeMixin<S extends Spec<S>> on StyleAttribute<S> {
  /// Adds modifiers to this attribute
  StyleAttribute<S> modifiers(List<ModifierAttribute> modifiers);

  /// Adds variants to this attribute
  StyleAttribute<S> variants(List<VariantStyleAttribute<S>> variants);

  // Convenience methods for common modifiers

  /// Wraps the widget with an Opacity modifier
  StyleAttribute<S> wrapOpacity(double opacity) {
    return modifiers([OpacityModifierAttribute.only(opacity: opacity)]);
  }

  /// Wraps the widget with a Padding modifier
  /// Accepts any EdgeInsetsGeometry value (EdgeInsets.all(), EdgeInsets.symmetric(), etc.)
  StyleAttribute<S> wrapPadding(EdgeInsetsGeometry padding) {
    return modifiers([
      PaddingModifierAttribute.only(
        padding: EdgeInsetsGeometryMix.value(padding),
      ),
    ]);
  }

  /// Wraps the widget with a ClipOval modifier
  StyleAttribute<S> wrapClipOval({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return modifiers([
      ClipOvalModifierAttribute.only(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    ]);
  }

  /// Wraps the widget with a ClipRRect modifier
  /// Accepts any BorderRadius value (BorderRadius.circular(), BorderRadius.all(), etc.)
  StyleAttribute<S> wrapClipRRect({
    BorderRadius? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return modifiers([
      ClipRRectModifierAttribute.only(
        borderRadius: borderRadius != null ? BorderRadiusGeometryMix.value(borderRadius) : null,
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    ]);
  }

  /// Wraps the widget with a ClipRect modifier
  StyleAttribute<S> wrapClipRect({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return modifiers([
      ClipRectModifierAttribute.only(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    ]);
  }

  /// Wraps the widget with a ClipPath modifier
  StyleAttribute<S> wrapClipPath({
    CustomClipper<Path>? clipper,
    Clip? clipBehavior,
  }) {
    return modifiers([
      ClipPathModifierAttribute.only(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    ]);
  }

  /// Wraps the widget with a Visibility modifier
  StyleAttribute<S> wrapVisibility(bool visible) {
    return modifiers([
      VisibilityModifierAttribute.only(visible: visible),
    ]);
  }

  /// Wraps the widget with an AspectRatio modifier
  StyleAttribute<S> wrapAspectRatio(double aspectRatio) {
    return modifiers([AspectRatioModifierAttribute.only(aspectRatio: aspectRatio)]);
  }

  /// Wraps the widget with a Flexible modifier
  StyleAttribute<S> wrapFlexible({
    int? flex,
    FlexFit? fit,
  }) {
    return modifiers([
      FlexibleModifierAttribute.only(
        flex: flex,
        fit: fit,
      ),
    ]);
  }

  /// Wraps the widget with an Expanded modifier (Flexible with flex: 1)
  StyleAttribute<S> wrapExpanded({int flex = 1}) {
    return modifiers([
      FlexibleModifierAttribute.only(
        flex: flex,
        fit: FlexFit.tight,
      ),
    ]);
  }

  /// Wraps the widget with a Transform modifier for scaling
  StyleAttribute<S> wrapScale(double scale, {Alignment? alignment}) {
    final transform = Matrix4.diagonal3Values(scale, scale, 1.0);
    return modifiers([
      TransformModifierAttribute.only(
        transform: transform,
        alignment: alignment ?? Alignment.center,
      ),
    ]);
  }

  /// Wraps the widget with a Transform modifier for rotation
  StyleAttribute<S> wrapRotate(double angle, {Alignment? alignment}) {
    final transform = Matrix4.rotationZ(angle);
    return modifiers([
      TransformModifierAttribute.only(
        transform: transform,
        alignment: alignment ?? Alignment.center,
      ),
    ]);
  }

  /// Wraps the widget with a Transform modifier for translation
  StyleAttribute<S> wrapTranslate({double? x, double? y}) {
    final transform = Matrix4.translationValues(x ?? 0, y ?? 0, 0.0);
    return modifiers([
      TransformModifierAttribute.only(
        transform: transform,
      ),
    ]);
  }

  /// Wraps the widget with a SizedBox modifier
  StyleAttribute<S> wrapSizedBox({
    double? width,
    double? height,
  }) {
    return modifiers([
      SizedBoxModifierAttribute.only(
        width: width,
        height: height,
      ),
    ]);
  }

  /// Wraps the widget with a ConstrainedBox modifier
  /// Accepts any BoxConstraints value (BoxConstraints.tight(), BoxConstraints.expand(), etc.)
  StyleAttribute<S> wrapConstrainedBox(BoxConstraints constraints) {
    return modifiers([
      SizedBoxModifierAttribute.only(
        width: constraints.hasBoundedWidth ? constraints.maxWidth : null,
        height: constraints.hasBoundedHeight ? constraints.maxHeight : null,
      ),
    ]);
  }


  /// Wraps the widget with an Align modifier
  StyleAttribute<S> wrapAlign(AlignmentGeometry alignment, {
    double? widthFactor,
    double? heightFactor,
  }) {
    return modifiers([
      AlignModifierAttribute.only(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    ]);
  }

  /// Wraps the widget with a Center modifier (Align with center alignment)
  StyleAttribute<S> wrapCenter() {
    return wrapAlign(Alignment.center);
  }

  /// Wraps the widget with a FractionallySizedBox modifier
  StyleAttribute<S> wrapFractionallySizedBox({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return modifiers([
      FractionallySizedBoxModifierAttribute.only(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    ]);
  }

  /// Wraps the widget with a RotatedBox modifier
  StyleAttribute<S> wrapRotatedBox(int quarterTurns) {
    return modifiers([RotatedBoxModifierAttribute.only(quarterTurns: quarterTurns)]);
  }

  /// Wraps the widget with an IntrinsicWidth modifier
  StyleAttribute<S> wrapIntrinsicWidth() {
    return modifiers([const IntrinsicWidthModifierAttribute()]);
  }

  /// Wraps the widget with an IntrinsicHeight modifier
  StyleAttribute<S> wrapIntrinsicHeight() {
    return modifiers([const IntrinsicHeightModifierAttribute()]);
  }
}

abstract class ModifierAttribute<S extends Modifier<S>>
    extends StyleAttribute<S> {
  const ModifierAttribute();

  @override
  ModifierAttribute<S> merge(covariant ModifierAttribute<S>? other);

  @override
  S resolve(BuildContext context);

  @override
  Type get mergeKey => S;
}

/// Variant wrapper for conditional styling
final class VariantStyleAttribute<S extends Spec<S>> extends StyleAttribute<S> {
  final Variant variant;
  final StyleAttribute<S> _style;

  const VariantStyleAttribute(this.variant, StyleAttribute<S> style)
    : _style = style;

  StyleAttribute<S> get value => _style;

  bool matches(Iterable<Variant> otherVariants) =>
      otherVariants.contains(variant);

  VariantStyleAttribute<S>? removeVariants(Iterable<Variant> variantsToRemove) {
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
        : VariantStyleAttribute(remainingVariant, _style);
  }

  @override
  S resolve(BuildContext context) {
    return _style.resolve(context);
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

class Style extends StyleAttribute<MultiSpec> {
  final Map<Object, StyleAttribute> _attributes;

  Style._({
    required List<StyleAttribute> attributes,
    super.animation,
    super.modifiers,
    super.variants,
  }) : _attributes = {for (var attr in attributes) attr.mergeKey: attr};

  /// Creates a new `Style` instance with specified list of [StyleAttribute]s.
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
  factory Style([
    StyleAttribute? p1,
    StyleAttribute? p2,
    StyleAttribute? p3,
    StyleAttribute? p4,
    StyleAttribute? p5,
    StyleAttribute? p6,
    StyleAttribute? p7,
    StyleAttribute? p8,
    StyleAttribute? p9,
    StyleAttribute? p10,
    StyleAttribute? p11,
    StyleAttribute? p12,
    StyleAttribute? p13,
    StyleAttribute? p14,
    StyleAttribute? p15,
    StyleAttribute? p16,
    StyleAttribute? p17,
    StyleAttribute? p18,
    StyleAttribute? p19,
    StyleAttribute? p20,
  ]) {
    final params = [
      p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, //
      p11, p12, p13, p14, p15, p16, p17, p18, p19, p20,
    ].whereType<StyleAttribute>();

    return Style.create(params);
  }

  /// Constructs a `Style` from an iterable of [StyleAttribute] instances.
  ///
  /// This factory constructor segregates the style elements into attributes
  /// and variants, initializing a new `MultiSpecAttribute` with these collections.
  /// Since Attribute extends StyleAttribute, this is backward compatible.
  ///
  /// Example:
  /// ```dart
  /// final style = Style.create([attribute1, attribute2]);
  /// ```
  factory Style.create(Iterable<StyleAttribute> elements) {
    final styleList = <StyleAttribute>[];
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
        case StyleAttribute():
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
  List<StyleAttribute> get attributes => _attributes.values.toList();

  Style animate({Duration? duration, Curve? curve}) {
    return Style._(
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
  Style merge(Style? other) {
    if (other == null) return this;

    final mergedAttributes = <StyleAttribute>[];

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

  const ResolvedStyle({this.spec, this.animation, this.modifiers});

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

/// Protected extension for StyleAttribute classes to build PropUtility instances
