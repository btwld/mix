import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'animation_codec.dart';
import 'common_codecs.dart';
import 'modifier_codec.dart';
import 'schema_field.dart';
import 'variant_codec.dart';

AckSchema<JsonMap, FlexStyler> flexStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  required FrozenRegistry Function() registry,
}) {
  return _flexStylerSchemaType(rootStyleSchema, registry).codec();
}

JsonMap encodeFlexStylerFields(
  FlexStyler value, {
  bool includeStylerMetadata = true,
}) {
  return _flexStylerSchemaType(null, _emptyRegistry).encodeFields(
    value,
    omit: includeStylerMetadata ? const {} : _stylerMetadataFields,
  );
}

SchemaObject<FlexStyler> _flexStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
  FrozenRegistry Function() registry,
) {
  final direction = valueField<FlexStyler, Axis>(
    'direction',
    enumCodec(enumNames(Axis.values)),
    (value) => value.$direction,
  );
  final mainAxisAlignment = valueField<FlexStyler, MainAxisAlignment>(
    'mainAxisAlignment',
    enumCodec(enumNames(MainAxisAlignment.values)),
    (value) => value.$mainAxisAlignment,
  );
  final crossAxisAlignment = valueField<FlexStyler, CrossAxisAlignment>(
    'crossAxisAlignment',
    enumCodec(enumNames(CrossAxisAlignment.values)),
    (value) => value.$crossAxisAlignment,
  );
  final mainAxisSize = valueField<FlexStyler, MainAxisSize>(
    'mainAxisSize',
    enumCodec(enumNames(MainAxisSize.values)),
    (value) => value.$mainAxisSize,
  );
  final verticalDirection = valueField<FlexStyler, VerticalDirection>(
    'verticalDirection',
    enumCodec(enumNames(VerticalDirection.values)),
    (value) => value.$verticalDirection,
  );
  final textDirection = valueField<FlexStyler, TextDirection>(
    'textDirection',
    enumCodec(enumNames(TextDirection.values)),
    (value) => value.$textDirection,
  );
  final textBaseline = valueField<FlexStyler, TextBaseline>(
    'textBaseline',
    enumCodec(enumNames(TextBaseline.values)),
    (value) => value.$textBaseline,
  );
  final clipBehavior = valueField<FlexStyler, Clip>(
    'clipBehavior',
    enumCodec(enumNames(Clip.values)),
    (value) => value.$clipBehavior,
  );
  final spacing = valueField<FlexStyler, double>(
    'spacing',
    numberAsDoubleCodec(),
    (value) => value.$spacing,
  );
  final variants = rootStyleSchema == null
      ? null
      : directField<FlexStyler, List<VariantStyle<FlexSpec>>>(
          'variants',
          Ack.list(variantCodec<FlexSpec>(rootStyleSchema)),
          (value) => value.$variants,
        );
  final modifiers = directField<FlexStyler, WidgetModifierConfig>(
    'modifiers',
    modifierConfigCodec(),
    (value) => value.$modifier,
  );
  final animation = directField<FlexStyler, AnimationConfig>(
    'animation',
    animationConfigCodec(registry: registry),
    (value) => value.$animation,
  );

  return SchemaObject<FlexStyler>(
    fields: [
      direction,
      mainAxisAlignment,
      crossAxisAlignment,
      mainAxisSize,
      verticalDirection,
      textDirection,
      textBaseline,
      clipBehavior,
      spacing,
      ?variants,
      modifiers,
      animation,
    ],
    unsupportedFields: [
      if (variants == null)
        UnsupportedSchemaField<FlexStyler>(
          'variants',
          (value) => value.$variants,
        ),
    ],
    build: (data) => FlexStyler(
      direction: direction.value(data),
      mainAxisAlignment: mainAxisAlignment.value(data),
      crossAxisAlignment: crossAxisAlignment.value(data),
      mainAxisSize: mainAxisSize.value(data),
      verticalDirection: verticalDirection.value(data),
      textDirection: textDirection.value(data),
      textBaseline: textBaseline.value(data),
      clipBehavior: clipBehavior.value(data),
      spacing: spacing.value(data),
      variants: variants?.value(data),
      modifier: modifiers.value(data),
      animation: animation.value(data),
    ),
  );
}

const _stylerMetadataFields = {'modifiers', 'animation'};

FrozenRegistry _emptyRegistry() => RegistryBuilder().freeze();
