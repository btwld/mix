import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for BorderSide values
class BorderSideParser implements Parser<BorderSide> {
  static const instance = BorderSideParser();

  const BorderSideParser();

  /// Safe parsing with error result
  ParseResult<BorderSide> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid BorderSide format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(BorderSide? value) {
    if (value == null) return null;

    // Special case for BorderSide.none
    if (value == BorderSide.none) return 'none';

    // Simple case: only width differs from default
    if (value.color == const Color(0xFF000000) &&
        value.style == BorderStyle.solid &&
        value.strokeAlign == BorderSide.strokeAlignInside) {
      return value.width;
    }

    // Full format
    return {
      // ignore: deprecated_member_use
      'color': value.color.value,
      'width': value.width,
      'style': value.style.name,
    };
  }

  @override
  BorderSide? decode(Object? json) {
    if (json == null) return null;

    switch (json) {
      // String shortcuts
      case 'none':
        return BorderSide.none;

      // Simple width value
      case num n:
        return BorderSide(width: n.toDouble());

      // Map format
      case Map<String, Object?> map:
        final colorValue = map['color'] as int?;
        final color =
            colorValue != null ? Color(colorValue) : const Color(0xFF000000);

        final styleString = map['style'] as String?;
        final style = styleString != null
            ? BorderStyle.values.firstWhere(
                (e) => e.name == styleString,
                orElse: () => BorderStyle.solid,
              )
            : BorderStyle.solid;

        return BorderSide(
          color: color,
          width: (map['width'] as num?)?.toDouble() ?? 1.0,
          style: style,
        );

      default:
        return null;
    }
  }
}
