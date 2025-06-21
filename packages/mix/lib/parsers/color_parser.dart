import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Simple color parser following KISS principle
class ColorParser implements Parser<Color> {
  static const instance = ColorParser();
  
  // Hex pattern for validation (6 or 8 chars: RRGGBB or AARRGGBB)
  static final RegExp _hexPattern = RegExp(r'^[0-9A-Fa-f]{6,8}$');

  const ColorParser();

  Color? _parseHex(String hexString) {
    try {
      // Remove # prefix if present
      final cleanHex = hexString.startsWith('#') 
          ? hexString.substring(1) 
          : hexString;
      
      // Validate hex format
      if (!_hexPattern.hasMatch(cleanHex)) return null;
      
      // Add full opacity if only RGB provided
      final fullHex = cleanHex.length == 6 ? 'FF$cleanHex' : cleanHex;
      
      return Color(int.parse(fullHex, radix: 16));
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

    return switch (json) {
      // Handle int values directly
      int colorValue => Color(colorValue),

      // Handle hex strings (with or without #)
      String hexString when hexString.startsWith('#') || 
                           _hexPattern.hasMatch(hexString) => 
        _parseHex(hexString),

      _ => null,
    };
  }
}
