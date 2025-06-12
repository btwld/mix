import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Token Integration Tests', () {
    testWidgets('ColorDto with Token<Color> integration', (tester) async {
      const primaryToken = Token<Color>('primary');
      const secondaryToken = Token<Color>('secondary');
      
      final theme = MixThemeData(
        colors: {
          ColorToken(primaryToken.name): Colors.blue,
          ColorToken(secondaryToken.name): Colors.red,
        },
      );

      await tester.pumpWidget(
        MixTheme(
          data: theme,
          child: Builder(
            builder: (context) {
              final dto1 = ColorDto.token(primaryToken);
              final dto2 = ColorDto.token(secondaryToken);
              
              final color1 = dto1.resolve(MixData.create(context, Style()));
              final color2 = dto2.resolve(MixData.create(context, Style()));
              
              expect(color1, equals(Colors.blue));
              expect(color2, equals(Colors.red));
              
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('SpaceDto with Token<double> integration', (tester) async {
      const smallToken = Token<double>('small');
      const largeToken = Token<double>('large');
      
      final theme = MixThemeData(
        spaces: {
          SpaceToken(smallToken.name): 8.0,
          SpaceToken(largeToken.name): 24.0,
        },
      );

      await tester.pumpWidget(
        MixTheme(
          data: theme,
          child: Builder(
            builder: (context) {
              final dto1 = SpaceDto.token(smallToken);
              final dto2 = SpaceDto.token(largeToken);
              
              final space1 = dto1.resolve(MixData.create(context, Style()));
              final space2 = dto2.resolve(MixData.create(context, Style()));
              
              expect(space1, equals(8.0));
              expect(space2, equals(24.0));
              
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('TextStyleDto with Token<TextStyle> integration', (tester) async {
      const headingToken = Token<TextStyle>('heading');
      const bodyToken = Token<TextStyle>('body');
      
      const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
      const bodyStyle = TextStyle(fontSize: 16);
      
      final theme = MixThemeData(
        textStyles: {
          TextStyleToken(headingToken.name): headingStyle,
          TextStyleToken(bodyToken.name): bodyStyle,
        },
      );

      await tester.pumpWidget(
        MixTheme(
          data: theme,
          child: Builder(
            builder: (context) {
              final dto1 = TextStyleDto.token(headingToken);
              final dto2 = TextStyleDto.token(bodyToken);
              
              final style1 = dto1.resolve(MixData.create(context, Style()));
              final style2 = dto2.resolve(MixData.create(context, Style()));
              
              expect(style1.fontSize, equals(24));
              expect(style1.fontWeight, equals(FontWeight.bold));
              expect(style2.fontSize, equals(16));
              
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('Utility extensions work with tokens', (tester) async {
      const primaryToken = Token<Color>('primary');
      const spacingToken = Token<double>('spacing');
      
      final theme = MixThemeData(
        colors: {
          ColorToken(primaryToken.name): Colors.purple,
        },
        spaces: {
          SpaceToken(spacingToken.name): 16.0,
        },
      );

      await tester.pumpWidget(
        MixTheme(
          data: theme,
          child: Builder(
            builder: (context) {
              final style = Style(
                $box.color.token(primaryToken),
                $box.padding.all.token(spacingToken),
              );
              
              final mixData = MixData.create(context, style);
              final boxSpec = mixData.attributeOf<BoxSpecAttribute>()?.resolve(mixData);
              
              expect((boxSpec?.decoration as BoxDecoration?)?.color, equals(Colors.purple));
              expect(boxSpec?.padding, equals(const EdgeInsets.all(16.0)));
              
              return Container();
            },
          ),
        ),
      );
    });

    test('Token backwards compatibility with old token types', () {
      // Old tokens should still work
      const oldColorToken = ColorToken('primary');
      const oldSpaceToken = SpaceToken('large');
      
      // New tokens with same names
      const newColorToken = Token<Color>('primary');
      const newSpaceToken = Token<double>('large');
      
      // Names should match for theme lookup
      expect(oldColorToken.name, equals(newColorToken.name));
      expect(oldSpaceToken.name, equals(newSpaceToken.name));
    });
  });
}
