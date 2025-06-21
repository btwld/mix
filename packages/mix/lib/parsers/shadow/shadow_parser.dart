import 'package:flutter/material.dart';

import '../parsers.dart';
import 'base_shadow_parser.dart';

/// Unified parser for Shadow types with discriminated type handling
class ShadowParser extends BaseShadowParser<Shadow> {
  const ShadowParser();

  @override
  Object? encode(Shadow? value) {
    if (value == null) return null;

    // Delegate to BoxShadowParser if it's a BoxShadow
    if (value is BoxShadow) {
      return MixParsers.get<BoxShadow>()?.encode(value);
    }

    // Handle basic Shadow
    return {'type': 'shadow', ...encodeCommon(value)};
  }

  @override
  Shadow? decode(Object? json) {
    if (json == null) return null;
    if (json is! Map<String, Object?>) return null;

    final map = json;
    final type = map['type'] as String?;

    switch (type) {
      case 'box_shadow':
        // Delegate to BoxShadowParser
        return MixParsers.get<BoxShadow>()?.decode(json);

      case 'shadow':
      default:
        return Shadow(
          color: decodeColor(map),
          offset: decodeOffset(map),
          blurRadius: decodeBlurRadius(map),
        );
    }
  }
}
