import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import '../registry/registry_value_codec.dart';
import 'animation_codec.dart';
import 'common_codecs.dart';
import 'modifier_codec.dart';
import 'schema_field.dart';
import 'variant_codec.dart';

AckSchema<JsonMap, ImageStyler> imageStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  required FrozenRegistry Function() registry,
}) {
  return _imageStylerSchemaType(rootStyleSchema, registry).codec();
}

SchemaObject<ImageStyler> _imageStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
  FrozenRegistry Function() registry,
) {
  final image = valueField<ImageStyler, ImageProvider<Object>>(
    'image',
    registryValueCodec<ImageProvider<Object>>(
      registry,
      MixSchemaScope.imageProvider,
    ),
    (value) => value.$image,
  );
  final width = valueField<ImageStyler, double>(
    'width',
    numberAsDoubleCodec(),
    (value) => value.$width,
  );
  final height = valueField<ImageStyler, double>(
    'height',
    numberAsDoubleCodec(),
    (value) => value.$height,
  );
  final color = valueField<ImageStyler, Color>(
    'color',
    colorCodec(),
    (value) => value.$color,
  );
  final repeat = valueField<ImageStyler, ImageRepeat>(
    'repeat',
    enumCodec(enumNames(ImageRepeat.values)),
    (value) => value.$repeat,
  );
  final fit = valueField<ImageStyler, BoxFit>(
    'fit',
    enumCodec(enumNames(BoxFit.values)),
    (value) => value.$fit,
  );
  final alignment = mixField<ImageStyler, Alignment, AlignmentGeometry>(
    'alignment',
    alignmentCodec(),
    (value) => value.$alignment,
  );
  final filterQuality = valueField<ImageStyler, FilterQuality>(
    'filterQuality',
    enumCodec(enumNames(FilterQuality.values)),
    (value) => value.$filterQuality,
  );
  final colorBlendMode = valueField<ImageStyler, BlendMode>(
    'colorBlendMode',
    enumCodec(enumNames(BlendMode.values)),
    (value) => value.$colorBlendMode,
  );
  final semanticLabel = valueField<ImageStyler, String>(
    'semanticLabel',
    Ack.string(),
    (value) => value.$semanticLabel,
  );
  final excludeFromSemantics = valueField<ImageStyler, bool>(
    'excludeFromSemantics',
    Ack.boolean(),
    (value) => value.$excludeFromSemantics,
  );
  final gaplessPlayback = valueField<ImageStyler, bool>(
    'gaplessPlayback',
    Ack.boolean(),
    (value) => value.$gaplessPlayback,
  );
  final isAntiAlias = valueField<ImageStyler, bool>(
    'isAntiAlias',
    Ack.boolean(),
    (value) => value.$isAntiAlias,
  );
  final matchTextDirection = valueField<ImageStyler, bool>(
    'matchTextDirection',
    Ack.boolean(),
    (value) => value.$matchTextDirection,
  );
  final variants = rootStyleSchema == null
      ? null
      : directField<ImageStyler, List<VariantStyle<ImageSpec>>>(
          'variants',
          Ack.list(variantCodec<ImageSpec>(rootStyleSchema)),
          (value) => value.$variants,
        );
  final modifiers = directField<ImageStyler, WidgetModifierConfig>(
    'modifiers',
    modifierConfigCodec(),
    (value) => value.$modifier,
  );
  final animation = directField<ImageStyler, AnimationConfig>(
    'animation',
    animationConfigCodec(registry: registry),
    (value) => value.$animation,
  );

  return SchemaObject<ImageStyler>(
    fields: [
      image,
      width,
      height,
      color,
      repeat,
      fit,
      alignment,
      filterQuality,
      colorBlendMode,
      semanticLabel,
      excludeFromSemantics,
      gaplessPlayback,
      isAntiAlias,
      matchTextDirection,
      ?variants,
      modifiers,
      animation,
    ],
    unsupportedFields: [
      if (variants == null)
        UnsupportedSchemaField<ImageStyler>(
          'variants',
          (value) => value.$variants,
        ),
      UnsupportedSchemaField<ImageStyler>(
        'centerSlice',
        (value) => value.$centerSlice,
      ),
    ],
    build: (data) => ImageStyler(
      image: image.value(data),
      width: width.value(data),
      height: height.value(data),
      color: color.value(data),
      repeat: repeat.value(data),
      fit: fit.value(data),
      alignment: alignment.value(data),
      filterQuality: filterQuality.value(data),
      colorBlendMode: colorBlendMode.value(data),
      semanticLabel: semanticLabel.value(data),
      excludeFromSemantics: excludeFromSemantics.value(data),
      gaplessPlayback: gaplessPlayback.value(data),
      isAntiAlias: isAntiAlias.value(data),
      matchTextDirection: matchTextDirection.value(data),
      variants: variants?.value(data),
      modifier: modifiers.value(data),
      animation: animation.value(data),
    ),
  );
}
