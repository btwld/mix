import 'package:flutter/material.dart';

import 'base/enum_parser.dart';
import 'base/parser_base.dart';
import 'color_parser.dart';

/// Parser for BorderSide values
class BorderSideParser extends Parser<BorderSide> {
  static const instance = BorderSideParser();

  // Reuse existing parsers for consistency
  static const _colorParser = ColorParser.instance;
  static const _styleParser = BorderStyleParser();

  // Default values for border side
  static const Color _defaultColor = Color(0xFF000000);
  static const BorderStyle _defaultStyle = BorderStyle.solid;
  static const double _defaultStrokeAlign = BorderSide.strokeAlignInside;

  const BorderSideParser();

  BorderSide _parseFromMap(Map<String, Object?> map) {
    // Reuse ColorParser for consistent color parsing (supports int and hex strings)
    final color = _colorParser.decode(map['color']) ?? _defaultColor;

    // Reuse EnumParser for consistent BorderStyle parsing
    final style = _styleParser.decode(map['style']) ?? _defaultStyle;

    return BorderSide(
      color: color,
      width: (map['width'] as num?)?.toDouble() ?? 1.0,
      style: style,
    );
  }

  @override
  Object? encode(BorderSide? value) {
    if (value == null) return null;

    return switch (value) {
      // Special case for BorderSide.none
      BorderSide.none => 'none',

      // Simple case: only width differs from defaults
      _
          when value.color == _defaultColor &&
              value.style == _defaultStyle &&
              value.strokeAlign == _defaultStrokeAlign =>
        value.width,

      // Full format for custom border sides
      _ => {
          'color': _colorParser.encode(value.color),
          'width': value.width,
          'style': _styleParser.encode(value.style),
        },
    };
  }

  @override
  BorderSide? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      // String shortcuts
      'none' => BorderSide.none,

      // Simple width value
      num widthValue => BorderSide(width: widthValue.toDouble()),

      // Map format
      Map<String, Object?> borderMap => _parseFromMap(borderMap),
      _ => null,
    };
  }
}
