import 'package:flutter/widgets.dart';

import '../core/json_map.dart';
import '../core/schema_wire_types.dart';
import '../schema/metadata/variant_condition_definition.dart';

JsonMap payloadWidgetStateCondition(WidgetState state) {
  return variantConditionDefinition(
    SchemaVariant.widgetState,
  ).encode({'state': state});
}

JsonMap payloadEnabledCondition() {
  return variantConditionDefinition(SchemaVariant.enabled).encode(const {});
}

JsonMap payloadBrightnessCondition(Brightness brightness) {
  return variantConditionDefinition(
    SchemaVariant.brightness,
  ).encode({'brightness': brightness});
}

JsonMap payloadBreakpointCondition({
  double? minWidth,
  double? maxWidth,
  double? minHeight,
  double? maxHeight,
}) {
  return variantConditionDefinition(SchemaVariant.breakpoint).encode({
    'minWidth': minWidth,
    'maxWidth': maxWidth,
    'minHeight': minHeight,
    'maxHeight': maxHeight,
  });
}

JsonMap payloadNotWidgetStateCondition(WidgetState state) {
  return variantConditionDefinition(
    SchemaVariant.notWidgetState,
  ).encode({'state': state});
}
