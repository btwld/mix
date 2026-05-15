import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/json_map.dart';
import '../../core/schema_wire_types.dart';
import '../styler_catalog.dart';
import '../styler_definition.dart';
import 'box_schema.dart';
import 'flex_box_schema.dart';
import 'flex_schema.dart';
import 'icon_schema.dart';
import 'image_schema.dart';
import 'stack_box_schema.dart';
import 'stack_schema.dart';
import 'text_schema.dart';

Map<SchemaStyler, CodecSchema<JsonMap, Object>> buildBuiltInStylerDefinitions(
  StylerCatalog catalog,
) {
  final definitions = {
    SchemaStyler.box: _contractCodec(buildBoxStylerDefinition(catalog)),
    SchemaStyler.text: _contractCodec(buildTextStylerDefinition(catalog)),
    SchemaStyler.flex: _contractCodec(buildFlexStylerDefinition(catalog)),
    SchemaStyler.icon: _contractCodec(buildIconStylerDefinition(catalog)),
    SchemaStyler.image: _contractCodec(buildImageStylerDefinition(catalog)),
    SchemaStyler.stack: _contractCodec(buildStackStylerDefinition(catalog)),
    SchemaStyler.flexBox: _contractCodec(buildFlexBoxStylerDefinition(catalog)),
    SchemaStyler.stackBox: _contractCodec(
      buildStackBoxStylerDefinition(catalog),
    ),
  };

  assert(
    definitions.length == SchemaStyler.values.length &&
        SchemaStyler.values.every(definitions.containsKey),
    'buildBuiltInStylerDefinitions must cover every built-in SchemaStyler.',
  );
  assert(
    definitions.entries.every(
      (entry) => _hasTopLevelType(entry.value, entry.key),
    ),
    'Built-in styler definition map keys must match their definition types.',
  );

  return Map.unmodifiable(definitions);
}

CodecSchema<JsonMap, Object> _contractCodec<
  S extends Spec<S>,
  T extends Style<S>
>(StylerContract<S, T> contract) {
  return contract.codec as CodecSchema<JsonMap, Object>;
}

bool _hasTopLevelType(CodecSchema<JsonMap, Object> codec, SchemaStyler type) {
  final inputSchema = codec.inputSchema;
  final typeSchema = inputSchema is ObjectSchema
      ? inputSchema.properties['type']
      : null;

  return typeSchema != null &&
      typeSchema.toJsonSchema()['const'] == type.wireValue;
}
