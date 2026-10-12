import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_winds/mix_winds.dart';
import 'package:mix_winds/src/translate/tw_translator.dart';

import 'winds_test_helpers.dart';

bool _classesWantFlex(Set<String> tokens) => TwTranslator(
  config: TwConfig.standard(),
).compileForWidget(tokens.join(' '), .boxOrFlex).wantsFlex;

Future<FlexParentData> _rowParentDataForDiv(
  WidgetTester tester,
  String classNames, {
  TokenWarningCallback? onUnsupported,
}) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: 200,
        child: Row(
          children: [
            Div(
              classNames: classNames,
              onUnsupported: onUnsupported,
              child: const SizedBox(width: 10, height: 10),
            ),
            const SizedBox(width: 20, height: 20),
          ],
        ),
      ),
    ),
  );

  final renderFlex = tester.renderObject<RenderFlex>(find.byType(Row));
  final firstChild = renderFlex.firstChild!;
  return firstChild.parentData as FlexParentData;
}

void main() {
  testWidgets('Div picks flex layout when flex token is present', (
    tester,
  ) async {
    await pumpLtr(
      tester,
      Div(classNames: 'flex gap-4', children: const [SizedBox(), SizedBox()]),
    );

    // CSS semantic widgets use Flex directly instead of FlexBox
    expect(find.byType(Flex), findsOneWidget);
  });

  testWidgets('Div picks flex layout when only md:flex token is present', (
    tester,
  ) async {
    await pumpLtr(
      tester,
      Div(
        classNames: 'md:flex gap-4',
        children: const [SizedBox(), SizedBox()],
      ),
    );

    // CSS semantic widgets use Flex directly instead of FlexBox
    expect(find.byType(Flex), findsOneWidget);
  });

  testWidgets('Div defaults to box layout when flex tokens missing', (
    tester,
  ) async {
    await pumpDiv(tester, 'bg-blue-500 p-4', child: const SizedBox());

    // CSS semantic widgets use Container directly; no Flex when not in flex mode
    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(Flex), findsNothing);
  });

  testWidgets('Div wraps multiple children in Column', (tester) async {
    await pumpLtr(
      tester,
      Div(classNames: 'p-4', children: const [Text('First'), Text('Second')]),
    );

    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Row), findsNothing);
  });

  testWidgets('w-full does not crash inside Row', (tester) async {
    await pumpLtr(
      tester,
      SizedBox(
        width: 200,
        child: Row(
          children: [
            Expanded(
              child: Div(
                classNames: 'w-full bg-blue-500',
                child: const Text('Should not crash'),
              ),
            ),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Should not crash'), findsOneWidget);
  });

  testWidgets('w-full expands to parent width inside Row', (tester) async {
    await pumpLtr(
      tester,
      SizedBox(
        width: 180,
        child: Row(
          children: [
            Expanded(
              child: Div(
                classNames: 'w-full bg-blue-500',
                child: const SizedBox(height: 10),
              ),
            ),
          ],
        ),
      ),
    );

    final boxFinder = find.descendant(
      of: find.byType(Row),
      matching: find.byType(Container),
    );
    final boxSize = tester.getSize(boxFinder);
    final rowSize = tester.getSize(find.byType(Row));
    expect(boxSize.width, rowSize.width);
  });

  testWidgets('w-full inside Row respects padded available width', (
    tester,
  ) async {
    await pumpSized(
      tester,
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: const [
            Div(classNames: 'w-full bg-blue-500', child: SizedBox(height: 10)),
          ],
        ),
      ),
      width: 260,
      height: 120,
    );

    expect(tester.takeException(), isNull);

    final boxFinder = find.descendant(
      of: find.byType(Row),
      matching: find.byType(Container),
    );
    final boxSize = tester.getSize(boxFinder);
    expect(boxSize.width, closeTo(260 - 32, 0.0001));
  });

  testWidgets('basis-auto preserves w-full expansion inside Row', (
    tester,
  ) async {
    await pumpSized(
      tester,
      Row(
        children: [
          Div(
            classNames: 'w-full basis-auto bg-blue-500',
            child: const SizedBox(height: 10),
          ),
          const SizedBox(width: 20, height: 20),
        ],
      ),
      width: 200,
      height: 80,
    );

    expect(tester.takeException(), isNull);
    final boxFinder = find.descendant(
      of: find.byType(Row),
      matching: find.byType(Container),
    );
    expect(tester.getSize(boxFinder).width, closeTo(180, 0.0001));
  });

  testWidgets('h-full does not crash inside Column', (tester) async {
    await pumpLtr(
      tester,
      SizedBox(
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: Div(
                classNames: 'h-full bg-blue-500',
                child: const Text('Should not crash'),
              ),
            ),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Should not crash'), findsOneWidget);
  });

  testWidgets('h-full expands to parent height inside Column', (tester) async {
    await pumpLtr(
      tester,
      SizedBox(
        height: 180,
        child: Column(
          children: [
            Expanded(
              child: Div(
                classNames: 'h-full bg-blue-500',
                child: const SizedBox(width: 10),
              ),
            ),
          ],
        ),
      ),
    );

    final boxFinder = find.descendant(
      of: find.byType(Column),
      matching: find.byType(Container),
    );
    final boxSize = tester.getSize(boxFinder);
    final columnSize = tester.getSize(find.byType(Column));
    expect(boxSize.height, columnSize.height);
  });

  testWidgets('md:w-full is also guarded', (tester) async {
    await pumpLtr(
      tester,
      SizedBox(
        width: 220,
        child: Row(
          children: [
            Expanded(
              child: Div(
                classNames: 'md:w-full bg-blue-500',
                child: const SizedBox(height: 10),
              ),
            ),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('flex container respects w-full wrapper', (tester) async {
    await pumpSized(
      tester,
      Div(
        classNames: 'flex w-full bg-blue-500',
        children: const [
          SizedBox(width: 20, height: 20),
          SizedBox(width: 20, height: 20),
        ],
      ),
      width: 260,
    );

    final flexFinder = find.descendant(
      of: find.byType(Div),
      matching: find.byType(Flex),
    );
    final flexSize = tester.getSize(flexFinder);
    expect(flexSize.width, closeTo(260, 0.0001));
  });

  testWidgets('flex container applies fractional width tokens', (tester) async {
    await pumpSized(
      tester,
      Div(
        classNames: 'flex w-1/2 bg-blue-500',
        children: const [
          SizedBox(width: 20, height: 20),
          SizedBox(width: 20, height: 20),
        ],
      ),
      width: 200,
    );

    final flexFinder = find.descendant(
      of: find.byType(Div),
      matching: find.byType(Flex),
    );
    final flexSize = tester.getSize(flexFinder);
    expect(flexSize.width, closeTo(100, 0.0001));
  });

  testWidgets('w-1/2 applies half-width constraint', (tester) async {
    await pumpSized(
      tester,
      Div(classNames: 'w-1/2 bg-blue-500', child: const SizedBox(height: 40)),
      width: 200,
    );

    final boxSize = tester.getSize(find.byType(Container));
    expect(boxSize.width, closeTo(100, 0.0001));
  });

  testWidgets('fractional width aligns its border box to inline start', (
    tester,
  ) async {
    await pumpSized(
      tester,
      Div(
        key: const ValueKey('fractional-box'),
        classNames: 'w-1/2 bg-blue-500',
        child: const SizedBox(height: 40),
      ),
      width: 200,
    );

    final boxRect = tester.getRect(find.byType(Container));
    expect(boxRect.left, closeTo(0, 0.0001));
    expect(boxRect.width, closeTo(100, 0.0001));
  });

  testWidgets('w-2/3 applies two-thirds width', (tester) async {
    await pumpSized(
      tester,
      Div(classNames: 'w-2/3', child: const SizedBox(height: 20)),
      width: 300,
    );

    final boxSize = tester.getSize(find.byType(Container));
    expect(boxSize.width, closeTo(200, 0.0001));
  });

  testWidgets('w-3/4 applies three-quarter width', (tester) async {
    await pumpSized(
      tester,
      Div(classNames: 'w-3/4', child: const SizedBox(height: 20)),
      width: 400,
    );

    final boxSize = tester.getSize(find.byType(Container));
    expect(boxSize.width, closeTo(300, 0.0001));
  });

  testWidgets('h-1/4 applies quarter-height constraint', (tester) async {
    await pumpSized(
      tester,
      Div(classNames: 'h-1/4 bg-blue-500', child: const SizedBox(width: 40)),
      height: 400,
    );

    final boxSize = tester.getSize(find.byType(Container));
    expect(boxSize.height, closeTo(100, 0.0001));
  });

  testWidgets('h-1/2 applies half-height constraint', (tester) async {
    await pumpSized(
      tester,
      Div(classNames: 'h-1/2 bg-blue-500', child: const SizedBox(width: 40)),
      height: 300,
    );

    final boxSize = tester.getSize(find.byType(Container));
    expect(boxSize.height, closeTo(150, 0.0001));
  });

  testWidgets('w-1/2 h-1/2 applies both width and height constraints', (
    tester,
  ) async {
    await pumpSized(
      tester,
      Div(classNames: 'w-1/2 h-1/2', child: const SizedBox()),
      width: 120,
      height: 240,
    );

    final boxSize = tester.getSize(find.byType(Container));
    expect(boxSize.width, closeTo(60, 0.0001));
    expect(boxSize.height, closeTo(120, 0.0001));
  });

  testWidgets('fixed width self-loosens inside a stretched block column', (
    tester,
  ) async {
    const fixed = ValueKey('nested-fixed-width');
    await pumpSized(
      tester,
      const Div(
        classNames: '',
        children: [
          Div(
            key: fixed,
            classNames: 'w-16 h-8 bg-blue-500',
            child: SizedBox(),
          ),
        ],
      ),
      width: 320,
      height: 120,
    );

    final container = find.descendant(
      of: find.byKey(fixed),
      matching: find.byType(Container),
    );
    expect(tester.getSize(container).width, 64);
    expect(tester.getTopLeft(container).dx, 0);
  });

  testWidgets('active width kind controls stretch in a flex column', (
    tester,
  ) async {
    const fixed = ValueKey('flex-fixed-width');
    const fraction = ValueKey('flex-fraction-width');
    const full = ValueKey('flex-full-width');
    await pumpSized(
      tester,
      const Div(
        classNames: 'flex flex-col',
        children: [
          Div(key: fixed, classNames: 'w-16 h-8 bg-blue-500'),
          Div(key: fraction, classNames: 'w-1/2 h-8 bg-blue-500'),
          Div(key: full, classNames: 'w-full h-8 bg-blue-500'),
        ],
      ),
      width: 320,
      height: 120,
    );

    double widthOf(Key key) => tester
        .getSize(
          find.descendant(
            of: find.byKey(key),
            matching: find.byType(Container),
          ),
        )
        .width;

    expect(widthOf(fixed), 64);
    expect(widthOf(fraction), 160);
    expect(widthOf(full), 320);
  });

  testWidgets('responsive fixed width can clear to auto stretch', (
    tester,
  ) async {
    const subject = ValueKey('responsive-auto-width');

    Future<double> widthAt(double viewportWidth) async {
      await pumpSized(
        tester,
        const Div(
          classNames: 'flex flex-col',
          children: [
            Div(key: subject, classNames: 'w-16 md:w-auto h-8 bg-blue-500'),
          ],
        ),
        width: viewportWidth,
        height: 100,
      );
      return tester
          .getSize(
            find.descendant(
              of: find.byKey(subject),
              matching: find.byType(Container),
            ),
          )
          .width;
    }

    expect(await widthAt(600), 64);
    expect(await widthAt(900), 900);
  });

  testWidgets('responsive fixed height can clear to intrinsic auto height', (
    tester,
  ) async {
    const subject = ValueKey('responsive-auto-height');

    Future<double> heightAt(double viewportWidth) async {
      await pumpSized(
        tester,
        const Div(
          classNames: 'flex flex-col',
          children: [
            Div(
              key: subject,
              classNames: 'w-16 h-16 md:h-auto bg-blue-500',
              child: SizedBox(height: 24),
            ),
          ],
        ),
        width: viewportWidth,
        height: 120,
      );
      return tester
          .getSize(
            find.descendant(
              of: find.byKey(subject),
              matching: find.byType(Container),
            ),
          )
          .height;
    }

    expect(await heightAt(600), 64);
    expect(await heightAt(900), 24);
  });

  testWidgets('nested vertical flex stretches cards across bounded width', (
    tester,
  ) async {
    const frame = ValueKey('centered-frame');
    const cardRoot = ValueKey('full-width-card-root');
    const contentColumn = ValueKey('padded-content-column');
    const responsiveColumn = ValueKey('responsive-column');
    const card = ValueKey('stretched-card');

    await pumpSized(
      tester,
      const Div(
        key: frame,
        classNames: 'flex w-full flex-col items-center gap-8 p-6',
        children: [
          Div(
            key: cardRoot,
            classNames:
                'flex w-full max-w-5xl flex-col overflow-hidden rounded-3xl '
                'border border-slate-200 bg-white',
            children: [
              Div(
                key: contentColumn,
                classNames: 'flex flex-col p-6 md:p-8',
                children: [
                  Div(
                    key: responsiveColumn,
                    classNames:
                        'mt-8 flex flex-col gap-6 md:flex-row md:items-start',
                    children: [
                      Div(
                        key: card,
                        classNames: 'flex flex-col rounded-2xl bg-blue-600 p-6',
                        child: P(text: 'Qualified sessions'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      width: 480,
      height: 320,
    );

    final responsiveFlexFinder = find
        .descendant(
          of: find.byKey(responsiveColumn),
          matching: find.byType(Flex),
        )
        .first;
    final responsiveFlex = tester.widget<Flex>(responsiveFlexFinder);
    final responsiveRenderFlex = tester.renderObject<RenderFlex>(
      responsiveFlexFinder,
    );
    final cardContainer = find.descendant(
      of: find.byKey(card),
      matching: find.byType(Container),
    );

    RenderFlex renderFlexUnder(Key key) => tester.renderObject<RenderFlex>(
      find.descendant(of: find.byKey(key), matching: find.byType(Flex)).first,
    );

    expect(
      renderFlexUnder(frame).crossAxisAlignment,
      CrossAxisAlignment.center,
    );
    expect(renderFlexUnder(cardRoot).size.width, 430);
    expect(renderFlexUnder(contentColumn).size.width, 382);
    expect(responsiveRenderFlex.constraints.minWidth, 382);
    expect(responsiveRenderFlex.constraints.maxWidth, 382);
    expect(responsiveFlex.direction, Axis.vertical);
    expect(responsiveFlex.crossAxisAlignment, CrossAxisAlignment.stretch);
    expect(tester.getSize(cardContainer).width, 382);
  });

  testWidgets('md:items-start only disables column stretch at md', (
    tester,
  ) async {
    const parent = ValueKey('responsive-items-parent');
    const child = ValueKey('responsive-items-child');

    Future<(CrossAxisAlignment, BoxConstraints, double)> metricsAt(
      double width,
    ) async {
      await pumpSized(
        tester,
        const Div(
          key: parent,
          classNames: 'flex flex-col md:items-start',
          children: [
            Div(
              key: child,
              classNames: 'h-8 bg-blue-500',
              child: SizedBox(width: 80),
            ),
          ],
        ),
        width: width,
        height: 120,
      );

      final flexFinder = find
          .descendant(of: find.byKey(parent), matching: find.byType(Flex))
          .first;
      final flex = tester.widget<Flex>(flexFinder);
      final constraints = tester
          .renderObject<RenderFlex>(flexFinder)
          .constraints;
      final childContainer = find.descendant(
        of: find.byKey(child),
        matching: find.byType(Container),
      );
      return (
        flex.crossAxisAlignment,
        constraints,
        tester.getSize(childContainer).width,
      );
    }

    final mobile = await metricsAt(600);
    expect(mobile.$1, CrossAxisAlignment.stretch);
    expect(mobile.$2.minWidth, 600);
    expect(mobile.$2.maxWidth, 600);
    expect(mobile.$3, 600);

    final desktop = await metricsAt(900);
    expect(desktop.$1, CrossAxisAlignment.start);
    expect(desktop.$2.minWidth, 900);
    expect(desktop.$2.maxWidth, 900);
    expect(desktop.$3, 80);
  });

  testWidgets('max-w-sm uses Tailwind named max-width scale', (tester) async {
    final container = await boxContainerFor(tester, 'max-w-sm');
    expect(container.constraints?.maxWidth, 384);
  });

  testWidgets('items-stretch expands cross axis when explicitly requested', (
    tester,
  ) async {
    await pumpSized(
      tester,
      Div(
        classNames: 'flex flex-col items-stretch',
        children: const [
          Div(
            key: ValueKey('metric-a'),
            classNames: 'flex flex-1 flex-col gap-2 rounded-xl bg-blue-50 p-4',
            child: P(text: 'Spend'),
          ),
          Div(
            key: ValueKey('metric-b'),
            classNames: 'flex flex-1 flex-col gap-2 rounded-xl bg-blue-50 p-4',
            child: P(text: 'Return'),
          ),
        ],
      ),
      width: 320,
      height: 240,
    );

    final firstWidth = tester
        .getSize(
          find.descendant(
            of: find.byKey(const ValueKey('metric-a')),
            matching: find.byType(Container),
          ),
        )
        .width;
    final secondWidth = tester
        .getSize(
          find.descendant(
            of: find.byKey(const ValueKey('metric-b')),
            matching: find.byType(Container),
          ),
        )
        .width;

    expect(firstWidth, closeTo(320, 0.0001));
    expect(secondWidth, closeTo(320, 0.0001));
  });

  testWidgets('row flex avoids stretch on unbounded cross axis', (
    tester,
  ) async {
    await pumpSized(
      tester,
      Div(
        classNames: 'flex flex-col',
        children: const [
          Div(
            classNames: 'flex gap-4',
            children: [
              Div(classNames: 'w-20 h-10 bg-blue-500'),
              Div(classNames: 'w-20 h-10 bg-red-500'),
            ],
          ),
        ],
      ),
      width: 320,
      height: 200,
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('vertical flex uses CSS-safe defaults across width constraints', (
    tester,
  ) async {
    const subject = ValueKey('alignment-subject');

    Future<(CrossAxisAlignment, bool)> metrics({
      required String classNames,
      required bool boundedWidth,
    }) async {
      final div = Div(
        key: subject,
        classNames: classNames,
        children: const [
          SizedBox(width: 40, height: 20),
          SizedBox(width: 80, height: 20),
        ],
      );

      await pumpSized(
        tester,
        boundedWidth
            ? div
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [div],
              ),
        width: 320,
        height: 120,
      );

      final flexFinder = find
          .descendant(of: find.byKey(subject), matching: find.byType(Flex))
          .first;
      final flex = tester.widget<Flex>(flexFinder);
      final renderFlex = tester.renderObject<RenderFlex>(flexFinder);
      return (flex.crossAxisAlignment, renderFlex.constraints.hasBoundedWidth);
    }

    final unboundedDefault = await metrics(
      classNames: 'flex flex-col',
      boundedWidth: false,
    );
    final boundedDefault = await metrics(
      classNames: 'flex flex-col',
      boundedWidth: true,
    );
    final unboundedCenter = await metrics(
      classNames: 'flex flex-col items-center',
      boundedWidth: false,
    );

    expect(unboundedDefault.$2, isFalse);
    expect(unboundedDefault.$1, CrossAxisAlignment.start);
    expect(boundedDefault.$2, isTrue);
    expect(boundedDefault.$1, CrossAxisAlignment.stretch);
    expect(unboundedCenter.$2, isFalse);
    expect(unboundedCenter.$1, CrossAxisAlignment.center);
  });

  testWidgets('flex-1 applies flex parent data when used inside Row', (
    tester,
  ) async {
    final parentData = await _rowParentDataForDiv(tester, 'flex-1 bg-blue-500');

    expect(parentData.flex, 1);
    expect(parentData.fit, FlexFit.tight);
  });

  testWidgets('grow applies flex parent data when used inside Row', (
    tester,
  ) async {
    final parentData = await _rowParentDataForDiv(tester, 'grow bg-blue-500');

    expect(parentData.flex, 1);
    expect(parentData.fit, FlexFit.tight);
  });

  testWidgets('grow-0 applies loose zero-flex parent data inside Row', (
    tester,
  ) async {
    final parentData = await _rowParentDataForDiv(tester, 'grow-0 bg-blue-500');

    expect(parentData.flex, 0);
    expect(parentData.fit, FlexFit.loose);
  });

  testWidgets('hover:flex-1 reports once without base parent data', (
    tester,
  ) async {
    final seen = <String>[];

    final parentData = await _rowParentDataForDiv(
      tester,
      'hover:flex-1 bg-blue-500',
      onUnsupported: seen.add,
    );

    expect(parentData.flex, isNull);
    expect(seen, ['hover:flex-1']);
  });

  testWidgets('hover:w-full reports once without base parent data', (
    tester,
  ) async {
    final seen = <String>[];

    final parentData = await _rowParentDataForDiv(
      tester,
      'hover:w-full bg-blue-500',
      onUnsupported: seen.add,
    );

    expect(parentData.flex, isNull);
    expect(seen, ['hover:w-full']);
  });

  testWidgets('hover:gap-x-4 reports once without base spacing', (
    tester,
  ) async {
    final seen = <String>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'flex hover:gap-x-4',
          onUnsupported: seen.add,
          children: const [
            SizedBox(width: 20, height: 20),
            SizedBox(width: 20, height: 20),
          ],
        ),
      ),
    );

    final flex = tester.widget<Flex>(find.byType(Flex));
    expect(flex.spacing, 0);
    expect(seen, ['hover:gap-x-4']);
  });

  testWidgets('TruncatedP renders correct hierarchy', (tester) async {
    await pumpLtr(
      tester,
      Row(
        children: const [TruncatedP(text: 'Long text', classNames: 'text-sm')],
      ),
    );

    // Should find StyledText (from P)
    expect(find.byType(StyledText), findsOneWidget);
  });

  testWidgets('basis-32 constrains main-axis size inside Row', (tester) async {
    await pumpSized(
      tester,
      Row(
        children: [
          Div(
            classNames: 'basis-32 bg-blue-500',
            child: const SizedBox(height: 20),
          ),
          const SizedBox(width: 20, height: 20),
        ],
      ),
      width: 200,
    );

    final fractionFinder = find.descendant(
      of: find.byType(Row),
      matching: find.byType(FractionallySizedBox),
    );
    expect(fractionFinder, findsNothing);

    final boxFinder = find.descendant(
      of: find.byType(Row),
      matching: find.byType(Container),
    );
    final boxSize = tester.getSize(boxFinder);
    expect(boxSize.width, closeTo(128, 0.0001));
  });

  testWidgets('self-end wraps child with Align based on flex axis', (
    tester,
  ) async {
    await pumpLtr(
      tester,
      Row(
        children: [
          Div(
            classNames: 'self-end',
            child: const SizedBox(width: 10, height: 10),
          ),
        ],
      ),
    );

    final alignFinder = find.descendant(
      of: find.byType(Div),
      matching: find.byType(Align),
    );
    expect(alignFinder, findsOneWidget);
    final align = tester.widget<Align>(alignFinder);
    expect(align.alignment, AlignmentDirectional.bottomCenter);
  });

  testWidgets('shadow-none removes box shadows', (tester) async {
    final decoration = await boxDecorationFor(tester, 'shadow-none');
    final shadows = decoration?.boxShadow;
    expect(shadows, anyOf(isNull, isEmpty));
  });

  testWidgets('shadow-xs matches Tailwind preset', (tester) async {
    await expectBoxShadows(tester, 'shadow-xs', const [
      BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
        color: Color(0x0D000000),
      ),
    ]);
  });

  testWidgets('shadow-sm matches Tailwind preset', (tester) async {
    await expectBoxShadows(tester, 'shadow-sm', const [
      BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
        color: Color(0x0D000000),
      ),
    ]);
  });

  testWidgets('shadow matches Tailwind preset', (tester) async {
    await expectBoxShadows(tester, 'shadow', const [
      BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 3,
        spreadRadius: 0,
        color: Color(0x1A000000),
      ),
      BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
        color: Color(0x0F000000),
      ),
    ]);
  });

  testWidgets('shadow-md matches Tailwind preset', (tester) async {
    await expectBoxShadows(tester, 'shadow-md', const [
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 6,
        spreadRadius: -1,
        color: Color(0x1A000000),
      ),
      BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 4,
        spreadRadius: -2,
        color: Color(0x1A000000),
      ),
    ]);
  });

  testWidgets('shadow-lg matches Tailwind preset', (tester) async {
    await expectBoxShadows(tester, 'shadow-lg', const [
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

  testWidgets('shadow-xl matches Tailwind preset', (tester) async {
    await expectBoxShadows(tester, 'shadow-xl', const [
      BoxShadow(
        offset: Offset(0, 20),
        blurRadius: 25,
        spreadRadius: -5,
        color: Color(0x1A000000),
      ),
      BoxShadow(
        offset: Offset(0, 8),
        blurRadius: 10,
        spreadRadius: -6,
        color: Color(0x1A000000),
      ),
    ]);
  });

  testWidgets('shadow-2xl matches Tailwind preset', (tester) async {
    await expectBoxShadows(tester, 'shadow-2xl', const [
      BoxShadow(
        offset: Offset(0, 25),
        blurRadius: 50,
        spreadRadius: -12,
        color: Color(0x40000000),
      ),
    ]);
  });

  testWidgets('gap-x-4 sets main-axis spacing for row flex', (tester) async {
    await pumpLtr(
      tester,
      Div(
        classNames: 'flex gap-x-4',
        children: const [
          SizedBox(width: 20, height: 20),
          SizedBox(width: 20, height: 20),
        ],
      ),
    );

    final flex = tester.widget<Flex>(find.byType(Flex));
    expect(flex.spacing, 16); // gap scale value for "4"
  });

  testWidgets('gap-y-4 applies cross-axis padding for row flex', (
    tester,
  ) async {
    await pumpLtr(
      tester,
      Div(
        classNames: 'flex gap-y-4',
        children: const [
          SizedBox(width: 20, height: 20),
          SizedBox(width: 20, height: 20),
        ],
      ),
    );

    final paddingFinder = find.descendant(
      of: find.byType(Flex),
      matching: find.byType(Padding),
    );
    expect(paddingFinder, findsNWidgets(2));

    final paddings = tester
        .widgetList<Padding>(paddingFinder)
        .toList(growable: false);
    final firstPadding = paddings.first.padding as EdgeInsets;
    final lastPadding = paddings.last.padding as EdgeInsets;

    expect(firstPadding.top, 0);
    expect(firstPadding.bottom, closeTo(8, 0.0001));
    expect(firstPadding.left, 0);
    expect(firstPadding.right, 0);

    expect(lastPadding.top, closeTo(8, 0.0001));
    expect(lastPadding.bottom, 0);
    expect(lastPadding.left, 0);
    expect(lastPadding.right, 0);
  });

  testWidgets('gap-y-6 sets main-axis spacing for column flex', (tester) async {
    await pumpLtr(
      tester,
      Div(
        classNames: 'flex flex-col gap-y-6',
        children: const [
          SizedBox(width: 20, height: 20),
          SizedBox(width: 20, height: 20),
        ],
      ),
    );

    final flex = tester.widget<Flex>(find.byType(Flex));
    expect(flex.spacing, 24); // gap scale value for "6"
  });

  testWidgets('gap-x-2 applies horizontal padding for column flex', (
    tester,
  ) async {
    await pumpLtr(
      tester,
      Div(
        classNames: 'flex flex-col gap-x-2',
        children: const [
          SizedBox(width: 20, height: 20),
          SizedBox(width: 20, height: 20),
        ],
      ),
    );

    final paddingFinder = find.descendant(
      of: find.byType(Flex),
      matching: find.byType(Padding),
    );
    expect(paddingFinder, findsNWidgets(2));

    final paddings = tester
        .widgetList<Padding>(paddingFinder)
        .toList(growable: false);
    final firstPadding = paddings.first.padding as EdgeInsets;
    final lastPadding = paddings.last.padding as EdgeInsets;

    expect(firstPadding.left, 0);
    expect(firstPadding.right, closeTo(4, 0.0001));
    expect(firstPadding.top, 0);
    expect(firstPadding.bottom, 0);

    expect(lastPadding.left, closeTo(4, 0.0001));
    expect(lastPadding.right, 0);
    expect(lastPadding.top, 0);
    expect(lastPadding.bottom, 0);
  });

  testWidgets('gap-x overrides gap on row flex', (tester) async {
    await pumpLtr(
      tester,
      Div(
        classNames: 'flex gap-2 gap-x-6',
        children: const [
          SizedBox(width: 20, height: 20),
          SizedBox(width: 20, height: 20),
        ],
      ),
    );

    final flex = tester.widget<Flex>(find.byType(Flex));
    expect(flex.spacing, 24); // gap-x-6 wins over gap-2 (8)
  });

  testWidgets(
    'flex axis and gap conflicts resolve independently of token order',
    (tester) async {
      Future<(Axis, double)> snapshotFor(String classNames) async {
        await pumpLtr(
          tester,
          Div(
            classNames: classNames,
            children: const [
              SizedBox(width: 20, height: 20),
              SizedBox(width: 20, height: 20),
            ],
          ),
        );

        final flex = tester.widget<Flex>(find.byType(Flex));
        return (flex.direction, flex.spacing);
      }

      final forward = await snapshotFor(
        'flex flex-col flex-row gap-x-2 gap-x-10 gap-y-8',
      );
      final reverse = await snapshotFor(
        'gap-y-8 gap-x-10 gap-x-2 flex-row flex-col flex',
      );

      expect(forward, (Axis.horizontal, 40));
      expect(reverse, forward);
    },
  );

  testWidgets('gap-x responds to breakpoints', (tester) async {
    Future<double> spacingFor(double width) async {
      await pumpSized(
        tester,
        Div(
          classNames: 'flex gap-x-2 md:gap-x-6',
          children: const [
            SizedBox(width: 20, height: 20),
            SizedBox(width: 20, height: 20),
          ],
        ),
        width: width,
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      return flex.spacing;
    }

    final baseSpacing = await spacingFor(500);
    expect(baseSpacing, 8);

    final mdSpacing = await spacingFor(900);
    expect(mdSpacing, 24);
  });

  testWidgets('gap-y responds to breakpoints for column flex', (tester) async {
    Future<double> spacingFor(double width) async {
      await pumpSized(
        tester,
        Div(
          classNames: 'flex flex-col gap-y-2 lg:gap-y-8',
          children: const [
            SizedBox(width: 20, height: 20),
            SizedBox(width: 20, height: 20),
          ],
        ),
        width: width,
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      return flex.spacing;
    }

    final baseSpacing = await spacingFor(700);
    expect(baseSpacing, 8);

    final lgSpacing = await spacingFor(1100);
    expect(lgSpacing, 32);
  });

  testWidgets('border-t applies top border', (tester) async {
    final decoration = await boxDecorationFor(tester, 'border-t');
    final border = decoration?.border as Border?;
    expect(border, isNotNull);
    expect(border!.top.width, 1);
    expect(border.bottom.width, 0);
  });

  testWidgets('border-y-2 sets vertical border width', (tester) async {
    final decoration = await boxDecorationFor(tester, 'border-y-2');
    final border = decoration?.border as Border?;
    expect(border, isNotNull);
    expect(border!.top.width, 2);
    expect(border.bottom.width, 2);
    expect(border.left.width, 0);
  });

  testWidgets('border-x-red-500 colors horizontal borders', (tester) async {
    final decoration = await boxDecorationFor(tester, 'border-x-red-500');
    final border = decoration?.border as Border?;
    expect(border, isNotNull);
    expect(border!.left.color, const Color(0xFFFB2C36));
    expect(border.right.color, const Color(0xFFFB2C36));
  });

  testWidgets('border-gray-200 alone produces no visible border', (
    tester,
  ) async {
    // Color-only border tokens should NOT create borders
    final decoration = await boxDecorationFor(tester, 'border-gray-200');
    final border = decoration?.border as Border?;
    // Either null or all sides have width 0
    expect(border?.top.width ?? 0, 0);
    expect(border?.bottom.width ?? 0, 0);
    expect(border?.left.width ?? 0, 0);
    expect(border?.right.width ?? 0, 0);
    expect(border?.top.style, BorderStyle.none);
    expect(border?.bottom.style, BorderStyle.none);
    expect(border?.left.style, BorderStyle.none);
    expect(border?.right.style, BorderStyle.none);
  });

  testWidgets('border-t border-gray-200 applies color to top only', (
    tester,
  ) async {
    final decoration = await boxDecorationFor(
      tester,
      'border-t border-gray-200',
    );
    final border = decoration?.border as Border?;
    expect(border, isNotNull);
    expect(border!.top.width, 1);
    expect(border.top.color, const Color(0xFFE5E7EB)); // gray-200
    expect(border.bottom.width, 0);
    expect(border.left.width, 0);
    expect(border.right.width, 0);
    expect(border.bottom.style, BorderStyle.none);
    expect(border.left.style, BorderStyle.none);
    expect(border.right.style, BorderStyle.none);
  });

  testWidgets('border border-red-500 applies color to all sides', (
    tester,
  ) async {
    final decoration = await boxDecorationFor(tester, 'border border-red-500');
    final border = decoration?.border as Border?;
    expect(border, isNotNull);
    expect(border!.top.width, 1);
    expect(border.top.color, const Color(0xFFFB2C36)); // red-500
    expect(border.bottom.color, const Color(0xFFFB2C36));
    expect(border.left.color, const Color(0xFFFB2C36));
    expect(border.right.color, const Color(0xFFFB2C36));
  });

  testWidgets('border-x-2 border-blue-500 applies width and color', (
    tester,
  ) async {
    final decoration = await boxDecorationFor(
      tester,
      'border-x-2 border-blue-500',
    );
    final border = decoration?.border as Border?;
    expect(border, isNotNull);
    expect(border!.left.width, 2);
    expect(border.right.width, 2);
    expect(border.left.color, const Color(0xFF2B7FFF)); // blue-500
    expect(border.right.color, const Color(0xFF2B7FFF));
    expect(border.top.width, 0);
    expect(border.bottom.width, 0);
  });

  testWidgets('variant borders inherit base border structure', (tester) async {
    final decoration = await boxDecorationFor(
      tester,
      'border-t hover:border-red-500',
    );
    final border = decoration?.border as Border?;

    expect(border, isNotNull);
    expect(border!.top.width, greaterThan(0));
    expect(border.bottom.width, 0);
    expect(border.left.width, 0);
    expect(border.right.width, 0);
  });

  testWidgets('rounded-t-md applies top border radius', (tester) async {
    final decoration = await boxDecorationFor(tester, 'rounded-t-md');
    final radius = decoration?.borderRadius?.resolve(TextDirection.ltr);
    expect(radius, isNotNull);
    expect(radius!.topLeft.x, 6);
    expect(radius.topRight.x, 6);
    expect(radius.bottomLeft.x, 0);
    expect(radius.bottomRight.x, 0);
  });

  testWidgets('rounded-bl-lg applies bottom-left radius', (tester) async {
    final decoration = await boxDecorationFor(tester, 'rounded-bl-lg');
    final radius = decoration?.borderRadius?.resolve(TextDirection.ltr);
    expect(radius, isNotNull);
    expect(radius!.bottomLeft.x, 8);
    expect(radius.topLeft.x, 0);
  });

  testWidgets('px-4 outranks p-2 independent of token position', (
    tester,
  ) async {
    final container = await boxContainerFor(tester, 'px-4 p-2');
    final padding = container.padding as EdgeInsets?;
    expect(padding, isNotNull);
    expect(padding!.left, 16);
    expect(padding.right, 16);
    expect(padding.top, 8);
  });

  testWidgets('p-2 overridden by px-4', (tester) async {
    final container = await boxContainerFor(tester, 'p-2 px-4');
    final padding = container.padding as EdgeInsets?;
    expect(padding, isNotNull);
    expect(padding!.left, 16);
    expect(padding.right, 16);
    expect(padding.top, 8);
  });

  testWidgets('P forwards text style tokens', (tester) async {
    final p = P(text: 'Hello', classNames: 'text-blue-500 font-bold');

    await pumpLtr(tester, p);

    final text = tester.widget<Text>(find.text('Hello'));
    expect(text.style?.color, const Color(0xFF2B7FFF));
    expect(text.style?.fontWeight, FontWeight.w700);
  });

  testWidgets(
    'Div reports unsupported tokens once across animation and translation',
    (tester) async {
      final seen = <String>[];

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Div(
            classNames: 'unknown-token',
            onUnsupported: seen.add,
            child: const SizedBox(),
          ),
        ),
      );

      expect(seen, ['unknown-token']);
    },
  );

  test('target inference detects prefixed flex tokens', () {
    expect(_classesWantFlex({'inline-flex'}), isTrue);
    expect(_classesWantFlex({'sm:flex'}), isTrue);
    expect(_classesWantFlex({'md:flex-row'}), isTrue);
    expect(_classesWantFlex({'lg:flex-col'}), isTrue);
    expect(_classesWantFlex({'md:hover:flex'}), isTrue);
    expect(_classesWantFlex({'bg-blue-500'}), isFalse);
  });

  test('target inference detects flex-implying properties', () {
    // items-* implies flex
    expect(_classesWantFlex({'items-center'}), isTrue);
    expect(_classesWantFlex({'items-start'}), isTrue);
    expect(_classesWantFlex({'md:items-end'}), isTrue);
    // justify-* implies flex
    expect(_classesWantFlex({'justify-between'}), isTrue);
    expect(_classesWantFlex({'justify-center'}), isTrue);
    expect(_classesWantFlex({'lg:justify-end'}), isTrue);
    // gap-* implies flex
    expect(_classesWantFlex({'gap-4'}), isTrue);
    expect(_classesWantFlex({'gap-x-2'}), isTrue);
    expect(_classesWantFlex({'gap-y-6'}), isTrue);
    expect(_classesWantFlex({'md:gap-8'}), isTrue);
    // Non-flex tokens should still return false
    expect(_classesWantFlex({'p-4'}), isFalse);
    expect(_classesWantFlex({'text-center'}), isFalse);
  });

  testWidgets('inline-flex renders horizontal shrink-wrap flex', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Div(
            classNames: 'inline-flex items-center',
            children: [SizedBox(width: 10, height: 8), SizedBox(width: 14)],
          ),
        ),
      ),
    );

    final flex = tester.widget<Flex>(find.byType(Flex));
    expect(flex.direction, Axis.horizontal);
    expect(flex.mainAxisSize, MainAxisSize.min);
    expect(tester.getSize(find.byType(Flex)).width, closeTo(24, 0.1));
  });

  testWidgets('TwIcon maps Tailwind size, color, and logical margin', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: TwScope(
          child: TwIcon(Icons.add, classNames: 'w-3 h-3 text-blue-700 me-1'),
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byIcon(Icons.add));
    expect(icon.size, 12);
    expect(icon.color, const Color(0xFF1447E6));

    final padding = tester.widget<Padding>(find.byType(Padding));
    expect(padding.padding.resolve(TextDirection.ltr).right, 4);
  });

  test('target inference handles arbitrary values with colons correctly', () {
    // Arbitrary values with colons should NOT trigger false positives
    // The colon inside brackets should be ignored
    expect(_classesWantFlex({'bg-[color:red]'}), isFalse);
    expect(_classesWantFlex({'bg-[color:rgba(0,0,0,0.5)]'}), isFalse);
    expect(_classesWantFlex({'text-[color:blue]'}), isFalse);

    // Prefixed arbitrary values should also work correctly
    expect(_classesWantFlex({'md:bg-[color:red]'}), isFalse);
    expect(_classesWantFlex({'hover:bg-[color:rgba(0,0,0,0.5)]'}), isFalse);

    // Flex with arbitrary values should still be detected
    expect(_classesWantFlex({'flex', 'bg-[color:red]'}), isTrue);
    expect(_classesWantFlex({'md:flex', 'bg-[color:red]'}), isTrue);

    // Malformed brackets should be handled gracefully (no crash)
    expect(_classesWantFlex({'bg-[color:red'}), isFalse);
    expect(_classesWantFlex({'md:bg-[color'}), isFalse);
  });

  testWidgets('Parser defaults to column for prefixed-only flex tokens', (
    tester,
  ) async {
    await pumpSized(
      tester,
      const Div(classNames: 'md:flex', children: [SizedBox(), SizedBox()]),
      width: 700,
    );
    expect(find.byType(Flex), findsOneWidget);
    expect(tester.widget<Flex>(find.byType(Flex)).direction, Axis.vertical);

    await pumpSized(
      tester,
      const Div(classNames: 'flex', children: [SizedBox(), SizedBox()]),
    );
    expect(find.byType(Flex), findsOneWidget);
    expect(tester.widget<Flex>(find.byType(Flex)).direction, Axis.horizontal);

    await pumpSized(
      tester,
      const Div(classNames: 'flex-col', children: [SizedBox(), SizedBox()]),
    );
    expect(find.byType(Flex), findsOneWidget);
    expect(tester.widget<Flex>(find.byType(Flex)).direction, Axis.vertical);
  });

  test('Div constructor is const', () {
    const div = Div(classNames: 'flex');
    expect(div, isNotNull);
  });

  // Note: Div asserts in build() when both child and children are provided.
  // This assertion is verified manually - providing both triggers:
  // 'Provide either child or children, not both.'

  test('P constructor is const', () {
    const p = P(text: 'Hello', classNames: 'text-blue-500');
    expect(p, isNotNull);
  });

  test('Unknown tokens trigger onUnsupported callback', () {
    final seen = <String>[];
    parseBoxWatching('w-4 unknown-token bg-blue-500', seen);

    expect(seen, contains('unknown-token'));
    expect(seen, isNot(contains('w-4')));
    expect(seen, isNot(contains('bg-blue-500')));
  });

  test('Typos are reported', () {
    final seen = <String>[];
    parseBoxWatching('bg-blu-500', seen);

    expect(seen, contains('bg-blu-500'));
  });

  test('Unimplemented tokens are reported', () {
    final seen = <String>[];
    parseBoxWatching('z-10 opacity-50', seen);

    expect(seen, contains('z-10'));
    expect(seen, isNot(contains('opacity-50')));
  });

  test('Prefix chains parse without warnings', () {
    final seen = <String>[];
    parseBoxWatching('md:hover:bg-blue-500', seen);

    expect(seen, isEmpty);
  });

  test('Invalid fractions are ignored', () {
    final parser = TwParser();

    expect(() => parser.parseBox('w-5/0'), returnsNormally);
    expect(() => parser.parseBox('w-abc/def'), returnsNormally);
    expect(() => parser.parseBox('h-1/'), returnsNormally);
  });

  testWidgets('Arbitrary 3/4-digit hex colors are applied', (tester) async {
    final rgb = await boxDecorationFor(tester, 'bg-[#fff]');
    expect(rgb?.color, equals(const Color(0xFFFFFFFF)));

    final rgba = await boxDecorationFor(tester, 'bg-[#ffff]');
    expect(rgba?.color, equals(const Color(0xFFFFFFFF)));
  });

  testWidgets('Arbitrary 6/8-digit CSS hex colors are applied', (tester) async {
    final opaque = await boxDecorationFor(tester, 'bg-[#ffffff]');
    expect(opaque?.color, equals(const Color(0xFFFFFFFF)));

    final alpha = await boxDecorationFor(tester, 'bg-[#ffffff80]');
    expect(alpha?.color, equals(const Color(0x80FFFFFF)));

    final cssOrdered = await boxDecorationFor(tester, 'bg-[#80ffffff]');
    expect(cssOrdered?.color, equals(const Color(0xFF80FFFF)));
  });

  group('state prefix parsing', () {
    const cases = <String, int>{
      'hover:bg-blue-500': 1,
      'focus:bg-blue-500': 1,
      'active:bg-blue-500': 1,
      'disabled:bg-gray-200': 1,
      'dark:bg-gray-700': 1,
      'light:bg-white': 1,
      'dark:hover:bg-blue-700': 1,
      'md:hover:bg-blue-500 lg:focus:bg-blue-700': 2,
    };

    for (final entry in cases.entries) {
      test('${entry.key} registers ${entry.value} variant(s)', () {
        final seen = <String>[];
        final style = parseBoxWatching(entry.key, seen);

        expect(seen, isEmpty);
        expect(style.$variants, isNotNull);
        expect(style.$variants, hasLength(entry.value));
      });
    }
  });

  // ==========================================================================
  // Line Height (leading-*) Tests
  // ==========================================================================

  testWidgets('leading-none applies line height 1.0', (tester) async {
    final text = await renderedTextFor(tester, 'leading-none');
    expect(text.style?.height, 1.0);
  });

  testWidgets('leading-tight applies line height 1.25', (tester) async {
    final text = await renderedTextFor(tester, 'leading-tight');
    expect(text.style?.height, 1.25);
  });

  testWidgets('leading-snug applies line height 1.375', (tester) async {
    final text = await renderedTextFor(tester, 'leading-snug');
    expect(text.style?.height, 1.375);
  });

  testWidgets('leading-normal applies line height 1.5', (tester) async {
    final text = await renderedTextFor(tester, 'leading-normal');
    expect(text.style?.height, 1.5);
  });

  testWidgets('leading-relaxed applies line height 1.625', (tester) async {
    final text = await renderedTextFor(tester, 'leading-relaxed');
    expect(text.style?.height, 1.625);
  });

  testWidgets('leading-loose applies line height 2.0', (tester) async {
    final text = await renderedTextFor(tester, 'leading-loose');
    expect(text.style?.height, 2.0);
  });

  testWidgets('explicit leading wins over font-size defaults in either order', (
    tester,
  ) async {
    for (final classNames in [
      'leading-tight text-2xl',
      'text-2xl leading-tight',
    ]) {
      final text = await renderedTextFor(tester, classNames);
      expect(text.style?.fontSize, 24);
      expect(text.style?.height, 1.25);
    }
  });

  testWidgets('leading-even applies even leading distribution', (tester) async {
    const value = 'leading-even sample';
    final seen = <String>[];
    final style = twParserWatching(seen).parseText('leading-even');

    expect(seen, isEmpty);

    await pumpLtr(tester, StyledText(value, style: style));

    final text = tester.widget<Text>(find.text(value));
    final behavior = text.textHeightBehavior;

    expect(behavior, isNotNull);
    expect(behavior!.leadingDistribution, TextLeadingDistribution.even);
    expect(behavior.applyHeightToFirstAscent, isTrue);
    expect(behavior.applyHeightToLastDescent, isTrue);
  });

  testWidgets(
    'leading-trim applies even distribution with trimmed ascent/descent',
    (tester) async {
      const value = 'leading-trim sample';
      final seen = <String>[];
      final style = twParserWatching(seen).parseText('leading-trim');

      expect(seen, isEmpty);

      await pumpLtr(tester, StyledText(value, style: style));

      final text = tester.widget<Text>(find.text(value));
      final behavior = text.textHeightBehavior;

      expect(behavior, isNotNull);
      expect(behavior!.leadingDistribution, TextLeadingDistribution.even);
      expect(behavior.applyHeightToFirstAscent, isFalse);
      expect(behavior.applyHeightToLastDescent, isFalse);
    },
  );

  // ==========================================================================
  // Letter Spacing (tracking-*) Tests
  // ==========================================================================

  testWidgets('tracking-tighter applies -0.8 letter spacing', (tester) async {
    final text = await renderedTextFor(tester, 'tracking-tighter');
    expect(text.style?.letterSpacing, -0.8);
  });

  testWidgets('tracking-tight applies -0.4 letter spacing', (tester) async {
    final text = await renderedTextFor(tester, 'tracking-tight');
    expect(text.style?.letterSpacing, -0.4);
  });

  testWidgets('tracking-normal applies 0 letter spacing', (tester) async {
    final text = await renderedTextFor(tester, 'tracking-normal');
    expect(text.style?.letterSpacing, 0);
  });

  testWidgets('tracking-wide applies 0.4 letter spacing', (tester) async {
    final text = await renderedTextFor(tester, 'tracking-wide');
    expect(text.style?.letterSpacing, 0.4);
  });

  testWidgets('tracking-wider applies 0.8 letter spacing', (tester) async {
    final text = await renderedTextFor(tester, 'tracking-wider');
    expect(text.style?.letterSpacing, 0.8);
  });

  testWidgets('tracking-widest applies 1.6 letter spacing', (tester) async {
    final text = await renderedTextFor(tester, 'tracking-widest');
    expect(text.style?.letterSpacing, 1.6);
  });

  testWidgets('tracking resolves em units against the selected font size', (
    tester,
  ) async {
    for (final classNames in [
      'tracking-tight text-2xl',
      'text-2xl tracking-tight',
    ]) {
      final text = await renderedTextFor(tester, classNames);
      expect(text.style?.letterSpacing, closeTo(-0.6, 0.000001));
    }
  });

  testWidgets('box default text uses the same leading and tracking rules', (
    tester,
  ) async {
    for (final classNames in [
      'leading-tight text-2xl tracking-tight',
      'tracking-tight text-2xl leading-tight',
    ]) {
      late TextStyle inherited;
      await pumpLtr(
        tester,
        Div(
          classNames: classNames,
          child: Builder(
            builder: (context) {
              inherited = DefaultTextStyle.of(context).style;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pump();

      expect(inherited.fontSize, 24);
      expect(inherited.height, 1.25);
      expect(inherited.letterSpacing, closeTo(-0.6, 0.000001));
    }
  });

  testWidgets('tracking uses configured base font size for text and boxes', (
    tester,
  ) async {
    final config = TwConfig.standard().copyWith(
      textDefaults: TwConfig.standard().textDefaults.copyWith(fontSize: 15),
    );
    late TextStyle inherited;

    await pumpLtr(
      tester,
      TwScope(
        config: config,
        child: Column(
          children: [
            StyledText(
              'direct tracking',
              style: TwParser(config: config).parseText('tracking-wide'),
            ),
            Div(
              classNames: 'tracking-wide',
              child: Builder(
                builder: (context) {
                  inherited = DefaultTextStyle.of(context).style;
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    final direct = tester.widget<Text>(find.text('direct tracking'));
    expect(direct.style?.letterSpacing, closeTo(0.375, 0.000001));
    expect(inherited.letterSpacing, closeTo(0.375, 0.000001));
  });

  // ==========================================================================
  // Min-Width/Min-Height Tests
  // ==========================================================================

  test('min-w-0 parses without warnings and returns a style', () {
    final seen = <String>[];
    final style = parseBoxWatching('min-w-0', seen);

    expect(seen, isEmpty);
    expect(style, isA<BoxStyler>());
  });

  test('min-h-0 parses without warnings and returns a style', () {
    final seen = <String>[];
    final style = parseBoxWatching('min-h-0', seen);

    expect(seen, isEmpty);
    expect(style, isA<BoxStyler>());
  });

  test('min-w-0 parses without warnings in flex context', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex min-w-0');
    expect(seen, isEmpty);
  });

  test('min-h-0 parses without warnings in flex context', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex min-h-0');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Text Truncation Tests
  // ==========================================================================

  test('truncate parses without warnings', () {
    final seen = <String>[];
    twParserWatching(seen).parseText('truncate');
    expect(seen, isEmpty);
  });

  testWidgets('P truncate applies ellipsis and maxLines', (tester) async {
    final p = P(
      text: 'This is a very long text that should be truncated',
      classNames: 'truncate',
    );

    await pumpLtr(tester, p);

    final text = tester.widget<Text>(
      find.text('This is a very long text that should be truncated'),
    );
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.maxLines, 1);
  });

  // ==========================================================================
  // Overflow Tests
  // ==========================================================================

  test('overflow-hidden parses without warnings in flex context', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex overflow-hidden');
    expect(seen, isEmpty);
  });

  test('overflow-visible parses without warnings in flex context', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex overflow-visible');
    expect(seen, isEmpty);
  });

  test('overflow-clip parses without warnings in flex context', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex overflow-clip');
    expect(seen, isEmpty);
  });

  test('overflow-hidden parses without warnings in box context', () {
    final seen = <String>[];
    parseBoxWatching('overflow-hidden', seen);
    expect(seen, isEmpty);
  });

  test('overflow-visible parses without warnings in box context', () {
    final seen = <String>[];
    parseBoxWatching('overflow-visible', seen);
    expect(seen, isEmpty);
  });

  test('overflow-clip parses without warnings in box context', () {
    final seen = <String>[];
    parseBoxWatching('overflow-clip', seen);
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Flex Shrink Tests
  // ==========================================================================

  test('flex-shrink-0 is ignored by parser (handled at widget layer)', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex flex-shrink-0');
    expect(seen, isEmpty);
  });

  test('shrink-0 is ignored by parser (handled at widget layer)', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex shrink-0');
    expect(seen, isEmpty);
  });

  test('flex-shrink is ignored by parser (handled at widget layer)', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex flex-shrink');
    expect(seen, isEmpty);
  });

  test('shrink is ignored by parser (handled at widget layer)', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex shrink');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Cross-Axis Alignment Tests
  // ==========================================================================

  test('items-stretch parses without warnings', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex items-stretch');
    expect(seen, isEmpty);
  });

  test('items-baseline parses without warnings', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex items-baseline');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Combined Token Tests
  // ==========================================================================

  test('text tokens can combine font-size with leading', () {
    final seen = <String>[];
    twParserWatching(seen).parseText('text-lg leading-tight');
    expect(seen, isEmpty);
  });

  test('text tokens can combine with tracking', () {
    final seen = <String>[];
    twParserWatching(seen).parseText('text-sm tracking-wide');
    expect(seen, isEmpty);
  });

  test('multiple text modifiers parse without warnings', () {
    final seen = <String>[];
    twParserWatching(
      seen,
    ).parseText('text-lg font-bold leading-tight tracking-wide uppercase');
    expect(seen, isEmpty);
  });

  test('flex with min-w-0 and overflow-hidden parses', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex min-w-0 overflow-hidden');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Animation Token Recognition Tests
  // ==========================================================================

  test('transition parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('transition', seen);
    expect(seen, isEmpty);
  });

  test('transition-all parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('transition-all', seen);
    expect(seen, isEmpty);
  });

  test('transition-none parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('transition-none', seen);
    expect(seen, isEmpty);
  });

  test('transition-colors parses without warnings (alias)', () {
    final seen = <String>[];
    parseBoxWatching('transition-colors', seen);
    expect(seen, isEmpty);
  });

  test('transition-opacity parses without warnings (alias)', () {
    final seen = <String>[];
    parseBoxWatching('transition-opacity', seen);
    expect(seen, isEmpty);
  });

  test('transition-shadow parses without warnings (alias)', () {
    final seen = <String>[];
    parseBoxWatching('transition-shadow', seen);
    expect(seen, isEmpty);
  });

  test('transition-transform parses without warnings (alias)', () {
    final seen = <String>[];
    parseBoxWatching('transition-transform', seen);
    expect(seen, isEmpty);
  });

  test('duration-300 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('duration-300', seen);
    expect(seen, isEmpty);
  });

  test('delay-150 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('delay-150', seen);
    expect(seen, isEmpty);
  });

  test('ease-in parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('ease-in', seen);
    expect(seen, isEmpty);
  });

  test('ease-out parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('ease-out', seen);
    expect(seen, isEmpty);
  });

  test('ease-in-out parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('ease-in-out', seen);
    expect(seen, isEmpty);
  });

  test('ease-linear parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('ease-linear', seen);
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Animation Default Values Tests
  // ==========================================================================

  test('transition applies 150ms default duration', () {
    final config = parseAnimation('transition');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 150));
  });

  test('transition applies ease-out default curve', () {
    final config = parseAnimation('transition');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeOut);
  });

  test('transition applies 0ms default delay', () {
    final config = parseAnimation('transition');
    expect(config, isNotNull);
    expect(config!.delay, Duration.zero);
  });

  // ==========================================================================
  // Delay Parsing Tests
  // ==========================================================================

  test('delay-0 sets 0ms delay', () {
    final config = parseAnimation('transition delay-0');
    expect(config, isNotNull);
    expect(config!.delay, Duration.zero);
  });

  test('delay-75 sets 75ms delay', () {
    final config = parseAnimation('transition delay-75');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 75));
  });

  test('delay-100 sets 100ms delay', () {
    final config = parseAnimation('transition delay-100');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 100));
  });

  test('delay-150 sets 150ms delay', () {
    final config = parseAnimation('transition delay-150');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 150));
  });

  test('delay-500 sets 500ms delay', () {
    final config = parseAnimation('transition delay-500');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 500));
  });

  test('delay-700 sets 700ms delay', () {
    final config = parseAnimation('transition delay-700');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 700));
  });

  test('delay-1000 sets 1000ms delay', () {
    final config = parseAnimation('transition delay-1000');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 1000));
  });

  // ==========================================================================
  // transition-none Tests (Critical)
  // ==========================================================================

  test('transition-none returns null config', () {
    final config = parseAnimation('transition-none');
    expect(config, isNull);
  });

  test('transition-none disables even with duration present', () {
    final config = parseAnimation('transition-none duration-300');
    expect(config, isNull);
  });

  test('transition-none disables even with ease present', () {
    final config = parseAnimation('transition-none ease-in');
    expect(config, isNull);
  });

  test('transition-none disables even with delay present', () {
    final config = parseAnimation('transition-none delay-500');
    expect(config, isNull);
  });

  test('transition-none disables with all modifiers', () {
    final config = parseAnimation(
      'transition-none duration-300 ease-in delay-100',
    );
    expect(config, isNull);
  });

  test('transition then transition-none disables animation', () {
    final config = parseAnimation('transition transition-none');
    expect(config, isNull);
  });

  test('duration-300 then transition-none disables animation', () {
    final config = parseAnimation('duration-300 transition-none');
    expect(config, isNull);
  });

  // ==========================================================================
  // Canonical Utility-Order Precedence Tests
  // ==========================================================================

  test('duration conflicts resolve independently of token order', () {
    for (final classes in [
      'transition duration-100 duration-300',
      'transition duration-300 duration-100',
    ]) {
      final config = parseAnimation(classes);
      expect(config, isNotNull);
      expect(config!.duration, const Duration(milliseconds: 300));
    }
  });

  test('ease conflicts resolve independently of token order', () {
    for (final classes in [
      'transition ease-in ease-out',
      'transition ease-out ease-in',
    ]) {
      final config = parseAnimation(classes);
      expect(config, isNotNull);
      expect(config!.curve, Curves.easeOut);
    }
  });

  test('delay conflicts resolve independently of token order', () {
    for (final classes in [
      'transition delay-100 delay-500',
      'transition delay-500 delay-100',
    ]) {
      final config = parseAnimation(classes);
      expect(config, isNotNull);
      expect(config!.delay, const Duration(milliseconds: 500));
    }
  });

  test('delay-500 outranks delay-0 independent of token order', () {
    for (final classes in [
      'transition delay-0 delay-500',
      'transition delay-500 delay-0',
    ]) {
      final config = parseAnimation(classes);
      expect(config, isNotNull);
      expect(config!.delay, const Duration(milliseconds: 500));
    }
  });

  // ==========================================================================
  // Standalone Tokens (No Trigger) Tests
  // ==========================================================================

  test('duration alone returns null', () {
    final config = parseAnimation('duration-300');
    expect(config, isNull);
  });

  test('ease alone returns null', () {
    final config = parseAnimation('ease-in');
    expect(config, isNull);
  });

  test('delay alone returns null', () {
    final config = parseAnimation('delay-200');
    expect(config, isNull);
  });

  test('duration ease delay without transition returns null', () {
    final config = parseAnimation('duration-300 ease-in delay-100');
    expect(config, isNull);
  });

  // ==========================================================================
  // Duration Parsing Tests
  // ==========================================================================

  test('duration-0 sets 0ms duration', () {
    final config = parseAnimation('transition duration-0');
    expect(config, isNotNull);
    expect(config!.duration, Duration.zero);
  });

  test('duration-75 sets 75ms duration', () {
    final config = parseAnimation('transition duration-75');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 75));
  });

  test('duration-100 sets 100ms duration', () {
    final config = parseAnimation('transition duration-100');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 100));
  });

  test('duration-150 sets 150ms duration', () {
    final config = parseAnimation('transition duration-150');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 150));
  });

  test('duration-200 sets 200ms duration', () {
    final config = parseAnimation('transition duration-200');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 200));
  });

  test('duration-300 sets 300ms duration', () {
    final config = parseAnimation('transition duration-300');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 300));
  });

  test('duration-500 sets 500ms duration', () {
    final config = parseAnimation('transition duration-500');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 500));
  });

  test('duration-700 sets 700ms duration', () {
    final config = parseAnimation('transition duration-700');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 700));
  });

  test('duration-1000 sets 1000ms duration', () {
    final config = parseAnimation('transition duration-1000');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 1000));
  });

  // ==========================================================================
  // Ease Parsing Tests
  // ==========================================================================

  test('ease-linear sets Curves.linear', () {
    final config = parseAnimation('transition ease-linear');
    expect(config, isNotNull);
    expect(config!.curve, Curves.linear);
  });

  test('ease-in sets Curves.easeIn', () {
    final config = parseAnimation('transition ease-in');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeIn);
  });

  test('ease-out sets Curves.easeOut', () {
    final config = parseAnimation('transition ease-out');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeOut);
  });

  test('ease-in-out sets Curves.easeInOut', () {
    final config = parseAnimation('transition ease-in-out');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeInOut);
  });

  // ==========================================================================
  // Combined Animation Tests
  // ==========================================================================

  test('transition with all modifiers parses correctly', () {
    final config = parseAnimation('transition duration-300 ease-in delay-100');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 300));
    expect(config.curve, Curves.easeIn);
    expect(config.delay, const Duration(milliseconds: 100));
  });

  test('transition-colors with modifiers parses correctly', () {
    final config = parseAnimation('transition-colors duration-500 ease-in-out');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 500));
    expect(config.curve, Curves.easeInOut);
  });

  test('prefixed animation tokens are recognized', () {
    final seen = <String>[];
    parseBoxWatching('hover:transition duration-300', seen);
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Invalid Value Warning Tests (P2)
  // ==========================================================================

  test('duration with invalid value warns via onUnsupported', () {
    final seen = <String>[];
    parseAnimation('transition duration-abc', parser: twParserWatching(seen));
    expect(seen, contains('duration-abc'));
  });

  test('delay with invalid value warns via onUnsupported', () {
    final seen = <String>[];
    parseAnimation('transition delay-xyz', parser: twParserWatching(seen));
    expect(seen, contains('delay-xyz'));
  });

  test('duration with invalid value preserves default 150ms', () {
    final config = parseAnimation('transition duration-abc');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 150));
  });

  test('delay with invalid value preserves default 0ms', () {
    final config = parseAnimation('transition delay-xyz');
    expect(config, isNotNull);
    expect(config!.delay, Duration.zero);
  });

  test('duration- without value warns via onUnsupported', () {
    final seen = <String>[];
    parseAnimation('transition duration-', parser: twParserWatching(seen));
    expect(seen, contains('duration-'));
  });

  test('delay- without value warns via onUnsupported', () {
    final seen = <String>[];
    parseAnimation('transition delay-', parser: twParserWatching(seen));
    expect(seen, contains('delay-'));
  });

  // ==========================================================================
  // Non-Tailwind Value Warning Tests
  // ==========================================================================

  test('duration-2000 warns (not a valid Tailwind value)', () {
    final seen = <String>[];
    parseAnimation('transition duration-2000', parser: twParserWatching(seen));
    expect(seen, contains('duration-2000'));
  });

  test('duration-50 warns (not a valid Tailwind value)', () {
    final seen = <String>[];
    parseAnimation('transition duration-50', parser: twParserWatching(seen));
    expect(seen, contains('duration-50'));
  });

  test('delay-2500 warns (not a valid Tailwind value)', () {
    final seen = <String>[];
    parseAnimation('transition delay-2500', parser: twParserWatching(seen));
    expect(seen, contains('delay-2500'));
  });

  test('delay-25 warns (not a valid Tailwind value)', () {
    final seen = <String>[];
    parseAnimation('transition delay-25', parser: twParserWatching(seen));
    expect(seen, contains('delay-25'));
  });

  // ==========================================================================
  // Prefixed Animation Token Tests (P2)
  // ==========================================================================

  test('md:transition is recognized as transition trigger', () {
    final config = parseAnimation('md:transition');
    expect(config, isNotNull);
  });

  test('hover:duration-500 modifies duration', () {
    final config = parseAnimation('transition hover:duration-500');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 500));
  });

  test('sm:ease-in correctly applies curve', () {
    final config = parseAnimation('transition sm:ease-in');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeIn);
  });

  test('md:transition-none disables animation', () {
    final config = parseAnimation('transition md:transition-none');
    expect(config, isNull);
  });

  test('lg:delay-300 applies delay', () {
    final config = parseAnimation('transition lg:delay-300');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 300));
  });

  // ==========================================================================
  // Edge Case Tests (P2)
  // ==========================================================================

  test('empty string returns null', () {
    final config = parseAnimation('');
    expect(config, isNull);
  });

  test('whitespace only returns null', () {
    final config = parseAnimation('   ');
    expect(config, isNull);
  });

  test('order independence: duration before transition works', () {
    final config = parseAnimation('duration-300 transition');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 300));
  });

  test('order independence: delay before transition works', () {
    final config = parseAnimation('delay-200 transition');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 200));
  });

  test('order independence: ease before transition works', () {
    final config = parseAnimation('ease-in transition');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeIn);
  });

  test('compileBox attaches transition animation to the style', () {
    final compilation = TwParser().compileBox(
      'bg-blue-500 p-4 transition duration-300 ease-in-out',
    );
    final animation = compilation.styler.$animation as CurveAnimationConfig?;

    expect(animation, isNotNull);
    expect(animation!.duration, const Duration(milliseconds: 300));
    expect(animation.curve, Curves.easeInOut);
    expect(compilation.diagnostics, isEmpty);
  });

  testWidgets('Div with transition renders without error', (tester) async {
    await pumpDiv(
      tester,
      'bg-blue-500 transition duration-300',
      child: const SizedBox(width: 50, height: 50),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('Div with transition-none renders without animation', (
    tester,
  ) async {
    await pumpDiv(
      tester,
      'bg-blue-500 transition-none duration-300',
      child: const SizedBox(width: 50, height: 50),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('FlexBox Div with transition renders without error', (
    tester,
  ) async {
    await pumpLtr(
      tester,
      Div(
        classNames: 'flex gap-4 transition duration-200 ease-in',
        children: const [
          SizedBox(width: 20, height: 20),
          SizedBox(width: 20, height: 20),
        ],
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(Flex), findsOneWidget);
  });

  // ==========================================================================
  // Transform Token Recognition Tests
  // ==========================================================================

  test('scale-105 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('scale-105', seen);
    expect(seen, isEmpty);
  });

  test('scale-50 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('scale-50', seen);
    expect(seen, isEmpty);
  });

  test('scale-150 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('scale-150', seen);
    expect(seen, isEmpty);
  });

  test('rotate-45 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('rotate-45', seen);
    expect(seen, isEmpty);
  });

  test('rotate-90 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('rotate-90', seen);
    expect(seen, isEmpty);
  });

  test('-rotate-45 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('-rotate-45', seen);
    expect(seen, isEmpty);
  });

  test('translate-x-4 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('translate-x-4', seen);
    expect(seen, isEmpty);
  });

  test('translate-y-4 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('translate-y-4', seen);
    expect(seen, isEmpty);
  });

  test('-translate-x-4 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('-translate-x-4', seen);
    expect(seen, isEmpty);
  });

  test('-translate-y-4 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('-translate-y-4', seen);
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Transform Widget Tests
  // ==========================================================================

  testWidgets('Div with scale-105 sets container transform', (tester) async {
    final container = await boxContainerFor(tester, 'scale-105 bg-blue-500');

    expect(container.transform, isNotNull);
    expect(container.transform![0], closeTo(1.05, 0.0001));
    expect(
      find.descendant(
        of: find.byType(Container),
        matching: find.byType(Transform),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Div with rotate-45 sets container transform', (tester) async {
    final container = await boxContainerFor(tester, 'rotate-45');

    expect(container.transform, isNotNull);
    expect(container.transform![0], closeTo(0.7071, 0.001));
    expect(
      find.descendant(
        of: find.byType(Container),
        matching: find.byType(Transform),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Div with translate-x-4 sets container transform', (
    tester,
  ) async {
    final container = await boxContainerFor(tester, 'translate-x-4');

    expect(container.transform, isNotNull);
    expect(container.transform![12], closeTo(16, 0.0001));
    expect(
      find.descendant(
        of: find.byType(Container),
        matching: find.byType(Transform),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Div without transform tokens leaves container transform null', (
    tester,
  ) async {
    final container = await boxContainerFor(tester, 'bg-blue-500 p-4');

    expect(container.transform, isNull);
    expect(
      find.descendant(
        of: find.byType(Container),
        matching: find.byType(Transform),
      ),
      findsNothing,
    );
  });

  testWidgets('Div with combined transforms applies single composite matrix', (
    tester,
  ) async {
    final container = await boxContainerFor(
      tester,
      'scale-110 rotate-12 translate-x-2',
    );

    expect(container.transform, isNotNull);
    final matrix = container.transform!;

    // Verify scale (1.10) is applied - diagonal elements should be ~1.10 * cos(12°)
    // cos(12°) ≈ 0.978, so [0] should be ~1.075
    expect(matrix[0], closeTo(1.075, 0.01)); // scaled cos(12°)

    // Verify rotation (12°) is applied - sin(12°) ≈ 0.208
    expect(matrix[1], closeTo(0.228, 0.01)); // scaled sin(12°)

    // Verify translation (translate-x-2 = 8px) is applied
    expect(matrix[12], closeTo(8, 0.0001)); // x translation

    expect(
      find.descendant(
        of: find.byType(Container),
        matching: find.byType(Transform),
      ),
      findsOneWidget,
    );
  });

  testWidgets('FlexBox Div applies transform on its Box container', (
    tester,
  ) async {
    await pumpLtr(
      tester,
      Div(
        classNames: 'flex gap-4 scale-105',
        children: const [
          SizedBox(width: 20, height: 20),
          SizedBox(width: 20, height: 20),
        ],
      ),
    );

    // CSS semantic box creates single Container - no nested Container
    final containerFinder = find.byType(Container);

    expect(containerFinder, findsOneWidget);
    final container = tester.widget<Container>(containerFinder);
    expect(container.transform, isNotNull);
    expect(container.transformAlignment, Alignment.center);
    expect(
      find.descendant(
        of: find.byType(Container),
        matching: find.byType(Transform),
      ),
      findsOneWidget,
    );
  });

  // ==========================================================================
  // Div Margin Hit-Test (CSS parity)
  // ==========================================================================

  group('Div margin hit-test (CSS parity)', () {
    testWidgets('m-4 applies margin via outer Padding on Div', (tester) async {
      await pumpSized(
        tester,
        Div(
          classNames: 'm-4 bg-blue-500',
          child: const SizedBox(width: 40, height: 40),
        ),
        width: 200,
        height: 120,
      );

      final padding = tester.widget<Padding>(find.byType(Padding).first);
      final edgeInsets = padding.padding as EdgeInsets;
      expect(edgeInsets.top, 16);
      expect(edgeInsets.right, 16);
      expect(edgeInsets.bottom, 16);
      expect(edgeInsets.left, 16);
    });

    testWidgets('hover does not apply when pointer is in margin zone', (
      tester,
    ) async {
      await pumpSized(
        tester,
        Div(
          classNames: 'm-8 hover:scale-110',
          child: const SizedBox(width: 40, height: 40),
        ),
        width: 220,
        height: 140,
      );

      final gesture = await createOffscreenMouseGesture(tester);

      final containerFinder = find.byType(Container);
      final marginPadding = find.byType(Padding).first;
      final marginTopLeft = tester.getTopLeft(marginPadding);
      final marginInsets =
          tester.widget<Padding>(marginPadding).padding as EdgeInsets;

      await gesture.moveTo(
        Offset(marginTopLeft.dx + marginInsets.left + 2, marginTopLeft.dy + 2),
      );
      await tester.pump();

      final marginZoneTransform = tester
          .widget<Container>(containerFinder)
          .transform;
      expect(marginZoneTransform, isNotNull);
      expect(marginZoneTransform![0], closeTo(1.0, 0.01));

      await gesture.moveTo(tester.getCenter(containerFinder));
      await tester.pump();

      final hoveredTransform = tester
          .widget<Container>(containerFinder)
          .transform;
      expect(hoveredTransform, isNotNull);
      expect(hoveredTransform![0], closeTo(1.1, 0.01));

      await gesture.moveTo(const Offset(-500, -500));
      await tester.pump();
      await gesture.removePointer();
    });
  });

  // ==========================================================================
  // Variant-Aware Transform Tests
  // ==========================================================================

  testWidgets('hover:scale-105 applies scale only when hovered', (
    tester,
  ) async {
    await pumpDiv(tester, 'hover:scale-105');

    final gesture = await createOffscreenMouseGesture(tester);

    // CSS semantic box creates single Container - no nested Container
    final containerFinder = find.byType(Container);

    await gesture.moveTo(tester.getCenter(containerFinder));
    await tester.pump();

    final hovered = tester.widget<Container>(containerFinder).transform;
    expect(hovered, isNotNull);
    expect(hovered![0], closeTo(1.05, 0.01));

    await gesture.moveTo(const Offset(-500, -500));
    await tester.pump();
    await gesture.removePointer();

    final afterExit = tester.widget<Container>(containerFinder).transform;
    // After mouse exits, transform returns to identity (needed for animation interpolation)
    expect(afterExit, isNotNull);
    expect(afterExit![0], closeTo(1.0, 0.01)); // identity matrix
  });

  testWidgets('hover transform returns to base state when mouse exits', (
    tester,
  ) async {
    await pumpDiv(
      tester,
      'hover:scale-110',
      child: const SizedBox(width: 30, height: 30),
    );

    final gesture = await createOffscreenMouseGesture(tester);

    // CSS semantic box creates single Container - no nested Container
    final containerFinder = find.byType(Container);

    await gesture.moveTo(tester.getCenter(containerFinder));
    await tester.pump();

    expect(tester.widget<Container>(containerFinder).transform, isNotNull);

    await gesture.moveTo(const Offset(-500, -500));
    await tester.pump();
    await gesture.removePointer();

    final reset = tester.widget<Container>(containerFinder).transform;
    // After mouse exits, transform returns to identity (needed for animation interpolation)
    expect(reset, isNotNull);
    expect(reset![0], closeTo(1.0, 0.01)); // identity matrix
  });

  testWidgets('md:rotate-45 applies only at md breakpoint', (tester) async {
    await pumpSized(
      tester,
      Div(
        classNames: 'md:rotate-45',
        child: const SizedBox(width: 20, height: 20),
      ),
      width: 500,
      height: 400,
    );

    // CSS semantic box creates single Container - no nested Container
    final containerFinder = find.byType(Container);
    // At width 500, md breakpoint (768) is not reached, so identity transform (for animation interpolation)
    final baseMatrix = tester.widget<Container>(containerFinder).transform;
    expect(baseMatrix, isNotNull);
    expect(baseMatrix![0], closeTo(1.0, 0.01)); // identity matrix

    await pumpSized(
      tester,
      Div(
        classNames: 'md:rotate-45',
        child: const SizedBox(width: 20, height: 20),
      ),
      width: 900,
      height: 600,
    );

    final rotated = tester.widget<Container>(containerFinder).transform!;
    expect(rotated[0], closeTo(0.7071, 0.01));
  });

  testWidgets('rotate-45 hover:scale-110 keeps rotation on hover', (
    tester,
  ) async {
    await pumpDiv(
      tester,
      'rotate-45 hover:scale-110',
      child: const SizedBox(width: 30, height: 30),
    );

    // CSS semantic box creates single Container - no nested Container
    final containerFinder = find.byType(Container);

    final baseMatrix = tester.widget<Container>(containerFinder).transform!;

    final gesture = await createMouseGesture(
      tester,
      initialPosition: Offset.zero,
    );
    await gesture.moveTo(tester.getCenter(containerFinder));
    await tester.pump();

    final hoveredMatrix = tester.widget<Container>(containerFinder).transform!;

    expect(hoveredMatrix[0], closeTo(baseMatrix[0] * 1.10, 0.02));
    expect(hoveredMatrix[1], closeTo(baseMatrix[1] * 1.10, 0.02));

    await gesture.moveTo(Offset.zero);
    await tester.pump();
    await gesture.removePointer();
  });

  testWidgets('transition hover:scale-110 animates on hover', (tester) async {
    await pumpDiv(
      tester,
      'transition hover:scale-110',
      child: const SizedBox(width: 30, height: 30),
    );

    final gesture = await createOffscreenMouseGesture(tester);

    // CSS semantic box creates single Container - no nested Container
    final containerFinder = find.byType(Container);

    // Before hover, identity transform (needed for animation interpolation when variants have transforms)
    final baseMatrix = tester.widget<Container>(containerFinder).transform;
    expect(baseMatrix, isNotNull);
    expect(
      baseMatrix![0],
      closeTo(1.0, 0.01),
    ); // identity matrix has 1.0 at [0][0]

    await gesture.moveTo(tester.getCenter(containerFinder));
    await tester.pump(); // start animation

    await tester.pump(const Duration(milliseconds: 50));
    final midMatrix = tester.widget<Container>(containerFinder).transform;
    expect(midMatrix, isNotNull);
    expect(midMatrix![0], greaterThan(1.0));
    expect(midMatrix[0], lessThan(1.11));

    await tester.pump(const Duration(milliseconds: 200));
    final endMatrix = tester.widget<Container>(containerFinder).transform!;
    expect(endMatrix[0], closeTo(1.10, 0.01));

    await gesture.removePointer();
  });

  testWidgets('transform is applied via Mix container, not external wrapper', (
    tester,
  ) async {
    await pumpDiv(
      tester,
      'scale-105',
      child: const SizedBox(width: 30, height: 30),
    );

    final boxFinder = find.byType(Container);

    // Transform is applied via Container.transform property, not a separate Transform widget
    final container = tester.widget<Container>(boxFinder);
    expect(container.transform, isNotNull);
    expect(container.transform![0], closeTo(1.05, 0.01));

    // No external Transform wrapper should exist
    expect(
      find.ancestor(of: boxFinder, matching: find.byType(Transform)),
      findsNothing,
    );
  });

  // ==========================================================================
  // Transform with Prefixes Tests
  // ==========================================================================

  test('hover:scale-105 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('hover:scale-105', seen);
    expect(seen, isEmpty);
  });

  test('md:rotate-45 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('md:rotate-45', seen);
    expect(seen, isEmpty);
  });

  test('lg:translate-x-4 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('lg:translate-x-4', seen);
    expect(seen, isEmpty);
  });

  test('dark:scale-110 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('dark:scale-110', seen);
    expect(seen, isEmpty);
  });

  test('md:hover:scale-105 parses without warnings', () {
    final seen = <String>[];
    parseBoxWatching('md:hover:scale-105', seen);
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Transform in flex context
  // ==========================================================================

  test('transform tokens parse without warnings in flex context', () {
    final seen = <String>[];
    twParserWatching(seen).parseFlex('flex scale-105 rotate-45');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Invalid Transform Values
  // ==========================================================================

  test('scale-999 warns via onUnsupported', () {
    final seen = <String>[];
    parseBoxWatching('scale-999', seen);
    expect(seen, contains('scale-999'));
  });

  test('rotate-999 warns via onUnsupported', () {
    final seen = <String>[];
    parseBoxWatching('rotate-999', seen);
    expect(seen, contains('rotate-999'));
  });

  // ==========================================================================
  // Flex-None Behavior Tests
  // ==========================================================================

  testWidgets('flex-none child maintains intrinsic width in Row', (
    tester,
  ) async {
    await pumpSized(
      tester,
      Row(
        children: [
          Div(
            classNames: 'flex-none bg-blue-500',
            child: const SizedBox(width: 50, height: 50),
          ),
          Div(
            classNames: 'flex-1 bg-red-500',
            child: const SizedBox(height: 50),
          ),
        ],
      ),
      width: 300,
    );

    // Find the first Box (flex-none child)
    final boxes = find.byType(Container);
    expect(boxes, findsNWidgets(2));

    // The flex-none child should maintain its 50px width
    final flexNoneSize = tester.getSize(boxes.first);
    expect(flexNoneSize.width, 50);
  });

  testWidgets('items-baseline sets baseline alignment and textBaseline', (
    tester,
  ) async {
    await pumpSized(
      tester,
      Div(
        classNames: 'flex items-baseline',
        children: [
          P(text: 'Hello', classNames: 'text-lg'),
          P(text: 'World', classNames: 'text-sm'),
        ],
      ),
      width: 300,
    );

    final flex = tester.widget<Flex>(find.byType(Flex));
    expect(flex.crossAxisAlignment, CrossAxisAlignment.baseline);
    expect(flex.textBaseline, TextBaseline.alphabetic);
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('World'), findsOneWidget);
  });

  // ==========================================================================
  // Blur Token Tests
  // ==========================================================================

  group('Blur tokens', () {
    test('blur-none parses without warnings', () {
      final seen = <String>[];
      parseBoxWatching('blur-none', seen);
      expect(seen, isEmpty);
    });

    test('blur-sm parses without warnings', () {
      final seen = <String>[];
      parseBoxWatching('blur-sm', seen);
      expect(seen, isEmpty);
    });

    test('blur parses without warnings (default)', () {
      final seen = <String>[];
      parseBoxWatching('blur', seen);
      expect(seen, isEmpty);
    });

    test('blur-md parses without warnings', () {
      final seen = <String>[];
      parseBoxWatching('blur-md', seen);
      expect(seen, isEmpty);
    });

    test('blur-lg parses without warnings', () {
      final seen = <String>[];
      parseBoxWatching('blur-lg', seen);
      expect(seen, isEmpty);
    });

    test('blur-xl parses without warnings', () {
      final seen = <String>[];
      parseBoxWatching('blur-xl', seen);
      expect(seen, isEmpty);
    });

    test('blur-2xl parses without warnings', () {
      final seen = <String>[];
      parseBoxWatching('blur-2xl', seen);
      expect(seen, isEmpty);
    });

    test('blur-3xl parses without warnings', () {
      final seen = <String>[];
      parseBoxWatching('blur-3xl', seen);
      expect(seen, isEmpty);
    });

    test('blur-999 warns via onUnsupported', () {
      final seen = <String>[];
      parseBoxWatching('blur-999', seen);
      expect(seen, contains('blur-999'));
    });

    testWidgets('Div with blur-md applies ImageFiltered', (tester) async {
      await pumpDiv(
        tester,
        'blur-md',
        child: const SizedBox(width: 40, height: 40),
      );

      expect(find.byType(ImageFiltered), findsOneWidget);
    });

    testWidgets('Div with blur-none does not apply ImageFiltered', (
      tester,
    ) async {
      await pumpDiv(
        tester,
        'blur-none',
        child: const SizedBox(width: 40, height: 40),
      );

      expect(find.byType(ImageFiltered), findsNothing);
    });

    testWidgets('hover:blur-lg applies blur on hover only', (tester) async {
      await pumpDiv(
        tester,
        'hover:blur-lg',
        child: const SizedBox(width: 40, height: 40),
      );

      // Initially no blur
      expect(find.byType(ImageFiltered), findsNothing);

      // Hover
      final gesture = await createMouseGesture(
        tester,
        initialPosition: Offset.zero,
      );

      final boxFinder = find.byType(Container);
      await gesture.moveTo(tester.getCenter(boxFinder.first));
      await tester.pump();

      // Blur applied on hover
      expect(find.byType(ImageFiltered), findsOneWidget);

      // Move away
      await gesture.moveTo(const Offset(-500, -500));
      await tester.pump();

      // Blur removed
      expect(find.byType(ImageFiltered), findsNothing);

      await gesture.removePointer();
    });
  });

  // ==========================================================================
  // Text Shadow Token Tests
  // ==========================================================================

  group('Text shadow tokens', () {
    test('text-shadow-none parses without warnings', () {
      final seen = <String>[];
      twParserWatching(seen).parseText('text-shadow-none');
      expect(seen, isEmpty);
    });

    test('text-shadow-2xs parses without warnings', () {
      final seen = <String>[];
      twParserWatching(seen).parseText('text-shadow-2xs');
      expect(seen, isEmpty);
    });

    test('text-shadow-xs parses without warnings', () {
      final seen = <String>[];
      twParserWatching(seen).parseText('text-shadow-xs');
      expect(seen, isEmpty);
    });

    test('text-shadow-sm parses without warnings', () {
      final seen = <String>[];
      twParserWatching(seen).parseText('text-shadow-sm');
      expect(seen, isEmpty);
    });

    test('text-shadow-md parses without warnings', () {
      final seen = <String>[];
      twParserWatching(seen).parseText('text-shadow-md');
      expect(seen, isEmpty);
    });

    test('text-shadow-lg parses without warnings', () {
      final seen = <String>[];
      twParserWatching(seen).parseText('text-shadow-lg');
      expect(seen, isEmpty);
    });

    test('text-shadow-999 warns via onUnsupported', () {
      final seen = <String>[];
      twParserWatching(seen).parseText('text-shadow-999');
      expect(seen, contains('text-shadow-999'));
    });

    testWidgets(
      'Div with text-shadow-md applies shadows via DefaultTextStyle',
      (tester) async {
        await pumpLtr(
          tester,
          Div(classNames: 'text-shadow-md', children: [const Text('Hello')]),
        );

        // Div wraps children with DefaultTextStyle for text shadows
        final defaultTextStyles = find.byType(DefaultTextStyle);
        expect(defaultTextStyles, findsWidgets);

        // Find the one with shadows
        bool foundShadows = false;
        for (final element in defaultTextStyles.evaluate()) {
          final widget = element.widget as DefaultTextStyle;
          if (widget.style.shadows != null &&
              widget.style.shadows!.isNotEmpty) {
            foundShadows = true;
            break;
          }
        }
        expect(foundShadows, isTrue);
      },
    );
  });

  // ===========================================================================
  // Span Box Utilities Tests
  // ===========================================================================

  group('Span box utilities', () {
    testWidgets('Span without box utilities renders StyledText only', (
      tester,
    ) async {
      await pumpLtr(
        tester,
        const Span(text: 'Hello', classNames: 'text-blue-500 font-bold'),
      );

      // Should have StyledText but no Container wrapper
      expect(find.byType(StyledText), findsOneWidget);
      expect(find.byType(Container), findsNothing);
    });

    testWidgets('Span with px-2 py-1 wraps in Box with padding', (
      tester,
    ) async {
      await pumpLtr(
        tester,
        const Span(text: 'Badge', classNames: 'px-2 py-1 text-white'),
      );

      // Should wrap in a Container (from _CssSemanticBox)
      expect(find.byType(Container), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));
      final padding = container.padding as EdgeInsets?;
      expect(padding, isNotNull);
      expect(padding!.left, 8); // px-2 = 8px
      expect(padding.right, 8);
      expect(padding.top, 4); // py-1 = 4px
      expect(padding.bottom, 4);
    });

    testWidgets('Span with bg-purple-500 applies background color', (
      tester,
    ) async {
      await pumpLtr(
        tester,
        const Span(text: 'Badge', classNames: 'bg-purple-500'),
      );

      expect(find.byType(Container), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(decoration!.color, isNotNull);
      // Purple-500 should have a non-zero alpha (visible color)
      expect(decoration.color!.a, greaterThan(0));
    });

    testWidgets('Span with rounded-full applies circular border radius', (
      tester,
    ) async {
      await pumpLtr(
        tester,
        const Span(text: 'Pill', classNames: 'px-2 rounded-full'),
      );

      expect(find.byType(Container), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(decoration!.borderRadius, isNotNull);
      // rounded-full should be 9999px (effectively circular)
      final radius = decoration.borderRadius as BorderRadius;
      expect(radius.topLeft.x, greaterThan(100));
    });

    testWidgets('Span with border applies border', (tester) async {
      await pumpLtr(
        tester,
        const Span(text: 'Bordered', classNames: 'border border-gray-300'),
      );

      expect(find.byType(Container), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(decoration!.border, isNotNull);
    });

    testWidgets('Span with combined box utilities (badge pill)', (
      tester,
    ) async {
      // This matches the card-alert Admin badge use case
      await pumpLtr(
        tester,
        const Span(
          text: 'Admin',
          classNames:
              'px-2 py-0.5 bg-purple-500/30 text-purple-200 text-xs rounded-full font-medium',
        ),
      );

      // Should have Container wrapper with all box properties
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(StyledText), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));

      // Check padding
      final padding = container.padding as EdgeInsets?;
      expect(padding, isNotNull);
      expect(padding!.left, 8); // px-2 = 8px
      expect(padding.right, 8);
      expect(padding.top, 2); // py-0.5 = 2px
      expect(padding.bottom, 2);

      // Check decoration
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(decoration!.color, isNotNull); // bg-purple-500/30
      expect(decoration.borderRadius, isNotNull); // rounded-full
    });

    testWidgets('Span with shadow wraps in Box', (tester) async {
      await pumpLtr(
        tester,
        const Span(text: 'Shadowed', classNames: 'shadow-md'),
      );

      // shadow is a box utility, should trigger wrapping
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Span with opacity wraps and applies Opacity', (tester) async {
      await pumpLtr(
        tester,
        const Span(text: 'Faded', classNames: 'opacity-50'),
      );

      expect(find.byType(Container), findsOneWidget);
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 0.5);
    });

    testWidgets('Span with transform wraps in Box', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Span(text: 'Moved', classNames: 'translate-x-2'),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.transform, isNotNull);
    });

    testWidgets('Span with overflow wraps in Box', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Span(text: 'Clipped', classNames: 'overflow-hidden'),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.clipBehavior, Clip.hardEdge);
    });

    testWidgets('Span with blur wraps in Box', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Span(text: 'Blurred', classNames: 'blur-sm'),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(ImageFiltered), findsOneWidget);
    });

    testWidgets('Span with gradient wraps in Box', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Span(
            text: 'Gradient',
            classNames: 'bg-gradient-to-r from-blue-500 to-red-500',
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.gradient, isA<LinearGradient>());
    });
  });

  group('Gradient direction parity', () {
    testWidgets('bg-gradient-to-br defaults to cssAngleRect strategy', (
      tester,
    ) async {
      final decoration = await boxDecorationFor(
        tester,
        'bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900',
      );
      final gradient = decoration?.gradient as LinearGradient?;

      expect(gradient, isNotNull);
      expect(gradient!.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
      expect(gradient.stops, const [0.0, 0.5, 1.0]);
      expect(gradient.transform, isA<TwCssKeywordLinearTransform>());
    });

    testWidgets('bg-gradient-to-br can still use alignment strategy', (
      tester,
    ) async {
      final config = TwConfig.standard().copyWith(
        gradientStrategy: TwGradientStrategy.alignment,
      );
      final decoration = await boxDecorationForWithConfig(
        tester,
        'bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900',
        config,
      );
      final gradient = decoration?.gradient as LinearGradient?;

      expect(gradient, isNotNull);
      expect(gradient!.begin, Alignment.topLeft);
      expect(gradient.end, Alignment.bottomRight);
      expect(gradient.stops, const [0.0, 0.5, 1.0]);
      expect(gradient.transform, isNull);
    });

    testWidgets('bg-gradient-to-br can use angle strategy', (tester) async {
      final config = TwConfig.standard().copyWith(
        gradientStrategy: TwGradientStrategy.angle,
      );
      final decoration = await boxDecorationForWithConfig(
        tester,
        'bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900',
        config,
      );
      final gradient = decoration?.gradient as LinearGradient?;

      expect(gradient, isNotNull);
      expect(gradient!.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
      expect(gradient.stops, const [0.0, 0.5, 1.0]);

      final transform = gradient.transform as GradientRotation?;
      expect(transform, isNotNull);
      expect(transform!.radians, closeTo(math.pi / 4, 0.0001));
    });

    testWidgets('bg-gradient-to-br can use cssAngleRect strategy', (
      tester,
    ) async {
      final config = TwConfig.standard().copyWith(
        gradientStrategy: TwGradientStrategy.cssAngleRect,
      );
      final decoration = await boxDecorationForWithConfig(
        tester,
        'bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900',
        config,
      );
      final gradient = decoration?.gradient as LinearGradient?;

      expect(gradient, isNotNull);
      expect(gradient!.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
      expect(gradient.stops, const [0.0, 0.5, 1.0]);
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
      final angle = math.atan2(direction.dy, direction.dx);

      // CSS-equivalent direction for `to-br` in non-square bounds uses
      // atan2(width, height), not a fixed 45-degree angle.
      expect(angle, closeTo(math.atan2(rect.width, rect.height), 0.0001));
    });

    testWidgets('bg-gradient-to-tr can use cssAngleRect strategy', (
      tester,
    ) async {
      final config = TwConfig.standard().copyWith(
        gradientStrategy: TwGradientStrategy.cssAngleRect,
      );
      final decoration = await boxDecorationForWithConfig(
        tester,
        'bg-gradient-to-tr from-slate-900 via-purple-900 to-slate-900',
        config,
      );
      final gradient = decoration?.gradient as LinearGradient?;

      expect(gradient, isNotNull);
      expect(gradient!.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
      expect(gradient.stops, const [0.0, 0.5, 1.0]);
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
      final angle = math.atan2(direction.dy, direction.dx);

      // CSS-equivalent direction for `to-tr` in non-square bounds uses
      // atan2(-width, height), not a fixed -45-degree angle.
      expect(angle, closeTo(math.atan2(-rect.width, rect.height), 0.0001));
    });

    testWidgets('bg-gradient-to-bl can use cssAngleRect strategy', (
      tester,
    ) async {
      final config = TwConfig.standard().copyWith(
        gradientStrategy: TwGradientStrategy.cssAngleRect,
      );
      final decoration = await boxDecorationForWithConfig(
        tester,
        'bg-gradient-to-bl from-slate-900 via-purple-900 to-slate-900',
        config,
      );
      final gradient = decoration?.gradient as LinearGradient?;

      expect(gradient, isNotNull);
      expect(gradient!.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
      expect(gradient.stops, const [0.0, 0.5, 1.0]);
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
      final angle = math.atan2(direction.dy, direction.dx);

      // CSS-equivalent direction for `to-bl` in non-square bounds uses
      // atan2(width, -height), not a fixed -45-degree angle.
      expect(angle, closeTo(math.atan2(rect.width, -rect.height), 0.0001));
    });

    testWidgets('bg-gradient-to-tl can use cssAngleRect strategy', (
      tester,
    ) async {
      final config = TwConfig.standard().copyWith(
        gradientStrategy: TwGradientStrategy.cssAngleRect,
      );
      final decoration = await boxDecorationForWithConfig(
        tester,
        'bg-gradient-to-tl from-slate-900 via-purple-900 to-slate-900',
        config,
      );
      final gradient = decoration?.gradient as LinearGradient?;

      expect(gradient, isNotNull);
      expect(gradient!.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
      expect(gradient.stops, const [0.0, 0.5, 1.0]);
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
      final angle = math.atan2(direction.dy, direction.dx);

      // CSS-equivalent direction for `to-tl` in non-square bounds uses
      // atan2(-width, -height), not a fixed 45-degree angle.
      expect(angle, closeTo(math.atan2(-rect.width, -rect.height), 0.0001));
    });

    testWidgets('bg-gradient-to-r uses unrotated horizontal axis', (
      tester,
    ) async {
      final decoration = await boxDecorationFor(
        tester,
        'bg-gradient-to-r from-slate-900 to-slate-900',
      );
      final gradient = decoration?.gradient as LinearGradient?;

      expect(gradient, isNotNull);
      expect(gradient!.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
      expect(gradient.stops, const [0.0, 1.0]);
      expect(gradient.transform, isNull);
    });
  });

  // ===========================================================================
  // Flex in unbounded contexts (CSS parity)
  // ===========================================================================

  group('flex in unbounded contexts (CSS parity)', () {
    testWidgets('flex-1 in vertical ScrollView does not crash', (tester) async {
      await pumpLtr(
        tester,
        const SingleChildScrollView(
          child: Div(
            classNames: 'flex flex-col gap-2',
            children: [
              Div(classNames: 'flex-1 h-20 bg-blue-500'),
              Div(classNames: 'h-20 bg-red-500'),
            ],
          ),
        ),
      );
      // Should not crash — flex-1 is no-op in unbounded context
      expect(tester.takeException(), isNull);
    });

    testWidgets('shrink in vertical ScrollView does not crash', (tester) async {
      await pumpLtr(
        tester,
        const SingleChildScrollView(
          child: Div(
            classNames: 'flex flex-col',
            children: [
              Div(classNames: 'shrink h-20 bg-blue-500'),
              Div(classNames: 'shrink-0 h-20 bg-red-500'),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('w-full in horizontal ScrollView does not crash', (
      tester,
    ) async {
      await pumpLtr(
        tester,
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Div(
            classNames: 'flex flex-row',
            children: [
              Div(classNames: 'w-full h-20 bg-blue-500'),
              Div(classNames: 'w-20 h-20 bg-red-500'),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('flex-1 in bounded context still works', (tester) async {
      await pumpLtr(
        tester,
        const SizedBox(
          width: 300,
          height: 200,
          child: Div(
            classNames: 'flex flex-row',
            children: [
              Div(classNames: 'flex-1 bg-blue-500'),
              Div(classNames: 'flex-1 bg-red-500'),
            ],
          ),
        ),
      );
      // Both should render without error
      expect(find.byType(Container), findsWidgets);
    });
  });
}
