import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/schema_wire_types.dart';
import '../discriminated_branch_registry.dart';
import 'modifier_definition.dart';

AckSchema<ModifierMix> buildModifierSchema() {
  final registry = DiscriminatedBranchRegistry<ModifierMix>(
    discriminatorKey: 'type',
  );

  for (final definition in modifierDefinitions.values) {
    registry.register(definition.type.wireValue, definition.schema);
  }

  return registry.freeze();
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
      ?.map(SchemaModifier.fromWireValue)
      .whereType<SchemaModifier>()
      .map(modifierRuntimeType)
      .toList(growable: false);

  return WidgetModifierConfig(
    modifiers: modifiers ?? const [],
    orderOfModifiers: orderOfModifiers == null || orderOfModifiers.isEmpty
        ? null
        : orderOfModifiers,
  );
}
