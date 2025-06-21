import 'base/parser_base.dart';

/// Simple duration parser following KISS principle
class DurationParser implements Parser<Duration> {
  static const instance = DurationParser();

  const DurationParser();

  Duration _parseMap(Map<String, Object?> map) {
    int parseUnit(String key) => (map[key] as num?)?.toInt() ?? 0;
    
    return Duration(
      days: parseUnit('days'),
      hours: parseUnit('hours'),
      minutes: parseUnit('minutes'),
      seconds: parseUnit('seconds'),
      milliseconds: parseUnit('milliseconds'),
      microseconds: parseUnit('microseconds'),
    );
  }

  /// Safe parsing with error result
  ParseResult<Duration> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError('Invalid duration format', json);
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }

  @override
  Object? encode(Duration? value) {
    if (value == null) return null;

    // Simple format: store as milliseconds (most common use case)
    return value.inMilliseconds;
  }

  @override
  Duration? decode(Object? json) {
    if (json == null) return null;

    switch (json) {
      // Handle milliseconds (most common)
      case int ms:
        return Duration(milliseconds: ms);

      // Handle map with multiple units (if needed)
      case Map<String, Object?> map:
        return _parseMap(map);

      default:
        return null;
    }
  }
}
