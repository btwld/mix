import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../mix_schema_catalog.dart';
import '../styler_definition.dart';
import 'built_in_field_groups.dart';

StylerDefinition<StackSpec, StackStyler> buildStackStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .stack,
    emptyStyle: StackStyler(),
    fields: buildStackStylerFields(catalog),
    build: (data, {animation, modifier, variants}) {
      return StackStyler(
        alignment: data['alignment'] as AlignmentGeometry?,
        fit: data['fit'] as StackFit?,
        textDirection: data['textDirection'] as TextDirection?,
        clipBehavior: data['clipBehavior'] as Clip?,
        animation: animation,
        modifier: modifier,
        variants: variants,
      );
    },
  );
}
