import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for TextHeightBehavior following consistent JSON-style mapping
class TextHeightBehaviorParser extends Parser<TextHeightBehavior> {
  static const instance = TextHeightBehaviorParser();

  const TextHeightBehaviorParser();

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
      // Support map format only
      Map<String, Object?> map => TextHeightBehavior(
          applyHeightToFirstAscent:
              map.get('applyHeightToFirstAscent') ?? false,
          applyHeightToLastDescent:
              map.get('applyHeightToLastDescent') ?? false,
        ),
      _ => null,
    };
  }
}
