import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../contract/mix_schema_limits.dart';
import '../../core/schema_wire_types.dart';

const animationMetadataField = 'animation';
const modifiersMetadataField = 'modifiers';
const modifierOrderMetadataField = 'modifierOrder';
const variantsMetadataField = 'variants';

Map<String, AckSchema> buildVariantStyleMetadataFieldSchemas({
  required AckSchema<ModifierMix> modifierSchema,
  required MixSchemaLimits limits,
}) {
  return {
    modifiersMetadataField: Ack.list(
      modifierSchema,
    ).maxLength(limits.maxModifiersPerStyler).optional(),
    modifierOrderMetadataField: Ack.list(
      Ack.enumString(_modifierTypeValues),
    ).maxLength(limits.maxModifiersPerStyler).optional(),
  };
}

Map<String, AckSchema> buildMetadataFieldSchemas({
  required AckSchema<CurveAnimationConfig> animationSchema,
  required AckSchema<ModifierMix> modifierSchema,
  required AckSchema variantSchema,
  required MixSchemaLimits limits,
}) {
  return {
    animationMetadataField: animationSchema.optional(),
    ...buildVariantStyleMetadataFieldSchemas(
      modifierSchema: modifierSchema,
      limits: limits,
    ),
    variantsMetadataField: Ack.list(
      variantSchema,
    ).maxLength(limits.maxVariantsPerStyler).optional(),
  };
}

final List<String> _modifierTypeValues = List.unmodifiable(
  SchemaModifier.values.map((modifier) => modifier.wireValue),
);
