import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/schema_wire_types.dart';
import '../discriminated_schema_builder.dart';
import '../mix_schema_catalog.dart';
import '../styler_definition.dart';
import 'box_schema.dart';
import 'flex_box_schema.dart';
import 'flex_schema.dart';
import 'icon_schema.dart';
import 'image_schema.dart';
import 'stack_box_schema.dart';
import 'stack_schema.dart';
import 'text_schema.dart';

final class BuiltInStylerContractEntry {
  final SchemaStyler type;
  final DiscriminatedSchemaBranch<Object> branch;
  final AckSchema<Object> schema;
  final List<String> fields;
  final List<String> unsupportedFields;

  const BuiltInStylerContractEntry({
    required this.type,
    required this.branch,
    required this.schema,
    required this.fields,
    this.unsupportedFields = const [],
  });
}

Map<SchemaStyler, BuiltInStylerContractEntry> buildBuiltInStylerDefinitions(
  MixSchemaCatalog catalog,
) {
  final definitions = {
    SchemaStyler.box: _entry(buildBoxStylerDefinition(catalog), catalog),
    SchemaStyler.text: _entry(buildTextStylerDefinition(catalog), catalog),
    SchemaStyler.flex: _entry(buildFlexStylerDefinition(catalog), catalog),
    SchemaStyler.icon: _entry(buildIconStylerDefinition(catalog), catalog),
    SchemaStyler.image: _entry(buildImageStylerDefinition(catalog), catalog),
    SchemaStyler.stack: _entry(buildStackStylerDefinition(catalog), catalog),
    SchemaStyler.flexBox: _entry(
      buildFlexBoxStylerDefinition(catalog),
      catalog,
    ),
    SchemaStyler.stackBox: _entry(
      buildStackBoxStylerDefinition(catalog),
      catalog,
    ),
  };

  assert(
    definitions.length == SchemaStyler.values.length &&
        SchemaStyler.values.every(definitions.containsKey),
    'buildBuiltInStylerDefinitions must cover every built-in SchemaStyler.',
  );
  assert(
    definitions.entries.every((entry) => entry.key == entry.value.type),
    'Built-in styler definition map keys must match their definition types.',
  );

  return Map.unmodifiable(definitions);
}

BuiltInStylerContractEntry _entry<S extends Spec<S>, T extends Style<S>>(
  StylerDefinition<S, T> definition,
  MixSchemaCatalog catalog,
) {
  final schema = buildStylerSchema(definition: definition, catalog: catalog);

  return BuiltInStylerContractEntry(
    type: definition.type,
    branch: discriminatedBranch(
      type: definition.type.wireValue,
      schema: schema,
    ),
    schema: schema as AckSchema<Object>,
    fields: definition.fields.keys.toList(growable: false),
    unsupportedFields: definition.unsupportedFields,
  );
}
