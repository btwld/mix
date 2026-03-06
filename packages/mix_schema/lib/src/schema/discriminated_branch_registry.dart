import 'package:ack/ack.dart';

final class DiscriminatedBranchRegistry<T extends Object> {
  final String discriminatorKey;

  final Map<String, _NormalizedBranch<T>> _branches =
      <String, _NormalizedBranch<T>>{};
  bool _frozen = false;
  DiscriminatedBranchRegistry({required this.discriminatorKey});

  void register<R extends T>(String type, AckSchema<R> schema) {
    if (_frozen) {
      throw StateError('Registry is frozen.');
    }

    if (_branches.containsKey(type)) {
      throw StateError('Type "$type" is already registered.');
    }

    _branches[type] = _normalizeDiscriminatedBranch(
      discriminatorKey: discriminatorKey,
      typeValue: type,
      schema: schema,
    );
  }

  AckSchema<T> freeze() {
    if (_frozen) {
      throw StateError('Registry is frozen.');
    }

    _frozen = true;
    final normalizedBranches = Map<String, _NormalizedBranch<T>>.unmodifiable(
      _branches,
    );
    final discriminatedSchema = Ack.discriminated(
      discriminatorKey: discriminatorKey,
      schemas: {
        for (final entry in normalizedBranches.entries)
          entry.key: entry.value.objectSchema,
      },
    );

    return discriminatedSchema.transform<T>((data) {
      final value = data!;
      final typeValue = value[discriminatorKey];
      final branch = normalizedBranches[typeValue];

      if (branch == null) {
        final branchLabel = typeValue ?? 'null';

        throw StateError('Unknown discriminated branch "$branchLabel".');
      }

      return branch.transform(value);
    });
  }
}

final class _NormalizedBranch<T extends Object> {
  final ObjectSchema objectSchema;

  final T Function(Map<String, Object?> value) transform;
  const _NormalizedBranch({
    required this.objectSchema,
    required this.transform,
  });
}

_NormalizedBranch<T> _normalizeDiscriminatedBranch<T extends Object>({
  required String discriminatorKey,
  required String typeValue,
  required AckSchema<T> schema,
}) {
  if (schema is ObjectSchema) {
    final objectSchema = _injectDiscriminatorIntoObject(
      discriminatorKey: discriminatorKey,
      typeValue: typeValue,
      schema: schema as ObjectSchema,
    );

    return _NormalizedBranch(
      objectSchema: objectSchema,
      transform: (value) => value as T,
    );
  }

  if (schema is TransformedSchema<Map<String, Object?>, T>) {
    final objectSchema = _injectDiscriminatorIntoObject(
      discriminatorKey: discriminatorKey,
      typeValue: typeValue,
      schema: _requireObjectSchema(schema.schema),
    );

    return _NormalizedBranch(
      objectSchema: objectSchema,
      transform: (value) => schema.transformer(value),
    );
  }

  throw StateError(
    'Discriminated branches must be object-backed schemas with at most one '
    'transform layer.',
  );
}

ObjectSchema _injectDiscriminatorIntoObject({
  required String discriminatorKey,
  required String typeValue,
  required ObjectSchema schema,
}) {
  if (schema.properties.containsKey(discriminatorKey)) {
    throw StateError(
      'Discriminated branches must not declare "$discriminatorKey" manually.',
    );
  }

  return schema.copyWith(
    properties: {
      discriminatorKey: Ack.literal(typeValue),
      ...schema.properties,
    },
  );
}

ObjectSchema _requireObjectSchema(AckSchema<Map<String, Object?>> schema) {
  if (schema is ObjectSchema) {
    return schema;
  }

  throw StateError(
    'Discriminated branches must be backed by Ack.object(...) before '
    'transform().',
  );
}
