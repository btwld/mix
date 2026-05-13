import 'package:ack/ack.dart';

/// Returns the object input schema behind an object-backed schema.
ObjectSchema? unwrapObjectBackedSchema(AckSchema schema) {
  var current = schema;

  while (true) {
    if (current is ObjectSchema) {
      return current;
    }

    if (current is CodecSchema) {
      current = current.inputSchema;
      continue;
    }

    return null;
  }
}

/// Requires [schema] to be backed by an [Ack.object] input shape.
ObjectSchema requireObjectBackedSchema(AckSchema schema, String message) {
  final objectSchema = unwrapObjectBackedSchema(schema);
  if (objectSchema == null) {
    throw ArgumentError.value(schema, 'schema', message);
  }

  return objectSchema;
}
