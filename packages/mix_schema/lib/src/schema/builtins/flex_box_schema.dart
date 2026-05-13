import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/json_map.dart';
import '../mix_schema_catalog.dart';
import '../styler_definition.dart';
import 'built_in_field_groups.dart';
import 'styler_field_encoders.dart';

StylerContract<FlexBoxSpec, FlexBoxStyler> buildFlexBoxStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return buildStylerCodecContract(
    catalog: catalog,
    type: .flexBox,
    emptyStyle: FlexBoxStyler(),
    fields: buildFlexBoxStylerFields(catalog),
    build: _decodeFlexBoxStyler,
    encodeFields: encodeFlexBoxFields,
  );
}

FlexBoxStyler _decodeFlexBoxStyler(
  JsonMap data, {
  AnimationConfig? animation,
  WidgetModifierConfig? modifier,
  List<VariantStyle<FlexBoxSpec>>? variants,
}) {
  return FlexBoxStyler(
    decoration: data['decoration'] as DecorationMix?,
    foregroundDecoration: data['foregroundDecoration'] as DecorationMix?,
    padding: data['padding'] as EdgeInsetsGeometryMix?,
    margin: data['margin'] as EdgeInsetsGeometryMix?,
    alignment: data['alignment'] as AlignmentGeometry?,
    constraints: data['constraints'] as BoxConstraintsMix?,
    transform: data['transform'] as Matrix4?,
    transformAlignment: data['transformAlignment'] as AlignmentGeometry?,
    clipBehavior: data['clipBehavior'] as Clip?,
    direction: data['direction'] as Axis?,
    mainAxisAlignment: data['mainAxisAlignment'] as MainAxisAlignment?,
    crossAxisAlignment: data['crossAxisAlignment'] as CrossAxisAlignment?,
    mainAxisSize: data['mainAxisSize'] as MainAxisSize?,
    verticalDirection: data['verticalDirection'] as VerticalDirection?,
    textDirection: data['textDirection'] as TextDirection?,
    textBaseline: data['textBaseline'] as TextBaseline?,
    flexClipBehavior: data['flexClipBehavior'] as Clip?,
    spacing: castDoubleOrNull(data['spacing']),
    animation: animation,
    modifier: modifier,
    variants: variants,
  );
}
