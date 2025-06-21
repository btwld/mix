import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for MainAxisSize enum following KISS principle
class MainAxisSizeParser implements Parser<MainAxisSize> {
  static const instance = MainAxisSizeParser();

  const MainAxisSizeParser();

  @override
  Object? encode(MainAxisSize? value) {
    if (value == null) return null;

    return switch (value) {
      MainAxisSize.min => 'min',
      MainAxisSize.max => 'max',
    };
  }

  @override
  MainAxisSize? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'min' => MainAxisSize.min,
      'max' => MainAxisSize.max,
      _ => null,
    };
  }
}
