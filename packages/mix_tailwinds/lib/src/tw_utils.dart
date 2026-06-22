/// Shared helpers for Tailwind token parsing.
library;

enum _ColonSearch { first, last }

/// Finds the first colon that's not inside square brackets.
///
/// Used for iterative prefix stripping (e.g., parsing `md:hover:flex` one
/// prefix at a time).
///
/// Returns -1 if:
/// - No colon exists outside brackets
/// - Brackets are malformed (unclosed or extra closing)
///
/// Example:
/// - `md:flex` → 2 (index of `:` after `md`)
/// - `bg-[color:red]` → -1 (colon is inside brackets)
/// - `md:bg-[color:red]` → 2 (first colon after `md`)
int findFirstColonOutsideBrackets(String token) =>
    _findColonOutsideBrackets(token, _ColonSearch.first);

int _findColonOutsideBrackets(String token, _ColonSearch search) {
  var bracketDepth = 0;
  var colonOutside = -1;

  for (var i = 0; i < token.length; i++) {
    final c = token[i];
    if (c == '[') {
      bracketDepth++;
    } else if (c == ']') {
      bracketDepth--;
      // Extra closing bracket - malformed
      if (bracketDepth < 0) return -1;
    } else if (c == ':' && bracketDepth == 0) {
      if (search == _ColonSearch.first && colonOutside == -1) {
        colonOutside = i;
      } else if (search == _ColonSearch.last) {
        colonOutside = i;
      }
    }
  }

  // Unclosed brackets - malformed, treat as no prefix
  if (bracketDepth != 0) return -1;
  return colonOutside;
}

/// Finds the last colon that's not inside square brackets.
///
/// Used for getting the base token directly (e.g., extracting `flex` from
/// `md:hover:flex` in one operation).
///
/// Returns -1 if:
/// - No colon exists outside brackets
/// - Brackets are malformed (unclosed or extra closing)
///
/// Example:
/// - `md:hover:flex` → 8 (index of last `:` before `flex`)
/// - `bg-[color:red]` → -1 (colon is inside brackets)
/// - `md:bg-[color:red]` → 2 (only colon outside brackets)
int findLastColonOutsideBrackets(String token) =>
    _findColonOutsideBrackets(token, _ColonSearch.last);

/// Returns the token segment after the last variant prefix.
///
/// Colons inside arbitrary-value brackets are ignored. Malformed bracket
/// structure is treated as having no prefix, matching [findLastColonOutsideBrackets].
String baseTokenOutsideBrackets(String token) {
  final colonIndex = findLastColonOutsideBrackets(token);
  return colonIndex >= 0 ? token.substring(colonIndex + 1) : token;
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
