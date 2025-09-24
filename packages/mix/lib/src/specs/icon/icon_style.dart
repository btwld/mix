import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../style/mixins/animation_style_mixin.dart';
import '../../style/mixins/variant_style_mixin.dart';
import '../../style/mixins/widget_modifier_style_mixin.dart';
import 'icon_mutable_style.dart';
import 'icon_spec.dart';
import 'icon_widget.dart';

typedef IconMix = IconStyler;

class IconStyler extends Style<IconSpec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<IconStyler, IconSpec>,
        VariantStyleMixin<IconStyler, IconSpec>,
        AnimationStyleMixin<IconStyler, IconSpec> {
  final Prop<Color>? $color;
  final Prop<double>? $size;
  final Prop<double>? $weight;
  final Prop<double>? $grade;
  final Prop<double>? $opticalSize;
  final Prop<List<Shadow>>? $shadows;
  final Prop<TextDirection>? $textDirection;
  final Prop<bool>? $applyTextScaling;
  final Prop<double>? $fill;
  final Prop<String>? $semanticsLabel;
  final Prop<double>? $opacity;
  final Prop<BlendMode>? $blendMode;
  final Prop<IconData>? $icon;

  const IconStyler.create({
    Prop<Color>? color,
    Prop<double>? size,
    Prop<double>? weight,
    Prop<double>? grade,
    Prop<double>? opticalSize,
    Prop<List<Shadow>>? shadows,
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

  IconStyler({
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
    WidgetModifierConfig? modifier,
    List<VariantStyle<IconSpec>>? variants,
  }) : this.create(
         color: Prop.maybe(color),
         size: Prop.maybe(size),
         weight: Prop.maybe(weight),
         grade: Prop.maybe(grade),
         opticalSize: Prop.maybe(opticalSize),
         shadows: shadows != null ? Prop.mix(ShadowListMix(shadows)) : null,
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

  static IconMutableStyler get chain => IconMutableStyler(IconStyler());

  /// Sets icon color
  IconStyler color(Color value) {
    return merge(IconStyler(color: value));
  }

  /// Sets icon size
  IconStyler size(double value) {
    return merge(IconStyler(size: value));
  }

  /// Sets icon weight
  IconStyler weight(double value) {
    return merge(IconStyler(weight: value));
  }

  /// Sets icon grade
  IconStyler grade(double value) {
    return merge(IconStyler(grade: value));
  }

  /// Sets icon optical size
  IconStyler opticalSize(double value) {
    return merge(IconStyler(opticalSize: value));
  }

  /// Sets single icon shadow
  IconStyler shadow(ShadowMix value) {
    return merge(IconStyler(shadows: [value]));
  }

  /// Sets icon shadows
  IconStyler shadows(List<ShadowMix> value) {
    return merge(IconStyler(shadows: value));
  }

  /// Sets text direction
  IconStyler textDirection(TextDirection value) {
    return merge(IconStyler(textDirection: value));
  }

  /// Sets apply text scaling
  IconStyler applyTextScaling(bool value) {
    return merge(IconStyler(applyTextScaling: value));
  }

  /// Sets icon fill
  IconStyler fill(double value) {
    return merge(IconStyler(fill: value));
  }

  /// Sets semantics label
  IconStyler semanticsLabel(String value) {
    return merge(IconStyler(semanticsLabel: value));
  }

  /// Sets opacity
  IconStyler opacity(double value) {
    return merge(IconStyler(opacity: value));
  }

  /// Sets blend mode
  IconStyler blendMode(BlendMode value) {
    return merge(IconStyler(blendMode: value));
  }

  /// Sets icon data
  IconStyler icon(IconData value) {
    return merge(IconStyler(icon: value));
  }

  StyledIcon call({IconData? icon, String? semanticLabel}) {
    return StyledIcon(icon: icon, semanticLabel: semanticLabel, style: this);
  }

  IconStyler modifier(WidgetModifierConfig value) {
    return merge(IconStyler(modifier: value));
  }

  /// Sets animation
  @override
  IconStyler animate(AnimationConfig animation) {
    return merge(IconStyler(animation: animation));
  }

  @override
  StyleSpec<IconSpec> resolve(BuildContext context) {
    final iconSpec = IconSpec(
      color: MixOps.resolve(context, $color),
      size: MixOps.resolve(context, $size),
      weight: MixOps.resolve(context, $weight),
      grade: MixOps.resolve(context, $grade),
      opticalSize: MixOps.resolve(context, $opticalSize),
      shadows: MixOps.resolve(context, $shadows),
      textDirection: MixOps.resolve(context, $textDirection),
      applyTextScaling: MixOps.resolve(context, $applyTextScaling),
      fill: MixOps.resolve(context, $fill),
      semanticsLabel: MixOps.resolve(context, $semanticsLabel),
      opacity: MixOps.resolve(context, $opacity),
      blendMode: MixOps.resolve(context, $blendMode),
      icon: MixOps.resolve(context, $icon),
    );

    return StyleSpec(
      spec: iconSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  IconStyler merge(IconStyler? other) {
    return IconStyler.create(
      color: MixOps.merge($color, other?.$color),
      size: MixOps.merge($size, other?.$size),
      weight: MixOps.merge($weight, other?.$weight),
      grade: MixOps.merge($grade, other?.$grade),
      opticalSize: MixOps.merge($opticalSize, other?.$opticalSize),
      shadows: MixOps.merge($shadows, other?.$shadows),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      applyTextScaling: MixOps.merge(
        $applyTextScaling,
        other?.$applyTextScaling,
      ),
      fill: MixOps.merge($fill, other?.$fill),
      semanticsLabel: MixOps.merge($semanticsLabel, other?.$semanticsLabel),
      opacity: MixOps.merge($opacity, other?.$opacity),
      blendMode: MixOps.merge($blendMode, other?.$blendMode),
      icon: MixOps.merge($icon, other?.$icon),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      variants: MixOps.mergeVariants($variants, other?.$variants),
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
  IconStyler variants(List<VariantStyle<IconSpec>> value) {
    return merge(IconStyler(variants: value));
  }

  @override
  IconStyler wrap(WidgetModifierConfig value) {
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
