import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for TextAlign enum following KISS principle
class TextAlignParser implements Parser<TextAlign> {
  static const instance = TextAlignParser();
  
  const TextAlignParser();

  @override
  Object? encode(TextAlign? value) {
    if (value == null) return null;
    
    return switch (value) {
      TextAlign.left => 'left',
      TextAlign.right => 'right',
      TextAlign.center => 'center',
      TextAlign.justify => 'justify',
      TextAlign.start => 'start',
      TextAlign.end => 'end',
    };
  }

  @override
  TextAlign? decode(Object? json) {
    if (json == null) return null;
    
    return switch (json) {
      'left' => TextAlign.left,
      'right' => TextAlign.right,
      'center' => TextAlign.center,
      'justify' => TextAlign.justify,
      'start' => TextAlign.start,
      'end' => TextAlign.end,
      _ => null,
    };
  }
}