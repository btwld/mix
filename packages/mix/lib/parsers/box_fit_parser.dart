import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for BoxFit enum following KISS principle
class BoxFitParser implements Parser<BoxFit> {
  static const instance = BoxFitParser();

  const BoxFitParser();

  @override
  Object? encode(BoxFit? value) {
    if (value == null) return null;

    return switch (value) {
      BoxFit.fill => 'fill',
      BoxFit.contain => 'contain',
      BoxFit.cover => 'cover',
      BoxFit.fitWidth => 'fitWidth',
      BoxFit.fitHeight => 'fitHeight',
      BoxFit.none => 'none',
      BoxFit.scaleDown => 'scaleDown',
    };
  }

  @override
  BoxFit? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'fill' => BoxFit.fill,
      'contain' => BoxFit.contain,
      'cover' => BoxFit.cover,
      'fitWidth' => BoxFit.fitWidth,
      'fitHeight' => BoxFit.fitHeight,
      'none' => BoxFit.none,
      'scaleDown' => BoxFit.scaleDown,
      _ => null,
    };
  }
}
