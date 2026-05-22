import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/branch_codec.dart';
import '../../core/json_casts.dart';
import '../../core/prop_encode.dart';
import '../../core/schema_wire_types.dart';
import '../../registry/registry_catalog.dart';
import '../shared/shared_schemas.dart';
import 'border_schemas.dart';
import 'gradient_schemas.dart';
import 'shape_border_schemas.dart';

CodecSchema<JsonMap, DecorationImageMix> buildDecorationImageCodec(
  RegistryCatalog registries,
) {
  final imageProviderCodec = buildImageProviderCodec(registries);

  return Ack.codec<JsonMap, JsonMap, DecorationImageMix>(
    input: Ack.object({
      'image': imageProviderCodec,
      'fit': boxFitSchema.optional(),
      'alignment': alignmentCodec.optional(),
      'centerSlice': rectCodec.optional(),
      'repeat': imageRepeatSchema.optional(),
      'filterQuality': filterQualitySchema.optional(),
      'invertColors': Ack.boolean().optional(),
      'isAntiAlias': Ack.boolean().optional(),
    }),
    output: Ack.instance<DecorationImageMix>(),
    decode: (data) => DecorationImageMix(
      image: data['image']! as ImageProvider<Object>,
      fit: data['fit'] as BoxFit?,
      alignment: data['alignment'] as AlignmentGeometry?,
      centerSlice: data['centerSlice'] as Rect?,
      repeat: data['repeat'] as ImageRepeat?,
      filterQuality: data['filterQuality'] as FilterQuality?,
      invertColors: data['invertColors'] as bool?,
      isAntiAlias: data['isAntiAlias'] as bool?,
    ),
    encode: (value) => optionalJsonMap([
      ('image', requiredDirectPropValue(value.$image, 'image')),
      ('fit', directPropValue(value.$fit)),
      ('alignment', directPropValue(value.$alignment)),
      ('centerSlice', directPropValue(value.$centerSlice)),
      ('repeat', directPropValue(value.$repeat)),
      ('filterQuality', directPropValue(value.$filterQuality)),
      ('invertColors', directPropValue(value.$invertColors)),
      ('isAntiAlias', directPropValue(value.$isAntiAlias)),
    ]),
  );
}

CodecSchema<JsonMap, BoxDecorationMix> buildBoxDecorationCodec(
  RegistryCatalog registries,
) {
  final decorationImageCodec = buildDecorationImageCodec(registries);

  return buildDiscriminatorInjectingCodec<BoxDecorationMix>(
    type: SchemaDecoration.box.wireValue,
    input: Ack.object({
      'color': colorCodec.optional(),
      'image': decorationImageCodec.optional(),
      'gradient': gradientCodec.optional(),
      'border': boxBorderCodec.optional(),
      'borderRadius': borderRadiusCodec.optional(),
      'shape': boxShapeSchema.optional(),
      'backgroundBlendMode': blendModeSchema.optional(),
      'boxShadow': Ack.list(boxShadowCodec).optional(),
    }).refine((data) {
      return data['shape'] != BoxShape.circle || data['borderRadius'] == null;
    }, message: 'borderRadius is not supported when shape is circle.'),
    output: Ack.instance<BoxDecorationMix>(),
    decode: (data) => BoxDecorationMix(
      border: data['border'] as BoxBorderMix?,
      borderRadius: data['borderRadius'] as BorderRadiusGeometryMix?,
      shape: data['shape'] as BoxShape?,
      backgroundBlendMode: data['backgroundBlendMode'] as BlendMode?,
      color: data['color'] as Color?,
      image: data['image'] as DecorationImageMix?,
      gradient: data['gradient'] as GradientMix?,
      boxShadow: castListOrNull(data['boxShadow']),
    ),
    encode: (value) {
      final BoxShadowListMix? boxShadow = directPropMix(value.$boxShadow);

      return optionalJsonMap([
        ('color', directPropValue(value.$color)),
        ('image', directPropMix<DecorationImageMix>(value.$image)),
        ('gradient', directPropMix<GradientMix>(value.$gradient)),
        ('border', directPropMix<BoxBorderMix>(value.$border)),
        (
          'borderRadius',
          directPropMix<BorderRadiusGeometryMix>(value.$borderRadius),
        ),
        ('shape', directPropValue(value.$shape)),
        ('backgroundBlendMode', directPropValue(value.$backgroundBlendMode)),
        ('boxShadow', boxShadow?.items),
      ]);
    },
  );
}

CodecSchema<JsonMap, ShapeDecorationMix> buildShapeDecorationCodec(
  RegistryCatalog registries,
) {
  final decorationImageCodec = buildDecorationImageCodec(registries);

  return buildDiscriminatorInjectingCodec<ShapeDecorationMix>(
    type: SchemaDecoration.shape.wireValue,
    input: Ack.object({
      'shape': shapeBorderCodec.optional(),
      'color': colorCodec.optional(),
      'image': decorationImageCodec.optional(),
      'gradient': gradientCodec.optional(),
      'shadows': Ack.list(boxShadowCodec).optional(),
    }),
    output: Ack.instance<ShapeDecorationMix>(),
    decode: (data) => ShapeDecorationMix(
      shape: data['shape'] as ShapeBorderMix?,
      color: data['color'] as Color?,
      image: data['image'] as DecorationImageMix?,
      gradient: data['gradient'] as GradientMix?,
      shadows: castListOrNull(data['shadows']),
    ),
    encode: (value) {
      final BoxShadowListMix? shadows = directPropMix(value.$shadows);

      return optionalJsonMap([
        ('shape', directPropMix<ShapeBorderMix>(value.$shape)),
        ('color', directPropValue(value.$color)),
        ('image', directPropMix<DecorationImageMix>(value.$image)),
        ('gradient', directPropMix<GradientMix>(value.$gradient)),
        ('shadows', shadows?.items),
      ]);
    },
  );
}

DiscriminatedObjectSchema<DecorationMix> buildDecorationCodec(
  RegistryCatalog registries,
) {
  return Ack.discriminated<DecorationMix>(
    discriminatorKey: 'type',
    schemas: {
      SchemaDecoration.box.wireValue: buildBoxDecorationCodec(registries),
      SchemaDecoration.shape.wireValue: buildShapeDecorationCodec(registries),
    },
  );
}
