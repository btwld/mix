import 'package:ack/ack.dart';

import '../core/json_map.dart';
import '../errors/mix_schema_decode_result.dart';
import '../errors/mix_schema_encode_result.dart';
import '../errors/mix_schema_error.dart';
import '../errors/mix_schema_validation_result.dart';
import '../errors/schema_error_mapper.dart';
import '../registry/frozen_registry.dart';
import '../registry/styler_registry.dart';

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

  /// Registers an object-backed codec under a styler wire `type`.
  ///
  /// Exportable field metadata is derived from the codec input schema.
  void register<T extends Object>(
    String type,
    CodecSchema<JsonMap, T> stylerSchema,
  ) {
    _stylerRegistry.register(type, stylerSchema);
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

  /// Exports the root Ack JSON Schema artifact.
  Map<String, Object?> exportJsonSchema() {
    return rootSchema.toJsonSchema();
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

  /// Encodes a Mix runtime object into a schema payload.
  MixSchemaEncodeResult<JsonMap> encode(Object value) {
    final result = _stylerRegistry.encode(value);

    return result.match(
      onOk: (encoded) {
        final payload = _asJsonMap(encoded);
        if (payload == null) {
          return MixSchemaEncodeResult.failure([
            MixSchemaError(
              code: .validationFailed,
              path: '#',
              message: 'Encoded value was not a JSON object payload.',
              value: encoded,
            ),
          ]);
        }

        return MixSchemaEncodeResult.success(payload);
      },
      onFail: (error) => MixSchemaEncodeResult.failure(_errorMapper.map(error)),
    );
  }
}

JsonMap? _asJsonMap(Object? value) {
  if (value is Map<String, Object?>) {
    return Map.unmodifiable(value);
  }

  if (value is Map) {
    final payload = <String, Object?>{};
    for (final entry in value.entries) {
      final key = entry.key;
      if (key is! String) {
        return null;
      }
      payload[key] = entry.value;
    }

    return Map.unmodifiable(payload);
  }

  return null;
}
