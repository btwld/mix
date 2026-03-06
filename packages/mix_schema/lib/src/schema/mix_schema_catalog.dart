import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry_catalog.dart';
import 'metadata/animation_schema.dart';
import 'metadata/metadata_field_schemas.dart';
import 'metadata/modifier_schema.dart';
import 'metadata/variant_schema.dart';
import 'painting/border_schemas.dart';
import 'painting/decoration_schemas.dart';
import 'painting/gradient_schemas.dart';
import 'painting/shape_border_schemas.dart';
import 'shared/box_constraints_schema.dart';
import 'shared/color_schema.dart';
import 'shared/edge_insets_schema.dart';
import 'shared/enum_schemas.dart';
import 'shared/primitive_schemas.dart';
import 'shared/typography_schemas.dart';

final class MixSchemaCatalog {
  final RegistryCatalog registries;

  late final AckSchema<AlignmentGeometry> alignment = alignmentSchema;

  late final AckSchema<Axis> axis = axisSchema;
  late final AckSchema<BlendMode> blendMode = blendModeSchema;
  late final AckSchema<BoxConstraintsMix> boxConstraints = boxConstraintsSchema;
  late final AckSchema<BoxFit> boxFit = boxFitSchema;
  late final AckSchema<Brightness> brightness = brightnessSchema;
  late final AckSchema<Clip> clip = clipSchema;
  late final AckSchema<Color> color = colorSchema;
  late final AckSchema<CrossAxisAlignment> crossAxisAlignment =
      crossAxisAlignmentSchema;
  late final AckSchema<DecorationMix> decoration = buildDecorationSchema(
    boxDecorationSchema: boxDecoration,
    shapeDecorationSchema: shapeDecoration,
  );
  late final AckSchema<EdgeInsetsGeometryMix> edgeInsetsGeometry =
      edgeInsetsGeometrySchema;
  late final AckSchema<FilterQuality> filterQuality = filterQualitySchema;
  late final AckSchema<ImageRepeat> imageRepeat = imageRepeatSchema;
  late final AckSchema<MainAxisAlignment> mainAxisAlignment =
      mainAxisAlignmentSchema;
  late final AckSchema<MainAxisSize> mainAxisSize = mainAxisSizeSchema;
  late final AckSchema<Matrix4> matrix4 = matrix4Schema;
  late final AckSchema<Rect> rect = rectSchema;
  late final AckSchema<ShadowMix> shadow = shadowSchema;
  late final AckSchema<StackFit> stackFit = stackFitSchema;
  late final AckSchema<StrutStyleMix> strutStyle = strutStyleSchema;
  late final AckSchema<TextAlign> textAlign = textAlignSchema;
  late final AckSchema<TextBaseline> textBaseline = textBaselineSchema;
  late final AckSchema<TextDirection> textDirection = textDirectionSchema;
  late final AckSchema<TextHeightBehaviorMix> textHeightBehavior =
      textHeightBehaviorSchema;
  late final AckSchema<TextOverflow> textOverflow = textOverflowSchema;
  late final AckSchema<TextScaler> textScaler = buildTextScalerSchema();
  late final AckSchema<TextStyleMix> textStyle = textStyleSchema;
  late final AckSchema<TextWidthBasis> textWidthBasis = textWidthBasisSchema;
  late final AckSchema<Directive<String>> textTransformDirective =
      textTransformDirectiveSchema;
  late final AckSchema<Locale> locale = localeSchema;
  late final AckSchema<VerticalDirection> verticalDirection =
      verticalDirectionSchema;
  late final AckSchema<CurveAnimationConfig> animation = buildAnimationSchema(
    registries: registries,
  );

  late final AckSchema<ModifierMix> modifier = buildModifierSchema();
  late final AckSchema<BoxBorderMix> boxBorder = buildBoxBorderSchema();
  late final AckSchema<BorderRadiusGeometryMix> borderRadius =
      buildBorderRadiusSchema();
  late final AckSchema<GradientTransform> gradientTransform =
      buildGradientTransformSchema();
  late final AckSchema<GradientMix> gradient = buildGradientSchema(
    gradientTransformSchema: gradientTransform,
  );
  late final AckSchema<ShapeBorderMix> shapeBorder = buildShapeBorderSchema(
    borderSideSchema: borderSideSchema,
    borderRadiusSchema: borderRadius,
  );
  late final AckSchema<BoxDecorationMix> boxDecoration =
      buildBoxDecorationSchema(
        borderSchema: boxBorder,
        borderRadiusSchema: borderRadius,
        gradientSchema: gradient,
      );
  late final AckSchema<ShapeDecorationMix> shapeDecoration =
      buildShapeDecorationSchema(
        shapeBorderSchema: shapeBorder,
        gradientSchema: gradient,
      );
  MixSchemaCatalog({required this.registries});

  Map<String, AckSchema> buildMetadataFields<
    S extends Spec<S>,
    T extends Style<S>
  >({required AckSchema<T> styleSchema, required T emptyStyle}) {
    final AckSchema<VariantStyle<S>> variantSchema = buildVariantSchema(
      styleSchema: styleSchema,
      emptyStyle: emptyStyle,
      registries: registries,
    );

    return buildMetadataFieldSchemas(
      animationSchema: animation,
      modifierSchema: modifier,
      variantSchema: variantSchema,
    );
  }

  WidgetModifierConfig? buildModifierConfig(Map<String, Object?> data) {
    return buildWidgetModifierConfigFromFields(data);
  }
}
