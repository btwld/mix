import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for BorderRadius values
class BorderRadiusParser implements Parser<BorderRadius> {
  static const instance = BorderRadiusParser();

  const BorderRadiusParser();

  /// Safe parsing with error result
  ParseResult<BorderRadius> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid BorderRadius format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(BorderRadius? value) {
    if (value == null) return null;

    // Check if all corners are the same (circular)
    if (value.topLeft == value.topRight &&
        value.topLeft == value.bottomLeft &&
        value.topLeft == value.bottomRight) {
      // Single value for BorderRadius.circular
      return value.topLeft.x;
    }

    // Check if corners are symmetric
    if (value.topLeft == value.bottomRight &&
        value.topRight == value.bottomLeft) {
      return {'topLeft': value.topLeft.x, 'topRight': value.topRight.x};
    }

    // Full format
    return {
      'topLeft': value.topLeft.x,
      'topRight': value.topRight.x,
      'bottomLeft': value.bottomLeft.x,
      'bottomRight': value.bottomRight.x,
    };
  }

  @override
  BorderRadius? decode(Object? json) {
    if (json == null) return null;

    switch (json) {
      // Single value: BorderRadius.circular
      case num n:
        return BorderRadius.circular(n.toDouble());

      // Map format
      case Map<String, Object?> map:
        // Check if it's simplified symmetric format
        if (map.length == 2 &&
            map.containsKey('topLeft') &&
            map.containsKey('topRight')) {
          return BorderRadius.only(
            topLeft: Radius.circular((map['topLeft'] as num).toDouble()),
            topRight: Radius.circular((map['topRight'] as num).toDouble()),
            bottomLeft: Radius.circular((map['topRight'] as num).toDouble()),
            bottomRight: Radius.circular((map['topLeft'] as num).toDouble()),
          );
        }

        // Full format
        return BorderRadius.only(
          topLeft: Radius.circular((map['topLeft'] as num?)?.toDouble() ?? 0.0),
          topRight:
              Radius.circular((map['topRight'] as num?)?.toDouble() ?? 0.0),
          bottomLeft:
              Radius.circular((map['bottomLeft'] as num?)?.toDouble() ?? 0.0),
          bottomRight:
              Radius.circular((map['bottomRight'] as num?)?.toDouble() ?? 0.0),
        );

      default:
        return null;
    }
  }
}
