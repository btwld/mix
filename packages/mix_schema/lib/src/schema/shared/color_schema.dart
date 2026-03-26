import 'package:ack/ack.dart';
import 'package:flutter/painting.dart';

final _rgbaPattern = RegExp(
  r'^rgba\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*([+-]?(?:(?:\d+(?:\.\d*)?)|(?:\.\d+))(?:[eE][+-]?\d+)?)\s*\)$',
  caseSensitive: false,
);
final _rgbPattern = RegExp(
  r'^rgb\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$',
  caseSensitive: false,
);
final _hexPattern = RegExp(r'^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{8})$');

final colorSchema = Ack.string()
    .describe(
      'CSS color in rgba(r,g,b,a), rgb(r,g,b), #RRGGBB, or #RRGGBBAA format. '
      'RGB channels are 0-255, alpha is 0.0-1.0. '
      'Examples: "rgba(59,130,246,0.5)", "rgb(255,0,0)", "#3B82F6", "#3B82F680".',
    )
    .matches(r'^([Rr][Gg][Bb][Aa]?\(.+\)|#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?)$')
    .refine(
      (value) => _tryParseCssColor(value) != null,
      message:
          'Expected color in rgba(...), rgb(...), #RRGGBB, or #RRGGBBAA format.',
    )
    .transform<Color>((value) => _tryParseCssColor(value)!);

Color? _tryParseCssColor(String value) {
  final input = value.trim();
  if (input.isEmpty) {
    return null;
  }

  if (_rgbaPattern.firstMatch(input) case final match?) {
    return _parseRgbFunction(match, hasAlpha: true);
  }

  if (_rgbPattern.firstMatch(input) case final match?) {
    return _parseRgbFunction(match, hasAlpha: false);
  }

  if (_hexPattern.firstMatch(input) case final match?) {
    return _parseHexColor(match.group(1)!);
  }

  return null;
}

Color? _parseRgbFunction(RegExpMatch match, {required bool hasAlpha}) {
  final red = _parseByte(match.group(1)!);
  final green = _parseByte(match.group(2)!);
  final blue = _parseByte(match.group(3)!);
  final alpha = hasAlpha ? _parseUnitInterval(match.group(4)!) : 1.0;

  if (red == null || green == null || blue == null || alpha == null) {
    return null;
  }

  return Color.fromRGBO(red, green, blue, alpha);
}

int? _parseByte(String input) {
  final value = int.tryParse(input);
  if (value == null) {
    return null;
  }

  return switch (value) {
    >= 0 && <= 255 => value,
    _ => null,
  };
}

double? _parseUnitInterval(String input) {
  final value = double.tryParse(input);
  if (value == null || !value.isFinite) {
    return null;
  }

  return switch (value) {
    >= 0 && <= 1 => value,
    _ => null,
  };
}

Color _parseHexColor(String hex) {
  final value = int.parse(hex, radix: 16);

  if (hex.length == 6) {
    return Color(0xFF000000 | value);
  }

  final rgb = value >> 8;
  final alpha = value & 0xFF;

  return Color((alpha << 24) | rgb);
}
