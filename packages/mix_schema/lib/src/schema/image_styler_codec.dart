import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../contract/identity_resolution.dart';
import '../registry/registry_value_codec.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'styler_field_inventory.dart';
import 'styler_codec_helpers.dart';

AckSchema<JsonMap, ImageStyler> imageStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  required MixSchemaIdentityContext Function() identityContext,
}) {
  return _imageStylerSchemaType(rootStyleSchema, identityContext).codec();
}

SchemaObject<ImageStyler> _imageStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
  MixSchemaIdentityContext Function() identityContext,
) {
  final image = propValueField<ImageStyler, ImageProvider<Object>>(
    'image',
    imageProviderIdentityCodec(identityContext),
    (value) => value.$image,
  );
  final width = propTokenValueField<ImageStyler, double>(
    'width',
    nonNegativeDoubleTokenCodec(),
    (value) => value.$width,
  );
  final height = propTokenValueField<ImageStyler, double>(
    'height',
    nonNegativeDoubleTokenCodec(),
    (value) => value.$height,
  );
  final color = propTokenValueField<ImageStyler, Color>(
    'color',
    colorCodec(),
    (value) => value.$color,
  );
  final repeat = propValueField<ImageStyler, ImageRepeat>(
    'repeat',
    enumNameCodec(ImageRepeat.values),
    (value) => value.$repeat,
  );
  final fit = propValueField<ImageStyler, BoxFit>(
    'fit',
    enumNameCodec(BoxFit.values),
    (value) => value.$fit,
  );
  final alignment = propValueAsField<ImageStyler, Alignment, AlignmentGeometry>(
    'alignment',
    alignmentCodec(),
    (value) => value.$alignment,
  );
  final centerSlice = propValueField<ImageStyler, Rect>(
    'centerSlice',
    rectCodec(),
    (value) => value.$centerSlice,
  );
  final filterQuality = propValueField<ImageStyler, FilterQuality>(
    'filterQuality',
    enumNameCodec(FilterQuality.values),
    (value) => value.$filterQuality,
  );
  final colorBlendMode = propValueField<ImageStyler, BlendMode>(
    'colorBlendMode',
    enumNameCodec(BlendMode.values),
    (value) => value.$colorBlendMode,
  );
  final semanticLabel = propValueField<ImageStyler, String>(
    'semanticLabel',
    Ack.string(),
    (value) => value.$semanticLabel,
  );
  final excludeFromSemantics = propValueField<ImageStyler, bool>(
    'excludeFromSemantics',
    Ack.boolean(),
    (value) => value.$excludeFromSemantics,
  );
  final gaplessPlayback = propValueField<ImageStyler, bool>(
    'gaplessPlayback',
    Ack.boolean(),
    (value) => value.$gaplessPlayback,
  );
  final isAntiAlias = propValueField<ImageStyler, bool>(
    'isAntiAlias',
    Ack.boolean(),
    (value) => value.$isAntiAlias,
  );
  final matchTextDirection = propValueField<ImageStyler, bool>(
    'matchTextDirection',
    Ack.boolean(),
    (value) => value.$matchTextDirection,
  );
  final metadata = StylerMetadataFields<ImageStyler, ImageSpec>(
    rootStyleSchema: rootStyleSchema,
    readVariants: (value) => value.$variants,
    readModifier: (value) => value.$modifier,
    readAnimation: (value) => value.$animation,
  );

  return SchemaObject<ImageStyler>(
    inventoryOwner: 'ImageStyler',
    ownerFieldInventory: imageStylerInventory,
    actualFieldCount: stylerFieldCount,
    fields: [
      image,
      width,
      height,
      color,
      repeat,
      fit,
      alignment,
      centerSlice,
      filterQuality,
      colorBlendMode,
      semanticLabel,
      excludeFromSemantics,
      gaplessPlayback,
      isAntiAlias,
      matchTextDirection,
      ...metadata.fields,
    ],
    unsupportedFields: [...metadata.unsupportedFields()],
    build: (data) => ImageStyler.create(
      image: image.value(data),
      width: width.value(data),
      height: height.value(data),
      color: color.value(data),
      repeat: repeat.value(data),
      fit: fit.value(data),
      alignment: alignment.value(data),
      centerSlice: centerSlice.value(data),
      filterQuality: filterQuality.value(data),
      colorBlendMode: colorBlendMode.value(data),
      semanticLabel: semanticLabel.value(data),
      excludeFromSemantics: excludeFromSemantics.value(data),
      gaplessPlayback: gaplessPlayback.value(data),
      isAntiAlias: isAntiAlias.value(data),
      matchTextDirection: matchTextDirection.value(data),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}
