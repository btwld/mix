import 'package:flutter/widgets.dart';

import '../core/json_map.dart';
import '../schema/metadata/variant_condition_definition.dart';

JsonMap payloadWidgetStateCondition(WidgetState state) {
  return variantConditionDefinition(.widgetState).encode({'state': state});
}

JsonMap payloadEnabledCondition() {
  return variantConditionDefinition(.enabled).encode(const {});
}

JsonMap payloadBrightnessCondition(Brightness brightness) {
  return variantConditionDefinition(
    .brightness,
  ).encode({'brightness': brightness});
}

JsonMap payloadBreakpointCondition({
  double? minWidth,
  double? maxWidth,
  double? minHeight,
  double? maxHeight,
}) {
  return variantConditionDefinition(.breakpoint).encode({
    'minWidth': minWidth,
    'maxWidth': maxWidth,
    'minHeight': minHeight,
    'maxHeight': maxHeight,
  });
}

JsonMap payloadNotWidgetStateCondition(WidgetState state) {
  return variantConditionDefinition(.notWidgetState).encode({'state': state});
}
