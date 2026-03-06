import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/schema_wire_types.dart';
import '../discriminated_branch_registry.dart';
import '../shared/color_schema.dart';
import '../shared/enum_schemas.dart';
import 'border_schemas.dart';

AckSchema<BoxDecorationMix> buildBoxDecorationSchema({
  required AckSchema<BoxBorderMix> borderSchema,
  required AckSchema<BorderRadiusGeometryMix> borderRadiusSchema,
  required AckSchema<GradientMix> gradientSchema,
}) {
  return Ack.object({
        'color': colorSchema.optional(),
        'gradient': gradientSchema.optional(),
        'border': borderSchema.optional(),
        'borderRadius': borderRadiusSchema.optional(),
        'shape': boxShapeSchema.optional(),
        'backgroundBlendMode': blendModeSchema.optional(),
        'boxShadow': Ack.list(boxShadowSchema).optional(),
      })
      .refine((data) {
        final map = data;

        return map['shape'] != BoxShape.circle || map['borderRadius'] == null;
      }, message: 'borderRadius is not supported when shape is circle.')
      .transform<BoxDecorationMix>((data) {
        final map = data!;

        return BoxDecorationMix(
          border: map['border'] as BoxBorderMix?,
          borderRadius: map['borderRadius'] as BorderRadiusGeometryMix?,
          shape: map['shape'] as BoxShape?,
          backgroundBlendMode: map['backgroundBlendMode'] as BlendMode?,
          color: map['color'] as Color?,
          gradient: map['gradient'] as GradientMix?,
          boxShadow: castListOrNull(map['boxShadow']),
        );
      });
}

AckSchema<ShapeDecorationMix> buildShapeDecorationSchema({
  required AckSchema<ShapeBorderMix> shapeBorderSchema,
  required AckSchema<GradientMix> gradientSchema,
}) {
  return Ack.object({
    'shape': shapeBorderSchema.optional(),
    'color': colorSchema.optional(),
    'gradient': gradientSchema.optional(),
    'shadows': Ack.list(boxShadowSchema).optional(),
  }).transform<ShapeDecorationMix>((data) {
    final map = data!;

    return ShapeDecorationMix(
      shape: map['shape'] as ShapeBorderMix?,
      color: map['color'] as Color?,
      gradient: map['gradient'] as GradientMix?,
      shadows: castListOrNull(map['shadows']),
    );
  });
}

AckSchema<DecorationMix> buildDecorationSchema({
  required AckSchema<BoxDecorationMix> boxDecorationSchema,
  required AckSchema<ShapeDecorationMix> shapeDecorationSchema,
}) {
  final registry = DiscriminatedBranchRegistry<DecorationMix>(
    discriminatorKey: 'type',
  );

  for (final type in SchemaDecoration.values) {
    switch (type) {
      case .box:
        registry.register(type.wireValue, boxDecorationSchema);
      case .shape:
        registry.register(type.wireValue, shapeDecorationSchema);
    }
  }

  return registry.freeze();
}
