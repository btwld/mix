import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/schema_wire_types.dart';
import '../../registry/registry_catalog.dart';
import '../../registry/registry_value_codec.dart';
import 'context_variant_leaf_schema.dart';
import 'variant_condition_definition.dart';
import 'variant_condition_schema.dart';

DiscriminatedObjectSchema<VariantStyle<S>>
buildVariantSchema<S extends Spec<S>, T extends Style<S>>({
  required AckSchema<JsonMap, T> styleSchema,
  required T emptyStyle,
  required RegistryCatalog registries,
}) {
  return Ack.discriminated<VariantStyle<S>>(
    discriminatorKey: 'type',
    schemas: {
      for (final type in SchemaVariant.values)
        type.wireValue: _buildVariantBranch<S, T>(
          type: type,
          styleSchema: styleSchema,
          emptyStyle: emptyStyle,
          registries: registries,
        ),
    },
  );
}

CodecSchema<JsonMap, VariantStyle<S>>
_buildVariantBranch<S extends Spec<S>, T extends Style<S>>({
  required SchemaVariant type,
  required AckSchema<JsonMap, T> styleSchema,
  required T emptyStyle,
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
          final leaves = (data['conditions']! as List)
              .cast<ContextVariantLeaf>();
          final conditions = ContextConditionSet.compound(leaves);

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
      final builderCodec = registryValueCodec<T Function(BuildContext)>(
        registries: registries,
        scope: .contextVariantBuilder,
        valueLabel: '$T Function(BuildContext)',
      );

      return Ack.codec<JsonMap, JsonMap, VariantStyle<S>>(
        input: Ack.object({'id': builderCodec}),
        output: Ack.instance<VariantStyle<S>>().refine(
          (value) => value.variant is ContextVariantBuilder,
          message: 'Variant style does not match context_variant_builder.',
        ),
        decode: (data) {
          final fn = data['id']! as T Function(BuildContext);

          return VariantStyle<S>(ContextVariantBuilder<T>(fn), emptyStyle);
        },
        encode: (value) {
          final variant = value.variant;
          if (variant is! ContextVariantBuilder) {
            throw ArgumentError('Expected a context_variant_builder variant.');
          }

          return {
            'type': type.wireValue,
            'id': variant.fn as T Function(BuildContext),
          };
        },
      );
  }
}
