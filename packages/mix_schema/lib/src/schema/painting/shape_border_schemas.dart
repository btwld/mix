import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/branch_codec.dart';
import '../../core/numeric_codecs.dart';
import '../../core/prop_encode.dart';
import '../../core/schema_wire_types.dart';
import 'border_schemas.dart';

final linearBorderEdgeCodec = Ack.codec<JsonMap, JsonMap, LinearBorderEdgeMix>(
  input: Ack.object({
    'size': doubleFromNum().optional(),
    'alignment': doubleFromNum().optional(),
  }),
  output: Ack.instance<LinearBorderEdgeMix>(),
  decode: (data) => LinearBorderEdgeMix(
    size: data['size'] as double?,
    alignment: data['alignment'] as double?,
  ),
  encode: (value) => optionalJsonMap([
    ('size', directPropValue(value.$size)),
    ('alignment', directPropValue(value.$alignment)),
  ]),
);

final shapeBorderCodec = Ack.discriminated<ShapeBorderMix>(
  discriminatorKey: 'type',
  schemas: {
    for (final type in SchemaShapeBorder.values)
      type.wireValue: _buildShapeBorderBranch(type: type),
  },
);

AckSchema<JsonMap, ShapeBorderMix> _buildShapeBorderBranch({
  required SchemaShapeBorder type,
}) {
  switch (type) {
    case .roundedRectangle:
      return discriminatedBranchCodec<
        ShapeBorderMix,
        RoundedRectangleBorderMix
      >(
        type: type.wireValue,
        input: Ack.object({
          'borderRadius': borderRadiusCodec.optional(),
          'side': borderSideCodec.optional(),
        }),
        decode: (data) => RoundedRectangleBorderMix(
          borderRadius: data['borderRadius'] as BorderRadiusGeometryMix?,
          side: data['side'] as BorderSideMix?,
        ),
        encode: (mix) => optionalJsonMap([
          ('borderRadius', directPropMix<BorderRadiusGeometryMix>(mix.$borderRadius)),
          ('side', directPropMix<BorderSideMix>(mix.$side)),
        ]),
      );
    case .roundedSuperellipse:
      return discriminatedBranchCodec<
        ShapeBorderMix,
        RoundedSuperellipseBorderMix
      >(
        type: type.wireValue,
        input: Ack.object({
          'borderRadius': borderRadiusCodec.optional(),
          'side': borderSideCodec.optional(),
        }),
        decode: (data) => RoundedSuperellipseBorderMix(
          borderRadius: data['borderRadius'] as BorderRadiusGeometryMix?,
          side: data['side'] as BorderSideMix?,
        ),
        encode: (mix) => optionalJsonMap([
          ('borderRadius', directPropMix<BorderRadiusGeometryMix>(mix.$borderRadius)),
          ('side', directPropMix<BorderSideMix>(mix.$side)),
        ]),
      );
    case .beveledRectangle:
      return discriminatedBranchCodec<
        ShapeBorderMix,
        BeveledRectangleBorderMix
      >(
        type: type.wireValue,
        input: Ack.object({
          'borderRadius': borderRadiusCodec.optional(),
          'side': borderSideCodec.optional(),
        }),
        decode: (data) => BeveledRectangleBorderMix(
          borderRadius: data['borderRadius'] as BorderRadiusGeometryMix?,
          side: data['side'] as BorderSideMix?,
        ),
        encode: (mix) => optionalJsonMap([
          ('borderRadius', directPropMix<BorderRadiusGeometryMix>(mix.$borderRadius)),
          ('side', directPropMix<BorderSideMix>(mix.$side)),
        ]),
      );
    case .continuousRectangle:
      return discriminatedBranchCodec<
        ShapeBorderMix,
        ContinuousRectangleBorderMix
      >(
        type: type.wireValue,
        input: Ack.object({
          'borderRadius': borderRadiusCodec.optional(),
          'side': borderSideCodec.optional(),
        }),
        decode: (data) => ContinuousRectangleBorderMix(
          borderRadius: data['borderRadius'] as BorderRadiusGeometryMix?,
          side: data['side'] as BorderSideMix?,
        ),
        encode: (mix) => optionalJsonMap([
          ('borderRadius', directPropMix<BorderRadiusGeometryMix>(mix.$borderRadius)),
          ('side', directPropMix<BorderSideMix>(mix.$side)),
        ]),
      );
    case .circle:
      return discriminatedBranchCodec<ShapeBorderMix, CircleBorderMix>(
        type: type.wireValue,
        input: Ack.object({
          'side': borderSideCodec.optional(),
          'eccentricity': doubleFromNum().optional(),
        }),
        decode: (data) => CircleBorderMix(
          side: data['side'] as BorderSideMix?,
          eccentricity: data['eccentricity'] as double?,
        ),
        encode: (mix) => optionalJsonMap([
          ('side', directPropMix<BorderSideMix>(mix.$side)),
          ('eccentricity', directPropValue(mix.$eccentricity)),
        ]),
      );
    case .star:
      return discriminatedBranchCodec<ShapeBorderMix, StarBorderMix>(
        type: type.wireValue,
        input: Ack.object({
          'side': borderSideCodec.optional(),
          'points': doubleFromNum().optional(),
          'innerRadiusRatio': doubleFromNum().optional(),
          'pointRounding': doubleFromNum().optional(),
          'valleyRounding': doubleFromNum().optional(),
          'rotation': doubleFromNum().optional(),
          'squash': doubleFromNum().optional(),
        }),
        decode: (data) => StarBorderMix(
          side: data['side'] as BorderSideMix?,
          points: data['points'] as double?,
          innerRadiusRatio: data['innerRadiusRatio'] as double?,
          pointRounding: data['pointRounding'] as double?,
          valleyRounding: data['valleyRounding'] as double?,
          rotation: data['rotation'] as double?,
          squash: data['squash'] as double?,
        ),
        encode: (mix) => optionalJsonMap([
          ('side', directPropMix<BorderSideMix>(mix.$side)),
          ('points', directPropValue(mix.$points)),
          ('innerRadiusRatio', directPropValue(mix.$innerRadiusRatio)),
          ('pointRounding', directPropValue(mix.$pointRounding)),
          ('valleyRounding', directPropValue(mix.$valleyRounding)),
          ('rotation', directPropValue(mix.$rotation)),
          ('squash', directPropValue(mix.$squash)),
        ]),
      );
    case .linear:
      return discriminatedBranchCodec<ShapeBorderMix, LinearBorderMix>(
        type: type.wireValue,
        input: Ack.object({
          'side': borderSideCodec.optional(),
          'start': linearBorderEdgeCodec.optional(),
          'end': linearBorderEdgeCodec.optional(),
          'top': linearBorderEdgeCodec.optional(),
          'bottom': linearBorderEdgeCodec.optional(),
        }),
        decode: (data) => LinearBorderMix(
          side: data['side'] as BorderSideMix?,
          start: data['start'] as LinearBorderEdgeMix?,
          end: data['end'] as LinearBorderEdgeMix?,
          top: data['top'] as LinearBorderEdgeMix?,
          bottom: data['bottom'] as LinearBorderEdgeMix?,
        ),
        encode: (mix) => optionalJsonMap([
          ('side', directPropMix<BorderSideMix>(mix.$side)),
          ('start', directPropMix<LinearBorderEdgeMix>(mix.$start)),
          ('end', directPropMix<LinearBorderEdgeMix>(mix.$end)),
          ('top', directPropMix<LinearBorderEdgeMix>(mix.$top)),
          ('bottom', directPropMix<LinearBorderEdgeMix>(mix.$bottom)),
        ]),
      );
    case .stadium:
      return discriminatedBranchCodec<ShapeBorderMix, StadiumBorderMix>(
        type: type.wireValue,
        input: Ack.object({'side': borderSideCodec.optional()}),
        decode: (data) =>
            StadiumBorderMix(side: data['side'] as BorderSideMix?),
        encode: (mix) =>
            optionalJsonMap([('side', directPropMix<BorderSideMix>(mix.$side))]),
      );
  }
}
