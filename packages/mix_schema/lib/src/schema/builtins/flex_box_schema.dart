import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../mix_schema_catalog.dart';
import '../styler_definition.dart';
import 'built_in_field_groups.dart';

StylerDefinition<FlexBoxSpec, FlexBoxStyler> buildFlexBoxStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .flexBox,
    emptyStyle: FlexBoxStyler(),
    fields: buildFlexBoxStylerFields(catalog),
    build: (data, {animation, modifier, variants}) {
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
        spacing: data['spacing'] as double?,
        animation: animation,
        modifier: modifier,
        variants: variants,
      );
    },
  );
}
