import 'package:ack/ack.dart';

import 'object_backed_schema.dart';

typedef DiscriminatedBranchSchemaBuilder<T extends Object> =
    AckSchema<T> Function({
      required String discriminatorKey,
      required String typeValue,
    });

typedef DiscriminatedSchemaBranch<T extends Object> = ({
  String type,
  DiscriminatedBranchSchemaBuilder<T> buildSchema,
});

DiscriminatedSchemaBranch<T> discriminatedBranch<
  T extends Object,
  B extends T
>({required String type, required AckSchema<B> schema}) {
  return (
    type: type,
    buildSchema: ({required discriminatorKey, required typeValue}) {
      return _injectDiscriminatorIntoBranch<B>(
            discriminatorKey: discriminatorKey,
            typeValue: typeValue,
            schema: schema,
          )
          as AckSchema<T>;
    },
  );
}

AckSchema<T> buildDiscriminatedSchema<T extends Object>({
  required String discriminatorKey,
  required Iterable<DiscriminatedSchemaBranch<T>> branches,
}) {
  final schemas = <String, AckSchema<T>>{};

  for (final branch in branches) {
    if (schemas.containsKey(branch.type)) {
      throw StateError('Type "${branch.type}" is already registered.');
    }

    schemas[branch.type] = branch.buildSchema(
      discriminatorKey: discriminatorKey,
      typeValue: branch.type,
    );
  }

  return Ack.discriminated<T>(
    discriminatorKey: discriminatorKey,
    schemas: Map.unmodifiable(schemas),
  );
}

AckSchema<T> _injectDiscriminatorIntoBranch<T extends Object>({
  required String discriminatorKey,
  required String typeValue,
  required AckSchema<T> schema,
}) {
  if (schema is ObjectSchema) {
    return _injectDiscriminatorIntoObject(
          discriminatorKey: discriminatorKey,
          typeValue: typeValue,
          schema: schema as ObjectSchema,
        )
        as AckSchema<T>;
  }

  if (schema is CodecSchema<Map<String, Object?>, T>) {
    final originalEncoder = schema.encoder;

    return schema.copyWith(
      inputSchema: _injectDiscriminatorIntoObject(
        discriminatorKey: discriminatorKey,
        typeValue: typeValue,
        schema: requireObjectBackedSchema(
          schema.inputSchema,
          'Discriminated branches must be backed by Ack.object(...) before '
          'transform().',
        ),
      ),
      encoder: originalEncoder == null
          ? null
          : (T value) => {
              discriminatorKey: typeValue,
              ...originalEncoder(value),
            },
    );
  }

  if (schema is CodecSchema) {
    throw StateError(
      'Discriminated codec branches must be backed by '
      'Ack.object(...).transform<T>(...) or Ack.codec(input: Ack.object(...), '
      '...) so the inner object schema can be discovered.',
    );
  }

  throw StateError(
    'Discriminated branches must be object-backed schemas with at most one '
    'codec layer.',
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
