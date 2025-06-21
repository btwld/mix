import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for Size values
class SizeParser implements Parser<Size> {
  static const instance = SizeParser();

  const SizeParser();

  /// Safe parsing with error result
  ParseResult<Size> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid Size format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(Size? value) {
    if (value == null) return null;

    // Special cases for common sizes
    if (value == Size.zero) return 'zero';
    if (value.width == double.infinity && value.height == double.infinity) {
      return 'infinite';
    }

    // Square size - single value
    if (value.width == value.height) {
      return value.width;
    }

    // Array format [width, height]
    return [value.width, value.height];
  }

  @override
  Size? decode(Object? json) {
    if (json == null) return null;

    switch (json) {
      // String shortcuts
      case 'zero':
        return Size.zero;
      case 'infinite':
        return Size.infinite;

      // Single value for square
      case num n:
        final size = n.toDouble();

        return Size(size, size);

      // Array format [width, height]
      case List list when list.length == 2:
        return Size(
          (list[0] as num).toDouble(),
          (list[1] as num).toDouble(),
        );

      // Map format for compatibility
      case Map<String, Object?> map:
        return Size(
          (map['width'] as num?)?.toDouble() ?? 0.0,
          (map['height'] as num?)?.toDouble() ?? 0.0,
        );

      default:
        return null;
    }
  }
}
