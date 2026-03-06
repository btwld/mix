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
import '../schema/erased_styler_definition.dart';
import '../schema/mix_schema_catalog.dart';

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
      final definition = _selectBuiltInStylerDefinition(
        catalog: catalog,
        type: type,
      );

      _registerBuiltInStyler(
        registry: stylerRegistry,
        catalog: catalog,
        definition: definition,
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
  required ErasedStylerDefinition definition,
}) {
  registry.register(
    definition.type.wireValue,
    definition.buildFullSchema(catalog),
  );
}

ErasedStylerDefinition _selectBuiltInStylerDefinition({
  required MixSchemaCatalog catalog,
  required SchemaStyler type,
}) {
  return switch (type) {
    .box => ErasedStylerDefinition.fromDefinition(
      buildBoxStylerDefinition(catalog),
    ),
    .text => ErasedStylerDefinition.fromDefinition(
      buildTextStylerDefinition(catalog),
    ),
    .flex => ErasedStylerDefinition.fromDefinition(
      buildFlexStylerDefinition(catalog),
    ),
    .icon => ErasedStylerDefinition.fromDefinition(
      buildIconStylerDefinition(catalog),
    ),
    .image => ErasedStylerDefinition.fromDefinition(
      buildImageStylerDefinition(catalog),
    ),
    .stack => ErasedStylerDefinition.fromDefinition(
      buildStackStylerDefinition(catalog),
    ),
    .flexBox => ErasedStylerDefinition.fromDefinition(
      buildFlexBoxStylerDefinition(catalog),
    ),
    .stackBox => ErasedStylerDefinition.fromDefinition(
      buildStackBoxStylerDefinition(catalog),
    ),
  };
}
