// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  // Create a test that checks if all th`e values of these tokens match the ThemeData from the MaterialApp
  group('Material tokens', () {
    testWidgets('colors', (tester) async {
      final theme = ThemeData.light();
      await tester.pumpWithMixScope(Container(), withMaterial: true);
      final context = tester.element(find.byType(Container));
      final colors = const MaterialTokens().colorScheme;
      final scope = MixScope.of(context);

      expect(
        scope.getToken(colors.primary, context),
        theme.colorScheme.primary,
      );
      expect(
        scope.getToken(colors.secondary, context),
        theme.colorScheme.secondary,
      );
      expect(
        scope.getToken(colors.tertiary, context),
        theme.colorScheme.tertiary,
      );
      expect(
        scope.getToken(colors.surface, context),
        theme.colorScheme.surface,
      );
      expect(
        scope.getToken(colors.background, context),
        theme.colorScheme.background,
      );
      expect(scope.getToken(colors.error, context), theme.colorScheme.error);
      expect(
        scope.getToken(colors.onPrimary, context),
        theme.colorScheme.onPrimary,
      );
      expect(
        scope.getToken(colors.onSecondary, context),
        theme.colorScheme.onSecondary,
      );
      expect(
        scope.getToken(colors.onTertiary, context),
        theme.colorScheme.onTertiary,
      );
      expect(
        scope.getToken(colors.onSurface, context),
        theme.colorScheme.onSurface,
      );
      expect(
        scope.getToken(colors.onBackground, context),
        theme.colorScheme.onBackground,
      );
      expect(
        scope.getToken(colors.onError, context),
        theme.colorScheme.onError,
      );
    });

    testWidgets('textStyles', (tester) async {
      await tester.pumpWithMixScope(Container(), withMaterial: true);
      final context = tester.element(find.byType(Container));
      final scope = MixScope.of(context);
      final tokens = const MaterialTokens().textTheme;
      final textTheme = Theme.of(context).textTheme;

      expect(
        scope.getToken(tokens.displayLarge, context),
        textTheme.displayLarge,
      );
      expect(
        scope.getToken(tokens.displayMedium, context),
        textTheme.displayMedium,
      );
      expect(
        scope.getToken(tokens.displaySmall, context),
        textTheme.displaySmall,
      );
      expect(
        scope.getToken(tokens.headlineLarge, context),
        textTheme.headlineLarge,
      );
      expect(
        scope.getToken(tokens.headlineMedium, context),
        textTheme.headlineMedium,
      );
      expect(
        scope.getToken(tokens.headlineSmall, context),
        textTheme.headlineSmall,
      );
      expect(scope.getToken(tokens.titleLarge, context), textTheme.titleLarge);
      expect(
        scope.getToken(tokens.titleMedium, context),
        textTheme.titleMedium,
      );
      expect(scope.getToken(tokens.titleSmall, context), textTheme.titleSmall);
      expect(scope.getToken(tokens.bodyLarge, context), textTheme.bodyLarge);
      expect(scope.getToken(tokens.bodyMedium, context), textTheme.bodyMedium);
      expect(scope.getToken(tokens.bodySmall, context), textTheme.bodySmall);
      expect(scope.getToken(tokens.labelLarge, context), textTheme.labelLarge);
      expect(
        scope.getToken(tokens.labelMedium, context),
        textTheme.labelMedium,
      );
      expect(scope.getToken(tokens.labelSmall, context), textTheme.labelSmall);

      // Deprecated aliases
      expect(scope.getToken(tokens.headline1, context), textTheme.displayLarge);
      expect(
        scope.getToken(tokens.headline2, context),
        textTheme.displayMedium,
      );
      expect(scope.getToken(tokens.headline3, context), textTheme.displaySmall);
      expect(
        scope.getToken(tokens.headline4, context),
        textTheme.headlineMedium,
      );
      expect(
        scope.getToken(tokens.headline5, context),
        textTheme.headlineSmall,
      );
      expect(scope.getToken(tokens.headline6, context), textTheme.titleLarge);
      expect(scope.getToken(tokens.subtitle1, context), textTheme.titleMedium);
      expect(scope.getToken(tokens.subtitle2, context), textTheme.titleSmall);
      expect(scope.getToken(tokens.bodyText1, context), textTheme.bodyLarge);
      expect(scope.getToken(tokens.bodyText2, context), textTheme.bodyMedium);
      expect(scope.getToken(tokens.caption, context), textTheme.bodySmall);
      expect(scope.getToken(tokens.button, context), textTheme.labelLarge);
      expect(scope.getToken(tokens.overline, context), textTheme.labelSmall);
    });
  });
}
