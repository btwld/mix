library;

import 'package:flutter/widgets.dart';

import 'src/schema/primitive_wire.dart';

enum SchemaStyler {
  box('box'),
  text('text'),
  flex('flex'),
  stack('stack'),
  icon('icon'),
  image('image'),
  flexBox('flex_box'),
  stackBox('stack_box');

  const SchemaStyler(this.wireValue);

  final String wireValue;
}

String payloadColor(Color value) {
  return encodeColorWire(value);
}

Object payloadAlignment(Alignment value) {
  return encodeAlignmentWire(value);
}

Object payloadEdgeInsets({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  if (all != null) return all;

  return encodeEdgeInsetsWire(
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}
