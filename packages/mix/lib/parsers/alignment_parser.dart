import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for AlignmentGeometry (Alignment and AlignmentDirectional)
class AlignmentParser implements Parser<AlignmentGeometry> {
  static const instance = AlignmentParser();

  // Map of named alignments for cleaner lookup
  static const Map<String, Alignment> _namedAlignments = {
    'center': Alignment.center,
    'topLeft': Alignment.topLeft,
    'topCenter': Alignment.topCenter,
    'topRight': Alignment.topRight,
    'centerLeft': Alignment.centerLeft,
    'centerRight': Alignment.centerRight,
    'bottomLeft': Alignment.bottomLeft,
    'bottomCenter': Alignment.bottomCenter,
    'bottomRight': Alignment.bottomRight,
  };

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
      // Check for named alignments using modern functional approach
      final namedAlignment = _namedAlignments.entries
          .where((entry) => entry.value == value)
          .firstOrNull;
      
      if (namedAlignment != null) return namedAlignment.key;

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
      // Named alignments using static map
      case String name when _namedAlignments.containsKey(name):
        return _namedAlignments[name];

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
