import 'package:ack/ack.dart';

import '../codecs/curve_codec.dart';

const _clipValues = ['none', 'hardEdge', 'antiAlias', 'antiAliasWithSaveLayer'];

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

final boxDecorationSchema = Ack.object(
  {
    'kind': Ack.enumString(['boxDecoration']),
    'color': Ack.int.nullable(),
    'boxShadow': Ack.list(boxShadowSchema).nullable(),
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

final boxDataSchema = Ack.object({
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
  'padding': edgeInsetsGeometrySchema.nullable(),
  'margin': edgeInsetsGeometrySchema.nullable(),
  'constraints': boxConstraintsSchema.nullable(),
  'decoration': boxDecorationSchema.nullable(),
  'foregroundDecoration': boxDecorationSchema.nullable(),
}, additionalProperties: false);
