import 'package:ack/ack.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
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

final CodecSchema<String, TextDecoration> textDecorationCodec =
    aliasedEnumCodec<TextDecoration>(
      canonical: {
        TextDecoration.none: 'none',
        TextDecoration.underline: 'underline',
        TextDecoration.overline: 'overline',
        TextDecoration.lineThrough: 'lineThrough',
      },
    );

final CodecSchema<String, Directive<String>> textTransformDirectiveSchema =
    Ack.codec<String, Directive<String>>(
      input: Ack.enumString(
        _textTransformDirectiveByName.keys.toList(growable: false),
      ),
      output: Ack.instance<Directive<String>>(),
      decoder: (value) => _textTransformDirectiveByName[value]!,
      encoder: _encodeTextTransformDirective,
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

final CodecSchema<Map<String, Object?>, ShadowMix> shadowCodec =
    Ack.codec<Map<String, Object?>, ShadowMix>(
      input: Ack.object({
        'color': colorCodec.optional(),
        'offset': offsetCodec.optional(),
        'blurRadius': Ack.number().optional(),
      }),
      output: Ack.instance<ShadowMix>(),
      decoder: (data) => ShadowMix(
        blurRadius: castDoubleOrNull(data['blurRadius']),
        color: data['color'] as Color?,
        offset: data['offset'] as Offset?,
      ),
      encoder: (value) => optionalJsonMap([
        ('color', propValue(value.$color)),
        ('offset', propValue(value.$offset)),
        ('blurRadius', propValue(value.$blurRadius)),
      ]),
    );

final CodecSchema<Map<String, Object?>, TextStyleMix> textStyleCodec =
    Ack.codec<Map<String, Object?>, TextStyleMix>(
      input: Ack.object({
        'color': colorCodec.optional(),
        'backgroundColor': colorCodec.optional(),
        'fontSize': Ack.number().optional(),
        'fontWeight': fontWeightCodec.optional(),
        'fontStyle': fontStyleSchema.optional(),
        'letterSpacing': Ack.number().optional(),
        'wordSpacing': Ack.number().optional(),
        'textBaseline': textBaselineSchema.optional(),
        'decoration': textDecorationCodec.optional(),
        'decorationColor': colorCodec.optional(),
        'decorationStyle': textDecorationStyleSchema.optional(),
        'height': Ack.number().optional(),
        'decorationThickness': Ack.number().optional(),
        'fontFamily': Ack.string().optional(),
        'fontFamilyFallback': stringListSchema.optional(),
        'inherit': Ack.boolean().optional(),
        'shadows': Ack.list(shadowCodec).optional(),
      }),
      output: Ack.instance<TextStyleMix>(),
      decoder: (data) => TextStyleMix(
        color: data['color'] as Color?,
        backgroundColor: data['backgroundColor'] as Color?,
        fontSize: castDoubleOrNull(data['fontSize']),
        fontWeight: data['fontWeight'] as FontWeight?,
        fontStyle: data['fontStyle'] as FontStyle?,
        letterSpacing: castDoubleOrNull(data['letterSpacing']),
        wordSpacing: castDoubleOrNull(data['wordSpacing']),
        textBaseline: data['textBaseline'] as TextBaseline?,
        shadows: castListOrNull(data['shadows']),
        decoration: data['decoration'] as TextDecoration?,
        decorationColor: data['decorationColor'] as Color?,
        decorationStyle: data['decorationStyle'] as TextDecorationStyle?,
        height: castDoubleOrNull(data['height']),
        decorationThickness: castDoubleOrNull(data['decorationThickness']),
        fontFamily: data['fontFamily'] as String?,
        fontFamilyFallback: castListOrNull(data['fontFamilyFallback']),
        inherit: data['inherit'] as bool?,
      ),
      encoder: (value) {
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

final CodecSchema<Map<String, Object?>, StrutStyleMix> strutStyleCodec =
    Ack.codec<Map<String, Object?>, StrutStyleMix>(
      input: Ack.object({
        'fontFamily': Ack.string().optional(),
        'fontFamilyFallback': stringListSchema.optional(),
        'fontSize': Ack.number().optional(),
        'fontWeight': fontWeightCodec.optional(),
        'fontStyle': fontStyleSchema.optional(),
        'height': Ack.number().optional(),
        'leading': Ack.number().optional(),
        'forceStrutHeight': Ack.boolean().optional(),
      }),
      output: Ack.instance<StrutStyleMix>(),
      decoder: (data) => StrutStyleMix(
        fontFamily: data['fontFamily'] as String?,
        fontFamilyFallback: castListOrNull(data['fontFamilyFallback']),
        fontSize: castDoubleOrNull(data['fontSize']),
        fontWeight: data['fontWeight'] as FontWeight?,
        fontStyle: data['fontStyle'] as FontStyle?,
        height: castDoubleOrNull(data['height']),
        leading: castDoubleOrNull(data['leading']),
        forceStrutHeight: data['forceStrutHeight'] as bool?,
      ),
      encoder: (value) => optionalJsonMap([
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

final CodecSchema<Map<String, Object?>, TextHeightBehaviorMix>
textHeightBehaviorCodec =
    Ack.codec<Map<String, Object?>, TextHeightBehaviorMix>(
      input: Ack.object({
        'applyHeightToFirstAscent': Ack.boolean().optional(),
        'applyHeightToLastDescent': Ack.boolean().optional(),
        'leadingDistribution': textLeadingDistributionSchema.optional(),
      }),
      output: Ack.instance<TextHeightBehaviorMix>(),
      decoder: (data) => TextHeightBehaviorMix(
        applyHeightToFirstAscent: data['applyHeightToFirstAscent'] as bool?,
        applyHeightToLastDescent: data['applyHeightToLastDescent'] as bool?,
        leadingDistribution:
            data['leadingDistribution'] as TextLeadingDistribution?,
      ),
      encoder: (value) => optionalJsonMap([
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

final CodecSchema<Map<String, Object?>, Locale> localeCodec =
    Ack.codec<Map<String, Object?>, Locale>(
      input: Ack.object({
        'languageCode': Ack.string(),
        'countryCode': Ack.string().nullable().optional(),
      }),
      output: Ack.instance<Locale>(),
      decoder: (data) {
        final languageCode = data['languageCode'] as String;
        final countryCode = data['countryCode'] as String?;

        return countryCode == null
            ? Locale(languageCode)
            : Locale(languageCode, countryCode);
      },
      encoder: (locale) => optionalJsonMap([
        ('languageCode', locale.languageCode),
        ('countryCode', locale.countryCode),
      ]),
    );

final AckSchema<TextScaler> textScalerCodec = Ack.discriminated<TextScaler>(
  discriminatorKey: 'type',
  schemas: {
    for (final type in SchemaTextScaler.values)
      type.wireValue: _buildTextScalerBranch(type),
  },
);

AckSchema<TextScaler> _buildTextScalerBranch(SchemaTextScaler type) {
  switch (type) {
    case .linear:
      return Ack.codec<Map<String, Object?>, TextScaler>(
        input: Ack.object({
          'type': Ack.literal(type.wireValue),
          'factor': Ack.number().min(0),
        }),
        output: Ack.instance<TextScaler>(),
        decoder: (data) => TextScaler.linear(castDouble(data['factor'])),
        encoder: (value) => {'type': type.wireValue, 'factor': value.scale(1)},
      );
  }
}
