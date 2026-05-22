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
    ('color', propValue(value.$color)),
    ('width', propValue(value.$width)),
    ('style', propValue(value.$style)),
    ('strokeAlign', propValue(value.$strokeAlign)),
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
    ('color', propValue(value.$color)),
    ('offset', propValue(value.$offset)),
    ('blurRadius', propValue(value.$blurRadius)),
    ('spreadRadius', propValue(value.$spreadRadius)),
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
          ('top', propMix<BorderSideMix>(mix.$top)),
          ('bottom', propMix<BorderSideMix>(mix.$bottom)),
          ('left', propMix<BorderSideMix>(mix.$left)),
          ('right', propMix<BorderSideMix>(mix.$right)),
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
          ('top', propMix<BorderSideMix>(mix.$top)),
          ('bottom', propMix<BorderSideMix>(mix.$bottom)),
          ('start', propMix<BorderSideMix>(mix.$start)),
          ('end', propMix<BorderSideMix>(mix.$end)),
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
          ('topLeft', propValue(mix.$topLeft)),
          ('topRight', propValue(mix.$topRight)),
          ('bottomLeft', propValue(mix.$bottomLeft)),
          ('bottomRight', propValue(mix.$bottomRight)),
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
          ('topStart', propValue(mix.$topStart)),
          ('topEnd', propValue(mix.$topEnd)),
          ('bottomStart', propValue(mix.$bottomStart)),
          ('bottomEnd', propValue(mix.$bottomEnd)),
        ]),
      );
  }
}
