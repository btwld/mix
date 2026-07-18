/// Deterministic Figma `/` to Mix `.` token-name mapping.
abstract final class MixFigmaNameMapper {
  static final RegExp _tokenNamePattern = RegExp(r'^[A-Za-z0-9_.-]{1,128}$');

  static String figmaToMix(String figmaName) {
    final result = figmaName.replaceAll('/', '.');
    _validate(result);

    return result;
  }

  static String mixToFigma(String mixName) {
    _validate(mixName);

    return mixName.replaceAll('.', '/');
  }

  static bool isValidMixName(String value) => _tokenNamePattern.hasMatch(value);

  static void _validate(String value) {
    if (!_tokenNamePattern.hasMatch(value)) {
      throw FormatException(
        'Token names must match [A-Za-z0-9_.-]{1,128}: "$value".',
      );
    }
  }
}
