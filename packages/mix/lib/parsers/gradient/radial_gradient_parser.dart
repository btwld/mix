import 'package:flutter/material.dart';

import '../parsers.dart';
import 'base_gradient_parser.dart';

/// Parser for RadialGradient values extending BaseGradientParser
class RadialGradientParser extends BaseGradientParser<RadialGradient> {
  const RadialGradientParser();

  @override
  Object? encode(RadialGradient? value) {
    if (value == null) return null;

    return {
      'type': 'radial',
      'center': MixParsers.get<AlignmentGeometry>()?.encode(value.center),
      'radius': value.radius,
      ...encodeCommon(value),
    };
  }

  @override
  RadialGradient? decode(Object? json) {
    if (json is! Map<String, Object?>) return null;

    final map = json;

    try {
      final colors = decodeColors(map);
      final stops = decodeStops(map);

      return RadialGradient(
        center: decodeAlignment(map, 'center', Alignment.center),
        radius: decodeDouble(map, 'radius', 0.5),
        colors: colors,
        stops: stops,
      );
    } catch (e) {
      return null;
    }
  }
}
