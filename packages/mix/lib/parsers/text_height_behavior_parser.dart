import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for TextHeightBehavior following KISS principle
class TextHeightBehaviorParser implements Parser<TextHeightBehavior> {
  static const instance = TextHeightBehaviorParser();

  const TextHeightBehaviorParser();

  @override
  Object? encode(TextHeightBehavior? value) {
    if (value == null) return null;

    // Check if it's just applyHeightToFirstAscent
    if (value.applyHeightToFirstAscent == true &&
        value.applyHeightToLastDescent == false) {
      return 'applyHeightToFirstAscent';
    }

    // Check if it's just applyHeightToLastDescent
    if (value.applyHeightToFirstAscent == false &&
        value.applyHeightToLastDescent == true) {
      return 'applyHeightToLastDescent';
    }

    // Check if both are true
    if (value.applyHeightToFirstAscent == true &&
        value.applyHeightToLastDescent == true) {
      return 'all';
    }

    // Check if both are false
    if (value.applyHeightToFirstAscent == false &&
        value.applyHeightToLastDescent == false) {
      return 'none';
    }

    // Full map format for clarity
    return {
      'applyHeightToFirstAscent': value.applyHeightToFirstAscent,
      'applyHeightToLastDescent': value.applyHeightToLastDescent,
    };
  }

  @override
  TextHeightBehavior? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
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
      Map<String, Object?> map => TextHeightBehavior(
          applyHeightToFirstAscent:
              map['applyHeightToFirstAscent'] as bool? ?? false,
          applyHeightToLastDescent:
              map['applyHeightToLastDescent'] as bool? ?? false,
        ),
      _ => null,
    };
  }
}
