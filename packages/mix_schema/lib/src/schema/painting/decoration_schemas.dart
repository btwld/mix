import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../contract/mix_schema_limits.dart';
import '../../core/json_casts.dart';
import '../../core/prop_encode.dart';
import '../../core/schema_wire_types.dart';
import '../../registry/registry_catalog.dart';
import '../shared/shared_schemas.dart';
import 'border_schemas.dart';
import 'gradient_schemas.dart';
import 'shape_border_schemas.dart';

CodecSchema<Map<String, Object?>, DecorationImageMix> buildDecorationImageCodec(
  RegistryCatalog registries, {
  required MixSchemaLimits limits,
}) {
  final imageProviderCodec = buildImageProviderCodec(
    registries,
    limits: limits,
  );

  return Ack.codec<Map<String, Object?>, DecorationImageMix>(
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
    decoder: (data) {
      final map = data;

      return DecorationImageMix(
        image: map['image'] as ImageProvider<Object>,
        fit: map['fit'] as BoxFit?,
        alignment: map['alignment'] as AlignmentGeometry?,
        centerSlice: map['centerSlice'] as Rect?,
        repeat: map['repeat'] as ImageRepeat?,
        filterQuality: map['filterQuality'] as FilterQuality?,
        invertColors: map['invertColors'] as bool?,
        isAntiAlias: map['isAntiAlias'] as bool?,
      );
    },
    encoder: (value) => optionalJsonMap([
      ('image', requiredPropValue(value.$image, 'image')),
      ('fit', propValue(value.$fit)),
      ('alignment', propValue(value.$alignment)),
      ('centerSlice', propValue(value.$centerSlice)),
      ('repeat', propValue(value.$repeat)),
      ('filterQuality', propValue(value.$filterQuality)),
      ('invertColors', propValue(value.$invertColors)),
      ('isAntiAlias', propValue(value.$isAntiAlias)),
    ]),
  );
}

CodecSchema<Map<String, Object?>, BoxDecorationMix> buildBoxDecorationCodec(
  RegistryCatalog registries, {
  required MixSchemaLimits limits,
}) {
  final decorationImageCodec = buildDecorationImageCodec(
    registries,
    limits: limits,
  );

  return Ack.codec<Map<String, Object?>, BoxDecorationMix>(
    input:
        Ack.object({
          'type': Ack.literal(SchemaDecoration.box.wireValue),
          'color': colorCodec.optional(),
          'image': decorationImageCodec.optional(),
          'gradient': gradientCodec.optional(),
          'border': boxBorderCodec.optional(),
          'borderRadius': borderRadiusCodec.optional(),
          'shape': boxShapeSchema.optional(),
          'backgroundBlendMode': blendModeSchema.optional(),
          'boxShadow': Ack.list(boxShadowCodec).optional(),
        }).refine((data) {
          final map = data;

          return map['shape'] != BoxShape.circle || map['borderRadius'] == null;
        }, message: 'borderRadius is not supported when shape is circle.'),
    output: Ack.instance<BoxDecorationMix>(),
    decoder: (data) {
      final map = data;

      return BoxDecorationMix(
        border: map['border'] as BoxBorderMix?,
        borderRadius: map['borderRadius'] as BorderRadiusGeometryMix?,
        shape: map['shape'] as BoxShape?,
        backgroundBlendMode: map['backgroundBlendMode'] as BlendMode?,
        color: map['color'] as Color?,
        image: map['image'] as DecorationImageMix?,
        gradient: map['gradient'] as GradientMix?,
        boxShadow: castListOrNull(map['boxShadow']),
      );
    },
    encoder: (value) {
      final BoxShadowListMix? boxShadow = propMix(value.$boxShadow);

      return optionalJsonMap([
        ('type', SchemaDecoration.box.wireValue),
        ('color', propValue(value.$color)),
        ('image', propMix<DecorationImageMix>(value.$image)),
        ('gradient', propMix<GradientMix>(value.$gradient)),
        ('border', propMix<BoxBorderMix>(value.$border)),
        ('borderRadius', propMix<BorderRadiusGeometryMix>(value.$borderRadius)),
        ('shape', propValue(value.$shape)),
        ('backgroundBlendMode', propValue(value.$backgroundBlendMode)),
        ('boxShadow', boxShadow?.items),
      ]);
    },
  );
}

CodecSchema<Map<String, Object?>, ShapeDecorationMix> buildShapeDecorationCodec(
  RegistryCatalog registries, {
  required MixSchemaLimits limits,
}) {
  final decorationImageCodec = buildDecorationImageCodec(
    registries,
    limits: limits,
  );

  return Ack.codec<Map<String, Object?>, ShapeDecorationMix>(
    input: Ack.object({
      'type': Ack.literal(SchemaDecoration.shape.wireValue),
      'shape': shapeBorderCodec.optional(),
      'color': colorCodec.optional(),
      'image': decorationImageCodec.optional(),
      'gradient': gradientCodec.optional(),
      'shadows': Ack.list(boxShadowCodec).optional(),
    }),
    output: Ack.instance<ShapeDecorationMix>(),
    decoder: (data) {
      final map = data;

      return ShapeDecorationMix(
        shape: map['shape'] as ShapeBorderMix?,
        color: map['color'] as Color?,
        image: map['image'] as DecorationImageMix?,
        gradient: map['gradient'] as GradientMix?,
        shadows: castListOrNull(map['shadows']),
      );
    },
    encoder: (value) {
      final BoxShadowListMix? shadows = propMix(value.$shadows);

      return optionalJsonMap([
        ('type', SchemaDecoration.shape.wireValue),
        ('shape', propMix<ShapeBorderMix>(value.$shape)),
        ('color', propValue(value.$color)),
        ('image', propMix<DecorationImageMix>(value.$image)),
        ('gradient', propMix<GradientMix>(value.$gradient)),
        ('shadows', shadows?.items),
      ]);
    },
  );
}

AckSchema<DecorationMix> buildDecorationCodec(
  RegistryCatalog registries, {
  required MixSchemaLimits limits,
}) {
  return Ack.discriminated<DecorationMix>(
    discriminatorKey: 'type',
    schemas: {
      SchemaDecoration.box.wireValue: buildBoxDecorationCodec(
        registries,
        limits: limits,
      ),
      SchemaDecoration.shape.wireValue: buildShapeDecorationCodec(
        registries,
        limits: limits,
      ),
    },
  );
}
