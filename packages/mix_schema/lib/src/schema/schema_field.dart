import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import 'common_codecs.dart';

abstract interface class SchemaFieldBase<Owner extends Object> {
  String get wire;
  String get inventoryName;
  AckSchema<Object, Object> get ackSchema;
  Object? readObject(Owner value);
}

final class SchemaField<Owner extends Object, Value extends Object>
    implements SchemaFieldBase<Owner> {
  const SchemaField({
    required this.wire,
    required this.codec,
    required this.read,
    String? inventoryName,
    this.optional = true,
  }) : inventoryName = inventoryName ?? wire;

  @override
  final String wire;

  @override
  final String inventoryName;

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
  String? inventoryName,
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    inventoryName: inventoryName,
    read: (value) => readProp<Value, Value>(read(value), fieldName ?? wire),
  );
}

SchemaField<Owner, Prop<Value>>
propValueField<Owner extends Object, Value extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Prop<Value>? Function(Owner value) read, {
  String? fieldName,
  String? inventoryName,
}) {
  return SchemaField<Owner, Prop<Value>>(
    wire: wire,
    codec: valuePropCodec<Value>(codec, fieldName: fieldName ?? wire),
    inventoryName: inventoryName,
    read: read,
  );
}

SchemaField<Owner, Prop<PropValue>> propValueAsField<
  Owner extends Object,
  Value extends Object,
  PropValue extends Object
>(
  String wire,
  AckSchema<Object, Value> codec,
  Prop<PropValue>? Function(Owner value) read, {
  String? fieldName,
  String? inventoryName,
}) {
  return SchemaField<Owner, Prop<PropValue>>(
    wire: wire,
    codec: valueAsPropCodec<Value, PropValue>(
      codec,
      fieldName: fieldName ?? wire,
    ),
    inventoryName: inventoryName,
    read: read,
  );
}

SchemaField<Owner, Value>
tokenValueField<Owner extends Object, Value extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Prop<Value>? Function(Owner value) read, {
  String? fieldName,
  String? inventoryName,
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    inventoryName: inventoryName,
    read: (value) => readPropWire<Value, Value>(read(value), fieldName ?? wire),
  );
}

SchemaField<Owner, Prop<Value>>
propTokenValueField<Owner extends Object, Value extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Prop<Value>? Function(Owner value) read, {
  String? fieldName,
  String? inventoryName,
}) {
  return SchemaField<Owner, Prop<Value>>(
    wire: wire,
    codec: valuePropCodec<Value>(codec, fieldName: fieldName ?? wire),
    inventoryName: inventoryName,
    read: read,
  );
}

SchemaField<Owner, Value>
mixField<Owner extends Object, Value extends Object, PropValue extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Prop<PropValue>? Function(Owner value) read, {
  String? fieldName,
  String? inventoryName,
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    inventoryName: inventoryName,
    read: (value) => readProp<Value, PropValue>(read(value), fieldName ?? wire),
  );
}

SchemaField<Owner, Prop<PropValue>> propMixField<
  Owner extends Object,
  Value extends Object,
  PropValue extends Object
>(
  String wire,
  AckSchema<Object, Value> codec,
  Prop<PropValue>? Function(Owner value) read, {
  String? fieldName,
  String? inventoryName,
}) {
  return SchemaField<Owner, Prop<PropValue>>(
    wire: wire,
    codec: mixPropCodec<Value, PropValue>(codec, fieldName: fieldName ?? wire),
    inventoryName: inventoryName,
    read: read,
  );
}

SchemaField<Owner, Value> tokenMixField<
  Owner extends Object,
  Value extends Object,
  PropValue extends Object
>(
  String wire,
  AckSchema<Object, Value> codec,
  Prop<PropValue>? Function(Owner value) read, {
  String? fieldName,
  String? inventoryName,
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    inventoryName: inventoryName,
    read: (value) =>
        readPropWire<Value, PropValue>(read(value), fieldName ?? wire),
  );
}

SchemaField<Owner, Prop<PropValue>> propTokenMixField<
  Owner extends Object,
  Value extends Object,
  PropValue extends Object
>(
  String wire,
  AckSchema<Object, Value> codec,
  Prop<PropValue>? Function(Owner value) read, {
  String? fieldName,
  String? inventoryName,
}) {
  return SchemaField<Owner, Prop<PropValue>>(
    wire: wire,
    codec: mixPropCodec<Value, PropValue>(codec, fieldName: fieldName ?? wire),
    inventoryName: inventoryName,
    read: read,
  );
}

SchemaField<Owner, Value>
directField<Owner extends Object, Value extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Object? Function(Owner value) read, {
  String? inventoryName,
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    read: read,
    inventoryName: inventoryName,
  );
}

SchemaField<Owner, Value>
derivedField<Owner extends Object, Value extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Object? Function(Owner value, String wire) read, {
  String? readWire,
  String? inventoryName,
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    inventoryName: inventoryName,
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

void checkSchemaFieldInventory({
  required String owner,
  required Set<String> ownerFieldInventory,
  required Set<String> consumedFieldInventory,
  int? actualFieldCount,
}) {
  final missing = ownerFieldInventory.difference(consumedFieldInventory);
  final stale = consumedFieldInventory.difference(ownerFieldInventory);
  final countSkew =
      actualFieldCount != null &&
      actualFieldCount != ownerFieldInventory.length;

  if (missing.isEmpty && stale.isEmpty && !countSkew) return;

  throw SchemaInventorySkewError(
    owner: owner,
    missingFields: missing,
    staleFields: stale,
    expectedFieldCount: countSkew ? ownerFieldInventory.length : null,
    actualFieldCount: countSkew ? actualFieldCount : null,
  );
}

final class SchemaObject<Owner extends Object> {
  const SchemaObject({
    required this.fields,
    required this.build,
    this.unsupportedFields = const [],
    this.inventoryOwner,
    this.ownerFieldInventory,
    this.actualFieldCount,
  });

  final List<SchemaFieldBase<Owner>> fields;
  final Owner Function(JsonMap data) build;
  final List<UnsupportedSchemaField<Owner>> unsupportedFields;
  final String? inventoryOwner;
  final Set<String>? ownerFieldInventory;
  final int Function(Owner value)? actualFieldCount;

  AckSchema<JsonMap, Owner> codec() {
    return Ack.object({
      for (final field in fields) field.wire: field.ackSchema,
    }).codec<Owner>(decode: build, encode: encode);
  }

  JsonMap encode(Owner value) => encodeFields(value);

  JsonMap encodeFields(Owner value, {Set<String> omit = const {}}) {
    _checkInventory(value);

    for (final field in unsupportedFields) {
      field.check(value);
    }

    return {
      for (final field in fields)
        if (!omit.contains(field.wire)) field.wire: field.readObject(value),
    };
  }

  void _checkInventory(Owner value) {
    final owner = ownerFieldInventory;
    if (owner == null) return;

    checkSchemaFieldInventory(
      owner: inventoryOwner ?? Owner.toString(),
      ownerFieldInventory: owner,
      consumedFieldInventory: _inferredConsumedFields(),
      actualFieldCount: actualFieldCount?.call(value),
    );
  }

  Set<String> _inferredConsumedFields() {
    return {
      for (final field in fields) field.inventoryName,
      for (final field in unsupportedFields) field.name,
    };
  }
}
