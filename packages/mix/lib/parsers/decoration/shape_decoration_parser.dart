import 'package:flutter/material.dart';

import '../parsers.dart';
import 'base_decoration_parser.dart';

/// Parser for ShapeDecoration values extending BaseDecorationParser
class ShapeDecorationParser extends BaseDecorationParser<ShapeDecoration> {
  const ShapeDecorationParser();

  @override
  Object? encode(ShapeDecoration? value) {
    if (value == null) return null;

    return {
      'type': 'shape_decoration',
      'shape': MixParsers.get<ShapeBorder>()?.encode(value.shape),
      ...encodeCommon(value),
    };
  }

  @override
  ShapeDecoration? decode(Object? json) {
    if (json is! Map<String, Object?>) return null;

    final map = json;

    final shape = MixParsers.get<ShapeBorder>()?.decode(map['shape']);
    if (shape == null) return null; // ShapeDecoration requires a shape

    return ShapeDecoration(
      color: decodeColor(map),
      image: decodeImage(map),
      gradient: decodeGradient(map),
      shadows: decodeShadows(map),
      shape: shape,
    );
  }
}
