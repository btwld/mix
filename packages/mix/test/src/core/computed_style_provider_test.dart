import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

// Helper to create ComputedStyle from Style
ComputedStyle _computeStyle(Style style) {
  final mixData = MixContext.create(MockBuildContext(), style);

  return ComputedStyle.compute(mixData);
}

// Helper to create a test provider
Widget _createProvider(ComputedStyle style, Widget child) {
  return ComputedStyleProvider(style: style, child: child);
}

void main() {
  group('ComputedStyleProvider', () {
    group('Provider Construction', () {
      test('creates provider with required style and child', () {
        final style = _computeStyle(Style($box.color(Colors.red)));
        const child = SizedBox();
        final provider = ComputedStyleProvider(style: style, child: child);

        expect(provider.style, equals(style));
        expect(provider.child, equals(child));
      });
    });

    group('Static Access Methods', () {
      testWidgets('of() returns ComputedStyle from provider', (tester) async {
        final style = _computeStyle(Style($box.color(Colors.blue)));

        await tester.pumpWidget(
          _createProvider(
            style,
            Builder(
              builder: (context) {
                final computedStyle = ComputedStyle.of(context);
                expect(computedStyle, equals(style));

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('maybeOf() returns null when no provider exists',
          (tester) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              final computedStyle = ComputedStyle.maybeOf(context);
              expect(computedStyle, isNull);

              return const SizedBox();
            },
          ),
        );
      });

      testWidgets('of() throws assertion when no provider exists',
          (tester) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              expect(() => ComputedStyle.of(context), throwsAssertionError);

              return const SizedBox();
            },
          ),
        );
      });

      testWidgets('specOf() returns specific spec type', (tester) async {
        final style = _computeStyle(Style(
          $box.color(Colors.red),
          $text.style.fontSize(16),
        ));

        await tester.pumpWidget(
          _createProvider(
            style,
            Builder(
              builder: (context) {
                final boxSpec = ComputedStyle.specOf<BoxSpec>(context);
                final textSpec = ComputedStyle.specOf<TextSpec>(context);
                final iconSpec = ComputedStyle.specOf<IconSpec>(context);

                expect(boxSpec, isA<BoxSpec>());
                expect(textSpec, isA<TextSpec>());
                expect(iconSpec, isNull);

                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('updateShouldNotify', () {
      test('returns true when style changes', () {
        final oldStyle = _computeStyle(Style($box.color(Colors.red)));
        final newStyle = _computeStyle(Style($box.color(Colors.blue)));

        final oldProvider =
            ComputedStyleProvider(style: oldStyle, child: const SizedBox());
        final newProvider =
            ComputedStyleProvider(style: newStyle, child: const SizedBox());

        expect(newProvider.updateShouldNotify(oldProvider), isTrue);
      });

      test('returns false when style is the same', () {
        final style = _computeStyle(Style($box.color(Colors.red)));

        final oldProvider =
            ComputedStyleProvider(style: style, child: const SizedBox());
        final newProvider =
            ComputedStyleProvider(style: style, child: const SizedBox());

        expect(newProvider.updateShouldNotify(oldProvider), isFalse);
      });
    });

    group('updateShouldNotifyDependent', () {
      test('returns true when dependent spec type changes', () {
        final oldStyle = _computeStyle(Style($box.color(Colors.red)));
        final newStyle = _computeStyle(Style($box.color(Colors.blue)));

        final oldProvider =
            ComputedStyleProvider(style: oldStyle, child: const SizedBox());
        final newProvider =
            ComputedStyleProvider(style: newStyle, child: const SizedBox());

        // Widget depends on BoxSpec, and BoxSpec changed
        expect(
          newProvider.updateShouldNotifyDependent(oldProvider, {BoxSpec}),
          isTrue,
        );
      });

      test('returns false when dependent spec type unchanged', () {
        final oldStyle = _computeStyle(Style($box.color(Colors.red)));
        final newStyle = _computeStyle(Style($box.color(Colors.red)));

        final oldProvider =
            ComputedStyleProvider(style: oldStyle, child: const SizedBox());
        final newProvider =
            ComputedStyleProvider(style: newStyle, child: const SizedBox());

        // Widget depends on BoxSpec, but BoxSpec unchanged
        expect(
          newProvider.updateShouldNotifyDependent(oldProvider, {BoxSpec}),
          isFalse,
        );
      });

      test('returns false when non-dependent spec type changes', () {
        final oldStyle = _computeStyle(Style($box.color(Colors.red)));
        final newStyle = _computeStyle(Style($box.color(Colors.blue)));

        final oldProvider =
            ComputedStyleProvider(style: oldStyle, child: const SizedBox());
        final newProvider =
            ComputedStyleProvider(style: newStyle, child: const SizedBox());

        // Widget depends on TextSpec, but BoxSpec changed
        expect(
          newProvider.updateShouldNotifyDependent(oldProvider, {TextSpec}),
          isFalse,
        );
      });

      test('returns true when any dependent spec type changes', () {
        final oldStyle = _computeStyle(Style(
          $box.color(Colors.red),
          $text.style.fontSize(14),
        ));
        final newStyle = _computeStyle(Style(
          $box.color(Colors.red),
          $text.style.fontSize(16), // TextSpec changed
        ));

        final oldProvider =
            ComputedStyleProvider(style: oldStyle, child: const SizedBox());
        final newProvider =
            ComputedStyleProvider(style: newStyle, child: const SizedBox());

        // Widget depends on both BoxSpec and TextSpec, TextSpec changed
        expect(
          newProvider
              .updateShouldNotifyDependent(oldProvider, {BoxSpec, TextSpec}),
          isTrue,
        );
      });

      test('handles empty dependencies', () {
        final oldStyle = _computeStyle(Style($box.color(Colors.red)));
        final newStyle = _computeStyle(Style($box.color(Colors.blue)));

        final oldProvider =
            ComputedStyleProvider(style: oldStyle, child: const SizedBox());
        final newProvider =
            ComputedStyleProvider(style: newStyle, child: const SizedBox());

        // No dependencies means no rebuilds
        expect(
          newProvider.updateShouldNotifyDependent(oldProvider, {}),
          isFalse,
        );
      });
    });

    group('Provider Inheritance', () {
      testWidgets('nested providers work correctly', (tester) async {
        final outerStyle = _computeStyle(Style($box.color(Colors.blue)));
        final innerStyle = _computeStyle(Style($box.color(Colors.red)));

        await tester.pumpWidget(
          _createProvider(
            outerStyle,
            _createProvider(
              innerStyle,
              Builder(
                builder: (context) {
                  final computedStyle = ComputedStyle.of(context);
                  expect(
                    computedStyle,
                    equals(innerStyle),
                  ); // Inner provider wins

                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });
    });

    group('Edge Cases', () {
      test('handles spec addition and removal', () {
        final oldStyle = _computeStyle(Style($box.color(Colors.red)));
        final newStyle = _computeStyle(Style(
          $box.color(Colors.red),
          $text.style.fontSize(16), // Added TextSpec
        ));

        final oldProvider =
            ComputedStyleProvider(style: oldStyle, child: const SizedBox());
        final newProvider =
            ComputedStyleProvider(style: newStyle, child: const SizedBox());

        // Adding a spec should notify dependents of that spec
        expect(
          newProvider.updateShouldNotifyDependent(oldProvider, {TextSpec}),
          isTrue,
        );

        // But not dependents of unchanged specs
        expect(
          newProvider.updateShouldNotifyDependent(oldProvider, {BoxSpec}),
          isFalse,
        );
      });

      test('handles null spec comparisons', () {
        final styleWithBox = _computeStyle(Style($box.color(Colors.red)));
        final styleWithoutBox = _computeStyle(Style($text.style.fontSize(16)));

        final oldProvider = ComputedStyleProvider(
          style: styleWithoutBox,
          child: const SizedBox(),
        );
        final newProvider =
            ComputedStyleProvider(style: styleWithBox, child: const SizedBox());

        // Adding BoxSpec when it didn't exist before
        expect(
          newProvider.updateShouldNotifyDependent(oldProvider, {BoxSpec}),
          isTrue,
        );
      });
    });
  });
}
