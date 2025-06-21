import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../parsers.dart';
import 'base_gradient_parser.dart';

/// Parser for SweepGradient values extending BaseGradientParser
class SweepGradientParser extends BaseGradientParser<SweepGradient> {
  const SweepGradientParser();

  @override
  Object? encode(SweepGradient? value) {
    if (value == null) return null;

    return {
      'type': 'sweep',
      'center': MixParsers.encode(value.center),
      'startAngle': value.startAngle,
      'endAngle': value.endAngle,
      ...encodeCommon(value),
    };
  }

  @override
  SweepGradient? decode(Object? json) {
    if (json is! Map<String, Object?>) return null;

    final map = json;

    try {
      final colors = decodeColors(map);
      final stops = decodeStops(map);

      return SweepGradient(
        center: decodeAlignment(map, 'center', Alignment.center),
        startAngle: decodeDouble(map, 'startAngle', 0.0),
        endAngle: decodeDouble(map, 'endAngle', 2 * math.pi),
        colors: colors,
        stops: stops,
      );
    } catch (e) {
      return null;
    }
  }
}
