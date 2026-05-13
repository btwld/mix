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

  const BuiltInStylerContractEntry({
    required this.type,
    required this.branch,
    required this.schema,
  });
}

Map<SchemaStyler, BuiltInStylerContractEntry> buildBuiltInStylerDefinitions(
  MixSchemaCatalog catalog,
) {
  final definitions = {
    SchemaStyler.box: _contractEntry(buildBoxStylerDefinition(catalog)),
    SchemaStyler.text: _contractEntry(buildTextStylerDefinition(catalog)),
    SchemaStyler.flex: _contractEntry(buildFlexStylerDefinition(catalog)),
    SchemaStyler.icon: _contractEntry(buildIconStylerDefinition(catalog)),
    SchemaStyler.image: _contractEntry(buildImageStylerDefinition(catalog)),
    SchemaStyler.stack: _contractEntry(buildStackStylerDefinition(catalog)),
    SchemaStyler.flexBox: _contractEntry(buildFlexBoxStylerDefinition(catalog)),
    SchemaStyler.stackBox: _contractEntry(
      buildStackBoxStylerDefinition(catalog),
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

BuiltInStylerContractEntry _contractEntry<
  S extends Spec<S>,
  T extends Style<S>
>(StylerContract<S, T> contract) {
  return BuiltInStylerContractEntry(
    type: contract.type,
    branch: discriminatedBranch(
      type: contract.type.wireValue,
      schema: contract.codec,
    ),
    schema: contract.codec as AckSchema<Object>,
  );
}
