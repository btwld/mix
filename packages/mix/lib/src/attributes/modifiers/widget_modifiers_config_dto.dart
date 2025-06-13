import 'package:flutter/foundation.dart';

import '../../core/attributes_map.dart';
import '../../core/element.dart';
import '../../core/factory/mix_data.dart';
import '../../core/modifier.dart';
import '../../modifiers/internal/reset_modifier.dart';
import 'widget_modifiers_config.dart';

@Deprecated(
    'Use WidgetModifiersConfigDto instead. This will be removed in version 2.0')
typedef WidgetModifiersDataDto = WidgetModifiersConfigDto;

class WidgetModifiersConfigDto extends Mixable<WidgetModifiersConfig>
    with Diagnosticable {
  final List<WidgetModifierSpecAttribute> value;

  const WidgetModifiersConfigDto(this.value);

  @override
  WidgetModifiersConfigDto merge(WidgetModifiersConfigDto? other) {
    if (other == null) return this;
    final thisMap = AttributeMap(value);

    final resetIndex =
        other.value.lastIndexWhere((e) => e is ResetModifierSpecAttribute);

    if (resetIndex != -1) {
      return WidgetModifiersConfigDto(other.value.sublist(resetIndex));
    }

    final otherMap = AttributeMap(other.value);
    final mergedMap = thisMap.merge(otherMap).values;

    return WidgetModifiersConfigDto(mergedMap);
  }

  @override
  WidgetModifiersConfig resolve(MixContext mix) {
    return WidgetModifiersConfig(value.map((e) => e.resolve(mix)).toList());
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    for (var attr in value) {
      properties.add(DiagnosticsProperty(attr.runtimeType.toString(), attr));
    }
  }

  @override
  List<Object?> get props => [value];
}
