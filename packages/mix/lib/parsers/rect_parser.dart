import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for Rect following KISS principle
class RectParser extends Parser<Rect> {
  static const instance = RectParser();

  const RectParser();

  Rect _decodeFromMap(Map<String, Object?> map) {
    // Support both LTRB and LTWH formats
    if (map.containsKey('left') && map.containsKey('top')) {
      final left = (map['left'] as num?)?.toDouble() ?? 0.0;
      final top = (map['top'] as num?)?.toDouble() ?? 0.0;

      if (map.containsKey('width') && map.containsKey('height')) {
        // LTWH format
        final width = (map['width'] as num?)?.toDouble() ?? 0.0;
        final height = (map['height'] as num?)?.toDouble() ?? 0.0;

        return Rect.fromLTWH(left, top, width, height);
      } else if (map.containsKey('right') && map.containsKey('bottom')) {
        // LTRB format
        final right = (map['right'] as num?)?.toDouble() ?? 0.0;
        final bottom = (map['bottom'] as num?)?.toDouble() ?? 0.0;

        return Rect.fromLTRB(left, top, right, bottom);
      }
    }

    // Center and size format
    if (map.containsKey('center') && map.containsKey('size')) {
      final centerList = map['center'] as List<Object?>?;
      final sizeList = map['size'] as List<Object?>?;

      if (centerList != null &&
          centerList.length == 2 &&
          sizeList != null &&
          sizeList.length == 2) {
        final centerX = (centerList[0] as num).toDouble();
        final centerY = (centerList[1] as num).toDouble();
        final width = (sizeList[0] as num).toDouble();
        final height = (sizeList[1] as num).toDouble();

        return Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: width,
          height: height,
        );
      }
    }

    return Rect.zero;
  }

  @override
  Object? encode(Rect? value) {
    if (value == null) return null;

    // Check for special cases
    if (value == Rect.zero) {
      return 'zero';
    }

    // Check for largest finite rect
    if (value == Rect.largest) {
      return 'largest';
    }

    // Standard format: [left, top, right, bottom]
    return [value.left, value.top, value.right, value.bottom];
  }

  @override
  Rect? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      // Special cases
      'zero' => Rect.zero,
      'largest' => Rect.largest,

      // Array format [left, top, right, bottom]
      List<Object?> list when list.length == 4 => Rect.fromLTRB(
          (list[0] as num).toDouble(),
          (list[1] as num).toDouble(),
          (list[2] as num).toDouble(),
          (list[3] as num).toDouble(),
        ),

      // Alternative array format [left, top, width, height] if marked
      Map<String, Object?> map => _decodeFromMap(map),
      _ => null,
    };
  }
}
