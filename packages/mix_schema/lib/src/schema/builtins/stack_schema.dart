import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../mix_schema_catalog.dart';
import '../styler_definition.dart';

StylerDefinition<StackSpec, StackStyler> buildStackStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .stack,
    emptyStyle: StackStyler(),
    fields: {
      'alignment': catalog.alignment.optional(),
      'fit': catalog.stackFit.optional(),
      'textDirection': catalog.textDirection.optional(),
      'clipBehavior': catalog.clip.optional(),
    },
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
