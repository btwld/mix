import 'package:ack/ack.dart';

import '../core/json_map.dart';
import '../schema/builtins/built_in_styler_definitions.dart';
import '../schema/discriminated_schema_builder.dart';
import '../schema/metadata/metadata_field_schemas.dart';
import '../schema/mix_schema_catalog.dart';
import 'frozen_registry.dart';
import 'registry_catalog.dart';

final class StylerRegistryEntry {
  final List<String> fields;
  final List<String> unsupportedFields;

  const StylerRegistryEntry({
    required this.fields,
    this.unsupportedFields = const [],
  });
}

/// Mutable registry of styler schemas used to build the payload decoder.
final class StylerRegistry {
  final List<DiscriminatedSchemaBranch<Object>> _branches = [];
  final Map<String, StylerRegistryEntry> _entries = {};
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
    required List<String> fields,
    required List<String> unsupportedFields,
  }) {
    if (_frozen) {
      throw StateError('Registry is frozen.');
    }

    if (_entries.containsKey(type)) {
      throw StateError('Type "$type" is already registered.');
    }

    _validateStylerRegistration(
      type: type,
      stylerSchema: stylerSchema,
      fields: fields,
      unsupportedFields: unsupportedFields,
    );

    _branches.add(branch);
    _entries[type] = StylerRegistryEntry(
      fields: List.unmodifiable(fields),
      unsupportedFields: List.unmodifiable(unsupportedFields),
    );
  }

  /// Whether the registry has been frozen and is ready for decode.
  bool get isFrozen => _frozen;

  /// The registered top-level styler `type` values in insertion order.
  List<String> get registeredTypes => .unmodifiable(_entries.keys);

  /// The declared field names for each registered styler `type`.
  Map<String, List<String>> get stylerFields {
    final fields = <String, List<String>>{
      for (final entry in _entries.entries)
        entry.key: List.unmodifiable(entry.value.fields),
    };

    return Map.unmodifiable(fields);
  }

  /// The declared unsupported field names for each registered styler `type`.
  Map<String, List<String>> get unsupportedFields {
    final fields = <String, List<String>>{
      for (final entry in _entries.entries)
        if (entry.value.unsupportedFields.isNotEmpty)
          entry.key: List.unmodifiable(entry.value.unsupportedFields),
    };

    return Map.unmodifiable(fields);
  }

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
    AckSchema<T> stylerSchema, {
    required List<String> fields,
    List<String> unsupportedFields = const [],
  }) {
    _register(
      type: type,
      stylerSchema: stylerSchema as AckSchema<Object>,
      branch: discriminatedBranch(type: type, schema: stylerSchema),
      fields: fields,
      unsupportedFields: unsupportedFields,
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
}

void _validateStylerRegistration({
  required String type,
  required AckSchema<Object> stylerSchema,
  required List<String> fields,
  required List<String> unsupportedFields,
}) {
  if (type.trim().isEmpty) {
    throw ArgumentError.value(type, 'type', 'Styler type must not be empty.');
  }

  _validateUniqueFieldNames(type: type, fieldName: 'fields', values: fields);
  _validateUniqueFieldNames(
    type: type,
    fieldName: 'unsupportedFields',
    values: unsupportedFields,
  );

  if (fields.contains('type')) {
    throw ArgumentError.value(
      fields,
      'fields',
      'Styler "$type" cannot declare `type` as a custom field; it is reserved for the branch discriminator.',
    );
  }

  final unsupportedOutsideFields = unsupportedFields
      .where((field) => !fields.contains(field))
      .toList(growable: false);

  if (unsupportedOutsideFields.isNotEmpty) {
    throw ArgumentError.value(
      unsupportedFields,
      'unsupportedFields',
      'Styler "$type" declared unsupported fields that are not present in fields: $unsupportedOutsideFields.',
    );
  }

  final schemaFields = _extractStylerSchemaFields(stylerSchema);
  if (schemaFields == null) {
    return;
  }

  if (schemaFields.contains('type')) {
    throw ArgumentError.value(
      stylerSchema,
      'stylerSchema',
      'Styler "$type" must not declare `type` inside its Ack object schema.',
    );
  }

  final declaredFields = [
    for (final field in schemaFields)
      if (!topLevelMetadataFieldNames.contains(field)) field,
  ];

  if (!_sameOrderedStrings(fields, declaredFields)) {
    throw ArgumentError.value(
      fields,
      'fields',
      'Styler "$type" fields must match the object-backed Ack schema shape. Expected $declaredFields, got $fields.',
    );
  }
}

void _validateUniqueFieldNames({
  required String type,
  required String fieldName,
  required List<String> values,
}) {
  final seen = <String>{};
  final duplicates = <String>[];

  for (final value in values) {
    if (!seen.add(value) && !duplicates.contains(value)) {
      duplicates.add(value);
    }
  }

  if (duplicates.isNotEmpty) {
    throw ArgumentError.value(
      values,
      fieldName,
      'Styler "$type" contains duplicate $fieldName entries: $duplicates.',
    );
  }
}

List<String>? _extractStylerSchemaFields(AckSchema<Object> stylerSchema) {
  final objectSchema = _unwrapObjectSchema(stylerSchema);
  if (objectSchema == null) {
    return null;
  }

  return objectSchema.properties.keys.toList(growable: false);
}

ObjectSchema? _unwrapObjectSchema(AckSchema<Object> stylerSchema) {
  AckSchema<Object> current = stylerSchema;

  while (true) {
    if (current is ObjectSchema) {
      return current;
    }

    if (current is TransformedSchema) {
      current = current.schema;
      continue;
    }

    return null;
  }
}

bool _sameOrderedStrings(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }

  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) {
      return false;
    }
  }

  return true;
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
      fields: entry.value.fields,
      unsupportedFields: entry.value.unsupportedFields,
    );
  }
}
