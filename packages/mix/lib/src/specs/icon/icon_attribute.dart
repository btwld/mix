import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../modifiers/widget_modifier_util.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'icon_spec.dart';
import 'icon_widget.dart';

class IconMix extends Style<IconSpec>
    with
        Diagnosticable,
        StyleWidgetModifierMixin<IconMix, IconSpec>,
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
  final Prop<String>? $semanticsLabel;
  final Prop<BlendMode>? $blendMode;
  final Prop<IconData>? $icon;

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

  /// Factory for semantics label
  factory IconMix.semanticsLabel(String value) {
    return IconMix(semanticsLabel: value);
  }

  /// Factory for blend mode
  factory IconMix.blendMode(BlendMode value) {
    return IconMix(blendMode: value);
  }

  /// Factory for icon data
  factory IconMix.icon(IconData value) {
    return IconMix(icon: value);
  }

  /// Factory for animation
  factory IconMix.animate(AnimationConfig animation) {
    return IconMix(animation: animation);
  }

  /// Factory for variant
  factory IconMix.variant(Variant variant, IconMix value) {
    return IconMix(variants: [VariantStyle(variant, value)]);
  }

  /// Factory for widget modifier
  factory IconMix.modifier(WidgetModifierConfig modifier) {
    return IconMix(modifier: modifier);
  }

  /// Factory for widget modifier
  factory IconMix.wrap(WidgetModifierConfig value) {
    return IconMix(modifier: value);
  }

  const IconMix.create({
    Prop<Color>? color,
    Prop<double>? size,
    Prop<double>? weight,
    Prop<double>? grade,
    Prop<double>? opticalSize,
    List<MixProp<Shadow>>? shadows,
    Prop<TextDirection>? textDirection,
    Prop<bool>? applyTextScaling,
    Prop<double>? fill,
    Prop<String>? semanticsLabel,
    Prop<BlendMode>? blendMode,
    Prop<IconData>? icon,
    super.animation,
    super.modifier,
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
       $fill = fill,
       $semanticsLabel = semanticsLabel,
       $blendMode = blendMode,
       $icon = icon;

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
    String? semanticsLabel,
    BlendMode? blendMode,
    IconData? icon,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<IconSpec>>? variants,
    bool? inherit,
  }) : this.create(
         color: Prop.maybe(color),
         size: Prop.maybe(size),
         weight: Prop.maybe(weight),
         grade: Prop.maybe(grade),
         opticalSize: Prop.maybe(opticalSize),
         shadows: shadows?.map(MixProp.new).toList(),
         textDirection: Prop.maybe(textDirection),
         applyTextScaling: Prop.maybe(applyTextScaling),
         fill: Prop.maybe(fill),
         semanticsLabel: Prop.maybe(semanticsLabel),
         blendMode: Prop.maybe(blendMode),
         icon: Prop.maybe(icon),
         animation: animation,
         modifier: modifier,
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
      semanticsLabel: spec.semanticsLabel,
      blendMode: spec.blendMode,
      icon: spec.icon,
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

  /// Sets semantics label
  IconMix semanticsLabel(String value) {
    return merge(IconMix.semanticsLabel(value));
  }

  /// Sets blend mode
  IconMix blendMode(BlendMode value) {
    return merge(IconMix.blendMode(value));
  }

  /// Sets icon data
  IconMix icon(IconData value) {
    return merge(IconMix.icon(value));
  }

  /// Sets animation
  IconMix animate(AnimationConfig animation) {
    return merge(IconMix.animate(animation));
  }

  StyledIcon call({IconData? icon, String? semanticLabel}) {
    return StyledIcon(icon: icon, semanticLabel: semanticLabel, style: this);
  }

  IconMix modifier(WidgetModifierConfig value) {
    return merge(IconMix(modifier: value));
  }

  @override
  IconSpec resolve(BuildContext context) {
    return IconSpec(
      color: MixOps.resolve(context, $color),
      size: MixOps.resolve(context, $size),
      weight: MixOps.resolve(context, $weight),
      grade: MixOps.resolve(context, $grade),
      opticalSize: MixOps.resolve(context, $opticalSize),
      shadows: MixOps.resolveList(context, $shadows),
      textDirection: MixOps.resolve(context, $textDirection),
      applyTextScaling: MixOps.resolve(context, $applyTextScaling),
      fill: MixOps.resolve(context, $fill),
      semanticsLabel: MixOps.resolve(context, $semanticsLabel),
      blendMode: MixOps.resolve(context, $blendMode),
      icon: MixOps.resolve(context, $icon),
    );
  }

  @override
  IconMix merge(IconMix? other) {
    if (other == null) return this;

    return IconMix.create(
      color: $color.tryMerge(other.$color),
      size: $size.tryMerge(other.$size),
      weight: $weight.tryMerge(other.$weight),
      grade: $grade.tryMerge(other.$grade),
      opticalSize: $opticalSize.tryMerge(other.$opticalSize),
      shadows: $shadows.tryMerge(other.$shadows),
      textDirection: $textDirection.tryMerge(other.$textDirection),
      applyTextScaling: $applyTextScaling.tryMerge(other.$applyTextScaling),
      fill: $fill.tryMerge(other.$fill),
      semanticsLabel: $semanticsLabel.tryMerge(other.$semanticsLabel),
      blendMode: $blendMode.tryMerge(other.$blendMode),
      icon: $icon.tryMerge(other.$icon),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
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
    properties.add(
      DiagnosticsProperty(
        'semanticsLabel',
        $semanticsLabel,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('blendMode', $blendMode, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('icon', $icon, defaultValue: null));
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
  IconMix wrap(WidgetModifierConfig value) {
    return modifier(value);
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
    $semanticsLabel,
    $blendMode,
    $icon,
    $animation,
    $modifier,
    $variants,
  ];
}
