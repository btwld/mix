import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import 'common_codecs.dart';

abstract interface class SchemaFieldBase<Owner extends Object> {
  String get wire;
  AckSchema<Object, Object> get ackSchema;
  Object? readObject(Owner value);
}

final class SchemaField<Owner extends Object, Value extends Object>
    implements SchemaFieldBase<Owner> {
  const SchemaField({
    required this.wire,
    required this.codec,
    required this.read,
    this.optional = true,
  });

  @override
  final String wire;

  final AckSchema<Object, Value> codec;
  final Object? Function(Owner value) read;
  final bool optional;

  @override
  AckSchema<Object, Object> get ackSchema {
    final schema = optional ? codec.optional() : codec;

    return schema as AckSchema<Object, Object>;
  }

  Value? value(JsonMap data) => data[wire] as Value?;

  @override
  Object? readObject(Owner value) => read(value);
}

SchemaField<Owner, Value>
valueField<Owner extends Object, Value extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Prop<Value>? Function(Owner value) read, {
  String? fieldName,
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    read: (value) => readProp<Value, Value>(read(value), fieldName ?? wire),
  );
}

SchemaField<Owner, Value>
mixField<Owner extends Object, Value extends Object, PropValue extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Prop<PropValue>? Function(Owner value) read, {
  String? fieldName,
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    read: (value) => readProp<Value, PropValue>(read(value), fieldName ?? wire),
  );
}

SchemaField<Owner, Value>
directField<Owner extends Object, Value extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Object? Function(Owner value) read,
) {
  return SchemaField<Owner, Value>(wire: wire, codec: codec, read: read);
}

SchemaField<Owner, Value>
derivedField<Owner extends Object, Value extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Object? Function(Owner value, String wire) read, {
  String? readWire,
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    read: (value) => read(value, readWire ?? wire),
  );
}

final class UnsupportedSchemaField<Owner extends Object> {
  const UnsupportedSchemaField(this.name, this.read);

  final String name;
  final Object? Function(Owner value) read;

  void check(Owner value) {
    final fieldValue = read(value);
    if (fieldValue == null) return;

    throw UnsupportedEncodeValueError(
      fieldValue,
      'Field "$name" is not representable by this schema.',
    );
  }
}

final class SchemaObject<Owner extends Object> {
  const SchemaObject({
    required this.fields,
    required this.build,
    this.unsupportedFields = const [],
  });

  final List<SchemaFieldBase<Owner>> fields;
  final Owner Function(JsonMap data) build;
  final List<UnsupportedSchemaField<Owner>> unsupportedFields;

  AckSchema<JsonMap, Owner> codec() {
    return Ack.object({
      for (final field in fields) field.wire: field.ackSchema,
    }).codec<Owner>(decode: build, encode: encode);
  }

  JsonMap encode(Owner value) => encodeFields(value);

  JsonMap encodeFields(Owner value, {Set<String> omit = const {}}) {
    for (final field in unsupportedFields) {
      field.check(value);
    }

    return {
      for (final field in fields)
        if (!omit.contains(field.wire)) field.wire: field.readObject(value),
    };
  }
}
