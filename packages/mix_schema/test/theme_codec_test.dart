import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  const codec = MixSchemaThemeCodec();

  group('theme document', () {
    test('decodes and encodes a full multi-kind token fixture', () {
      final decoded = _decodeTheme(codec, _themeFixture());
      final tokens = decoded.tokens;

      expect(
        tokens[const ColorToken('color.surface')],
        const Color(0xFF101820),
      );
      expect(
        tokens[const ColorToken('color.surface.alias')],
        const Color(0xFF101820),
      );
      expect(tokens[const SpaceToken('space.stack.sm')], 8.0);
      expect(tokens[const SpaceToken('space.stack.alias')], 8.0);
      expect(tokens[const DoubleToken('double.opacity')], 0.64);
      expect(tokens[const DoubleToken('double.opacity.alias')], 0.64);
      expect(
        tokens[const RadiusToken('radius.card')],
        const Radius.circular(12),
      );
      expect(
        tokens[const TextStyleToken('type.body')],
        const TextStyle(fontSize: 14, height: 1.4),
      );
      expect(tokens[const ShadowToken('shadow.text.soft')], const [
        Shadow(color: Color(0x33000000), offset: Offset(0, 1), blurRadius: 2),
      ]);
      expect(tokens[const BoxShadowToken('shadow.box.raised')], const [
        BoxShadow(
          color: Color(0x33000000),
          offset: Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ]);
      expect(
        tokens[const BorderSideToken('border.focus')],
        const BorderSide(color: Color(0xFF008577), width: 2),
      );
      expect(
        tokens[const FontWeightToken('font.weight.strong')],
        FontWeight.w700,
      );
      expect(
        tokens[const BreakpointToken('breakpoint.sidebar')],
        Breakpoint.minWidth(960),
      );
      expect(
        tokens[const DurationToken('duration.fast')],
        const Duration(milliseconds: 120),
      );

      final encoded = _encodeTheme(codec, decoded);
      expect(encoded['v'], mixSchemaFormatVersion);
      expect(encoded['type'], 'theme');
      expect(
        Map<String, Object?>.from(
          encoded['colors']! as Map,
        )['color.surface.alias'],
        isNot(contains(r'$token')),
      );
      expect(_decodeTheme(codec, encoded).tokens, tokens);
    });

    test('rejects alias cycles with the cycle path', () {
      final result = codec.decode({
        'v': 1,
        'type': 'theme',
        'colors': {
          'color.a': {r'$token': 'color.b'},
          'color.b': {r'$token': 'color.a'},
        },
      });
      final errors = switch (result) {
        MixSchemaDecodeFailure<MixSchemaThemeDocument>(:final errors) => errors,
        MixSchemaDecodeSuccess<MixSchemaThemeDocument>() => fail(
          'expected failure',
        ),
      };

      expect(
        errors,
        contains(
          isA<MixSchemaError>()
              .having(
                (error) => error.code,
                'code',
                MixSchemaErrorCode.constraintViolation,
              )
              .having((error) => error.path, 'path', '/colors/color.b/\$token')
              .having(
                (error) => error.message,
                'message',
                contains('color.a -> color.b -> color.a'),
              ),
        ),
      );
    });

    test('rejects cross-kind aliases', () {
      final result = codec.decode({
        'v': 1,
        'type': 'theme',
        'colors': {
          'color.alias': {r'$token': 'space.sm'},
        },
        'spaces': {'space.sm': 8},
      });
      final errors = switch (result) {
        MixSchemaDecodeFailure<MixSchemaThemeDocument>(:final errors) => errors,
        MixSchemaDecodeSuccess<MixSchemaThemeDocument>() => fail(
          'expected failure',
        ),
      };

      expect(errors.single.code, MixSchemaErrorCode.constraintViolation);
      expect(errors.single.path, '/colors/color.alias/\$token');
      expect(errors.single.message, contains('"spaces"'));
    });

    test('rejects extra alias keys including apply', () {
      final cases = <String, ({String extraKey, JsonMap payload})>{
        'apply': (
          extraKey: 'apply',
          payload: {
            'v': 1,
            'type': 'theme',
            'colors': {
              'color.brand': '#336699',
              'color.alias': {
                r'$token': 'color.brand',
                'apply': [
                  {'op': 'color_opacity', 'opacity': 0.5},
                ],
              },
            },
          },
        ),
        'extra': (
          extraKey: 'fallback',
          payload: {
            'v': 1,
            'type': 'theme',
            'colors': {
              'color.brand': '#336699',
              'color.alias': {r'$token': 'color.brand', 'fallback': '#000000'},
            },
          },
        ),
      };

      for (final entry in cases.entries) {
        final result = codec.decode(entry.value.payload);
        final errors = switch (result) {
          MixSchemaDecodeFailure<MixSchemaThemeDocument>(:final errors) =>
            errors,
          MixSchemaDecodeSuccess<MixSchemaThemeDocument>() => fail(
            'expected ${entry.key} failure',
          ),
        };

        expect(errors.single.code, MixSchemaErrorCode.unknownField);
        expect(
          errors.single.path,
          '/colors/color.alias/${entry.value.extraKey}',
        );
      }
    });

    test('round-trips canonical text style fields', () {
      final payload = {
        'v': 1,
        'type': 'theme',
        'textStyles': {
          'type.rich': {
            'color': '#112233',
            'backgroundColor': '#445566',
            'fontSize': 16,
            'fontWeight': 'w700',
            'fontStyle': 'italic',
            'letterSpacing': 0.4,
            'debugLabel': 'rich-label',
            'wordSpacing': 1.2,
            'textBaseline': 'alphabetic',
            'height': 1.5,
            'fontFamily': 'Inter',
            'fontFamilyFallback': ['Arial', 'sans-serif'],
            'fontFeatures': [
              {'feature': 'liga', 'value': 1},
            ],
            'fontVariations': [
              {'axis': 'wght', 'value': 650},
            ],
            'decoration': 'underline',
            'decorationColor': '#778899',
            'decorationStyle': 'dashed',
            'decorationThickness': 2,
            'shadows': [
              {
                'color': '#33000000',
                'offset': {'x': 0, 'y': 1},
                'blurRadius': 2,
              },
            ],
          },
        },
      };

      final decoded = _decodeTheme(codec, payload);
      final style = decoded.tokens[const TextStyleToken('type.rich')];

      expect(
        style,
        isA<TextStyle>()
            .having((value) => value.color, 'color', const Color(0xFF112233))
            .having(
              (value) => value.backgroundColor,
              'backgroundColor',
              const Color(0xFF445566),
            )
            .having((value) => value.fontSize, 'fontSize', 16)
            .having((value) => value.fontWeight, 'fontWeight', FontWeight.w700)
            .having((value) => value.fontStyle, 'fontStyle', FontStyle.italic)
            .having((value) => value.letterSpacing, 'letterSpacing', 0.4)
            .having((value) => value.debugLabel, 'debugLabel', 'rich-label')
            .having((value) => value.wordSpacing, 'wordSpacing', 1.2)
            .having(
              (value) => value.textBaseline,
              'textBaseline',
              TextBaseline.alphabetic,
            )
            .having((value) => value.height, 'height', 1.5)
            .having((value) => value.fontFamily, 'fontFamily', 'Inter')
            .having((value) => value.fontFamilyFallback, 'fontFamilyFallback', [
              'Arial',
              'sans-serif',
            ])
            .having((value) => value.fontFeatures, 'fontFeatures', const [
              FontFeature('liga'),
            ])
            .having((value) => value.fontVariations, 'fontVariations', const [
              FontVariation('wght', 650),
            ])
            .having(
              (value) => value.textBaseline,
              'textBaseline',
              TextBaseline.alphabetic,
            )
            .having(
              (value) => value.decoration,
              'decoration',
              TextDecoration.underline,
            )
            .having(
              (value) => value.decorationColor,
              'decorationColor',
              const Color(0xFF778899),
            )
            .having(
              (value) => value.decorationStyle,
              'decorationStyle',
              TextDecorationStyle.dashed,
            )
            .having(
              (value) => value.decorationThickness,
              'decorationThickness',
              2,
            ),
      );
      expect(_encodeTheme(codec, decoded), payload);
    });

    test('rejects token references when encoding concrete theme values', () {
      final result = codec.encode(
        MixSchemaThemeDocument(
          tokens: {
            const DoubleToken('double.alias'): const SpaceToken('space.base')(),
            const TextStyleToken('type.bad'): TextStyle(
              fontSize: const DoubleToken('double.font')(),
            ),
          },
        ),
      );
      final errors = switch (result) {
        MixSchemaEncodeFailure(:final errors) => errors,
        MixSchemaEncodeSuccess() => fail('expected failure'),
      };

      expect(
        errors,
        contains(
          isA<MixSchemaError>()
              .having(
                (error) => error.code,
                'code',
                MixSchemaErrorCode.constraintViolation,
              )
              .having((error) => error.path, 'path', '/doubles/double.alias')
              .having(
                (error) => error.message,
                'message',
                contains('must be concrete'),
              ),
        ),
      );
      expect(
        errors,
        contains(
          isA<MixSchemaError>().having(
            (error) => error.path,
            'path',
            '/textStyles/type.bad',
          ),
        ),
      );
    });

    test('uses a dedicated entry point outside the styler root union', () {
      final contract = MixSchemaContractBuilder().builtIn().freeze();
      final result = contract.decode<Object>(_themeFixture());
      final errors = switch (result) {
        MixSchemaDecodeFailure<Object>(:final errors) => errors,
        MixSchemaDecodeSuccess<Object>() => fail('expected failure'),
      };

      expect(errors.single.code, MixSchemaErrorCode.unknownType);
      expect(errors.single.path, '/type');
      expect(_decodeTheme(codec, _themeFixture()).tokens, isNotEmpty);
    });

    test('exports JSON Schema for theme documents', () {
      final schema = codec.exportJsonSchema();
      final encoded = jsonEncode(schema);
      final properties = Map<String, Object?>.from(
        schema['properties']! as Map,
      );
      final colors = Map<String, Object?>.from(properties['colors']! as Map);
      final textStyles = Map<String, Object?>.from(
        properties['textStyles']! as Map,
      );
      final textStyleBranches =
          (Map<String, Object?>.from(
                    textStyles['additionalProperties']! as Map,
                  )['anyOf']!
                  as List)
              .cast<JsonMap>();

      expect(schema[r'$schema'], 'http://json-schema.org/draft-07/schema#');
      expect(schema['x-mix-schema-contract'], 'mix_schema_theme');
      expect(properties['v'], {'type': 'integer', 'const': 1});
      expect(
        Map<String, Object?>.from(properties['type']! as Map)['const'],
        'theme',
      );
      expect(
        colors['propertyNames'],
        containsPair('pattern', r'^[A-Za-z0-9_.-]{1,128}$'),
      );
      expect(encoded, contains(r'"$token"'));
      expect(encoded, contains('breakpoints'));
      expect(encoded, contains('durations'));
      expect(
        textStyleBranches.where(
          (branch) => jsonEncode(branch).contains(r'"$token"'),
        ),
        hasLength(1),
      );
    });
  });
}

JsonMap _themeFixture() {
  return {
    'v': 1,
    'type': 'theme',
    'colors': {
      'color.surface': '#101820',
      'color.surface.alias': {r'$token': 'color.surface'},
    },
    'spaces': {
      'space.stack.sm': 8,
      'space.stack.alias': {r'$token': 'space.stack.sm', 'kind': 'space'},
    },
    'doubles': {
      'double.opacity': 0.64,
      'double.opacity.alias': {r'$token': 'double.opacity', 'kind': 'double'},
    },
    'radii': {'radius.card': 12},
    'textStyles': {
      'type.body': {'fontSize': 14, 'height': 1.4},
    },
    'shadows': {
      'shadow.text.soft': [
        {
          'color': '#33000000',
          'offset': {'x': 0, 'y': 1},
          'blurRadius': 2,
        },
      ],
    },
    'boxShadows': {
      'shadow.box.raised': [
        {
          'color': '#33000000',
          'offset': {'x': 0, 'y': 2},
          'blurRadius': 8,
          'spreadRadius': 1,
        },
      ],
    },
    'borders': {
      'border.focus': {'color': '#008577', 'width': 2, 'style': 'solid'},
    },
    'fontWeights': {'font.weight.strong': 'w700'},
    'breakpoints': {
      'breakpoint.sidebar': {'minWidth': 960},
    },
    'durations': {'duration.fast': 120},
  };
}

MixSchemaThemeDocument _decodeTheme(
  MixSchemaThemeCodec codec,
  JsonMap payload,
) {
  return switch (codec.decode(payload)) {
    MixSchemaDecodeSuccess<MixSchemaThemeDocument>(:final value) => value,
    MixSchemaDecodeFailure<MixSchemaThemeDocument>(:final errors) => fail(
      '$errors',
    ),
  };
}

JsonMap _encodeTheme(
  MixSchemaThemeCodec codec,
  MixSchemaThemeDocument document,
) {
  return switch (codec.encode(document)) {
    MixSchemaEncodeSuccess(:final value) => value,
    MixSchemaEncodeFailure(:final errors) => fail('$errors'),
  };
}
