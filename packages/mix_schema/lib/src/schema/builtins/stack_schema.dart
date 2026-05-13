import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_map.dart';
import '../mix_schema_catalog.dart';
import '../styler_definition.dart';
import 'built_in_field_groups.dart';
import 'styler_field_encoders.dart';

StylerContract<StackSpec, StackStyler> buildStackStylerDefinition(
  MixSchemaCatalog catalog,
) {
  final emptyStyle = StackStyler();
  final fields = buildStackStylerFields(catalog);

  return buildStylerCodecContract(
    catalog: catalog,
    type: .stack,
    emptyStyle: emptyStyle,
    fields: fields,
    build: _decodeStackStyler,
    encodeFields: encodeStackFields,
  );
}

StackStyler _decodeStackStyler(
  JsonMap data, {
  AnimationConfig? animation,
  WidgetModifierConfig? modifier,
  List<VariantStyle<StackSpec>>? variants,
}) {
  return StackStyler(
    alignment: data['alignment'] as AlignmentGeometry?,
    fit: data['fit'] as StackFit?,
    textDirection: data['textDirection'] as TextDirection?,
    clipBehavior: data['clipBehavior'] as Clip?,
    animation: animation,
    modifier: modifier,
    variants: variants,
  );
}
