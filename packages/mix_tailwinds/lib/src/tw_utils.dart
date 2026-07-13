/// Shared helpers for Tailwind token parsing.
library;

final _whitespaceRegex = RegExp(r'\s+');

List<String> splitTailwindTokens(String classNames) {
  final trimmed = classNames.trim();
  return trimmed.isEmpty ? const [] : trimmed.split(_whitespaceRegex);
}

double? parseFractionToken(String value) {
  final parts = value.split('/');
  if (parts.length != 2) {
    return null;
  }

  final numerator = double.tryParse(parts[0]);
  final denominator = double.tryParse(parts[1]);

  if (numerator == null || denominator == null || denominator == 0) {
    return null;
  }

  return numerator / denominator;
}

final _cssLengthRegex = RegExp(r'^(-?\d+\.?\d*)(px|rem|em)?$');

/// Parses a raw CSS length string into logical pixels.
///
/// A bare number is treated as `px`; `rem`/`em` are converted at 16px. Returns
/// null when [raw] is not a plain numeric length (e.g. `50%`, `full`, `auto`).
double? parseCssLength(String raw) {
  final match = _cssLengthRegex.firstMatch(raw);
  if (match == null) return null;
  var length = double.parse(match.group(1)!);
  final unit = match.group(2) ?? 'px';
  if (unit == 'rem' || unit == 'em') length *= 16;
  return length;
}
