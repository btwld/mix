import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyleUtility', () {
    late TextStyleUtility<MockStyle<Prop<TextStyle>>> util;

    setUp(() {
      util = TextStyleUtility<MockStyle<Prop<TextStyle>>>(
        (prop) => MockStyle(prop),
      );
    });

    group('utility properties', () {
      test('has color utility', () {
        expect(util.color, isA<ColorUtility>());
      });

      test('has fontWeight utility', () {
        expect(util.fontWeight, isA<MixUtility>());
      });

      test('has fontStyle utility', () {
        expect(util.fontStyle, isA<MixUtility>());
      });

      test('has decoration utility', () {
        expect(util.decoration, isA<MixUtility>());
      });

      test('has fontSize utility', () {
        expect(util.fontSize, isA<Function>());
      });

      test('has backgroundColor utility', () {
        expect(util.backgroundColor, isA<ColorUtility>());
      });

      test('has decorationColor utility', () {
        expect(util.decorationColor, isA<ColorUtility>());
      });

      test('has decorationStyle utility', () {
        expect(util.decorationStyle, isA<MixUtility>());
      });

      test('has textBaseline utility', () {
        expect(util.textBaseline, isA<MixUtility>());
      });

      test('has fontFamily utility', () {
        expect(util.fontFamily, isA<Function>());
      });

      test('has inherit utility', () {
        expect(util.inherit, isA<Function>());
      });
    });

    group('property setters', () {
      test('color sets text color', () {
        final result = util.color(Colors.red);

        expect(result.value, resolvesTo(const TextStyle(color: Colors.red)));
      });

      test('fontWeight sets font weight', () {
        final result = util.fontWeight(FontWeight.bold);

        expect(
          result.value,
          resolvesTo(const TextStyle(fontWeight: FontWeight.bold)),
        );
      });

      test('fontStyle sets font style', () {
        final result = util.fontStyle(FontStyle.italic);

        expect(
          result.value,
          resolvesTo(const TextStyle(fontStyle: FontStyle.italic)),
        );
      });

      test('decoration sets text decoration', () {
        final result = util.decoration(TextDecoration.underline);

        expect(
          result.value,
          resolvesTo(const TextStyle(decoration: TextDecoration.underline)),
        );
      });

      test('fontSize sets font size', () {
        final result = util.fontSize(16.0);

        expect(result.value, resolvesTo(const TextStyle(fontSize: 16.0)));
      });

      test('backgroundColor sets background color', () {
        final result = util.backgroundColor(Colors.yellow);

        expect(
          result.value,
          resolvesTo(const TextStyle(backgroundColor: Colors.yellow)),
        );
      });

      test('decorationColor sets decoration color', () {
        final result = util.decorationColor(Colors.blue);

        expect(
          result.value,
          resolvesTo(const TextStyle(decorationColor: Colors.blue)),
        );
      });

      test('decorationStyle sets decoration style', () {
        final result = util.decorationStyle(TextDecorationStyle.dashed);

        expect(
          result.value,
          resolvesTo(
            const TextStyle(decorationStyle: TextDecorationStyle.dashed),
          ),
        );
      });

      test('textBaseline sets text baseline', () {
        final result = util.textBaseline(TextBaseline.ideographic);

        expect(
          result.value,
          resolvesTo(const TextStyle(textBaseline: TextBaseline.ideographic)),
        );
      });

      test('fontFamily sets font family', () {
        final result = util.fontFamily('Roboto');

        expect(result.value, resolvesTo(const TextStyle(fontFamily: 'Roboto')));
      });

      test('inherit sets inherit property', () {
        final result = util.inherit(false);

        expect(result.value, resolvesTo(const TextStyle(inherit: false)));
      });
    });

    group('convenience methods', () {
      test('height sets line height', () {
        final result = util.height(1.5);

        expect(result.value, resolvesTo(const TextStyle(height: 1.5)));
      });

      test('wordSpacing sets word spacing', () {
        final result = util.wordSpacing(2.0);

        expect(result.value, resolvesTo(const TextStyle(wordSpacing: 2.0)));
      });

      test('letterSpacing sets letter spacing', () {
        final result = util.letterSpacing(1.2);

        expect(result.value, resolvesTo(const TextStyle(letterSpacing: 1.2)));
      });

      test('italic sets font style to italic', () {
        final result = util.italic();

        expect(
          result.value,
          resolvesTo(const TextStyle(fontStyle: FontStyle.italic)),
        );
      });

      test('bold sets font weight to bold', () {
        final result = util.bold();

        expect(
          result.value,
          resolvesTo(const TextStyle(fontWeight: FontWeight.bold)),
        );
      });

      test('decorationThickness sets decoration thickness', () {
        final result = util.decorationThickness(2.5);

        expect(
          result.value,
          resolvesTo(const TextStyle(decorationThickness: 2.5)),
        );
      });

      test('debugLabel sets debug label', () {
        final result = util.debugLabel('test-label');

        expect(
          result.value,
          resolvesTo(const TextStyle(debugLabel: 'test-label')),
        );
      });

      test('fontFamilyFallback sets font family fallback', () {
        final fallbacks = ['Arial', 'sans-serif'];
        final result = util.fontFamilyFallback(fallbacks);

        expect(
          result.value,
          resolvesTo(TextStyle(fontFamilyFallback: fallbacks)),
        );
      });
    });

    group('advanced properties', () {
      test('shadows sets text shadows', () {
        const shadows = [
          Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2),
          Shadow(color: Colors.grey, offset: Offset(2, 2), blurRadius: 4),
        ];
        final result = util.shadows(shadows);

        expect(result.value, resolvesTo(const TextStyle(shadows: shadows)));
      });

      test('fontFeatures sets font features', () {
        const features = [
          FontFeature.enable('smcp'),
          FontFeature.enable('c2sc'),
        ];
        final result = util.fontFeatures(features);

        expect(
          result.value,
          resolvesTo(const TextStyle(fontFeatures: features)),
        );
      });

      test('fontVariations sets font variations', () {
        const variations = [
          FontVariation('wght', 400),
          FontVariation('wdth', 100),
        ];
        final result = util.fontVariations(variations);

        expect(
          result.value,
          resolvesTo(const TextStyle(fontVariations: variations)),
        );
      });

      test('fontVariation sets single font variation', () {
        const variation = FontVariation('wght', 600);
        final result = util.fontVariation(variation);

        expect(
          result.value,
          resolvesTo(const TextStyle(fontVariations: [variation])),
        );
      });

      test('foreground sets foreground paint', () {
        final paint = Paint()..color = const Color(0xFFFF0000);
        final result = util.foreground(paint);

        expect(result.value, resolvesTo(TextStyle(foreground: paint)));
      });

      test('background sets background paint', () {
        const expectedColor = Color(0xFF2196F3);
        final paint = Paint()..color = expectedColor;
        final result = util.background(paint);

        expect(result.value, resolvesTo(TextStyle(background: paint)));
      });
    });

    group('only method', () {
      test('sets all basic properties', () {
        final result = util(
          color: Colors.red,
          backgroundColor: Colors.yellow,
          fontFamily: 'Arial',
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.0,
          wordSpacing: 2.0,
          height: 1.4,
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue,
          decorationStyle: TextDecorationStyle.solid,
          decorationThickness: 1.5,
          textBaseline: TextBaseline.alphabetic,
          inherit: false,
        );

        expect(
          result.value,
          resolvesTo(
            const TextStyle(
              color: Colors.red,
              backgroundColor: Colors.yellow,
              fontFamily: 'Arial',
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              letterSpacing: 1.0,
              wordSpacing: 2.0,
              height: 1.4,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue,
              decorationStyle: TextDecorationStyle.solid,
              decorationThickness: 1.5,
              textBaseline: TextBaseline.alphabetic,
              inherit: false,
            ),
          ),
        );
      });

      test('sets partial properties', () {
        final result = util(
          fontFamily: 'Georgia',
          fontSize: 14.0,
          color: Colors.green,
        );

        expect(
          result.value,
          resolvesTo(
            const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 14.0,
              color: Colors.green,
            ),
          ),
        );
      });

      test('handles null values', () {
        final result = util();

        expect(result.value, resolvesTo(const TextStyle()));
      });

      test('sets advanced properties', () {
        const shadows = [
          Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2),
        ];
        const fontFeatures = [FontFeature.enable('liga')];
        const fontVariations = [FontVariation('wght', 500)];
        final fallbacks = ['Helvetica', 'sans-serif'];

        final result = util(
          shadows: shadows.map(ShadowMix.value).toList(),
          fontFeatures: fontFeatures,
          fontVariations: fontVariations,
          fontFamilyFallback: fallbacks,
          debugLabel: 'test-style',
        );

        expect(
          result.value,
          resolvesTo(
            TextStyle(
              shadows: shadows,
              fontFeatures: fontFeatures,
              fontVariations: fontVariations,
              fontFamilyFallback: fallbacks,
              debugLabel: 'test-style',
            ),
          ),
        );
      });

      test('sets paint properties', () {
        final foregroundPaint = Paint()..color = Colors.red;
        final backgroundPaint = Paint()..color = Colors.blue;

        final result = util(
          foreground: foregroundPaint,
          background: backgroundPaint,
        );

        expect(
          result.value,
          resolvesTo(
            TextStyle(foreground: foregroundPaint, background: backgroundPaint),
          ),
        );
      });
    });

    group('call method', () {
      test('delegates to only method with all properties', () {
        final shadows = [
          Shadow(color: Colors.grey, offset: Offset(0, 1), blurRadius: 3),
        ];
        const fontFeatures = [FontFeature.enable('kern')];
        const fontVariations = [FontVariation('slnt', -10)];

        final result = util(
          color: Colors.purple,
          backgroundColor: Colors.pink,
          fontFamily: 'Times New Roman',
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.5,
          wordSpacing: 1.5,
          height: 1.8,
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.orange,
          decorationStyle: TextDecorationStyle.dotted,
          decorationThickness: 2.0,
          textBaseline: TextBaseline.ideographic,
          shadows: shadows.map(ShadowMix.value).toList(),
          fontFeatures: fontFeatures,
          fontVariations: fontVariations,
          debugLabel: 'call-test',
          inherit: false,
        );

        expect(
          result.value,
          resolvesTo(
            TextStyle(
              color: Colors.purple,
              backgroundColor: Colors.pink,
              fontFamily: 'Times New Roman',
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
              letterSpacing: 0.5,
              wordSpacing: 1.5,
              height: 1.8,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.orange,
              decorationStyle: TextDecorationStyle.dotted,
              decorationThickness: 2.0,
              textBaseline: TextBaseline.ideographic,
              shadows: shadows,
              fontFeatures: fontFeatures,
              fontVariations: fontVariations,
              debugLabel: 'call-test',
              inherit: false,
            ),
          ),
        );
      });

      test('handles partial parameters', () {
        final result = util(
          fontWeight: FontWeight.w800,
          fontSize: 22.0,
          color: Colors.teal,
        );

        expect(
          result.value,
          resolvesTo(
            const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22.0,
              color: Colors.teal,
            ),
          ),
        );
      });

      test('handles empty parameters', () {
        final result = util();

        expect(result.value, resolvesTo(const TextStyle()));
      });
    });

    group('as method', () {
      test('accepts TextStyle with all properties', () {
        const shadows = [
          Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 4),
        ];
        const fontFeatures = [FontFeature.enable('smcp')];
        const fontVariations = [FontVariation('wght', 700)];

        const textStyle = TextStyle(
          color: Colors.indigo,
          backgroundColor: Colors.amber,
          fontFamily: 'Courier New',
          fontFamilyFallback: ['Courier', 'monospace'],
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.1,
          wordSpacing: 2.2,
          textBaseline: TextBaseline.alphabetic,
          height: 1.3,
          decoration: TextDecoration.overline,
          decorationColor: Colors.cyan,
          decorationStyle: TextDecorationStyle.wavy,
          decorationThickness: 1.8,
          shadows: shadows,
          fontFeatures: fontFeatures,
          fontVariations: fontVariations,
          debugLabel: 'as-test',
          inherit: false,
        );

        final result = util.as(textStyle);

        expect(result.value, resolvesTo(textStyle));
      });

      test('accepts minimal TextStyle', () {
        const textStyle = TextStyle();
        final result = util.as(textStyle);

        expect(result.value, resolvesTo(textStyle));
      });

      test('accepts TextStyle with paint properties', () {
        final foregroundPaint = Paint()..color = Colors.red;
        final backgroundPaint = Paint()..color = Colors.blue;

        final textStyle = TextStyle(
          foreground: foregroundPaint,
          background: backgroundPaint,
        );

        final result = util.as(textStyle);

        expect(result.value, resolvesTo(textStyle));
      });
    });

    group('font weight variations', () {
      test('handles all FontWeight values', () {
        final fontWeights = [
          FontWeight.w100,
          FontWeight.w200,
          FontWeight.w300,
          FontWeight.w400,
          FontWeight.w500,
          FontWeight.w600,
          FontWeight.w700,
          FontWeight.w800,
          FontWeight.w900,
        ];

        for (final weight in fontWeights) {
          final result = util.fontWeight(weight);
          expect(result.value, resolvesTo(TextStyle(fontWeight: weight)));
        }
      });

      test('handles named FontWeight values', () {
        final result1 = util.fontWeight(FontWeight.normal);
        final result2 = util.fontWeight(FontWeight.bold);

        expect(
          result1.value,
          resolvesTo(const TextStyle(fontWeight: FontWeight.w400)),
        );
        expect(
          result2.value,
          resolvesTo(const TextStyle(fontWeight: FontWeight.w700)),
        );
      });
    });

    group('text decoration variations', () {
      test('handles all TextDecoration values', () {
        final decorations = [
          TextDecoration.none,
          TextDecoration.underline,
          TextDecoration.overline,
          TextDecoration.lineThrough,
        ];

        for (final decoration in decorations) {
          final result = util.decoration(decoration);
          expect(result.value, resolvesTo(TextStyle(decoration: decoration)));
        }
      });

      test('handles combined decorations', () {
        final combined = TextDecoration.combine([
          TextDecoration.underline,
          TextDecoration.overline,
        ]);

        final result = util.decoration(combined);

        expect(result.value, resolvesTo(TextStyle(decoration: combined)));
      });
    });

    group('text decoration style variations', () {
      test('handles all TextDecorationStyle values', () {
        final decorationStyles = [
          TextDecorationStyle.solid,
          TextDecorationStyle.double,
          TextDecorationStyle.dotted,
          TextDecorationStyle.dashed,
          TextDecorationStyle.wavy,
        ];

        for (final style in decorationStyles) {
          final result = util.decorationStyle(style);
          expect(result.value, resolvesTo(TextStyle(decorationStyle: style)));
        }
      });
    });

    group('text baseline variations', () {
      test('handles all TextBaseline values', () {
        final baselines = [TextBaseline.alphabetic, TextBaseline.ideographic];

        for (final baseline in baselines) {
          final result = util.textBaseline(baseline);
          expect(result.value, resolvesTo(TextStyle(textBaseline: baseline)));
        }
      });
    });

    group('color utility integration', () {
      test('color utility supports directives', () {
        final result = util.color.withOpacity(0.8);

        expect(result.value, isA<Prop<TextStyle>>());
        // Color directives should be applied during resolution
      });

      test('color utility supports material colors', () {
        final result = util.color.red();

        expect(result.value, resolvesTo(const TextStyle(color: Colors.red)));
      });

      test('backgroundColor utility supports directives', () {
        final result = util.backgroundColor.withAlpha(128);

        expect(result.value, isA<Prop<TextStyle>>());
      });

      test('decorationColor utility supports tokens', () {
        const colorToken = MixToken<Color>('decorationColor');
        final context = MockBuildContext(
          tokens: {colorToken: Colors.orange},
        );

        final result = util.decorationColor.token(colorToken);

        expect(
          result.value,
          resolvesTo(
            const TextStyle(decorationColor: Colors.orange),
            context: context,
          ),
        );
      });
    });

    group('edge cases and validation', () {
      test('handles extremely small font size', () {
        final result = util.fontSize(0.1);

        expect(result.value, resolvesTo(const TextStyle(fontSize: 0.1)));
      });

      test('handles large font size', () {
        final result = util.fontSize(200.0);

        expect(result.value, resolvesTo(const TextStyle(fontSize: 200.0)));
      });

      test('handles negative spacing values', () {
        final result = util.letterSpacing(-1.0);

        expect(result.value, resolvesTo(const TextStyle(letterSpacing: -1.0)));
      });

      test('handles zero spacing values', () {
        final result = util.wordSpacing(0.0);

        expect(result.value, resolvesTo(const TextStyle(wordSpacing: 0.0)));
      });

      test('handles extremely small height', () {
        final result = util.height(0.1);

        expect(result.value, resolvesTo(const TextStyle(height: 0.1)));
      });

      test('handles large height', () {
        final result = util.height(5.0);

        expect(result.value, resolvesTo(const TextStyle(height: 5.0)));
      });

      test('handles empty font family fallback list', () {
        final result = util.fontFamilyFallback([]);

        expect(
          result.value,
          resolvesTo(const TextStyle(fontFamilyFallback: [])),
        );
      });

      test('handles empty shadow list', () {
        final result = util.shadows([]);

        expect(result.value, resolvesTo(const TextStyle(shadows: [])));
      });

      test('handles empty font features list', () {
        final result = util.fontFeatures([]);

        expect(result.value, resolvesTo(const TextStyle(fontFeatures: [])));
      });

      test('handles empty font variations list', () {
        final result = util.fontVariations([]);

        expect(result.value, resolvesTo(const TextStyle(fontVariations: [])));
      });
    });
  });

  group('TextStyle integration tests', () {
    test('utility works with Mix context', () {
      final util = TextStyleUtility<MockStyle<Prop<TextStyle>>>(
        (prop) => MockStyle(prop),
      );

      final result = util(
        color: Colors.blue,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      );

      expect(result.value, isA<Prop<TextStyle>>());

      expect(
        result.value,
        resolvesTo(
          const TextStyle(
            color: Colors.blue,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
      );
    });

    test('utility properties work independently', () {
      final util = TextStyleUtility<MockStyle<Prop<TextStyle>>>(
        (prop) => MockStyle(prop),
      );

      final colorResult = util.color(Colors.red);
      final sizeResult = util.fontSize(18.0);
      final weightResult = util.fontWeight(FontWeight.bold);
      final familyResult = util.fontFamily('Arial');

      expect(colorResult.value, resolvesTo(const TextStyle(color: Colors.red)));
      expect(sizeResult.value, resolvesTo(const TextStyle(fontSize: 18.0)));
      expect(
        weightResult.value,
        resolvesTo(const TextStyle(fontWeight: FontWeight.bold)),
      );
      expect(
        familyResult.value,
        resolvesTo(const TextStyle(fontFamily: 'Arial')),
      );
    });

    test('convenience methods work correctly', () {
      final util = TextStyleUtility<MockStyle<Prop<TextStyle>>>(
        (prop) => MockStyle(prop),
      );

      final boldResult = util.bold();
      final italicResult = util.italic();

      expect(
        boldResult.value,
        resolvesTo(const TextStyle(fontWeight: FontWeight.bold)),
      );
      expect(
        italicResult.value,
        resolvesTo(const TextStyle(fontStyle: FontStyle.italic)),
      );
    });

    test('preserves Flutter TextStyle semantics', () {
      final util = TextStyleUtility<MockStyle<Prop<TextStyle>>>(
        (prop) => MockStyle(prop),
      );

      const flutterStyle = TextStyle(
        color: Colors.green,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
      );

      final mixResult = util.as(flutterStyle);

      expect(mixResult.value, resolvesTo(flutterStyle));
    });
  });
}
