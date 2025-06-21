import 'package:flutter/material.dart';

import 'parsers.dart';

/// Simplified Gradient parser following KISS principle
class GradientParser extends Parser<Gradient> {
  static const instance = GradientParser();

  const GradientParser();

  @override
  Object? encode(Gradient? value) {
    if (value == null) return null;

    if (value is LinearGradient) {
      return {
        'type': 'linear',
        'colors': value.colors
            .map((c) => MixParsers.get<Color>()?.encode(c))
            .toList(),
        'stops': value.stops,
        'begin': MixParsers.get<AlignmentGeometry>()?.encode(value.begin),
        'end': MixParsers.get<AlignmentGeometry>()?.encode(value.end),
      };
    }

    if (value is RadialGradient) {
      return {
        'type': 'radial',
        'colors': value.colors
            .map((c) => MixParsers.get<Color>()?.encode(c))
            .toList(),
        'stops': value.stops,
        'center': MixParsers.get<AlignmentGeometry>()?.encode(value.center),
        'radius': value.radius,
      };
    }

    if (value is SweepGradient) {
      return {
        'type': 'sweep',
        'colors': value.colors
            .map((c) => MixParsers.get<Color>()?.encode(c))
            .toList(),
        'stops': value.stops,
        'center': MixParsers.get<AlignmentGeometry>()?.encode(value.center),
        'startAngle': value.startAngle,
        'endAngle': value.endAngle,
      };
    }

    throw ArgumentError('Unsupported Gradient type: ${value.runtimeType}');
  }

  @override
  Gradient? decode(Object? json) {
    if (json == null) return null;

    if (json is! Map<String, Object?>) return null;

    final map = json;
    final type = map['type'] as String?;

    // Parse colors
    final colors = map.getListOf('colors', MixParsers.get<Color>()?.decode);

    if (colors.isEmpty) return null;

    // Parse stops
    final stops =
        (map['stops'] as List?)?.map((s) => (s as num).toDouble()).toList();

    switch (type) {
      case 'linear':
        return LinearGradient(
          begin: MixParsers.get<AlignmentGeometry>()?.decode(map['begin'])
                  as Alignment? ??
              Alignment.centerLeft,
          end: MixParsers.get<AlignmentGeometry>()?.decode(map['end'])
                  as Alignment? ??
              Alignment.centerRight,
          colors: colors,
          stops: stops,
        );

      case 'radial':
        return RadialGradient(
          center: MixParsers.get<AlignmentGeometry>()?.decode(map['center'])
                  as Alignment? ??
              Alignment.center,
          radius: (map['radius'] as num?)?.toDouble() ?? 0.5,
          colors: colors,
          stops: stops,
        );

      case 'sweep':
        return SweepGradient(
          center: MixParsers.get<AlignmentGeometry>()?.decode(map['center'])
                  as Alignment? ??
              Alignment.center,
          startAngle: (map['startAngle'] as num?)?.toDouble() ?? 0.0,
          endAngle:
              (map['endAngle'] as num?)?.toDouble() ?? 6.283185307179586, // 2π
          colors: colors,
          stops: stops,
        );

      default:
        return null;
    }
  }
}
