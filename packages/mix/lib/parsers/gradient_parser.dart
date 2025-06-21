import 'package:flutter/material.dart';

import 'base/parser_base.dart';
import 'alignment_parser.dart';
import 'color_parser.dart';

/// Simplified Gradient parser following KISS principle
class GradientParser implements Parser<Gradient> {
  static const instance = GradientParser();

  const GradientParser();

  /// Safe parsing with error result
  ParseResult<Gradient> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid Gradient format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(Gradient? value) {
    if (value == null) return null;

    if (value is LinearGradient) {
      return {
        'type': 'linear',
        'colors':
            value.colors.map((c) => ColorParser.instance.encode(c)).toList(),
        'stops': value.stops,
        'begin': AlignmentParser.instance.encode(value.begin),
        'end': AlignmentParser.instance.encode(value.end),
      };
    }

    if (value is RadialGradient) {
      return {
        'type': 'radial',
        'colors':
            value.colors.map((c) => ColorParser.instance.encode(c)).toList(),
        'stops': value.stops,
        'center': AlignmentParser.instance.encode(value.center),
        'radius': value.radius,
      };
    }

    if (value is SweepGradient) {
      return {
        'type': 'sweep',
        'colors':
            value.colors.map((c) => ColorParser.instance.encode(c)).toList(),
        'stops': value.stops,
        'center': AlignmentParser.instance.encode(value.center),
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
    final colorsList = map['colors'] as List?;
    final colors = colorsList
            ?.map((c) => ColorParser.instance.decode(c))
            .whereType<Color>()
            .toList() ??
        [];

    if (colors.isEmpty) return null;

    // Parse stops
    final stops =
        (map['stops'] as List?)?.map((s) => (s as num).toDouble()).toList();

    switch (type) {
      case 'linear':
        return LinearGradient(
          begin: AlignmentParser.instance.decode(map['begin']) ??
              Alignment.centerLeft,
          end: AlignmentParser.instance.decode(map['end']) ??
              Alignment.centerRight,
          colors: colors,
          stops: stops,
        );

      case 'radial':
        return RadialGradient(
          center: AlignmentParser.instance.decode(map['center']) ??
              Alignment.center,
          radius: (map['radius'] as num?)?.toDouble() ?? 0.5,
          colors: colors,
          stops: stops,
        );

      case 'sweep':
        return SweepGradient(
          center: AlignmentParser.instance.decode(map['center']) ??
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
