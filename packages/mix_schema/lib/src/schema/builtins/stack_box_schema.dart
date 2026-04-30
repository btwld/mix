import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../mix_schema_catalog.dart';
import '../styler_definition.dart';
import 'built_in_field_groups.dart';

StylerDefinition<StackBoxSpec, StackBoxStyler> buildStackBoxStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .stackBox,
    emptyStyle: StackBoxStyler(),
    fields: buildStackBoxStylerFields(catalog),
    build: (data, {animation, modifier, variants}) {
      return StackBoxStyler(
        decoration: data['decoration'] as DecorationMix?,
        foregroundDecoration: data['foregroundDecoration'] as DecorationMix?,
        padding: data['padding'] as EdgeInsetsGeometryMix?,
        margin: data['margin'] as EdgeInsetsGeometryMix?,
        alignment: data['alignment'] as AlignmentGeometry?,
        constraints: data['constraints'] as BoxConstraintsMix?,
        transform: data['transform'] as Matrix4?,
        transformAlignment: data['transformAlignment'] as AlignmentGeometry?,
        clipBehavior: data['clipBehavior'] as Clip?,
        stackAlignment: data['stackAlignment'] as AlignmentGeometry?,
        fit: data['fit'] as StackFit?,
        textDirection: data['textDirection'] as TextDirection?,
        stackClipBehavior: data['stackClipBehavior'] as Clip?,
        animation: animation,
        modifier: modifier,
        variants: variants,
      );
    },
  );
}
