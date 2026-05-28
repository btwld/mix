// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

// ignore_for_file: prefer_relative_imports, unnecessary_import, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';
import 'icon_widget.dart';

import 'icon_spec.dart';

class IconStyler extends MixStyler<IconStyler, IconSpec> {
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
    super.variants,
    super.modifier,
    super.animation,
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
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory IconStyler.color(Color value) => IconStyler().color(value);
  factory IconStyler.size(double value) => IconStyler().size(value);
  factory IconStyler.weight(double value) => IconStyler().weight(value);
  factory IconStyler.grade(double value) => IconStyler().grade(value);
  factory IconStyler.opticalSize(double value) =>
      IconStyler().opticalSize(value);
  factory IconStyler.shadows(List<ShadowMix> value) =>
      IconStyler().shadows(value);
  factory IconStyler.textDirection(TextDirection value) =>
      IconStyler().textDirection(value);
  factory IconStyler.applyTextScaling(bool value) =>
      IconStyler().applyTextScaling(value);
  factory IconStyler.fill(double value) => IconStyler().fill(value);
  factory IconStyler.opacity(double value) => IconStyler().opacity(value);
  factory IconStyler.blendMode(BlendMode value) =>
      IconStyler().blendMode(value);
  factory IconStyler.icon(IconData value) => IconStyler().icon(value);
  factory IconStyler.shadow(ShadowMix value) => IconStyler().shadow(value);

  IconStyler shadow(ShadowMix value) {
    return merge(IconStyler(shadows: [value]));
  }

  /// Sets the color.
  IconStyler color(Color value) {
    return merge(IconStyler(color: value));
  }

  /// Sets the size.
  IconStyler size(double value) {
    return merge(IconStyler(size: value));
  }

  /// Sets the weight.
  IconStyler weight(double value) {
    return merge(IconStyler(weight: value));
  }

  /// Sets the grade.
  IconStyler grade(double value) {
    return merge(IconStyler(grade: value));
  }

  /// Sets the opticalSize.
  IconStyler opticalSize(double value) {
    return merge(IconStyler(opticalSize: value));
  }

  /// Sets the shadows.
  IconStyler shadows(List<ShadowMix> value) {
    return merge(IconStyler(shadows: value));
  }

  /// Sets the textDirection.
  IconStyler textDirection(TextDirection value) {
    return merge(IconStyler(textDirection: value));
  }

  /// Sets the applyTextScaling.
  IconStyler applyTextScaling(bool value) {
    return merge(IconStyler(applyTextScaling: value));
  }

  /// Sets the fill.
  IconStyler fill(double value) {
    return merge(IconStyler(fill: value));
  }

  /// Sets the semanticsLabel.
  IconStyler semanticsLabel(String value) {
    return merge(IconStyler(semanticsLabel: value));
  }

  /// Sets the opacity.
  IconStyler opacity(double value) {
    return merge(IconStyler(opacity: value));
  }

  /// Sets the blendMode.
  IconStyler blendMode(BlendMode value) {
    return merge(IconStyler(blendMode: value));
  }

  /// Sets the icon.
  IconStyler icon(IconData value) {
    return merge(IconStyler(icon: value));
  }

  /// Sets the animation configuration.
  @override
  IconStyler animate(AnimationConfig value) {
    return merge(IconStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  IconStyler variants(List<VariantStyle<IconSpec>> value) {
    return merge(IconStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  IconStyler wrap(WidgetModifierConfig value) {
    return merge(IconStyler(modifier: value));
  }

  /// Sets the widget modifier.
  IconStyler modifier(WidgetModifierConfig value) {
    return merge(IconStyler(modifier: value));
  }

  StyledIcon call({Key? key, IconData? icon, String? semanticLabel}) {
    return StyledIcon(
      key: key,
      style: this,
      icon: icon,
      semanticLabel: semanticLabel,
    );
  }

  /// Merges with another [IconStyler].
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
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<IconSpec>] using [context].
  @override
  StyleSpec<IconSpec> resolve(BuildContext context) {
    final spec = IconSpec(
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
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
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
