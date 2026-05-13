import 'package:flutter/widgets.dart';

import '../core/codec_typed_encode.dart';
import '../core/json_map.dart';
import '../schema/shared/color_schema.dart';
import '../schema/shared/primitive_schemas.dart';

String payloadColor(Color value) => colorCodec.encodeTyped(value);

JsonMap payloadAlignment(AlignmentGeometry value) =>
    alignmentCodec.encodeTyped(value);

JsonMap payloadOffset(Offset value) => offsetCodec.encodeTyped(value);

JsonMap payloadRadius(Radius value) => radiusCodec.encodeTyped(value);
