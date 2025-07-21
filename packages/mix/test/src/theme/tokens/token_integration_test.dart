import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  group('Token Integration Tests', () {
    testWidgets('Mixable<Color> with Token<Color> integration', (tester) async {
      const primaryToken = MixToken<Color>('primary');
      const secondaryToken = MixToken<Color>('secondary');

      final theme = MixScopeData.static(
        tokens: {primaryToken: Colors.blue, secondaryToken: Colors.red},
      );

      await tester.pumpWidget(
        MixScope(
          data: theme,
          child: Builder(
            builder: (context) {
              final mix1 = Prop.token(primaryToken);
              final mix2 = Prop.token(secondaryToken);

              final mixContext = MixContext.create(context, Style());
              expect(mix1, resolvesTo(Colors.blue, context: mixContext));
              expect(mix2, resolvesTo(Colors.red, context: mixContext));

              return Container();
            },
          ),
        ),
      );
    });


    testWidgets('Utility extensions work with tokens', (tester) async {
      const primaryToken = MixToken<Color>('primary');
      const spacingToken = MixToken<double>('spacing');

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
      const colorToken = MixToken<Color>('primary');
      const spaceToken = MixToken<double>('large');

      // Names should be predictable
      expect(colorToken.name, equals('primary'));
      expect(spaceToken.name, equals('large'));
    });
  });
}
