import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Simple EdgeInsets parser following KISS principle
class EdgeInsetsParser extends Parser<EdgeInsetsGeometry> {
  static const instance = EdgeInsetsParser();

  const EdgeInsetsParser();

  @override
  Object? encode(EdgeInsetsGeometry? value) {
    if (value == null) return null;

    // Handle the two main types we care about
    if (value is EdgeInsets) {
      // For symmetric values, use simpler format
      if (value.left == value.right && value.top == value.bottom) {
        if (value.left == value.top) {
          return value.left; // Single value for all sides
        }

        return [value.top, value.left]; // Vertical, horizontal
      }

      // Full format
      return [value.left, value.top, value.right, value.bottom];
    }

    if (value is EdgeInsetsDirectional) {
      return {
        'start': value.start,
        'top': value.top,
        'end': value.end,
        'bottom': value.bottom,
      };
    }

    throw ArgumentError(
      'Unsupported EdgeInsetsGeometry type: ${value.runtimeType}',
    );
  }

  @override
  EdgeInsetsGeometry? decode(Object? json) {
    if (json == null) return null;

    switch (json) {
      // Single value: all sides equal
      case num n:
        return EdgeInsets.all(n.toDouble());

      // Array format for EdgeInsets
      case List list when list.length == 2:
        // [vertical, horizontal]
        return EdgeInsets.symmetric(
          vertical: (list[0] as num).toDouble(),
          horizontal: (list[1] as num).toDouble(),
        );

      case List list when list.length == 4:
        // [left, top, right, bottom]
        return EdgeInsets.fromLTRB(
          (list[0] as num).toDouble(),
          (list[1] as num).toDouble(),
          (list[2] as num).toDouble(),
          (list[3] as num).toDouble(),
        );

      // Map format for EdgeInsetsDirectional
      case Map<String, Object?> map when map.containsKey('start'):
        return EdgeInsetsDirectional.fromSTEB(
          (map['start'] as num?)?.toDouble() ?? 0.0,
          (map['top'] as num?)?.toDouble() ?? 0.0,
          (map['end'] as num?)?.toDouble() ?? 0.0,
          (map['bottom'] as num?)?.toDouble() ?? 0.0,
        );

      default:
        return null;
    }
  }
}
