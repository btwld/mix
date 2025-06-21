import 'package:flutter/material.dart';

import '../parsers.dart';

/// Base abstract parser for Gradient types with shared functionality
abstract class BaseGradientParser<T extends Gradient> extends Parser<T> {
  const BaseGradientParser();

  /// Shared encoding logic for all Gradient types
  Map<String, Object?> encodeCommon(Gradient gradient) {
    return {
      'colors': gradient.colors
          .map((c) => MixParsers.get<Color>()?.encode(c))
          .toList(),
      'stops': gradient.stops,
    };
  }

  /// Decode colors from map with validation
  List<Color> decodeColors(Map<String, Object?> map) {
    final colors = map.getListOf('colors', MixParsers.get<Color>()?.decode);
    if (colors.isEmpty) {
      throw ArgumentError('Gradient must have at least one color');
    }

    return colors;
  }

  /// Decode stops from map with fallback
  List<double>? decodeStops(Map<String, Object?> map) =>
      (map['stops'] as List?)?.map((s) => (s as num).toDouble()).toList();

  /// Decode alignment from map with fallback
  AlignmentGeometry decodeAlignment(
          Map<String, Object?> map, String key, AlignmentGeometry fallback) =>
      MixParsers.get<AlignmentGeometry>()?.decode(map[key]) ?? fallback;

  /// Decode double value from map with fallback
  double decodeDouble(Map<String, Object?> map, String key, double fallback) =>
      (map[key] as num?)?.toDouble() ?? fallback;
}
