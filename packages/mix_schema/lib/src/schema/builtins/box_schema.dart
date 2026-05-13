import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_map.dart';
import '../mix_schema_catalog.dart';
import '../styler_definition.dart';
import 'built_in_field_groups.dart';
import 'styler_field_encoders.dart';

StylerContract<BoxSpec, BoxStyler> buildBoxStylerDefinition(
  MixSchemaCatalog catalog,
) {
  final emptyStyle = BoxStyler();
  final fields = buildBoxStylerFields(catalog);

  return buildStylerCodecContract(
    catalog: catalog,
    type: .box,
    emptyStyle: emptyStyle,
    fields: fields,
    build: _decodeBoxStyler,
    encodeFields: encodeBoxFields,
  );
}

BoxStyler _decodeBoxStyler(
  JsonMap data, {
  AnimationConfig? animation,
  WidgetModifierConfig? modifier,
  List<VariantStyle<BoxSpec>>? variants,
}) {
  return BoxStyler(
    alignment: data['alignment'] as AlignmentGeometry?,
    padding: data['padding'] as EdgeInsetsGeometryMix?,
    margin: data['margin'] as EdgeInsetsGeometryMix?,
    constraints: data['constraints'] as BoxConstraintsMix?,
    decoration: data['decoration'] as DecorationMix?,
    foregroundDecoration: data['foregroundDecoration'] as DecorationMix?,
    transform: data['transform'] as Matrix4?,
    transformAlignment: data['transformAlignment'] as AlignmentGeometry?,
    clipBehavior: data['clipBehavior'] as Clip?,
    animation: animation,
    modifier: modifier,
    variants: variants,
  );
}
