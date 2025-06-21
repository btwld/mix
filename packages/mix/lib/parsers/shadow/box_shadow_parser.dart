import 'package:flutter/material.dart';

import 'base_shadow_parser.dart';

/// Parser for BoxShadow values extending BaseShadowParser
class BoxShadowParser extends BaseShadowParser<BoxShadow> {
  const BoxShadowParser();

  @override
  Object? encode(BoxShadow? value) {
    if (value == null) return null;

    return {
      'type': 'box_shadow',
      'spreadRadius': value.spreadRadius,
      ...encodeCommon(value),
    };
  }

  @override
  BoxShadow? decode(Object? json) {
    if (json is! Map<String, Object?>) return null;

    final map = json;

    return BoxShadow(
      color: decodeColor(map),
      offset: decodeOffset(map),
      blurRadius: decodeBlurRadius(map),
      spreadRadius: (map['spreadRadius'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
