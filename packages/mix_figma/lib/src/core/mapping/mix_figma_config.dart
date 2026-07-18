import 'package:yaml/yaml.dart';

/// Protocol groups that can receive a primitive Figma FLOAT variable.
enum MixFigmaFloatGroup { spaces, doubles, radii, fontWeights }

/// User overrides for mappings that cannot be inferred from Figma metadata.
final class MixFigmaConfig {
  final Map<String, MixFigmaFloatGroup> floatGroupsByVariable;

  final Map<String, MixFigmaFloatGroup> floatGroupsByCollection;

  const MixFigmaConfig({
    this.floatGroupsByVariable = const {},
    this.floatGroupsByCollection = const {},
  });

  factory MixFigmaConfig.fromYaml(String source) {
    final root = loadYaml(source);
    if (root == null) return const MixFigmaConfig();
    if (root is! Map) throw const FormatException('Config must be a map.');
    final floatGroups = root['floatGroups'];
    if (floatGroups == null) return const MixFigmaConfig();
    if (floatGroups is! Map) {
      throw const FormatException('floatGroups must be a map.');
    }

    return MixFigmaConfig(
      floatGroupsByVariable: _parseOverrides(floatGroups['variables']),
      floatGroupsByCollection: _parseOverrides(floatGroups['collections']),
    );
  }
}

Map<String, MixFigmaFloatGroup> _parseOverrides(Object? value) {
  if (value == null) return const {};
  if (value is! Map) throw const FormatException('Overrides must be a map.');

  final result = <String, MixFigmaFloatGroup>{};
  for (final entry in value.entries) {
    if (entry.key is! String || entry.value is! String) {
      throw const FormatException('Override keys and values must be strings.');
    }
    result[entry.key! as String] = _parseFloatGroup(entry.value! as String);
  }

  return Map.unmodifiable(result);
}

MixFigmaFloatGroup _parseFloatGroup(String value) {
  return switch (value) {
    'spaces' || 'space' => .spaces,
    'doubles' || 'double' => .doubles,
    'radii' || 'radius' => .radii,
    'fontWeights' || 'fontWeight' => .fontWeights,
    _ => throw FormatException('Unsupported FLOAT group "$value".'),
  };
}
