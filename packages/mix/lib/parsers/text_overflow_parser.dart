import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for TextOverflow enum following KISS principle
class TextOverflowParser implements Parser<TextOverflow> {
  static const instance = TextOverflowParser();

  const TextOverflowParser();

  @override
  Object? encode(TextOverflow? value) {
    if (value == null) return null;

    return switch (value) {
      TextOverflow.clip => 'clip',
      TextOverflow.fade => 'fade',
      TextOverflow.ellipsis => 'ellipsis',
      TextOverflow.visible => 'visible',
    };
  }

  @override
  TextOverflow? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'clip' => TextOverflow.clip,
      'fade' => TextOverflow.fade,
      'ellipsis' => TextOverflow.ellipsis,
      'visible' => TextOverflow.visible,
      _ => null,
    };
  }
}
