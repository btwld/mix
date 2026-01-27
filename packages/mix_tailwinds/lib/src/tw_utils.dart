/// Shared helpers for Tailwind token parsing.

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
int findFirstColonOutsideBrackets(String token) {
  var bracketDepth = 0;
  var firstColonOutside = -1;
  for (var i = 0; i < token.length; i++) {
    final c = token[i];
    if (c == '[') {
      bracketDepth++;
    } else if (c == ']') {
      bracketDepth--;
      // Extra closing bracket - malformed
      if (bracketDepth < 0) return -1;
    } else if (c == ':' && bracketDepth == 0 && firstColonOutside == -1) {
      firstColonOutside = i;
    }
  }
  // Unclosed brackets - malformed, treat as no prefix
  if (bracketDepth != 0) return -1;
  return firstColonOutside;
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
int findLastColonOutsideBrackets(String token) {
  var bracketDepth = 0;
  var lastColonOutside = -1;
  for (var i = 0; i < token.length; i++) {
    final c = token[i];
    if (c == '[') {
      bracketDepth++;
    } else if (c == ']') {
      bracketDepth--;
      // Extra closing bracket - malformed
      if (bracketDepth < 0) return -1;
    } else if (c == ':' && bracketDepth == 0) {
      lastColonOutside = i; // Keep updating to get the last one
    }
  }
  // Unclosed brackets - malformed, treat as no prefix
  if (bracketDepth != 0) return -1;
  return lastColonOutside;
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
