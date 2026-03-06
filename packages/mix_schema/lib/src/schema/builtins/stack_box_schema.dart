import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../mix_schema_catalog.dart';
import '../styler_definition.dart';

StylerDefinition<StackBoxSpec, StackBoxStyler> buildStackBoxStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .stackBox,
    emptyStyle: StackBoxStyler(),
    fields: {
      'decoration': catalog.decoration.optional(),
      'foregroundDecoration': catalog.decoration.optional(),
      'padding': catalog.edgeInsetsGeometry.optional(),
      'margin': catalog.edgeInsetsGeometry.optional(),
      'alignment': catalog.alignment.optional(),
      'constraints': catalog.boxConstraints.optional(),
      'transform': catalog.matrix4.optional(),
      'transformAlignment': catalog.alignment.optional(),
      'clipBehavior': catalog.clip.optional(),
      'stackAlignment': catalog.alignment.optional(),
      'fit': catalog.stackFit.optional(),
      'textDirection': catalog.textDirection.optional(),
      'stackClipBehavior': catalog.clip.optional(),
    },
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
