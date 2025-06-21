import 'package:flutter/material.dart';

import '../parsers.dart';
import 'base_decoration_parser.dart';

/// Unified parser for Decoration types with discriminated type handling
class DecorationParser extends BaseDecorationParser<Decoration> {
  const DecorationParser();

  @override
  Object? encode(Decoration? value) {
    if (value == null) return null;

    // Delegate to BoxDecorationParser if it's a BoxDecoration
    if (value is BoxDecoration) {
      return MixParsers.encode(value);
    }

    // Delegate to ShapeDecorationParser if it's a ShapeDecoration
    if (value is ShapeDecoration) {
      return MixParsers.encode(value);
    }

    // Fallback for unknown decoration types
    return {'type': 'decoration', ...encodeCommon(value)};
  }

  @override
  Decoration? decode(Object? json) {
    if (json == null) return null;
    if (json is! Map<String, Object?>) return null;

    final map = json;
    final type = map['type'] as String?;

    switch (type) {
      case 'box_decoration':
        // Delegate to BoxDecorationParser
        return MixParsers.decode<BoxDecoration>(json);

      case 'shape_decoration':
        // Delegate to ShapeDecorationParser
        return MixParsers.decode<ShapeDecoration>(json);

      case 'decoration':
      default:
        // For basic decoration, create a BoxDecoration as fallback
        return BoxDecoration(
          color: decodeColor(map),
          image: decodeImage(map),
          boxShadow: decodeShadows(map),
          gradient: decodeGradient(map),
        );
    }
  }
}
