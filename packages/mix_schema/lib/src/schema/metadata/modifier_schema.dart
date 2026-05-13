import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/schema_wire_types.dart';
import 'modifier_definition.dart';

AckSchema<ModifierMix> buildModifierSchema() {
  return Ack.discriminated<ModifierMix>(
    discriminatorKey: 'type',
    schemas: {
      for (final definition in modifierDefinitions.values)
        definition.type.wireValue: definition.codec,
    },
  );
}

WidgetModifierConfig? buildWidgetModifierConfigFromFields(
  Map<String, Object?> data,
) {
  final List<ModifierMix>? modifiers = castListOrNull(data['modifiers']);
  final List<String>? wireOrder = castListOrNull(data['modifierOrder']);

  if (modifiers == null && wireOrder == null) {
    return null;
  }

  final orderOfModifiers = wireOrder
      ?.map(_modifierRuntimeTypeFromWireValue)
      .toList(growable: false);

  return WidgetModifierConfig(
    modifiers: modifiers ?? const [],
    orderOfModifiers: orderOfModifiers == null || orderOfModifiers.isEmpty
        ? null
        : orderOfModifiers,
  );
}

Type _modifierRuntimeTypeFromWireValue(String wireValue) {
  final type = SchemaModifier.fromWireValue(wireValue);
  if (type == null) {
    throw ArgumentError.value(
      wireValue,
      'modifierOrder',
      'Unknown modifierOrder value',
    );
  }

  return modifierRuntimeType(type);
}
