import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_figma/mix_figma.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  group('dtcgToThemeDocument', () {
    test('converts a multi-type DTCG document to a decodable theme', () {
      final result = dtcgToThemeDocument(
        _fixture(),
        options: const DtcgConversionOptions(
          groupOverrides: {'radius': 'radii', 'breakpoint': 'breakpoints'},
        ),
      );

      final document = result.themeDocument;
      expect(document['v'], mixProtocolFormatVersion);
      expect(document['type'], 'theme');

      final theme = _decodeTheme(document);
      final tokens = theme.tokens;

      expect(tokens[const ColorToken('color.brand.primary')], _rgb(0x3366FF));
      expect(tokens[const ColorToken('color.brand.secondary')], _rgb(0x101820));
      expect(
        tokens[const ColorToken('color.overlay')],
        const Color(0x80000000),
      );
      // Alias resolves to the same value as its target.
      expect(tokens[const ColorToken('color.action')], _rgb(0x3366FF));

      expect(tokens[const SpaceToken('space.sm')], 8.0);
      expect(tokens[const SpaceToken('space.md')], 16.0);
      // Alias within the spaces group.
      expect(tokens[const SpaceToken('space.gutter')], 16.0);

      expect(
        tokens[const RadiusToken('radius.card')],
        const Radius.circular(12),
      );
      expect(
        tokens[const BreakpointToken('breakpoint.md')],
        Breakpoint.minWidth(768),
      );

      expect(tokens[const DoubleToken('opacity.disabled')], 0.4);
      expect(tokens[const FontWeightToken('weight.bold')], FontWeight.w700);
      expect(tokens[const FontWeightToken('weight.heading')], FontWeight.w600);
      expect(
        tokens[const DurationToken('motion.fast')],
        const Duration(milliseconds: 150),
      );
      expect(
        tokens[const DurationToken('motion.slow')],
        const Duration(milliseconds: 2000),
      );

      expect(tokens[const BoxShadowToken('elevation.raised')], const [
        BoxShadow(
          color: Color(0x33000000),
          offset: Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Color(0x1A000000),
          offset: Offset(0, 1),
          blurRadius: 2,
        ),
      ]);

      expect(
        tokens[const BorderSideToken('border.focus')],
        const BorderSide(color: Color(0xFF008577), width: 2),
      );

      expect(
        tokens[const TextStyleToken('type.body')],
        const TextStyle(
          fontFamily: 'Inter',
          fontFamilyFallback: ['Roboto'],
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
          height: 1.4,
        ),
      );
    });

    test('converted documents survive a strict decode/encode round trip', () {
      final result = dtcgToThemeDocument(_fixture());
      final theme = _decodeTheme(result.themeDocument);
      final encoded = switch (mixProtocol.encodeTheme(theme)) {
        MixProtocolSuccess<JsonMap>(:final value) => value,
        MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
      };

      expect(_decodeTheme(encoded).tokens, theme.tokens);
    });

    test('is deterministic', () {
      final first = dtcgToThemeDocument(_fixture());
      final second = dtcgToThemeDocument(_fixture());

      expect(first.themeDocument, second.themeDocument);
      expect(
        first.diagnostics.map((d) => d.toString()),
        second.diagnostics.map((d) => d.toString()),
      );
    });

    test(
      'reports unsupported and malformed tokens instead of dropping them',
      () {
        final result = dtcgToThemeDocument({
          'easing': {
            r'$type': 'cubicBezier',
            'standard': {
              r'$value': [0.4, 0, 0.2, 1],
            },
          },
          'flag': {
            'enabled': {r'$value': true},
          },
          'ghost': {
            r'$type': 'color',
            'alias': {r'$value': '{color.missing}'},
          },
          'inset-shadow': {
            r'$type': 'shadow',
            'sunken': {
              r'$value': {
                'color': '#00000033',
                'offsetX': {'value': 0, 'unit': 'px'},
                'offsetY': {'value': 2, 'unit': 'px'},
                'blur': {'value': 4, 'unit': 'px'},
                'spread': {'value': 0, 'unit': 'px'},
                'inset': true,
              },
            },
          },
          'rem-size': {
            r'$type': 'dimension',
            'body': {
              r'$value': {'value': 1, 'unit': 'rem'},
            },
          },
        });

        final paths = result.diagnostics.map((d) => d.path).toSet();
        expect(paths, {
          'easing.standard',
          'flag.enabled',
          'ghost.alias',
          'inset-shadow.sunken',
          'rem-size.body',
        });
        // Nothing partially converted.
        expect(result.themeDocument.keys.toSet(), {'v', 'type'});
      },
    );

    test('converts rem dimensions when remPixelRatio is provided', () {
      final result = dtcgToThemeDocument({
        'space': {
          r'$type': 'dimension',
          'body': {
            r'$value': {'value': 1.5, 'unit': 'rem'},
          },
        },
      }, options: const DtcgConversionOptions(remPixelRatio: 16));

      expect(result.diagnostics, isEmpty);
      final theme = _decodeTheme(result.themeDocument);
      expect(theme.tokens[const SpaceToken('space.body')], 24.0);
    });

    test('preserves alias structure in the emitted document', () {
      final result = dtcgToThemeDocument(_fixture());
      final colors = result.themeDocument['colors']! as Map<String, Object?>;
      final spaces = result.themeDocument['spaces']! as Map<String, Object?>;

      expect(colors['color.action'], {r'$token': 'color.brand.primary'});
      expect(spaces['space.gutter'], {r'$token': 'space.md', 'kind': 'space'});
    });

    test('normalizes Figma-style slash-separated names', () {
      final result = dtcgToThemeDocument({
        'color': {
          r'$type': 'color',
          'surface/raised': {r'$value': '#FFFFFF'},
        },
      });

      final theme = _decodeTheme(result.themeDocument);
      expect(
        theme.tokens[const ColorToken('color.surface.raised')],
        _rgb(0xFFFFFF),
      );
    });
  });
}

Color _rgb(int rgb) => Color(0xFF000000 | rgb);

MixProtocolTheme _decodeTheme(JsonMap document) {
  return switch (mixProtocol.decodeTheme(document)) {
    MixProtocolSuccess<MixProtocolTheme>(:final value) => value,
    MixProtocolFailure<MixProtocolTheme>(:final errors) => fail('$errors'),
  };
}

/// A DTCG 2025.10 document shaped like a Figma variable/style export.
Map<String, Object?> _fixture() {
  return {
    'color': {
      r'$type': 'color',
      'brand': {
        'primary': {
          r'$value': {
            'colorSpace': 'srgb',
            'components': [0.2, 0.4, 1],
          },
        },
        'secondary': {r'$value': '#101820'},
      },
      // DTCG hex carries alpha last; the protocol wants it first.
      'overlay': {r'$value': '#00000080'},
      'action': {r'$value': '{color.brand.primary}'},
    },
    'space': {
      r'$type': 'dimension',
      'sm': {
        r'$value': {'value': 8, 'unit': 'px'},
      },
      'md': {
        r'$value': {'value': 16, 'unit': 'px'},
      },
      'gutter': {r'$value': '{space.md}'},
    },
    'radius': {
      r'$type': 'dimension',
      'card': {
        r'$value': {'value': 12, 'unit': 'px'},
      },
    },
    'breakpoint': {
      r'$type': 'dimension',
      'md': {
        r'$value': {'value': 768, 'unit': 'px'},
      },
    },
    'opacity': {
      r'$type': 'number',
      'disabled': {r'$value': 0.4},
    },
    'weight': {
      r'$type': 'fontWeight',
      'bold': {r'$value': 'bold'},
      // Snaps to w600 with a diagnostic.
      'heading': {r'$value': 620},
    },
    'motion': {
      r'$type': 'duration',
      'fast': {
        r'$value': {'value': 150, 'unit': 'ms'},
      },
      'slow': {
        r'$value': {'value': 2, 'unit': 's'},
      },
    },
    'elevation': {
      r'$type': 'shadow',
      'raised': {
        r'$value': [
          {
            'color': '#00000033',
            'offsetX': {'value': 0, 'unit': 'px'},
            'offsetY': {'value': 2, 'unit': 'px'},
            'blur': {'value': 8, 'unit': 'px'},
            'spread': {'value': 1, 'unit': 'px'},
          },
          {
            'color': '#0000001A',
            'offsetX': {'value': 0, 'unit': 'px'},
            'offsetY': {'value': 1, 'unit': 'px'},
            'blur': {'value': 2, 'unit': 'px'},
            'spread': {'value': 0, 'unit': 'px'},
          },
        ],
      },
    },
    'border': {
      r'$type': 'border',
      'focus': {
        r'$value': {
          'color': '#008577',
          'width': {'value': 2, 'unit': 'px'},
          'style': 'solid',
        },
      },
    },
    'type': {
      r'$type': 'typography',
      'body': {
        r'$value': {
          'fontFamily': ['Inter', 'Roboto'],
          'fontSize': {'value': 14, 'unit': 'px'},
          'fontWeight': 400,
          'letterSpacing': {'value': 0.2, 'unit': 'px'},
          'lineHeight': 1.4,
        },
      },
    },
  };
}
