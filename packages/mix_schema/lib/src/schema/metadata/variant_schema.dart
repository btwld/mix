import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../contract/mix_schema_limits.dart';
import '../../core/mix_schema_scope.dart';
import '../../core/schema_wire_types.dart';
import '../../errors/schema_transform_exceptions.dart';
import '../../registry/registry_catalog.dart';
import 'context_variant_leaf_schema.dart';
import 'variant_condition_schema.dart';

DiscriminatedObjectSchema<VariantStyle<S>>
buildVariantSchema<S extends Spec<S>, T extends Style<S>>({
  required AckSchema<JsonMap, T> styleSchema,
  required T emptyStyle,
  required RegistryCatalog registries,
  required MixSchemaLimits limits,
}) {
  final conditionParser = buildVariantConditionParser();

  return Ack.discriminated<VariantStyle<S>>(
    discriminatorKey: 'type',
    schemas: {
      for (final type in SchemaVariant.values)
        type.wireValue: _buildVariantBranch<S, T>(
          type: type,
          styleSchema: styleSchema,
          emptyStyle: emptyStyle,
          conditionParser: conditionParser,
          registries: registries,
          limits: limits,
        ),
    },
  );
}

CodecSchema<JsonMap, VariantStyle<S>>
_buildVariantBranch<S extends Spec<S>, T extends Style<S>>({
  required SchemaVariant type,
  required AckSchema<JsonMap, T> styleSchema,
  required T emptyStyle,
  required VariantConditionParser conditionParser,
  required RegistryCatalog registries,
  required MixSchemaLimits limits,
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
      return Ack.codec<JsonMap, JsonMap, VariantStyle<S>>(
        input: Ack.object({'name': Ack.string(), 'style': styleSchema}),
        output: Ack.instance<VariantStyle<S>>().refine(
          (value) => value.variant is NamedVariant,
          message: 'Variant style does not match named.',
        ),
        decode: (data) => VariantStyle<S>(
          Variant.named(data['name']! as String),
          data['style']! as T,
        ),
        encode: (value) {
          final variant = value.variant;
          if (variant is! NamedVariant) {
            throw ArgumentError('Expected a named variant.');
          }

          return {
            'type': type.wireValue,
            'name': variant.name,
            'style': value.value as T,
          };
        },
      );
    case .contextAllOf:
      return Ack.codec<JsonMap, JsonMap, VariantStyle<S>>(
        input: Ack.object({
          'conditions': buildContextConditionListSchema(),
          'style': styleSchema,
        }),
        output: Ack.instance<VariantStyle<S>>().refine((value) {
          final conditionSet = contextConditionSetFromVariant(value.variant);

          return conditionSet != null && conditionSet.leaves.length >= 2;
        }, message: 'Variant style does not match context_all_of.'),
        decode: (data) {
          final conditions = ContextConditionSet.compound(
            conditionParser.parseList(
              (data['conditions']! as List<Object?>).toList(growable: false),
            ),
          );

          return VariantStyle<S>(conditions.toVariant(), data['style']! as T);
        },
        encode: (value) {
          final conditionSet = contextConditionSetFromVariant(value.variant);
          if (conditionSet == null || conditionSet.leaves.length < 2) {
            throw ArgumentError('Expected a context_all_of variant.');
          }

          return {
            'type': type.wireValue,
            'conditions': conditionSet.leaves,
            'style': value.value as T,
          };
        },
      );
    case .contextBuilder:
      return Ack.codec<JsonMap, JsonMap, VariantStyle<S>>(
        input: Ack.object({
          'id': Ack.string().maxLength(limits.maxRegistryIdLength),
        }),
        output: Ack.instance<VariantStyle<S>>().refine(
          (value) => value.variant is ContextVariantBuilder,
          message: 'Variant style does not match context_variant_builder.',
        ),
        decode: (data) {
          final fn = registries.lookup<T Function(BuildContext)>(
            MixSchemaScope.contextVariantBuilder.wireValue,
            data['id']! as String,
          );

          return VariantStyle<S>(ContextVariantBuilder<T>(fn), emptyStyle);
        },
        encode: (value) {
          final variant = value.variant;
          if (variant is! ContextVariantBuilder) {
            throw ArgumentError('Expected a context_variant_builder variant.');
          }

          final key = registries.keyOf<T Function(BuildContext)>(
            MixSchemaScope.contextVariantBuilder.wireValue,
            variant.fn as T Function(BuildContext),
          );
          if (key == null) {
            throw RegistryValueLookupError(
              scope: MixSchemaScope.contextVariantBuilder.wireValue,
              expectedType: '$T Function(BuildContext)',
              value: variant.fn,
            );
          }

          return {'type': type.wireValue, 'id': key};
        },
      );
  }
}
