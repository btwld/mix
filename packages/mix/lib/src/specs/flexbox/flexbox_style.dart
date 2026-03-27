import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/painting/border_mix.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/decoration_image_mix.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/gradient_mix.dart';
import '../../properties/painting/shape_border_mix.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../style/abstracts/styler.dart';
import '../../style/mixins/border_radius_style_mixin.dart';
import '../../style/mixins/border_style_mixin.dart';
import '../../style/mixins/constraint_style_mixin.dart';
import '../../style/mixins/decoration_style_mixin.dart';
import '../../style/mixins/flex_style_mixin.dart';
import '../../style/mixins/shadow_style_mixin.dart';
import '../../style/mixins/spacing_style_mixin.dart';
import '../../style/mixins/transform_style_mixin.dart';
import '../box/box_spec.dart';
import '../box/box_style.dart';
import '../flex/flex_spec.dart';
import '../flex/flex_style.dart';
import 'flexbox_mutable_style.dart';
import 'flexbox_spec.dart';
import 'flexbox_widget.dart';

part 'flexbox_style.g.dart';

/// Represents the attributes of a [FlexBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexBoxSpec].
///
/// Use this class to configure the attributes of a [FlexBoxSpec] and pass it to
/// the [FlexBoxSpec] constructor.
@MixableStyler(methods: GeneratedStylerMethods.skipSetters)
class FlexBoxStyler extends MixStyler<FlexBoxStyler, FlexBoxSpec>
    with
        BorderStyleMixin<FlexBoxStyler>,
        BorderRadiusStyleMixin<FlexBoxStyler>,
        ShadowStyleMixin<FlexBoxStyler>,
        DecorationStyleMixin<FlexBoxStyler>,
        SpacingStyleMixin<FlexBoxStyler>,
        TransformStyleMixin<FlexBoxStyler>,
        ConstraintStyleMixin<FlexBoxStyler>,
        FlexStyleMixin<FlexBoxStyler>,
        _$FlexBoxStylerMixin {
  @override
  final Prop<StyleSpec<BoxSpec>>? $box;
  @override
  final Prop<StyleSpec<FlexSpec>>? $flex;

  /// Main constructor with individual property parameters
  FlexBoxStyler({
    // Box properties
    DecorationMix? decoration,
    DecorationMix? foregroundDecoration,
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    AlignmentGeometry? alignment,
    BoxConstraintsMix? constraints,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    // Flex properties
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? flexClipBehavior,
    double? spacing,
    // Style properties
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<FlexBoxSpec>>? variants,
  }) : this.create(
         box: Prop.maybeMix(
           BoxStyler(
             alignment: alignment,
             padding: padding,
             margin: margin,
             constraints: constraints,
             decoration: decoration,
             foregroundDecoration: foregroundDecoration,
             transform: transform,
             transformAlignment: transformAlignment,
             clipBehavior: clipBehavior,
           ),
         ),
         flex: Prop.maybeMix(
           FlexStyler(
             direction: direction,
             mainAxisAlignment: mainAxisAlignment,
             crossAxisAlignment: crossAxisAlignment,
             mainAxisSize: mainAxisSize,
             verticalDirection: verticalDirection,
             textDirection: textDirection,
             textBaseline: textBaseline,
             clipBehavior: flexClipBehavior,
             spacing: spacing,
           ),
         ),
         animation: animation,
         modifier: modifier,
         variants: variants,
       );

  /// Create constructor with Prop`<T>` types for internal use
  const FlexBoxStyler.create({
    Prop<StyleSpec<BoxSpec>>? box,
    Prop<StyleSpec<FlexSpec>>? flex,
    super.animation,
    super.modifier,
    super.variants,
  }) : $box = box,
       $flex = flex;

  // Factory constructors for dot-shorthand notation.
  // Keep only base primitives and non-compound conveniences.

  // Direct constructor params (Box + Flex)
  factory FlexBoxStyler.alignment(AlignmentGeometry value) =>
      FlexBoxStyler(alignment: value);
  factory FlexBoxStyler.padding(EdgeInsetsGeometryMix value) =>
      FlexBoxStyler(padding: value);
  factory FlexBoxStyler.margin(EdgeInsetsGeometryMix value) =>
      FlexBoxStyler(margin: value);
  factory FlexBoxStyler.constraints(BoxConstraintsMix value) =>
      FlexBoxStyler(constraints: value);
  factory FlexBoxStyler.decoration(DecorationMix value) =>
      FlexBoxStyler(decoration: value);
  factory FlexBoxStyler.foregroundDecoration(DecorationMix value) =>
      FlexBoxStyler(foregroundDecoration: value);
  factory FlexBoxStyler.clipBehavior(Clip value) =>
      FlexBoxStyler(clipBehavior: value);
  factory FlexBoxStyler.direction(Axis value) =>
      FlexBoxStyler(direction: value);
  factory FlexBoxStyler.mainAxisAlignment(MainAxisAlignment value) =>
      FlexBoxStyler(mainAxisAlignment: value);
  factory FlexBoxStyler.crossAxisAlignment(CrossAxisAlignment value) =>
      FlexBoxStyler(crossAxisAlignment: value);
  factory FlexBoxStyler.mainAxisSize(MainAxisSize value) =>
      FlexBoxStyler(mainAxisSize: value);
  factory FlexBoxStyler.spacing(double value) => FlexBoxStyler(spacing: value);
  factory FlexBoxStyler.verticalDirection(VerticalDirection value) =>
      FlexBoxStyler(verticalDirection: value);
  factory FlexBoxStyler.textDirection(TextDirection value) =>
      FlexBoxStyler(textDirection: value);
  factory FlexBoxStyler.textBaseline(TextBaseline value) =>
      FlexBoxStyler(textBaseline: value);

  // Decoration convenience
  factory FlexBoxStyler.color(Color value) => FlexBoxStyler().color(value);
  factory FlexBoxStyler.gradient(GradientMix value) =>
      FlexBoxStyler().gradient(value);
  factory FlexBoxStyler.border(BoxBorderMix value) =>
      FlexBoxStyler().border(value);
  factory FlexBoxStyler.borderRadius(BorderRadiusGeometryMix value) =>
      FlexBoxStyler().borderRadius(value);
  factory FlexBoxStyler.elevation(ElevationShadow value) =>
      FlexBoxStyler().elevation(value);
  factory FlexBoxStyler.shadow(BoxShadowMix value) =>
      FlexBoxStyler().shadow(value);
  factory FlexBoxStyler.shadows(List<BoxShadowMix> value) =>
      FlexBoxStyler().shadows(value);

  // Constraints convenience
  factory FlexBoxStyler.width(double value) => FlexBoxStyler().width(value);
  factory FlexBoxStyler.height(double value) => FlexBoxStyler().height(value);
  factory FlexBoxStyler.size(double width, double height) =>
      FlexBoxStyler().size(width, height);
  factory FlexBoxStyler.minWidth(double value) =>
      FlexBoxStyler().minWidth(value);
  factory FlexBoxStyler.maxWidth(double value) =>
      FlexBoxStyler().maxWidth(value);
  factory FlexBoxStyler.minHeight(double value) =>
      FlexBoxStyler().minHeight(value);
  factory FlexBoxStyler.maxHeight(double value) =>
      FlexBoxStyler().maxHeight(value);

  // Transform convenience
  factory FlexBoxStyler.scale(double scale, {Alignment alignment = .center}) =>
      FlexBoxStyler().scale(scale, alignment: alignment);
  factory FlexBoxStyler.rotate(double angle, {Alignment alignment = .center}) =>
      FlexBoxStyler().rotate(angle, alignment: alignment);

  // Style metadata convenience
  factory FlexBoxStyler.animate(AnimationConfig value) =>
      FlexBoxStyler().animate(value);

  // Flex convenience (zero-param presets)
  factory FlexBoxStyler.row() => FlexBoxStyler(direction: .horizontal);
  factory FlexBoxStyler.column() => FlexBoxStyler(direction: .vertical);

  // Decoration convenience (extended)
  factory FlexBoxStyler.image(DecorationImageMix value) =>
      FlexBoxStyler().image(value);
  factory FlexBoxStyler.shape(ShapeBorderMix value) =>
      FlexBoxStyler().shape(value);
  factory FlexBoxStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => FlexBoxStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory FlexBoxStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => FlexBoxStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory FlexBoxStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => FlexBoxStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory FlexBoxStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => FlexBoxStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory FlexBoxStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => FlexBoxStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory FlexBoxStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => FlexBoxStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory FlexBoxStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => FlexBoxStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory FlexBoxStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => FlexBoxStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory FlexBoxStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => FlexBoxStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );

  // Transform convenience (extended)
  factory FlexBoxStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => FlexBoxStyler().transform(value, alignment: alignment);
  factory FlexBoxStyler.translate(double x, double y, [double z = 0.0]) =>
      FlexBoxStyler().translate(x, y, z);
  factory FlexBoxStyler.skew(double skewX, double skewY) =>
      FlexBoxStyler().skew(skewX, skewY);
  static FlexBoxMutableStyler get chain => .new(FlexBoxStyler());

  // Box-style instance methods

  /// Sets the alignment property.
  FlexBoxStyler alignment(AlignmentGeometry value) {
    return merge(FlexBoxStyler(alignment: value));
  }

  /// Sets the transform alignment.
  FlexBoxStyler transformAlignment(AlignmentGeometry value) {
    return merge(FlexBoxStyler(transformAlignment: value));
  }

  /// Sets the clip behavior.
  FlexBoxStyler clipBehavior(Clip value) {
    return merge(FlexBoxStyler(clipBehavior: value));
  }

  /// Sets the widget modifier.
  FlexBoxStyler modifier(WidgetModifierConfig value) {
    return merge(FlexBoxStyler(modifier: value));
  }

  /// Creates a FlexBox widget with children.
  FlexBox call({Key? key, required List<Widget> children}) {
    return FlexBox(key: key, style: this, children: children);
  }

  /// Sets the animation property.
  @override
  FlexBoxStyler animate(AnimationConfig animation) {
    return merge(FlexBoxStyler(animation: animation));
  }

  /// Sets the foreground decoration.
  @override
  FlexBoxStyler foregroundDecoration(DecorationMix value) {
    return merge(FlexBoxStyler(foregroundDecoration: value));
  }

  /// Sets the flex property.
  @override
  FlexBoxStyler flex(FlexStyler value) {
    return merge(FlexBoxStyler.create(flex: Prop.maybeMix(value)));
  }

  /// Sets the padding property.
  @override
  FlexBoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyler(padding: value));
  }

  /// Sets the margin property.
  @override
  FlexBoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyler(margin: value));
  }

  /// Sets the transform property.
  @override
  FlexBoxStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      FlexBoxStyler(transform: value, transformAlignment: alignment),
    );
  }

  /// Sets the decoration property.
  @override
  FlexBoxStyler decoration(DecorationMix value) {
    return merge(FlexBoxStyler(decoration: value));
  }

  /// Sets the constraints property.
  @override
  FlexBoxStyler constraints(BoxConstraintsMix value) {
    return merge(FlexBoxStyler(constraints: value));
  }

  /// Sets the widget modifier (wrap).
  @override
  FlexBoxStyler wrap(WidgetModifierConfig value) {
    return modifier(value);
  }

  /// Sets the variants list.
  @override
  FlexBoxStyler variants(List<VariantStyle<FlexBoxSpec>> variants) {
    return merge(FlexBoxStyler(variants: variants));
  }

  /// Sets the border radius property via decoration.
  @override
  FlexBoxStyler borderRadius(BorderRadiusGeometryMix value) {
    return merge(FlexBoxStyler(decoration: DecorationMix.borderRadius(value)));
  }

  /// Sets the border property via decoration.
  @override
  FlexBoxStyler border(BoxBorderMix value) {
    return merge(FlexBoxStyler(decoration: DecorationMix.border(value)));
  }
}
