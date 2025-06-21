import 'package:flutter/material.dart';

import '../parsers.dart';

/// Base abstract parser for Shadow types with shared functionality
abstract class BaseShadowParser<T extends Shadow> extends Parser<T> {
  const BaseShadowParser();

  /// Shared encoding logic for all Shadow types
  Map<String, Object?> encodeCommon(Shadow shadow) {
    return {
      'color': MixParsers.encode(shadow.color),
      'offset': MixParsers.encode(shadow.offset),
      'blurRadius': shadow.blurRadius,
    };
  }

  /// Decode color from map with fallback
  Color decodeColor(Map<String, Object?> map) =>
      MixParsers.decode(map['color']) ?? Colors.black;

  /// Decode offset from map with fallback
  Offset decodeOffset(Map<String, Object?> map) =>
      MixParsers.decode(map['offset']) ?? Offset.zero;

  /// Decode blur radius from map with fallback
  double decodeBlurRadius(Map<String, Object?> map) =>
      (map['blurRadius'] as num?)?.toDouble() ?? 0.0;
}
