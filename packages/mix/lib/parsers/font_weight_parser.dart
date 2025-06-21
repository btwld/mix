import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for FontWeight following KISS principle
class FontWeightParser extends Parser<FontWeight> {
  static const instance = FontWeightParser();

  const FontWeightParser();

  @override
  Object? encode(FontWeight? value) {
    if (value == null) return null;

    return {'weight': value.value};
  }

  @override
  FontWeight? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      // Support map format (primary)
      Map<String, Object?> map => FontWeight.values.firstWhere(
          (weight) => weight.value == (map.get('weight') as num?)?.toInt(),
          orElse: () => FontWeight.normal,
        ),

      // Legacy string and numeric support for backward compatibility
      'thin' || 100 => FontWeight.w100,
      'extraLight' || 200 => FontWeight.w200,
      'light' || 300 => FontWeight.w300,
      'normal' || 'regular' || 400 => FontWeight.w400,
      'medium' || 500 => FontWeight.w500,
      'semiBold' || 600 => FontWeight.w600,
      'bold' || 700 => FontWeight.w700,
      'extraBold' || 800 => FontWeight.w800,
      'black' || 900 => FontWeight.w900,
      num numericValue => FontWeight.values.firstWhere(
          (weight) => weight.value == numericValue.toInt(),
          orElse: () => FontWeight.normal,
        ),
      _ => null,
    };
  }
}
