import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for TextScaler following KISS principle
class TextScalerParser extends Parser<TextScaler> {
  static const instance = TextScalerParser();

  const TextScalerParser();

  TextScaler? _decodeFromMap(Map<String, Object?> map) {
    final type = map['type'] as String?;

    return switch (type) {
      'linear' => TextScaler.linear(
          (map['scaleFactor'] as num?)?.toDouble() ?? 1.0,
        ),
      'noScaling' => TextScaler.noScaling,
      _ => null,
    };
  }

  @override
  Object? encode(TextScaler? value) {
    if (value == null) return null;

    // Check for common cases first
    if (value == TextScaler.noScaling) {
      return {'type': 'noScaling'};
    }

    // For linear scaling, extract the scale factor
    // Note: This is a simplified approach - TextScaler doesn't expose scale factor directly
    // We'll test with different values to determine if it's linear
    final testScale = value.scale(14.0);
    final scaleFactor = testScale / 14.0;

    // Return linear scaling representation
    return {'type': 'linear', 'scaleFactor': scaleFactor};
  }

  @override
  TextScaler? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      // Map format (primary)
      Map<String, Object?> map => _decodeFromMap(map),

      // Legacy support for backward compatibility
      'noScaling' => TextScaler.noScaling,
      num factor => TextScaler.linear(factor.toDouble()),
      _ => null,
    };
  }
}
