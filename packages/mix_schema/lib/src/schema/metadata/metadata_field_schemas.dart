import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/schema_wire_types.dart';

const animationMetadataField = 'animation';
const modifiersMetadataField = 'modifiers';
const modifierOrderMetadataField = 'modifierOrder';
const variantsMetadataField = 'variants';

Map<String, AckSchema> buildVariantStyleMetadataFieldSchemas({
  required AckSchema<ModifierMix> modifierSchema,
}) {
  return {
    modifiersMetadataField: Ack.list(modifierSchema).optional(),
    modifierOrderMetadataField: Ack.list(
      Ack.enumString(_modifierTypeValues),
    ).optional(),
  };
}

Map<String, AckSchema> buildMetadataFieldSchemas({
  required AckSchema<CurveAnimationConfig> animationSchema,
  required AckSchema<ModifierMix> modifierSchema,
  required AckSchema variantSchema,
}) {
  return {
    animationMetadataField: animationSchema.optional(),
    ...buildVariantStyleMetadataFieldSchemas(modifierSchema: modifierSchema),
    variantsMetadataField: Ack.list(variantSchema).optional(),
  };
}

final List<String> _modifierTypeValues = List.unmodifiable(
  SchemaModifier.values.map((modifier) => modifier.wireValue),
);
