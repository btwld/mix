import 'base/parser_base.dart';

/// Simple duration parser following KISS principle
class DurationParser implements Parser<Duration> {
  static const instance = DurationParser();

  const DurationParser();

  Duration _parseMap(Map<String, Object?> map) {
    return Duration(
      days: (map['days'] as num?)?.toInt() ?? 0,
      hours: (map['hours'] as num?)?.toInt() ?? 0,
      minutes: (map['minutes'] as num?)?.toInt() ?? 0,
      seconds: (map['seconds'] as num?)?.toInt() ?? 0,
      milliseconds: (map['milliseconds'] as num?)?.toInt() ?? 0,
      microseconds: (map['microseconds'] as num?)?.toInt() ?? 0,
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
