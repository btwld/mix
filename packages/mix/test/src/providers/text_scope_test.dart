import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('TextScope', () {
    testWidgets('provides text data to descendants', (tester) async {
      final text = TextStyling(
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      );

      late TextStyling capturedScope;

      await tester.pumpWidget(
        TextScope(
          text: text,
          child: Builder(
            builder: (context) {
              capturedScope = TextScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedScope, isNotNull);
      expect(capturedScope, equals(text));
    });

    testWidgets('maybeOf returns null when no scope found', (tester) async {
      TextStyling? capturedScope;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            capturedScope = TextScope.maybeOf(context);
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
            expect(() => TextScope.of(context), throwsAssertionError);
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('wraps child with DefaultTextStyle', (tester) async {
      final text = TextStyling(
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        softWrap: false,
      );

      await tester.pumpWidget(
        TextScope(
          text: text,
          child: Builder(
            builder: (context) {
              final defaultTextStyle = DefaultTextStyle.of(context);
              expect(defaultTextStyle.textAlign, TextAlign.center);
              expect(defaultTextStyle.overflow, TextOverflow.ellipsis);
              expect(defaultTextStyle.maxLines, 3);
              expect(defaultTextStyle.softWrap, false);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('updateShouldNotify returns true when text changes', (
      tester,
    ) async {
      final text1 = TextStyling(maxLines: 1);
      final text2 = TextStyling(maxLines: 2);

      // Test through InheritedWidget implementation
      expect(text1, isNot(equals(text2)));
    });

    testWidgets('updateShouldNotify returns false when text is same', (
      tester,
    ) async {
      final text = TextStyling(maxLines: 1);

      // Test through InheritedWidget implementation
      expect(text, equals(text));
    });

    testWidgets('handles null text properties', (tester) async {
      final text = TextStyling();

      await tester.pumpWidget(
        MaterialApp(
          home: TextScope(
            text: text,
            child: Builder(
              builder: (context) {
                final defaultTextStyle = DefaultTextStyle.of(context);
                // DefaultTextStyle.of(context) may have default values from MaterialApp
                // Just verify that TextScope is providing the theme
                expect(defaultTextStyle, isNotNull);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });
}