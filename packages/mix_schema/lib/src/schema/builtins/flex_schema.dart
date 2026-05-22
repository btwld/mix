import 'package:ack/ack.dart' show JsonMap;
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../styler_catalog.dart';
import '../styler_definition.dart';
import 'built_in_field_groups.dart';
import 'styler_field_encoders.dart';

StylerContract<FlexSpec, FlexStyler> buildFlexStylerDefinition(
  StylerCatalog catalog,
) {
  final emptyStyle = FlexStyler();
  final fields = buildFlexStylerFields();

  return buildStylerCodecContract(
    catalog: catalog,
    type: .flex,
    emptyStyle: emptyStyle,
    fields: fields,
    build: _decodeFlexStyler,
    encodeFields: encodeFlexFields,
  );
}

FlexStyler _decodeFlexStyler(
  JsonMap data, {
  AnimationConfig? animation,
  WidgetModifierConfig? modifier,
  List<VariantStyle<FlexSpec>>? variants,
}) {
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
}
