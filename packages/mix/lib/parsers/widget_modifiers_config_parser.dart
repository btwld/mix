import '../src/attributes/modifiers/widget_modifiers_config.dart';
import 'parsers.dart';

/// Parser for [WidgetModifiersConfig] objects
///
/// Note: Individual WidgetModifierSpec objects cannot be fully serialized
/// as they contain complex widget transformation logic. This parser
/// provides basic structure serialization only.
class WidgetModifiersConfigParser extends Parser<WidgetModifiersConfig> {
  const WidgetModifiersConfigParser();

  @override
  Object? encode(WidgetModifiersConfig? value) {
    if (value == null) return null;

    // Since WidgetModifierSpec objects don't have built-in serialization,
    // we can only serialize basic metadata
    return {
      'count': value.value.length,
      'types': value.value.map((spec) => spec.runtimeType.toString()).toList(),
      // Note: Actual modifier data cannot be serialized without individual parsers
    };
  }

  @override
  WidgetModifiersConfig? decode(Object? json) {
    if (json == null) return null;
    if (json is! Map<String, Object?>) {
      throw FormatException(
        'Expected Map<String, Object?>, got ${json.runtimeType}',
      );
    }

    // Cannot reconstruct WidgetModifierSpec objects without individual parsers
    // This is a limitation that requires implementing specific parsers for each modifier type

    // Return empty config for now - actual implementation would need
    // individual parsers for each WidgetModifierSpec subtype
    return const WidgetModifiersConfig([]);
  }
}
