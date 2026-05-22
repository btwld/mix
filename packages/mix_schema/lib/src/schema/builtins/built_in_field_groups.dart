import 'package:ack/ack.dart';

import '../../core/numeric_codecs.dart';
import '../shared/shared_schemas.dart';
import '../styler_catalog.dart';

Map<String, AckSchema<Object, Object>> buildBoxStylerFields(
  StylerCatalog catalog,
) {
  return {
    'alignment': alignmentCodec.optional(),
    ..._boxSpacingFields(),
    'constraints': boxConstraintsCodec.optional(),
    ..._boxDecorationFields(catalog),
    ..._boxTransformAndClipFields(),
  };
}

Map<String, AckSchema<Object, Object>> buildFlexStylerFields() {
  return _flexLayoutFields();
}

Map<String, AckSchema<Object, Object>> buildStackStylerFields() {
  return _stackLayoutFields();
}

Map<String, AckSchema<Object, Object>> buildFlexBoxStylerFields(
  StylerCatalog catalog,
) {
  return {
    ..._boxDecorationFields(catalog),
    ..._boxSpacingFields(),
    'alignment': alignmentCodec.optional(),
    'constraints': boxConstraintsCodec.optional(),
    ..._boxTransformAndClipFields(),
    ..._flexLayoutFields(clipBehaviorField: 'flexClipBehavior'),
  };
}

Map<String, AckSchema<Object, Object>> buildStackBoxStylerFields(
  StylerCatalog catalog,
) {
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

Map<String, AckSchema<Object, Object>> _boxSpacingFields() {
  return {
    'padding': edgeInsetsGeometryCodec.optional(),
    'margin': edgeInsetsGeometryCodec.optional(),
  };
}

Map<String, AckSchema<Object, Object>> _boxDecorationFields(
  StylerCatalog catalog,
) {
  return {
    'decoration': catalog.decorationCodec.optional(),
    'foregroundDecoration': catalog.decorationCodec.optional(),
  };
}

Map<String, AckSchema<Object, Object>> _boxTransformAndClipFields() {
  return {
    'transform': matrix4Codec.optional(),
    'transformAlignment': alignmentCodec.optional(),
    'clipBehavior': clipSchema.optional(),
  };
}

Map<String, AckSchema<Object, Object>> _flexLayoutFields({
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
    'spacing': doubleFromNum().optional(),
  };
}

Map<String, AckSchema<Object, Object>> _stackLayoutFields({
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
