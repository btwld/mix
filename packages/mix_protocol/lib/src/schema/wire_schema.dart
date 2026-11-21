import 'dart:convert';

import 'package:ack/ack.dart';

/// Supplies the wire grammar for codecs that dispatch on property markers.
///
/// The codec performs validation and preserves its diagnostic paths. Ack uses
/// this constraint to export the same literal schemas and control grammar.
final class WireSchemaConstraint<T> extends Constraint<T>
    with JsonSchemaSpec<T> {
  final JsonMap Function() _build;
  late final JsonMap _schema = _definitionSchema(_build());

  WireSchemaConstraint(this._build)
    : super(
        constraintKey: 'mix_protocol_wire_schema',
        description: 'The wire grammar of a marker-dispatched codec.',
      );

  @override
  JsonMap toJsonSchema() => _schema;

  @override
  bool operator ==(Object other) =>
      other is WireSchemaConstraint<T> && identical(_build, other._build);

  @override
  int get hashCode => _build.hashCode;
}

/// Identifies an existing definition without traversing a recursive codec.
final class WireSchemaReference<T> extends Constraint<T> {
  final String name;

  const WireSchemaReference(this.name)
    : super(
        constraintKey: 'mix_protocol_wire_reference',
        description: 'A reference to a shared wire definition.',
      );

  @override
  bool operator ==(Object other) =>
      other is WireSchemaReference<T> && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

JsonMap literalWireSchema(AckSchema<Object, Object> codec) {
  final references = codec.constraints.whereType<WireSchemaReference>();
  if (references.isNotEmpty) return wireSchemaReference(references.single.name);

  return codec.toJsonSchema();
}

JsonMap _definitionSchema(JsonMap schema) {
  if (schema.containsKey(r'$ref')) return schema;
  final name = wireSchemaName(schema);

  return {
    ...wireSchemaReference(name),
    'definitions': {name: schema},
  };
}

JsonMap wireSchemaReference(String name) => {r'$ref': '#/definitions/$name'};

/// Gives identical grammars identical names across fields and compositions.
String wireSchemaName(JsonMap schema, {String prefix = 'value'}) {
  var hash = 0x811c9dc5;
  for (final byte in utf8.encode(jsonEncode(schema))) {
    hash ^= byte;
    hash = (hash * 0x193 + (hash << 24)) & 0xffffffff;
  }

  return 'mix_protocol_${prefix}_${hash.toRadixString(16)}';
}

/// Moves local definitions to the document root without changing their rules.
JsonMap hoistWireDefinitions(JsonMap schema) {
  final definitions = <String, Object?>{};

  Object? visit(Object? value) {
    if (value is List) return [for (final item in value) visit(item)];
    if (value is! Map) return value;
    final local = value['definitions'];
    if (local is Map) {
      for (final entry in local.entries) {
        final name = entry.key as String;
        final definition = visit(entry.value);
        if (definitions.containsKey(name) &&
            !deepEquals(definitions[name], definition)) {
          throw StateError('Conflicting wire definition "$name".');
        }
        definitions[name] = definition;
      }
    }
    // Draft 7 ignores validation siblings of a reference.
    if (value.containsKey(r'$ref')) return {r'$ref': value[r'$ref']};

    return <String, Object?>{
      for (final entry in value.entries)
        if (entry.key != 'definitions' && entry.key != 'x-transformed')
          entry.key as String: visit(entry.value),
    };
  }

  final root = visit(schema) as JsonMap;

  return {...root, if (definitions.isNotEmpty) 'definitions': definitions};
}
