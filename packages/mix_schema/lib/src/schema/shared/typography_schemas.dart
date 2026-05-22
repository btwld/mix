import 'package:ack/ack.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/numeric_codecs.dart';
import '../../core/prop_encode.dart';
import '../../core/schema_wire_types.dart';
import 'color_schema.dart';
import 'enum_schemas.dart';
import 'primitive_schemas.dart';

const Map<String, Directive<String>> _textTransformDirectiveByName =
    <String, Directive<String>>{
      'uppercase': UppercaseStringDirective(),
      'lowercase': LowercaseStringDirective(),
      'capitalize': CapitalizeStringDirective(),
      'titleCase': TitleCaseStringDirective(),
      'sentenceCase': SentenceCaseStringDirective(),
    };

final textDecorationCodec = aliasedEnumCodec<TextDecoration>(
  canonical: {
    TextDecoration.none: 'none',
    TextDecoration.underline: 'underline',
    TextDecoration.overline: 'overline',
    TextDecoration.lineThrough: 'lineThrough',
  },
);

final textTransformDirectiveSchema =
    Ack.codec<String, String, Directive<String>>(
      input: Ack.enumString(
        _textTransformDirectiveByName.keys.toList(growable: false),
      ),
      output: Ack.instance<Directive<String>>(),
      decode: (value) => _textTransformDirectiveByName[value]!,
      encode: _encodeTextTransformDirective,
    );

String _encodeTextTransformDirective(Directive<String> value) {
  return switch (value) {
    UppercaseStringDirective() => 'uppercase',
    LowercaseStringDirective() => 'lowercase',
    CapitalizeStringDirective() => 'capitalize',
    TitleCaseStringDirective() => 'titleCase',
    SentenceCaseStringDirective() => 'sentenceCase',
    _ => throw ArgumentError('Unsupported text transform directive.'),
  };
}

final shadowCodec = Ack.codec<JsonMap, JsonMap, ShadowMix>(
  input: Ack.object({
    'color': colorCodec.optional(),
    'offset': offsetCodec.optional(),
    'blurRadius': doubleFromNum().optional(),
  }),
  output: Ack.instance<ShadowMix>(),
  decode: (data) => ShadowMix(
    blurRadius: data['blurRadius'] as double?,
    color: data['color'] as Color?,
    offset: data['offset'] as Offset?,
  ),
  encode: (value) => optionalJsonMap([
    ('color', propValue(value.$color)),
    ('offset', propValue(value.$offset)),
    ('blurRadius', propValue(value.$blurRadius)),
  ]),
);

final textStyleCodec = Ack.codec<JsonMap, JsonMap, TextStyleMix>(
  input: Ack.object({
    'color': colorCodec.optional(),
    'backgroundColor': colorCodec.optional(),
    'fontSize': doubleFromNum().optional(),
    'fontWeight': fontWeightCodec.optional(),
    'fontStyle': fontStyleSchema.optional(),
    'letterSpacing': doubleFromNum().optional(),
    'wordSpacing': doubleFromNum().optional(),
    'textBaseline': textBaselineSchema.optional(),
    'decoration': textDecorationCodec.optional(),
    'decorationColor': colorCodec.optional(),
    'decorationStyle': textDecorationStyleSchema.optional(),
    'height': doubleFromNum().optional(),
    'decorationThickness': doubleFromNum().optional(),
    'fontFamily': Ack.string().optional(),
    'fontFamilyFallback': stringListSchema.optional(),
    'inherit': Ack.boolean().optional(),
    'shadows': Ack.list(shadowCodec).optional(),
  }),
  output: Ack.instance<TextStyleMix>(),
  decode: (data) => TextStyleMix(
    color: data['color'] as Color?,
    backgroundColor: data['backgroundColor'] as Color?,
    fontSize: data['fontSize'] as double?,
    fontWeight: data['fontWeight'] as FontWeight?,
    fontStyle: data['fontStyle'] as FontStyle?,
    letterSpacing: data['letterSpacing'] as double?,
    wordSpacing: data['wordSpacing'] as double?,
    textBaseline: data['textBaseline'] as TextBaseline?,
    shadows: castListOrNull(data['shadows']),
    decoration: data['decoration'] as TextDecoration?,
    decorationColor: data['decorationColor'] as Color?,
    decorationStyle: data['decorationStyle'] as TextDecorationStyle?,
    height: data['height'] as double?,
    decorationThickness: data['decorationThickness'] as double?,
    fontFamily: data['fontFamily'] as String?,
    fontFamilyFallback: castListOrNull(data['fontFamilyFallback']),
    inherit: data['inherit'] as bool?,
  ),
  encode: (value) {
    final ShadowListMix? shadows = propMix(value.$shadows);

    return optionalJsonMap([
      ('color', propValue(value.$color)),
      ('backgroundColor', propValue(value.$backgroundColor)),
      ('fontSize', propValue(value.$fontSize)),
      ('fontWeight', propValue(value.$fontWeight)),
      ('fontStyle', propValue(value.$fontStyle)),
      ('letterSpacing', propValue(value.$letterSpacing)),
      ('wordSpacing', propValue(value.$wordSpacing)),
      ('textBaseline', propValue(value.$textBaseline)),
      ('decoration', propValue(value.$decoration)),
      ('decorationColor', propValue(value.$decorationColor)),
      ('decorationStyle', propValue(value.$decorationStyle)),
      ('height', propValue(value.$height)),
      ('decorationThickness', propValue(value.$decorationThickness)),
      ('fontFamily', propValue(value.$fontFamily)),
      ('fontFamilyFallback', propValue(value.$fontFamilyFallback)),
      ('inherit', propValue(value.$inherit)),
      ('shadows', shadows?.items),
    ]);
  },
);

final strutStyleCodec = Ack.codec<JsonMap, JsonMap, StrutStyleMix>(
  input: Ack.object({
    'fontFamily': Ack.string().optional(),
    'fontFamilyFallback': stringListSchema.optional(),
    'fontSize': doubleFromNum().optional(),
    'fontWeight': fontWeightCodec.optional(),
    'fontStyle': fontStyleSchema.optional(),
    'height': doubleFromNum().optional(),
    'leading': doubleFromNum().optional(),
    'forceStrutHeight': Ack.boolean().optional(),
  }),
  output: Ack.instance<StrutStyleMix>(),
  decode: (data) => StrutStyleMix(
    fontFamily: data['fontFamily'] as String?,
    fontFamilyFallback: castListOrNull(data['fontFamilyFallback']),
    fontSize: data['fontSize'] as double?,
    fontWeight: data['fontWeight'] as FontWeight?,
    fontStyle: data['fontStyle'] as FontStyle?,
    height: data['height'] as double?,
    leading: data['leading'] as double?,
    forceStrutHeight: data['forceStrutHeight'] as bool?,
  ),
  encode: (value) => optionalJsonMap([
    ('fontFamily', propValue(value.$fontFamily)),
    ('fontFamilyFallback', propValue(value.$fontFamilyFallback)),
    ('fontSize', propValue(value.$fontSize)),
    ('fontWeight', propValue(value.$fontWeight)),
    ('fontStyle', propValue(value.$fontStyle)),
    ('height', propValue(value.$height)),
    ('leading', propValue(value.$leading)),
    ('forceStrutHeight', propValue(value.$forceStrutHeight)),
  ]),
);

final textHeightBehaviorCodec =
    Ack.codec<JsonMap, JsonMap, TextHeightBehaviorMix>(
      input: Ack.object({
        'applyHeightToFirstAscent': Ack.boolean().optional(),
        'applyHeightToLastDescent': Ack.boolean().optional(),
        'leadingDistribution': textLeadingDistributionSchema.optional(),
      }),
      output: Ack.instance<TextHeightBehaviorMix>(),
      decode: (data) => TextHeightBehaviorMix(
        applyHeightToFirstAscent: data['applyHeightToFirstAscent'] as bool?,
        applyHeightToLastDescent: data['applyHeightToLastDescent'] as bool?,
        leadingDistribution:
            data['leadingDistribution'] as TextLeadingDistribution?,
      ),
      encode: (value) => optionalJsonMap([
        (
          'applyHeightToFirstAscent',
          propValue(value.$applyHeightToFirstAscent),
        ),
        (
          'applyHeightToLastDescent',
          propValue(value.$applyHeightToLastDescent),
        ),
        ('leadingDistribution', propValue(value.$leadingDistribution)),
      ]),
    );

final localeCodec = Ack.codec<JsonMap, JsonMap, Locale>(
  input: Ack.object({
    'languageCode': Ack.string(),
    'countryCode': Ack.string().nullable().optional(),
  }),
  output: Ack.instance<Locale>(),
  decode: (data) {
    final languageCode = data['languageCode']! as String;
    final countryCode = data['countryCode'] as String?;

    return countryCode == null
        ? Locale(languageCode)
        : Locale(languageCode, countryCode);
  },
  encode: (locale) => optionalJsonMap([
    ('languageCode', locale.languageCode),
    ('countryCode', locale.countryCode),
  ]),
);

final textScalerCodec = Ack.discriminated<TextScaler>(
  discriminatorKey: 'type',
  schemas: {
    for (final type in SchemaTextScaler.values)
      type.wireValue: _buildTextScalerBranch(type),
  },
);

AckSchema<JsonMap, TextScaler> _buildTextScalerBranch(SchemaTextScaler type) {
  switch (type) {
    case .linear:
      return Ack.codec<JsonMap, JsonMap, TextScaler>(
        input: Ack.object({
          'factor': doubleFromNum().refine(
            (v) => v >= 0,
            message: 'Must be ≥ 0',
          ),
        }),
        output: Ack.instance<TextScaler>(),
        decode: (data) => TextScaler.linear(data['factor']! as double),
        encode: (value) => {'type': type.wireValue, 'factor': value.scale(1)},
      );
  }
}
