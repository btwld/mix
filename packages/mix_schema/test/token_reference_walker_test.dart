import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  MixSchemaContract contract() => MixSchemaContractBuilder().builtIn().freeze();

  test(
    'finds token references across styles, variants, modifiers, and animation',
    () {
      final style = _decodeBox(contract(), _stylePayload());

      expect(
        tokenReferencesOf(style),
        unorderedEquals({
          const MixSchemaTokenReference('spaces', 'space.stack.sm'),
          const MixSchemaTokenReference('doubles', 'double.opacity'),
          const MixSchemaTokenReference('colors', 'color.surface'),
          const MixSchemaTokenReference('colors', 'color.accent'),
          const MixSchemaTokenReference('radii', 'radius.card'),
          const MixSchemaTokenReference('textStyles', 'type.body'),
          const MixSchemaTokenReference('shadows', 'shadow.text.soft'),
          const MixSchemaTokenReference('boxShadows', 'shadow.box.raised'),
          const MixSchemaTokenReference('borders', 'border.focus'),
          const MixSchemaTokenReference('fontWeights', 'font.weight.strong'),
          const MixSchemaTokenReference('breakpoints', 'breakpoint.sidebar'),
          const MixSchemaTokenReference('durations', 'duration.fast'),
          const MixSchemaTokenReference('durations', 'duration.delay'),
        }),
      );
    },
  );

  test('diffs a style document references against a theme document', () {
    final style = _decodeBox(contract(), _stylePayload());
    final theme = _decodeTheme({
      'v': 1,
      'type': 'theme',
      'colors': {'color.surface': '#101820'},
      'spaces': {'space.stack.sm': 8},
      'doubles': {'double.opacity': 0.64},
      'radii': {'radius.card': 12},
      'textStyles': {
        'type.body': {'fontSize': 14},
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
          },
        ],
      },
      'borders': {
        'border.focus': {'color': '#008577', 'width': 2},
      },
      'fontWeights': {'font.weight.strong': 'w700'},
      'breakpoints': {
        'breakpoint.sidebar': {'minWidth': 960},
      },
      'durations': {'duration.fast': 120},
    });

    final declared = theme.tokens.keys
        .map(MixSchemaTokenReference.fromToken)
        .toSet();

    expect(tokenReferencesOf(style).difference(declared), {
      const MixSchemaTokenReference('colors', 'color.accent'),
      const MixSchemaTokenReference('durations', 'duration.delay'),
    });
  });

  test('finds token references inside concrete theme value objects', () {
    final references = tokenReferencesOf({
      const TextStyleToken('type.bad'): TextStyle(
        color: const ColorToken('color.text')(),
        fontSize: const SpaceToken('space.font')(),
        fontWeight: const FontWeightToken('font.weight.strong')(),
        shadows: [Shadow(color: const ColorToken('color.shadow')())],
      ),
      const BorderSideToken('border.bad'): BorderSide(
        color: const ColorToken('color.border')(),
      ),
    });

    expect(
      references,
      unorderedEquals({
        const MixSchemaTokenReference('textStyles', 'type.bad'),
        const MixSchemaTokenReference('colors', 'color.text'),
        const MixSchemaTokenReference('spaces', 'space.font'),
        const MixSchemaTokenReference('fontWeights', 'font.weight.strong'),
        const MixSchemaTokenReference('colors', 'color.shadow'),
        const MixSchemaTokenReference('borders', 'border.bad'),
        const MixSchemaTokenReference('colors', 'color.border'),
      }),
    );
  });
}

JsonMap _stylePayload() {
  return {
    'v': 1,
    'type': 'box',
    'padding': {
      'top': {r'$token': 'space.stack.sm'},
      'bottom': {r'$token': 'double.opacity', 'kind': 'double'},
    },
    'decoration': {
      'color': {r'$token': 'color.surface'},
      'borderRadius': {r'$token': 'radius.card'},
      'border': {
        'top': {r'$token': 'border.focus'},
      },
      'boxShadow': {r'$token': 'shadow.box.raised'},
    },
    'modifiers': [
      {
        'type': 'default_text_style',
        'style': {r'$token': 'type.body'},
        'maxLines': 2,
      },
    ],
    'animation': {
      'duration': {r'$token': 'duration.fast'},
      'curve': 'linear',
      'delay': {r'$token': 'duration.delay'},
    },
    'variants': [
      {
        'kind': 'context_breakpoint',
        'token': 'breakpoint.sidebar',
        'style': {
          'type': 'box',
          'decoration': {
            'color': {r'$token': 'color.accent'},
          },
          'modifiers': [
            {
              'type': 'default_text_style',
              'style': {
                'fontWeight': {r'$token': 'font.weight.strong'},
                'shadows': {r'$token': 'shadow.text.soft'},
              },
            },
          ],
        },
      },
    ],
  };
}

BoxStyler _decodeBox(MixSchemaContract contract, JsonMap payload) {
  return switch (contract.decode<BoxStyler>(payload)) {
    MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
    MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
  };
}

MixSchemaThemeDocument _decodeTheme(JsonMap payload) {
  return switch (const MixSchemaThemeCodec().decode(payload)) {
    MixSchemaDecodeSuccess<MixSchemaThemeDocument>(:final value) => value,
    MixSchemaDecodeFailure<MixSchemaThemeDocument>(:final errors) => fail(
      '$errors',
    ),
  };
}
