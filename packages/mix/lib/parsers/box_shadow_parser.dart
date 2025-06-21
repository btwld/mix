import 'package:flutter/material.dart';

import 'base/parser_base.dart';
import 'color_parser.dart';
import 'offset_parser.dart';

/// Parser for BoxShadow values
class BoxShadowParser implements Parser<BoxShadow> {
  static const instance = BoxShadowParser();

  const BoxShadowParser();

  /// Safe parsing with error result
  ParseResult<BoxShadow> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid BoxShadow format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(BoxShadow? value) {
    if (value == null) return null;

    // Simplified format for common shadows
    if (value.spreadRadius == 0.0 && value.color == const Color(0xFF000000)) {
      // Just offset and blur
      return {
        'offset': OffsetParser.instance.encode(value.offset),
        'blur': value.blurRadius,
      };
    }

    // Full format
    return {
      'color': ColorParser.instance.encode(value.color),
      'offset': OffsetParser.instance.encode(value.offset),
      'blurRadius': value.blurRadius,
      'spreadRadius': value.spreadRadius,
    };
  }

  @override
  BoxShadow? decode(Object? json) {
    if (json == null) return null;

    if (json is! Map<String, Object?>) return null;

    final map = json;

    return BoxShadow(
      color:
          ColorParser.instance.decode(map['color']) ?? const Color(0xFF000000),
      offset: OffsetParser.instance.decode(map['offset']) ?? Offset.zero,
      blurRadius: (map['blurRadius'] as num?)?.toDouble() ??
          (map['blur'] as num?)?.toDouble() ??
          0.0,
      spreadRadius: (map['spreadRadius'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
