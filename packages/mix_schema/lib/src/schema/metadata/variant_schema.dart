import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/mix_schema_scope.dart';
import '../../core/schema_wire_types.dart';
import '../../registry/registry_catalog.dart';
import '../discriminated_schema_builder.dart';
import 'context_variant_leaf_schema.dart';
import 'variant_condition_schema.dart';

AckSchema<VariantStyle<S>>
buildVariantSchema<S extends Spec<S>, T extends Style<S>>({
  required AckSchema<T> styleSchema,
  required T emptyStyle,
  required RegistryCatalog registries,
}) {
  final conditionParser = buildVariantConditionParser();

  return buildDiscriminatedSchema<VariantStyle<S>>(
    discriminatorKey: 'type',
    branches: [
      for (final type in SchemaVariant.values)
        discriminatedBranch<VariantStyle<S>, VariantStyle<S>>(
          type: type.wireValue,
          schema: _buildVariantBranch(
            type: type,
            styleSchema: styleSchema,
            emptyStyle: emptyStyle,
            conditionParser: conditionParser,
            registries: registries,
          ),
        ),
    ],
  );
}

AckSchema<VariantStyle<S>>
_buildVariantBranch<S extends Spec<S>, T extends Style<S>>({
  required SchemaVariant type,
  required AckSchema<T> styleSchema,
  required T emptyStyle,
  required VariantConditionParser conditionParser,
  required RegistryCatalog registries,
}) {
  switch (type) {
    case .widgetState ||
        .enabled ||
        .brightness ||
        .breakpoint ||
        .notWidgetState:
      return buildContextVariantStyleBranch(
        type: type,
        styleSchema: styleSchema,
      );
    case .named:
      return Ack.object({
        'name': Ack.string(),
        'style': styleSchema,
      }).transform<VariantStyle<S>>((data) {
        final map = data;

        return VariantStyle<S>(
          Variant.named(map['name'] as String),
          map['style'] as T,
        );
      });
    case .contextAllOf:
      return Ack.object({
        'conditions': buildContextConditionListSchema(),
        'style': styleSchema,
      }).transform<VariantStyle<S>>((data) {
        final map = data;
        final conditions = ContextConditionSet.compound(
          conditionParser.parseList(
            (map['conditions'] as List<Object?>).toList(growable: false),
          ),
        );

        return VariantStyle<S>(conditions.toVariant(), map['style'] as T);
      });
    case .contextBuilder:
      return Ack.object({'id': Ack.string()}).transform<VariantStyle<S>>((
        data,
      ) {
        final map = data;
        final fn = registries.lookup<T Function(BuildContext)>(
          MixSchemaScope.contextVariantBuilder.wireValue,
          map['id'] as String,
        );

        return VariantStyle<S>(ContextVariantBuilder<T>(fn), emptyStyle);
      });
  }
}
