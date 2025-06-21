import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for Offset values
class OffsetParser implements Parser<Offset> {
  static const instance = OffsetParser();

  const OffsetParser();

  /// Safe parsing with error result
  ParseResult<Offset> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid Offset format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(Offset? value) {
    if (value == null) return null;

    // Special case for zero offset
    if (value == Offset.zero) return 'zero';

    // Array format [dx, dy]
    return [value.dx, value.dy];
  }

  @override
  Offset? decode(Object? json) {
    if (json == null) return null;

    switch (json) {
      // String shortcuts
      case 'zero':
        return Offset.zero;

      // Array format [dx, dy]
      case List list when list.length == 2:
        return Offset(
          (list[0] as num).toDouble(),
          (list[1] as num).toDouble(),
        );

      // Map format for compatibility
      case Map<String, Object?> map:
        return Offset(
          (map['dx'] as num?)?.toDouble() ?? 0.0,
          (map['dy'] as num?)?.toDouble() ?? 0.0,
        );

      default:
        return null;
    }
  }
}
