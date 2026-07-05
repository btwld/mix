import 'package:flutter/widgets.dart';

String encodeColorWire(Color value) {
  final argb = value.toARGB32();
  final alpha = (argb >> 24) & 0xFF;
  final red = (argb >> 16) & 0xFF;
  final green = (argb >> 8) & 0xFF;
  final blue = argb & 0xFF;

  if (alpha == 0xFF) {
    return '#${_hex(red)}${_hex(green)}${_hex(blue)}';
  }

  return '#${_hex(alpha)}${_hex(red)}${_hex(green)}${_hex(blue)}';
}

Object encodeAlignmentWire(Alignment value) {
  for (final entry in namedAlignments.entries) {
    if (entry.value == value) return entry.key;
  }

  return {'x': value.x, 'y': value.y};
}

Object encodeEdgeInsetsWire({
  required double? left,
  required double? top,
  required double? right,
  required double? bottom,
}) {
  if (left != null && left == top && top == right && right == bottom) {
    return left;
  }

  final payload = <String, double>{};
  if (left != null) payload['left'] = left;
  if (top != null) payload['top'] = top;
  if (right != null) payload['right'] = right;
  if (bottom != null) payload['bottom'] = bottom;
  return payload;
}

const namedAlignments = <String, Alignment>{
  'topLeft': Alignment.topLeft,
  'topCenter': Alignment.topCenter,
  'topRight': Alignment.topRight,
  'centerLeft': Alignment.centerLeft,
  'center': Alignment.center,
  'centerRight': Alignment.centerRight,
  'bottomLeft': Alignment.bottomLeft,
  'bottomCenter': Alignment.bottomCenter,
  'bottomRight': Alignment.bottomRight,
};

String _hex(int value) => value.toRadixString(16).padLeft(2, '0').toUpperCase();
