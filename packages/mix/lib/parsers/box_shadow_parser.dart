import 'package:flutter/material.dart';

import 'parsers.dart';

/// Parser for BoxShadow values
class BoxShadowParser extends Parser<BoxShadow> {
  static const instance = BoxShadowParser();

  const BoxShadowParser();

  @override
  Object? encode(BoxShadow? value) {
    if (value == null) return null;

    // Simplified format for common shadows
    if (value.spreadRadius == 0.0 && value.color == const Color(0xFF000000)) {
      // Just offset and blur
      return {
        'offset': MixParsers.get<Offset>()?.encode(value.offset),
        'blur': value.blurRadius,
      };
    }

    // Full format
    return {
      'color': MixParsers.get<Color>()?.encode(value.color),
      'offset': MixParsers.get<Offset>()?.encode(value.offset),
      'blurRadius': value.blurRadius,
      'spreadRadius': value.spreadRadius,
    };
  }

  @override
  BoxShadow? decode(Object? json) {
    if (json == null) return null;

    if (json is! Map<String, Object?>) return null;

    final map = json;

    return BoxShadow(
      color: MixParsers.get<Color>()?.decode(map['color']) ??
          const Color(0xFF000000),
      offset: MixParsers.get<Offset>()?.decode(map['offset']) ?? Offset.zero,
      blurRadius: (map['blurRadius'] as num?)?.toDouble() ??
          (map['blur'] as num?)?.toDouble() ??
          0.0,
      spreadRadius: (map['spreadRadius'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
