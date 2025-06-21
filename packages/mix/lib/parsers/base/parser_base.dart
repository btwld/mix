/// Base parser interface and utilities
/// Following KISS principle - minimal abstraction
abstract class Parser<T> {
  /// Encode a value to JSON-compatible format
  Object? encode(T? value);
  
  /// Decode from JSON to typed value
  T? decode(Object? json);
}

/// Result type for safe parsing
sealed class ParseResult<T> {
  const ParseResult();
  
  bool get isSuccess => this is ParseSuccess<T>;
  bool get isError => this is ParseError<T>;
  
  T? get valueOrNull => this is ParseSuccess<T> ? (this as ParseSuccess<T>).value : null;
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
  String toString() => 'ParseError: $message${source != null ? ' (source: $source)' : ''}';
}

/// Extension for cleaner null-safe map access
extension JsonMapExtension on Map<String, Object?>? {
  T? get<T>(String key) => this?[key] as T?;
  
  num? getNum(String key) => this?[key] as num?;
  
  double? getDouble(String key) => getNum(key)?.toDouble();
  
  int? getInt(String key) => getNum(key)?.toInt();
  
  String? getString(String key) => this?[key] as String?;
  
  Map<String, Object?>? getMap(String key) => this?[key] as Map<String, Object?>?;
  
  List<Object?>? getList(String key) => this?[key] as List<Object?>?;
}
