import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../contract/identity_resolution.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'styler_codec_helpers.dart';

SchemaObject<WrapStyler> wrapStylerSchema({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  MixProtocolIdentityContext Function()? identityContext,
}) {
  return _wrapStylerSchemaType(rootStyleSchema);
}

JsonMap encodeWrapStylerFields(
  WrapStyler value, {
  bool includeStylerMetadata = true,
}) {
  return _wrapStylerSchemaType(null).encodeFields(
    value,
    omit: includeStylerMetadata ? const {} : stylerMetadataFields,
  );
}

SchemaObject<WrapStyler> _wrapStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
) {
  final direction = propValueField<WrapStyler, Axis>(
    'direction',
    enumNameCodec(Axis.values),
    (value) => value.$direction,
  );
  final alignment = propValueField<WrapStyler, WrapAlignment>(
    'alignment',
    enumNameCodec(WrapAlignment.values),
    (value) => value.$alignment,
  );
  final spacing = propValueField<WrapStyler, double>(
    'spacing',
    doubleTokenCodec(),
    (value) => value.$spacing,
  );
  final runAlignment = propValueField<WrapStyler, WrapAlignment>(
    'runAlignment',
    enumNameCodec(WrapAlignment.values),
    (value) => value.$runAlignment,
  );
  final runSpacing = propValueField<WrapStyler, double>(
    'runSpacing',
    doubleTokenCodec(),
    (value) => value.$runSpacing,
  );
  final crossAxisAlignment = propValueField<WrapStyler, WrapCrossAlignment>(
    'crossAxisAlignment',
    enumNameCodec(WrapCrossAlignment.values),
    (value) => value.$crossAxisAlignment,
  );
  final textDirection = propValueField<WrapStyler, TextDirection>(
    'textDirection',
    textDirectionCodec(),
    (value) => value.$textDirection,
  );
  final verticalDirection = propValueField<WrapStyler, VerticalDirection>(
    'verticalDirection',
    enumNameCodec(VerticalDirection.values),
    (value) => value.$verticalDirection,
  );
  final clipBehavior = propValueField<WrapStyler, Clip>(
    'clipBehavior',
    enumNameCodec(Clip.values),
    (value) => value.$clipBehavior,
  );

  return stylerSchemaObject<WrapStyler, WrapSpec>(
    rootStyleSchema: rootStyleSchema,
    fields: [
      direction,
      alignment,
      spacing,
      runAlignment,
      runSpacing,
      crossAxisAlignment,
      textDirection,
      verticalDirection,
      clipBehavior,
    ],
    build: (data, metadata) => WrapStyler.create(
      direction: direction.value(data),
      alignment: alignment.value(data),
      spacing: spacing.value(data),
      runAlignment: runAlignment.value(data),
      runSpacing: runSpacing.value(data),
      crossAxisAlignment: crossAxisAlignment.value(data),
      textDirection: textDirection.value(data),
      verticalDirection: verticalDirection.value(data),
      clipBehavior: clipBehavior.value(data),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}
