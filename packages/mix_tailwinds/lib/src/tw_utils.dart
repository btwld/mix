/// Shared helpers for Tailwind token parsing.
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
