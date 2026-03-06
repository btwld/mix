import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../mix_schema_catalog.dart';
import '../styler_definition.dart';

StylerDefinition<FlexBoxSpec, FlexBoxStyler> buildFlexBoxStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .flexBox,
    emptyStyle: FlexBoxStyler(),
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
      'direction': catalog.axis.optional(),
      'mainAxisAlignment': catalog.mainAxisAlignment.optional(),
      'crossAxisAlignment': catalog.crossAxisAlignment.optional(),
      'mainAxisSize': catalog.mainAxisSize.optional(),
      'verticalDirection': catalog.verticalDirection.optional(),
      'textDirection': catalog.textDirection.optional(),
      'textBaseline': catalog.textBaseline.optional(),
      'flexClipBehavior': catalog.clip.optional(),
      'spacing': Ack.double().optional(),
    },
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
