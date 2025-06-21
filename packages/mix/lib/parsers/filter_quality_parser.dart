import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for FilterQuality enum following KISS principle
class FilterQualityParser implements Parser<FilterQuality> {
  static const instance = FilterQualityParser();

  const FilterQualityParser();

  @override
  Object? encode(FilterQuality? value) {
    if (value == null) return null;

    return switch (value) {
      FilterQuality.none => 'none',
      FilterQuality.low => 'low',
      FilterQuality.medium => 'medium',
      FilterQuality.high => 'high',
    };
  }

  @override
  FilterQuality? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'none' => FilterQuality.none,
      'low' => FilterQuality.low,
      'medium' => FilterQuality.medium,
      'high' => FilterQuality.high,
      _ => null,
    };
  }
}