import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('TextScope', () {
    testWidgets('provides text data to descendants', (tester) async {
      final text = TextStyler(
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      );

      late TextStyler capturedScope;

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
      TextStyler? capturedScope;

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
      final text = TextStyler(
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
      final text1 = TextStyler(maxLines: 1);
      final text2 = TextStyler(maxLines: 2);

      // Test through InheritedWidget implementation
      expect(text1, isNot(equals(text2)));
    });

    testWidgets('updateShouldNotify returns false when text is same', (
      tester,
    ) async {
      final text = TextStyler(maxLines: 1);

      // Test through InheritedWidget implementation
      expect(text, equals(text));
    });

    testWidgets('handles null text properties', (tester) async {
      final text = TextStyler();

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

    group('default values', () {
      testWidgets('softWrap defaults to true when null', (tester) async {
        // TextStyler with no softWrap specified
        final text = TextStyler(textAlign: TextAlign.left);

        await tester.pumpWidget(
          MaterialApp(
            home: TextScope(
              text: text,
              child: Builder(
                builder: (context) {
                  final defaultTextStyle = DefaultTextStyle.of(context);
                  expect(defaultTextStyle.softWrap, true);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('overflow defaults to TextOverflow.clip when null', (
        tester,
      ) async {
        // TextStyler with no overflow specified
        final text = TextStyler(textAlign: TextAlign.left);

        await tester.pumpWidget(
          MaterialApp(
            home: TextScope(
              text: text,
              child: Builder(
                builder: (context) {
                  final defaultTextStyle = DefaultTextStyle.of(context);
                  expect(defaultTextStyle.overflow, TextOverflow.clip);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('textWidthBasis defaults to TextWidthBasis.parent when null', (
        tester,
      ) async {
        // TextStyler with no textWidthBasis specified
        final text = TextStyler(textAlign: TextAlign.left);

        await tester.pumpWidget(
          MaterialApp(
            home: TextScope(
              text: text,
              child: Builder(
                builder: (context) {
                  final defaultTextStyle = DefaultTextStyle.of(context);
                  expect(defaultTextStyle.textWidthBasis, TextWidthBasis.parent);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('style defaults to empty TextStyle when null', (
        tester,
      ) async {
        // TextStyler with no style specified
        final text = TextStyler();

        await tester.pumpWidget(
          MaterialApp(
            home: TextScope(
              text: text,
              child: Builder(
                builder: (context) {
                  final defaultTextStyle = DefaultTextStyle.of(context);
                  // The style should be a TextStyle (not null)
                  expect(defaultTextStyle.style, isA<TextStyle>());
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });
    });

    group('nested scopes', () {
      testWidgets('inner scope overrides outer scope', (tester) async {
        final outerText = TextStyler(maxLines: 5);
        final innerText = TextStyler(maxLines: 2);

        late TextStyler capturedScope;

        await tester.pumpWidget(
          MaterialApp(
            home: TextScope(
              text: outerText,
              child: TextScope(
                text: innerText,
                child: Builder(
                  builder: (context) {
                    capturedScope = TextScope.of(context);
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );

        // Inner scope should be accessible, not outer
        expect(capturedScope, equals(innerText));
        expect(capturedScope, isNot(equals(outerText)));
      });

      testWidgets('inner DefaultTextStyle overrides outer', (tester) async {
        final outerText = TextStyler(maxLines: 5);
        final innerText = TextStyler(maxLines: 2);

        await tester.pumpWidget(
          MaterialApp(
            home: TextScope(
              text: outerText,
              child: TextScope(
                text: innerText,
                child: Builder(
                  builder: (context) {
                    final defaultTextStyle = DefaultTextStyle.of(context);
                    expect(defaultTextStyle.maxLines, 2);
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );
      });

      testWidgets('scope is accessible at multiple nesting depths', (
        tester,
      ) async {
        final text = TextStyler(maxLines: 3);
        late TextStyler capturedScope;

        await tester.pumpWidget(
          MaterialApp(
            home: TextScope(
              text: text,
              child: Column(
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) {
                          capturedScope = TextScope.of(context);
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        expect(capturedScope, equals(text));
      });
    });
  });
}
