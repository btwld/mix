import 'package:ack/ack.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/schema_wire_types.dart';
import '../discriminated_branch_registry.dart';
import 'color_schema.dart';
import 'enum_schemas.dart';
import 'primitive_schemas.dart';

const Map<String, TextDecoration> _textDecorationByName = {
  'none': TextDecoration.none,
  'underline': TextDecoration.underline,
  'overline': TextDecoration.overline,
  'lineThrough': TextDecoration.lineThrough,
};

const Map<String, Directive<String>> _textTransformDirectiveByName =
    <String, Directive<String>>{
      'uppercase': UppercaseStringDirective(),
      'lowercase': LowercaseStringDirective(),
      'capitalize': CapitalizeStringDirective(),
      'titleCase': TitleCaseStringDirective(),
      'sentenceCase': SentenceCaseStringDirective(),
    };

final AckSchema<TextDecoration> textDecorationSchema = Ack.enumString(
  _textDecorationByName.keys.toList(growable: false),
).transform<TextDecoration>((value) => _textDecorationByName[value]!);

final AckSchema<Directive<String>> textTransformDirectiveSchema =
    Ack.enumString(
      _textTransformDirectiveByName.keys.toList(growable: false),
    ).transform<Directive<String>>(
      (value) => _textTransformDirectiveByName[value]!,
    );

final AckSchema<ShadowMix> shadowSchema =
    Ack.object({
      'color': colorSchema.optional(),
      'offset': offsetSchema.optional(),
      'blurRadius': Ack.double().optional(),
    }).transform<ShadowMix>((data) {
      final map = data;

      return ShadowMix(
        blurRadius: map['blurRadius'] as double?,
        color: map['color'] as Color?,
        offset: map['offset'] as Offset?,
      );
    });

final AckSchema<TextStyleMix> textStyleSchema =
    Ack.object({
      'color': colorSchema.optional(),
      'backgroundColor': colorSchema.optional(),
      'fontSize': Ack.double().optional(),
      'fontWeight': fontWeightSchema.optional(),
      'fontStyle': fontStyleSchema.optional(),
      'letterSpacing': Ack.double().optional(),
      'wordSpacing': Ack.double().optional(),
      'textBaseline': textBaselineSchema.optional(),
      'decoration': textDecorationSchema.optional(),
      'decorationColor': colorSchema.optional(),
      'decorationStyle': textDecorationStyleSchema.optional(),
      'height': Ack.double().optional(),
      'decorationThickness': Ack.double().optional(),
      'fontFamily': Ack.string().optional(),
      'fontFamilyFallback': stringListSchema.optional(),
      'inherit': Ack.boolean().optional(),
      'shadows': Ack.list(shadowSchema).optional(),
    }).transform<TextStyleMix>((data) {
      final map = data;

      return TextStyleMix(
        color: map['color'] as Color?,
        backgroundColor: map['backgroundColor'] as Color?,
        fontSize: map['fontSize'] as double?,
        fontWeight: map['fontWeight'] as FontWeight?,
        fontStyle: map['fontStyle'] as FontStyle?,
        letterSpacing: map['letterSpacing'] as double?,
        wordSpacing: map['wordSpacing'] as double?,
        textBaseline: map['textBaseline'] as TextBaseline?,
        shadows: castListOrNull(map['shadows']),
        decoration: map['decoration'] as TextDecoration?,
        decorationColor: map['decorationColor'] as Color?,
        decorationStyle: map['decorationStyle'] as TextDecorationStyle?,
        height: map['height'] as double?,
        decorationThickness: map['decorationThickness'] as double?,
        fontFamily: map['fontFamily'] as String?,
        fontFamilyFallback: castListOrNull(map['fontFamilyFallback']),
        inherit: map['inherit'] as bool?,
      );
    });

final AckSchema<StrutStyleMix> strutStyleSchema =
    Ack.object({
      'fontFamily': Ack.string().optional(),
      'fontFamilyFallback': stringListSchema.optional(),
      'fontSize': Ack.double().optional(),
      'fontWeight': fontWeightSchema.optional(),
      'fontStyle': fontStyleSchema.optional(),
      'height': Ack.double().optional(),
      'leading': Ack.double().optional(),
      'forceStrutHeight': Ack.boolean().optional(),
    }).transform<StrutStyleMix>((data) {
      final map = data;

      return StrutStyleMix(
        fontFamily: map['fontFamily'] as String?,
        fontFamilyFallback: castListOrNull(map['fontFamilyFallback']),
        fontSize: map['fontSize'] as double?,
        fontWeight: map['fontWeight'] as FontWeight?,
        fontStyle: map['fontStyle'] as FontStyle?,
        height: map['height'] as double?,
        leading: map['leading'] as double?,
        forceStrutHeight: map['forceStrutHeight'] as bool?,
      );
    });

final AckSchema<TextHeightBehaviorMix> textHeightBehaviorSchema =
    Ack.object({
      'applyHeightToFirstAscent': Ack.boolean().optional(),
      'applyHeightToLastDescent': Ack.boolean().optional(),
      'leadingDistribution': textLeadingDistributionSchema.optional(),
    }).transform<TextHeightBehaviorMix>((data) {
      final map = data;

      return TextHeightBehaviorMix(
        applyHeightToFirstAscent: map['applyHeightToFirstAscent'] as bool?,
        applyHeightToLastDescent: map['applyHeightToLastDescent'] as bool?,
        leadingDistribution:
            map['leadingDistribution'] as TextLeadingDistribution?,
      );
    });

final AckSchema<Locale> localeSchema =
    Ack.object({
      'languageCode': Ack.string(),
      'countryCode': Ack.string().nullable().optional(),
    }).transform<Locale>((data) {
      final map = data;
      final languageCode = map['languageCode'] as String;
      final countryCode = map['countryCode'] as String?;

      return countryCode == null
          ? Locale(languageCode)
          : Locale(languageCode, countryCode);
    });

AckSchema<TextScaler> buildTextScalerSchema() {
  final registry = DiscriminatedBranchRegistry<TextScaler>(
    discriminatorKey: 'type',
  );

  for (final type in SchemaTextScaler.values) {
    registry.register(type.wireValue, _buildTextScalerBranch(type));
  }

  return registry.freeze();
}

AckSchema<TextScaler> _buildTextScalerBranch(SchemaTextScaler type) {
  switch (type) {
    case .linear:
      return Ack.object({'factor': Ack.double().min(0)}).transform<TextScaler>((
        data,
      ) {
        final map = data;

        return TextScaler.linear(map['factor'] as double);
      });
  }
}
