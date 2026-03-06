import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../mix_schema_catalog.dart';
import '../styler_definition.dart';

StylerDefinition<BoxSpec, BoxStyler> buildBoxStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .box,
    emptyStyle: BoxStyler(),
    fields: {
      'alignment': catalog.alignment.optional(),
      'padding': catalog.edgeInsetsGeometry.optional(),
      'margin': catalog.edgeInsetsGeometry.optional(),
      'constraints': catalog.boxConstraints.optional(),
      'decoration': catalog.decoration.optional(),
      'foregroundDecoration': catalog.decoration.optional(),
      'transform': catalog.matrix4.optional(),
      'transformAlignment': catalog.alignment.optional(),
      'clipBehavior': catalog.clip.optional(),
    },
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
