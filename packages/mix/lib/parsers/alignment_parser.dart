import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for AlignmentGeometry (Alignment and AlignmentDirectional)
class AlignmentParser implements Parser<AlignmentGeometry> {
  static const instance = AlignmentParser();

  const AlignmentParser();

  /// Safe parsing with error result
  ParseResult<AlignmentGeometry> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid alignment format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(AlignmentGeometry? value) {
    if (value == null) return null;

    if (value is Alignment) {
      // For center alignment, use simple string
      if (value == Alignment.center) return 'center';
      if (value == Alignment.topLeft) return 'topLeft';
      if (value == Alignment.topCenter) return 'topCenter';
      if (value == Alignment.topRight) return 'topRight';
      if (value == Alignment.centerLeft) return 'centerLeft';
      if (value == Alignment.centerRight) return 'centerRight';
      if (value == Alignment.bottomLeft) return 'bottomLeft';
      if (value == Alignment.bottomCenter) return 'bottomCenter';
      if (value == Alignment.bottomRight) return 'bottomRight';

      // For custom values, use array format
      return [value.x, value.y];
    }

    if (value is AlignmentDirectional) {
      return {'start': value.start, 'y': value.y};
    }

    throw ArgumentError(
      'Unsupported AlignmentGeometry type: ${value.runtimeType}',
    );
  }

  @override
  AlignmentGeometry? decode(Object? json) {
    if (json == null) return null;

    switch (json) {
      // Named alignments
      case 'center':
        return Alignment.center;
      case 'topLeft':
        return Alignment.topLeft;
      case 'topCenter':
        return Alignment.topCenter;
      case 'topRight':
        return Alignment.topRight;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'centerRight':
        return Alignment.centerRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'bottomRight':
        return Alignment.bottomRight;

      // Array format [x, y]
      case List list when list.length == 2:
        return Alignment(
          (list[0] as num).toDouble(),
          (list[1] as num).toDouble(),
        );

      // Map format for AlignmentDirectional
      case Map<String, Object?> map when map.containsKey('start'):
        return AlignmentDirectional(
          (map['start'] as num?)?.toDouble() ?? 0.0,
          (map['y'] as num?)?.toDouble() ?? 0.0,
        );

      default:
        return null;
    }
  }
}
