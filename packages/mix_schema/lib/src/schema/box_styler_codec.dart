import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'styler_field_inventory.dart';
import 'styler_codec_helpers.dart';

AckSchema<JsonMap, BoxStyler> boxStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  required FrozenRegistry Function() registry,
}) {
  return _boxStylerSchemaType(rootStyleSchema, registry).codec();
}

JsonMap encodeBoxStylerFields(
  BoxStyler value, {
  bool includeStylerMetadata = true,
}) {
  return _boxStylerSchemaType(null, null).encodeFields(
    value,
    omit: includeStylerMetadata ? const {} : stylerMetadataFields,
  );
}

SchemaObject<BoxStyler> _boxStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
  FrozenRegistry Function()? registry,
) {
  final alignment = mixField<BoxStyler, Alignment, AlignmentGeometry>(
    'alignment',
    alignmentCodec(),
    (value) => value.$alignment,
  );
  final padding = mixField<BoxStyler, EdgeInsetsMix, EdgeInsetsGeometry>(
    'padding',
    edgeInsetsCodec(),
    (value) => value.$padding,
  );
  final margin = mixField<BoxStyler, EdgeInsetsMix, EdgeInsetsGeometry>(
    'margin',
    edgeInsetsCodec(),
    (value) => value.$margin,
  );
  final constraints = mixField<BoxStyler, BoxConstraintsMix, BoxConstraints>(
    'constraints',
    boxConstraintsCodec(),
    (value) => value.$constraints,
  );
  final clipBehavior = valueField<BoxStyler, Clip>(
    'clipBehavior',
    enumNameCodec(Clip.values),
    (value) => value.$clipBehavior,
  );
  final transform = valueField<BoxStyler, Matrix4>(
    'transform',
    matrix4Codec(),
    (value) => value.$transform,
  );
  final transformAlignment = mixField<BoxStyler, Alignment, AlignmentGeometry>(
    'transformAlignment',
    alignmentCodec(),
    (value) => value.$transformAlignment,
  );
  final decoration = mixField<BoxStyler, BoxDecorationMix, Decoration>(
    'decoration',
    boxDecorationCodec(),
    (value) => value.$decoration,
  );
  final metadata = StylerMetadataFields<BoxStyler, BoxSpec>(
    rootStyleSchema: rootStyleSchema,
    registry: registry ?? emptyFrozenRegistry,
    readVariants: (value) => value.$variants,
    readModifier: (value) => value.$modifier,
    readAnimation: (value) => value.$animation,
  );

  return SchemaObject<BoxStyler>(
    inventoryOwner: 'BoxStyler',
    ownerFieldInventory: boxStylerInventory,
    actualFieldCount: stylerFieldCount,
    fields: [
      alignment,
      padding,
      margin,
      constraints,
      clipBehavior,
      transform,
      transformAlignment,
      decoration,
      ...metadata.fields,
    ],
    unsupportedFields: [
      UnsupportedSchemaField<BoxStyler>(
        'foregroundDecoration',
        (value) => value.$foregroundDecoration,
      ),
      ...metadata.unsupportedFields(),
    ],
    build: (data) => BoxStyler(
      alignment: alignment.value(data),
      padding: padding.value(data),
      margin: margin.value(data),
      constraints: constraints.value(data),
      clipBehavior: clipBehavior.value(data),
      transform: transform.value(data),
      transformAlignment: transformAlignment.value(data),
      decoration: decoration.value(data),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}

CodecSchema<JsonMap, BoxDecorationMix> boxDecorationCodec() {
  return Ack.object({
    'color': colorCodec().optional(),
    'border': borderCodec().optional(),
    'borderRadius': borderRadiusCodec().optional(),
    'shape': enumNameCodec(BoxShape.values).optional(),
    'backgroundBlendMode': enumNameCodec(BlendMode.values).optional(),
    'boxShadow': Ack.list(boxShadowCodec()).optional(),
  }).codec<BoxDecorationMix>(
    decode: (data) => BoxDecorationMix(
      color: data['color'] as Color?,
      border: data['border'] as BorderMix?,
      borderRadius: data['borderRadius'] as BorderRadiusMix?,
      shape: data['shape'] as BoxShape?,
      backgroundBlendMode: data['backgroundBlendMode'] as BlendMode?,
      boxShadow: data['boxShadow'] as List<BoxShadowMix>?,
    ),
    encode: (value) {
      failIfPresent(value.$image, 'decoration.image');
      failIfPresent(value.$gradient, 'decoration.gradient');

      return {
        'color': singleValueProp(value.$color, 'decoration.color'),
        'border': singleMixProp<BorderMix, BoxBorder>(
          value.$border,
          'decoration.border',
        ),
        'borderRadius': singleMixProp<BorderRadiusMix, BorderRadiusGeometry>(
          value.$borderRadius,
          'decoration.borderRadius',
        ),
        'shape': singleValueProp(value.$shape, 'decoration.shape'),
        'backgroundBlendMode': singleValueProp(
          value.$backgroundBlendMode,
          'decoration.backgroundBlendMode',
        ),
        'boxShadow': _singleBoxShadowList(value),
      };
    },
  );
}

List<BoxShadowMix>? _singleBoxShadowList(BoxDecorationMix value) {
  final boxShadow = singleMixProp<BoxShadowListMix, List<BoxShadow>>(
    value.$boxShadow,
    'decoration.boxShadow',
  );

  return boxShadow?.items;
}
