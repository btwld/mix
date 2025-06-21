import 'package:flutter/material.dart';

import '../parsers.dart';
import 'base_gradient_parser.dart';

/// Parser for LinearGradient values extending BaseGradientParser
class LinearGradientParser extends BaseGradientParser<LinearGradient> {
  const LinearGradientParser();

  @override
  Object? encode(LinearGradient? value) {
    if (value == null) return null;

    return {
      'type': 'linear',
      'begin': MixParsers.encode(value.begin),
      'end': MixParsers.encode(value.end),
      ...encodeCommon(value),
    };
  }

  @override
  LinearGradient? decode(Object? json) {
    if (json is! Map<String, Object?>) return null;

    final map = json;

    try {
      final colors = decodeColors(map);
      final stops = decodeStops(map);

      return LinearGradient(
        begin: decodeAlignment(map, 'begin', Alignment.centerLeft),
        end: decodeAlignment(map, 'end', Alignment.centerRight),
        colors: colors,
        stops: stops,
      );
    } catch (e) {
      return null;
    }
  }
}
