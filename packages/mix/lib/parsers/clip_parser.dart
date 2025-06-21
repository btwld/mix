import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for Clip enum values
class ClipParser implements Parser<Clip> {
  static const instance = ClipParser();

  const ClipParser();

  /// Safe parsing with error result
  ParseResult<Clip> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid Clip format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(Clip? value) {
    if (value == null) return null;

    return value.name;
  }

  @override
  Clip? decode(Object? json) {
    if (json == null) return null;

    if (json is! String) return null;

    return Clip.values.firstWhere(
      (e) => e.name == json,
      orElse: () => Clip.none,
    );
  }
}
