import 'package:flutter/widgets.dart';

import '../core/json_map.dart';

String payloadColor(Color color) {
  final value = color.toARGB32();
  final red = (value >> 16) & 0xFF;
  final green = (value >> 8) & 0xFF;
  final blue = value & 0xFF;
  final alpha = (value >> 24) & 0xFF;

  String hexByte(int byte) => byte.toRadixString(16).padLeft(2, '0');

  return '#${hexByte(red)}${hexByte(green)}${hexByte(blue)}${hexByte(alpha)}'
      .toUpperCase();
}

JsonMap payloadAlignment(
  AlignmentGeometry alignment, {
  TextDirection textDirection = .ltr,
}) {
  final resolved = alignment.resolve(textDirection);

  return {'x': resolved.x, 'y': resolved.y};
}

JsonMap payloadOffset(Offset offset) => {'dx': offset.dx, 'dy': offset.dy};

JsonMap payloadRadius(Radius radius) {
  return {'x': radius.x, if (radius.y != radius.x) 'y': radius.y};
}
