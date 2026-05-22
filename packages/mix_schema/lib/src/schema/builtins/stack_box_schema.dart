import 'package:ack/ack.dart' show JsonMap;
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../styler_catalog.dart';
import '../styler_definition.dart';
import 'built_in_field_groups.dart';
import 'styler_field_encoders.dart';

StylerContract<StackBoxSpec, StackBoxStyler> buildStackBoxStylerDefinition(
  StylerCatalog catalog,
) {
  return buildStylerCodecContract(
    catalog: catalog,
    type: .stackBox,
    emptyStyle: StackBoxStyler(),
    fields: buildStackBoxStylerFields(catalog),
    build: _decodeStackBoxStyler,
    encodeFields: encodeStackBoxFields,
  );
}

StackBoxStyler _decodeStackBoxStyler(
  JsonMap data, {
  AnimationConfig? animation,
  WidgetModifierConfig? modifier,
  List<VariantStyle<StackBoxSpec>>? variants,
}) {
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
}
