import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';

import '../codecs/curve_codec.dart';

const _clipValues = ['none', 'hardEdge', 'antiAlias', 'antiAliasWithSaveLayer'];
const _borderStyleValues = ['none', 'solid'];
const _boxShapeValues = ['rectangle', 'circle'];
const _tileModeValues = ['clamp', 'repeated', 'mirror', 'decal'];

const _fontWeightValues = [
  'w100',
  'w200',
  'w300',
  'w400',
  'w500',
  'w600',
  'w700',
  'w800',
  'w900',
];

const _fontStyleValues = ['normal', 'italic'];
const _textLeadingDistributionValues = ['proportional', 'even'];
final _blendModeValues = BlendMode.values
    .map((value) => value.name)
    .toList(growable: false);
final _widgetStateValues = WidgetState.values
    .map((value) => value.name)
    .toList(growable: false);
const _modifierKindValues = [
  'reset',
  'opacity',
  'padding',
  'shaderMask',
  'clipOval',
  'clipRect',
  'clipPath',
  'clipRRect',
  'clipTriangle',
];

final edgeInsetsSchema = Ack.object(
  {
    'kind': Ack.enumString(['edgeInsets']),
    'left': Ack.double.nullable(),
    'top': Ack.double.nullable(),
    'right': Ack.double.nullable(),
    'bottom': Ack.double.nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final edgeInsetsDirectionalSchema = Ack.object(
  {
    'kind': Ack.enumString(['edgeInsetsDirectional']),
    'start': Ack.double.nullable(),
    'top': Ack.double.nullable(),
    'end': Ack.double.nullable(),
    'bottom': Ack.double.nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final edgeInsetsGeometrySchema = Ack.discriminated(
  discriminatorKey: 'kind',
  schemas: {
    'edgeInsets': edgeInsetsSchema,
    'edgeInsetsDirectional': edgeInsetsDirectionalSchema,
  },
);

final alignmentSchema = Ack.object(
  {
    'kind': Ack.enumString(['alignment']),
    'x': Ack.double,
    'y': Ack.double,
  },
  additionalProperties: false,
  required: ['kind', 'x', 'y'],
);

final alignmentDirectionalSchema = Ack.object(
  {
    'kind': Ack.enumString(['alignmentDirectional']),
    'start': Ack.double,
    'y': Ack.double,
  },
  additionalProperties: false,
  required: ['kind', 'start', 'y'],
);

final alignmentGeometrySchema = Ack.discriminated(
  discriminatorKey: 'kind',
  schemas: {
    'alignment': alignmentSchema,
    'alignmentDirectional': alignmentDirectionalSchema,
  },
);

final matrix4Schema = Ack.list(Ack.double).minItems(16).maxItems(16);

final boxConstraintsSchema = Ack.object({
  'minWidth': Ack.double.nullable(),
  'maxWidth': Ack.double.nullable(),
  'minHeight': Ack.double.nullable(),
  'maxHeight': Ack.double.nullable(),
}, additionalProperties: false);

final offsetSchema = Ack.object(
  {'dx': Ack.double, 'dy': Ack.double},
  additionalProperties: false,
  required: ['dx', 'dy'],
);

final boxShadowSchema = Ack.object({
  'color': Ack.int.nullable(),
  'offset': offsetSchema.nullable(),
  'blurRadius': Ack.double.nullable(),
  'spreadRadius': Ack.double.nullable(),
}, additionalProperties: false);

final borderSideSchema = Ack.object({
  'color': Ack.int.nullable(),
  'width': Ack.double.nullable(),
  'style': Ack.enumString(_borderStyleValues).nullable(),
  'strokeAlign': Ack.double.nullable(),
}, additionalProperties: false);

final borderSchema = Ack.object(
  {
    'kind': Ack.enumString(['border']),
    'top': borderSideSchema.nullable(),
    'bottom': borderSideSchema.nullable(),
    'left': borderSideSchema.nullable(),
    'right': borderSideSchema.nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final borderDirectionalSchema = Ack.object(
  {
    'kind': Ack.enumString(['borderDirectional']),
    'top': borderSideSchema.nullable(),
    'bottom': borderSideSchema.nullable(),
    'start': borderSideSchema.nullable(),
    'end': borderSideSchema.nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final boxBorderSchema = Ack.discriminated(
  discriminatorKey: 'kind',
  schemas: {
    'border': borderSchema,
    'borderDirectional': borderDirectionalSchema,
  },
);

final radiusSchema = Ack.object(
  {'x': Ack.double, 'y': Ack.double},
  additionalProperties: false,
  required: ['x', 'y'],
);

final borderRadiusSchema = Ack.object(
  {
    'kind': Ack.enumString(['borderRadius']),
    'topLeft': radiusSchema.nullable(),
    'topRight': radiusSchema.nullable(),
    'bottomLeft': radiusSchema.nullable(),
    'bottomRight': radiusSchema.nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final borderRadiusDirectionalSchema = Ack.object(
  {
    'kind': Ack.enumString(['borderRadiusDirectional']),
    'topStart': radiusSchema.nullable(),
    'topEnd': radiusSchema.nullable(),
    'bottomStart': radiusSchema.nullable(),
    'bottomEnd': radiusSchema.nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final borderRadiusGeometrySchema = Ack.discriminated(
  discriminatorKey: 'kind',
  schemas: {
    'borderRadius': borderRadiusSchema,
    'borderRadiusDirectional': borderRadiusDirectionalSchema,
  },
);

final gradientTransformRotationSchema = Ack.object(
  {
    'kind': Ack.enumString(['gradientRotation']),
    'radians': Ack.double,
  },
  additionalProperties: false,
  required: ['kind', 'radians'],
);

final gradientTransformSchema = Ack.discriminated(
  discriminatorKey: 'kind',
  schemas: {'gradientRotation': gradientTransformRotationSchema},
);

final linearGradientSchema = Ack.object(
  {
    'kind': Ack.enumString(['linearGradient']),
    'begin': alignmentGeometrySchema.nullable(),
    'end': alignmentGeometrySchema.nullable(),
    'tileMode': Ack.enumString(_tileModeValues).nullable(),
    'transform': gradientTransformSchema.nullable(),
    'colors': Ack.list(Ack.int).nullable(),
    'stops': Ack.list(Ack.double).nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final radialGradientSchema = Ack.object(
  {
    'kind': Ack.enumString(['radialGradient']),
    'center': alignmentGeometrySchema.nullable(),
    'radius': Ack.double.nullable(),
    'tileMode': Ack.enumString(_tileModeValues).nullable(),
    'focal': alignmentGeometrySchema.nullable(),
    'focalRadius': Ack.double.nullable(),
    'transform': gradientTransformSchema.nullable(),
    'colors': Ack.list(Ack.int).nullable(),
    'stops': Ack.list(Ack.double).nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final sweepGradientSchema = Ack.object(
  {
    'kind': Ack.enumString(['sweepGradient']),
    'center': alignmentGeometrySchema.nullable(),
    'startAngle': Ack.double.nullable(),
    'endAngle': Ack.double.nullable(),
    'tileMode': Ack.enumString(_tileModeValues).nullable(),
    'transform': gradientTransformSchema.nullable(),
    'colors': Ack.list(Ack.int).nullable(),
    'stops': Ack.list(Ack.double).nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final gradientSchema = Ack.discriminated(
  discriminatorKey: 'kind',
  schemas: {
    'linearGradient': linearGradientSchema,
    'radialGradient': radialGradientSchema,
    'sweepGradient': sweepGradientSchema,
  },
);

final boxDecorationSchema = Ack.object(
  {
    'kind': Ack.enumString(['boxDecoration']),
    'color': Ack.int.nullable(),
    'border': boxBorderSchema.nullable(),
    'borderRadius': borderRadiusGeometrySchema.nullable(),
    'gradient': gradientSchema.nullable(),
    'boxShadow': Ack.list(boxShadowSchema).nullable(),
    'shape': Ack.enumString(_boxShapeValues).nullable(),
    'backgroundBlendMode': Ack.enumString(_blendModeValues).nullable(),
    // DecorationImage is intentionally deferred in v1 and rejected by codecs.
    'image': Ack.object({}, additionalProperties: true).nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final textStyleDtoSchema = Ack.object({
  'color': Ack.int.nullable(),
  'fontSize': Ack.double.nullable(),
  'fontWeight': Ack.enumString(_fontWeightValues).nullable(),
  'fontStyle': Ack.enumString(_fontStyleValues).nullable(),
  'letterSpacing': Ack.double.nullable(),
  'wordSpacing': Ack.double.nullable(),
  'height': Ack.double.nullable(),
  'fontFamily': Ack.string.nullable(),
}, additionalProperties: false);

final strutStyleDtoSchema = Ack.object({
  'fontFamily': Ack.string.nullable(),
  'fontSize': Ack.double.nullable(),
  'fontWeight': Ack.enumString(_fontWeightValues).nullable(),
  'fontStyle': Ack.enumString(_fontStyleValues).nullable(),
  'height': Ack.double.nullable(),
  'leading': Ack.double.nullable(),
  'forceStrutHeight': Ack.boolean.nullable(),
}, additionalProperties: false);

final textHeightBehaviorDtoSchema = Ack.object({
  'applyHeightToFirstAscent': Ack.boolean.nullable(),
  'applyHeightToLastDescent': Ack.boolean.nullable(),
  'leadingDistribution': Ack.enumString(
    _textLeadingDistributionValues,
  ).nullable(),
}, additionalProperties: false);

final namedVariantSchema = Ack.object(
  {
    'kind': Ack.enumString(['named']),
    'name': Ack.string,
    'style': Ack.object({}, additionalProperties: true),
  },
  additionalProperties: false,
  required: ['kind', 'name', 'style'],
);

final widgetStateVariantSchema = Ack.object(
  {
    'kind': Ack.enumString(['widgetState']),
    'state': Ack.enumString(_widgetStateValues),
    'style': Ack.object({}, additionalProperties: true),
  },
  additionalProperties: false,
  required: ['kind', 'state', 'style'],
);

final contextVariantBuilderSchema = Ack.object(
  {
    'kind': Ack.enumString(['contextVariantBuilder']),
    'fn': Ack.string,
  },
  additionalProperties: false,
  required: ['kind', 'fn'],
);

final variantSchema = Ack.discriminated(
  discriminatorKey: 'kind',
  schemas: {
    'named': namedVariantSchema,
    'widgetState': widgetStateVariantSchema,
    'contextVariantBuilder': contextVariantBuilderSchema,
  },
);

final resetModifierSchema = Ack.object(
  {
    'kind': Ack.enumString(['reset']),
  },
  additionalProperties: false,
  required: ['kind'],
);

final opacityModifierSchema = Ack.object(
  {
    'kind': Ack.enumString(['opacity']),
    'opacity': Ack.double.nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final paddingModifierSchema = Ack.object(
  {
    'kind': Ack.enumString(['padding']),
    'padding': edgeInsetsGeometrySchema.nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final shaderMaskModifierSchema = Ack.object(
  {
    'kind': Ack.enumString(['shaderMask']),
    'shaderCallback': Ack.string,
    'blendMode': Ack.enumString(_blendModeValues).nullable(),
  },
  additionalProperties: false,
  required: ['kind', 'shaderCallback'],
);

final clipOvalModifierSchema = Ack.object(
  {
    'kind': Ack.enumString(['clipOval']),
    'clipper': Ack.string.nullable(),
    'clipBehavior': Ack.enumString(_clipValues).nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final clipRectModifierSchema = Ack.object(
  {
    'kind': Ack.enumString(['clipRect']),
    'clipper': Ack.string.nullable(),
    'clipBehavior': Ack.enumString(_clipValues).nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final clipPathModifierSchema = Ack.object(
  {
    'kind': Ack.enumString(['clipPath']),
    'clipper': Ack.string.nullable(),
    'clipBehavior': Ack.enumString(_clipValues).nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final clipRRectModifierSchema = Ack.object(
  {
    'kind': Ack.enumString(['clipRRect']),
    'borderRadius': borderRadiusGeometrySchema.nullable(),
    'clipper': Ack.string.nullable(),
    'clipBehavior': Ack.enumString(_clipValues).nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final clipTriangleModifierSchema = Ack.object(
  {
    'kind': Ack.enumString(['clipTriangle']),
    'clipBehavior': Ack.enumString(_clipValues).nullable(),
  },
  additionalProperties: false,
  required: ['kind'],
);

final modifierItemSchema = Ack.discriminated(
  discriminatorKey: 'kind',
  schemas: {
    'reset': resetModifierSchema,
    'opacity': opacityModifierSchema,
    'padding': paddingModifierSchema,
    'shaderMask': shaderMaskModifierSchema,
    'clipOval': clipOvalModifierSchema,
    'clipRect': clipRectModifierSchema,
    'clipPath': clipPathModifierSchema,
    'clipRRect': clipRRectModifierSchema,
    'clipTriangle': clipTriangleModifierSchema,
  },
);

final modifierConfigSchema = Ack.object({
  'orderOfModifiers': Ack.list(Ack.enumString(_modifierKindValues)).nullable(),
  'modifiers': Ack.list(modifierItemSchema).nullable(),
}, additionalProperties: false);

final boxDataSchema = Ack.object({
  'alignment': alignmentGeometrySchema.nullable(),
  'clipBehavior': Ack.enumString(_clipValues).nullable(),
  'animation': Ack.object(
    {
      'durationMs': Ack.int,
      'curve': Ack.enumString(CurveCodec.supportedCurveNames),
      'delayMs': Ack.int.nullable(),
      'onEnd': Ack.string.nullable(),
    },
    additionalProperties: false,
    required: ['durationMs', 'curve'],
  ).nullable(),
  'transform': matrix4Schema.nullable(),
  'transformAlignment': alignmentGeometrySchema.nullable(),
  'padding': edgeInsetsGeometrySchema.nullable(),
  'margin': edgeInsetsGeometrySchema.nullable(),
  'constraints': boxConstraintsSchema.nullable(),
  'decoration': boxDecorationSchema.nullable(),
  'foregroundDecoration': boxDecorationSchema.nullable(),
  'modifier': modifierConfigSchema.nullable(),
  'variants': Ack.list(variantSchema).nullable(),
}, additionalProperties: false);
