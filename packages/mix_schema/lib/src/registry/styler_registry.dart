import 'package:ack/ack.dart';

import '../contract/mix_schema_limits.dart';
import '../schema/builtins/built_in_styler_definitions.dart';
import '../schema/styler_catalog.dart';
import 'frozen_registry.dart';
import 'registry_catalog.dart';

/// Mutable registry of styler schemas used to build the payload decoder.
final class StylerRegistry {
  final MixSchemaLimits limits;
  final Map<String, CodecSchema<JsonMap, Object>> _schemas = {};
  final Set<String> _registeredTypes = <String>{};
  AckSchema<JsonMap, Object>? _payloadSchema;
  bool _frozen = false;

  StylerRegistry({this.limits = const MixSchemaLimits()});

  /// Creates a mutable registry pre-populated with the built-in styler set.
  ///
  /// The provided registries are wired into the built-in schemas immediately,
  /// so they must contain any runtime values those stylers need at decode time.
  factory StylerRegistry.builtIn({
    Iterable<FrozenRegistry<Object>> registries = const [],
    MixSchemaLimits limits = const MixSchemaLimits(),
  }) {
    final stylerRegistry = StylerRegistry(limits: limits);
    final registryCatalog = RegistryCatalog(registries);
    final catalog = StylerCatalog(registries: registryCatalog, limits: limits);

    _registerBuiltInStylers(registry: stylerRegistry, catalog: catalog);

    return stylerRegistry;
  }

  void _register({
    required String type,
    required CodecSchema<JsonMap, Object> stylerSchema,
  }) {
    if (_frozen) {
      throw StateError('Registry is frozen.');
    }

    if (_registeredTypes.contains(type)) {
      throw StateError('Type "$type" is already registered.');
    }

    _validateStylerRegistration(type: type, stylerSchema: stylerSchema);

    _schemas[type] = stylerSchema;
    _registeredTypes.add(type);
  }

  /// Whether the registry has been frozen and is ready for decode.
  bool get isFrozen => _frozen;

  /// The registered top-level styler `type` values in insertion order.
  List<String> get registeredTypes => .unmodifiable(_registeredTypes);

  /// The frozen root Ack schema for the full payload contract.
  AckSchema<JsonMap, Object> get payloadSchema {
    if (!_frozen || _payloadSchema == null) {
      throw StateError('Registry must be frozen before accessing schema.');
    }

    return _payloadSchema!;
  }

  /// Registers a styler schema under its wire `type` value.
  void register<T extends Object>(
    String type,
    CodecSchema<JsonMap, T> stylerSchema,
  ) {
    _register(
      type: type,
      stylerSchema: stylerSchema as CodecSchema<JsonMap, Object>,
    );
  }

  /// Freezes the registry and builds the discriminated payload schema.
  void freeze() {
    if (_frozen) {
      throw StateError('Registry is frozen.');
    }

    _payloadSchema = Ack.discriminated<Object>(
      discriminatorKey: 'type',
      schemas: Map.unmodifiable(_schemas),
    );
    _frozen = true;
  }

  /// Parses a payload using the frozen discriminated schema.
  SchemaResult<Object> decode(JsonMap payload) {
    if (!_frozen || _payloadSchema == null) {
      throw StateError('Registry must be frozen before decode.');
    }

    return _payloadSchema!.safeParse(payload);
  }

  /// Encodes a runtime value using the frozen discriminated schema.
  SchemaResult<JsonMap> encode(Object value) {
    if (!_frozen || _payloadSchema == null) {
      throw StateError('Registry must be frozen before encode.');
    }

    return _payloadSchema!.safeEncode(value);
  }
}

void _validateStylerRegistration({
  required String type,
  required CodecSchema<JsonMap, Object> stylerSchema,
}) {
  if (type.trim().isEmpty) {
    throw ArgumentError.value(type, 'type', 'Styler type must not be empty.');
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

void _registerBuiltInStylers({
  required StylerRegistry registry,
  required StylerCatalog catalog,
}) {
  for (final entry in buildBuiltInStylerDefinitions(catalog).entries) {
    registry._register(type: entry.key.wireValue, stylerSchema: entry.value);
  }
}
