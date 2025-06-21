import 'package:flutter/material.dart';

import 'parsers.dart';

/// Parser for Border values
class BorderParser extends Parser<Border> {
  static const instance = BorderParser();

  const BorderParser();

  @override
  Object? encode(Border? value) {
    if (value == null) return null;

    // Check if all sides are the same (Border.all)
    if (value.top == value.right &&
        value.top == value.bottom &&
        value.top == value.left) {
      // Use BorderSideParser for single side
      return MixParsers.encode(value.top);
    }

    // Check if symmetric (vertical/horizontal)
    if (value.top == value.bottom && value.left == value.right) {
      return {
        'vertical': MixParsers.encode(value.left),
        'horizontal': MixParsers.encode(value.top),
      };
    }

    // Full format
    return {
      'top': MixParsers.encode(value.top),
      'right': MixParsers.encode(value.right),
      'bottom': MixParsers.encode(value.bottom),
      'left': MixParsers.encode(value.left),
    };
  }

  @override
  Border? decode(Object? json) {
    if (json == null) return null;

    // If it's not a map, treat it as a single BorderSide for all sides
    if (json is! Map<String, Object?>) {
      final side = MixParsers.decode<BorderSide>(json);

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
      final vertical = MixParsers.decode<BorderSide>(map['vertical']);
      final horizontal = MixParsers.decode<BorderSide>(map['horizontal']);

      if (vertical == null || horizontal == null) return null;

      return Border.symmetric(vertical: vertical, horizontal: horizontal);
    }

    // Full format
    return Border(
      top: MixParsers.decode(map['top']) ?? BorderSide.none,
      right: MixParsers.decode(map['right']) ?? BorderSide.none,
      bottom: MixParsers.decode(map['bottom']) ?? BorderSide.none,
      left: MixParsers.decode(map['left']) ?? BorderSide.none,
    );
  }
}
