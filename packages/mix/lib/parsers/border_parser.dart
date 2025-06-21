import 'package:flutter/material.dart';

import 'parsers.dart';

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
      return MixParsers.get<BorderSide>()?.encode(value.top);
    }

    // Check if symmetric (vertical/horizontal)
    if (value.top == value.bottom && value.left == value.right) {
      return {
        'vertical': MixParsers.get<BorderSide>()?.encode(value.left),
        'horizontal': MixParsers.get<BorderSide>()?.encode(value.top),
      };
    }

    // Full format
    return {
      'top': MixParsers.get<BorderSide>()?.encode(value.top),
      'right': MixParsers.get<BorderSide>()?.encode(value.right),
      'bottom': MixParsers.get<BorderSide>()?.encode(value.bottom),
      'left': MixParsers.get<BorderSide>()?.encode(value.left),
    };
  }

  @override
  Border? decode(Object? json) {
    if (json == null) return null;

    // If it's not a map, treat it as a single BorderSide for all sides
    if (json is! Map<String, Object?>) {
      final side = MixParsers.get<BorderSide>()?.decode(json);

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
      final vertical = MixParsers.get<BorderSide>()?.decode(map['vertical']);
      final horizontal = MixParsers.get<BorderSide>()?.decode(map['horizontal']);

      if (vertical == null || horizontal == null) return null;

      return Border.symmetric(vertical: vertical, horizontal: horizontal);
    }

    // Full format
    return Border(
      top: MixParsers.get<BorderSide>()?.decode(map['top']) ?? BorderSide.none,
      right: MixParsers.get<BorderSide>()?.decode(map['right']) ?? BorderSide.none,
      bottom:
          MixParsers.get<BorderSide>()?.decode(map['bottom']) ?? BorderSide.none,
      left: MixParsers.get<BorderSide>()?.decode(map['left']) ?? BorderSide.none,
    );
  }
}
