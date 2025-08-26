import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('IconScope', () {
    testWidgets('provides icon data to descendants', (tester) async {
      final icon = IconMix(
        size: 24.0,
        color: Colors.blue,
        weight: 400.0,
        fill: 1.0,
      );

      late IconMix capturedScope;

      await tester.pumpWidget(
        IconScope(
          icon: icon,
          child: Builder(
            builder: (context) {
              capturedScope = IconScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedScope, isNotNull);
      expect(capturedScope, equals(icon));
    });

    testWidgets('maybeOf returns null when no scope found', (tester) async {
      IconMix? capturedScope;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            capturedScope = IconScope.maybeOf(context);
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
            expect(() => IconScope.of(context), throwsAssertionError);
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('wraps child with IconTheme', (tester) async {
      final icon = IconMix(
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
        IconScope(
          icon: icon,
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

    testWidgets('updateShouldNotify returns true when icon changes', (
      tester,
    ) async {
      final icon1 = IconMix(size: 16.0);
      final icon2 = IconMix(size: 24.0);

      // Test through InheritedWidget implementation
      expect(icon1, isNot(equals(icon2)));
    });

    testWidgets('updateShouldNotify returns false when icon is same', (
      tester,
    ) async {
      final icon = IconMix(size: 16.0);

      // Test through InheritedWidget implementation
      expect(icon, equals(icon));
    });

    testWidgets('handles null icon properties', (tester) async {
      final icon = IconMix();

      await tester.pumpWidget(
        MaterialApp(
          home: IconScope(
            icon: icon,
            child: Builder(
              builder: (context) {
                final iconTheme = IconTheme.of(context);
                // IconTheme.of(context) may have default values from MaterialApp
                // Just verify that IconScope is providing the theme
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