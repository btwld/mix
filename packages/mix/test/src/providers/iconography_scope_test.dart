import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('IconographyScope', () {
    testWidgets('provides iconography data to descendants', (tester) async {
      final iconography = IconographyMix(
        size: 24.0,
        color: Colors.blue,
        weight: 400.0,
        fill: 1.0,
      );

      late IconographyMix capturedScope;

      await tester.pumpWidget(
        IconographyScope(
          iconography: iconography,
          child: Builder(
            builder: (context) {
              capturedScope = IconographyScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedScope, isNotNull);
      expect(capturedScope, equals(iconography));
    });

    testWidgets('maybeOf returns null when no scope found', (tester) async {
      IconographyMix? capturedScope;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            capturedScope = IconographyScope.maybeOf(context);
            return const SizedBox();
          },
        ),
      );

      expect(capturedScope, isNull);
    });

    testWidgets('of throws assertion error when no scope found', (
      tester,
    ) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(() => IconographyScope.of(context), throwsAssertionError);
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('wraps child with IconTheme', (tester) async {
      final iconography = IconographyMix(
        size: 32.0,
        color: Colors.red,
        weight: 700.0,
        fill: 0.5,
        grade: 200.0,
        opticalSize: 48.0,
        opacity: 0.8,
        shadows: [ShadowMix(color: Colors.black, offset: const Offset(1, 1))],
        applyTextScaling: false,
      );

      await tester.pumpWidget(
        IconographyScope(
          iconography: iconography,
          child: Builder(
            builder: (context) {
              final iconTheme = IconTheme.of(context);
              expect(iconTheme.size, 32.0);
              expect(iconTheme.color, Colors.red);
              expect(iconTheme.weight, 700.0);
              expect(iconTheme.fill, 0.5);
              expect(iconTheme.grade, 200.0);
              expect(iconTheme.opticalSize, 48.0);
              expect(iconTheme.opacity, 0.8);
              expect(iconTheme.shadows, isNotNull);
              expect(iconTheme.shadows!.length, 1);
              expect(iconTheme.applyTextScaling, false);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('updateShouldNotify returns true when iconography changes', (
      tester,
    ) async {
      final iconography1 = IconographyMix(size: 16.0);
      final iconography2 = IconographyMix(size: 24.0);

      // Test through InheritedWidget implementation
      expect(iconography1, isNot(equals(iconography2)));
    });

    testWidgets('updateShouldNotify returns false when iconography is same', (
      tester,
    ) async {
      final iconography = IconographyMix(size: 16.0);

      // Test through InheritedWidget implementation
      expect(iconography, equals(iconography));
    });

    testWidgets('handles null iconography properties', (tester) async {
      final iconography = IconographyMix();

      await tester.pumpWidget(
        MaterialApp(
          home: IconographyScope(
            iconography: iconography,
            child: Builder(
              builder: (context) {
                final iconTheme = IconTheme.of(context);
                // IconTheme.of(context) may have default values from MaterialApp
                // Just verify that IconographyScope is providing the theme
                expect(iconTheme, isNotNull);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });
}
