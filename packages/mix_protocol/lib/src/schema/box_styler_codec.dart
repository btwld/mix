import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_protocol_error.dart';
import '../contract/identity_resolution.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'styler_field_inventory.dart';
import 'styler_codec_helpers.dart';

SchemaObject<BoxStyler> boxStylerSchema({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  MixProtocolIdentityContext Function()? identityContext,
}) {
  return _boxStylerSchemaType(rootStyleSchema);
}

JsonMap encodeBoxStylerFields(
  BoxStyler value, {
  bool includeStylerMetadata = true,
}) {
  return _boxStylerSchemaType(null).encodeFields(
    value,
    omit: includeStylerMetadata ? const {} : stylerMetadataFields,
  );
}

SchemaObject<BoxStyler> _boxStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
) {
  final alignment = propValueAsField<BoxStyler, Alignment, AlignmentGeometry>(
    'alignment',
    alignmentCodec(),
    (value) => value.$alignment,
  );
  final padding = propMixField<BoxStyler, EdgeInsetsMix, EdgeInsetsGeometry>(
    'padding',
    edgeInsetsCodec(),
    (value) => value.$padding,
  );
  final margin = propMixField<BoxStyler, EdgeInsetsMix, EdgeInsetsGeometry>(
    'margin',
    edgeInsetsCodec(),
    (value) => value.$margin,
  );
  final constraints =
      propMixField<BoxStyler, BoxConstraintsMix, BoxConstraints>(
        'constraints',
        boxConstraintsCodec(),
        (value) => value.$constraints,
      );
  final clipBehavior = propValueField<BoxStyler, Clip>(
    'clipBehavior',
    enumNameCodec(Clip.values),
    (value) => value.$clipBehavior,
  );
  final transform = propValueField<BoxStyler, Matrix4>(
    'transform',
    matrix4Codec(),
    (value) => value.$transform,
  );
  final transformAlignment =
      propValueAsField<BoxStyler, Alignment, AlignmentGeometry>(
        'transformAlignment',
        alignmentCodec(),
        (value) => value.$transformAlignment,
      );
  final decoration = propMixField<BoxStyler, BoxDecorationMix, Decoration>(
    'decoration',
    boxDecorationCodec(),
    (value) => value.$decoration,
    schemaSemantics: boxDecorationFieldSemantics,
  );
  final foregroundDecoration =
      propMixField<BoxStyler, BoxDecorationMix, Decoration>(
        'foregroundDecoration',
        boxDecorationCodec(),
        (value) => value.$foregroundDecoration,
        schemaSemantics: boxDecorationFieldSemantics,
      );

  return stylerSchemaObject<BoxStyler, BoxSpec>(
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
    ],
    build: (data, metadata) => BoxStyler.create(
      alignment: alignment.value(data),
      padding: padding.value(data),
      margin: margin.value(data),
      constraints: constraints.value(data),
      decoration: decoration.value(data),
      foregroundDecoration: foregroundDecoration.value(data),
      transform: transform.value(data),
      transformAlignment: transformAlignment.value(data),
      clipBehavior: clipBehavior.value(data),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}

CodecSchema<JsonMap, BoxDecorationMix> boxDecorationCodec() {
  return Ack.object({
    'color': valuePropCodec<Color>(
      colorCodec(),
      fieldName: 'decoration.color',
    ).optional(),
    'border': mixPropCodec<BorderMix, BoxBorder>(
      borderCodec(),
      fieldName: 'decoration.border',
    ).optional(),
    'borderRadius': mixPropCodec<BorderRadiusMix, BorderRadiusGeometry>(
      borderRadiusCodec(),
      fieldName: 'decoration.borderRadius',
    ).optional(),
    'shape': valuePropCodec<BoxShape>(
      enumNameCodec(BoxShape.values),
      fieldName: 'decoration.shape',
    ).optional(),
    'backgroundBlendMode': valuePropCodec<BlendMode>(
      enumNameCodec(BlendMode.values),
      fieldName: 'decoration.backgroundBlendMode',
    ).optional(),
    'gradient': mixPropCodec<GradientMix, Gradient>(
      gradientCodec(),
      fieldName: 'decoration.gradient',
    ).optional(),
    'boxShadow': mixPropCodec<BoxShadowListMix, List<BoxShadow>>(
      boxShadowListMixCodec(),
      fieldName: 'decoration.boxShadow',
    ).optional(),
  }).codec<BoxDecorationMix>(
    decode: (data) => BoxDecorationMix.create(
      border: data['border'] as Prop<BoxBorder>?,
      borderRadius: data['borderRadius'] as Prop<BorderRadiusGeometry>?,
      shape: data['shape'] as Prop<BoxShape>?,
      backgroundBlendMode: data['backgroundBlendMode'] as Prop<BlendMode>?,
      color: data['color'] as Prop<Color>?,
      gradient: data['gradient'] as Prop<Gradient>?,
      boxShadow: data['boxShadow'] as Prop<List<BoxShadow>>?,
    ),
    encode: (value) {
      checkKnownFieldInventory(
        value,
        owner: 'BoxDecorationMix',
        fields: boxDecorationMixInventory,
      );
      failIfPresent(value.$image, 'decoration.image');

      return {
        'color': value.$color,
        'border': value.$border,
        'borderRadius': value.$borderRadius,
        'shape': value.$shape,
        'backgroundBlendMode': value.$backgroundBlendMode,
        'gradient': value.$gradient,
        'boxShadow': value.$boxShadow,
      };
    },
  );
}

CodecSchema<JsonMap, GradientMix> gradientCodec() {
  final colors = valuePropCodec<List<Color>>(
    Ack.list(colorLiteralCodec()),
    fieldName: 'decoration.gradient.colors',
  );
  final stops = valuePropCodec<List<double>>(
    Ack.list(numberAsDoubleCodec()),
    fieldName: 'decoration.gradient.stops',
  );
  final transform = valuePropCodec<GradientTransform>(
    _gradientTransformCodec(),
    fieldName: 'decoration.gradient.transform',
  );
  final alignment = valueAsPropCodec<Alignment, AlignmentGeometry>(
    alignmentCodec(),
    fieldName: 'decoration.gradient.alignment',
  );
  final doubleValue = valuePropCodec<double>(
    doubleTokenCodec(),
    fieldName: 'decoration.gradient.number',
  );
  final tileMode = valuePropCodec<TileMode>(
    enumNameCodec(TileMode.values),
    fieldName: 'decoration.gradient.tileMode',
  );

  return Ack.object({
    'kind': Ack.enumString(['linear', 'radial', 'sweep']),
    'begin': alignment.optional(),
    'end': alignment.optional(),
    'center': alignment.optional(),
    'radius': doubleValue.optional(),
    'focal': alignment.optional(),
    'focalRadius': doubleValue.optional(),
    'startAngle': doubleValue.optional(),
    'endAngle': doubleValue.optional(),
    'colors': colors.optional(),
    'stops': stops.optional(),
    'tileMode': tileMode.optional(),
    'transform': transform.optional(),
  }).codec<GradientMix>(decode: _decodeGradientMix, encode: _encodeGradientMix);
}

GradientMix _decodeGradientMix(JsonMap data) {
  final kind = data['kind'] as String;
  _checkGradientKindFields(data, kind);

  return switch (kind) {
    'linear' => LinearGradientMix.create(
      begin: data['begin'] as Prop<AlignmentGeometry>?,
      end: data['end'] as Prop<AlignmentGeometry>?,
      tileMode: data['tileMode'] as Prop<TileMode>?,
      transform: data['transform'] as Prop<GradientTransform>?,
      colors: data['colors'] as Prop<List<Color>>?,
      stops: data['stops'] as Prop<List<double>>?,
    ),
    'radial' => RadialGradientMix.create(
      center: data['center'] as Prop<AlignmentGeometry>?,
      radius: data['radius'] as Prop<double>?,
      tileMode: data['tileMode'] as Prop<TileMode>?,
      focal: data['focal'] as Prop<AlignmentGeometry>?,
      focalRadius: data['focalRadius'] as Prop<double>?,
      transform: data['transform'] as Prop<GradientTransform>?,
      colors: data['colors'] as Prop<List<Color>>?,
      stops: data['stops'] as Prop<List<double>>?,
    ),
    'sweep' => SweepGradientMix.create(
      center: data['center'] as Prop<AlignmentGeometry>?,
      startAngle: data['startAngle'] as Prop<double>?,
      endAngle: data['endAngle'] as Prop<double>?,
      tileMode: data['tileMode'] as Prop<TileMode>?,
      transform: data['transform'] as Prop<GradientTransform>?,
      colors: data['colors'] as Prop<List<Color>>?,
      stops: data['stops'] as Prop<List<double>>?,
    ),
    _ => throw UnsupportedEncodeValueError(
      kind,
      'Unsupported gradient kind "$kind".',
    ),
  };
}

void _checkGradientKindFields(JsonMap data, String kind) {
  final allowed = switch (kind) {
    'linear' => _linearGradientFields,
    'radial' => _radialGradientFields,
    'sweep' => _sweepGradientFields,
    _ => const <String>{},
  };

  for (final entry in data.entries) {
    if (allowed.contains(entry.key)) continue;

    throw SchemaPathError(
      code: MixProtocolErrorCode.unknownField,
      relativePath: '/${entry.key}',
      reason:
          'Field "decoration.gradient.${entry.key}" is not valid for '
          '$kind gradients.',
      value: entry.value,
    );
  }
}

const _baseGradientFields = {
  'kind',
  'colors',
  'stops',
  'tileMode',
  'transform',
};
const _linearGradientFields = {..._baseGradientFields, 'begin', 'end'};
const _radialGradientFields = {
  ..._baseGradientFields,
  'center',
  'radius',
  'focal',
  'focalRadius',
};
const _sweepGradientFields = {
  ..._baseGradientFields,
  'center',
  'startAngle',
  'endAngle',
};

JsonMap _encodeGradientMix(GradientMix value) {
  return switch (value) {
    LinearGradientMix() => _encodeLinearGradientMix(value),
    RadialGradientMix() => _encodeRadialGradientMix(value),
    SweepGradientMix() => _encodeSweepGradientMix(value),
  };
}

JsonMap _encodeLinearGradientMix(LinearGradientMix value) {
  checkKnownFieldInventory(
    value,
    owner: 'LinearGradientMix',
    fields: linearGradientMixInventory,
  );

  return {
    'kind': 'linear',
    'begin': value.$begin,
    'end': value.$end,
    'colors': value.$colors,
    'stops': value.$stops,
    'tileMode': value.$tileMode,
    'transform': value.$transform,
  };
}

JsonMap _encodeRadialGradientMix(RadialGradientMix value) {
  checkKnownFieldInventory(
    value,
    owner: 'RadialGradientMix',
    fields: radialGradientMixInventory,
  );

  return {
    'kind': 'radial',
    'center': value.$center,
    'radius': value.$radius,
    'focal': value.$focal,
    'focalRadius': value.$focalRadius,
    'colors': value.$colors,
    'stops': value.$stops,
    'tileMode': value.$tileMode,
    'transform': value.$transform,
  };
}

JsonMap _encodeSweepGradientMix(SweepGradientMix value) {
  checkKnownFieldInventory(
    value,
    owner: 'SweepGradientMix',
    fields: sweepGradientMixInventory,
  );

  return {
    'kind': 'sweep',
    'center': value.$center,
    'startAngle': value.$startAngle,
    'endAngle': value.$endAngle,
    'colors': value.$colors,
    'stops': value.$stops,
    'tileMode': value.$tileMode,
    'transform': value.$transform,
  };
}

CodecSchema<Object, GradientTransform> _gradientTransformCodec() {
  return Ack.anyOf([
    Ack.object({
      'kind': Ack.literal('rotation'),
      'radians': numberAsDoubleCodec(),
    }),
    Ack.object({
      'kind': Ack.literal('css_linear'),
      'direction': Ack.enumString(
        CssKeywordLinearTransform.supportedDirectionKeys.toList(
          growable: false,
        ),
      ),
    }),
  ]).codec<GradientTransform>(
    decode: (value) {
      final data = value as JsonMap;

      return switch (data['kind']) {
        'rotation' => GradientRotation(data['radians']! as double),
        'css_linear' => CssKeywordLinearTransform(data['direction']! as String),
        final kind => throw UnsupportedEncodeValueError(
          kind,
          'Unsupported gradient transform kind "$kind".',
        ),
      };
    },
    encode: _encodeGradientTransform,
  );
}

JsonMap _encodeGradientTransform(GradientTransform value) {
  return switch (value) {
    GradientRotation(:final radians) => {
      'kind': 'rotation',
      'radians': radians,
    },
    CssKeywordLinearTransform(:final directionKey) =>
      _encodeCssKeywordLinearTransform(value, directionKey),
    _ => throw UnsupportedEncodeValueError(
      value,
      'Field "decoration.gradient.transform" only supports '
      'GradientRotation or CssKeywordLinearTransform.',
    ),
  };
}

JsonMap _encodeCssKeywordLinearTransform(
  CssKeywordLinearTransform value,
  String directionKey,
) {
  if (!CssKeywordLinearTransform.supportedDirectionKeys.contains(
    directionKey,
  )) {
    throw UnsupportedEncodeValueError(
      value,
      'Field "decoration.gradient.transform.css_linear.direction" only '
      'supports CSS linear-gradient directions.',
    );
  }

  return {'kind': 'css_linear', 'direction': directionKey};
}
