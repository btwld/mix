import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';

import 'winds_test_helpers.dart';

Finder _paintedBox(String key) =>
    find.descendant(of: find.byKey(Key(key)), matching: find.byType(Container));

double _width(WidgetTester tester, String key) =>
    tester.getSize(_paintedBox(key)).width;

double _height(WidgetTester tester, String key) =>
    tester.getSize(_paintedBox(key)).height;

Future<(double, double)> _twoItemWidths(
  WidgetTester tester, {
  required double containerWidth,
  required String firstClasses,
  required String secondClasses,
}) async {
  await pumpSized(
    tester,
    Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: containerWidth,
        child: Div(
          classNames: 'flex',
          children: [
            Div(key: const Key('a'), classNames: firstClasses),
            Div(key: const Key('b'), classNames: secondClasses),
          ],
        ),
      ),
    ),
    width: 1000,
  );

  return (_width(tester, 'a'), _width(tester, 'b'));
}

void main() {
  group('CSS zero-basis flex sizing', () {
    testWidgets(
      'reserves unequal horizontal padding and border before growing',
      (tester) async {
        await pumpSized(
          tester,
          const Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 900,
              child: Div(
                classNames: 'flex',
                children: [
                  Div(key: Key('a'), classNames: 'flex-1 border px-5'),
                  Div(key: Key('b'), classNames: 'flex-1'),
                ],
              ),
            ),
          ),
          width: 1000,
        );

        // Browser reference: 900px minus A's 42px padding + border leaves
        // 858px of content space. Each item receives 429px of content.
        expect(_width(tester, 'a'), closeTo(471, 0.01));
        expect(_width(tester, 'b'), closeTo(429, 0.01));
      },
    );

    testWidgets('keeps a fixed sibling and gap outside distributed space', (
      tester,
    ) async {
      await pumpSized(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 900,
            child: Div(
              classNames: 'flex gap-5',
              children: [
                Div(key: Key('fixed'), classNames: 'w-[100px] shrink-0'),
                Div(key: Key('a'), classNames: 'flex-1 border px-5'),
                Div(key: Key('b'), classNames: 'flex-1'),
              ],
            ),
          ),
        ),
        width: 1000,
      );

      expect(_width(tester, 'fixed'), 100);
      expect(_width(tester, 'a'), closeTo(401, 0.01));
      expect(_width(tester, 'b'), closeTo(359, 0.01));
    });

    testWidgets('uses the same content-box distribution on the vertical axis', (
      tester,
    ) async {
      await pumpSized(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 100,
            height: 900,
            child: Div(
              classNames: 'flex flex-col',
              children: [
                Div(key: Key('a'), classNames: 'flex-1 border py-5'),
                Div(key: Key('b'), classNames: 'flex-1'),
              ],
            ),
          ),
        ),
        width: 1000,
        height: 1000,
      );

      expect(_height(tester, 'a'), closeTo(471, 0.01));
      expect(_height(tester, 'b'), closeTo(429, 0.01));
    });

    testWidgets('keeps equal chrome at an even split', (tester) async {
      await pumpSized(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 900,
            child: Div(
              classNames: 'flex',
              children: [
                Div(key: Key('a'), classNames: 'flex-1 border px-5'),
                Div(key: Key('b'), classNames: 'flex-1 border px-5'),
              ],
            ),
          ),
        ),
        width: 1000,
      );

      expect(_width(tester, 'a'), closeTo(450, 0.01));
      expect(_width(tester, 'b'), closeTo(450, 0.01));
    });

    testWidgets('reserves margin outside equal content widths', (tester) async {
      await pumpSized(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 900,
            child: Div(
              classNames: 'flex',
              children: [
                Div(key: Key('a'), classNames: 'flex-1 ml-10'),
                Div(key: Key('b'), classNames: 'flex-1'),
              ],
            ),
          ),
        ),
        width: 1000,
      );

      expect(_width(tester, 'a'), closeTo(430, 0.01));
      expect(_width(tester, 'b'), closeTo(430, 0.01));
      expect(
        tester.getTopLeft(_paintedBox('a')).dx,
        closeTo(tester.getTopLeft(_paintedBox('b')).dx - 430, 0.01),
      );
    });

    testWidgets('basis longhand overrides flex shorthand in either order', (
      tester,
    ) async {
      final forward = await _twoItemWidths(
        tester,
        containerWidth: 600,
        firstClasses: 'flex-1 basis-32 border px-5',
        secondClasses: 'basis-32 flex-1',
      );
      expect(forward.$1, closeTo(300, 0.01));
      expect(forward.$2, closeTo(300, 0.01));

      final reversed = await _twoItemWidths(
        tester,
        containerWidth: 600,
        firstClasses: 'basis-32 flex-1 border px-5',
        secondClasses: 'basis-32 flex-1',
      );
      expect(reversed.$1, closeTo(300, 0.01));
      expect(reversed.$2, closeTo(300, 0.01));
    });

    testWidgets('responsive declarations outrank lower-breakpoint longhands', (
      tester,
    ) async {
      // At md, the shorthand replaces the base basis and grow longhands.
      final responsiveShorthand = await _twoItemWidths(
        tester,
        containerWidth: 900,
        firstClasses: 'basis-32 grow-0 md:flex-1 border px-5',
        secondClasses: 'basis-32 grow-0 md:flex-1',
      );
      expect(responsiveShorthand.$1, closeTo(471, 0.01));
      expect(responsiveShorthand.$2, closeTo(429, 0.01));

      // Conversely, an md basis longhand replaces the base shorthand's basis.
      final responsiveLonghand = await _twoItemWidths(
        tester,
        containerWidth: 900,
        firstClasses: 'flex-1 md:basis-32 border px-5',
        secondClasses: 'flex-1 md:basis-32',
      );
      expect(responsiveLonghand.$1, closeTo(450, 0.01));
      expect(responsiveLonghand.$2, closeTo(450, 0.01));
    });

    testWidgets('composes with per-child cross-axis alignment', (tester) async {
      await pumpSized(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 900,
            height: 100,
            child: Div(
              classNames: 'flex items-start',
              children: [
                Div(
                  key: Key('a'),
                  classNames: 'flex-1 self-end h-5 border px-5',
                ),
                Div(key: Key('b'), classNames: 'flex-1 h-20'),
              ],
            ),
          ),
        ),
        width: 1000,
      );

      expect(_width(tester, 'a'), closeTo(471, 0.01));
      expect(_width(tester, 'b'), closeTo(429, 0.01));
      expect(tester.getTopLeft(_paintedBox('a')).dy, 80);
      expect(tester.getTopLeft(_paintedBox('b')).dy, 0);
    });

    testWidgets('keeps native Row compatibility on Flutter distribution', (
      tester,
    ) async {
      await pumpSized(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 900,
            child: Row(
              children: [
                Div(key: Key('a'), classNames: 'flex-1 border px-5'),
                Div(key: Key('b'), classNames: 'flex-1'),
              ],
            ),
          ),
        ),
        width: 1000,
      );

      expect(_width(tester, 'a'), closeTo(450, 0.01));
      expect(_width(tester, 'b'), closeTo(450, 0.01));
    });

    testWidgets('uses a direct child explicit config for its outer size', (
      tester,
    ) async {
      final standard = TwConfig.standard();
      final childConfig = standard.copyWith(
        space: {...standard.space, '5': 30},
      );

      await pumpSized(
        tester,
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 900,
            child: Div(
              classNames: 'flex',
              children: [
                Div(
                  key: const Key('a'),
                  classNames: 'flex-1 border px-5',
                  config: childConfig,
                ),
                const Div(key: Key('b'), classNames: 'flex-1'),
              ],
            ),
          ),
        ),
        width: 1000,
      );

      expect(_width(tester, 'a'), closeTo(481, 0.01));
      expect(_width(tester, 'b'), closeTo(419, 0.01));
    });
  });
}
