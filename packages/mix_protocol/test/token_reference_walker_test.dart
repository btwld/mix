import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  MixProtocol contract() => mixProtocol;

  test(
    'finds token references across styles, variants, modifiers, and animation',
    () {
      final style = _decodeBox(contract(), _stylePayload());

      expect(
        tokenReferencesOf(style),
        unorderedEquals({
          const MixProtocolTokenReference('spaces', 'space.stack.sm'),
          const MixProtocolTokenReference('doubles', 'double.opacity'),
          const MixProtocolTokenReference('colors', 'color.surface'),
          const MixProtocolTokenReference('colors', 'color.accent'),
          const MixProtocolTokenReference('radii', 'radius.card'),
          const MixProtocolTokenReference('textStyles', 'type.body'),
          const MixProtocolTokenReference('shadows', 'shadow.text.soft'),
          const MixProtocolTokenReference('boxShadows', 'shadow.box.raised'),
          const MixProtocolTokenReference('borders', 'border.focus'),
          const MixProtocolTokenReference('fontWeights', 'font.weight.strong'),
          const MixProtocolTokenReference('breakpoints', 'breakpoint.sidebar'),
          const MixProtocolTokenReference('durations', 'duration.fast'),
          const MixProtocolTokenReference('durations', 'duration.delay'),
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
        .map(MixProtocolTokenReference.fromToken)
        .toSet();

    expect(tokenReferencesOf(style).difference(declared), {
      const MixProtocolTokenReference('colors', 'color.accent'),
      const MixProtocolTokenReference('durations', 'duration.delay'),
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
        const MixProtocolTokenReference('textStyles', 'type.bad'),
        const MixProtocolTokenReference('colors', 'color.text'),
        const MixProtocolTokenReference('spaces', 'space.font'),
        const MixProtocolTokenReference('fontWeights', 'font.weight.strong'),
        const MixProtocolTokenReference('colors', 'color.shadow'),
        const MixProtocolTokenReference('borders', 'border.bad'),
        const MixProtocolTokenReference('colors', 'color.border'),
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

BoxStyler _decodeBox(MixProtocol contract, JsonMap payload) {
  return switch (contract.decodeStyle<BoxStyler>(payload)) {
    MixProtocolSuccess<BoxStyler>(:final value) => value,
    MixProtocolFailure<BoxStyler>(:final errors) => fail('$errors'),
  };
}

MixProtocolTheme _decodeTheme(JsonMap payload) {
  return switch (mixProtocol.decodeTheme(payload)) {
    MixProtocolSuccess<MixProtocolTheme>(:final value) => value,
    MixProtocolFailure<MixProtocolTheme>(:final errors) => fail('$errors'),
  };
}
