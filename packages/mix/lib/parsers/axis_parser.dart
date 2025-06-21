import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for Axis enum following KISS principle
class AxisParser implements Parser<Axis> {
  static const instance = AxisParser();

  const AxisParser();

  @override
  Object? encode(Axis? value) {
    if (value == null) return null;

    return switch (value) {
      Axis.horizontal => 'horizontal',
      Axis.vertical => 'vertical',
    };
  }

  @override
  Axis? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'horizontal' => Axis.horizontal,
      'vertical' => Axis.vertical,
      _ => null,
    };
  }
}
