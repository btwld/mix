import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../contract/identity_resolution.dart';
import '../contract/identity_codec.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'styler_codec_helpers.dart';

SchemaObject<IconStyler> iconStylerSchema({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  required MixProtocolIdentityContext Function() identityContext,
}) {
  return _iconStylerSchemaType(rootStyleSchema, identityContext);
}

SchemaObject<IconStyler> _iconStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
  MixProtocolIdentityContext Function() identityContext,
) {
  final icon = propValueField<IconStyler, IconData>(
    'icon',
    iconDataIdentityCodec(identityContext),
    (value) => value.$icon,
  );
  final color = propValueField<IconStyler, Color>(
    'color',
    colorCodec(),
    (value) => value.$color,
  );
  final size = propValueField<IconStyler, double>(
    'size',
    nonNegativeDoubleTokenCodec(),
    (value) => value.$size,
  );
  final weight = propValueField<IconStyler, double>(
    'weight',
    doubleTokenCodec(),
    (value) => value.$weight,
  );
  final grade = propValueField<IconStyler, double>(
    'grade',
    doubleTokenCodec(),
    (value) => value.$grade,
  );
  final opticalSize = propValueField<IconStyler, double>(
    'opticalSize',
    nonNegativeDoubleTokenCodec(),
    (value) => value.$opticalSize,
  );
  final shadows = propMixField<IconStyler, ShadowListMix, List<Shadow>>(
    'shadows',
    shadowListMixCodec(),
    (value) => value.$shadows,
    schemaSemantics: listEntryFieldSemantics,
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
  final fill = propValueField<IconStyler, double>(
    'fill',
    doubleTokenCodec(),
    (value) => value.$fill,
  );
  final semanticsLabel = propValueField<IconStyler, String>(
    'semanticsLabel',
    Ack.string(),
    (value) => value.$semanticsLabel,
  );
  final opacity = propValueField<IconStyler, double>(
    'opacity',
    unitDoubleTokenCodec(),
    (value) => value.$opacity,
  );
  final blendMode = propValueField<IconStyler, BlendMode>(
    'blendMode',
    enumNameCodec(BlendMode.values),
    (value) => value.$blendMode,
  );

  return stylerSchemaObject<IconStyler, IconSpec>(
    rootStyleSchema: rootStyleSchema,
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
    ],
    build: (data, metadata) => IconStyler.create(
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
      icon: icon.value(data),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}
