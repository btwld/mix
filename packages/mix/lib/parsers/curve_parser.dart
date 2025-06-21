import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for Curve values
class CurveParser implements Parser<Curve> {
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

  /// Safe parsing with error result
  ParseResult<Curve> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid Curve format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(Curve? value) {
    if (value == null) return null;

    // Find matching named curve
    for (final entry in _curves.entries) {
      if (entry.value == value) {
        return entry.key;
      }
    }

    // For custom curves, return a generic identifier
    return 'custom_${value.runtimeType}';
  }

  @override
  Curve? decode(Object? json) {
    if (json == null) return null;

    if (json is! String) return null;

    // Return named curve or default to linear
    return _curves[json] ?? Curves.linear;
  }
}
