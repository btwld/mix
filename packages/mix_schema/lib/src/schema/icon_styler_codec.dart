import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import '../registry/registry_value_codec.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'styler_field_inventory.dart';
import 'styler_codec_helpers.dart';

AckSchema<JsonMap, IconStyler> iconStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  required FrozenRegistry Function() registry,
}) {
  return _iconStylerSchemaType(rootStyleSchema, registry).codec();
}

SchemaObject<IconStyler> _iconStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
  FrozenRegistry Function() registry,
) {
  final icon = propValueField<IconStyler, IconData>(
    'icon',
    registryValueCodec<IconData>(registry, MixSchemaScope.iconData),
    (value) => value.$icon,
  );
  final color = propTokenValueField<IconStyler, Color>(
    'color',
    colorCodec(),
    (value) => value.$color,
  );
  final size = propTokenValueField<IconStyler, double>(
    'size',
    nonNegativeDoubleTokenCodec(),
    (value) => value.$size,
  );
  final weight = propTokenValueField<IconStyler, double>(
    'weight',
    doubleTokenCodec(),
    (value) => value.$weight,
  );
  final grade = propTokenValueField<IconStyler, double>(
    'grade',
    doubleTokenCodec(),
    (value) => value.$grade,
  );
  final opticalSize = propTokenValueField<IconStyler, double>(
    'opticalSize',
    nonNegativeDoubleTokenCodec(),
    (value) => value.$opticalSize,
  );
  final shadows = propMixField<IconStyler, ShadowListMix, List<Shadow>>(
    'shadows',
    shadowListMixCodec(),
    (value) => value.$shadows,
  );
  final textDirection = propValueField<IconStyler, TextDirection>(
    'textDirection',
    textDirectionCodec(),
    (value) => value.$textDirection,
  );
  final applyTextScaling = propValueField<IconStyler, bool>(
    'applyTextScaling',
    Ack.boolean(),
    (value) => value.$applyTextScaling,
  );
  final fill = propTokenValueField<IconStyler, double>(
    'fill',
    doubleTokenCodec(),
    (value) => value.$fill,
  );
  final semanticsLabel = propValueField<IconStyler, String>(
    'semanticsLabel',
    Ack.string(),
    (value) => value.$semanticsLabel,
  );
  final opacity = propTokenValueField<IconStyler, double>(
    'opacity',
    doubleTokenCodec(),
    (value) => value.$opacity,
  );
  final blendMode = propValueField<IconStyler, BlendMode>(
    'blendMode',
    enumNameCodec(BlendMode.values),
    (value) => value.$blendMode,
  );
  final metadata = StylerMetadataFields<IconStyler, IconSpec>(
    rootStyleSchema: rootStyleSchema,
    registry: registry,
    readVariants: (value) => value.$variants,
    readModifier: (value) => value.$modifier,
    readAnimation: (value) => value.$animation,
  );

  return SchemaObject<IconStyler>(
    inventoryOwner: 'IconStyler',
    ownerFieldInventory: iconStylerInventory,
    actualFieldCount: stylerFieldCount,
    fields: [
      icon,
      color,
      size,
      weight,
      grade,
      opticalSize,
      shadows,
      textDirection,
      applyTextScaling,
      fill,
      semanticsLabel,
      opacity,
      blendMode,
      ...metadata.fields,
    ],
    unsupportedFields: [...metadata.unsupportedFields()],
    build: (data) => IconStyler.create(
      icon: icon.value(data),
      color: color.value(data),
      size: size.value(data),
      weight: weight.value(data),
      grade: grade.value(data),
      opticalSize: opticalSize.value(data),
      shadows: shadows.value(data),
      textDirection: textDirection.value(data),
      applyTextScaling: applyTextScaling.value(data),
      fill: fill.value(data),
      semanticsLabel: semanticsLabel.value(data),
      opacity: opacity.value(data),
      blendMode: blendMode.value(data),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}
