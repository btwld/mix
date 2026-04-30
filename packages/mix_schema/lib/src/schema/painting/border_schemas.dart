import 'package:ack/ack.dart';
import 'package:flutter/painting.dart';
import 'package:mix/mix.dart';

import '../../core/schema_wire_types.dart';
import '../discriminated_schema_builder.dart';
import '../shared/shared_schemas.dart';

final AckSchema<BorderSideMix> borderSideSchema =
    Ack.object({
      'color': colorSchema.optional(),
      'width': Ack.double().optional(),
      'style': borderStyleSchema.optional(),
      'strokeAlign': Ack.double().optional(),
    }).transform<BorderSideMix>((data) {
      final map = data;

      return BorderSideMix(
        color: map['color'] as Color?,
        strokeAlign: map['strokeAlign'] as double?,
        style: map['style'] as BorderStyle?,
        width: map['width'] as double?,
      );
    });

final AckSchema<BoxShadowMix> boxShadowSchema =
    Ack.object({
      'color': colorSchema.optional(),
      'offset': offsetSchema.optional(),
      'blurRadius': Ack.double().optional(),
      'spreadRadius': Ack.double().optional(),
    }).transform<BoxShadowMix>((data) {
      final map = data;

      return BoxShadowMix(
        color: map['color'] as Color?,
        offset: map['offset'] as Offset?,
        blurRadius: map['blurRadius'] as double?,
        spreadRadius: map['spreadRadius'] as double?,
      );
    });

AckSchema<BoxBorderMix> buildBoxBorderSchema() {
  return buildDiscriminatedSchema<BoxBorderMix>(
    discriminatorKey: 'type',
    branches: [
      for (final type in SchemaBorder.values)
        discriminatedBranch<BoxBorderMix, BoxBorderMix>(
          type: type.wireValue,
          schema: _buildBoxBorderBranch(type),
        ),
    ],
  );
}

AckSchema<BorderRadiusGeometryMix> buildBorderRadiusSchema() {
  return buildDiscriminatedSchema<BorderRadiusGeometryMix>(
    discriminatorKey: 'type',
    branches: [
      for (final type in SchemaBorderRadius.values)
        discriminatedBranch<BorderRadiusGeometryMix, BorderRadiusGeometryMix>(
          type: type.wireValue,
          schema: _buildBorderRadiusBranch(type),
        ),
    ],
  );
}

AckSchema<BoxBorderMix> _buildBoxBorderBranch(SchemaBorder type) {
  switch (type) {
    case .border:
      return Ack.object({
        'top': borderSideSchema.optional(),
        'bottom': borderSideSchema.optional(),
        'left': borderSideSchema.optional(),
        'right': borderSideSchema.optional(),
      }).transform<BoxBorderMix>((data) {
        final map = data;

        return BorderMix(
          top: map['top'] as BorderSideMix?,
          bottom: map['bottom'] as BorderSideMix?,
          left: map['left'] as BorderSideMix?,
          right: map['right'] as BorderSideMix?,
        );
      });
    case .borderDirectional:
      return Ack.object({
        'top': borderSideSchema.optional(),
        'bottom': borderSideSchema.optional(),
        'start': borderSideSchema.optional(),
        'end': borderSideSchema.optional(),
      }).transform<BoxBorderMix>((data) {
        final map = data;

        return BorderDirectionalMix(
          top: map['top'] as BorderSideMix?,
          bottom: map['bottom'] as BorderSideMix?,
          start: map['start'] as BorderSideMix?,
          end: map['end'] as BorderSideMix?,
        );
      });
  }
}

AckSchema<BorderRadiusGeometryMix> _buildBorderRadiusBranch(
  SchemaBorderRadius type,
) {
  switch (type) {
    case .borderRadius:
      return Ack.object({
        'topLeft': radiusSchema.optional(),
        'topRight': radiusSchema.optional(),
        'bottomLeft': radiusSchema.optional(),
        'bottomRight': radiusSchema.optional(),
      }).transform<BorderRadiusGeometryMix>((data) {
        final map = data;

        return BorderRadiusMix(
          topLeft: map['topLeft'] as Radius?,
          topRight: map['topRight'] as Radius?,
          bottomLeft: map['bottomLeft'] as Radius?,
          bottomRight: map['bottomRight'] as Radius?,
        );
      });
    case .borderRadiusDirectional:
      return Ack.object({
        'topStart': radiusSchema.optional(),
        'topEnd': radiusSchema.optional(),
        'bottomStart': radiusSchema.optional(),
        'bottomEnd': radiusSchema.optional(),
      }).transform<BorderRadiusGeometryMix>((data) {
        final map = data;

        return BorderRadiusDirectionalMix(
          topStart: map['topStart'] as Radius?,
          topEnd: map['topEnd'] as Radius?,
          bottomStart: map['bottomStart'] as Radius?,
          bottomEnd: map['bottomEnd'] as Radius?,
        );
      });
  }
}
