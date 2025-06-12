// ignore_for_file: non_constant_identifier_names, constant_identifier_names, long-parameter-list, prefer-named-boolean-parameters

import 'package:flutter/widgets.dart';

import '../../attributes/animated/animated_data.dart';
import '../../attributes/nested_style/nested_style_attribute.dart';
import '../../internal/compare_mixin.dart';
import '../../internal/helper_util.dart';
import '../../specs/spec_util.dart';
import '../../variants/variant_attribute.dart';
import '../attributes_map.dart';
import '../element.dart';
import '../spec.dart';
import '../variant.dart';
import 'mix_data.dart';

/// A utility class for managing a collection of styling attributes and variants.
///
/// The `Style` class is used to encapsulate a set of styling attributes and
/// variants which can be applied to a widget. This class provides several
/// factory constructors and utility methods to help create, manipulate, and
/// merge collections of styling attributes and variants.
///
/// Example:
/// ```dart
/// final style = Style(attribute1, attribute2, attribute3);
/// final updatedStyle = style.variant(myVariant);
/// ```
class Style with EqualityMixin {
  /// Visual attributes contained in this mix.
  final AttributeMap<SpecAttribute> styles;

  /// The variant attributes contained in this mix.
  final AttributeMap<VariantAttribute> variants;

  /// A constant, empty mix for use with const constructor widgets.
  ///
  /// This can be used as a default or initial value where a `Style` is required.
  const Style.empty()
      : styles = const AttributeMap.empty(),
        variants = const AttributeMap.empty();

  const Style._({required this.styles, required this.variants});

  /// Creates a new `Style` instance with a specified list of [Attribute]s.
  ///
  /// This factory constructor initializes a `Style` with a list of
  /// attributes provided as individual parameters. Only non-null attributes
  /// are included in the resulting `Style`.
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
    Attribute? p1,
    Attribute? p2,
    Attribute? p3,
    Attribute? p4,
    Attribute? p5,
    Attribute? p6,
    Attribute? p7,
    Attribute? p8,
    Attribute? p9,
    Attribute? p10,
    Attribute? p11,
    Attribute? p12,
    Attribute? p13,
    Attribute? p14,
    Attribute? p15,
    Attribute? p16,
    Attribute? p17,
    Attribute? p18,
    Attribute? p19,
    Attribute? p20,
  ]) {
    final params = [
      p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, //
      p11, p12, p13, p14, p15, p16, p17, p18, p19, p20,
    ].whereType<Attribute>();

    return Style.create(params);
  }

  /// Constructs a `Style` from an iterable of [Attribute] instances.
  ///
  /// This factory constructor segregates the attributes into visual and variant
  /// attributes, initializing a new `Style` with these segregated collections.
  ///
  /// Example:
  /// ```dart
  /// final style = Style.create([attribute1, attribute2]);
  /// ```
  factory Style.create(Iterable<Attribute> attributes) {
    final applyVariants = <VariantAttribute>[];
    final styleList = <SpecAttribute>[];

    for (final attribute in attributes) {
      switch (attribute) {
        case FluentAttribute():
          styleList.add(attribute.value);
          applyVariants.addAll(attribute.variants);
        case SpecAttribute():
          styleList.add(attribute);
        case VariantAttribute():
          applyVariants.add(attribute);
        case NestedStyleAttribute():
          applyVariants.addAll(attribute.value.variants.values);
          styleList.addAll(attribute.value.styles.values);
        case SpecUtility():
          if (attribute.attributeValue != null) {
            final nestedStyle = Style.create([attribute.attributeValue!]);
            styleList.addAll(nestedStyle.styles.values);
            applyVariants.addAll(nestedStyle.variants.values);
          }
        default:
          throw FlutterError.fromParts([
            ErrorSummary(
              'Unsupported attribute type encountered in Style creation.',
            ),
            ErrorDescription(
              'The attribute of type ${attribute.runtimeType} is not supported.',
            ),
            ErrorHint(
              'Custom Attributes must be subclasses of one of the following types: '
              'StyledAttribute, VariantAttribute, NestedStyleAttribute, or SpecUtility. '
              'Please ensure your attribute implements one of these supported types.',
            ),
          ]);
      }
    }

    return Style._(
      styles: AttributeMap(styleList),
      variants: AttributeMap(applyVariants),
    );
  }

  /// Combines a positional list of [mixes] into a single `Style`.
  ///
  /// This factory constructor iterates through the list of [mixes] params, merging
  /// each mix with the previous mix and returning the final combined `Style`.
  ///
  /// Example:
  /// ```dart
  /// final combinedStyle = Style.combine([style1, style2, style3]);
  /// ```
  static Style combine(Iterable<Style> mixes) {
    return mixes.isEmpty
        ? const Style.empty()
        : mixes.reduce((combinedStyle, mix) => combinedStyle.merge(mix));
  }

  /// Returns all utilities, allowing you to use your own namespace
  static MixUtilities utilities() => const MixUtilities();

  static get asAttribute => const SpreadFunctionParams<Attribute, Attribute>(
        NestedStyleAttribute.fromList,
      );

  bool get isAnimated => this is AnimatedStyle;

  /// Returns a list of all attributes contained in this mix.
  ///
  /// This includes both visual and variant attributes.
  Iterable<Attribute> get values => [...styles.values, ...variants.values];

  /// Returns true if this Style does not contain any attributes or variants.
  bool get isEmpty => styles.isEmpty && variants.isEmpty;

  /// Returns false if this Style contains any attributes or variants.
  bool get isNotEmpty => !isEmpty;

  /// Returns the length of the list of attributes contained in this mix.
  ///
  /// This includes both visual and variant attributes.
  int get length => values.length;

  /// Allows to create a new `Style` by using this mix as a base and adding additional attributes.
  SpreadFunctionParams<Attribute, Style> get add =>
      SpreadFunctionParams(addAll);

  /// Selects a single or positional params list of [Variant] and returns a new `Style` with the selected variants.
  ///
  /// If the [applyVariant] is not initially part of the `Style`, this method returns this mix without any changes.
  /// Otherwise, the method merges the attributes of the selected [applyVariant] into a new `Style` instance.
  SpreadFunctionParams<Variant, Style> get applyVariant =>
      SpreadFunctionParams(applyVariants);

  Style addAll(Iterable<Attribute> attributes) {
    return merge(Style.create(attributes));
  }

  MixData of(BuildContext context) => MixData.create(context, this);

  /// Returns a `AnimatedStyle` from this `Style` with the provided [duration] and [curve].
  AnimatedStyle animate({
    Duration? duration,
    Curve? curve,
    VoidCallback? onEnd,
  }) {
    return AnimatedStyle._(
      styles: styles,
      variants: variants,
      animated: AnimatedData(duration: duration, curve: curve, onEnd: onEnd),
    );
  }

  /// Returns a new `Style` with the provided [styles] and [variants] merged with this mix's values.
  ///
  /// If [styles] or [variants] is null, the corresponding attribute map of this mix is used.
  Style copyWith({
    AttributeMap<SpecAttribute>? styles,
    AttributeMap<VariantAttribute>? variants,
  }) {
    return Style._(
      styles: styles ?? this.styles,
      variants: variants ?? this.variants,
    );
  }

  /// Merges this mix with the provided [Style] instances and returns the resulting `Style`.
  ///
  /// This method combines the visual and variant attributes of this mix and the provided [Style] instances.
  /// If a null value is provided for any of the parameters, it is ignored.
  ///
  /// This method combines the visual and variant attributes of this mix and the provided [mix].
  Style merge(Style? style) {
    if (style == null) return this;

    final mergedStyles = styles.merge(style.styles);
    final mergedVariants = variants.merge(style.variants);

    if (style is AnimatedStyle) {
      return AnimatedStyle._(
        styles: mergedStyles,
        variants: mergedVariants,
        animated: style.animated,
      );
    }

    return copyWith(styles: mergedStyles, variants: mergedVariants);
  }

  /// Selects multiple [Variant] instances and returns a new `Style` with the selected variants.
  ///
  /// If the [applyVariants] list is empty, returns this mix without any changes.
  /// Otherwise, the method merges the attributes of the selected variants into a new `Style` instance.
  ///
  /// Example:
  /// ```dart
  /// final outlinedVariant = Variant('outlined');
  /// final smallVariant = Variant('small');
  /// final style = Style(
  ///   attr1,
  ///   attr2,
  ///   outlinedVariant(attr3, attr4),
  ///   smallVariant(attr5),
  /// );
  /// final outlinedSmallMix = style.applyVariants([outlinedVariant, smallVariant]);
  /// ```
  ///
  /// In this example:
  /// - Two `Variant` instances `outlinedVariant` and `smallVariant` are created.
  /// - An initial `Style` instance `style` is created with `attr1` and `attr2`, along with the two variants.
  /// - The `applyVariants` method is called on the `Style` instance with a list of `outlinedVariant` and `smallVariant` as the argument.
  /// - The `applyVariants` method returns a new `Style` instance `outlinedSmallMix` with the attributes of the selected variants merged.
  /// - The resulting `outlinedSmallMix` is equivalent to `Style(attr1, attr2, attr3, attr4, attr5)`.
  ///
  /// Note:
  /// The attributes from the selected variants (`attr3`, `attr4`, and `attr5`) are not applied to the `Style` instance until the `applyVariants` method is called.
  Style applyVariants(List<Variant> selectedVariants) {
    /// Return the original Style if no variants were selected
    if (selectedVariants.isEmpty) {
      return this;
    }

    /// Initializing two empty lists that store the matched and remaining `Variants`, respectively.
    final matchedVariants = <VariantAttribute>[];
    final remainingVariants = <VariantAttribute>[];

    /// Loop over all VariantAttributes in variants only once instead of a nested loop,
    /// checking if each one matches with the selected variants.
    /// If it does, add it to the matchedVariants, else add it to remainingVariants.
    for (final variant in variants.values) {
      if (variant.matches(selectedVariants)) {
        matchedVariants.add(variant);
      } else {
        final remainingVariant = variant.removeVariants(selectedVariants);
        if (remainingVariant != null) {
          remainingVariants.add(remainingVariant);
        }
      }
    }

    final updatedStyle = Style._(
      styles: styles,
      variants: AttributeMap(remainingVariants),
    );

    /// If not a single variant was matched, return the original Style.
    if (matchedVariants.isEmpty) {
      return updatedStyle;
    }

    /// Create a Style from the matched variants.
    final styleToApply =
        Style.combine(matchedVariants.map((e) => e.value).toList());

    /// Merge the new Style created with the existing Style, excluding the matched variants.
    final mergedStyle = updatedStyle.merge(styleToApply);

    /// Apply all variants and return the final Style.
    return mergedStyle.applyVariants(selectedVariants);
  }

  /// Returns a new `NestedStyleAttribute` instance that wraps the current `Style` instance.
  ///
  /// This method is used to create a nested style attribute, which can be used to apply a `Style` instance
  /// as an attribute within another `Style` instance.
  NestedStyleAttribute call() => NestedStyleAttribute(this);

  /// Picks and applies only the attributes within the specified [Variant] instances, and returns a new `Style`.
  ///
  /// Unlike `applyVariants`, `pickVariants` ignores all other attributes initially present in the `Style`.
  ///
  /// If the list of [pickVariants] is empty, returns a new empty `Style`.
  ///
  /// Example:
  /// ```dart
  /// final outlinedVariant = Variant('outlined');
  /// final smallVariant = Variant('small');
  /// final style = Style(attr1, attr2, outlinedVariant(buttonAttr1, buttonAttr2), smallVariant(buttonAttr3));
  /// final pickedMix = style.pickVariants([outlinedVariant, smallVariant]);
  /// ```
  ///
  /// In this example:
  /// - Two `Variant` instances `outlinedVariant` and `smallVariant` are created.
  /// - An initial `Style` instance `style` is created with `attr1` and `attr2`, along with the two variants.
  /// - The `pickVariants` method is called on the `Style` instance with a list of `outlinedVariant` and `smallVariant` as the argument.
  /// - The `pickVariants` method returns a new `Style` instance `pickedMix` with only the attributes of the selected variants, ignoring `attr1` and `attr2`.
  /// - The resulting `pickedMix` is equivalent to `Style(buttonAttr1, buttonAttr2, buttonAttr3)`.
  ///
  /// Note:
  /// The attributes `attr1` and `attr2` from the initial `Style` are ignored, and only the attributes within the specified variants are picked and applied to the new `Style`.
  @visibleForTesting
  Style pickVariants(
    List<IVariant> pickedVariants, {
    bool isRecursive = false,
  }) {
    final matchedVariants = <VariantAttribute>[];

    // Return an empty Style if the list of picked variants is empty

    for (final variantAttr in variants.values) {
      if (pickedVariants.contains(variantAttr.variant)) {
        matchedVariants.add(variantAttr);
      }
    }
    if (pickedVariants.isEmpty || matchedVariants.isEmpty) {
      return isRecursive ? this : const Style.empty();
    }

    final pickedStyle = Style.combine(matchedVariants.map((e) => e.value));

    return pickedStyle.pickVariants(pickedVariants, isRecursive: true);
  }

  @override
  get props => [styles, variants];
}

class AnimatedStyle extends Style {
  final AnimatedData animated;

  const AnimatedStyle._({
    required super.styles,
    required super.variants,
    required this.animated,
  }) : super._();

  factory AnimatedStyle(
    Style style, {
    required Duration duration,
    required Curve curve,
    VoidCallback? onEnd,
  }) {
    return AnimatedStyle._(
      styles: style.styles,
      variants: style.variants,
      animated: AnimatedData(duration: duration, curve: curve, onEnd: onEnd),
    );
  }

  /// Returns a new `Style` with the provided [styles] and [variants] merged with this mix's values.
  ///
  /// If [styles] or [variants] is null, the corresponding attribute map of this mix is used.
  @override
  AnimatedStyle copyWith({
    AttributeMap<SpecAttribute>? styles,
    AttributeMap<VariantAttribute>? variants,
    AnimatedData? animated,
  }) {
    return AnimatedStyle._(
      styles: styles ?? this.styles,
      variants: variants ?? this.variants,
      animated: animated ?? this.animated,
    );
  }

  @override
  Style applyVariants(List<Variant> selectedVariants) {
    final newStyle = super.applyVariants(selectedVariants);

    return AnimatedStyle._(
      styles: newStyle.styles,
      variants: newStyle.variants,
      animated: animated,
    );
  }
}
