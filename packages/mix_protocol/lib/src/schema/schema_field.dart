import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../errors/mix_protocol_error.dart';
import 'common_codecs.dart';

const boxDecorationFieldSemantics = SchemaFieldSemantics(
  listEntryPaths: [
    ['boxShadow'],
    ['gradient', 'colors'],
    ['gradient', 'stops'],
  ],
);

const strutStyleFieldSemantics = SchemaFieldSemantics(
  listEntryPaths: [
    ['fontFamilyFallback'],
  ],
);

const textStyleFieldSemantics = SchemaFieldSemantics(
  listEntryPaths: [
    ['fontFamilyFallback'],
    ['fontFeatures'],
    ['fontVariations'],
    ['shadows'],
  ],
);

const listEntryFieldSemantics = SchemaFieldSemantics(listEntryPaths: [[]]);

abstract interface class SchemaFieldBase<Owner extends Object> {
  /// Stable key used by the serialized protocol document.
  String get wire;

  /// Dart source field consumed from [Owner] for inventory validation.
  ///
  /// This defaults to [wire], but can differ when one source field contributes
  /// multiple wire fields or when the stable wire spelling differs from Dart.
  String get inventoryName;
  AckSchema<Object, Object> get ackSchema;
  SchemaFieldSemantics get schemaSemantics;
  Object? readObject(Owner value, Map<Object, JsonMap> groups);
}

/// List paths that support removal of invalid entries during lenient decoding.
final class SchemaFieldSemantics {
  final List<List<String>> listEntryPaths;

  const SchemaFieldSemantics({this.listEntryPaths = const []});

  bool get isEmpty => listEntryPaths.isEmpty;
}

final class SchemaField<Owner extends Object, Value extends Object>
    implements SchemaFieldBase<Owner> {
  @override
  final String wire;

  @override
  final String inventoryName;

  final AckSchema<Object, Value> codec;
  final Object? Function(Owner value)? read;
  final JsonMap Function(Owner value)? readGroup;
  final String? readWire;
  final bool optional;

  @override
  final SchemaFieldSemantics schemaSemantics;

  const SchemaField({
    required this.wire,
    required this.codec,
    String? inventoryName,
    this.schemaSemantics = const SchemaFieldSemantics(),
    this.read,
    this.readGroup,
    this.readWire,
    this.optional = true,
  }) : assert((read == null) != (readGroup == null)),
       inventoryName = inventoryName ?? wire;

  Value? value(JsonMap data) => data[wire] as Value?;

  @override
  Object? readObject(Owner value, Map<Object, JsonMap> groups) {
    final group = readGroup;
    if (group == null) return read!(value);

    return groups.putIfAbsent(group, () => group(value))[readWire ?? wire];
  }

  @override
  AckSchema<Object, Object> get ackSchema {
    final schema = optional ? codec.optional() : codec;

    return schema as AckSchema<Object, Object>;
  }
}

SchemaField<Owner, Value>
valueField<Owner extends Object, Value extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Prop<Value>? Function(Owner value) read, {
  String? fieldName,
  String? inventoryName,
  SchemaFieldSemantics schemaSemantics = const SchemaFieldSemantics(),
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    inventoryName: inventoryName,
    schemaSemantics: schemaSemantics,
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
  SchemaFieldSemantics schemaSemantics = const SchemaFieldSemantics(),
}) {
  return SchemaField<Owner, Prop<Value>>(
    wire: wire,
    codec: valuePropCodec<Value>(codec, fieldName: fieldName ?? wire),
    inventoryName: inventoryName,
    schemaSemantics: schemaSemantics,
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
  SchemaFieldSemantics schemaSemantics = const SchemaFieldSemantics(),
}) {
  return SchemaField<Owner, Prop<PropValue>>(
    wire: wire,
    codec: valueAsPropCodec<Value, PropValue>(
      codec,
      fieldName: fieldName ?? wire,
    ),
    inventoryName: inventoryName,
    schemaSemantics: schemaSemantics,
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
  SchemaFieldSemantics schemaSemantics = const SchemaFieldSemantics(),
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    inventoryName: inventoryName,
    schemaSemantics: schemaSemantics,
    read: (value) => readPropWire<Value, Value>(read(value), fieldName ?? wire),
  );
}

SchemaField<Owner, Value>
mixField<Owner extends Object, Value extends Object, PropValue extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Prop<PropValue>? Function(Owner value) read, {
  String? fieldName,
  String? inventoryName,
  SchemaFieldSemantics schemaSemantics = const SchemaFieldSemantics(),
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    inventoryName: inventoryName,
    schemaSemantics: schemaSemantics,
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
  SchemaFieldSemantics schemaSemantics = const SchemaFieldSemantics(),
  Value? Function(PropValue value)? convertValue,
}) {
  return SchemaField<Owner, Prop<PropValue>>(
    wire: wire,
    codec: mixPropCodec<Value, PropValue>(
      codec,
      fieldName: fieldName ?? wire,
      convertValue: convertValue,
    ),
    inventoryName: inventoryName,
    schemaSemantics: schemaSemantics,
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
  SchemaFieldSemantics schemaSemantics = const SchemaFieldSemantics(),
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    inventoryName: inventoryName,
    schemaSemantics: schemaSemantics,
    read: (value) =>
        readPropWire<Value, PropValue>(read(value), fieldName ?? wire),
  );
}

SchemaField<Owner, Value>
directField<Owner extends Object, Value extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  Object? Function(Owner value) read, {
  String? inventoryName,
  SchemaFieldSemantics schemaSemantics = const SchemaFieldSemantics(),
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    inventoryName: inventoryName,
    schemaSemantics: schemaSemantics,
    read: read,
  );
}

SchemaField<Owner, Value>
derivedField<Owner extends Object, Value extends Object>(
  String wire,
  AckSchema<Object, Value> codec,
  JsonMap Function(Owner value) read, {
  String? readWire,
  String? inventoryName,
  SchemaFieldSemantics schemaSemantics = const SchemaFieldSemantics(),
}) {
  return SchemaField<Owner, Value>(
    wire: wire,
    codec: codec,
    inventoryName: inventoryName,
    schemaSemantics: schemaSemantics,
    readGroup: read,
    readWire: readWire,
  );
}

final class UnsupportedSchemaField<Owner extends Object> {
  final String name;
  final Object? Function(Owner value) read;

  const UnsupportedSchemaField(this.name, this.read);

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
  final List<SchemaFieldBase<Owner>> fields;
  final Owner Function(JsonMap data) build;
  final List<UnsupportedSchemaField<Owner>> unsupportedFields;
  final String? inventoryOwner;
  final Set<String>? ownerFieldInventory;
  final Set<String>? Function(Owner value)? ownerFieldInventoryOf;
  final int Function(Owner value)? actualFieldCount;

  const SchemaObject({
    required this.fields,
    required this.build,
    this.unsupportedFields = const [],
    this.inventoryOwner,
    this.ownerFieldInventory,
    this.ownerFieldInventoryOf,
    this.actualFieldCount,
  });

  void _checkInventory(Owner value) {
    final inventoryOf = ownerFieldInventoryOf;
    final inventory = inventoryOf?.call(value) ?? ownerFieldInventory;
    if (inventory == null) {
      if (inventoryOf == null) return;
      throw SchemaInventorySkewError(
        owner: inventoryOwner ?? Owner.toString(),
        metadataUnavailable: true,
      );
    }

    checkSchemaFieldInventory(
      owner: inventoryOwner ?? Owner.toString(),
      ownerFieldInventory: inventory,
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

  void _checkWireFields(String debugName) {
    final seen = <String>{};
    for (final field in fields) {
      final wire = field.wire;
      if (wire == 'v' || wire == 'type') {
        throw ArgumentError.value(
          wire,
          'fields',
          'Branch "$debugName" uses a protocol-reserved field name.',
        );
      }
      if (!_wireFieldPattern.hasMatch(wire)) {
        throw ArgumentError.value(
          wire,
          'fields',
          'Branch "$debugName" field names must use lower camel case.',
        );
      }
      if (!seen.add(wire)) {
        throw ArgumentError.value(
          wire,
          'fields',
          'Branch "$debugName" declares the same wire field more than once.',
        );
      }
    }
  }

  Map<String, SchemaFieldSemantics> get fieldSemantics => {
    for (final field in fields)
      if (!field.schemaSemantics.isEmpty) field.wire: field.schemaSemantics,
  };

  AckSchema<JsonMap, Owner> codec({String? debugName}) {
    _checkWireFields(debugName ?? Owner.toString());

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

    final groups = <Object, JsonMap>{};

    return {
      for (final field in fields)
        if (!omit.contains(field.wire))
          field.wire: field.readObject(value, groups),
    };
  }
}

final RegExp _wireFieldPattern = RegExp(r'^[a-z][A-Za-z0-9]*$');
