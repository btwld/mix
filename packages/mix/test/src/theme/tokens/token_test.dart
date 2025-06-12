import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Token<T>', () {
    test('creates token with correct name and type', () {
      const colorToken = Token<Color>('primary');
      const spaceToken = Token<double>('large');
      const textToken = Token<TextStyle>('heading');
      
      expect(colorToken.name, 'primary');
      expect(spaceToken.name, 'large');
      expect(textToken.name, 'heading');
      
      expect(colorToken.toString(), 'Token<Color>(primary)');
      expect(spaceToken.toString(), 'Token<double>(large)');
      expect(textToken.toString(), 'Token<TextStyle>(heading)');
    });

    test('equality works correctly', () {
      const token1 = Token<Color>('primary');
      const token2 = Token<Color>('primary');
      const token3 = Token<Color>('secondary');
      const token4 = Token<double>('primary'); // Different type
      
      expect(token1, equals(token2));
      expect(token1, isNot(equals(token3)));
      expect(token1, isNot(equals(token4)));
      expect(token1 == token2, isTrue);
      expect(identical(token1, token2), isTrue); // const constructors
    });

    test('hashCode is consistent', () {
      const token1 = Token<Color>('primary');
      const token2 = Token<Color>('primary');
      
      expect(token1.hashCode, equals(token2.hashCode));
      
      // Different types should have different hashCodes
      const token3 = Token<double>('primary');
      expect(token1.hashCode, isNot(equals(token3.hashCode)));
    });

    test('call() creates appropriate ref types', () {
      const colorToken = Token<Color>('primary');
      const spaceToken = Token<double>('large');
      const radiusToken = Token<Radius>('small');
      const textStyleToken = Token<TextStyle>('heading');
      
      final colorRef = colorToken();
      final spaceRef = spaceToken();
      final radiusRef = radiusToken();
      final textStyleRef = textStyleToken();
      
      expect(colorRef, isA<ColorRef>());
      expect(spaceRef, isA<double>());
      expect(spaceRef, lessThan(0)); // Negative hashcode hack
      expect(radiusRef, isA<RadiusRef>());
      expect(textStyleRef, isA<TextStyleRef>());
    });

    testWidgets('resolve() works with theme data', (tester) async {
      const token = Token<Color>('primary');
      final theme = MixThemeData(
        colors: {
          ColorToken(token.name): Colors.blue,
        },
      );

      await tester.pumpWidget(
        MixTheme(
          data: theme,
          child: Container(),
        ),
      );

      final context = tester.element(find.byType(Container));
      final resolved = token.resolve(context);
      
      expect(resolved, equals(Colors.blue));
    });

    testWidgets('resolve() throws for undefined tokens', (tester) async {
      const token = Token<Color>('undefined');
      final theme = MixThemeData();
      
      await tester.pumpWidget(createWithMixTheme(theme));
      final context = tester.element(find.byType(Container));
      
      expect(
        () => token.resolve(context),
        throwsAssertionError,
      );
    });

    testWidgets('unsupported types throw appropriate errors', (tester) async {
      const token = Token<String>('unsupported');
      
      await tester.pumpWidget(createWithMixTheme(MixThemeData()));
      final context = tester.element(find.byType(Container));
      
      expect(
        () => token.resolve(context),
        throwsUnsupportedError,
      );
      
      expect(
        () => token(),
        throwsUnsupportedError,
      );
    });
  });
}
