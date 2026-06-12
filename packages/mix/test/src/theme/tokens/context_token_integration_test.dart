import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

Color _resolvePrimary(BuildContext context) {
  return Theme.of(context).colorScheme.primary;
}

Color _resolveBlack(BuildContext _) => const Color(0xFF000000);

/// End-to-end tests for [ContextToken] and resolver values in [MixScope]:
/// context-derived token values resolve through the standard token ref
/// pipeline, so they follow exact fluent-chain ordering.
void main() {
  const themePrimary = Color(0xFF123456);
  const explicitColor = Color(0xFFFF0000);

  final primary = ContextToken(_resolvePrimary);

  Widget wrapWithTheme(Widget child) {
    return Theme(
      data: ThemeData(
        colorScheme: const ColorScheme.light(primary: themePrimary),
      ),
      child: Directionality(textDirection: .ltr, child: child),
    );
  }

  BoxDecoration decorationOf(WidgetTester tester) {
    final container = tester.widget<Container>(find.byType(Container));

    return container.decoration! as BoxDecoration;
  }

  group('ContextToken', () {
    test('call() returns a typed token reference', () {
      final ref = primary();

      expect(ref, isA<Color>());
      expect(isAnyTokenRef(ref), isTrue);
    });

    test('equality is based on resolver identity', () {
      final a = ContextToken(_resolveBlack);
      final b = ContextToken(_resolveBlack);
      final c = ContextToken((_) => const Color(0xFF000000));
      final d = ContextToken((_) => const Color(0xFF000000));

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a == c, isFalse);
      expect(c == d, isFalse);
    });

    testWidgets('resolves from context without a MixScope', (tester) async {
      final style = BoxStyler().color(primary());

      await tester.pumpWidget(wrapWithTheme(Box(style: style)));

      expect(decorationOf(tester).color, themePrimary);
    });

    testWidgets('explicit value after a context token wins (chain order)', (
      tester,
    ) async {
      final style = BoxStyler().color(primary()).color(explicitColor);

      await tester.pumpWidget(wrapWithTheme(Box(style: style)));

      expect(decorationOf(tester).color, explicitColor);
    });

    testWidgets('context token after an explicit value wins (chain order)', (
      tester,
    ) async {
      final style = BoxStyler().color(explicitColor).color(primary());

      await tester.pumpWidget(wrapWithTheme(Box(style: style)));

      expect(decorationOf(tester).color, themePrimary);
    });

    testWidgets('MixScope value overrides the resolver', (tester) async {
      const scopeColor = Color(0xFF00FF00);
      final style = BoxStyler().color(primary());

      await tester.pumpWidget(
        wrapWithTheme(
          MixScope(
            tokens: {primary: scopeColor},
            child: Box(style: style),
          ),
        ),
      );

      expect(decorationOf(tester).color, scopeColor);
    });

    testWidgets('MixScope resolver overrides the resolver', (tester) async {
      const scopeColor = Color(0xFF00FF00);
      final style = BoxStyler().color(primary());

      await tester.pumpWidget(
        wrapWithTheme(
          MixScope(
            tokens: {primary: (BuildContext _) => scopeColor},
            child: Box(style: style),
          ),
        ),
      );

      expect(decorationOf(tester).color, scopeColor);
    });

    testWidgets(
      'MixScope override uses resolver identity across token instances',
      (tester) async {
        const scopeColor = Color(0xFF00FF00);
        final scopedPrimary = ContextToken(_resolvePrimary);
        final styledPrimary = ContextToken(_resolvePrimary);
        final style = BoxStyler().color(styledPrimary());

        await tester.pumpWidget(
          wrapWithTheme(
            MixScope(
              tokens: {scopedPrimary: scopeColor},
              child: Box(style: style),
            ),
          ),
        );

        expect(decorationOf(tester).color, scopeColor);
      },
    );

    testWidgets('directives apply to the context-resolved color', (
      tester,
    ) async {
      final style = BoxStyler().color(primary().withAlpha(128));

      await tester.pumpWidget(wrapWithTheme(Box(style: style)));

      expect(decorationOf(tester).color, themePrimary.withAlpha(128));
    });

    testWidgets('re-resolves when the Theme changes', (tester) async {
      const updatedPrimary = Color(0xFF654321);
      final style = BoxStyler().color(primary());
      // Reuse the exact same child widget instance across pumps so a rebuild
      // can only come from the Theme dependency registered during resolution.
      final child = Directionality(
        textDirection: .ltr,
        child: Box(style: style),
      );

      await tester.pumpWidget(
        Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(primary: themePrimary),
          ),
          child: child,
        ),
      );
      expect(decorationOf(tester).color, themePrimary);

      await tester.pumpWidget(
        Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(primary: updatedPrimary),
          ),
          child: child,
        ),
      );
      expect(decorationOf(tester).color, updatedPrimary);
    });

    testWidgets('double context token follows chain order', (tester) async {
      final spacing = ContextToken((_) => 42.0);

      final tokenLast = BoxStyler().paddingAll(10).paddingAll(spacing());
      final explicitLast = BoxStyler().paddingAll(spacing()).paddingAll(10);

      await tester.pumpWidget(wrapWithTheme(Box(style: tokenLast)));
      expect(
        tester.widget<Container>(find.byType(Container)).padding,
        const EdgeInsets.all(42),
      );

      await tester.pumpWidget(wrapWithTheme(Box(style: explicitLast)));
      expect(
        tester.widget<Container>(find.byType(Container)).padding,
        const EdgeInsets.all(10),
      );
    });
  });

  group('MixScope resolver values', () {
    testWidgets('a token backed by a resolver resolves from context', (
      tester,
    ) async {
      const token = ColorToken('app.primary');
      final style = BoxStyler().color(token());

      await tester.pumpWidget(
        wrapWithTheme(
          MixScope(
            tokens: {
              token: (BuildContext context) =>
                  Theme.of(context).colorScheme.primary,
            },
            child: Box(style: style),
          ),
        ),
      );

      expect(decorationOf(tester).color, themePrimary);
    });

    testWidgets('resolver-backed token follows chain order', (tester) async {
      const token = ColorToken('app.primary');
      final style = BoxStyler().color(token()).color(explicitColor);

      await tester.pumpWidget(
        wrapWithTheme(
          MixScope(
            tokens: {
              token: (BuildContext context) =>
                  Theme.of(context).colorScheme.primary,
            },
            child: Box(style: style),
          ),
        ),
      );

      expect(decorationOf(tester).color, explicitColor);
    });

    testWidgets('resolver-backed token after an explicit value wins', (
      tester,
    ) async {
      const token = ColorToken('app.primary');
      final style = BoxStyler().color(explicitColor).color(token());

      await tester.pumpWidget(
        wrapWithTheme(
          MixScope(
            tokens: {
              token: (BuildContext context) =>
                  Theme.of(context).colorScheme.primary,
            },
            child: Box(style: style),
          ),
        ),
      );

      expect(decorationOf(tester).color, themePrimary);
    });

    testWidgets('resolve() invokes the resolver with the consuming context', (
      tester,
    ) async {
      const token = DoubleToken('app.scale');

      await tester.pumpWidget(
        MixScope(
          tokens: {token: (BuildContext context) => 1.5},
          child: Builder(
            builder: (context) {
              expect(token.resolve(context), 1.5);

              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
