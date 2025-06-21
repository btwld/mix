import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for CrossAxisAlignment enum following KISS principle
class CrossAxisAlignmentParser implements Parser<CrossAxisAlignment> {
  static const instance = CrossAxisAlignmentParser();

  const CrossAxisAlignmentParser();

  @override
  Object? encode(CrossAxisAlignment? value) {
    if (value == null) return null;

    return switch (value) {
      CrossAxisAlignment.start => 'start',
      CrossAxisAlignment.end => 'end',
      CrossAxisAlignment.center => 'center',
      CrossAxisAlignment.stretch => 'stretch',
      CrossAxisAlignment.baseline => 'baseline',
    };
  }

  @override
  CrossAxisAlignment? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'start' => CrossAxisAlignment.start,
      'end' => CrossAxisAlignment.end,
      'center' => CrossAxisAlignment.center,
      'stretch' => CrossAxisAlignment.stretch,
      'baseline' => CrossAxisAlignment.baseline,
      _ => null,
    };
  }
}
