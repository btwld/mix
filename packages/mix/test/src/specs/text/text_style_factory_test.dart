import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyler factory constructors', () {
    group('dot-shorthand resolution', () {
      test('factory resolves via dot-shorthand typed assignment', () {
        TextStyler styler = TextStyler.color(Colors.red);
        expect(styler.$style, isNotNull);
      });

      test('chaining after factory constructor works', () {
        final styler = TextStyler.color(
          Colors.red,
        ).fontSize(16).fontWeight(.bold);
        expect(styler.$style, isNotNull);
      });
    });

    group('factory matches instance method', () {
      // Direct constructor param factories
      test('overflow', () {
        expect(
          TextStyler.overflow(.ellipsis),
          equals(TextStyler(overflow: .ellipsis)),
        );
      });

      test('textAlign', () {
        expect(
          TextStyler.textAlign(.center),
          equals(TextStyler(textAlign: .center)),
        );
      });

      test('maxLines', () {
        expect(TextStyler.maxLines(3), equals(TextStyler(maxLines: 3)));
      });

      test('softWrap', () {
        expect(TextStyler.softWrap(false), equals(TextStyler(softWrap: false)));
      });

      test('textDirection', () {
        expect(
          TextStyler.textDirection(.rtl),
          equals(TextStyler(textDirection: .rtl)),
        );
      });

      test('style', () {
        final mix = TextStyleMix.color(Colors.red);
        expect(TextStyler.style(mix), equals(TextStyler(style: mix)));
      });

      // TextStyleMixin convenience factories
      test('color', () {
        expect(
          TextStyler.color(Colors.blue),
          equals(TextStyler().color(Colors.blue)),
        );
      });

      test('fontSize', () {
        expect(TextStyler.fontSize(24), equals(TextStyler().fontSize(24)));
      });

      test('fontWeight', () {
        expect(
          TextStyler.fontWeight(.bold),
          equals(TextStyler().fontWeight(.bold)),
        );
      });

      test('fontStyle', () {
        expect(
          TextStyler.fontStyle(.italic),
          equals(TextStyler().fontStyle(.italic)),
        );
      });

      test('letterSpacing', () {
        expect(
          TextStyler.letterSpacing(1.5),
          equals(TextStyler().letterSpacing(1.5)),
        );
      });

      test('wordSpacing', () {
        expect(
          TextStyler.wordSpacing(2.0),
          equals(TextStyler().wordSpacing(2.0)),
        );
      });

      test('height', () {
        expect(TextStyler.height(1.5), equals(TextStyler().height(1.5)));
      });

      test('fontFamily', () {
        expect(
          TextStyler.fontFamily('Roboto'),
          equals(TextStyler().fontFamily('Roboto')),
        );
      });

      test('decoration', () {
        expect(
          TextStyler.decoration(.underline),
          equals(TextStyler().decoration(.underline)),
        );
      });

      // Direct constructor param factories
      test('strutStyle', () {
        final mix = StrutStyleMix();
        expect(TextStyler.strutStyle(mix), equals(TextStyler(strutStyle: mix)));
      });

      test('textWidthBasis', () {
        expect(
          TextStyler.textWidthBasis(.longestLine),
          equals(TextStyler(textWidthBasis: .longestLine)),
        );
      });

      test('textScaler', () {
        expect(
          TextStyler.textScaler(const .linear(2.0)),
          equals(TextStyler(textScaler: const .linear(2.0))),
        );
      });

      test('textHeightBehavior', () {
        final mix = TextHeightBehaviorMix();
        expect(
          TextStyler.textHeightBehavior(mix),
          equals(TextStyler(textHeightBehavior: mix)),
        );
      });

      test('selectionColor', () {
        expect(
          TextStyler.selectionColor(Colors.blue),
          equals(TextStyler(selectionColor: Colors.blue)),
        );
      });

      test('locale', () {
        expect(
          TextStyler.locale(const Locale('en')),
          equals(TextStyler(locale: const Locale('en'))),
        );
      });

      // TextStyleMixin convenience factories
      test('backgroundColor', () {
        expect(
          TextStyler.backgroundColor(Colors.red),
          equals(TextStyler().backgroundColor(Colors.red)),
        );
      });

      test('textBaseline', () {
        expect(
          TextStyler.textBaseline(.alphabetic),
          equals(TextStyler().textBaseline(.alphabetic)),
        );
      });

      test('decorationColor', () {
        expect(
          TextStyler.decorationColor(Colors.red),
          equals(TextStyler().decorationColor(Colors.red)),
        );
      });

      test('decorationStyle', () {
        expect(
          TextStyler.decorationStyle(.dashed),
          equals(TextStyler().decorationStyle(.dashed)),
        );
      });

      test('decorationThickness', () {
        expect(
          TextStyler.decorationThickness(2.0),
          equals(TextStyler().decorationThickness(2.0)),
        );
      });

      test('fontFamilyFallback', () {
        expect(
          TextStyler.fontFamilyFallback(['Arial', 'Helvetica']),
          equals(TextStyler().fontFamilyFallback(['Arial', 'Helvetica'])),
        );
      });

      test('shadows', () {
        final s = [ShadowMix(color: Colors.black, blurRadius: 4)];
        expect(TextStyler.shadows(s), equals(TextStyler().shadows(s)));
      });

      test('shadow', () {
        final s = ShadowMix(color: Colors.black, blurRadius: 4);
        expect(TextStyler.shadow(s), equals(TextStyler().shadow(s)));
      });

      test('fontFeatures', () {
        expect(
          TextStyler.fontFeatures([const FontFeature.enable('smcp')]),
          equals(TextStyler().fontFeatures([const FontFeature.enable('smcp')])),
        );
      });

      test('fontVariations', () {
        expect(
          TextStyler.fontVariations([const FontVariation('wght', 400)]),
          equals(
            TextStyler().fontVariations([const FontVariation('wght', 400)]),
          ),
        );
      });

      test('foreground', () {
        final paint = Paint()..color = Colors.red;
        expect(
          TextStyler.foreground(paint),
          equals(TextStyler().foreground(paint)),
        );
      });

      test('background', () {
        final paint = Paint()..color = Colors.blue;
        expect(
          TextStyler.background(paint),
          equals(TextStyler().background(paint)),
        );
      });

      // Text directive factories
      test('uppercase', () {
        expect(TextStyler.uppercase(), equals(TextStyler().uppercase()));
      });

      test('lowercase', () {
        expect(TextStyler.lowercase(), equals(TextStyler().lowercase()));
      });

      test('capitalize', () {
        expect(TextStyler.capitalize(), equals(TextStyler().capitalize()));
      });

      test('titlecase', () {
        expect(TextStyler.titlecase(), equals(TextStyler().titlecase()));
      });

      test('sentencecase', () {
        expect(TextStyler.sentencecase(), equals(TextStyler().sentencecase()));
      });
    });

    group('resolved values', () {
      test('color resolves correctly', () {
        final textStyle = TextStyler.color(
          Colors.blue,
        ).$style!.resolveProp(MockBuildContext());
        expect(textStyle, isA<TextStyle>());
        expect(textStyle.color, Colors.blue);
      });

      test('fontSize resolves correctly', () {
        final textStyle = TextStyler.fontSize(
          24,
        ).$style!.resolveProp(MockBuildContext());
        expect(textStyle, isA<TextStyle>());
        expect(textStyle.fontSize, 24);
      });
    });
  });
}
