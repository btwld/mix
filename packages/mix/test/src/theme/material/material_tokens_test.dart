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
      await tester.pumpWithMixTheme(
        Container(),
        theme: MixThemeData.withMaterial().copyWith(),
      );
      final context = tester.element(find.byType(Container));
      final colors = const MaterialTokens().colorScheme;

      expect(colors.primary.resolve(context), theme.colorScheme.primary);
      expect(
        colors.secondary.resolve(context),
        theme.colorScheme.secondary,
      );
      expect(
        colors.tertiary.resolve(context),
        theme.colorScheme.tertiary,
      );
      expect(colors.surface.resolve(context), theme.colorScheme.surface);
      expect(
        colors.background.resolve(context),
        theme.colorScheme.background,
      );
      expect(colors.error.resolve(context), theme.colorScheme.error);
      expect(
        colors.onPrimary.resolve(context),
        theme.colorScheme.onPrimary,
      );
      expect(
        colors.onSecondary.resolve(context),
        theme.colorScheme.onSecondary,
      );
      expect(
        colors.onTertiary.resolve(context),
        theme.colorScheme.onTertiary,
      );
      expect(
        colors.onSurface.resolve(context),
        theme.colorScheme.onSurface,
      );
      expect(
        colors.onBackground.resolve(context),
        theme.colorScheme.onBackground,
      );
      expect(colors.onError.resolve(context), theme.colorScheme.onError);
    });

    testWidgets('Material 3 textStyles', (tester) async {
      await tester.pumpWithMixTheme(
        Container(),
        theme: MixThemeData.withMaterial(),
      );
      final context = tester.element(find.byType(Container));

      final theme = Theme.of(context);

      final textStyles = const MaterialTokens().textTheme;
      expect(
        textStyles.displayLarge.resolve(context),
        theme.textTheme.displayLarge,
      );
      expect(
        textStyles.displayMedium.resolve(context),
        theme.textTheme.displayMedium,
      );
      expect(
        textStyles.displaySmall.resolve(context),
        theme.textTheme.displaySmall,
      );
      expect(
        textStyles.headlineLarge.resolve(context),
        theme.textTheme.headlineLarge,
      );
      expect(
        textStyles.headlineMedium.resolve(context),
        theme.textTheme.headlineMedium,
      );
      expect(
        textStyles.headlineSmall.resolve(context),
        theme.textTheme.headlineSmall,
      );
      expect(
        textStyles.titleLarge.resolve(context),
        theme.textTheme.titleLarge,
      );
      expect(
        textStyles.titleMedium.resolve(context),
        theme.textTheme.titleMedium,
      );
      expect(
        textStyles.titleSmall.resolve(context),
        theme.textTheme.titleSmall,
      );
      expect(
        textStyles.bodyLarge.resolve(context),
        theme.textTheme.bodyLarge,
      );
      expect(
        textStyles.bodyMedium.resolve(context),
        theme.textTheme.bodyMedium,
      );
      expect(
        textStyles.bodySmall.resolve(context),
        theme.textTheme.bodySmall,
      );
      expect(
        textStyles.labelLarge.resolve(context),
        theme.textTheme.labelLarge,
      );
      expect(
        textStyles.labelMedium.resolve(context),
        theme.textTheme.labelMedium,
      );
      expect(
        textStyles.labelSmall.resolve(context),
        theme.textTheme.labelSmall,
      );
    });
  });
}
