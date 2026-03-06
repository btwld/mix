import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../mix_schema_catalog.dart';
import '../styler_definition.dart';

StylerDefinition<FlexSpec, FlexStyler> buildFlexStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .flex,
    emptyStyle: FlexStyler(),
    fields: {
      'direction': catalog.axis.optional(),
      'mainAxisAlignment': catalog.mainAxisAlignment.optional(),
      'crossAxisAlignment': catalog.crossAxisAlignment.optional(),
      'mainAxisSize': catalog.mainAxisSize.optional(),
      'verticalDirection': catalog.verticalDirection.optional(),
      'textDirection': catalog.textDirection.optional(),
      'textBaseline': catalog.textBaseline.optional(),
      'clipBehavior': catalog.clip.optional(),
      'spacing': Ack.double().optional(),
    },
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
