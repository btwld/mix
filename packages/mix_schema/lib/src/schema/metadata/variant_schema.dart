import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../contract/mix_schema_limits.dart';
import '../../core/mix_schema_scope.dart';
import '../../core/schema_wire_types.dart';
import '../../errors/schema_transform_exceptions.dart';
import '../../registry/registry_catalog.dart';
import 'context_variant_leaf_schema.dart';
import 'variant_condition_definition.dart';
import 'variant_condition_schema.dart';

AckSchema<VariantStyle<S>>
buildVariantSchema<S extends Spec<S>, T extends Style<S>>({
  required AckSchema<T> styleSchema,
  required T emptyStyle,
  required RegistryCatalog registries,
  required MixSchemaLimits limits,
}) {
  final conditionParser = buildVariantConditionParser();
  final branchSchemas = {
    for (final type in SchemaVariant.values)
      type: _buildVariantBranch<S, T>(
        type: type,
        styleSchema: styleSchema,
        emptyStyle: emptyStyle,
        conditionParser: conditionParser,
        registries: registries,
        limits: limits,
      ),
  };
  final inputSchema = Ack.discriminated<Map<String, Object?>>(
    discriminatorKey: 'type',
    schemas: {
      for (final entry in branchSchemas.entries)
        entry.key.wireValue: entry.value.inputSchema,
    },
  );

  return Ack.codec<Map<String, Object?>, VariantStyle<S>>(
    input: inputSchema,
    output: Ack.instance<VariantStyle<S>>(),
    decoder: (data) {
      return _decodeVariantStyle(
        data,
        styleSchema: styleSchema,
        emptyStyle: emptyStyle,
        conditionParser: conditionParser,
        registries: registries,
      );
    },
    encoder: (value) {
      return _encodeVariantStyle<S, T>(value, registries: registries);
    },
  );
}

CodecSchema<Map<String, Object?>, VariantStyle<S>>
_buildVariantBranch<S extends Spec<S>, T extends Style<S>>({
  required SchemaVariant type,
  required AckSchema<T> styleSchema,
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
      return Ack.codec<Map<String, Object?>, VariantStyle<S>>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'name': Ack.string(),
          'style': styleSchema,
        }),
        output: Ack.instance<VariantStyle<S>>().refine(
          (value) => value.variant is NamedVariant,
          message: 'Variant style does not match named.',
        ),
        decoder: (data) {
          final map = data;

          return VariantStyle<S>(
            Variant.named(map['name'] as String),
            map['style'] as T,
          );
        },
        encoder: (value) {
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
      return Ack.codec<Map<String, Object?>, VariantStyle<S>>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'conditions': buildContextConditionListSchema(),
          'style': styleSchema,
        }),
        output: Ack.instance<VariantStyle<S>>().refine((value) {
          final conditionSet = contextConditionSetFromVariant(value.variant);

          return conditionSet != null && conditionSet.leaves.length >= 2;
        }, message: 'Variant style does not match context_all_of.'),
        decoder: (data) {
          final map = data;
          final conditions = ContextConditionSet.compound(
            conditionParser.parseList(
              (map['conditions'] as List<Object?>).toList(growable: false),
            ),
          );

          return VariantStyle<S>(conditions.toVariant(), map['style'] as T);
        },
        encoder: (value) {
          final conditionSet = contextConditionSetFromVariant(value.variant);
          if (conditionSet == null || conditionSet.leaves.length < 2) {
            throw ArgumentError('Expected a context_all_of variant.');
          }

          return {
            'type': type.wireValue,
            'conditions': encodeContextConditionSet(conditionSet),
            'style': value.value as T,
          };
        },
      );
    case .contextBuilder:
      return Ack.codec<Map<String, Object?>, VariantStyle<S>>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'id': Ack.string().maxLength(limits.maxRegistryIdLength),
        }),
        output: Ack.instance<VariantStyle<S>>().refine(
          (value) => value.variant is ContextVariantBuilder,
          message: 'Variant style does not match context_variant_builder.',
        ),
        decoder: (data) {
          final map = data;
          final fn = registries.lookup<T Function(BuildContext)>(
            MixSchemaScope.contextVariantBuilder.wireValue,
            map['id'] as String,
          );

          return VariantStyle<S>(ContextVariantBuilder<T>(fn), emptyStyle);
        },
        encoder: (value) {
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

VariantStyle<S> _decodeVariantStyle<S extends Spec<S>, T extends Style<S>>(
  Map<String, Object?> data, {
  required AckSchema<T> styleSchema,
  required T emptyStyle,
  required VariantConditionParser conditionParser,
  required RegistryCatalog registries,
}) {
  final type = _variantTypeFromWireValue(data['type'] as String);

  switch (type) {
    case .widgetState ||
        .enabled ||
        .brightness ||
        .breakpoint ||
        .notWidgetState:
      final branch = variantConditionDefinition(
        type,
      ).buildVariantSchema<S, T>(styleSchema);

      return branch.decoder(data);
    case .named:
      return VariantStyle<S>(
        Variant.named(data['name'] as String),
        data['style'] as T,
      );
    case .contextAllOf:
      final conditions = ContextConditionSet.compound(
        conditionParser.parseList(
          (data['conditions'] as List<Object?>).toList(growable: false),
        ),
      );

      return VariantStyle<S>(conditions.toVariant(), data['style'] as T);
    case .contextBuilder:
      final fn = registries.lookup<T Function(BuildContext)>(
        MixSchemaScope.contextVariantBuilder.wireValue,
        data['id'] as String,
      );

      return VariantStyle<S>(ContextVariantBuilder<T>(fn), emptyStyle);
  }
}

Map<String, Object?> _encodeVariantStyle<S extends Spec<S>, T extends Style<S>>(
  VariantStyle<S> value, {
  required RegistryCatalog registries,
}) {
  final variant = value.variant;

  if (variant is NamedVariant) {
    return {
      'type': SchemaVariant.named.wireValue,
      'name': variant.name,
      'style': value.value,
    };
  }

  final conditionSet = contextConditionSetFromVariant(variant);
  if (conditionSet != null) {
    return {
      'type': SchemaVariant.contextAllOf.wireValue,
      'conditions': encodeContextConditionSet(conditionSet),
      'style': value.value,
    };
  }

  if (variant is ContextVariantBuilder) {
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

    return {'type': SchemaVariant.contextBuilder.wireValue, 'id': key};
  }

  if (variant is ContextVariant) {
    final definition = _variantConditionDefinitionForVariant(variant);

    return {
      'type': definition.type.wireValue,
      ...definition.encodeLeafFields(
        ContextVariantLeaf(variant: variant, canonicalKey: variant.key),
      ),
      'style': value.value,
    };
  }

  throw ArgumentError('Variant cannot be encoded.');
}

VariantConditionDefinition _variantConditionDefinitionForVariant(
  Variant variant,
) {
  for (final definition in variantConditionDefinitions.values) {
    if (definition.matchesVariant(variant)) {
      return definition;
    }
  }

  throw ArgumentError('Context variant cannot be encoded.');
}

SchemaVariant _variantTypeFromWireValue(String wireValue) {
  for (final type in SchemaVariant.values) {
    if (type.wireValue == wireValue) return type;
  }

  throw ArgumentError.value(wireValue, 'type', 'Unknown variant type');
}
