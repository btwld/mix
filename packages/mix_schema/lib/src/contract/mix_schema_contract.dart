import 'package:ack/ack.dart';

import 'mix_schema_limits.dart';
import '../core/branch_codec.dart';
import '../core/schema_wire_types.dart';
import '../errors/mix_schema_decode_result.dart';
import '../errors/mix_schema_encode_result.dart';
import '../errors/mix_schema_error.dart';
import '../errors/mix_schema_validation_result.dart';
import '../errors/schema_error_mapper.dart';
import '../registry/frozen_registry.dart';
import '../registry/registry_catalog.dart';
import '../schema/builtins/built_in_styler_definitions.dart';
import '../schema/styler_catalog.dart';

final RegExp _stylerTypePattern = RegExp(r'^[a-z][a-z0-9_]*$');
final Set<String> _reservedStylerTypes = {
  for (final type in SchemaStyler.values) type.wireValue,
};

/// Mutable builder for composing a frozen [MixSchemaContract].
final class MixSchemaContractBuilder {
  final MixSchemaLimits _limits;
  final Map<String, CodecSchema<JsonMap, Object>> _schemas = {};
  final Set<String> _registeredTypes = <String>{};
  bool _frozen = false;

  MixSchemaContractBuilder._({required MixSchemaLimits limits})
    : _limits = limits;

  /// Creates an empty builder for custom top-level styler sets.
  factory MixSchemaContractBuilder({
    MixSchemaLimits limits = const MixSchemaLimits(),
  }) {
    return MixSchemaContractBuilder._(limits: limits);
  }

  /// Creates a builder pre-populated with the built-in styler set.
  factory MixSchemaContractBuilder.builtIn({
    Iterable<FrozenRegistry<Object>> registries = const [],
    MixSchemaLimits limits = const MixSchemaLimits(),
  }) {
    final builder = MixSchemaContractBuilder._(limits: limits);
    final registryCatalog = RegistryCatalog(registries);
    final catalog = StylerCatalog(registries: registryCatalog, limits: limits);

    for (final entry in buildBuiltInStylerDefinitions(catalog).entries) {
      builder._register(
        type: entry.key.wireValue,
        stylerSchema: entry.value,
        allowReservedType: true,
      );
    }

    return builder;
  }

  /// The registered top-level styler `type` values in insertion order.
  List<String> get registeredTypes => List.unmodifiable(_registeredTypes);

  /// Registers an object-backed codec under a styler wire `type`.
  ///
  /// Accepts the same building blocks as `Ack.codec(...)`. The builder wraps
  /// them so the discriminator `{'type': type}` is always prepended on encode
  /// — producers do not (and must not) emit `type` from [encode] themselves.
  /// The optional [output] schema attaches runtime-side refinements.
  void register<T extends Object>(
    String type, {
    required ObjectSchema input,
    required T Function(JsonMap data) decode,
    required JsonMap Function(T value) encode,
    // ignore: avoid-dynamic, matches Ack.codec's `output` parameter type.
    AckSchema<dynamic, T>? output,
  }) {
    final stylerSchema = buildDiscriminatorInjectingCodec<T>(
      type: type,
      input: input,
      decode: decode,
      encode: encode,
      output: output,
    );
    _register(
      type: type,
      stylerSchema: stylerSchema as CodecSchema<JsonMap, Object>,
    );
  }

  void _register({
    required String type,
    required CodecSchema<JsonMap, Object> stylerSchema,
    bool allowReservedType = false,
  }) {
    if (_frozen) {
      throw StateError('Contract builder is frozen.');
    }

    if (_registeredTypes.contains(type)) {
      throw StateError('Type "$type" is already registered.');
    }

    _validateStylerRegistration(
      type: type,
      stylerSchema: stylerSchema,
      allowReservedType: allowReservedType,
    );

    _schemas[type] = stylerSchema;
    _registeredTypes.add(type);
  }

  /// Freezes the builder and returns an immutable contract.
  MixSchemaContract freeze() {
    if (_frozen) {
      throw StateError('Contract builder is frozen.');
    }
    _frozen = true;

    final payloadSchema = Ack.discriminated<Object>(
      discriminatorKey: 'type',
      schemas: Map.unmodifiable(_schemas),
    );

    return MixSchemaContract._(
      payloadSchema: payloadSchema,
      registeredTypes: List.unmodifiable(_registeredTypes),
      limits: _limits,
    );
  }
}

/// Contract-facing entry point for built-in `mix_schema` validation and decode.
///
/// This surface keeps the existing decode path while exposing the frozen root
/// schema and supported built-in styler types for future producer tooling.
final class MixSchemaContract {
  static const contractVersion = '0.1.0-dev.0';

  final AckSchema<JsonMap, Object> _payloadSchema;
  final List<String> _registeredTypes;
  final MixSchemaLimits _limits;
  final SchemaErrorMapper _errorMapper = const SchemaErrorMapper();

  MixSchemaContract._({
    required AckSchema<JsonMap, Object> payloadSchema,
    required List<String> registeredTypes,
    required MixSchemaLimits limits,
  }) : _payloadSchema = payloadSchema,
       _registeredTypes = registeredTypes,
       _limits = limits;

  /// Builds a contract with the built-in styler set and provided registries.
  factory MixSchemaContract.builtIn({
    Iterable<FrozenRegistry<Object>> registries = const [],
    MixSchemaLimits limits = const MixSchemaLimits(),
  }) {
    return MixSchemaContractBuilder.builtIn(
      registries: registries,
      limits: limits,
    ).freeze();
  }

  /// The registered top-level styler `type` values in insertion order.
  List<String> get registeredTypes => _registeredTypes;

  /// The frozen root Ack schema for the full built-in payload contract.
  AckSchema<JsonMap, Object> get rootSchema => _payloadSchema;

  /// Exports the root Ack JSON Schema artifact.
  Map<String, Object?> exportJsonSchema() {
    return {
      ..._payloadSchema.toJsonSchema(),
      '\$schema': 'http://json-schema.org/draft-07/schema#',
      'x-mix-schema-contract': 'mix_schema',
      'x-mix-schema-version': contractVersion,
      'x-mix-schema-limits': _limits.toJson(),
      'x-mix-variant-priority': _variantPriorityMetadata,
    };
  }

  /// Validates a payload against the current contract.
  ///
  /// Validation currently follows the same Ack-driven path as decode, including
  /// registry-backed transform checks, but does not expose the decoded value.
  MixSchemaValidationResult validate(JsonMap payload) {
    final limitErrors = validatePayloadLimits(payload, _limits);
    if (limitErrors.isNotEmpty) {
      return MixSchemaValidationResult.failure(limitErrors);
    }

    final result = _payloadSchema.safeParse(payload);

    return result.match(
      onOk: (_) => MixSchemaValidationResult.success(),
      onFail: (error) =>
          MixSchemaValidationResult.failure(_errorMapper.map(error)),
    );
  }

  /// Validates and decodes a payload into a Mix runtime object.
  MixSchemaDecodeResult<Object> decode(JsonMap payload) {
    final limitErrors = validatePayloadLimits(payload, _limits);
    if (limitErrors.isNotEmpty) {
      return MixSchemaDecodeResult.failure(limitErrors);
    }

    final result = _payloadSchema.safeParse(payload);

    return result.match(
      onOk: (value) => MixSchemaDecodeResult.success(value!),
      onFail: (error) => MixSchemaDecodeResult.failure(_errorMapper.map(error)),
    );
  }

  /// Encodes a Mix runtime object into a schema payload.
  MixSchemaEncodeResult<JsonMap> encode(Object value) {
    final result = _payloadSchema.safeEncode(value);

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

        final limitErrors = validatePayloadLimits(payload, _limits);
        if (limitErrors.isNotEmpty) {
          return MixSchemaEncodeResult.failure(limitErrors);
        }

        return MixSchemaEncodeResult.success(payload);
      },
      onFail: (error) {
        return MixSchemaEncodeResult.failure(_errorMapper.mapEncode(error));
      },
    );
  }
}

/// Producer-facing documentation for compound context variant priority.
///
/// Compound context variants (`context_all_of`) inherit the maximum sort
/// priority of their leaves; the priority is a Mix runtime concept that
/// the wire format does not declare. This metadata documents runtime-derived
/// behavior — the Mix runtime is the actual source of truth for priority.
const Map<String, Object?> _variantPriorityMetadata = {
  'description':
      'Compound context_all_of variants inherit the maximum sortPriority '
      'across their leaves; widget_state contributes priority 1, other '
      'context leaves contribute priority 0. The wire format does not '
      'advertise priority — it is computed by the Mix runtime from the '
      'leaf set.',
  'rule': 'priority(compound) = max(priority(leaf) for leaf in leaves)',
  'leaves': {
    'widget_state': 1,
    'context_brightness': 0,
    'context_breakpoint': 0,
    'context_not_widget_state': 0,
    'enabled': 0,
  },
};

void _validateStylerRegistration({
  required String type,
  required CodecSchema<JsonMap, Object> stylerSchema,
  required bool allowReservedType,
}) {
  if (type.trim().isEmpty) {
    throw ArgumentError.value(type, 'type', 'Styler type must not be empty.');
  }

  if (type != type.trim() || !_stylerTypePattern.hasMatch(type)) {
    throw ArgumentError.value(
      type,
      'type',
      'Styler type must match ${_stylerTypePattern.pattern}.',
    );
  }

  if (!allowReservedType && _reservedStylerTypes.contains(type)) {
    throw ArgumentError.value(
      type,
      'type',
      'Styler type "$type" is reserved for a built-in styler.',
    );
  }

  final inputSchema = stylerSchema.inputSchema;
  if (inputSchema is! ObjectSchema) {
    throw ArgumentError.value(
      stylerSchema,
      'stylerSchema',
      'Styler "$type" must be backed by Ack.object(...).',
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
