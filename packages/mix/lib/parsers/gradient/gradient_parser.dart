import 'package:flutter/material.dart';

import '../parsers.dart';
import 'base_gradient_parser.dart';

/// Unified parser for Gradient types with discriminated type handling
class GradientParser extends BaseGradientParser<Gradient> {
  static const instance = GradientParser();

  const GradientParser();

  @override
  Object? encode(Gradient? value) {
    if (value == null) return null;

    // Delegate to LinearGradientParser if it's a LinearGradient
    if (value is LinearGradient) {
      return MixParsers.get<LinearGradient>()?.encode(value);
    }

    // Delegate to RadialGradientParser if it's a RadialGradient
    if (value is RadialGradient) {
      return MixParsers.get<RadialGradient>()?.encode(value);
    }

    // Delegate to SweepGradientParser if it's a SweepGradient
    if (value is SweepGradient) {
      return MixParsers.get<SweepGradient>()?.encode(value);
    }

    // Fallback for unknown gradient types
    return {'type': 'gradient', ...encodeCommon(value)};
  }

  @override
  Gradient? decode(Object? json) {
    if (json == null) return null;
    if (json is! Map<String, Object?>) return null;

    final map = json;
    final type = map['type'] as String?;

    switch (type) {
      case 'linear':
        // Delegate to LinearGradientParser
        return MixParsers.get<LinearGradient>()?.decode(json);

      case 'radial':
        // Delegate to RadialGradientParser
        return MixParsers.get<RadialGradient>()?.decode(json);

      case 'sweep':
        // Delegate to SweepGradientParser
        return MixParsers.get<SweepGradient>()?.decode(json);

      case 'gradient':
      default:
        // For basic gradient, create a LinearGradient as fallback
        try {
          final colors = decodeColors(map);
          final stops = decodeStops(map);

          return LinearGradient(colors: colors, stops: stops);
        } catch (e) {
          return null;
        }
    }
  }
}
