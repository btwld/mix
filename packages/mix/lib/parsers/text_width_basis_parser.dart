import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for TextWidthBasis enum following KISS principle
class TextWidthBasisParser implements Parser<TextWidthBasis> {
  static const instance = TextWidthBasisParser();

  const TextWidthBasisParser();

  @override
  Object? encode(TextWidthBasis? value) {
    if (value == null) return null;

    return switch (value) {
      TextWidthBasis.parent => 'parent',
      TextWidthBasis.longestLine => 'longestLine',
    };
  }

  @override
  TextWidthBasis? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'parent' => TextWidthBasis.parent,
      'longestLine' => TextWidthBasis.longestLine,
      _ => null,
    };
  }
}