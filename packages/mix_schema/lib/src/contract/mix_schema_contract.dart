import 'package:ack/ack.dart';

import '../core/json_map.dart';
import '../core/schema_wire_types.dart';
import '../errors/mix_schema_decode_result.dart';
import '../errors/mix_schema_validation_result.dart';
import '../errors/schema_error_mapper.dart';
import '../registry/frozen_registry.dart';
import '../registry/styler_registry.dart';
import '../schema/metadata/metadata_schemas.dart';
import 'mix_schema_export_metadata.dart';

/// Mutable builder for composing a frozen [MixSchemaContract].
final class MixSchemaContractBuilder {
  final StylerRegistry _stylerRegistry;

  const MixSchemaContractBuilder._({required StylerRegistry stylerRegistry})
    : _stylerRegistry = stylerRegistry;

  /// Creates an empty builder for custom top-level styler sets.
  factory MixSchemaContractBuilder() {
    return MixSchemaContractBuilder._(stylerRegistry: StylerRegistry());
  }

  /// Creates a builder pre-populated with the built-in styler set.
  factory MixSchemaContractBuilder.builtIn({
    Iterable<FrozenRegistry<Object>> registries = const [],
  }) {
    return MixSchemaContractBuilder._(
      stylerRegistry: StylerRegistry.builtIn(registries: registries),
    );
  }

  /// The registered top-level styler `type` values in insertion order.
  List<String> get registeredTypes => _stylerRegistry.registeredTypes;

  /// Registers a styler schema plus its exportable field contract.
  ///
  /// The explicit [fields] list currently powers metadata export for custom
  /// stylers. Object-backed schemas are validated against that field list so
  /// drift fails fast until richer Ack-derived export becomes available.
  void register<T extends Object>(
    String type,
    AckSchema<T> stylerSchema, {
    required List<String> fields,
    List<String> unsupportedFields = const [],
  }) {
    _stylerRegistry.register(
      type,
      stylerSchema,
      fields: fields,
      unsupportedFields: unsupportedFields,
    );
  }

  /// Freezes the builder and returns an immutable contract.
  MixSchemaContract freeze() {
    _stylerRegistry.freeze();

    return MixSchemaContract._(stylerRegistry: _stylerRegistry);
  }
}

/// Contract-facing entry point for built-in `mix_schema` validation and decode.
///
/// This surface keeps the existing decode path while exposing the frozen root
/// schema and supported built-in styler types for future producer tooling.
final class MixSchemaContract {
  final StylerRegistry _stylerRegistry;
  final SchemaErrorMapper _errorMapper = const SchemaErrorMapper();

  MixSchemaContract._({required StylerRegistry stylerRegistry})
    : _stylerRegistry = stylerRegistry {
    if (!stylerRegistry.isFrozen) {
      throw StateError('StylerRegistry must be frozen before use.');
    }
  }

  /// Builds a contract with the built-in styler set and provided registries.
  factory MixSchemaContract.builtIn({
    Iterable<FrozenRegistry<Object>> registries = const [],
  }) {
    return MixSchemaContractBuilder.builtIn(registries: registries).freeze();
  }

  /// The frozen root Ack schema for the full built-in payload contract.
  AckSchema<Object> get rootSchema => _stylerRegistry.payloadSchema;

  /// Exports minimal contract metadata for producers and tooling.
  MixSchemaExportMetadata exportMetadata() {
    return MixSchemaExportMetadata(
      stylerTypes: _stylerRegistry.registeredTypes,
      modifierTypes: SchemaModifier.values
          .map((modifier) => modifier.wireValue)
          .toList(growable: false),
      variantTypes: SchemaVariant.values
          .map((variant) => variant.wireValue)
          .toList(growable: false),
      contextConditionTypes: [
        ...variantConditionDefinitions.keys.map((type) => type.wireValue),
        SchemaVariant.contextAllOf.wireValue,
      ],
      topLevelMetadataFields: topLevelMetadataFieldNames,
      variantStyleMetadataFields: variantStyleMetadataFieldNames,
      stylerFields: _stylerRegistry.stylerFields,
      unsupportedFields: _stylerRegistry.unsupportedFields,
    );
  }

  /// Validates a payload against the current contract.
  ///
  /// Validation currently follows the same Ack-driven path as decode, including
  /// registry-backed transform checks, but does not expose the decoded value.
  MixSchemaValidationResult validate(JsonMap payload) {
    final result = _stylerRegistry.decode(payload);

    return result.match(
      onOk: (_) => MixSchemaValidationResult.success(),
      onFail: (error) =>
          MixSchemaValidationResult.failure(_errorMapper.map(error)),
    );
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
