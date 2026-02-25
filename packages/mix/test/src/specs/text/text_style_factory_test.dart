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
        ).fontSize(16).fontWeight(FontWeight.bold);
        expect(styler.$style, isNotNull);
      });
    });

    group('factory matches instance method', () {
      // Direct constructor param factories
      test('overflow', () {
        expect(
          TextStyler.overflow(TextOverflow.ellipsis),
          equals(TextStyler(overflow: TextOverflow.ellipsis)),
        );
      });

      test('textAlign', () {
        expect(
          TextStyler.textAlign(TextAlign.center),
          equals(TextStyler(textAlign: TextAlign.center)),
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
          TextStyler.textDirection(TextDirection.rtl),
          equals(TextStyler(textDirection: TextDirection.rtl)),
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
          TextStyler.fontWeight(FontWeight.bold),
          equals(TextStyler().fontWeight(FontWeight.bold)),
        );
      });

      test('fontStyle', () {
        expect(
          TextStyler.fontStyle(FontStyle.italic),
          equals(TextStyler().fontStyle(FontStyle.italic)),
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
          TextStyler.decoration(TextDecoration.underline),
          equals(TextStyler().decoration(TextDecoration.underline)),
        );
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
