import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('WrapBox geometry', () {
    testWidgets(
      'forces a second run with exact spacing, run spacing, alignment, and padding',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Align(
              alignment: .topLeft,
              child: SizedBox(
                key: const Key('host'),
                width: 130,
                height: 100,
                child: WrapBox(
                  style: WrapBoxStyler()
                      .paddingAll(10)
                      .spacing(10)
                      .runSpacing(12)
                      .wrapAlignment(.center),
                  children: const [
                    SizedBox(key: Key('c1'), width: 50, height: 20),
                    SizedBox(key: Key('c2'), width: 50, height: 20),
                    SizedBox(key: Key('c3'), width: 50, height: 20),
                  ],
                ),
              ),
            ),
          ),
        );

        final host = tester.getTopLeft(find.byKey(const Key('host')));
        final c1 = tester.getTopLeft(find.byKey(const Key('c1')));
        final c2 = tester.getTopLeft(find.byKey(const Key('c2')));
        final c3 = tester.getTopLeft(find.byKey(const Key('c3')));

        expect(c1 - host, const Offset(10, 10));
        expect(c2 - c1, const Offset(60, 0));
        expect(c3 - c1, const Offset(30, 32));
      },
    );

    testWidgets('vertical Wrap uses exact item and run spacing', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: .topLeft,
            child: SizedBox(
              width: 100,
              height: 50,
              child: WrapBox(
                style: WrapBoxStyler(
                  direction: .vertical,
                  spacing: 10,
                  runSpacing: 12,
                  textDirection: .ltr,
                  verticalDirection: .down,
                ),
                children: const [
                  SizedBox(key: Key('v1'), width: 20, height: 20),
                  SizedBox(key: Key('v2'), width: 20, height: 20),
                  SizedBox(key: Key('v3'), width: 20, height: 20),
                ],
              ),
            ),
          ),
        ),
      );

      final v1 = tester.getTopLeft(find.byKey(const Key('v1')));
      final v2 = tester.getTopLeft(find.byKey(const Key('v2')));
      final v3 = tester.getTopLeft(find.byKey(const Key('v3')));

      expect(v2 - v1, const Offset(0, 30));
      expect(v3 - v1, const Offset(32, 0));
    });

    testWidgets('RTL and upward ordering reverse the corresponding axes', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: .topLeft,
            child: SizedBox(
              width: 110,
              height: 50,
              child: WrapBox(
                style: WrapBoxStyler(
                  spacing: 10,
                  runSpacing: 10,
                  textDirection: .rtl,
                  verticalDirection: .up,
                ),
                children: const [
                  SizedBox(key: Key('r1'), width: 50, height: 20),
                  SizedBox(key: Key('r2'), width: 50, height: 20),
                  SizedBox(key: Key('r3'), width: 50, height: 20),
                ],
              ),
            ),
          ),
        ),
      );

      final r1 = tester.getTopLeft(find.byKey(const Key('r1')));
      final r2 = tester.getTopLeft(find.byKey(const Key('r2')));
      final r3 = tester.getTopLeft(find.byKey(const Key('r3')));

      expect(r1.dx, greaterThan(r2.dx));
      expect(r1.dy, greaterThan(r3.dy));
    });

    testWidgets('wrapClipBehavior controls actual overflow painting', (
      tester,
    ) async {
      Widget build(Clip clipBehavior) {
        return MaterialApp(
          home: Align(
            alignment: .topLeft,
            child: SizedBox(
              width: 100,
              height: 50,
              child: WrapBox(
                style: WrapBoxStyler.wrapClipBehavior(clipBehavior),
                children: const [
                  SizedBox(width: 80, height: 40),
                  SizedBox(width: 80, height: 40),
                ],
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(build(.none));
      expect(
        tester.renderObject<RenderBox>(find.byType(Wrap)),
        isNot(paints..clipRect()),
      );

      await tester.pumpWidget(build(.hardEdge));
      expect(
        tester.renderObject<RenderBox>(find.byType(Wrap)),
        paints..clipRect(),
      );
    });

    testWidgets('uses Flutter-compatible defaults when Wrap fields are unset', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: .rtl,
          child: WrapBox(children: [SizedBox(width: 10, height: 10)]),
        ),
      );

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.direction, Axis.horizontal);
      expect(wrap.alignment, WrapAlignment.start);
      expect(wrap.spacing, 0);
      expect(wrap.runAlignment, WrapAlignment.start);
      expect(wrap.runSpacing, 0);
      expect(wrap.crossAxisAlignment, WrapCrossAlignment.start);
      expect(wrap.textDirection, isNull);
      expect(wrap.verticalDirection, VerticalDirection.down);
      expect(wrap.clipBehavior, Clip.none);
    });
  });
}
