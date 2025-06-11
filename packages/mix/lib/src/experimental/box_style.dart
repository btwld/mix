import 'package:flutter/widgets.dart';

import '../attributes/animated/animated_data_dto.dart';
import '../attributes/animated/animated_util.dart';
import '../attributes/constraints/constraints_dto.dart';
import '../attributes/decoration/decoration_dto.dart';
import '../attributes/enum/enum_util.dart';
import '../attributes/modifiers/widget_modifiers_data_dto.dart';
import '../attributes/modifiers/widget_modifiers_util.dart';
import '../attributes/scalars/scalar_util.dart';
import '../attributes/spacing/edge_insets_dto.dart';
import '../attributes/spacing/spacing_util.dart';
import '../core/factory/mix_data.dart';
import '../core/spec.dart';
import '../core/utility.dart';
import '../specs/box/box_spec.dart';
import '../variants/variant_attribute.dart';

class BoxStyle extends FluentAttribute<BoxSpecAttribute, BoxSpec, BoxStyle> {
  /// Utility for defining [BoxSpecAttribute.height]
  late final height = DoubleUtility((v) => only(height: v));
  late final width = DoubleUtility((v) => only(width: v));

  late final decoration = BoxDecorationUtility((v) => only(decoration: v));

  late final alignment = AlignmentGeometryUtility((v) => only(alignment: v));

  /// Utility for defining [BoxSpecAttribute.padding]
  late final padding = EdgeInsetsGeometryUtility((v) => only(padding: v));

  /// Utility for defining [BoxSpecAttribute.margin]
  late final margin = EdgeInsetsGeometryUtility((v) => only(margin: v));

  /// Utility for defining [BoxSpecAttribute.constraints]
  late final constraints = BoxConstraintsUtility((v) => only(constraints: v));

  /// Utility for defining [BoxSpecAttribute.constraints.minWidth]
  late final minWidth = constraints.minWidth;

  /// Utility for defining [BoxSpecAttribute.constraints.maxWidth]
  late final maxWidth = constraints.maxWidth;

  /// Utility for defining [BoxSpecAttribute.constraints.minHeight]
  late final minHeight = constraints.minHeight;

  /// Utility for defining [BoxSpecAttribute.constraints.maxHeight]
  late final maxHeight = constraints.maxHeight;

  /// Utility for defining [BoxSpecAttribute.decoration.color]
  late final color = decoration.color;

  /// Utility for defining [BoxSpecAttribute.decoration.border]
  late final border = decoration.border;

  /// Utility for defining [BoxSpecAttribute.decoration.border.directional]
  late final borderDirectional = decoration.border.directional;

  /// Utility for defining [BoxSpecAttribute.decoration.borderRadius]
  late final borderRadius = decoration.borderRadius;

  /// Utility for defining [BoxSpecAttribute.decoration.borderRadius.directional]
  late final borderRadiusDirectional = decoration.borderRadius.directional;

  /// Utility for defining [BoxSpecAttribute.decoration.gradient]
  late final gradient = decoration.gradient;

  /// Utility for defining [BoxSpecAttribute.decoration.gradient.sweep]
  late final sweepGradient = decoration.gradient.sweep;

  /// Utility for defining [BoxSpecAttribute.decoration.gradient.radial]
  late final radialGradient = decoration.gradient.radial;

  /// Utility for defining [BoxSpecAttribute.decoration.gradient.linear]
  late final linearGradient = decoration.gradient.linear;

  /// Utility for defining [BoxSpecAttribute.decoration.boxShadows]
  late final shadows = decoration.boxShadows;

  /// Utility for defining [BoxSpecAttribute.decoration.boxShadow]
  late final shadow = decoration.boxShadow;

  /// Utility for defining [BoxSpecAttribute.decoration.elevation]
  late final elevation = decoration.elevation;

  /// Utility for defining [BoxSpecAttribute.decoration]
  late final shapeDecoration =
      ShapeDecorationUtility((v) => only(decoration: v));

  /// Utility for defining [BoxSpecAttribute.shapeDecoration.shape]
  late final shape = shapeDecoration.shape;

  /// Utility for defining [BoxSpecAttribute.foregroundDecoration]
  late final foregroundDecoration =
      BoxDecorationUtility((v) => only(foregroundDecoration: v));

  /// Utility for defining [BoxSpecAttribute.transform]
  late final transform = Matrix4Utility((v) => only(transform: v));

  /// Utility for defining [BoxSpecAttribute.transformAlignment]
  late final transformAlignment =
      AlignmentGeometryUtility((v) => only(transformAlignment: v));

  /// Utility for defining [BoxSpecAttribute.clipBehavior]
  late final clipBehavior = ClipUtility((v) => only(clipBehavior: v));

  /// Utility for defining [BoxSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [BoxSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  BoxStyle._(super.attribute, {super.variants});
  BoxStyle() : this._(const BoxSpecAttribute());

  BoxSpecAttribute _merge(BoxSpecAttribute a) {
    return value.merge(a);
  }

  BoxStyle only({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometryDto? padding,
    EdgeInsetsGeometryDto? margin,
    BoxConstraintsDto? constraints,
    DecorationDto? decoration,
    DecorationDto? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    double? width,
    double? height,
    WidgetModifiersDataDto? modifiers,
    AnimatedDataDto? animated,
  }) =>
      BoxStyle._(_merge(BoxSpecAttribute(
        alignment: alignment,
        padding: padding,
        margin: margin,
        constraints: constraints,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        width: width,
        height: height,
        modifiers: modifiers,
        animated: animated,
      )));

  @override
  BoxStyle merge(covariant BoxStyle? other) {
    if (other == null) return BoxStyle();

    return BoxStyle._(value.merge(other.value), variants: [
      ...variants,
      ...other.variants,
    ]);
  }

  @override
  BoxSpec resolve(MixData mix) {
    return value.resolve(mix);
  }

  @override
  List<Object?> get props => [value, variants];

  @override
  BoxStyle Function(BoxSpecAttribute value, {List<VariantAttribute> variants})
      get constructor => BoxStyle._;

  @override
  BoxStyle Function() get constructorEmpty => BoxStyle.new;
}
