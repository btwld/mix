import 'package:flutter/material.dart';

import 'parsers.dart';

/// Simplified BoxDecoration parser following KISS principle
class BoxDecorationParser implements Parser<BoxDecoration> {
  static const instance = BoxDecorationParser();

  const BoxDecorationParser();

  /// Safe parsing with error result
  ParseResult<BoxDecoration> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid BoxDecoration format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(BoxDecoration? value) {
    if (value == null) return null;

    final result = <String, dynamic>{};

    // Only encode non-null properties
    if (value.color != null) {
      result['color'] = MixParsers.get<Color>()?.encode(value.color);
    }

    if (value.border is Border) {
      result['border'] = MixParsers.get<Border>()?.encode(value.border as Border);
    }

    if (value.borderRadius is BorderRadius) {
      result['borderRadius'] = MixParsers.get<BorderRadius>()
          ?.encode(value.borderRadius as BorderRadius);
    }

    if (value.boxShadow != null) {
      result['boxShadow'] = value.boxShadow!
          .map((shadow) => MixParsers.get<BoxShadow>()?.encode(shadow))
          .toList();
    }

    if (value.shape != BoxShape.rectangle) {
      result['shape'] = value.shape.name;
    }

    // Skip gradient for now (YAGNI - add when needed)
    // Skip image for now (YAGNI - add when needed)

    return result;
  }

  @override
  BoxDecoration? decode(Object? json) {
    if (json == null) return null;

    // Support simple color value
    if (json is int || json is String) {
      final color = MixParsers.get<Color>()?.decode(json);

      return color != null ? BoxDecoration(color: color) : null;
    }

    if (json is! Map<String, Object?>) return null;

    final map = json;

    // Parse boxShadow list
    List<BoxShadow>? boxShadow;
    final shadowList = map['boxShadow'] as List?;
    if (shadowList != null) {
      boxShadow = shadowList
          .map((s) => MixParsers.get<BoxShadow>()?.decode(s))
          .whereType<BoxShadow>()
          .toList();
    }

    // Parse shape
    BoxShape shape = BoxShape.rectangle;
    final shapeString = map['shape'] as String?;
    if (shapeString != null) {
      shape = BoxShape.values.firstWhere(
        (e) => e.name == shapeString,
        orElse: () => BoxShape.rectangle,
      );
    }

    return BoxDecoration(
      color: MixParsers.get<Color>()?.decode(map['color']),
      border: MixParsers.get<Border>()?.decode(map['border']),
      borderRadius: shape == BoxShape.rectangle
          ? MixParsers.get<BorderRadius>()?.decode(map['borderRadius'])
          : null,
      boxShadow: boxShadow,
      shape: shape,
    );
  }
}
