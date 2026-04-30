import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../mix_schema_catalog.dart';
import '../styler_definition.dart';
import 'built_in_field_groups.dart';

StylerDefinition<FlexSpec, FlexStyler> buildFlexStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .flex,
    emptyStyle: FlexStyler(),
    fields: buildFlexStylerFields(catalog),
    build: (data, {animation, modifier, variants}) {
      return FlexStyler(
        direction: data['direction'] as Axis?,
        mainAxisAlignment: data['mainAxisAlignment'] as MainAxisAlignment?,
        crossAxisAlignment: data['crossAxisAlignment'] as CrossAxisAlignment?,
        mainAxisSize: data['mainAxisSize'] as MainAxisSize?,
        verticalDirection: data['verticalDirection'] as VerticalDirection?,
        textDirection: data['textDirection'] as TextDirection?,
        textBaseline: data['textBaseline'] as TextBaseline?,
        clipBehavior: data['clipBehavior'] as Clip?,
        spacing: data['spacing'] as double?,
        animation: animation,
        modifier: modifier,
        variants: variants,
      );
    },
  );
}
