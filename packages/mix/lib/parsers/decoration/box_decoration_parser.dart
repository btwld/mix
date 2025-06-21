import 'package:flutter/material.dart';

import '../parsers.dart';
import 'base_decoration_parser.dart';

/// Parser for BoxDecoration values extending BaseDecorationParser
class BoxDecorationParser extends BaseDecorationParser<BoxDecoration> {
  static const instance = BoxDecorationParser();

  const BoxDecorationParser();

  @override
  Object? encode(BoxDecoration? value) {
    if (value == null) return null;

    return {
      'type': 'box_decoration',
      'border': value.border is Border
          ? MixParsers.get<Border>()?.encode(value.border as Border)
          : null,
      'borderRadius': value.borderRadius is BorderRadius
          ? MixParsers.get<BorderRadius>()
              ?.encode(value.borderRadius as BorderRadius)
          : null,
      'shape': value.shape != BoxShape.rectangle ? value.shape.name : null,
      ...encodeCommon(value),
    }..removeWhere((key, value) => value == null);
  }

  @override
  BoxDecoration? decode(Object? json) {
    if (json == null) return null;

    // Support simple color value
    if (json is int || json is String) {
      final color = MixParsers.get<Color>()?.decode(json);

      return color != null ? BoxDecoration(color: color) : null;
    }

    if (json is! Map<String, Object?>) return null;

    final map = json;

    // Parse shape
    BoxShape shape = BoxShape.rectangle;
    final shapeString = map['shape'] as String?;
    if (shapeString != null) {
      shape = BoxShape.values.firstWhere(
        (e) => e.name == shapeString,
        orElse: () => BoxShape.rectangle,
      );
    }

    return BoxDecoration(
      color: decodeColor(map),
      image: decodeImage(map),
      border: MixParsers.get<Border>()?.decode(map['border']),
      borderRadius: shape == BoxShape.rectangle
          ? MixParsers.get<BorderRadius>()?.decode(map['borderRadius'])
          : null,
      boxShadow: decodeShadows(map),
      gradient: decodeGradient(map),
      shape: shape,
    );
  }
}
