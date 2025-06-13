import 'package:flutter/foundation.dart';

import '../../core/attributes_map.dart';
import '../../core/element.dart';
import '../../core/factory/mix_data.dart';
import '../../core/modifier.dart';
import '../../modifiers/internal/reset_modifier.dart';
import 'widget_modifiers_data.dart';

class WidgetModifiersDataDto extends Mixable<WidgetModifiersData> {
  final List<WidgetModifierSpecAttribute> value;

  const WidgetModifiersDataDto(this.value);

  @override
  WidgetModifiersDataDto merge(WidgetModifiersDataDto? other) {
    if (other == null) return this;
    final thisMap = AttributeMap(value);

    final resetIndex =
        other.value.lastIndexWhere((e) => e is ResetModifierSpecAttribute);

    if (resetIndex != -1) {
      return WidgetModifiersDataDto(other.value.sublist(resetIndex));
    }

    final otherMap = AttributeMap(other.value);
    final mergedMap = thisMap.merge(otherMap).values;

    return WidgetModifiersDataDto(mergedMap);
  }

  @override
  WidgetModifiersData resolve(MixData mix) {
    return WidgetModifiersData(value.map((e) => e.resolve(mix)).toList());
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
