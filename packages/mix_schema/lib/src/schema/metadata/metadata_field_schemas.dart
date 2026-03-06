import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

Map<String, AckSchema> buildMetadataFieldSchemas({
  required AckSchema<CurveAnimationConfig> animationSchema,
  required AckSchema<ModifierMix> modifierSchema,
  required AckSchema variantSchema,
}) {
  return {
    'animation': animationSchema.optional(),
    'modifiers': Ack.list(modifierSchema).optional(),
    'modifierOrder': Ack.list(Ack.string()).optional(),
    'variants': Ack.list(variantSchema).optional(),
  };
}
