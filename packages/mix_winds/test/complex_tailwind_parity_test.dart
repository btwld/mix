import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';

import 'winds_test_helpers.dart';

const _blue500 = Color(0xFF2B7FFF);
const _blue900 = Color(0xFF1C398E);
const _pink500 = Color(0xFFF6339A);
const _purple500 = Color(0xFFAD46FF);
const _red500 = Color(0xFFFB2C36);
const _slate700 = Color(0xFF314158);
const _slate900 = Color(0xFF0F172B);

void main() {
  group('Tailwind CSS v4.3.1 complex runtime parity', () {
    testWidgets('01 card surface matches box-model and visual tokens', (
      tester,
    ) async {
      await _pumpLooseCanvas(
        tester,
        const Div(
          classNames:
              'w-80 h-48 p-6 bg-slate-900 border-2 border-slate-700 '
              'rounded-2xl shadow-lg',
          child: SizedBox(),
        ),
        width: 500,
        height: 400,
      );

      final finder = find.byType(Container);
      final container = tester.widget<Container>(finder);
      final decoration = container.decoration! as BoxDecoration;
      final border = decoration.border! as Border;
      final radius = decoration.borderRadius!.resolve(TextDirection.ltr);

      expect(tester.getSize(finder), const Size(320, 192));
      expect(container.padding, const EdgeInsets.all(24));
      expect(decoration.color, _slate900);
      expect(border.top.width, 2);
      expect(border.top.color, _slate700);
      expect(radius.topLeft, const Radius.circular(16));
      expect(decoration.boxShadow, const [
        BoxShadow(
          offset: Offset(0, 10),
          blurRadius: 15,
          spreadRadius: -3,
          color: Color(0x1A000000),
        ),
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 6,
          spreadRadius: -4,
          color: Color(0x1A000000),
        ),
      ]);
    });

    testWidgets('02 spacing specificity is independent of class order', (
      tester,
    ) async {
      for (final classNames in [
        'p-2 px-6 pt-4 m-2 mx-4 mt-8 bg-red-500',
        'bg-red-500 mt-8 mx-4 m-2 pt-4 px-6 p-2',
      ]) {
        await pumpDiv(
          tester,
          classNames,
          child: const SizedBox(width: 10, height: 10),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final paddings = tester
            .widgetList<Padding>(find.byType(Padding))
            .map((widget) => widget.padding)
            .toList();
        final decoration = container.decoration! as BoxDecoration;

        expect(container.padding, const EdgeInsets.fromLTRB(24, 16, 24, 8));
        expect(paddings, contains(const EdgeInsets.fromLTRB(16, 32, 16, 8)));
        expect(decoration.color, _red500);
      }
    });

    testWidgets(
      '03 arbitrary pixel, color, opacity, and transform values match',
      (tester) async {
        await _pumpLooseCanvas(
          tester,
          const Div(
            classNames:
                'w-[37px] h-[29px] bg-[#123456]/[50%] '
                'translate-x-[11px] -translate-y-[7px]',
            child: SizedBox(),
          ),
          width: 200,
          height: 200,
        );

        final finder = find.byType(Container);
        final container = tester.widget<Container>(finder);
        final decoration = container.decoration! as BoxDecoration;

        expect(tester.getSize(finder), const Size(37, 29));
        expect(decoration.color, const Color(0x80123456));
        expect(container.transform, isNotNull);
        expect(container.transform![12], closeTo(11, 0.000001));
        expect(container.transform![13], closeTo(-7, 0.000001));
      },
    );

    testWidgets(
      '04 rich typography preserves Tailwind line-height and em tracking',
      (tester) async {
        await pumpLtr(
          tester,
          const SizedBox(
            width: 180,
            child: Span(
              text: 'complex tailwind',
              classNames:
                  'text-2xl font-bold leading-tight tracking-tight '
                  'text-slate-700 uppercase text-center truncate',
            ),
          ),
        );

        final text = tester.widget<Text>(find.byType(Text));

        expect(text.data, 'COMPLEX TAILWIND');
        expect(text.style?.fontSize, 24);
        expect(text.style?.fontWeight, FontWeight.w700);
        // Tailwind keeps the explicit `leading-tight` override and resolves
        // `tracking-tight` (-0.025em) against the 24px font size.
        expect(
          [text.style?.height, text.style?.letterSpacing],
          [1.25, closeTo(-0.6, 0.000001)],
        );
        expect(text.style?.color, _slate700);
        expect(text.textAlign, TextAlign.center);
        expect(text.overflow, TextOverflow.ellipsis);
        expect(text.maxLines, 1);
        expect(text.softWrap, isFalse);
      },
    );

    testWidgets('05 v4 diagonal three-stop gradient matches CSS geometry', (
      tester,
    ) async {
      final decoration = await boxDecorationFor(
        tester,
        'bg-linear-to-br from-blue-500 via-purple-500 to-pink-500',
      );
      final gradient = decoration!.gradient! as LinearGradient;

      expect(gradient.colors, const [_blue500, _purple500, _pink500]);
      expect(gradient.stops, const [0, 0.5, 1]);
      expect(gradient.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
      expect(gradient.transform, isA<TwCssKeywordLinearTransform>());

      final rect = const Rect.fromLTWH(0, 0, 300, 120);
      final matrix = gradient.transform!.transform(rect)!;
      final center = rect.center;
      final transformedCenter = MatrixUtils.transformPoint(matrix, center);
      final transformedPoint = MatrixUtils.transformPoint(
        matrix,
        center + const Offset(1, 0),
      );
      final direction = transformedPoint - transformedCenter;

      expect(
        math.atan2(direction.dy, direction.dx),
        closeTo(math.atan2(rect.width, rect.height), 0.000001),
      );
    });

    testWidgets('06 composite translate rotate and scale matches CSS order', (
      tester,
    ) async {
      final container = await boxContainerFor(
        tester,
        'translate-x-4 -translate-y-2 rotate-45 scale-105',
      );
      final actual = container.transform!;
      expect(container.transformAlignment, Alignment.center);
      final expected =
          (Matrix4.identity()
                ..multiply(Matrix4.translationValues(16, -8, 0))
                ..multiply(Matrix4.rotationZ(math.pi / 4))
                ..multiply(Matrix4.diagonal3Values(1.05, 1.05, 1)))
              .storage;

      for (var index = 0; index < expected.length; index++) {
        expect(actual[index], closeTo(expected[index], 0.000001));
      }
    });

    testWidgets('07 responsive fractions follow md and lg breakpoints', (
      tester,
    ) async {
      Future<double> widthAt(double viewportWidth) async {
        await pumpSized(
          tester,
          const Div(
            classNames: 'w-full md:w-1/2 lg:w-1/3 h-12 bg-blue-500',
            child: SizedBox(),
          ),
          width: viewportWidth,
          height: 200,
        );
        return tester.getSize(find.byType(Container)).width;
      }

      expect(await widthAt(600), closeTo(600, 0.000001));
      expect(await widthAt(900), closeTo(450, 0.000001));
      expect(await widthAt(1200), closeTo(400, 0.000001));
    });

    testWidgets('08 responsive flex direction and gap match Tailwind', (
      tester,
    ) async {
      Future<Flex> flexAt(double viewportWidth) async {
        await pumpSized(
          tester,
          const Div(
            classNames:
                'flex flex-col gap-2 md:flex-row md:gap-6 '
                'items-center justify-between',
            children: [
              SizedBox(width: 40, height: 20),
              SizedBox(width: 40, height: 20),
              SizedBox(width: 40, height: 20),
            ],
          ),
          width: viewportWidth,
          height: 200,
        );
        return tester.widget<Flex>(find.byType(Flex));
      }

      final mobile = await flexAt(600);
      expect(mobile.direction, Axis.vertical);
      expect(mobile.spacing, 8);
      expect(mobile.crossAxisAlignment, CrossAxisAlignment.center);
      expect(mobile.mainAxisAlignment, MainAxisAlignment.spaceBetween);

      final desktop = await flexAt(900);
      expect(desktop.direction, Axis.horizontal);
      expect(desktop.spacing, 24);
      expect(desktop.crossAxisAlignment, CrossAxisAlignment.center);
      expect(desktop.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });

    testWidgets('09 dark hover compound variant responds to pointer hover', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            size: Size(400, 300),
            platformBrightness: Brightness.dark,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: Div(
                classNames:
                    'w-24 h-24 bg-white dark:bg-slate-900 '
                    'dark:hover:bg-blue-900',
                child: SizedBox(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final finder = find.byType(Container);
      Color? color() =>
          (tester.widget<Container>(finder).decoration! as BoxDecoration).color;

      expect(color(), _slate900);

      final gesture = await createOffscreenMouseGesture(tester);
      await gesture.moveTo(tester.getCenter(finder));
      await tester.pump();

      expect(color(), _blue900);

      await gesture.removePointer();
    });

    testWidgets('10 delayed color transition follows Tailwind timing', (
      tester,
    ) async {
      await pumpDiv(
        tester,
        'w-24 h-24 bg-red-500 hover:bg-blue-500 transition-colors '
        'duration-300 ease-in-out delay-100',
        child: const SizedBox(),
      );

      final finder = find.byType(Container);
      Color? color() =>
          (tester.widget<Container>(finder).decoration! as BoxDecoration).color;

      expect(color(), _red500);

      final gesture = await createOffscreenMouseGesture(tester);
      await gesture.moveTo(tester.getCenter(finder));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(color(), _red500);

      await tester.pump(const Duration(milliseconds: 100));
      expect(color(), isNot(_red500));
      expect(color(), isNot(_blue500));

      await tester.pump(const Duration(milliseconds: 300));
      expect(color(), _blue500);

      await gesture.removePointer();
    });
  });
}

Future<void> _pumpLooseCanvas(
  WidgetTester tester,
  Widget child, {
  required double width,
  required double height,
}) async {
  await tester.binding.setSurfaceSize(Size(width, height));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: Size(width, height)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: child),
      ),
    ),
  );
  await tester.pump();
}
