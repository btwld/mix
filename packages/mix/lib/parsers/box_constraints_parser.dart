import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for BoxConstraints values
class BoxConstraintsParser implements Parser<BoxConstraints> {
  static const instance = BoxConstraintsParser();

  const BoxConstraintsParser();

  /// Safe parsing with error result
  ParseResult<BoxConstraints> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid BoxConstraints format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(BoxConstraints? value) {
    if (value == null) return null;

    // Handle common cases with simplified formats

    // Tight constraints (exact size)
    if (value.isTight) {
      return {'width': value.maxWidth, 'height': value.maxHeight};
    }

    // Loose constraints (no minimum)
    if (value.minWidth == 0 && value.minHeight == 0) {
      // Infinite constraints
      if (value.maxWidth == double.infinity &&
          value.maxHeight == double.infinity) {
        return 'loose';
      }

      // Only max constraints
      return {
        'maxWidth': value.maxWidth.isFinite ? value.maxWidth : null,
        'maxHeight': value.maxHeight.isFinite ? value.maxHeight : null,
      };
    }

    // Full format
    return {
      'minWidth': value.minWidth,
      'maxWidth': value.maxWidth.isFinite ? value.maxWidth : null,
      'minHeight': value.minHeight,
      'maxHeight': value.maxHeight.isFinite ? value.maxHeight : null,
    };
  }

  @override
  BoxConstraints? decode(Object? json) {
    if (json == null) return null;

    switch (json) {
      // String shortcuts
      case 'loose':
        return const BoxConstraints();

      // Map format
      case Map<String, Object?> map:
        // Check for tight constraints format
        if (map.containsKey('width') && map.containsKey('height')) {
          final width = (map['width'] as num).toDouble();
          final height = (map['height'] as num).toDouble();

          return BoxConstraints.tight(Size(width, height));
        }

        // Full or partial constraints
        return BoxConstraints(
          minWidth: (map['minWidth'] as num?)?.toDouble() ?? 0.0,
          maxWidth: (map['maxWidth'] as num?)?.toDouble() ?? double.infinity,
          minHeight: (map['minHeight'] as num?)?.toDouble() ?? 0.0,
          maxHeight: (map['maxHeight'] as num?)?.toDouble() ?? double.infinity,
        );

      default:
        return null;
    }
  }
}
