import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../contract/mix_schema_limits.dart';
import '../registry/registry_catalog.dart';
import 'metadata/metadata_schemas.dart';
import 'painting/painting_schemas.dart';
import 'shared/shared_schemas.dart';

final class MixSchemaCatalog {
  final RegistryCatalog registries;
  final MixSchemaLimits limits;

  late final AckSchema<AlignmentGeometry> alignment = alignmentCodec;
  late final AckSchema<Axis> axis = axisSchema;
  late final AckSchema<BlendMode> blendMode = blendModeSchema;
  late final AckSchema<BoxConstraintsMix> boxConstraints = boxConstraintsCodec;
  late final AckSchema<BoxFit> boxFit = boxFitSchema;
  late final AckSchema<Brightness> brightness = brightnessSchema;
  late final AckSchema<Clip> clip = clipSchema;
  late final AckSchema<Color> color = colorCodec;
  late final AckSchema<CrossAxisAlignment> crossAxisAlignment =
      crossAxisAlignmentSchema;
  late final AckSchema<ImageProvider<Object>> imageProvider =
      buildImageProviderSchema(registries: registries, limits: limits);
  late final AckSchema<IconData> iconData = buildIconDataSchema(
    registries: registries,
    limits: limits,
  );
  late final AckSchema<DecorationMix> decoration = buildDecorationSchema(
    boxDecorationSchema: boxDecoration,
    shapeDecorationSchema: shapeDecoration,
  );
  late final AckSchema<DecorationImageMix> decorationImage =
      buildDecorationImageSchema(imageProviderSchema: imageProvider);
  late final AckSchema<EdgeInsetsGeometryMix> edgeInsetsGeometry =
      edgeInsetsGeometryCodec;
  late final AckSchema<FilterQuality> filterQuality = filterQualitySchema;
  late final AckSchema<ImageRepeat> imageRepeat = imageRepeatSchema;
  late final AckSchema<MainAxisAlignment> mainAxisAlignment =
      mainAxisAlignmentSchema;
  late final AckSchema<MainAxisSize> mainAxisSize = mainAxisSizeSchema;
  late final AckSchema<Matrix4> matrix4 = matrix4Codec;
  late final AckSchema<Rect> rect = rectCodec;
  late final AckSchema<ShadowMix> shadow = shadowCodec;
  late final AckSchema<StackFit> stackFit = stackFitSchema;
  late final AckSchema<StrutStyleMix> strutStyle = strutStyleCodec;
  late final AckSchema<TextAlign> textAlign = textAlignSchema;
  late final AckSchema<TextBaseline> textBaseline = textBaselineSchema;
  late final AckSchema<TextDirection> textDirection = textDirectionSchema;
  late final AckSchema<TextHeightBehaviorMix> textHeightBehavior =
      textHeightBehaviorCodec;
  late final AckSchema<TextOverflow> textOverflow = textOverflowSchema;
  late final AckSchema<TextScaler> textScaler = buildTextScalerSchema();
  late final AckSchema<TextStyleMix> textStyle = textStyleCodec;
  late final AckSchema<TextWidthBasis> textWidthBasis = textWidthBasisSchema;
  late final AckSchema<Directive<String>> textTransformDirective =
      textTransformDirectiveSchema;
  late final AckSchema<Locale> locale = localeCodec;
  late final AckSchema<VerticalDirection> verticalDirection =
      verticalDirectionSchema;
  late final AckSchema<CurveAnimationConfig> animation = buildAnimationSchema(
    registries: registries,
    limits: limits,
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
    borderSideCodec: borderSideCodec,
    borderRadiusSchema: borderRadius,
  );
  late final AckSchema<BoxDecorationMix> boxDecoration =
      buildBoxDecorationSchema(
        borderSchema: boxBorder,
        borderRadiusSchema: borderRadius,
        gradientSchema: gradient,
        imageSchema: decorationImage,
      );
  late final AckSchema<ShapeDecorationMix> shapeDecoration =
      buildShapeDecorationSchema(
        shapeBorderSchema: shapeBorder,
        gradientSchema: gradient,
        imageSchema: decorationImage,
      );

  MixSchemaCatalog({
    required this.registries,
    this.limits = const MixSchemaLimits(),
  });

  Map<String, AckSchema> buildMetadataFields<
    S extends Spec<S>,
    T extends Style<S>
  >({required AckSchema<T> styleSchema, required T emptyStyle}) {
    final AckSchema<VariantStyle<S>> variantSchema = buildVariantSchema(
      styleSchema: styleSchema,
      emptyStyle: emptyStyle,
      registries: registries,
      limits: limits,
    );

    return buildMetadataFieldSchemas(
      animationSchema: animation,
      modifierSchema: modifier,
      variantSchema: variantSchema,
      limits: limits,
    );
  }

  Map<String, AckSchema> buildVariantStyleMetadataFields() {
    return buildVariantStyleMetadataFieldSchemas(
      modifierSchema: modifier,
      limits: limits,
    );
  }

  WidgetModifierConfig? buildModifierConfig(Map<String, Object?> data) {
    return buildWidgetModifierConfigFromFields(data);
  }
}
