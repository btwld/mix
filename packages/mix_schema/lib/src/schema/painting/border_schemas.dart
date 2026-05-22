import 'package:ack/ack.dart';
import 'package:flutter/painting.dart';
import 'package:mix/mix.dart';

import '../../core/branch_codec.dart';
import '../../core/numeric_codecs.dart';
import '../../core/prop_encode.dart';
import '../../core/schema_wire_types.dart';
import '../shared/shared_schemas.dart';

final borderSideCodec = Ack.codec<JsonMap, JsonMap, BorderSideMix>(
  input: Ack.object({
    'color': colorCodec.optional(),
    'width': doubleFromNum().optional(),
    'style': borderStyleSchema.optional(),
    'strokeAlign': doubleFromNum().optional(),
  }),
  output: Ack.instance<BorderSideMix>(),
  decode: (data) => BorderSideMix(
    color: data['color'] as Color?,
    strokeAlign: data['strokeAlign'] as double?,
    style: data['style'] as BorderStyle?,
    width: data['width'] as double?,
  ),
  encode: (value) => optionalJsonMap([
    ('color', directPropValue(value.$color)),
    ('width', directPropValue(value.$width)),
    ('style', directPropValue(value.$style)),
    ('strokeAlign', directPropValue(value.$strokeAlign)),
  ]),
);

final boxShadowCodec = Ack.codec<JsonMap, JsonMap, BoxShadowMix>(
  input: Ack.object({
    'color': colorCodec.optional(),
    'offset': offsetCodec.optional(),
    'blurRadius': doubleFromNum().optional(),
    'spreadRadius': doubleFromNum().optional(),
  }),
  output: Ack.instance<BoxShadowMix>(),
  decode: (data) => BoxShadowMix(
    color: data['color'] as Color?,
    offset: data['offset'] as Offset?,
    blurRadius: data['blurRadius'] as double?,
    spreadRadius: data['spreadRadius'] as double?,
  ),
  encode: (value) => optionalJsonMap([
    ('color', directPropValue(value.$color)),
    ('offset', directPropValue(value.$offset)),
    ('blurRadius', directPropValue(value.$blurRadius)),
    ('spreadRadius', directPropValue(value.$spreadRadius)),
  ]),
);

final boxBorderCodec = Ack.discriminated<BoxBorderMix>(
  discriminatorKey: 'type',
  schemas: {
    for (final type in SchemaBorder.values)
      type.wireValue: _buildBoxBorderBranch(type),
  },
);

final borderRadiusCodec = Ack.discriminated<BorderRadiusGeometryMix>(
  discriminatorKey: 'type',
  schemas: {
    for (final type in SchemaBorderRadius.values)
      type.wireValue: _buildBorderRadiusBranch(type),
  },
);

AckSchema<JsonMap, BoxBorderMix> _buildBoxBorderBranch(SchemaBorder type) {
  switch (type) {
    case .border:
      return discriminatedBranchCodec<BoxBorderMix, BorderMix>(
        type: type.wireValue,
        input: Ack.object({
          'top': borderSideCodec.optional(),
          'bottom': borderSideCodec.optional(),
          'left': borderSideCodec.optional(),
          'right': borderSideCodec.optional(),
        }),
        decode: (data) => BorderMix(
          top: data['top'] as BorderSideMix?,
          bottom: data['bottom'] as BorderSideMix?,
          left: data['left'] as BorderSideMix?,
          right: data['right'] as BorderSideMix?,
        ),
        encode: (mix) => optionalJsonMap([
          ('top', directPropMix<BorderSideMix>(mix.$top)),
          ('bottom', directPropMix<BorderSideMix>(mix.$bottom)),
          ('left', directPropMix<BorderSideMix>(mix.$left)),
          ('right', directPropMix<BorderSideMix>(mix.$right)),
        ]),
      );
    case .borderDirectional:
      return discriminatedBranchCodec<BoxBorderMix, BorderDirectionalMix>(
        type: type.wireValue,
        input: Ack.object({
          'top': borderSideCodec.optional(),
          'bottom': borderSideCodec.optional(),
          'start': borderSideCodec.optional(),
          'end': borderSideCodec.optional(),
        }),
        decode: (data) => BorderDirectionalMix(
          top: data['top'] as BorderSideMix?,
          bottom: data['bottom'] as BorderSideMix?,
          start: data['start'] as BorderSideMix?,
          end: data['end'] as BorderSideMix?,
        ),
        encode: (mix) => optionalJsonMap([
          ('top', directPropMix<BorderSideMix>(mix.$top)),
          ('bottom', directPropMix<BorderSideMix>(mix.$bottom)),
          ('start', directPropMix<BorderSideMix>(mix.$start)),
          ('end', directPropMix<BorderSideMix>(mix.$end)),
        ]),
      );
  }
}

AckSchema<JsonMap, BorderRadiusGeometryMix> _buildBorderRadiusBranch(
  SchemaBorderRadius type,
) {
  switch (type) {
    case .borderRadius:
      return discriminatedBranchCodec<BorderRadiusGeometryMix, BorderRadiusMix>(
        type: type.wireValue,
        input: Ack.object({
          'topLeft': radiusCodec.optional(),
          'topRight': radiusCodec.optional(),
          'bottomLeft': radiusCodec.optional(),
          'bottomRight': radiusCodec.optional(),
        }),
        decode: (data) => BorderRadiusMix(
          topLeft: data['topLeft'] as Radius?,
          topRight: data['topRight'] as Radius?,
          bottomLeft: data['bottomLeft'] as Radius?,
          bottomRight: data['bottomRight'] as Radius?,
        ),
        encode: (mix) => optionalJsonMap([
          ('topLeft', directPropValue(mix.$topLeft)),
          ('topRight', directPropValue(mix.$topRight)),
          ('bottomLeft', directPropValue(mix.$bottomLeft)),
          ('bottomRight', directPropValue(mix.$bottomRight)),
        ]),
      );
    case .borderRadiusDirectional:
      return discriminatedBranchCodec<
        BorderRadiusGeometryMix,
        BorderRadiusDirectionalMix
      >(
        type: type.wireValue,
        input: Ack.object({
          'topStart': radiusCodec.optional(),
          'topEnd': radiusCodec.optional(),
          'bottomStart': radiusCodec.optional(),
          'bottomEnd': radiusCodec.optional(),
        }),
        decode: (data) => BorderRadiusDirectionalMix(
          topStart: data['topStart'] as Radius?,
          topEnd: data['topEnd'] as Radius?,
          bottomStart: data['bottomStart'] as Radius?,
          bottomEnd: data['bottomEnd'] as Radius?,
        ),
        encode: (mix) => optionalJsonMap([
          ('topStart', directPropValue(mix.$topStart)),
          ('topEnd', directPropValue(mix.$topEnd)),
          ('bottomStart', directPropValue(mix.$bottomStart)),
          ('bottomEnd', directPropValue(mix.$bottomEnd)),
        ]),
      );
  }
}
