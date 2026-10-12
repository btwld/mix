import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';

void main() {
  for (final (name, child) in <(String, Widget)>[
    ('paragraph', const P(text: 'Label', classNames: 'mb-4')),
    ('heading', const H1(text: 'Label', classNames: 'mb-4')),
    ('span', const Span(text: 'Label', classNames: 'p-4')),
    (
      'icon',
      const TwIcon(
        IconData(0xe047, fontFamily: 'MaterialIcons'),
        classNames: 'me-1',
      ),
    ),
  ]) {
    for (final axis in Axis.values) {
      testWidgets('$name supports intrinsic ${axis.name} measurement', (
        tester,
      ) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(),
            child: Directionality(
              textDirection: .ltr,
              child: Center(
                child: axis == .horizontal
                    ? IntrinsicWidth(child: child)
                    : IntrinsicHeight(child: child),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        final size = tester.getSize(find.byWidget(child));
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(0));
        expect(size.isFinite, isTrue);
      });
    }
  }

  for (final (name, child, axis) in <(String, Widget, Axis)>[
    (
      'paragraph',
      const P(text: 'Label', classNames: 'mb-2 md:mb-4'),
      .vertical,
    ),
    ('heading', const H1(text: 'Label', classNames: 'mb-2 md:mb-4'), .vertical),
    (
      'span',
      const Span(text: 'Label', classNames: 'p-4 mb-2 md:mb-4'),
      .vertical,
    ),
    (
      'icon',
      const TwIcon(
        IconData(0xe047, fontFamily: 'MaterialIcons'),
        classNames: 'me-2 md:me-4',
      ),
      .horizontal,
    ),
  ]) {
    testWidgets('$name updates viewport margins inside intrinsic sizing', (
      tester,
    ) async {
      final sizes = <Size>[];
      for (final width in [400.0, 1000.0, 400.0]) {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(size: Size(width, 600)),
            child: Directionality(
              textDirection: .ltr,
              child: Center(
                child: IntrinsicWidth(child: IntrinsicHeight(child: child)),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        sizes.add(tester.getSize(find.byWidget(child)));
      }

      final delta = axis == .horizontal
          ? sizes[1].width - sizes[0].width
          : sizes[1].height - sizes[0].height;
      expect(delta, closeTo(8, 0.001));
      expect(sizes[2], sizes[0]);
    });
    testWidgets('$name uses flex scope margins inside intrinsic sizing', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      Size? baseSize;
      for (final (viewport, width, margin) in [
        (0.0, 400.0, 8.0),
        (0.0, 1000.0, 16.0),
        (400.0, 1000.0, 8.0),
        (0.0, 1000.0, 16.0),
        (0.0, 400.0, 8.0),
      ]) {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(size: Size(viewport, 600)),
            child: Directionality(
              textDirection: .ltr,
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: width,
                  child: Div(
                    classNames: 'flex items-start',
                    children: [
                      IntrinsicWidth(child: IntrinsicHeight(child: child)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        final size = tester.getSize(find.byWidget(child));
        expect(size.isFinite, isTrue);
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(0));
        baseSize ??= size;
        expect(
          axis == .horizontal ? size.width : size.height,
          closeTo(
            (axis == .horizontal ? baseSize.width : baseSize.height) +
                margin -
                8,
            0.001,
          ),
        );
      }
    });
  }

  testWidgets(
    'responsive margins retain the constraint fallback without a viewport width',
    (tester) async {
      for (final (width, margin) in [
        (400.0, 8.0),
        (800.0, 16.0),
        (400.0, 8.0),
      ]) {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(),
            child: Directionality(
              textDirection: .ltr,
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: width,
                  child: const P(text: 'Label', classNames: 'mb-2 md:mb-4'),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(
          tester.widget<Padding>(find.byType(Padding)).padding,
          EdgeInsets.only(bottom: margin),
        );
      }
    },
  );
}
