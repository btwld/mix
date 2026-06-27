import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import '../registry/registry_value_codec.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
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
  final icon = valueField<IconStyler, IconData>(
    'icon',
    registryValueCodec<IconData>(registry, MixSchemaScope.iconData),
    (value) => value.$icon,
  );
  final color = valueField<IconStyler, Color>(
    'color',
    colorCodec(),
    (value) => value.$color,
  );
  final size = valueField<IconStyler, double>(
    'size',
    numberAsDoubleCodec(),
    (value) => value.$size,
  );
  final weight = valueField<IconStyler, double>(
    'weight',
    numberAsDoubleCodec(),
    (value) => value.$weight,
  );
  final grade = valueField<IconStyler, double>(
    'grade',
    numberAsDoubleCodec(),
    (value) => value.$grade,
  );
  final opticalSize = valueField<IconStyler, double>(
    'opticalSize',
    numberAsDoubleCodec(),
    (value) => value.$opticalSize,
  );
  final textDirection = valueField<IconStyler, TextDirection>(
    'textDirection',
    textDirectionCodec(),
    (value) => value.$textDirection,
  );
  final applyTextScaling = valueField<IconStyler, bool>(
    'applyTextScaling',
    Ack.boolean(),
    (value) => value.$applyTextScaling,
  );
  final fill = valueField<IconStyler, double>(
    'fill',
    numberAsDoubleCodec(),
    (value) => value.$fill,
  );
  final semanticsLabel = valueField<IconStyler, String>(
    'semanticsLabel',
    Ack.string(),
    (value) => value.$semanticsLabel,
  );
  final opacity = valueField<IconStyler, double>(
    'opacity',
    numberAsDoubleCodec(),
    (value) => value.$opacity,
  );
  final blendMode = valueField<IconStyler, BlendMode>(
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
    fields: [
      icon,
      color,
      size,
      weight,
      grade,
      opticalSize,
      textDirection,
      applyTextScaling,
      fill,
      semanticsLabel,
      opacity,
      blendMode,
      ...metadata.fields,
    ],
    unsupportedFields: [
      ...metadata.unsupportedFields(),
      UnsupportedSchemaField<IconStyler>('shadows', (value) => value.$shadows),
    ],
    build: (data) => IconStyler(
      icon: icon.value(data),
      color: color.value(data),
      size: size.value(data),
      weight: weight.value(data),
      grade: grade.value(data),
      opticalSize: opticalSize.value(data),
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
