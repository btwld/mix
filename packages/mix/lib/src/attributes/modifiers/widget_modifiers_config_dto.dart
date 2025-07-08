import '../../core/attributes_map.dart';
import '../../core/element.dart';
import '../../core/factory/mix_context.dart';
import '../../core/modifier.dart';
import '../../modifiers/internal/reset_modifier.dart';
import 'widget_modifiers_config.dart';

@Deprecated(
  'Use WidgetModifiersConfigDto instead. This will be removed in version 2.0',
)
typedef WidgetModifiersDataDto = WidgetModifiersConfigDto;

class WidgetModifiersConfigDto extends Mixable<WidgetModifiersConfig> {
  final List<WidgetModifierSpecAttribute> modifiers;

  const WidgetModifiersConfigDto(this.modifiers);

  /// Creates a WidgetModifiersConfigDto from a WidgetModifiersConfig value
  /// 
  /// Note: This method cannot be implemented because WidgetModifiersConfig contains
  /// resolved WidgetModifierSpec objects, but the DTO requires unresolved 
  /// WidgetModifierSpecAttribute objects. This conversion is not possible.
  factory WidgetModifiersConfigDto.from(WidgetModifiersConfig config) {
    throw UnimplementedError(
      'Cannot create WidgetModifiersConfigDto from WidgetModifiersConfig. '
      'WidgetModifiersConfig contains resolved WidgetModifierSpec objects, '
      'but WidgetModifiersConfigDto requires unresolved WidgetModifierSpecAttribute objects.',
    );
  }

  /// Creates a WidgetModifiersConfigDto from a nullable WidgetModifiersConfig value
  /// Returns null if the value is null, otherwise uses WidgetModifiersConfigDto.from
  /// 
  /// Note: This method cannot be implemented because WidgetModifiersConfig contains
  /// resolved WidgetModifierSpec objects, but the DTO requires unresolved 
  /// WidgetModifierSpecAttribute objects. This conversion is not possible.
  static WidgetModifiersConfigDto? maybeFrom(WidgetModifiersConfig? value) {
    return value != null ? WidgetModifiersConfigDto.from(value) : null;
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
