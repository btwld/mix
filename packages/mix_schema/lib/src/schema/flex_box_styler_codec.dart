import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../contract/identity_resolution.dart';
import 'box_styler_codec.dart';
import 'common_codecs.dart';
import 'flex_styler_codec.dart';
import 'schema_field.dart';
import 'styler_field_inventory.dart';
import 'styler_codec_helpers.dart';

AckSchema<JsonMap, FlexBoxStyler> flexBoxStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  MixSchemaIdentityContext Function()? identityContext,
}) {
  return _flexBoxStylerSchemaType(rootStyleSchema).codec();
}

SchemaObject<FlexBoxStyler> _flexBoxStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
) {
  final alignment = derivedField<FlexBoxStyler, Prop<AlignmentGeometry>>(
    'alignment',
    valueAsPropCodec<Alignment, AlignmentGeometry>(
      alignmentCodec(),
      fieldName: 'alignment',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final padding = derivedField<FlexBoxStyler, Prop<EdgeInsetsGeometry>>(
    'padding',
    mixPropCodec<EdgeInsetsMix, EdgeInsetsGeometry>(
      edgeInsetsCodec(),
      fieldName: 'padding',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final margin = derivedField<FlexBoxStyler, Prop<EdgeInsetsGeometry>>(
    'margin',
    mixPropCodec<EdgeInsetsMix, EdgeInsetsGeometry>(
      edgeInsetsCodec(),
      fieldName: 'margin',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final constraints = derivedField<FlexBoxStyler, Prop<BoxConstraints>>(
    'constraints',
    mixPropCodec<BoxConstraintsMix, BoxConstraints>(
      boxConstraintsCodec(),
      fieldName: 'constraints',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final clipBehavior = derivedField<FlexBoxStyler, Prop<Clip>>(
    'clipBehavior',
    valuePropCodec<Clip>(enumNameCodec(Clip.values), fieldName: 'clipBehavior'),
    _boxField,
    inventoryName: 'box',
  );
  final transform = derivedField<FlexBoxStyler, Prop<Matrix4>>(
    'transform',
    valuePropCodec<Matrix4>(matrix4Codec(), fieldName: 'transform'),
    _boxField,
    inventoryName: 'box',
  );
  final transformAlignment =
      derivedField<FlexBoxStyler, Prop<AlignmentGeometry>>(
        'transformAlignment',
        valueAsPropCodec<Alignment, AlignmentGeometry>(
          alignmentCodec(),
          fieldName: 'transformAlignment',
        ),
        _boxField,
        inventoryName: 'box',
      );
  final decoration = derivedField<FlexBoxStyler, Prop<Decoration>>(
    'decoration',
    mixPropCodec<BoxDecorationMix, Decoration>(
      boxDecorationCodec(),
      fieldName: 'decoration',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final direction = derivedField<FlexBoxStyler, Prop<Axis>>(
    'direction',
    valuePropCodec<Axis>(enumNameCodec(Axis.values), fieldName: 'direction'),
    _flexField,
    inventoryName: 'flex',
  );
  final mainAxisAlignment =
      derivedField<FlexBoxStyler, Prop<MainAxisAlignment>>(
        'mainAxisAlignment',
        valuePropCodec<MainAxisAlignment>(
          enumNameCodec(MainAxisAlignment.values),
          fieldName: 'mainAxisAlignment',
        ),
        _flexField,
        inventoryName: 'flex',
      );
  final crossAxisAlignment =
      derivedField<FlexBoxStyler, Prop<CrossAxisAlignment>>(
        'crossAxisAlignment',
        valuePropCodec<CrossAxisAlignment>(
          enumNameCodec(CrossAxisAlignment.values),
          fieldName: 'crossAxisAlignment',
        ),
        _flexField,
        inventoryName: 'flex',
      );
  final mainAxisSize = derivedField<FlexBoxStyler, Prop<MainAxisSize>>(
    'mainAxisSize',
    valuePropCodec<MainAxisSize>(
      enumNameCodec(MainAxisSize.values),
      fieldName: 'mainAxisSize',
    ),
    _flexField,
    inventoryName: 'flex',
  );
  final verticalDirection =
      derivedField<FlexBoxStyler, Prop<VerticalDirection>>(
        'verticalDirection',
        valuePropCodec<VerticalDirection>(
          enumNameCodec(VerticalDirection.values),
          fieldName: 'verticalDirection',
        ),
        _flexField,
        inventoryName: 'flex',
      );
  final textDirection = derivedField<FlexBoxStyler, Prop<TextDirection>>(
    'textDirection',
    valuePropCodec<TextDirection>(
      textDirectionCodec(),
      fieldName: 'textDirection',
    ),
    _flexField,
    inventoryName: 'flex',
  );
  final textBaseline = derivedField<FlexBoxStyler, Prop<TextBaseline>>(
    'textBaseline',
    valuePropCodec<TextBaseline>(
      enumNameCodec(TextBaseline.values),
      fieldName: 'textBaseline',
    ),
    _flexField,
    inventoryName: 'flex',
  );
  final flexClipBehavior = derivedField<FlexBoxStyler, Prop<Clip>>(
    'flexClipBehavior',
    valuePropCodec<Clip>(
      enumNameCodec(Clip.values),
      fieldName: 'flexClipBehavior',
    ),
    _flexField,
    readWire: 'clipBehavior',
    inventoryName: 'flex',
  );
  final spacing = derivedField<FlexBoxStyler, Prop<double>>(
    'spacing',
    valuePropCodec<double>(doubleTokenCodec(), fieldName: 'spacing'),
    _flexField,
    inventoryName: 'flex',
  );
  final metadata = StylerMetadataFields<FlexBoxStyler, FlexBoxSpec>(
    rootStyleSchema: rootStyleSchema,
    readVariants: (value) => value.$variants,
    readModifier: (value) => value.$modifier,
    readAnimation: (value) => value.$animation,
  );

  return SchemaObject<FlexBoxStyler>(
    inventoryOwner: 'FlexBoxStyler',
    ownerFieldInventory: flexBoxStylerInventory,
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
      direction,
      mainAxisAlignment,
      crossAxisAlignment,
      mainAxisSize,
      verticalDirection,
      textDirection,
      textBaseline,
      flexClipBehavior,
      spacing,
      ...metadata.fields,
    ],
    unsupportedFields: [...metadata.unsupportedFields()],
    build: (data) => FlexBoxStyler.create(
      box: Prop.mix(
        BoxStyler.create(
          alignment: alignment.value(data),
          padding: padding.value(data),
          margin: margin.value(data),
          constraints: constraints.value(data),
          clipBehavior: clipBehavior.value(data),
          transform: transform.value(data),
          transformAlignment: transformAlignment.value(data),
          decoration: decoration.value(data),
        ),
      ),
      flex: Prop.mix(
        FlexStyler.create(
          direction: direction.value(data),
          mainAxisAlignment: mainAxisAlignment.value(data),
          crossAxisAlignment: crossAxisAlignment.value(data),
          mainAxisSize: mainAxisSize.value(data),
          verticalDirection: verticalDirection.value(data),
          textDirection: textDirection.value(data),
          textBaseline: textBaseline.value(data),
          clipBehavior: flexClipBehavior.value(data),
          spacing: spacing.value(data),
        ),
      ),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}

Object? _boxField(FlexBoxStyler value, String wire) {
  return encodedNestedStylerField<FlexBoxStyler, BoxStyler, BoxSpec>(
    value,
    wire,
    read: (value) => value.$box,
    encodeFields: encodeBoxStylerFields,
    fieldName: 'box',
  );
}

Object? _flexField(FlexBoxStyler value, String wire) {
  return encodedNestedStylerField<FlexBoxStyler, FlexStyler, FlexSpec>(
    value,
    wire,
    read: (value) => value.$flex,
    encodeFields: encodeFlexStylerFields,
    fieldName: 'flex',
  );
}
