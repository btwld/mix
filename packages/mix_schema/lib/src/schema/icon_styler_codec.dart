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
    enumCodec(enumNames(TextDirection.values)),
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
    enumCodec(enumNames(BlendMode.values)),
    (value) => value.$blendMode,
  );
  final variants = rootStyleSchema == null
      ? null
      : directField<IconStyler, List<VariantStyle<IconSpec>>>(
          'variants',
          Ack.list(variantCodec<IconSpec>(rootStyleSchema)),
          (value) => value.$variants,
        );
  final modifiers = directField<IconStyler, WidgetModifierConfig>(
    'modifiers',
    modifierConfigCodec(),
    (value) => value.$modifier,
  );
  final animation = directField<IconStyler, AnimationConfig>(
    'animation',
    animationConfigCodec(registry: registry),
    (value) => value.$animation,
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
      ?variants,
      modifiers,
      animation,
    ],
    unsupportedFields: [
      if (variants == null)
        UnsupportedSchemaField<IconStyler>(
          'variants',
          (value) => value.$variants,
        ),
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
      variants: variants?.value(data),
      modifier: modifiers.value(data),
      animation: animation.value(data),
    ),
  );
}
