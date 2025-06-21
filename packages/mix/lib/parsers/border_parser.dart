import 'package:flutter/material.dart';

import 'base/parser_base.dart';
import 'border_side_parser.dart';

/// Parser for Border values
class BorderParser implements Parser<Border> {
  static const instance = BorderParser();

  const BorderParser();

  /// Safe parsing with error result
  ParseResult<Border> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid Border format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(Border? value) {
    if (value == null) return null;

    // Check if all sides are the same (Border.all)
    if (value.top == value.right &&
        value.top == value.bottom &&
        value.top == value.left) {
      // Use BorderSideParser for single side
      return BorderSideParser.instance.encode(value.top);
    }

    // Check if symmetric (vertical/horizontal)
    if (value.top == value.bottom && value.left == value.right) {
      return {
        'vertical': BorderSideParser.instance.encode(value.left),
        'horizontal': BorderSideParser.instance.encode(value.top),
      };
    }

    // Full format
    return {
      'top': BorderSideParser.instance.encode(value.top),
      'right': BorderSideParser.instance.encode(value.right),
      'bottom': BorderSideParser.instance.encode(value.bottom),
      'left': BorderSideParser.instance.encode(value.left),
    };
  }

  @override
  Border? decode(Object? json) {
    if (json == null) return null;

    // If it's not a map, treat it as a single BorderSide for all sides
    if (json is! Map<String, Object?>) {
      final side = BorderSideParser.instance.decode(json);

      return side != null
          ? Border.all(
              color: side.color,
              width: side.width,
              style: side.style,
            )
          : null;
    }

    final map = json;

    // Check for symmetric format
    if (map.containsKey('vertical') && map.containsKey('horizontal')) {
      final vertical = BorderSideParser.instance.decode(map['vertical']);
      final horizontal = BorderSideParser.instance.decode(map['horizontal']);

      if (vertical == null || horizontal == null) return null;

      return Border.symmetric(vertical: vertical, horizontal: horizontal);
    }

    // Full format
    return Border(
      top: BorderSideParser.instance.decode(map['top']) ?? BorderSide.none,
      right: BorderSideParser.instance.decode(map['right']) ?? BorderSide.none,
      bottom:
          BorderSideParser.instance.decode(map['bottom']) ?? BorderSide.none,
      left: BorderSideParser.instance.decode(map['left']) ?? BorderSide.none,
    );
  }
}
