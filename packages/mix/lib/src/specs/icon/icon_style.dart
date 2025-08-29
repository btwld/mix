import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../animation/animation_mixin.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/widget_spec.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'icon_spec.dart';
import 'icon_util.dart';
import 'icon_widget.dart';

typedef IconMix = IconStyle;

class IconStyle extends Style<IconSpec>
    with
        Diagnosticable,
        StyleModifierMixin<IconStyle, IconSpec>,
        StyleVariantMixin<IconStyle, IconSpec>,
        StyleAnimationMixin<IconSpec, IconStyle> {
  final Prop<Color>? $color;
  final Prop<double>? $size;
  final Prop<double>? $weight;
  final Prop<double>? $grade;
  final Prop<double>? $opticalSize;
  final List<Prop<Shadow>>? $shadows;
  final Prop<TextDirection>? $textDirection;
  final Prop<bool>? $applyTextScaling;
  final Prop<double>? $fill;
  final Prop<String>? $semanticsLabel;
  final Prop<double>? $opacity;
  final Prop<BlendMode>? $blendMode;
  final Prop<IconData>? $icon;

  const IconStyle.create({
    Prop<Color>? color,
    Prop<double>? size,
    Prop<double>? weight,
    Prop<double>? grade,
    Prop<double>? opticalSize,
    List<Prop<Shadow>>? shadows,
    Prop<TextDirection>? textDirection,
    Prop<bool>? applyTextScaling,
    Prop<double>? fill,
    Prop<String>? semanticsLabel,
    Prop<double>? opacity,
    Prop<BlendMode>? blendMode,
    Prop<IconData>? icon,
    super.animation,
    super.modifier,
    super.variants,

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
       $opacity = opacity,
       $blendMode = blendMode,
       $icon = icon;

  IconStyle({
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
    double? opacity,
    BlendMode? blendMode,
    IconData? icon,
    AnimationConfig? animation,
    ModifierConfig? modifier,
    List<VariantStyle<IconSpec>>? variants,
  }) : this.create(
         color: Prop.maybe(color),
         size: Prop.maybe(size),
         weight: Prop.maybe(weight),
         grade: Prop.maybe(grade),
         opticalSize: Prop.maybe(opticalSize),
         shadows: shadows?.map(Prop.mix).toList(),
         textDirection: Prop.maybe(textDirection),
         applyTextScaling: Prop.maybe(applyTextScaling),
         fill: Prop.maybe(fill),
         semanticsLabel: Prop.maybe(semanticsLabel),
         opacity: Prop.maybe(opacity),
         blendMode: Prop.maybe(blendMode),
         icon: Prop.maybe(icon),
         animation: animation,
         modifier: modifier,
         variants: variants,
       );

  factory IconStyle.builder(IconStyle Function(BuildContext) fn) {
    return IconStyle().builder(fn);
  }

  static IconSpecUtility get chain => IconSpecUtility(IconStyle());

  /// Sets icon color
  IconStyle color(Color value) {
    return merge(IconStyle(color: value));
  }

  /// Sets icon size
  IconStyle size(double value) {
    return merge(IconStyle(size: value));
  }

  /// Sets icon weight
  IconStyle weight(double value) {
    return merge(IconStyle(weight: value));
  }

  /// Sets icon grade
  IconStyle grade(double value) {
    return merge(IconStyle(grade: value));
  }

  /// Sets icon optical size
  IconStyle opticalSize(double value) {
    return merge(IconStyle(opticalSize: value));
  }

  /// Sets single icon shadow
  IconStyle shadow(ShadowMix value) {
    return merge(IconStyle(shadows: [value]));
  }

  /// Sets icon shadows
  IconStyle shadows(List<ShadowMix> value) {
    return merge(IconStyle(shadows: value));
  }

  /// Sets text direction
  IconStyle textDirection(TextDirection value) {
    return merge(IconStyle(textDirection: value));
  }

  /// Sets apply text scaling
  IconStyle applyTextScaling(bool value) {
    return merge(IconStyle(applyTextScaling: value));
  }

  /// Sets icon fill
  IconStyle fill(double value) {
    return merge(IconStyle(fill: value));
  }

  /// Sets semantics label
  IconStyle semanticsLabel(String value) {
    return merge(IconStyle(semanticsLabel: value));
  }

  /// Sets opacity
  IconStyle opacity(double value) {
    return merge(IconStyle(opacity: value));
  }

  /// Sets blend mode
  IconStyle blendMode(BlendMode value) {
    return merge(IconStyle(blendMode: value));
  }

  /// Sets icon data
  IconStyle icon(IconData value) {
    return merge(IconStyle(icon: value));
  }

  StyledIcon call({IconData? icon, String? semanticLabel}) {
    return StyledIcon(icon: icon, semanticLabel: semanticLabel, style: this);
  }

  IconStyle modifier(ModifierConfig value) {
    return merge(IconStyle(modifier: value));
  }

  /// Sets animation
  @override
  IconStyle animate(AnimationConfig animation) {
    return merge(IconStyle(animation: animation));
  }

  @override
  WidgetSpec<IconSpec> resolve(BuildContext context) {
    final iconSpec = IconSpec(
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
      opacity: MixOps.resolve(context, $opacity),
      blendMode: MixOps.resolve(context, $blendMode),
      icon: MixOps.resolve(context, $icon),
    );

    return WidgetSpec(
      spec: iconSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  IconStyle merge(IconStyle? other) {
    if (other == null) return this;

    return IconStyle.create(
      color: MixOps.merge($color, other.$color),
      size: MixOps.merge($size, other.$size),
      weight: MixOps.merge($weight, other.$weight),
      grade: MixOps.merge($grade, other.$grade),
      opticalSize: MixOps.merge($opticalSize, other.$opticalSize),
      shadows: MixOps.mergeList($shadows, other.$shadows),
      textDirection: MixOps.merge($textDirection, other.$textDirection),
      applyTextScaling: MixOps.merge(
        $applyTextScaling,
        other.$applyTextScaling,
      ),
      fill: MixOps.merge($fill, other.$fill),
      semanticsLabel: MixOps.merge($semanticsLabel, other.$semanticsLabel),
      opacity: MixOps.merge($opacity, other.$opacity),
      blendMode: MixOps.merge($blendMode, other.$blendMode),
      icon: MixOps.merge($icon, other.$icon),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      variants: mergeVariantLists($variants, other.$variants),

    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('size', $size))
      ..add(DiagnosticsProperty('weight', $weight))
      ..add(DiagnosticsProperty('grade', $grade))
      ..add(DiagnosticsProperty('opticalSize', $opticalSize))
      ..add(DiagnosticsProperty('shadows', $shadows))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('applyTextScaling', $applyTextScaling))
      ..add(DiagnosticsProperty('fill', $fill))
      ..add(DiagnosticsProperty('semanticsLabel', $semanticsLabel))
      ..add(DiagnosticsProperty('opacity', $opacity))
      ..add(DiagnosticsProperty('blendMode', $blendMode))
      ..add(DiagnosticsProperty('icon', $icon));
  }

  @override
  IconStyle variant(Variant variant, IconStyle style) {
    return merge(IconStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  IconStyle variants(List<VariantStyle<IconSpec>> value) {
    return merge(IconStyle(variants: value));
  }

  @override
  IconStyle wrap(ModifierConfig value) {
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
    $opacity,
    $blendMode,
    $icon,
    $animation,
    $modifier,
    $variants,
  ];
}
