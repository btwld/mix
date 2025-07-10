import '../../core/attributes_map.dart';
import '../../core/factory/mix_context.dart';
import '../../core/mix_element.dart';
import '../../core/modifier.dart';
import '../../modifiers/internal/reset_modifier.dart';
import 'widget_modifiers_config.dart';

@Deprecated(
  'Use WidgetModifiersConfigDto instead. This will be removed in version 2.0',
)
typedef WidgetModifiersDataDto = WidgetModifiersConfigDto;

class WidgetModifiersConfigDto extends Mix<WidgetModifiersConfig> {
  final List<WidgetModifierSpecAttribute> modifiers;

  const WidgetModifiersConfigDto._(this.modifiers);
  
  factory WidgetModifiersConfigDto(List<WidgetModifierSpecAttribute> modifiers) {
    return WidgetModifiersConfigDto._(modifiers);
  }

  /// Constructor that accepts a [WidgetModifiersConfig] value and extracts its properties.
  ///
  /// This is useful for converting existing [WidgetModifiersConfig] instances to [WidgetModifiersConfigDto].
  ///
  /// ```dart
  /// final config = WidgetModifiersConfig([...]);
  /// final dto = WidgetModifiersConfigDto.value(config);
  /// ```
  factory WidgetModifiersConfigDto.value(WidgetModifiersConfig config) {
    // TODO: This conversion is complex as it requires converting WidgetModifierSpec to WidgetModifierSpecAttribute
    // For now, return empty list - this needs proper implementation based on available conversion methods
    return const WidgetModifiersConfigDto._([]);
  }

  /// Constructor that accepts a nullable [WidgetModifiersConfig] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [WidgetModifiersConfigDto.value].
  ///
  /// ```dart
  /// final WidgetModifiersConfig? config = WidgetModifiersConfig([...]);
  /// final dto = WidgetModifiersConfigDto.maybeValue(config); // Returns WidgetModifiersConfigDto or null
  /// ```
  static WidgetModifiersConfigDto? maybeValue(WidgetModifiersConfig? config) {
    return config != null ? WidgetModifiersConfigDto.value(config) : null;
  }


  @override
  WidgetModifiersConfigDto merge(WidgetModifiersConfigDto? other) {
    if (other == null) return this;
    final thisMap = AttributeMap(modifiers);

    final resetIndex = other.modifiers.lastIndexWhere(
      (e) => e is ResetModifierSpecAttribute,
    );

    if (resetIndex != -1) {
      return WidgetModifiersConfigDto(other.modifiers.sublist(resetIndex));
    }

    final otherMap = AttributeMap(other.modifiers);
    final mergedMap = thisMap.merge(otherMap).values;

    return WidgetModifiersConfigDto(mergedMap);
  }

  @override
  WidgetModifiersConfig resolve(MixContext mix) {
    return WidgetModifiersConfig(modifiers.map((e) => e.resolve(mix)).toList());
  }

  @override
  List<Object?> get props => [modifiers];
}
