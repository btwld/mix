import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Simple color parser following KISS principle
class ColorParser implements Parser<Color> {
  static const instance = ColorParser();

  const ColorParser();

  Color? _parseHex(String hex) {
    try {
      final buffer = hex.substring(1); // Remove #
      final value = buffer.length == 6
          ? 'FF$buffer' // Add opacity if not present
          : buffer;

      return Color(int.parse(value, radix: 16));
    } catch (_) {
      return null;
    }
  }

  /// Safe parsing with error result
  ParseResult<Color> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid color format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(Color? value) {
    if (value == null) return null;

    // Simple format: store as int value (using .value for backward compatibility)
    // ignore: deprecated_member_use
    return value.value;
  }

  @override
  Color? decode(Object? json) {
    if (json == null) return null;

    switch (json) {
      // Handle int values directly
      case int value:
        return Color(value);

      // Handle hex strings (common use case)
      case String hex when hex.startsWith('#'):
        return _parseHex(hex);

      // Handle hex without #
      case String hex when RegExp(r'^[0-9A-Fa-f]{6,8}$').hasMatch(hex):
        return _parseHex('#$hex');

      default:
        return null;
    }
  }
}
