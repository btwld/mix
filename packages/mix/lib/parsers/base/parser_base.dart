/// Base parser interface and utilities
/// Following KISS principle - minimal abstraction
abstract class Parser<T> {
  const Parser();

  /// Encode a value to JSON-compatible format
  Object? encode(T? value);

  /// Decode from JSON to typed value
  T? decode(Object? json);

  /// Safe parsing with error result
  /// Reusable implementation that delegates to decode()
  ParseResult<T> tryDecode(Object? json) {
    try {
      final result = decode(json);

      return result != null
          ? ParseSuccess(result)
          : ParseError(
              'Invalid ${T.toString().replaceAll('?', '')} format',
              json,
            );
    } catch (e) {
      return ParseError(e.toString(), json);
    }
  }
}

/// Result type for safe parsing
sealed class ParseResult<T> {
  const ParseResult();

  bool get isSuccess => this is ParseSuccess<T>;
  bool get isError => this is ParseError<T>;

  T? get valueOrNull =>
      this is ParseSuccess<T> ? (this as ParseSuccess<T>).value : null;
}

class ParseSuccess<T> extends ParseResult<T> {
  final T value;
  const ParseSuccess(this.value);
}

class ParseError<T> extends ParseResult<T> {
  final String message;
  final Object? source;

  const ParseError(this.message, [this.source]);

  @override
  String toString() =>
      'ParseError: $message${source != null ? ' (source: $source)' : ''}';
}

/// Extension for cleaner null-safe map access
extension JsonMapExtension on Map<String, Object?>? {
  T? get<T>(String key) => this?[key] as T?;

  num? getNum(String key) => this?[key] as num?;

  double? getDouble(String key) => getNum(key)?.toDouble();

  int? getInt(String key) => getNum(key)?.toInt();

  String? getString(String key) => this?[key] as String?;

  Map<String, Object?>? getMap(String key) =>
      this?[key] as Map<String, Object?>?;

  List<Object?>? getList(String key) => this?[key] as List<Object?>?;

  /// Parse a list with type safety and null checks
  List<T> getListOf<T>(String key, T? Function(Object?)? decoder) {
    if (decoder == null) return [];

    return getList(key)?.map(decoder).whereType<T>().toList() ?? [];
  }
}

/// Utility for building maps with only non-null values
class MapBuilder {
  final Map<String, Object?> _map = <String, Object?>{};

  /// Check if the builder is empty
  bool get isEmpty => _map.isEmpty;

  /// Add a value to the map only if it's not null
  void addIfNotNull<T>(String key, T? value, [Object? Function(T)? encoder]) {
    if (value != null) {
      _map[key] = encoder?.call(value) ?? value;
    }
  }

  /// Add a value directly without null check
  void add(String key, Object? value) {
    _map[key] = value;
  }

  /// Build the final map, returns empty map if no values were added
  Map<String, Object?> build() => _map;
}
