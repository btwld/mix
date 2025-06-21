import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for StackFit enum following KISS principle
class StackFitParser implements Parser<StackFit> {
  static const instance = StackFitParser();

  const StackFitParser();

  @override
  Object? encode(StackFit? value) {
    if (value == null) return null;

    return switch (value) {
      StackFit.loose => 'loose',
      StackFit.expand => 'expand',
      StackFit.passthrough => 'passthrough',
    };
  }

  @override
  StackFit? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'loose' => StackFit.loose,
      'expand' => StackFit.expand,
      'passthrough' => StackFit.passthrough,
      _ => null,
    };
  }
}