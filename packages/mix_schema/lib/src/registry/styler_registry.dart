import 'package:ack/ack.dart';

import '../core/json_map.dart';
import '../schema/builtins/built_in_styler_definitions.dart';
import '../schema/discriminated_schema_builder.dart';
import '../schema/mix_schema_catalog.dart';
import '../schema/object_backed_schema.dart';
import 'frozen_registry.dart';
import 'registry_catalog.dart';

/// Mutable registry of styler schemas used to build the payload decoder.
final class StylerRegistry {
  final List<DiscriminatedSchemaBranch<Object>> _branches = [];
  final Set<String> _registeredTypes = <String>{};
  AckSchema<Object>? _payloadSchema;
  bool _frozen = false;

  StylerRegistry();

  /// Creates a mutable registry pre-populated with the built-in styler set.
  ///
  /// The provided registries are wired into the built-in schemas immediately,
  /// so they must contain any runtime values those stylers need at decode time.
  factory StylerRegistry.builtIn({
    Iterable<FrozenRegistry<Object>> registries = const [],
  }) {
    final stylerRegistry = StylerRegistry();
    final registryCatalog = RegistryCatalog(registries);
    final catalog = MixSchemaCatalog(registries: registryCatalog);

    _registerBuiltInStylers(registry: stylerRegistry, catalog: catalog);

    return stylerRegistry;
  }

  void _register({
    required String type,
    required AckSchema<Object> stylerSchema,
    required DiscriminatedSchemaBranch<Object> branch,
  }) {
    if (_frozen) {
      throw StateError('Registry is frozen.');
    }

    if (_registeredTypes.contains(type)) {
      throw StateError('Type "$type" is already registered.');
    }

    _validateStylerRegistration(type: type, stylerSchema: stylerSchema);

    _branches.add(branch);
    _registeredTypes.add(type);
  }

  /// Whether the registry has been frozen and is ready for decode.
  bool get isFrozen => _frozen;

  /// The registered top-level styler `type` values in insertion order.
  List<String> get registeredTypes => .unmodifiable(_registeredTypes);

  /// The frozen root Ack schema for the full payload contract.
  AckSchema<Object> get payloadSchema {
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
      stylerSchema: stylerSchema as AckSchema<Object>,
      branch: discriminatedBranch(type: type, schema: stylerSchema),
    );
  }

  /// Freezes the registry and builds the discriminated payload schema.
  void freeze() {
    if (_frozen) {
      throw StateError('Registry is frozen.');
    }

    _payloadSchema = buildDiscriminatedSchema<Object>(
      discriminatorKey: 'type',
      branches: _branches,
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
  SchemaResult<Object> encode(Object value) {
    if (!_frozen || _payloadSchema == null) {
      throw StateError('Registry must be frozen before encode.');
    }

    return _payloadSchema!.safeEncode(value);
  }
}

void _validateStylerRegistration({
  required String type,
  required AckSchema<Object> stylerSchema,
}) {
  if (type.trim().isEmpty) {
    throw ArgumentError.value(type, 'type', 'Styler type must not be empty.');
  }

  final objectSchema = requireObjectBackedSchema(
    stylerSchema,
    'Styler schemas must be backed by Ack.object(...).',
  );
  if (objectSchema.properties.containsKey('type')) {
    throw ArgumentError.value(
      stylerSchema,
      'stylerSchema',
      'Styler "$type" must not declare `type` inside its Ack object schema.',
    );
  }
}

void _registerBuiltInStylers({
  required StylerRegistry registry,
  required MixSchemaCatalog catalog,
}) {
  for (final entry in buildBuiltInStylerDefinitions(catalog).entries) {
    registry._register(
      type: entry.value.type.wireValue,
      stylerSchema: entry.value.schema,
      branch: entry.value.branch,
    );
  }
}
