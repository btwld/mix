import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for FontWeight following KISS principle
class FontWeightParser implements Parser<FontWeight> {
  static const instance = FontWeightParser();

  const FontWeightParser();

  @override
  Object? encode(FontWeight? value) {
    if (value == null) return null;

    return switch (value) {
      FontWeight.w100 => 'thin',
      FontWeight.w200 => 'extraLight',
      FontWeight.w300 => 'light',
      FontWeight.w400 => 'normal',
      FontWeight.w500 => 'medium',
      FontWeight.w600 => 'semiBold',
      FontWeight.w700 => 'bold',
      FontWeight.w800 => 'extraBold',
      FontWeight.w900 => 'black',
      _ => value.value,
    };
  }

  @override
  FontWeight? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'thin' || 100 => FontWeight.w100,
      'extraLight' || 200 => FontWeight.w200,
      'light' || 300 => FontWeight.w300,
      'normal' || 'regular' || 400 => FontWeight.w400,
      'medium' || 500 => FontWeight.w500,
      'semiBold' || 600 => FontWeight.w600,
      'bold' || 700 => FontWeight.w700,
      'extraBold' || 800 => FontWeight.w800,
      'black' || 900 => FontWeight.w900,
      num n => FontWeight.values.firstWhere(
          (w) => w.value == n.toInt(),
          orElse: () => FontWeight.normal,
        ),
      _ => null,
    };
  }
}
