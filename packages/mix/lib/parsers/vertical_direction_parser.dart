import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for VerticalDirection enum following KISS principle
class VerticalDirectionParser implements Parser<VerticalDirection> {
  static const instance = VerticalDirectionParser();

  const VerticalDirectionParser();

  @override
  Object? encode(VerticalDirection? value) {
    if (value == null) return null;

    return switch (value) {
      VerticalDirection.up => 'up',
      VerticalDirection.down => 'down',
    };
  }

  @override
  VerticalDirection? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'up' => VerticalDirection.up,
      'down' => VerticalDirection.down,
      _ => null,
    };
  }
}