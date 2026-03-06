import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../core/json_map.dart';
import '../core/schema_wire_types.dart';
import '../errors/mix_schema_decode_result.dart';
import '../errors/schema_error_mapper.dart';
import '../registry/frozen_registry.dart';
import '../registry/registry_catalog.dart';
import '../registry/styler_registry.dart';
import '../schema/builtins/box_schema.dart';
import '../schema/builtins/flex_box_schema.dart';
import '../schema/builtins/flex_schema.dart';
import '../schema/builtins/icon_schema.dart';
import '../schema/builtins/image_schema.dart';
import '../schema/builtins/stack_box_schema.dart';
import '../schema/builtins/stack_schema.dart';
import '../schema/builtins/text_schema.dart';
import '../schema/mix_schema_catalog.dart';
import '../schema/styler_definition.dart';

/// Decodes payload maps into Mix styling objects.
///
/// The decoder consumes a frozen [StylerRegistry] so that runtime payload
/// dispatch is deterministic and cannot change during decode.
final class MixSchemaDecoder {
  final StylerRegistry _stylerRegistry;

  final SchemaErrorMapper _errorMapper = const SchemaErrorMapper();

  MixSchemaDecoder({required StylerRegistry stylerRegistry})
    : _stylerRegistry = stylerRegistry {
    if (!stylerRegistry.isFrozen) {
      throw StateError('StylerRegistry must be frozen before decode.');
    }
  }

  /// Builds a decoder with the built-in styler set and the provided registries.
  factory MixSchemaDecoder.builtIn({
    Iterable<FrozenRegistry<Object>> registries = const [],
  }) {
    final registryCatalog = RegistryCatalog(registries);
    final catalog = MixSchemaCatalog(registries: registryCatalog);
    final stylerRegistry = StylerRegistry();

    for (final type in SchemaStyler.values) {
      _registerBuiltInStyler(
        registry: stylerRegistry,
        catalog: catalog,
        type: type,
      );
    }

    stylerRegistry.freeze();

    return MixSchemaDecoder(stylerRegistry: stylerRegistry);
  }

  /// Validates and decodes a payload into a Mix runtime object.
  MixSchemaDecodeResult<Object> decode(JsonMap payload) {
    final result = _stylerRegistry.decode(payload);

    return result.match(
      onOk: (value) => MixSchemaDecodeResult.success(value!),
      onFail: (error) => MixSchemaDecodeResult.failure(_errorMapper.map(error)),
    );
  }
}

void _registerBuiltInStyler({
  required StylerRegistry registry,
  required MixSchemaCatalog catalog,
  required SchemaStyler type,
}) {
  final schema = _buildBuiltInSchema(catalog: catalog, type: type);
  registry.register(type.wireValue, schema);
}

AckSchema<Object> _buildBuiltInSchema({
  required MixSchemaCatalog catalog,
  required SchemaStyler type,
}) {
  return switch (type) {
    .box => _fullSchema(buildBoxStylerDefinition(catalog), catalog),
    .text => _fullSchema(buildTextStylerDefinition(catalog), catalog),
    .flex => _fullSchema(buildFlexStylerDefinition(catalog), catalog),
    .icon => _fullSchema(buildIconStylerDefinition(catalog), catalog),
    .image => _fullSchema(buildImageStylerDefinition(catalog), catalog),
    .stack => _fullSchema(buildStackStylerDefinition(catalog), catalog),
    .flexBox => _fullSchema(buildFlexBoxStylerDefinition(catalog), catalog),
    .stackBox => _fullSchema(buildStackBoxStylerDefinition(catalog), catalog),
  };
}

AckSchema<Object> _fullSchema<S extends Spec<S>, T extends Style<S>>(
  StylerDefinition<S, T> definition,
  MixSchemaCatalog catalog,
) {
  return buildStylerSchemas(definition: definition, catalog: catalog).fullSchema
      as AckSchema<Object>;
}
