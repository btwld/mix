import 'parser_base.dart';

/// Generic parser for all enum types following KISS principle
/// Reduces code duplication by handling all enum parsing in one place
class EnumParser<T extends Enum> implements Parser<T> {
  /// The list of all enum values for type T
  final List<T> values;

  /// Optional custom name encoder (defaults to using .name property)
  final String Function(T)? customEncoder;

  const EnumParser(this.values, {this.customEncoder});

  @override
  Object? encode(T? value) {
    if (value == null) return null;

    // Use custom encoder if provided, otherwise use .name
    return customEncoder?.call(value) ?? value.name;
  }

  @override
  T? decode(Object? json) {
    if (json == null) return null;
    if (json is! String) return null;

    // Find enum by name/custom encoding
    try {
      return values.firstWhere(
        (e) => (customEncoder?.call(e) ?? e.name) == json,
      );
    } catch (_) {
      return null;
    }
  }
}
