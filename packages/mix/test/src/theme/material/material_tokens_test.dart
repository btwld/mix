// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  // Create a test that checks if all the values of these tokens match the ThemeData from the MaterialApp
  group('Material tokens', () {

    testWidgets('colors', (tester) async {
      final theme = ThemeData.light();
      await tester.pumpWithMixScope(
        Container(),
        theme: MixScopeData.withMaterial(),
      );
      final context = tester.element(find.byType(Container));
      final colors = const MaterialTokens().colorScheme;
      final scope = MixScope.of(context);

      expect(scope.getToken(colors.primary, context), theme.colorScheme.primary);
      expect(
        scope.getToken(colors.secondary, context),
        theme.colorScheme.secondary,
      );
      expect(
        scope.getToken(colors.tertiary, context),
        theme.colorScheme.tertiary,
      );
      expect(scope.getToken(colors.surface, context), theme.colorScheme.surface);
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
      expect(scope.getToken(colors.onError, context), theme.colorScheme.onError);
    });

    testWidgets('Material 3 textStyles', (tester) async {
      await tester.pumpWithMixScope(
        Container(),
        theme: MixScopeData.withMaterial(),
      );
      final context = tester.element(find.byType(Container));

      final theme = Theme.of(context);
      final scope = MixScope.of(context);

      final textStyles = const MaterialTokens().textTheme;
      expect(
        scope.getToken(textStyles.displayLarge, context),
        theme.textTheme.displayLarge,
      );
      expect(
        scope.getToken(textStyles.displayMedium, context),
        theme.textTheme.displayMedium,
      );
      expect(
        scope.getToken(textStyles.displaySmall, context),
        theme.textTheme.displaySmall,
      );
      expect(
        scope.getToken(textStyles.headlineLarge, context),
        theme.textTheme.headlineLarge,
      );
      expect(
        scope.getToken(textStyles.headlineMedium, context),
        theme.textTheme.headlineMedium,
      );
      expect(
        scope.getToken(textStyles.headlineSmall, context),
        theme.textTheme.headlineSmall,
      );
      expect(
        scope.getToken(textStyles.titleLarge, context),
        theme.textTheme.titleLarge,
      );
      expect(
        scope.getToken(textStyles.titleMedium, context),
        theme.textTheme.titleMedium,
      );
      expect(
        scope.getToken(textStyles.titleSmall, context),
        theme.textTheme.titleSmall,
      );
      expect(
        scope.getToken(textStyles.bodyLarge, context),
        theme.textTheme.bodyLarge,
      );
      expect(
        scope.getToken(textStyles.bodyMedium, context),
        theme.textTheme.bodyMedium,
      );
      expect(
        scope.getToken(textStyles.bodySmall, context),
        theme.textTheme.bodySmall,
      );
      expect(
        scope.getToken(textStyles.labelLarge, context),
        theme.textTheme.labelLarge,
      );
      expect(
        scope.getToken(textStyles.labelMedium, context),
        theme.textTheme.labelMedium,
      );
      expect(
        scope.getToken(textStyles.labelSmall, context),
        theme.textTheme.labelSmall,
      );
    });
  });
}
