import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/prop_encode.dart';
import '../../core/schema_wire_types.dart';
import 'border_schemas.dart';

final CodecSchema<Map<String, Object?>, LinearBorderEdgeMix>
linearBorderEdgeCodec = Ack.codec<Map<String, Object?>, LinearBorderEdgeMix>(
  input: Ack.object({
    'size': Ack.number().optional(),
    'alignment': Ack.number().optional(),
  }),
  output: Ack.instance<LinearBorderEdgeMix>(),
  decoder: (data) => LinearBorderEdgeMix(
    size: castDoubleOrNull(data['size']),
    alignment: castDoubleOrNull(data['alignment']),
  ),
  encoder: (value) => optionalJsonMap([
    ('size', propValue(value.$size)),
    ('alignment', propValue(value.$alignment)),
  ]),
);

final AckSchema<ShapeBorderMix> shapeBorderCodec =
    Ack.discriminated<ShapeBorderMix>(
      discriminatorKey: 'type',
      schemas: {
        for (final type in SchemaShapeBorder.values)
          type.wireValue: _buildShapeBorderBranch(type: type),
      },
    );

AckSchema<ShapeBorderMix> _buildShapeBorderBranch({
  required SchemaShapeBorder type,
}) {
  switch (type) {
    case .roundedRectangle:
      return Ack.codec<Map<String, Object?>, ShapeBorderMix>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'borderRadius': borderRadiusCodec.optional(),
          'side': borderSideCodec.optional(),
        }),
        output: Ack.instance<ShapeBorderMix>(),
        decoder: (data) {
          final map = data;

          return RoundedRectangleBorderMix(
            borderRadius: map['borderRadius'] as BorderRadiusGeometryMix?,
            side: map['side'] as BorderSideMix?,
          );
        },
        encoder: (value) {
          final mix = value as RoundedRectangleBorderMix;

          return optionalJsonMap([
            ('type', type.wireValue),
            (
              'borderRadius',
              propMix<BorderRadiusGeometryMix>(mix.$borderRadius),
            ),
            ('side', propMix<BorderSideMix>(mix.$side)),
          ]);
        },
      );
    case .roundedSuperellipse:
      return Ack.codec<Map<String, Object?>, ShapeBorderMix>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'borderRadius': borderRadiusCodec.optional(),
          'side': borderSideCodec.optional(),
        }),
        output: Ack.instance<ShapeBorderMix>(),
        decoder: (data) {
          final map = data;

          return RoundedSuperellipseBorderMix(
            borderRadius: map['borderRadius'] as BorderRadiusGeometryMix?,
            side: map['side'] as BorderSideMix?,
          );
        },
        encoder: (value) {
          final mix = value as RoundedSuperellipseBorderMix;

          return optionalJsonMap([
            ('type', type.wireValue),
            (
              'borderRadius',
              propMix<BorderRadiusGeometryMix>(mix.$borderRadius),
            ),
            ('side', propMix<BorderSideMix>(mix.$side)),
          ]);
        },
      );
    case .beveledRectangle:
      return Ack.codec<Map<String, Object?>, ShapeBorderMix>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'borderRadius': borderRadiusCodec.optional(),
          'side': borderSideCodec.optional(),
        }),
        output: Ack.instance<ShapeBorderMix>(),
        decoder: (data) {
          final map = data;

          return BeveledRectangleBorderMix(
            borderRadius: map['borderRadius'] as BorderRadiusGeometryMix?,
            side: map['side'] as BorderSideMix?,
          );
        },
        encoder: (value) {
          final mix = value as BeveledRectangleBorderMix;

          return optionalJsonMap([
            ('type', type.wireValue),
            (
              'borderRadius',
              propMix<BorderRadiusGeometryMix>(mix.$borderRadius),
            ),
            ('side', propMix<BorderSideMix>(mix.$side)),
          ]);
        },
      );
    case .continuousRectangle:
      return Ack.codec<Map<String, Object?>, ShapeBorderMix>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'borderRadius': borderRadiusCodec.optional(),
          'side': borderSideCodec.optional(),
        }),
        output: Ack.instance<ShapeBorderMix>(),
        decoder: (data) {
          final map = data;

          return ContinuousRectangleBorderMix(
            borderRadius: map['borderRadius'] as BorderRadiusGeometryMix?,
            side: map['side'] as BorderSideMix?,
          );
        },
        encoder: (value) {
          final mix = value as ContinuousRectangleBorderMix;

          return optionalJsonMap([
            ('type', type.wireValue),
            (
              'borderRadius',
              propMix<BorderRadiusGeometryMix>(mix.$borderRadius),
            ),
            ('side', propMix<BorderSideMix>(mix.$side)),
          ]);
        },
      );
    case .circle:
      return Ack.codec<Map<String, Object?>, ShapeBorderMix>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'side': borderSideCodec.optional(),
          'eccentricity': Ack.number().optional(),
        }),
        output: Ack.instance<ShapeBorderMix>(),
        decoder: (data) {
          final map = data;

          return CircleBorderMix(
            side: map['side'] as BorderSideMix?,
            eccentricity: castDoubleOrNull(map['eccentricity']),
          );
        },
        encoder: (value) {
          final mix = value as CircleBorderMix;

          return optionalJsonMap([
            ('type', type.wireValue),
            ('side', propMix<BorderSideMix>(mix.$side)),
            ('eccentricity', propValue(mix.$eccentricity)),
          ]);
        },
      );
    case .star:
      return Ack.codec<Map<String, Object?>, ShapeBorderMix>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'side': borderSideCodec.optional(),
          'points': Ack.number().optional(),
          'innerRadiusRatio': Ack.number().optional(),
          'pointRounding': Ack.number().optional(),
          'valleyRounding': Ack.number().optional(),
          'rotation': Ack.number().optional(),
          'squash': Ack.number().optional(),
        }),
        output: Ack.instance<ShapeBorderMix>(),
        decoder: (data) {
          final map = data;

          return StarBorderMix(
            side: map['side'] as BorderSideMix?,
            points: castDoubleOrNull(map['points']),
            innerRadiusRatio: castDoubleOrNull(map['innerRadiusRatio']),
            pointRounding: castDoubleOrNull(map['pointRounding']),
            valleyRounding: castDoubleOrNull(map['valleyRounding']),
            rotation: castDoubleOrNull(map['rotation']),
            squash: castDoubleOrNull(map['squash']),
          );
        },
        encoder: (value) {
          final mix = value as StarBorderMix;

          return optionalJsonMap([
            ('type', type.wireValue),
            ('side', propMix<BorderSideMix>(mix.$side)),
            ('points', propValue(mix.$points)),
            ('innerRadiusRatio', propValue(mix.$innerRadiusRatio)),
            ('pointRounding', propValue(mix.$pointRounding)),
            ('valleyRounding', propValue(mix.$valleyRounding)),
            ('rotation', propValue(mix.$rotation)),
            ('squash', propValue(mix.$squash)),
          ]);
        },
      );
    case .linear:
      return Ack.codec<Map<String, Object?>, ShapeBorderMix>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'side': borderSideCodec.optional(),
          'start': linearBorderEdgeCodec.optional(),
          'end': linearBorderEdgeCodec.optional(),
          'top': linearBorderEdgeCodec.optional(),
          'bottom': linearBorderEdgeCodec.optional(),
        }),
        output: Ack.instance<ShapeBorderMix>(),
        decoder: (data) {
          final map = data;

          return LinearBorderMix(
            side: map['side'] as BorderSideMix?,
            start: map['start'] as LinearBorderEdgeMix?,
            end: map['end'] as LinearBorderEdgeMix?,
            top: map['top'] as LinearBorderEdgeMix?,
            bottom: map['bottom'] as LinearBorderEdgeMix?,
          );
        },
        encoder: (value) {
          final mix = value as LinearBorderMix;

          return optionalJsonMap([
            ('type', type.wireValue),
            ('side', propMix<BorderSideMix>(mix.$side)),
            ('start', propMix<LinearBorderEdgeMix>(mix.$start)),
            ('end', propMix<LinearBorderEdgeMix>(mix.$end)),
            ('top', propMix<LinearBorderEdgeMix>(mix.$top)),
            ('bottom', propMix<LinearBorderEdgeMix>(mix.$bottom)),
          ]);
        },
      );
    case .stadium:
      return Ack.codec<Map<String, Object?>, ShapeBorderMix>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'side': borderSideCodec.optional(),
        }),
        output: Ack.instance<ShapeBorderMix>(),
        decoder: (data) {
          final map = data;

          return StadiumBorderMix(side: map['side'] as BorderSideMix?);
        },
        encoder: (value) {
          final mix = value as StadiumBorderMix;

          return optionalJsonMap([
            ('type', type.wireValue),
            ('side', propMix<BorderSideMix>(mix.$side)),
          ]);
        },
      );
  }
}
