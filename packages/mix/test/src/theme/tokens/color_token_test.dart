import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ColorToken Tests', () {
    // Constructor Test
    test('Constructor assigns name correctly', () {
      const colorToken = ColorToken('testName');
      expect(colorToken.name, 'testName');
      final ColorRef colorRef = colorToken();
      expect(colorRef.token, colorToken);
    });

    // Equality Operator Test
    test('Equality operator works correctly', () {
      const colorToken1 = ColorToken('testName');
      const colorToken2 = ColorToken('testName');

      const colorToken3 = ColorToken('differentName');

      expect(colorToken1 == colorToken2, isTrue);

      expect(colorToken1 == colorToken3, isFalse);
      expect(colorToken1 == Object(), isFalse);
    });

    // HashCode Test
    test('hashCode is consistent with name', () {
      const colorToken1 = ColorToken('testName');
      const colorToken2 = ColorToken('testName');
      const colorToken3 = ColorToken('differentName');

      expect(colorToken1.hashCode, colorToken2.hashCode);
      expect(colorToken1.hashCode, isNot(colorToken3.hashCode));
    });

    testWidgets('Test it resolves correctly', (tester) async {
      const redcolorToken = ColorToken('red');
      const greencolorToken = ColorToken('green');
      const bluecolorToken = ColorToken('blue');
      final theme = MixThemeData(
        colors: {
          greencolorToken: Colors.green,
          redcolorToken: Colors.redAccent,
          bluecolorToken: Colors.blueAccent,
        },
      );

      await tester.pumpWidget(createWithMixTheme(theme));

      final context = tester.element(find.byType(Container));

      final mixData = MixData.create(context, const Style.empty());

      expect(mixData.tokens.colorToken(redcolorToken), Colors.redAccent);
      expect(mixData.tokens.colorToken(greencolorToken), Colors.green);
      expect(mixData.tokens.colorToken(bluecolorToken), Colors.blueAccent);
    });
  });

  group('ColorResolver Tests', () {
    testWidgets('ColorResolver resolves color dynamically', (tester) async {
      const colorToken = ColorToken('dynamicColor');
      final theme = MixThemeData(
        colors: {
          colorToken: ColorResolver((context) {
            final brightness = MediaQuery.of(context).platformBrightness;
            return brightness == Brightness.dark ? Colors.white : Colors.black;
          }),
        },
      );
      // set brightness to dark on the next pump widget
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: MixTheme(
            data: theme,
            child: Container(),
          ),
        ),
      );

      final context = tester.element(find.byType(Container));
      final mixData = MixData.create(context, const Style.empty());

      expect(mixData.tokens.colorToken(colorToken), Colors.white);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.light),
          child: MixTheme(
            data: theme,
            child: Container(),
          ),
        ),
      );
      expect(mixData.tokens.colorToken(colorToken), Colors.black);
    });

    testWidgets('ColorResolver returns transparent color when null',
        (tester) async {
      const colorToken = ColorToken('nullColor');
      final theme = MixThemeData(
        colors: {
          colorToken: ColorResolver((_) => Colors.transparent),
        },
      );

      await tester.pumpWidget(createWithMixTheme(theme));

      final context = tester.element(find.byType(Container));
      final mixData = MixData.create(context, const Style.empty());

      expect(mixData.tokens.colorToken(colorToken), Colors.transparent);
    });
  });

  group('ColorRef Tests', () {
    test('ColorRef equality works correctly', () {
      const colorToken = ColorToken('testColor');
      const colorRef1 = ColorRef(colorToken);
      const colorRef2 = ColorRef(colorToken);

      expect(colorRef1 == colorRef2, isTrue);
      expect(colorRef1 == Object(), isFalse);
    });

    test('ColorRef hashCode is consistent with token', () {
      const colorToken = ColorToken('testColor');
      const colorRef1 = ColorRef(colorToken);
      const colorRef2 = ColorRef(colorToken);

      expect(colorRef1.hashCode, colorRef2.hashCode);
    });
  });

  group('ColorSwatchToken Tests', () {
    test('Constructor assigns name and swatch correctly', () {
      const swatchToken =
          ColorSwatchToken<int>('testSwatch', {100: 'color100', 200: 'color200'});
      expect(swatchToken.name, 'testSwatch');
      expect(swatchToken.swatch, {100: 'color100', 200: 'color200'});
    });

    test('[] operator returns ColorTokenOfSwatch', () {
      const swatchToken =
          ColorSwatchToken<int>('testSwatch', {100: 'color100', 200: 'color200'});
      final tokenOfSwatch = swatchToken[100];
      expect(tokenOfSwatch, isA<ColorTokenOfSwatch>());
      expect(tokenOfSwatch.name, 'color100');
      expect(tokenOfSwatch.index, 100);
    });

    test('[] operator throws assertion error for non-existent index', () {
      const swatchToken = ColorSwatchToken('testSwatch', {100: 'color100'});
      expect(() => swatchToken[200], throwsAssertionError);
    });

    test('Equality and hashCode', () {
      const swatchToken1 = ColorSwatchToken('testSwatch', {100: 'color100'});
      const swatchToken2 = ColorSwatchToken('testSwatch', {100: 'color100'});
      const swatchToken3 =
          ColorSwatchToken('differentSwatch', {100: 'color100'});

      expect(swatchToken1, equals(swatchToken2));
      expect(swatchToken1.hashCode, equals(swatchToken2.hashCode));
      expect(swatchToken1, isNot(equals(swatchToken3)));
    });

    test('scale method creates ColorSwatchToken with correct swatch', () {
      final swatchToken = ColorSwatchToken.scale('testSwatch', 3);
      expect(swatchToken.name, 'testSwatch');
      expect(swatchToken.swatch,
          {1: 'testSwatch-1', 2: 'testSwatch-2', 3: 'testSwatch-3'});
    });

    testWidgets('resolve method returns correct ColorSwatch', (tester) async {
      const swatchToken =
          ColorSwatchToken<int>('testSwatch', {100: 'color100', 200: 'color200'});
      final theme = MixThemeData(
        colors: {
          swatchToken:
              const ColorSwatch(100, {100: Colors.red, 200: Colors.blue}),
        },
      );

      await tester.pumpWidget(createWithMixTheme(theme));

      final context = tester.element(find.byType(Container));
      final resolvedSwatch = swatchToken.resolve(context);

      expect(resolvedSwatch, isA<ColorSwatch>());
      expect(resolvedSwatch[100], Colors.red);
      expect(resolvedSwatch[200], Colors.blue);
    });
  });

  group('ColorTokenOfSwatch Tests', () {
    test('Constructor assigns name, swatchToken, and index correctly', () {
      const swatchToken =
          ColorSwatchToken<int>('testSwatch', {100: 'color100', 200: 'color200'});
      const tokenOfSwatch = ColorTokenOfSwatch('color100', swatchToken, 100);
      expect(tokenOfSwatch.name, 'color100');
      expect(tokenOfSwatch.swatchToken, swatchToken);
      expect(tokenOfSwatch.index, 100);
    });

    testWidgets('resolve method returns correct Color', (tester) async {
      const swatchToken =
          ColorSwatchToken<int>('testSwatch', {100: 'color100', 200: 'color200'});
      const tokenOfSwatch = ColorTokenOfSwatch('color100', swatchToken, 100);
      final theme = MixThemeData(
        colors: {
          swatchToken:
              const ColorSwatch(100, {100: Colors.red, 200: Colors.blue}),
        },
      );

      await tester.pumpWidget(createWithMixTheme(theme));

      final context = tester.element(find.byType(Container));
      final resolvedColor = tokenOfSwatch.resolve(context);

      expect(resolvedColor, Colors.red);
    });

    test('call() method returns ColorRef with correct token', () {
      const swatchToken = ColorSwatchToken('testSwatch', {100: 'color100'});
      const tokenOfSwatch = ColorTokenOfSwatch('color100', swatchToken, 100);
      expect(tokenOfSwatch(), equals(const ColorRef(tokenOfSwatch)));
    });

    test('Equality and hashCode', () {
      const swatchToken = ColorSwatchToken('testSwatch', {100: 'color100'});
      const tokenOfSwatch1 = ColorTokenOfSwatch('color100', swatchToken, 100);
      const tokenOfSwatch2 = ColorTokenOfSwatch('color100', swatchToken, 100);
      const tokenOfSwatch3 = ColorTokenOfSwatch('color200', swatchToken, 200);

      expect(tokenOfSwatch1, equals(tokenOfSwatch2));
      expect(tokenOfSwatch1.hashCode, equals(tokenOfSwatch2.hashCode));
      expect(tokenOfSwatch1, isNot(equals(tokenOfSwatch3)));
    });
  });
}
