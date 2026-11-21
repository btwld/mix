import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  final codec = mixProtocol;

  group('theme document', () {
    test('rejects a missing top-level version', () {
      final result = codec.decodeTheme({'type': 'theme'});
      final errors = switch (result) {
        MixProtocolFailure<MixProtocolTheme>(:final errors) => errors,
        MixProtocolSuccess<MixProtocolTheme>() => fail('expected failure'),
      };

      expect(errors, hasLength(1));
      expect(errors.single.code, MixProtocolErrorCode.requiredField);
      expect(errors.single.path, '/v');
      expect(errors.single.severity, MixProtocolDiagnosticSeverity.error);
    });

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
      expect(encoded['v'], mixProtocolFormatVersion);
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
      final result = codec.decodeTheme({
        'v': 1,
        'type': 'theme',
        'colors': {
          'color.a': {r'$token': 'color.b'},
          'color.b': {r'$token': 'color.a'},
        },
      });
      final errors = switch (result) {
        MixProtocolFailure<MixProtocolTheme>(:final errors) => errors,
        MixProtocolSuccess<MixProtocolTheme>() => fail('expected failure'),
      };

      expect(
        errors,
        contains(
          isA<MixProtocolError>()
              .having(
                (error) => error.code,
                'code',
                MixProtocolErrorCode.constraintViolation,
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

    test('resolves long shallow alias chains within the input budget', () {
      const aliasCount = 4900;
      String name(int index) => 'color.${index.toString().padLeft(4, '0')}';
      final colors = <String, Object?>{
        for (var index = 0; index < aliasCount; index += 1)
          name(index): {r'$token': name(index + 1)},
        name(aliasCount): '#336699',
      };

      final result = codec.decodeTheme({
        'v': 1,
        'type': 'theme',
        'colors': colors,
      });
      final theme = switch (result) {
        MixProtocolSuccess<MixProtocolTheme>(:final value) => value,
        MixProtocolFailure<MixProtocolTheme>(:final errors) => fail('$errors'),
      };

      expect(theme.tokens, hasLength(aliasCount + 1));
      expect(theme.tokens[ColorToken(name(0))], const Color(0xFF336699));
    });

    test('rejects cross-kind aliases', () {
      final result = codec.decodeTheme({
        'v': 1,
        'type': 'theme',
        'colors': {
          'color.alias': {r'$token': 'space.sm'},
        },
        'spaces': {'space.sm': 8},
      });
      final errors = switch (result) {
        MixProtocolFailure<MixProtocolTheme>(:final errors) => errors,
        MixProtocolSuccess<MixProtocolTheme>() => fail('expected failure'),
      };

      expect(errors.single.code, MixProtocolErrorCode.constraintViolation);
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
        final result = codec.decodeTheme(entry.value.payload);
        final errors = switch (result) {
          MixProtocolFailure<MixProtocolTheme>(:final errors) => errors,
          MixProtocolSuccess<MixProtocolTheme>() => fail(
            'expected ${entry.key} failure',
          ),
        };

        expect(errors.single.code, MixProtocolErrorCode.unknownField);
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
      final result = codec.encodeTheme(
        MixProtocolTheme(
          tokens: {
            const DoubleToken('double.alias'): const SpaceToken('space.base')(),
            const TextStyleToken('type.bad'): TextStyle(
              fontSize: const DoubleToken('double.font')(),
            ),
          },
        ),
      );
      final errors = switch (result) {
        MixProtocolFailure<JsonMap>(:final errors) => errors,
        MixProtocolSuccess<JsonMap>() => fail('expected failure'),
      };

      expect(
        errors,
        contains(
          isA<MixProtocolError>()
              .having(
                (error) => error.code,
                'code',
                MixProtocolErrorCode.constraintViolation,
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
          isA<MixProtocolError>().having(
            (error) => error.path,
            'path',
            '/textStyles/type.bad',
          ),
        ),
      );
    });

    test('uses a dedicated entry point outside the styler root union', () {
      final contract = mixProtocol;
      final result = contract.decodeStyle<Object>(_themeFixture());
      final errors = switch (result) {
        MixProtocolFailure<Object>(:final errors) => errors,
        MixProtocolSuccess<Object>() => fail('expected failure'),
      };

      expect(errors.single.code, MixProtocolErrorCode.unknownType);
      expect(errors.single.path, '/type');
      expect(_decodeTheme(codec, _themeFixture()).tokens, isNotEmpty);
    });

    test('exports JSON Schema for theme documents', () {
      final schema = codec.exportThemeJsonSchema();
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
      expect(schema['x-mix-protocol-contract'], 'mix_protocol_theme');
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

MixProtocolTheme _decodeTheme(MixProtocol codec, JsonMap payload) {
  return switch (codec.decodeTheme(payload)) {
    MixProtocolSuccess<MixProtocolTheme>(:final value) => value,
    MixProtocolFailure<MixProtocolTheme>(:final errors) => fail('$errors'),
  };
}

JsonMap _encodeTheme(MixProtocol codec, MixProtocolTheme document) {
  return switch (codec.encodeTheme(document)) {
    MixProtocolSuccess<JsonMap>(:final value) => value,
    MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
  };
}
