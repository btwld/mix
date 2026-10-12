import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../contract/identity_resolution.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'styler_codec_helpers.dart';

SchemaObject<StackStyler> stackStylerSchema({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  MixProtocolIdentityContext Function()? identityContext,
}) {
  return _stackStylerSchemaType(rootStyleSchema);
}

JsonMap encodeStackStylerFields(
  StackStyler value, {
  bool includeStylerMetadata = true,
}) {
  return _stackStylerSchemaType(null).encodeFields(
    value,
    omit: includeStylerMetadata ? const {} : stylerMetadataFields,
  );
}

SchemaObject<StackStyler> _stackStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
) {
  final alignment = propValueAsField<StackStyler, Alignment, AlignmentGeometry>(
    'alignment',
    alignmentCodec(),
    (value) => value.$alignment,
  );
  final fit = propValueField<StackStyler, StackFit>(
    'fit',
    enumNameCodec(StackFit.values),
    (value) => value.$fit,
  );
  final textDirection = propValueField<StackStyler, TextDirection>(
    'textDirection',
    textDirectionCodec(),
    (value) => value.$textDirection,
  );
  final clipBehavior = propValueField<StackStyler, Clip>(
    'clipBehavior',
    enumNameCodec(Clip.values),
    (value) => value.$clipBehavior,
  );

  return stylerSchemaObject<StackStyler, StackSpec>(
    rootStyleSchema: rootStyleSchema,
    fields: [alignment, fit, textDirection, clipBehavior],
    build: (data, metadata) => StackStyler.create(
      alignment: alignment.value(data),
      fit: fit.value(data),
      textDirection: textDirection.value(data),
      clipBehavior: clipBehavior.value(data),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}
