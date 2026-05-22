import 'package:ack/ack.dart' show JsonMap;
import 'package:flutter/widgets.dart';

import '../schema/shared/color_schema.dart';
import '../schema/shared/primitive_schemas.dart';

String payloadColor(Color value) => colorCodec.encode(value)!;

JsonMap payloadAlignment(AlignmentGeometry value) =>
    alignmentCodec.encode(value)!;

JsonMap payloadOffset(Offset value) => offsetCodec.encode(value)!;

JsonMap payloadRadius(Radius value) => radiusCodec.encode(value)!;
