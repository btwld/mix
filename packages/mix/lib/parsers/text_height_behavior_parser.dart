import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for TextHeightBehavior following consistent JSON-style mapping
class TextHeightBehaviorParser implements Parser<TextHeightBehavior> {
  static const instance = TextHeightBehaviorParser();

  const TextHeightBehaviorParser();

  /// Safe parsing with error result
  ParseResult<TextHeightBehavior> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid TextHeightBehavior format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(TextHeightBehavior? value) {
    if (value == null) return null;

    // Always use consistent map format for JSON-style behavior
    return {
      'applyHeightToFirstAscent': value.applyHeightToFirstAscent,
      'applyHeightToLastDescent': value.applyHeightToLastDescent,
    };
  }

  @override
  TextHeightBehavior? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      // Support map format (primary)
      Map<String, Object?> map => TextHeightBehavior(
          applyHeightToFirstAscent: map.get('applyHeightToFirstAscent') ?? false,
          applyHeightToLastDescent: map.get('applyHeightToLastDescent') ?? false,
        ),
      
      // Legacy string support for backward compatibility
      'applyHeightToFirstAscent' => const TextHeightBehavior(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
        ),
      'applyHeightToLastDescent' => const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
        ),
      'all' => const TextHeightBehavior(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
        ),
      'none' => const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
      
      _ => null,
    };
  }
}
