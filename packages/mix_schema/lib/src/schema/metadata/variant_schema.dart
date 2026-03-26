import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/mix_schema_scope.dart';
import '../../core/schema_wire_types.dart';
import '../../registry/registry_catalog.dart';
import '../discriminated_branch_registry.dart';
import 'context_variant_leaf_schema.dart';
import 'variant_condition_schema.dart';

AckSchema<VariantStyle<S>>
buildVariantSchema<S extends Spec<S>, T extends Style<S>>({
  required AckSchema<T> styleSchema,
  required T emptyStyle,
  required RegistryCatalog registries,
}) {
  final conditionParser = buildVariantConditionParser();
  final registry = DiscriminatedBranchRegistry<VariantStyle<S>>(
    discriminatorKey: 'type',
  );

  for (final type in SchemaVariant.values) {
    final AckSchema<VariantStyle<S>> branch = _buildVariantBranch(
      type: type,
      styleSchema: styleSchema,
      emptyStyle: emptyStyle,
      conditionParser: conditionParser,
      registries: registries,
    );

    registry.register(type.wireValue, branch);
  }

  return registry.freeze();
}

AckSchema<VariantStyle<S>>
_buildVariantBranch<S extends Spec<S>, T extends Style<S>>({
  required SchemaVariant type,
  required AckSchema<T> styleSchema,
  required T emptyStyle,
  required VariantConditionParser conditionParser,
  required RegistryCatalog registries,
}) {
  if (sharedContextVariantLeafTypes.contains(type)) {
    return buildContextVariantStyleBranch(type: type, styleSchema: styleSchema);
  }

  switch (type) {
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
        'conditions': Ack.list(Ack.any()).refine(
          (conditions) => conditions.length >= 2,
          message: 'context_all_of requires at least two conditions.',
        ),
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
    case .widgetState ||
        .enabled ||
        .brightness ||
        .breakpoint ||
        .notWidgetState:
      throw StateError(
        'Shared context variant type should be handled earlier.',
      );
  }
}
