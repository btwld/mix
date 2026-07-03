import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  MixSchemaContract contract() => MixSchemaContractBuilder().builtIn().freeze();

  JsonMap encode(Object value) {
    return switch (contract().encode(value)) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };
  }

  T decode<T extends Object>(JsonMap payload) {
    return switch (contract().decode<T>(payload)) {
      MixSchemaDecodeSuccess<T>(:final value) => value,
      MixSchemaDecodeFailure<T>(:final errors) => fail('$errors'),
    };
  }

  group('property directive grammar', () {
    for (final entry in _colorDirectiveCases.entries) {
      test('round-trips ${entry.key} color directive params', () {
        final payload = {
          'v': 1,
          'type': 'box',
          'decoration': {
            'color': {
              r'$merge': ['#336699'],
              'apply': [
                {'op': entry.key, ...entry.value},
              ],
            },
          },
        };

        final decoded = decode<BoxStyler>(payload);

        expect(encode(decoded), payload);
      });
    }

    for (final op in _stringDirectiveOps) {
      test('round-trips $op string directive', () {
        final payload = {
          'v': 1,
          'type': 'text',
          'semanticsLabel': {
            r'$merge': ['hello world'],
            'apply': [
              {'op': op},
            ],
          },
        };

        final decoded = decode<TextStyler>(payload);

        expect(encode(decoded), payload);
      });
    }

    for (final entry in _numberDirectiveCases.entries) {
      test('round-trips ${entry.key} number directive params', () {
        final payload = {
          'v': 1,
          'type': 'flex',
          'spacing': {
            r'$merge': [4],
            'apply': [
              {'op': entry.key, ...entry.value},
            ],
          },
        };

        final decoded = decode<FlexStyler>(payload);

        expect(encode(decoded), payload);
      });
    }

    test('round-trips string directives on string terms', () {
      final style = TextStyler.create(
        semanticsLabel: Prop.value(
          'hello world',
        ).directives([const TitleCaseStringDirective()]),
      );

      final payload = encode(style);

      expect(payload['semanticsLabel'], {
        r'$merge': ['hello world'],
        'apply': [
          {'op': 'title_case'},
        ],
      });
      expect(encode(decode<TextStyler>(payload)), payload);
    });

    test('round-trips nested text style token directives', () {
      final payload = {
        'v': 1,
        'type': 'text',
        'style': {
          'color': {
            r'$token': 'color.brand',
            'apply': [
              {'op': 'color_alpha', 'alpha': 128},
            ],
          },
        },
      };

      final decoded = decode<TextStyler>(payload);

      expect(encode(decoded), payload);
    });

    test('round-trips nested strut numeric directives', () {
      final payload = {
        'v': 1,
        'type': 'text',
        'strutStyle': {
          'fontSize': {
            r'$merge': [12],
            'apply': [
              {'op': 'number_multiply', 'factor': 1.5},
            ],
          },
        },
      };

      final decoded = decode<TextStyler>(payload);

      expect(encode(decoded), payload);
    });

    test('round-trips nested box shadow merge terms', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'decoration': {
          'boxShadow': {
            r'$merge': [
              [
                {
                  'color': '#000000',
                  'offset': {'x': 0, 'y': 1},
                  'blurRadius': 2,
                },
              ],
              [
                {
                  'color': '#FFFFFF',
                  'offset': {'x': 2, 'y': 3},
                  'blurRadius': 4,
                },
              ],
            ],
          },
        },
      };

      final decoded = decode<BoxStyler>(payload);

      expect(encode(decoded), payload);
    });

    test('unknown directive ops fail strict and skip in lenient mode', () {
      final payload = {
        'v': 1,
        'type': 'box',
        'padding': 4,
        'decoration': {
          'color': {
            r'$token': 'color.brand',
            'apply': [
              {'op': 'future_op'},
            ],
          },
        },
      };

      final strict = contract().decode<BoxStyler>(payload);
      final strictErrors = switch (strict) {
        MixSchemaDecodeFailure<BoxStyler>(:final errors) => errors,
        MixSchemaDecodeSuccess<BoxStyler>() => fail('expected failure'),
      };

      expect(strictErrors.single.code, MixSchemaErrorCode.invalidEnum);

      final lenient = contract().decode<BoxStyler>(
        payload,
        options: const MixSchemaDecodeOptions(
          mode: MixSchemaDecodeMode.lenient,
        ),
      );
      final success = switch (lenient) {
        MixSchemaDecodeSuccess<BoxStyler> result => result,
        MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
      };

      final reencoded = encode(success.value);

      expect(success.warnings.single.code, MixSchemaErrorCode.invalidEnum);
      expect(success.warnings.single.path, '/decoration/color/apply/0/op');
      expect(reencoded['decoration'], {
        'color': {r'$token': 'color.brand'},
      });
      expect(reencoded['padding'], 4.0);
    });
  });
}

const Map<String, JsonMap> _colorDirectiveCases = {
  'color_opacity': {'opacity': 0.5},
  'color_with_values': {
    'alpha': 0.7,
    'red': 0.2,
    'green': 0.3,
    'blue': 0.4,
    'colorSpace': 'sRGB',
  },
  'color_alpha': {'alpha': 128},
  'color_darken': {'amount': 10},
  'color_lighten': {'amount': 10},
  'color_saturate': {'amount': 10},
  'color_desaturate': {'amount': 10},
  'color_tint': {'amount': 10},
  'color_shade': {'amount': 10},
  'color_brighten': {'amount': 10},
  'color_with_red': {'red': 12},
  'color_with_green': {'green': 34},
  'color_with_blue': {'blue': 56},
};

const List<String> _stringDirectiveOps = [
  'uppercase',
  'lowercase',
  'capitalize',
  'title_case',
  'sentence_case',
];

const Map<String, JsonMap> _numberDirectiveCases = {
  'number_multiply': {'factor': 1.5},
  'number_add': {'addend': 2},
  'number_subtract': {'subtrahend': 1},
  'number_divide': {'divisor': 2},
  'number_clamp': {'min': 1, 'max': 8},
  'number_abs': {},
  'number_round': {},
  'number_floor': {},
  'number_ceil': {},
};
