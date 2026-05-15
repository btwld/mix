import 'package:ack/ack.dart';
import 'package:flutter/painting.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/prop_encode.dart';
import '../../core/schema_wire_types.dart';
import '../shared/shared_schemas.dart';

final CodecSchema<Map<String, Object?>, BorderSideMix> borderSideCodec =
    Ack.codec<Map<String, Object?>, BorderSideMix>(
      input: Ack.object({
        'color': colorCodec.optional(),
        'width': Ack.number().optional(),
        'style': borderStyleSchema.optional(),
        'strokeAlign': Ack.number().optional(),
      }),
      output: Ack.instance<BorderSideMix>(),
      decoder: (data) => BorderSideMix(
        color: data['color'] as Color?,
        strokeAlign: castDoubleOrNull(data['strokeAlign']),
        style: data['style'] as BorderStyle?,
        width: castDoubleOrNull(data['width']),
      ),
      encoder: (value) => optionalJsonMap([
        ('color', propValue(value.$color)),
        ('width', propValue(value.$width)),
        ('style', propValue(value.$style)),
        ('strokeAlign', propValue(value.$strokeAlign)),
      ]),
    );

final CodecSchema<Map<String, Object?>, BoxShadowMix> boxShadowCodec =
    Ack.codec<Map<String, Object?>, BoxShadowMix>(
      input: Ack.object({
        'color': colorCodec.optional(),
        'offset': offsetCodec.optional(),
        'blurRadius': Ack.number().optional(),
        'spreadRadius': Ack.number().optional(),
      }),
      output: Ack.instance<BoxShadowMix>(),
      decoder: (data) => BoxShadowMix(
        color: data['color'] as Color?,
        offset: data['offset'] as Offset?,
        blurRadius: castDoubleOrNull(data['blurRadius']),
        spreadRadius: castDoubleOrNull(data['spreadRadius']),
      ),
      encoder: (value) => optionalJsonMap([
        ('color', propValue(value.$color)),
        ('offset', propValue(value.$offset)),
        ('blurRadius', propValue(value.$blurRadius)),
        ('spreadRadius', propValue(value.$spreadRadius)),
      ]),
    );

final AckSchema<BoxBorderMix> boxBorderCodec = Ack.discriminated<BoxBorderMix>(
  discriminatorKey: 'type',
  schemas: {
    for (final type in SchemaBorder.values)
      type.wireValue: _buildBoxBorderBranch(type),
  },
);

final AckSchema<BorderRadiusGeometryMix> borderRadiusCodec =
    Ack.discriminated<BorderRadiusGeometryMix>(
      discriminatorKey: 'type',
      schemas: {
        for (final type in SchemaBorderRadius.values)
          type.wireValue: _buildBorderRadiusBranch(type),
      },
    );

AckSchema<BoxBorderMix> _buildBoxBorderBranch(SchemaBorder type) {
  switch (type) {
    case .border:
      return Ack.codec<Map<String, Object?>, BoxBorderMix>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'top': borderSideCodec.optional(),
          'bottom': borderSideCodec.optional(),
          'left': borderSideCodec.optional(),
          'right': borderSideCodec.optional(),
        }),
        output: Ack.instance<BoxBorderMix>(),
        decoder: (data) => BorderMix(
          top: data['top'] as BorderSideMix?,
          bottom: data['bottom'] as BorderSideMix?,
          left: data['left'] as BorderSideMix?,
          right: data['right'] as BorderSideMix?,
        ),
        encoder: (value) {
          final mix = value as BorderMix;

          return optionalJsonMap([
            ('type', type.wireValue),
            ('top', propMix<BorderSideMix>(mix.$top)),
            ('bottom', propMix<BorderSideMix>(mix.$bottom)),
            ('left', propMix<BorderSideMix>(mix.$left)),
            ('right', propMix<BorderSideMix>(mix.$right)),
          ]);
        },
      );
    case .borderDirectional:
      return Ack.codec<Map<String, Object?>, BoxBorderMix>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'top': borderSideCodec.optional(),
          'bottom': borderSideCodec.optional(),
          'start': borderSideCodec.optional(),
          'end': borderSideCodec.optional(),
        }),
        output: Ack.instance<BoxBorderMix>(),
        decoder: (data) => BorderDirectionalMix(
          top: data['top'] as BorderSideMix?,
          bottom: data['bottom'] as BorderSideMix?,
          start: data['start'] as BorderSideMix?,
          end: data['end'] as BorderSideMix?,
        ),
        encoder: (value) {
          final mix = value as BorderDirectionalMix;

          return optionalJsonMap([
            ('type', type.wireValue),
            ('top', propMix<BorderSideMix>(mix.$top)),
            ('bottom', propMix<BorderSideMix>(mix.$bottom)),
            ('start', propMix<BorderSideMix>(mix.$start)),
            ('end', propMix<BorderSideMix>(mix.$end)),
          ]);
        },
      );
  }
}

AckSchema<BorderRadiusGeometryMix> _buildBorderRadiusBranch(
  SchemaBorderRadius type,
) {
  switch (type) {
    case .borderRadius:
      return Ack.codec<Map<String, Object?>, BorderRadiusGeometryMix>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'topLeft': radiusCodec.optional(),
          'topRight': radiusCodec.optional(),
          'bottomLeft': radiusCodec.optional(),
          'bottomRight': radiusCodec.optional(),
        }),
        output: Ack.instance<BorderRadiusGeometryMix>(),
        decoder: (data) => BorderRadiusMix(
          topLeft: data['topLeft'] as Radius?,
          topRight: data['topRight'] as Radius?,
          bottomLeft: data['bottomLeft'] as Radius?,
          bottomRight: data['bottomRight'] as Radius?,
        ),
        encoder: (value) {
          final mix = value as BorderRadiusMix;

          return optionalJsonMap([
            ('type', type.wireValue),
            ('topLeft', propValue(mix.$topLeft)),
            ('topRight', propValue(mix.$topRight)),
            ('bottomLeft', propValue(mix.$bottomLeft)),
            ('bottomRight', propValue(mix.$bottomRight)),
          ]);
        },
      );
    case .borderRadiusDirectional:
      return Ack.codec<Map<String, Object?>, BorderRadiusGeometryMix>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'topStart': radiusCodec.optional(),
          'topEnd': radiusCodec.optional(),
          'bottomStart': radiusCodec.optional(),
          'bottomEnd': radiusCodec.optional(),
        }),
        output: Ack.instance<BorderRadiusGeometryMix>(),
        decoder: (data) => BorderRadiusDirectionalMix(
          topStart: data['topStart'] as Radius?,
          topEnd: data['topEnd'] as Radius?,
          bottomStart: data['bottomStart'] as Radius?,
          bottomEnd: data['bottomEnd'] as Radius?,
        ),
        encoder: (value) {
          final mix = value as BorderRadiusDirectionalMix;

          return optionalJsonMap([
            ('type', type.wireValue),
            ('topStart', propValue(mix.$topStart)),
            ('topEnd', propValue(mix.$topEnd)),
            ('bottomStart', propValue(mix.$bottomStart)),
            ('bottomEnd', propValue(mix.$bottomEnd)),
          ]);
        },
      );
  }
}
