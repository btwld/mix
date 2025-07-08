import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Token Integration Tests', () {
    testWidgets('Mixable<Color> with Token<Color> integration', (tester) async {
      const primaryToken = MixableToken<Color>('primary');
      const secondaryToken = MixableToken<Color>('secondary');

      final theme = MixScopeData.static(
        tokens: {primaryToken: Colors.blue, secondaryToken: Colors.red},
      );

      await tester.pumpWidget(
        MixScope(
          data: theme,
          child: Builder(
            builder: (context) {
              const dto1 = Mixable<Color>.token(primaryToken);
              const dto2 = Mixable<Color>.token(secondaryToken);

              final color1 = dto1.resolve(MixContext.create(context, Style()));
              final color2 = dto2.resolve(MixContext.create(context, Style()));

              expect(color1, equals(Colors.blue));
              expect(color2, equals(Colors.red));

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('SpaceDto with Token<double> integration', (tester) async {
      const smallToken = MixableToken<double>('small');
      const largeToken = MixableToken<double>('large');

      final theme = MixScopeData.static(
        tokens: {smallToken: 8.0, largeToken: 24.0},
      );

      await tester.pumpWidget(
        MixScope(
          data: theme,
          child: Builder(
            builder: (context) {
              const dto1 = SpaceDto.token(smallToken);
              const dto2 = SpaceDto.token(largeToken);

              final space1 = dto1.resolve(MixContext.create(context, Style()));
              final space2 = dto2.resolve(MixContext.create(context, Style()));

              expect(space1, equals(8.0));
              expect(space2, equals(24.0));

              return Container();
            },
          ),
        ),
      );
    });


    testWidgets('Utility extensions work with tokens', (tester) async {
      const primaryToken = MixableToken<Color>('primary');
      const spacingToken = MixableToken<double>('spacing');

      final theme = MixScopeData.static(
        tokens: {primaryToken: Colors.purple, spacingToken: 16.0},
      );

      await tester.pumpWidget(
        MixScope(
          data: theme,
          child: Builder(
            builder: (context) {
              final style = Style(
                $box.color.token(primaryToken),
                $box.padding.all.token(spacingToken),
              );

              final mixData = MixContext.create(context, style);
              final boxSpec = mixData.attributeOf<BoxSpecAttribute>()?.resolve(
                mixData,
              );

              expect(
                (boxSpec?.decoration as BoxDecoration?)?.color,
                equals(Colors.purple),
              );
              expect(boxSpec?.padding, equals(const EdgeInsets.all(16.0)));

              return Container();
            },
          ),
        ),
      );
    });

    test('Token names are consistent', () {
      // New tokens
      const colorToken = MixableToken<Color>('primary');
      const spaceToken = MixableToken<double>('large');

      // Names should be predictable
      expect(colorToken.name, equals('primary'));
      expect(spaceToken.name, equals('large'));
    });
  });
}
