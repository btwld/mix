import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

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

        final container = await tester.pumpBoxWithMixScope(
          tokens: {token: baseColor},
          style: style,
        );
        expect(boxDecorationFrom(container).color, baseColor.withAlpha(128));
      },
    );

    testWidgets('chained directives apply in call order', (tester) async {
      const token = ColorToken('primary');
      const baseColor = Color(0xFF80A0C0);

      final style = BoxStyler().color(
        token().withRed(10).withGreen(20).withBlue(30),
      );

      final container = await tester.pumpBoxWithMixScope(
        tokens: {token: baseColor},
        style: style,
      );
      final expected = baseColor.withRed(10).withGreen(20).withBlue(30);
      expect(boxDecorationFrom(container).color, expected);
    });

    testWidgets('withValues applies at render time with multiple channels', (
      tester,
    ) async {
      const token = ColorToken('primary');
      const baseColor = Color(0xFF336699);

      final style = BoxStyler().color(
        token().withValues(alpha: 0.25, red: 0.5),
      );

      final container = await tester.pumpBoxWithMixScope(
        tokens: {token: baseColor},
        style: style,
      );
      expect(
        boxDecorationFrom(container).color,
        baseColor.withValues(alpha: 0.25, red: 0.5),
      );
    });

    testWidgets('withOpacity applies via OpacityColorDirective', (
      tester,
    ) async {
      const token = ColorToken('primary');
      const baseColor = Color(0xFFFF0000);

      final style = BoxStyler().color(
        // ignore: deprecated_member_use
        token().withOpacity(0.5),
      );

      final container = await tester.pumpBoxWithMixScope(
        tokens: {token: baseColor},
        style: style,
      );
      expect(
        boxDecorationFrom(container).color,
        baseColor.withValues(alpha: 0.5),
      );
    });
  });
}
