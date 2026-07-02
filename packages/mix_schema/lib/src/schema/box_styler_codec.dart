import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
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
  final padding = tokenMixField<BoxStyler, EdgeInsetsMix, EdgeInsetsGeometry>(
    'padding',
    edgeInsetsCodec(),
    (value) => value.$padding,
  );
  final margin = tokenMixField<BoxStyler, EdgeInsetsMix, EdgeInsetsGeometry>(
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
    'boxShadow': _boxShadowListFieldCodec().optional(),
  }).codec<BoxDecorationMix>(
    decode: (data) => BoxDecorationMix.create(
      color: Prop.maybe(data['color'] as Color?),
      border: Prop.maybeMix(data['border'] as BorderMix?),
      borderRadius: Prop.maybeMix(data['borderRadius'] as BorderRadiusMix?),
      shape: Prop.maybe(data['shape'] as BoxShape?),
      backgroundBlendMode: Prop.maybe(
        data['backgroundBlendMode'] as BlendMode?,
      ),
      boxShadow: _boxShadowListProp(data['boxShadow']),
    ),
    encode: (value) {
      failIfPresent(value.$image, 'decoration.image');
      failIfPresent(value.$gradient, 'decoration.gradient');

      return {
        'color': singleValuePropWire(value.$color, 'decoration.color'),
        'border': singleMixPropWire<BorderMix, BoxBorder>(
          value.$border,
          'decoration.border',
        ),
        'borderRadius':
            singleMixPropWire<BorderRadiusMix, BorderRadiusGeometry>(
              value.$borderRadius,
              'decoration.borderRadius',
            ),
        'shape': singleValueProp(value.$shape, 'decoration.shape'),
        'backgroundBlendMode': singleValueProp(
          value.$backgroundBlendMode,
          'decoration.backgroundBlendMode',
        ),
        'boxShadow': _boxShadowListWire(value),
      };
    },
  );
}

Object? _boxShadowListWire(BoxDecorationMix value) {
  final boxShadow = singleMixPropWire<BoxShadowListMix, List<BoxShadow>>(
    value.$boxShadow,
    'decoration.boxShadow',
  );

  return switch (boxShadow) {
    null => null,
    JsonMap() => boxShadow,
    Prop<List<BoxShadow>>() => boxShadow,
    BoxShadowListMix() => boxShadow.items,
    _ => throw UnsupportedEncodeValueError(
      boxShadow,
      'Field "decoration.boxShadow" decoded to unsupported '
      '${boxShadow.runtimeType}.',
    ),
  };
}

AckSchema<Object, Object> _boxShadowListFieldCodec() {
  return Ack.anyOf([
    Ack.list(boxShadowCodec()),
    tokenReferenceCodec<List<BoxShadow>, BoxShadowListMix>(
      decodeToken: (data) => BoxShadowToken(data[tokenReferenceKey]! as String),
      reference: (token) => (token as BoxShadowToken).mix(),
    ),
  ]);
}

Prop<List<BoxShadow>>? _boxShadowListProp(Object? value) {
  return switch (value) {
    null => null,
    Prop<List<BoxShadow>>() => value,
    List<BoxShadowMix>() => Prop.mix(BoxShadowListMix(value)),
    _ => throw UnsupportedEncodeValueError(
      value,
      'Box decoration shadows decoded to unsupported ${value.runtimeType}.',
    ),
  };
}
