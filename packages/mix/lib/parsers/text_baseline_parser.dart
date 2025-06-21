import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for TextBaseline enum following KISS principle
class TextBaselineParser implements Parser<TextBaseline> {
  static const instance = TextBaselineParser();

  const TextBaselineParser();

  @override
  Object? encode(TextBaseline? value) {
    if (value == null) return null;

    return switch (value) {
      TextBaseline.alphabetic => 'alphabetic',
      TextBaseline.ideographic => 'ideographic',
    };
  }

  @override
  TextBaseline? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'alphabetic' => TextBaseline.alphabetic,
      'ideographic' => TextBaseline.ideographic,
      _ => null,
    };
  }
}
