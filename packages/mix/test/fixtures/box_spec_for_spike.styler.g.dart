// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'box_spec_for_spike.dart';

class BoxSpecForSpikeStyler
    extends MixStyler<BoxSpecForSpikeStyler, BoxSpecForSpike>
    with
        SpacingStyleMixin<BoxSpecForSpikeStyler>,
        ConstraintStyleMixin<BoxSpecForSpikeStyler>,
        DecorationStyleMixin<BoxSpecForSpikeStyler>,
        BorderStyleMixin<BoxSpecForSpikeStyler>,
        BorderRadiusStyleMixin<BoxSpecForSpikeStyler>,
        ShadowStyleMixin<BoxSpecForSpikeStyler>,
        _$BoxSpecForSpikeStylerMixin {
  @override
  final Prop<AlignmentGeometry>? $alignment;
  @override
  final Prop<EdgeInsetsGeometry>? $padding;
  @override
  final Prop<EdgeInsetsGeometry>? $margin;
  @override
  final Prop<BoxConstraints>? $constraints;
  @override
  final Prop<Decoration>? $decoration;
  @override
  final Prop<Decoration>? $foregroundDecoration;
  @override
  final Prop<Matrix4>? $transform;
  @override
  final Prop<AlignmentGeometry>? $transformAlignment;
  @override
  final Prop<Clip>? $clipBehavior;

  const BoxSpecForSpikeStyler.create({
    Prop<AlignmentGeometry>? alignment,
    Prop<EdgeInsetsGeometry>? padding,
    Prop<EdgeInsetsGeometry>? margin,
    Prop<BoxConstraints>? constraints,
    Prop<Decoration>? decoration,
    Prop<Decoration>? foregroundDecoration,
    Prop<Matrix4>? transform,
    Prop<AlignmentGeometry>? transformAlignment,
    Prop<Clip>? clipBehavior,
    super.variants,
    super.modifier,
    super.animation,
  }) : $alignment = alignment,
       $padding = padding,
       $margin = margin,
       $constraints = constraints,
       $decoration = decoration,
       $foregroundDecoration = foregroundDecoration,
       $transform = transform,
       $transformAlignment = transformAlignment,
       $clipBehavior = clipBehavior;

  BoxSpecForSpikeStyler({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    BoxConstraintsMix? constraints,
    DecorationMix? decoration,
    DecorationMix? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<BoxSpecForSpike>>? variants,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         padding: Prop.maybeMix(padding),
         margin: Prop.maybeMix(margin),
         constraints: Prop.maybeMix(constraints),
         decoration: Prop.maybeMix(decoration),
         foregroundDecoration: Prop.maybeMix(foregroundDecoration),
         transform: Prop.maybe(transform),
         transformAlignment: Prop.maybe(transformAlignment),
         clipBehavior: Prop.maybe(clipBehavior),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory BoxSpecForSpikeStyler.marginAll(double value) =>
      BoxSpecForSpikeStyler().marginAll(value);
  factory BoxSpecForSpikeStyler.marginBottom(double value) =>
      BoxSpecForSpikeStyler().marginBottom(value);
  factory BoxSpecForSpikeStyler.marginEnd(double value) =>
      BoxSpecForSpikeStyler().marginEnd(value);
  factory BoxSpecForSpikeStyler.marginLeft(double value) =>
      BoxSpecForSpikeStyler().marginLeft(value);
  factory BoxSpecForSpikeStyler.marginOnly({
    double? horizontal,
    double? vertical,
    double? start,
    double? end,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) => BoxSpecForSpikeStyler().marginOnly(
    horizontal: horizontal,
    vertical: vertical,
    start: start,
    end: end,
    left: left,
    right: right,
    top: top,
    bottom: bottom,
  );
  factory BoxSpecForSpikeStyler.marginRight(double value) =>
      BoxSpecForSpikeStyler().marginRight(value);
  factory BoxSpecForSpikeStyler.marginStart(double value) =>
      BoxSpecForSpikeStyler().marginStart(value);
  factory BoxSpecForSpikeStyler.marginTop(double value) =>
      BoxSpecForSpikeStyler().marginTop(value);
  factory BoxSpecForSpikeStyler.marginX(double value) =>
      BoxSpecForSpikeStyler().marginX(value);
  factory BoxSpecForSpikeStyler.marginY(double value) =>
      BoxSpecForSpikeStyler().marginY(value);
  factory BoxSpecForSpikeStyler.paddingAll(double value) =>
      BoxSpecForSpikeStyler().paddingAll(value);
  factory BoxSpecForSpikeStyler.paddingBottom(double value) =>
      BoxSpecForSpikeStyler().paddingBottom(value);
  factory BoxSpecForSpikeStyler.paddingEnd(double value) =>
      BoxSpecForSpikeStyler().paddingEnd(value);
  factory BoxSpecForSpikeStyler.paddingLeft(double value) =>
      BoxSpecForSpikeStyler().paddingLeft(value);
  factory BoxSpecForSpikeStyler.paddingOnly({
    double? horizontal,
    double? vertical,
    double? start,
    double? end,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) => BoxSpecForSpikeStyler().paddingOnly(
    horizontal: horizontal,
    vertical: vertical,
    start: start,
    end: end,
    left: left,
    right: right,
    top: top,
    bottom: bottom,
  );
  factory BoxSpecForSpikeStyler.paddingRight(double value) =>
      BoxSpecForSpikeStyler().paddingRight(value);
  factory BoxSpecForSpikeStyler.paddingStart(double value) =>
      BoxSpecForSpikeStyler().paddingStart(value);
  factory BoxSpecForSpikeStyler.paddingTop(double value) =>
      BoxSpecForSpikeStyler().paddingTop(value);
  factory BoxSpecForSpikeStyler.paddingX(double value) =>
      BoxSpecForSpikeStyler().paddingX(value);
  factory BoxSpecForSpikeStyler.paddingY(double value) =>
      BoxSpecForSpikeStyler().paddingY(value);
  factory BoxSpecForSpikeStyler.constraintsOnly({
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) => BoxSpecForSpikeStyler().constraintsOnly(
    width: width,
    height: height,
    minWidth: minWidth,
    maxWidth: maxWidth,
    minHeight: minHeight,
    maxHeight: maxHeight,
  );
  factory BoxSpecForSpikeStyler.height(double value) =>
      BoxSpecForSpikeStyler().height(value);
  factory BoxSpecForSpikeStyler.maxHeight(double value) =>
      BoxSpecForSpikeStyler().maxHeight(value);
  factory BoxSpecForSpikeStyler.maxWidth(double value) =>
      BoxSpecForSpikeStyler().maxWidth(value);
  factory BoxSpecForSpikeStyler.minHeight(double value) =>
      BoxSpecForSpikeStyler().minHeight(value);
  factory BoxSpecForSpikeStyler.minWidth(double value) =>
      BoxSpecForSpikeStyler().minWidth(value);
  factory BoxSpecForSpikeStyler.size(double width, double height) =>
      BoxSpecForSpikeStyler().size(width, height);
  factory BoxSpecForSpikeStyler.width(double value) =>
      BoxSpecForSpikeStyler().width(value);
  factory BoxSpecForSpikeStyler.backgroundImage(
    ImageProvider<Object> image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => BoxSpecForSpikeStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory BoxSpecForSpikeStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => BoxSpecForSpikeStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory BoxSpecForSpikeStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => BoxSpecForSpikeStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory BoxSpecForSpikeStyler.border(BoxBorderMix<BoxBorder> value) =>
      BoxSpecForSpikeStyler().border(value);
  factory BoxSpecForSpikeStyler.borderRadius(
    BorderRadiusGeometryMix<BorderRadiusGeometry> value,
  ) => BoxSpecForSpikeStyler().borderRadius(value);
  factory BoxSpecForSpikeStyler.color(Color value) =>
      BoxSpecForSpikeStyler().color(value);
  factory BoxSpecForSpikeStyler.elevation(ElevationShadow value) =>
      BoxSpecForSpikeStyler().elevation(value);
  factory BoxSpecForSpikeStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => BoxSpecForSpikeStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory BoxSpecForSpikeStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => BoxSpecForSpikeStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory BoxSpecForSpikeStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => BoxSpecForSpikeStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory BoxSpecForSpikeStyler.gradient(GradientMix<Gradient> value) =>
      BoxSpecForSpikeStyler().gradient(value);
  factory BoxSpecForSpikeStyler.image(DecorationImageMix value) =>
      BoxSpecForSpikeStyler().image(value);
  factory BoxSpecForSpikeStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => BoxSpecForSpikeStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory BoxSpecForSpikeStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => BoxSpecForSpikeStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory BoxSpecForSpikeStyler.shadow(BoxShadowMix value) =>
      BoxSpecForSpikeStyler().shadow(value);
  factory BoxSpecForSpikeStyler.shadows(List<BoxShadowMix> value) =>
      BoxSpecForSpikeStyler().shadows(value);
  factory BoxSpecForSpikeStyler.shape(ShapeBorderMix<ShapeBorder> value) =>
      BoxSpecForSpikeStyler().shape(value);
  factory BoxSpecForSpikeStyler.shapeBeveledRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) => BoxSpecForSpikeStyler().shapeBeveledRectangle(
    side: side,
    borderRadius: borderRadius,
  );
  factory BoxSpecForSpikeStyler.shapeCircle({BorderSideMix? side}) =>
      BoxSpecForSpikeStyler().shapeCircle(side: side);
  factory BoxSpecForSpikeStyler.shapeContinuousRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) => BoxSpecForSpikeStyler().shapeContinuousRectangle(
    side: side,
    borderRadius: borderRadius,
  );
  factory BoxSpecForSpikeStyler.shapeLinear({
    BorderSideMix? side,
    LinearBorderEdgeMix? start,
    LinearBorderEdgeMix? end,
    LinearBorderEdgeMix? top,
    LinearBorderEdgeMix? bottom,
  }) => BoxSpecForSpikeStyler().shapeLinear(
    side: side,
    start: start,
    end: end,
    top: top,
    bottom: bottom,
  );
  factory BoxSpecForSpikeStyler.shapeRoundedRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) => BoxSpecForSpikeStyler().shapeRoundedRectangle(
    side: side,
    borderRadius: borderRadius,
  );
  factory BoxSpecForSpikeStyler.shapeStadium({BorderSideMix? side}) =>
      BoxSpecForSpikeStyler().shapeStadium(side: side);
  factory BoxSpecForSpikeStyler.shapeStar({
    BorderSideMix? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) => BoxSpecForSpikeStyler().shapeStar(
    side: side,
    points: points,
    innerRadiusRatio: innerRadiusRatio,
    pointRounding: pointRounding,
    valleyRounding: valleyRounding,
    rotation: rotation,
    squash: squash,
  );
  factory BoxSpecForSpikeStyler.shapeSuperellipse({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) => BoxSpecForSpikeStyler().shapeSuperellipse(
    side: side,
    borderRadius: borderRadius,
  );
  factory BoxSpecForSpikeStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => BoxSpecForSpikeStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory BoxSpecForSpikeStyler.borderAll({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) => BoxSpecForSpikeStyler().borderAll(
    color: color,
    width: width,
    style: style,
    strokeAlign: strokeAlign,
  );
  factory BoxSpecForSpikeStyler.borderBottom({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) => BoxSpecForSpikeStyler().borderBottom(
    color: color,
    width: width,
    style: style,
    strokeAlign: strokeAlign,
  );
  factory BoxSpecForSpikeStyler.borderEnd({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) => BoxSpecForSpikeStyler().borderEnd(
    color: color,
    width: width,
    style: style,
    strokeAlign: strokeAlign,
  );
  factory BoxSpecForSpikeStyler.borderHorizontal({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) => BoxSpecForSpikeStyler().borderHorizontal(
    color: color,
    width: width,
    style: style,
    strokeAlign: strokeAlign,
  );
  factory BoxSpecForSpikeStyler.borderLeft({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) => BoxSpecForSpikeStyler().borderLeft(
    color: color,
    width: width,
    style: style,
    strokeAlign: strokeAlign,
  );
  factory BoxSpecForSpikeStyler.borderRight({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) => BoxSpecForSpikeStyler().borderRight(
    color: color,
    width: width,
    style: style,
    strokeAlign: strokeAlign,
  );
  factory BoxSpecForSpikeStyler.borderStart({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) => BoxSpecForSpikeStyler().borderStart(
    color: color,
    width: width,
    style: style,
    strokeAlign: strokeAlign,
  );
  factory BoxSpecForSpikeStyler.borderTop({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) => BoxSpecForSpikeStyler().borderTop(
    color: color,
    width: width,
    style: style,
    strokeAlign: strokeAlign,
  );
  factory BoxSpecForSpikeStyler.borderVertical({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) => BoxSpecForSpikeStyler().borderVertical(
    color: color,
    width: width,
    style: style,
    strokeAlign: strokeAlign,
  );
  factory BoxSpecForSpikeStyler.borderRadiusAll(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusAll(radius);
  factory BoxSpecForSpikeStyler.borderRadiusBottom(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusBottom(radius);
  factory BoxSpecForSpikeStyler.borderRadiusBottomEnd(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusBottomEnd(radius);
  factory BoxSpecForSpikeStyler.borderRadiusBottomLeft(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusBottomLeft(radius);
  factory BoxSpecForSpikeStyler.borderRadiusBottomRight(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusBottomRight(radius);
  factory BoxSpecForSpikeStyler.borderRadiusBottomStart(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusBottomStart(radius);
  factory BoxSpecForSpikeStyler.borderRadiusLeft(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusLeft(radius);
  factory BoxSpecForSpikeStyler.borderRadiusRight(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusRight(radius);
  factory BoxSpecForSpikeStyler.borderRadiusTop(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusTop(radius);
  factory BoxSpecForSpikeStyler.borderRadiusTopEnd(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusTopEnd(radius);
  factory BoxSpecForSpikeStyler.borderRadiusTopLeft(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusTopLeft(radius);
  factory BoxSpecForSpikeStyler.borderRadiusTopRight(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusTopRight(radius);
  factory BoxSpecForSpikeStyler.borderRadiusTopStart(Radius radius) =>
      BoxSpecForSpikeStyler().borderRadiusTopStart(radius);
  factory BoxSpecForSpikeStyler.borderRounded(double radius) =>
      BoxSpecForSpikeStyler().borderRounded(radius);
  factory BoxSpecForSpikeStyler.borderRoundedBottom(double radius) =>
      BoxSpecForSpikeStyler().borderRoundedBottom(radius);
  factory BoxSpecForSpikeStyler.borderRoundedBottomEnd(double radius) =>
      BoxSpecForSpikeStyler().borderRoundedBottomEnd(radius);
  factory BoxSpecForSpikeStyler.borderRoundedBottomLeft(double radius) =>
      BoxSpecForSpikeStyler().borderRoundedBottomLeft(radius);
  factory BoxSpecForSpikeStyler.borderRoundedBottomRight(double radius) =>
      BoxSpecForSpikeStyler().borderRoundedBottomRight(radius);
  factory BoxSpecForSpikeStyler.borderRoundedBottomStart(double radius) =>
      BoxSpecForSpikeStyler().borderRoundedBottomStart(radius);
  factory BoxSpecForSpikeStyler.borderRoundedLeft(double radius) =>
      BoxSpecForSpikeStyler().borderRoundedLeft(radius);
  factory BoxSpecForSpikeStyler.borderRoundedRight(double radius) =>
      BoxSpecForSpikeStyler().borderRoundedRight(radius);
  factory BoxSpecForSpikeStyler.borderRoundedTop(double radius) =>
      BoxSpecForSpikeStyler().borderRoundedTop(radius);
  factory BoxSpecForSpikeStyler.borderRoundedTopEnd(double radius) =>
      BoxSpecForSpikeStyler().borderRoundedTopEnd(radius);
  factory BoxSpecForSpikeStyler.borderRoundedTopLeft(double radius) =>
      BoxSpecForSpikeStyler().borderRoundedTopLeft(radius);
  factory BoxSpecForSpikeStyler.borderRoundedTopRight(double radius) =>
      BoxSpecForSpikeStyler().borderRoundedTopRight(radius);
  factory BoxSpecForSpikeStyler.borderRoundedTopStart(double radius) =>
      BoxSpecForSpikeStyler().borderRoundedTopStart(radius);
  factory BoxSpecForSpikeStyler.boxElevation(ElevationShadow value) =>
      BoxSpecForSpikeStyler().boxElevation(value);
  factory BoxSpecForSpikeStyler.boxShadows(List<BoxShadowMix> value) =>
      BoxSpecForSpikeStyler().boxShadows(value);
  factory BoxSpecForSpikeStyler.shadowOnly({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) => BoxSpecForSpikeStyler().shadowOnly(
    color: color,
    offset: offset,
    blurRadius: blurRadius,
    spreadRadius: spreadRadius,
  );
  factory BoxSpecForSpikeStyler.alignment(AlignmentGeometry value) =>
      BoxSpecForSpikeStyler().alignment(value);
  factory BoxSpecForSpikeStyler.transform(Matrix4 value) =>
      BoxSpecForSpikeStyler().transform(value);
  factory BoxSpecForSpikeStyler.transformAlignment(AlignmentGeometry value) =>
      BoxSpecForSpikeStyler().transformAlignment(value);
  factory BoxSpecForSpikeStyler.clipBehavior(Clip value) =>
      BoxSpecForSpikeStyler().clipBehavior(value);
}

mixin _$BoxSpecForSpikeStylerMixin on Style<BoxSpecForSpike>, Diagnosticable {
  Prop<AlignmentGeometry>? get $alignment;
  Prop<EdgeInsetsGeometry>? get $padding;
  Prop<EdgeInsetsGeometry>? get $margin;
  Prop<BoxConstraints>? get $constraints;
  Prop<Decoration>? get $decoration;
  Prop<Decoration>? get $foregroundDecoration;
  Prop<Matrix4>? get $transform;
  Prop<AlignmentGeometry>? get $transformAlignment;
  Prop<Clip>? get $clipBehavior;

  /// Sets the alignment.
  BoxSpecForSpikeStyler alignment(AlignmentGeometry value) {
    return merge(BoxSpecForSpikeStyler(alignment: value));
  }

  /// Sets the padding.
  BoxSpecForSpikeStyler padding(EdgeInsetsGeometryMix value) {
    return merge(BoxSpecForSpikeStyler(padding: value));
  }

  /// Sets the margin.
  BoxSpecForSpikeStyler margin(EdgeInsetsGeometryMix value) {
    return merge(BoxSpecForSpikeStyler(margin: value));
  }

  /// Sets the constraints.
  BoxSpecForSpikeStyler constraints(BoxConstraintsMix value) {
    return merge(BoxSpecForSpikeStyler(constraints: value));
  }

  /// Sets the decoration.
  BoxSpecForSpikeStyler decoration(DecorationMix value) {
    return merge(BoxSpecForSpikeStyler(decoration: value));
  }

  /// Sets the foregroundDecoration.
  BoxSpecForSpikeStyler foregroundDecoration(DecorationMix value) {
    return merge(BoxSpecForSpikeStyler(foregroundDecoration: value));
  }

  /// Sets the transform.
  BoxSpecForSpikeStyler transform(Matrix4 value) {
    return merge(BoxSpecForSpikeStyler(transform: value));
  }

  /// Sets the transformAlignment.
  BoxSpecForSpikeStyler transformAlignment(AlignmentGeometry value) {
    return merge(BoxSpecForSpikeStyler(transformAlignment: value));
  }

  /// Sets the clipBehavior.
  BoxSpecForSpikeStyler clipBehavior(Clip value) {
    return merge(BoxSpecForSpikeStyler(clipBehavior: value));
  }

  /// Sets the animation configuration.
  BoxSpecForSpikeStyler animate(AnimationConfig value) {
    return merge(BoxSpecForSpikeStyler(animation: value));
  }

  /// Sets the style variants.
  BoxSpecForSpikeStyler variants(List<VariantStyle<BoxSpecForSpike>> value) {
    return merge(BoxSpecForSpikeStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  BoxSpecForSpikeStyler wrap(WidgetModifierConfig value) {
    return merge(BoxSpecForSpikeStyler(modifier: value));
  }

  /// Merges with another [BoxSpecForSpikeStyler].
  @override
  BoxSpecForSpikeStyler merge(BoxSpecForSpikeStyler? other) {
    return BoxSpecForSpikeStyler.create(
      alignment: MixOps.merge($alignment, other?.$alignment),
      padding: MixOps.merge($padding, other?.$padding),
      margin: MixOps.merge($margin, other?.$margin),
      constraints: MixOps.merge($constraints, other?.$constraints),
      decoration: MixOps.merge($decoration, other?.$decoration),
      foregroundDecoration: MixOps.merge(
        $foregroundDecoration,
        other?.$foregroundDecoration,
      ),
      transform: MixOps.merge($transform, other?.$transform),
      transformAlignment: MixOps.merge(
        $transformAlignment,
        other?.$transformAlignment,
      ),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<BoxSpecForSpike>] using [context].
  @override
  StyleSpec<BoxSpecForSpike> resolve(BuildContext context) {
    final spec = BoxSpecForSpike(
      alignment: MixOps.resolve(context, $alignment),
      padding: MixOps.resolve(context, $padding),
      margin: MixOps.resolve(context, $margin),
      constraints: MixOps.resolve(context, $constraints),
      decoration: MixOps.resolve(context, $decoration),
      foregroundDecoration: MixOps.resolve(context, $foregroundDecoration),
      transform: MixOps.resolve(context, $transform),
      transformAlignment: MixOps.resolve(context, $transformAlignment),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
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
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('padding', $padding))
      ..add(DiagnosticsProperty('margin', $margin))
      ..add(DiagnosticsProperty('constraints', $constraints))
      ..add(DiagnosticsProperty('decoration', $decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', $foregroundDecoration))
      ..add(DiagnosticsProperty('transform', $transform))
      ..add(DiagnosticsProperty('transformAlignment', $transformAlignment))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));
  }

  @override
  List<Object?> get props => [
    $alignment,
    $padding,
    $margin,
    $constraints,
    $decoration,
    $foregroundDecoration,
    $transform,
    $transformAlignment,
    $clipBehavior,
    $animation,
    $modifier,
    $variants,
  ];
}
