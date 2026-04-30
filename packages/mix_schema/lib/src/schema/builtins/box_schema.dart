import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../mix_schema_catalog.dart';
import '../styler_definition.dart';
import 'built_in_field_groups.dart';

StylerDefinition<BoxSpec, BoxStyler> buildBoxStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .box,
    emptyStyle: BoxStyler(),
    fields: buildBoxStylerFields(catalog),
    build: (data, {animation, modifier, variants}) {
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
    },
  );
}
