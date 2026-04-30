import 'package:ack/ack.dart';

import '../mix_schema_catalog.dart';

Map<String, AckSchema> buildBoxStylerFields(MixSchemaCatalog catalog) {
  return {
    'alignment': catalog.alignment.optional(),
    ..._boxSpacingFields(catalog),
    'constraints': catalog.boxConstraints.optional(),
    ..._boxDecorationFields(catalog),
    ..._boxTransformAndClipFields(catalog),
  };
}

Map<String, AckSchema> buildFlexStylerFields(MixSchemaCatalog catalog) {
  return _flexLayoutFields(catalog);
}

Map<String, AckSchema> buildStackStylerFields(MixSchemaCatalog catalog) {
  return _stackLayoutFields(catalog);
}

Map<String, AckSchema> buildFlexBoxStylerFields(MixSchemaCatalog catalog) {
  return {
    ..._boxDecorationFields(catalog),
    ..._boxSpacingFields(catalog),
    'alignment': catalog.alignment.optional(),
    'constraints': catalog.boxConstraints.optional(),
    ..._boxTransformAndClipFields(catalog),
    ..._flexLayoutFields(catalog, clipBehaviorField: 'flexClipBehavior'),
  };
}

Map<String, AckSchema> buildStackBoxStylerFields(MixSchemaCatalog catalog) {
  return {
    ..._boxDecorationFields(catalog),
    ..._boxSpacingFields(catalog),
    'alignment': catalog.alignment.optional(),
    'constraints': catalog.boxConstraints.optional(),
    ..._boxTransformAndClipFields(catalog),
    ..._stackLayoutFields(
      catalog,
      alignmentField: 'stackAlignment',
      clipBehaviorField: 'stackClipBehavior',
    ),
  };
}

Map<String, AckSchema> _boxSpacingFields(MixSchemaCatalog catalog) {
  return {
    'padding': catalog.edgeInsetsGeometry.optional(),
    'margin': catalog.edgeInsetsGeometry.optional(),
  };
}

Map<String, AckSchema> _boxDecorationFields(MixSchemaCatalog catalog) {
  return {
    'decoration': catalog.decoration.optional(),
    'foregroundDecoration': catalog.decoration.optional(),
  };
}

Map<String, AckSchema> _boxTransformAndClipFields(MixSchemaCatalog catalog) {
  return {
    'transform': catalog.matrix4.optional(),
    'transformAlignment': catalog.alignment.optional(),
    'clipBehavior': catalog.clip.optional(),
  };
}

Map<String, AckSchema> _flexLayoutFields(
  MixSchemaCatalog catalog, {
  String clipBehaviorField = 'clipBehavior',
}) {
  return {
    'direction': catalog.axis.optional(),
    'mainAxisAlignment': catalog.mainAxisAlignment.optional(),
    'crossAxisAlignment': catalog.crossAxisAlignment.optional(),
    'mainAxisSize': catalog.mainAxisSize.optional(),
    'verticalDirection': catalog.verticalDirection.optional(),
    'textDirection': catalog.textDirection.optional(),
    'textBaseline': catalog.textBaseline.optional(),
    clipBehaviorField: catalog.clip.optional(),
    'spacing': Ack.double().optional(),
  };
}

Map<String, AckSchema> _stackLayoutFields(
  MixSchemaCatalog catalog, {
  String alignmentField = 'alignment',
  String clipBehaviorField = 'clipBehavior',
}) {
  return {
    alignmentField: catalog.alignment.optional(),
    'fit': catalog.stackFit.optional(),
    'textDirection': catalog.textDirection.optional(),
    clipBehaviorField: catalog.clip.optional(),
  };
}
