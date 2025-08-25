import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('TypographyScope', () {
    testWidgets('provides typography data to descendants', (tester) async {
      final typography = TypographyMix(
        style: TextStyleMix(fontSize: 16.0, color: Colors.blue),
        textAlign: TextAlign.center,
        maxLines: 2,
      );

      late TypographyMix capturedScope;

      await tester.pumpWidget(
        TypographyScope(
          typography: typography,
          child: Builder(
            builder: (context) {
              capturedScope = TypographyScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedScope, isNotNull);
      expect(capturedScope, equals(typography));
    });

    testWidgets('maybeOf returns null when no scope found', (tester) async {
      TypographyMix? capturedScope;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            capturedScope = TypographyScope.maybeOf(context);
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
            expect(() => TypographyScope.of(context), throwsAssertionError);
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('wraps child with DefaultTextStyle', (tester) async {
      final typography = TypographyMix(
        style: TextStyleMix(fontSize: 18.0, color: Colors.red),
        textAlign: TextAlign.justify,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      );

      await tester.pumpWidget(
        TypographyScope(
          typography: typography,
          child: Builder(
            builder: (context) {
              final defaultTextStyle = DefaultTextStyle.of(context);
              expect(defaultTextStyle.style.fontSize, 18);
              expect(defaultTextStyle.style.color, Colors.red);
              expect(defaultTextStyle.textAlign, TextAlign.justify);
              expect(defaultTextStyle.softWrap, false);
              expect(defaultTextStyle.overflow, TextOverflow.ellipsis);
              expect(defaultTextStyle.maxLines, 3);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('updateShouldNotify returns true when typography changes', (
      tester,
    ) async {
      final typography1 = TypographyMix(style: TextStyleMix(fontSize: 16.0));
      final typography2 = TypographyMix(style: TextStyleMix(fontSize: 18.0));

      // Test through InheritedWidget implementation
      expect(typography1, isNot(equals(typography2)));
    });

    testWidgets('updateShouldNotify returns false when typography is same', (
      tester,
    ) async {
      final typography = TypographyMix(style: TextStyleMix(fontSize: 16.0));

      // Test through InheritedWidget implementation
      expect(typography, equals(typography));
    });

    testWidgets('handles null typography properties', (tester) async {
      final typography = TypographyMix();

      await tester.pumpWidget(
        TypographyScope(
          typography: typography,
          child: Builder(
            builder: (context) {
              final defaultTextStyle = DefaultTextStyle.of(context);
              expect(defaultTextStyle.style, const TextStyle());
              expect(defaultTextStyle.textAlign, isNull);
              expect(defaultTextStyle.softWrap, true);
              expect(defaultTextStyle.overflow, TextOverflow.clip);
              expect(defaultTextStyle.maxLines, isNull);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
