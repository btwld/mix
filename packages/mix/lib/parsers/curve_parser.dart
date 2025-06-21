import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for Curve values
class CurveParser extends Parser<Curve> {
  static const instance = CurveParser();

  // Map of common curves for encoding/decoding
  static const Map<String, Curve> _curves = {
    'linear': Curves.linear,
    'easeIn': Curves.easeIn,
    'easeOut': Curves.easeOut,
    'easeInOut': Curves.easeInOut,
    'fastOutSlowIn': Curves.fastOutSlowIn,
    'slowMiddle': Curves.slowMiddle,
    'bounceIn': Curves.bounceIn,
    'bounceOut': Curves.bounceOut,
    'bounceInOut': Curves.bounceInOut,
    'elasticIn': Curves.elasticIn,
    'elasticOut': Curves.elasticOut,
    'elasticInOut': Curves.elasticInOut,
    'decelerate': Curves.decelerate,
    'ease': Curves.ease,
  };

  const CurveParser();

  @override
  Object? encode(Curve? value) {
    if (value == null) return null;

    // Find matching named curve using modern functional approach
    final namedCurve =
        _curves.entries.where((entry) => entry.value == value).firstOrNull;

    return {'type': namedCurve?.key ?? 'custom_${value.runtimeType}'};
  }

  @override
  Curve? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      // Support map format (primary)
      Map<String, Object?> map => _curves[map.get('type')] ?? Curves.linear,

      // Legacy string support for backward compatibility
      String curveName => _curves[curveName] ?? Curves.linear,
      _ => null,
    };
  }
}
