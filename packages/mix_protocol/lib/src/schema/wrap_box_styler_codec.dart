import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../contract/identity_resolution.dart';
import 'box_styler_codec.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'styler_codec_helpers.dart';
import 'wrap_styler_codec.dart';

SchemaObject<WrapBoxStyler> wrapBoxStylerSchema({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  MixProtocolIdentityContext Function()? identityContext,
}) {
  return _wrapBoxStylerSchemaType(rootStyleSchema);
}

SchemaObject<WrapBoxStyler> _wrapBoxStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
) {
  final alignment = derivedField<WrapBoxStyler, Prop<AlignmentGeometry>>(
    'alignment',
    valueAsPropCodec<Alignment, AlignmentGeometry>(
      alignmentCodec(),
      fieldName: 'alignment',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final padding = derivedField<WrapBoxStyler, Prop<EdgeInsetsGeometry>>(
    'padding',
    mixPropCodec<EdgeInsetsMix, EdgeInsetsGeometry>(
      edgeInsetsCodec(),
      fieldName: 'padding',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final margin = derivedField<WrapBoxStyler, Prop<EdgeInsetsGeometry>>(
    'margin',
    mixPropCodec<EdgeInsetsMix, EdgeInsetsGeometry>(
      edgeInsetsCodec(),
      fieldName: 'margin',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final constraints = derivedField<WrapBoxStyler, Prop<BoxConstraints>>(
    'constraints',
    mixPropCodec<BoxConstraintsMix, BoxConstraints>(
      boxConstraintsCodec(),
      fieldName: 'constraints',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final clipBehavior = derivedField<WrapBoxStyler, Prop<Clip>>(
    'clipBehavior',
    valuePropCodec<Clip>(enumNameCodec(Clip.values), fieldName: 'clipBehavior'),
    _boxField,
    inventoryName: 'box',
  );
  final transform = derivedField<WrapBoxStyler, Prop<Matrix4>>(
    'transform',
    valuePropCodec<Matrix4>(matrix4Codec(), fieldName: 'transform'),
    _boxField,
    inventoryName: 'box',
  );
  final transformAlignment =
      derivedField<WrapBoxStyler, Prop<AlignmentGeometry>>(
        'transformAlignment',
        valueAsPropCodec<Alignment, AlignmentGeometry>(
          alignmentCodec(),
          fieldName: 'transformAlignment',
        ),
        _boxField,
        inventoryName: 'box',
      );
  final decoration = derivedField<WrapBoxStyler, Prop<Decoration>>(
    'decoration',
    mixPropCodec<BoxDecorationMix, Decoration>(
      boxDecorationCodec(),
      fieldName: 'decoration',
    ),
    _boxField,
    inventoryName: 'box',
    schemaSemantics: boxDecorationFieldSemantics,
  );
  final foregroundDecoration = derivedField<WrapBoxStyler, Prop<Decoration>>(
    'foregroundDecoration',
    mixPropCodec<BoxDecorationMix, Decoration>(
      boxDecorationCodec(),
      fieldName: 'foregroundDecoration',
    ),
    _boxField,
    inventoryName: 'box',
    schemaSemantics: boxDecorationFieldSemantics,
  );
  final direction = derivedField<WrapBoxStyler, Prop<Axis>>(
    'direction',
    valuePropCodec<Axis>(enumNameCodec(Axis.values), fieldName: 'direction'),
    _flowField,
    inventoryName: 'flow',
  );
  final wrapAlignment = derivedField<WrapBoxStyler, Prop<WrapAlignment>>(
    'wrapAlignment',
    valuePropCodec<WrapAlignment>(
      enumNameCodec(WrapAlignment.values),
      fieldName: 'wrapAlignment',
    ),
    _flowField,
    readWire: 'alignment',
    inventoryName: 'flow',
  );
  final spacing = derivedField<WrapBoxStyler, Prop<double>>(
    'spacing',
    valuePropCodec<double>(doubleTokenCodec(), fieldName: 'spacing'),
    _flowField,
    inventoryName: 'flow',
  );
  final runAlignment = derivedField<WrapBoxStyler, Prop<WrapAlignment>>(
    'runAlignment',
    valuePropCodec<WrapAlignment>(
      enumNameCodec(WrapAlignment.values),
      fieldName: 'runAlignment',
    ),
    _flowField,
    inventoryName: 'flow',
  );
  final runSpacing = derivedField<WrapBoxStyler, Prop<double>>(
    'runSpacing',
    valuePropCodec<double>(doubleTokenCodec(), fieldName: 'runSpacing'),
    _flowField,
    inventoryName: 'flow',
  );
  final crossAxisAlignment =
      derivedField<WrapBoxStyler, Prop<WrapCrossAlignment>>(
        'crossAxisAlignment',
        valuePropCodec<WrapCrossAlignment>(
          enumNameCodec(WrapCrossAlignment.values),
          fieldName: 'crossAxisAlignment',
        ),
        _flowField,
        inventoryName: 'flow',
      );
  final textDirection = derivedField<WrapBoxStyler, Prop<TextDirection>>(
    'textDirection',
    valuePropCodec<TextDirection>(
      textDirectionCodec(),
      fieldName: 'textDirection',
    ),
    _flowField,
    inventoryName: 'flow',
  );
  final verticalDirection =
      derivedField<WrapBoxStyler, Prop<VerticalDirection>>(
        'verticalDirection',
        valuePropCodec<VerticalDirection>(
          enumNameCodec(VerticalDirection.values),
          fieldName: 'verticalDirection',
        ),
        _flowField,
        inventoryName: 'flow',
      );
  final wrapClipBehavior = derivedField<WrapBoxStyler, Prop<Clip>>(
    'wrapClipBehavior',
    valuePropCodec<Clip>(
      enumNameCodec(Clip.values),
      fieldName: 'wrapClipBehavior',
    ),
    _flowField,
    readWire: 'clipBehavior',
    inventoryName: 'flow',
  );

  return stylerSchemaObject<WrapBoxStyler, WrapBoxSpec>(
    rootStyleSchema: rootStyleSchema,
    fields: [
      alignment,
      padding,
      margin,
      constraints,
      clipBehavior,
      transform,
      transformAlignment,
      decoration,
      foregroundDecoration,
      direction,
      wrapAlignment,
      spacing,
      runAlignment,
      runSpacing,
      crossAxisAlignment,
      textDirection,
      verticalDirection,
      wrapClipBehavior,
    ],
    build: (data, metadata) => WrapBoxStyler.create(
      box: Prop.mix(
        BoxStyler.create(
          alignment: alignment.value(data),
          padding: padding.value(data),
          margin: margin.value(data),
          constraints: constraints.value(data),
          decoration: decoration.value(data),
          foregroundDecoration: foregroundDecoration.value(data),
          transform: transform.value(data),
          transformAlignment: transformAlignment.value(data),
          clipBehavior: clipBehavior.value(data),
        ),
      ),
      flow: Prop.mix(
        WrapStyler.create(
          direction: direction.value(data),
          alignment: wrapAlignment.value(data),
          spacing: spacing.value(data),
          runAlignment: runAlignment.value(data),
          runSpacing: runSpacing.value(data),
          crossAxisAlignment: crossAxisAlignment.value(data),
          textDirection: textDirection.value(data),
          verticalDirection: verticalDirection.value(data),
          clipBehavior: wrapClipBehavior.value(data),
        ),
      ),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}

JsonMap _boxField(WrapBoxStyler value) {
  return encodedNestedStylerFields<WrapBoxStyler, BoxStyler, BoxSpec>(
    value,
    read: (value) => value.$box,
    encodeFields: encodeBoxStylerFields,
    fieldName: 'box',
  );
}

JsonMap _flowField(WrapBoxStyler value) {
  return encodedNestedStylerFields<WrapBoxStyler, WrapStyler, WrapSpec>(
    value,
    read: (value) => value.$flow,
    encodeFields: encodeWrapStylerFields,
    fieldName: 'flow',
  );
}
