import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

/// End-to-end tests for the fluent directive API on [ColorRef]:
/// `colorToken().withAlpha(...)`, `.withValues(...)`, `.withOpacity(...)`, etc.
/// chained into a [BoxStyler] and rendered through [Box] + [MixScope].
void main() {
  group('ColorToken + ColorRef fluent directive integration', () {
    testWidgets(
      'withAlpha applies to the token-resolved color at render time',
      (tester) async {
        const token = ColorToken('primary');
        const baseColor = Color(0xFF112233);

        final style = BoxStyler().color(token().withAlpha(128));

        await tester.pumpWidget(
          MixScope(
            tokens: {token: baseColor},
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Box(style: style),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, baseColor.withAlpha(128));
      },
    );

    testWidgets('chained directives apply in call order', (tester) async {
      const token = ColorToken('primary');
      const baseColor = Color(0xFF80A0C0);

      final style = BoxStyler().color(
        token().withRed(10).withGreen(20).withBlue(30),
      );

      await tester.pumpWidget(
        MixScope(
          tokens: {token: baseColor},
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Box(style: style),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      final expected = baseColor.withRed(10).withGreen(20).withBlue(30);
      expect(decoration.color, expected);
    });

    testWidgets(
      'withValues applies at render time with multiple channels',
      (tester) async {
        const token = ColorToken('primary');
        const baseColor = Color(0xFF336699);

        final style = BoxStyler().color(
          token().withValues(alpha: 0.25, red: 0.5),
        );

        await tester.pumpWidget(
          MixScope(
            tokens: {token: baseColor},
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Box(style: style),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, baseColor.withValues(alpha: 0.25, red: 0.5));
      },
    );

    testWidgets('withOpacity applies via OpacityColorDirective', (tester) async {
      const token = ColorToken('primary');
      const baseColor = Color(0xFFFF0000);

      // OpacityColorDirective is implemented as withValues(alpha: opacity),
      // so the expected output matches that, not the deprecated withOpacity.
      final style = BoxStyler().color(
        // ignore: deprecated_member_use
        token().withOpacity(0.5),
      );

      await tester.pumpWidget(
        MixScope(
          tokens: {token: baseColor},
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Box(style: style),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, baseColor.withValues(alpha: 0.5));
    });
  });
}
