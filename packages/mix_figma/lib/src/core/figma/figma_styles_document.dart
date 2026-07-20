import '../json_map.dart';

/// Local style kinds with values available through the Plugin API.
enum FigmaStyleType { text, effect, paint }

/// One values-bearing local style.
final class FigmaStyle {
  final String id;

  final String key;
  final String name;
  final FigmaStyleType type;
  final JsonMap value;
  final JsonMap pluginData;
  final String description;
  final bool remote;
  FigmaStyle({
    required this.id,
    required this.key,
    required this.name,
    required this.type,
    required JsonMap value,
    JsonMap pluginData = const {},
    this.description = '',
    this.remote = false,
  }) : value = Map.unmodifiable(value),
       pluginData = Map.unmodifiable(pluginData);
}

/// Values-bearing style document emitted by the Figma plugin.
final class FigmaStylesDocument {
  final List<FigmaStyle> styles;

  FigmaStylesDocument({required Iterable<FigmaStyle> styles})
    : styles = List.unmodifiable(styles);
}
