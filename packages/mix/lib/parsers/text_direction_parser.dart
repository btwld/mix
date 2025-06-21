import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for TextDirection enum following KISS principle
class TextDirectionParser implements Parser<TextDirection> {
  static const instance = TextDirectionParser();
  
  const TextDirectionParser();

  @override
  Object? encode(TextDirection? value) {
    if (value == null) return null;
    
    return switch (value) {
      TextDirection.ltr => 'ltr',
      TextDirection.rtl => 'rtl',
    };
  }

  @override
  TextDirection? decode(Object? json) {
    if (json == null) return null;
    
    return switch (json) {
      'ltr' => TextDirection.ltr,
      'rtl' => TextDirection.rtl,
      _ => null,
    };
  }
}