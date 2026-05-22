import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

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

  return Map.unmodifiable(definitions);
}

CodecSchema<JsonMap, Object> _contractCodec<
  S extends Spec<S>,
  T extends Style<S>
>(StylerContract<S, T> contract) {
  return contract.codec as CodecSchema<JsonMap, Object>;
}
