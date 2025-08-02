import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../modifiers/widget_decorator_config.dart';
import '../../modifiers/widget_decorator_util.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'icon_spec.dart';

class IconMix extends Style<IconSpec>
    with
        Diagnosticable,
        StyleModifierMixin<IconMix, IconSpec>,
        StyleVariantMixin<IconMix, IconSpec> {
  final Prop<Color>? $color;
  final Prop<double>? $size;
  final Prop<double>? $weight;
  final Prop<double>? $grade;
  final Prop<double>? $opticalSize;
  final List<MixProp<Shadow>>? $shadows;
  final Prop<TextDirection>? $textDirection;
  final Prop<bool>? $applyTextScaling;
  final Prop<double>? $fill;

  /// Factory for icon color
  factory IconMix.color(Color value) {
    return IconMix(color: value);
  }

  /// Factory for icon size
  factory IconMix.size(double value) {
    return IconMix(size: value);
  }

  /// Factory for icon weight
  factory IconMix.weight(double value) {
    return IconMix(weight: value);
  }

  /// Factory for icon grade
  factory IconMix.grade(double value) {
    return IconMix(grade: value);
  }

  /// Factory for icon optical size
  factory IconMix.opticalSize(double value) {
    return IconMix(opticalSize: value);
  }

  /// Factory for icon shadow
  factory IconMix.shadow(ShadowMix value) {
    return IconMix(shadows: [value]);
  }

  /// Factory for icon shadows
  factory IconMix.shadows(List<ShadowMix> value) {
    return IconMix(shadows: value);
  }

  /// Factory for text direction
  factory IconMix.textDirection(TextDirection value) {
    return IconMix(textDirection: value);
  }

  /// Factory for apply text scaling
  factory IconMix.applyTextScaling(bool value) {
    return IconMix(applyTextScaling: value);
  }

  /// Factory for icon fill
  factory IconMix.fill(double value) {
    return IconMix(fill: value);
  }

  /// Factory for animation
  factory IconMix.animate(AnimationConfig animation) {
    return IconMix(animation: animation);
  }

  /// Factory for variant
  factory IconMix.variant(Variant variant, IconMix value) {
    return IconMix(variants: [VariantStyle(variant, value)]);
  }

  const IconMix.raw({
    Prop<Color>? color,
    Prop<double>? size,
    Prop<double>? weight,
    Prop<double>? grade,
    Prop<double>? opticalSize,
    List<MixProp<Shadow>>? shadows,
    Prop<TextDirection>? textDirection,
    Prop<bool>? applyTextScaling,
    Prop<double>? fill,
    super.animation,
    super.modifierConfig,
    super.variants,

    super.inherit,
  }) : $color = color,
       $size = size,
       $weight = weight,
       $grade = grade,
       $opticalSize = opticalSize,
       $shadows = shadows,
       $textDirection = textDirection,
       $applyTextScaling = applyTextScaling,
       $fill = fill;

  IconMix({
    Color? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<ShadowMix>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    AnimationConfig? animation,
    WidgetDecoratorConfig? modifierConfig,
    List<VariantStyle<IconSpec>>? variants,
    bool? inherit,
  }) : this.raw(
         color: Prop.maybe(color),
         size: Prop.maybe(size),
         weight: Prop.maybe(weight),
         grade: Prop.maybe(grade),
         opticalSize: Prop.maybe(opticalSize),
         shadows: shadows?.map(MixProp.new).toList(),
         textDirection: Prop.maybe(textDirection),
         applyTextScaling: Prop.maybe(applyTextScaling),
         fill: Prop.maybe(fill),
         animation: animation,
         modifierConfig: modifierConfig,
         variants: variants,
         inherit: inherit,
       );

  // Static factory to create from resolved Spec
  static IconMix value(IconSpec spec) {
    return IconMix(
      color: spec.color,
      size: spec.size,
      weight: spec.weight,
      grade: spec.grade,
      opticalSize: spec.opticalSize,
      shadows: spec.shadows?.map((shadow) => ShadowMix.value(shadow)).toList(),
      textDirection: spec.textDirection,
      applyTextScaling: spec.applyTextScaling,
      fill: spec.fill,
    );
  }

  /// Constructor that accepts a nullable [IconSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [IconMix.value].
  ///
  /// ```dart
  /// const IconSpec? spec = IconSpec(color: Colors.blue, size: 24.0);
  /// final attr = IconMix.maybeValue(spec); // Returns IconMix or null
  /// ```
  static IconMix? maybeValue(IconSpec? spec) {
    return spec != null ? IconMix.value(spec) : null;
  }

  /// Sets icon color
  IconMix color(Color value) {
    return merge(IconMix.color(value));
  }

  /// Sets icon size
  IconMix size(double value) {
    return merge(IconMix.size(value));
  }

  /// Sets icon weight
  IconMix weight(double value) {
    return merge(IconMix.weight(value));
  }

  /// Sets icon grade
  IconMix grade(double value) {
    return merge(IconMix.grade(value));
  }

  /// Sets icon optical size
  IconMix opticalSize(double value) {
    return merge(IconMix.opticalSize(value));
  }

  /// Sets single icon shadow
  IconMix shadow(ShadowMix value) {
    return merge(IconMix.shadow(value));
  }

  /// Sets icon shadows
  IconMix shadows(List<ShadowMix> value) {
    return merge(IconMix.shadows(value));
  }

  /// Sets text direction
  IconMix textDirection(TextDirection value) {
    return merge(IconMix.textDirection(value));
  }

  /// Sets apply text scaling
  IconMix applyTextScaling(bool value) {
    return merge(IconMix.applyTextScaling(value));
  }

  /// Sets icon fill
  IconMix fill(double value) {
    return merge(IconMix.fill(value));
  }

  /// Sets animation
  IconMix animate(AnimationConfig animation) {
    return merge(IconMix.animate(animation));
  }

  @override
  IconMix modifier(WidgetDecoratorConfig value) {
    return merge(IconMix(modifierConfig: value));
  }

  @override
  IconSpec resolve(BuildContext context) {
    return IconSpec(
      color: MixHelpers.resolve(context, $color),
      size: MixHelpers.resolve(context, $size),
      weight: MixHelpers.resolve(context, $weight),
      grade: MixHelpers.resolve(context, $grade),
      opticalSize: MixHelpers.resolve(context, $opticalSize),
      shadows: MixHelpers.resolveList(context, $shadows),
      textDirection: MixHelpers.resolve(context, $textDirection),
      applyTextScaling: MixHelpers.resolve(context, $applyTextScaling),
      fill: MixHelpers.resolve(context, $fill),
    );
  }

  @override
  IconMix merge(IconMix? other) {
    if (other == null) return this;

    return IconMix.raw(
      color: $color.tryMerge(other.$color),
      size: $size.tryMerge(other.$size),
      weight: $weight.tryMerge(other.$weight),
      grade: $grade.tryMerge(other.$grade),
      opticalSize: $opticalSize.tryMerge(other.$opticalSize),
      shadows: $shadows.tryMerge(other.$shadows),
      textDirection: $textDirection.tryMerge(other.$textDirection),
      applyTextScaling: $applyTextScaling.tryMerge(other.$applyTextScaling),
      fill: $fill.tryMerge(other.$fill),
      animation: other.$animation ?? $animation,
      modifierConfig: $modifierConfig.tryMerge(other.$modifierConfig),
      variants: mergeVariantLists($variants, other.$variants),

      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('color', $color, defaultValue: null));
    properties.add(DiagnosticsProperty('size', $size, defaultValue: null));
    properties.add(DiagnosticsProperty('weight', $weight, defaultValue: null));
    properties.add(DiagnosticsProperty('grade', $grade, defaultValue: null));
    properties.add(
      DiagnosticsProperty('opticalSize', $opticalSize, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('shadows', $shadows, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textDirection', $textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'applyTextScaling',
        $applyTextScaling,
        defaultValue: null,
      ),
    );
    properties.add(DiagnosticsProperty('fill', $fill, defaultValue: null));
  }

  @override
  IconMix variant(Variant variant, IconMix style) {
    return merge(IconMix(variants: [VariantStyle(variant, style)]));
  }

  @override
  IconMix variants(List<VariantStyle<IconSpec>> value) {
    return merge(IconMix(variants: value));
  }

  @override
  List<Object?> get props => [
    $color,
    $size,
    $weight,
    $grade,
    $opticalSize,
    $shadows,
    $textDirection,
    $applyTextScaling,
    $fill,
    $animation,
    $modifierConfig,
    $variants,
  ];
}
