import 'package:ack/ack.dart';

import '../shared/shared_schemas.dart';
import '../styler_catalog.dart';

Map<String, AckSchema> buildBoxStylerFields(StylerCatalog catalog) {
  return {
    'alignment': alignmentCodec.optional(),
    ..._boxSpacingFields(),
    'constraints': boxConstraintsCodec.optional(),
    ..._boxDecorationFields(catalog),
    ..._boxTransformAndClipFields(),
  };
}

Map<String, AckSchema> buildFlexStylerFields() {
  return _flexLayoutFields();
}

Map<String, AckSchema> buildStackStylerFields() {
  return _stackLayoutFields();
}

Map<String, AckSchema> buildFlexBoxStylerFields(StylerCatalog catalog) {
  return {
    ..._boxDecorationFields(catalog),
    ..._boxSpacingFields(),
    'alignment': alignmentCodec.optional(),
    'constraints': boxConstraintsCodec.optional(),
    ..._boxTransformAndClipFields(),
    ..._flexLayoutFields(clipBehaviorField: 'flexClipBehavior'),
  };
}

Map<String, AckSchema> buildStackBoxStylerFields(StylerCatalog catalog) {
  return {
    ..._boxDecorationFields(catalog),
    ..._boxSpacingFields(),
    'alignment': alignmentCodec.optional(),
    'constraints': boxConstraintsCodec.optional(),
    ..._boxTransformAndClipFields(),
    ..._stackLayoutFields(
      alignmentField: 'stackAlignment',
      clipBehaviorField: 'stackClipBehavior',
    ),
  };
}

Map<String, AckSchema> _boxSpacingFields() {
  return {
    'padding': edgeInsetsGeometryCodec.optional(),
    'margin': edgeInsetsGeometryCodec.optional(),
  };
}

Map<String, AckSchema> _boxDecorationFields(StylerCatalog catalog) {
  return {
    'decoration': catalog.decorationCodec.optional(),
    'foregroundDecoration': catalog.decorationCodec.optional(),
  };
}

Map<String, AckSchema> _boxTransformAndClipFields() {
  return {
    'transform': matrix4Codec.optional(),
    'transformAlignment': alignmentCodec.optional(),
    'clipBehavior': clipSchema.optional(),
  };
}

Map<String, AckSchema> _flexLayoutFields({
  String clipBehaviorField = 'clipBehavior',
}) {
  return {
    'direction': axisSchema.optional(),
    'mainAxisAlignment': mainAxisAlignmentSchema.optional(),
    'crossAxisAlignment': crossAxisAlignmentSchema.optional(),
    'mainAxisSize': mainAxisSizeSchema.optional(),
    'verticalDirection': verticalDirectionSchema.optional(),
    'textDirection': textDirectionSchema.optional(),
    'textBaseline': textBaselineSchema.optional(),
    clipBehaviorField: clipSchema.optional(),
    'spacing': Ack.number().optional(),
  };
}

Map<String, AckSchema> _stackLayoutFields({
  String alignmentField = 'alignment',
  String clipBehaviorField = 'clipBehavior',
}) {
  return {
    alignmentField: alignmentCodec.optional(),
    'fit': stackFitSchema.optional(),
    'textDirection': textDirectionSchema.optional(),
    clipBehaviorField: clipSchema.optional(),
  };
}
