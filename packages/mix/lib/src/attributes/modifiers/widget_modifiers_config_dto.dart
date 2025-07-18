import 'package:flutter/widgets.dart';

import '../../core/attribute.dart';
import '../../core/attributes_map.dart';
import '../../core/mix_element.dart';
import '../../core/modifier.dart';
import '../../modifiers/internal/reset_modifier.dart';
import 'widget_modifiers_config.dart';

@Deprecated(
  'Use WidgetModifiersConfigDto instead. This will be removed in version 2.0',
)
typedef WidgetModifiersDataDto = WidgetModifiersConfigDto;

class WidgetModifiersConfigDto extends Mix<WidgetModifiersConfig> {
  final List<WidgetModifierSpecAttribute>? modifiers;

  const WidgetModifiersConfigDto.props({this.modifiers});

  factory WidgetModifiersConfigDto({
    List<WidgetModifierSpecAttribute>? modifiers,
  }) {
    return WidgetModifiersConfigDto.props(modifiers: modifiers);
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
    return const WidgetModifiersConfigDto.props();
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

    final thisModifiers = modifiers ?? <WidgetModifierSpecAttribute>[];
    final otherModifiers = other.modifiers ?? <WidgetModifierSpecAttribute>[];

    final thisMap = AttributeMap(thisModifiers);

    final resetIndex = otherModifiers.lastIndexWhere(
      (e) => e is ResetModifierSpecAttribute,
    );

    if (resetIndex != -1) {
      return WidgetModifiersConfigDto(
        modifiers: otherModifiers.sublist(resetIndex),
      );
    }

    final otherMap = AttributeMap(otherModifiers);
    final mergedMap = thisMap.merge(otherMap).values;

    return WidgetModifiersConfigDto(modifiers: mergedMap);
  }

  @override
  WidgetModifiersConfig resolve(BuildContext context) {
    final resolvedModifiers =
        modifiers?.map((e) => e.resolve(context)).toList() ??
        <WidgetModifierSpec>[];

    return WidgetModifiersConfig(resolvedModifiers);
  }

  @override
  List<Object?> get props => [modifiers];
}
