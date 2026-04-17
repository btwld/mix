import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/schema_wire_types.dart';
import 'variant_condition_definition.dart';

AckSchema<ContextVariantLeaf> buildContextVariantLeafSchema({
  required SchemaVariant type,
}) {
  return variantConditionDefinition(type).buildLeafSchema();
}

AckSchema<VariantStyle<S>> buildContextVariantStyleBranch<
  S extends Spec<S>,
  T extends Style<S>
>({required SchemaVariant type, required AckSchema<T> styleSchema}) {
  return variantConditionDefinition(type).buildVariantSchema(styleSchema);
}
