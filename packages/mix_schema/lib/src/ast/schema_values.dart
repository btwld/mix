/// All values in the AST resolve through this hierarchy.
///
/// The resolution strategy for each type is documented in the executable plan §4.
sealed class SchemaValue {
  const SchemaValue();
}

/// Literal value — used directly at render time.
final class DirectValue<T> extends SchemaValue {
  final T value;

  const DirectValue(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DirectValue<T> && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'DirectValue($value)';
}

/// Token reference — resolves through MixScope at render time.
///
/// Wire format: `{"token": {"type": "color", "name": "primary"}}`
/// Shorthand: `"color.primary"` (normalized by adapter)
final class TokenRef extends SchemaValue {
  final String type; // "color", "space", "radius", "textStyle", etc.
  final String name; // "primary", "surface.container", etc.

  const TokenRef({required this.type, required this.name});

  /// Dotted name for Mix token lookup: "color.primary"
  String get tokenName => '$type.$name';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenRef && type == other.type && name == other.name;

  @override
  int get hashCode => Object.hash(type, name);

  @override
  String toString() => 'TokenRef($tokenName)';
}

/// Brightness-adaptive value — resolves based on theme mode.
///
/// Wire format: `{"adaptive": {"light": "#000000", "dark": "#FFFFFF"}}`
final class AdaptiveValue extends SchemaValue {
  final SchemaValue light;
  final SchemaValue dark;

  const AdaptiveValue({required this.light, required this.dark});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveValue && light == other.light && dark == other.dark;

  @override
  int get hashCode => Object.hash(light, dark);

  @override
  String toString() => 'AdaptiveValue(light: $light, dark: $dark)';
}

/// Viewport-responsive value — resolves based on breakpoint.
///
/// Wire format: `{"responsive": {"mobile": 8, "tablet": 16, "desktop": 24}}`
final class ResponsiveValue extends SchemaValue {
  final Map<String, SchemaValue> breakpoints; // "mobile", "tablet", "desktop"

  const ResponsiveValue(this.breakpoints);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsiveValue &&
          _mapsEqual(breakpoints, other.breakpoints);

  @override
  int get hashCode => Object.hashAll(breakpoints.entries);

  @override
  String toString() => 'ResponsiveValue($breakpoints)';
}

/// Data binding — resolves from SchemaDataContext at render time.
///
/// Wire format: `{"bind": "user.displayName"}`
final class BindingValue extends SchemaValue {
  final String path; // JSON Pointer or dot-path

  const BindingValue(this.path);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BindingValue && path == other.path;

  @override
  int get hashCode => path.hashCode;

  @override
  String toString() => 'BindingValue($path)';
}

/// Transform — binding + closed-registry transform.
///
/// Wire format: `{"bind": "price", "transform": "currency"}`
final class TransformValue extends SchemaValue {
  final String path;
  final String transformKey; // must exist in closed registry

  const TransformValue({required this.path, required this.transformKey});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransformValue &&
          path == other.path &&
          transformKey == other.transformKey;

  @override
  int get hashCode => Object.hash(path, transformKey);

  @override
  String toString() => 'TransformValue($path, transform: $transformKey)';
}

// Private helper for map equality
bool _mapsEqual<K, V>(Map<K, V> a, Map<K, V> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}
