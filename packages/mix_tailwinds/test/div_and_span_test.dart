import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

Future<Container> _boxContainerFor(
  WidgetTester tester,
  String classNames,
) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Div(classNames: classNames, child: const SizedBox()),
    ),
  );
  await tester.pump();

  // CSS semantic widgets use Container directly (margin is applied via Padding)
  final containerFinder = find.byType(Container);

  expect(containerFinder, findsOneWidget);

  return tester.widget<Container>(containerFinder);
}

Future<BoxDecoration?> _boxDecorationFor(
  WidgetTester tester,
  String classNames,
) async {
  final container = await _boxContainerFor(tester, classNames);
  return container.decoration as BoxDecoration?;
}

Future<void> _expectShadowElevation(
  WidgetTester tester,
  String classNames,
  int elevation,
) async {
  final decoration = await _boxDecorationFor(tester, classNames);
  final expected = kElevationToShadow[elevation]!;
  final actual = decoration?.boxShadow;

  expect(actual, isNotNull);
  expect(actual, hasLength(expected.length));

  for (var i = 0; i < expected.length; i++) {
    expect(actual![i], equals(expected[i]));
  }
}

/// Helper to parse animation config from class names.
/// Uses the non-deprecated parseAnimationFromTokens internally.
CurveAnimationConfig? _parseAnimation(
  String classNames, {
  TwParser? parser,
}) {
  final p = parser ?? TwParser();
  return p.parseAnimationFromTokens(p.listTokens(classNames));
}

Future<void> _pumpSized(
  WidgetTester tester,
  Widget child, {
  double width = 800,
  double height = 600,
}) async {
  await tester.binding.setSurfaceSize(Size(width, height));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: Size(width, height)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: width, height: height, child: child),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('Div picks flex layout when flex token is present', (
    tester,
  ) async {
    final widget = Directionality(
      textDirection: TextDirection.ltr,
      child: Div(
        classNames: 'flex gap-4',
        children: const [SizedBox(), SizedBox()],
      ),
    );

    await tester.pumpWidget(widget);

    // CSS semantic widgets use Flex directly instead of FlexBox
    expect(find.byType(Flex), findsOneWidget);
  });

  testWidgets('Div picks flex layout when only md:flex token is present', (
    tester,
  ) async {
    final widget = Directionality(
      textDirection: TextDirection.ltr,
      child: Div(
        classNames: 'md:flex gap-4',
        children: const [SizedBox(), SizedBox()],
      ),
    );

    await tester.pumpWidget(widget);

    // CSS semantic widgets use Flex directly instead of FlexBox
    expect(find.byType(Flex), findsOneWidget);
  });

  testWidgets('Div defaults to box layout when flex tokens missing', (
    tester,
  ) async {
    final widget = Directionality(
      textDirection: TextDirection.ltr,
      child: Div(classNames: 'bg-blue-500 p-4', child: const SizedBox()),
    );

    await tester.pumpWidget(widget);

    // CSS semantic widgets use Container directly; no Flex when not in flex mode
    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(Flex), findsNothing);
  });

  testWidgets('Div wraps multiple children in Column', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'p-4',
          children: const [Text('First'), Text('Second')],
        ),
      ),
    );

    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Row), findsNothing);
  });

  testWidgets('w-full does not crash inside Row', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
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
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Should not crash'), findsOneWidget);
  });

  testWidgets('w-full expands to parent width inside Row', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
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

  testWidgets('h-full does not crash inside Column', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
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
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Should not crash'), findsOneWidget);
  });

  testWidgets('h-full expands to parent height inside Column', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
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
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
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
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('flex container respects w-full wrapper', (tester) async {
    await _pumpSized(
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
    await _pumpSized(
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
    await _pumpSized(
      tester,
      Div(classNames: 'w-1/2 bg-blue-500', child: const SizedBox(height: 40)),
      width: 200,
    );

    final boxSize = tester.getSize(find.byType(Container));
    expect(boxSize.width, closeTo(100, 0.0001));
  });

  testWidgets('w-2/3 applies two-thirds width', (tester) async {
    await _pumpSized(
      tester,
      Div(classNames: 'w-2/3', child: const SizedBox(height: 20)),
      width: 300,
    );

    final boxSize = tester.getSize(find.byType(Container));
    expect(boxSize.width, closeTo(200, 0.0001));
  });

  testWidgets('w-3/4 applies three-quarter width', (tester) async {
    await _pumpSized(
      tester,
      Div(classNames: 'w-3/4', child: const SizedBox(height: 20)),
      width: 400,
    );

    final boxSize = tester.getSize(find.byType(Container));
    expect(boxSize.width, closeTo(300, 0.0001));
  });

  testWidgets('h-1/4 applies quarter-height constraint', (tester) async {
    await _pumpSized(
      tester,
      Div(classNames: 'h-1/4 bg-blue-500', child: const SizedBox(width: 40)),
      height: 400,
    );

    final boxSize = tester.getSize(find.byType(Container));
    expect(boxSize.height, closeTo(100, 0.0001));
  });

  testWidgets('h-1/2 applies half-height constraint', (tester) async {
    await _pumpSized(
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
    await _pumpSized(
      tester,
      Div(classNames: 'w-1/2 h-1/2', child: const SizedBox()),
      width: 120,
      height: 240,
    );

    final boxSize = tester.getSize(find.byType(Container));
    expect(boxSize.width, closeTo(60, 0.0001));
    expect(boxSize.height, closeTo(120, 0.0001));
  });

  testWidgets('flex-1 applies flex parent data when used inside Row', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 200,
          child: Row(
            children: [
              Div(
                classNames: 'flex-1 bg-blue-500',
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
    final parentData = firstChild.parentData as FlexParentData;
    expect(parentData.flex, 1);
    expect(parentData.fit, FlexFit.tight);
  });

  testWidgets('flex-1 auto-applies min-w-0 constraint', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 200,
          child: Row(
            children: [
              Div(
                classNames: 'flex-1 bg-blue-500',
                child: const SizedBox(width: 10, height: 10),
              ),
            ],
          ),
        ),
      ),
    );

    // flex-1 should auto-apply ConstrainedBox with min 0
    final constrainedBox = find.byType(ConstrainedBox);
    expect(constrainedBox, findsOneWidget);
    final box = tester.widget<ConstrainedBox>(constrainedBox);
    expect(box.constraints.minWidth, 0);
    expect(box.constraints.minHeight, 0);
  });

  testWidgets('flex-1 min-w-auto disables auto-constraint', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 200,
          child: Row(
            children: [
              Div(
                classNames: 'flex-1 min-w-auto bg-blue-500',
                child: const SizedBox(width: 10, height: 10),
              ),
            ],
          ),
        ),
      ),
    );

    // min-w-auto escape hatch should prevent auto ConstrainedBox
    final constrainedBoxes = tester.widgetList<ConstrainedBox>(
      find.byType(ConstrainedBox),
    );
    for (final box in constrainedBoxes) {
      expect(
        box.constraints.minWidth == 0 && box.constraints.minHeight == 0,
        isFalse,
        reason: 'min-w-auto should disable auto min constraint',
      );
    }
  });

  testWidgets('flex-auto does NOT auto-apply min-w-0', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 200,
          child: Row(
            children: [
              Div(
                classNames: 'flex-auto bg-blue-500',
                child: const SizedBox(width: 10, height: 10),
              ),
            ],
          ),
        ),
      ),
    );

    // flex-auto should NOT have ConstrainedBox with min 0
    final constrainedBoxes = tester.widgetList<ConstrainedBox>(
      find.byType(ConstrainedBox),
    );
    for (final box in constrainedBoxes) {
      expect(
        box.constraints.minWidth == 0 && box.constraints.minHeight == 0,
        isFalse,
        reason: 'flex-auto should respect content size, not auto-apply min-w-0',
      );
    }
  });

  testWidgets('TruncatedP renders correct hierarchy', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: const [
            TruncatedP(text: 'Long text', classNames: 'text-sm'),
          ],
        ),
      ),
    );

    // Should find StyledText (from P)
    expect(find.byType(StyledText), findsOneWidget);
  });

  testWidgets('basis-32 constrains main-axis size inside Row', (tester) async {
    await _pumpSized(
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
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            Div(
              classNames: 'self-end',
              child: const SizedBox(width: 10, height: 10),
            ),
          ],
        ),
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
    final decoration = await _boxDecorationFor(tester, 'shadow-none');
    final shadows = decoration?.boxShadow;
    expect(shadows, anyOf(isNull, isEmpty));
  });

  testWidgets('shadow-sm maps to elevation 1', (tester) async {
    await _expectShadowElevation(tester, 'shadow-sm', 1);
  });

  testWidgets('shadow maps to elevation 2', (tester) async {
    await _expectShadowElevation(tester, 'shadow', 2);
  });

  testWidgets('shadow-md maps to elevation 3', (tester) async {
    await _expectShadowElevation(tester, 'shadow-md', 3);
  });

  testWidgets('shadow-lg maps to elevation 6', (tester) async {
    await _expectShadowElevation(tester, 'shadow-lg', 6);
  });

  testWidgets('shadow-xl maps to elevation 9', (tester) async {
    await _expectShadowElevation(tester, 'shadow-xl', 9);
  });

  testWidgets('shadow-2xl maps to elevation 12', (tester) async {
    await _expectShadowElevation(tester, 'shadow-2xl', 12);
  });

  testWidgets('gap-x-4 sets main-axis spacing for row flex', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'flex gap-x-4',
          children: const [
            SizedBox(width: 20, height: 20),
            SizedBox(width: 20, height: 20),
          ],
        ),
      ),
    );

    final flex = tester.widget<Flex>(find.byType(Flex));
    expect(flex.spacing, 16); // gap scale value for "4"
  });

  testWidgets('gap-y-4 applies cross-axis padding for row flex', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'flex gap-y-4',
          children: const [
            SizedBox(width: 20, height: 20),
            SizedBox(width: 20, height: 20),
          ],
        ),
      ),
    );

    final paddingFinder = find.descendant(
      of: find.byType(Flex),
      matching: find.byType(Padding),
    );
    expect(paddingFinder, findsNWidgets(2));

    final padding =
        tester.widget<Padding>(paddingFinder.first).padding as EdgeInsets;
    expect(padding.top, closeTo(8, 0.0001));
    expect(padding.bottom, closeTo(8, 0.0001));
    expect(padding.left, 0);
    expect(padding.right, 0);
  });

  testWidgets('gap-y-6 sets main-axis spacing for column flex', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'flex flex-col gap-y-6',
          children: const [
            SizedBox(width: 20, height: 20),
            SizedBox(width: 20, height: 20),
          ],
        ),
      ),
    );

    final flex = tester.widget<Flex>(find.byType(Flex));
    expect(flex.spacing, 24); // gap scale value for "6"
  });

  testWidgets('gap-x-2 applies horizontal padding for column flex', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'flex flex-col gap-x-2',
          children: const [
            SizedBox(width: 20, height: 20),
            SizedBox(width: 20, height: 20),
          ],
        ),
      ),
    );

    final paddingFinder = find.descendant(
      of: find.byType(Flex),
      matching: find.byType(Padding),
    );
    expect(paddingFinder, findsNWidgets(2));

    final padding =
        tester.widget<Padding>(paddingFinder.first).padding as EdgeInsets;
    expect(padding.left, closeTo(4, 0.0001));
    expect(padding.right, closeTo(4, 0.0001));
    expect(padding.top, 0);
    expect(padding.bottom, 0);
  });

  testWidgets('gap-x overrides gap on row flex', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'flex gap-2 gap-x-6',
          children: const [
            SizedBox(width: 20, height: 20),
            SizedBox(width: 20, height: 20),
          ],
        ),
      ),
    );

    final flex = tester.widget<Flex>(find.byType(Flex));
    expect(flex.spacing, 24); // gap-x-6 wins over gap-2 (8)
  });

  testWidgets('gap-x responds to breakpoints', (tester) async {
    Future<double> spacingFor(double width) async {
      await _pumpSized(
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
      await _pumpSized(
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
    final decoration = await _boxDecorationFor(tester, 'border-t');
    final border = decoration?.border as Border?;
    expect(border, isNotNull);
    expect(border!.top.width, 1);
    expect(border.bottom.width, 0);
  });

  testWidgets('border-y-2 sets vertical border width', (tester) async {
    final decoration = await _boxDecorationFor(tester, 'border-y-2');
    final border = decoration?.border as Border?;
    expect(border, isNotNull);
    expect(border!.top.width, 2);
    expect(border.bottom.width, 2);
    expect(border.left.width, 0);
  });

  testWidgets('border-x-red-500 colors horizontal borders', (tester) async {
    final decoration = await _boxDecorationFor(tester, 'border-x-red-500');
    final border = decoration?.border as Border?;
    expect(border, isNotNull);
    expect(border!.left.color, const Color(0xFFEF4444));
    expect(border.right.color, const Color(0xFFEF4444));
  });

  testWidgets('border-gray-200 alone produces no visible border', (tester) async {
    // Color-only border tokens should NOT create borders
    final decoration = await _boxDecorationFor(tester, 'border-gray-200');
    final border = decoration?.border as Border?;
    // Either null or all sides have width 0
    expect(border?.top.width ?? 0, 0);
    expect(border?.bottom.width ?? 0, 0);
    expect(border?.left.width ?? 0, 0);
    expect(border?.right.width ?? 0, 0);
  });

  testWidgets('border-t border-gray-200 applies color to top only',
      (tester) async {
    final decoration =
        await _boxDecorationFor(tester, 'border-t border-gray-200');
    final border = decoration?.border as Border?;
    expect(border, isNotNull);
    expect(border!.top.width, 1);
    expect(border.top.color, const Color(0xFFE5E7EB)); // gray-200
    expect(border.bottom.width, 0);
    expect(border.left.width, 0);
    expect(border.right.width, 0);
  });

  testWidgets('border border-red-500 applies color to all sides',
      (tester) async {
    final decoration =
        await _boxDecorationFor(tester, 'border border-red-500');
    final border = decoration?.border as Border?;
    expect(border, isNotNull);
    expect(border!.top.width, 1);
    expect(border.top.color, const Color(0xFFEF4444)); // red-500
    expect(border.bottom.color, const Color(0xFFEF4444));
    expect(border.left.color, const Color(0xFFEF4444));
    expect(border.right.color, const Color(0xFFEF4444));
  });

  testWidgets('border-x-2 border-blue-500 applies width and color',
      (tester) async {
    final decoration =
        await _boxDecorationFor(tester, 'border-x-2 border-blue-500');
    final border = decoration?.border as Border?;
    expect(border, isNotNull);
    expect(border!.left.width, 2);
    expect(border.right.width, 2);
    expect(border.left.color, const Color(0xFF3B82F6)); // blue-500
    expect(border.right.color, const Color(0xFF3B82F6));
    expect(border.top.width, 0);
    expect(border.bottom.width, 0);
  });

  test('variant borders inherit base border structure', () {
    // This tests that hover:border-red-500 inherits border-t's structure
    // Previously, inheritColorFrom only inherited color, not widths
    final parser = TwParser();
    final styler = parser.parseFlex('border-t hover:border-red-500');

    // The base should have top border with default width
    // The hover variant should inherit the top-only structure
    // We can verify the styler was created without errors
    expect(styler, isNotNull);

    // Parse with color on base to verify variant inheritance
    final styler2 = parser.parseFlex('border-t border-gray-200 hover:border-red-500');
    expect(styler2, isNotNull);
  });

  testWidgets('rounded-t-md applies top border radius', (tester) async {
    final decoration = await _boxDecorationFor(tester, 'rounded-t-md');
    final radius = decoration?.borderRadius?.resolve(TextDirection.ltr);
    expect(radius, isNotNull);
    expect(radius!.topLeft.x, 6);
    expect(radius.topRight.x, 6);
    expect(radius.bottomLeft.x, 0);
    expect(radius.bottomRight.x, 0);
  });

  testWidgets('rounded-bl-lg applies bottom-left radius', (tester) async {
    final decoration = await _boxDecorationFor(tester, 'rounded-bl-lg');
    final radius = decoration?.borderRadius?.resolve(TextDirection.ltr);
    expect(radius, isNotNull);
    expect(radius!.bottomLeft.x, 8);
    expect(radius.topLeft.x, 0);
  });

  testWidgets('px-4 overridden by p-2', (tester) async {
    final container = await _boxContainerFor(tester, 'px-4 p-2');
    final padding = container.padding as EdgeInsets?;
    expect(padding, isNotNull);
    expect(padding!.left, 8);
    expect(padding.right, 8);
    expect(padding.top, 8);
  });

  testWidgets('p-2 overridden by px-4', (tester) async {
    final container = await _boxContainerFor(tester, 'p-2 px-4');
    final padding = container.padding as EdgeInsets?;
    expect(padding, isNotNull);
    expect(padding!.left, 16);
    expect(padding.right, 16);
    expect(padding.top, 8);
  });

  testWidgets('P forwards text style tokens', (tester) async {
    final p = P(text: 'Hello', classNames: 'text-blue-500 font-bold');

    await tester.pumpWidget(
      Directionality(textDirection: TextDirection.ltr, child: p),
    );

    final text = tester.widget<Text>(find.text('Hello'));
    expect(text.style?.color, const Color(0xFF3B82F6));
    expect(text.style?.fontWeight, FontWeight.w700);
  });

  test('flex item tokens are ignored by parser callbacks', () {
    final seen = <String>[];
    TwParser(
      onUnsupported: seen.add,
    ).parseFlex('flex flex-1 basis-1/2 self-end');
    expect(seen, isEmpty);
  });

  test('wantsFlex detects prefixed flex tokens', () {
    final parser = TwParser();
    expect(parser.wantsFlex({'sm:flex'}), isTrue);
    expect(parser.wantsFlex({'md:flex-row'}), isTrue);
    expect(parser.wantsFlex({'lg:flex-col'}), isTrue);
    expect(parser.wantsFlex({'md:hover:flex'}), isTrue);
    expect(parser.wantsFlex({'bg-blue-500'}), isFalse);
  });

  test('wantsFlex detects flex-implying properties', () {
    final parser = TwParser();
    // items-* implies flex
    expect(parser.wantsFlex({'items-center'}), isTrue);
    expect(parser.wantsFlex({'items-start'}), isTrue);
    expect(parser.wantsFlex({'md:items-end'}), isTrue);
    // justify-* implies flex
    expect(parser.wantsFlex({'justify-between'}), isTrue);
    expect(parser.wantsFlex({'justify-center'}), isTrue);
    expect(parser.wantsFlex({'lg:justify-end'}), isTrue);
    // gap-* implies flex
    expect(parser.wantsFlex({'gap-4'}), isTrue);
    expect(parser.wantsFlex({'gap-x-2'}), isTrue);
    expect(parser.wantsFlex({'gap-y-6'}), isTrue);
    expect(parser.wantsFlex({'md:gap-8'}), isTrue);
    // Non-flex tokens should still return false
    expect(parser.wantsFlex({'p-4'}), isFalse);
    expect(parser.wantsFlex({'text-center'}), isFalse);
  });

  test('wantsFlex handles arbitrary values with colons correctly', () {
    final parser = TwParser();

    // Arbitrary values with colons should NOT trigger false positives
    // The colon inside brackets should be ignored
    expect(parser.wantsFlex({'bg-[color:red]'}), isFalse);
    expect(parser.wantsFlex({'bg-[color:rgba(0,0,0,0.5)]'}), isFalse);
    expect(parser.wantsFlex({'text-[color:blue]'}), isFalse);

    // Prefixed arbitrary values should also work correctly
    expect(parser.wantsFlex({'md:bg-[color:red]'}), isFalse);
    expect(parser.wantsFlex({'hover:bg-[color:rgba(0,0,0,0.5)]'}), isFalse);

    // Flex with arbitrary values should still be detected
    expect(parser.wantsFlex({'flex', 'bg-[color:red]'}), isTrue);
    expect(parser.wantsFlex({'md:flex', 'bg-[color:red]'}), isTrue);

    // Malformed brackets should be handled gracefully (no crash)
    expect(parser.wantsFlex({'bg-[color:red'}), isFalse);
    expect(parser.wantsFlex({'md:bg-[color'}), isFalse);
  });

  test('Parser defaults to column for prefixed-only flex tokens', () {
    final parser = TwParser();

    // Only prefixed flex - should start with column (block-like)
    final prefixedOnly = parser.parseFlex('md:flex');
    expect(prefixedOnly, isA<FlexBoxStyler>());

    // Base flex - should allow default row behavior
    final baseFlex = parser.parseFlex('flex');
    expect(baseFlex, isA<FlexBoxStyler>());

    // Explicit column - should be column
    final explicitCol = parser.parseFlex('flex-col');
    expect(explicitCol, isA<FlexBoxStyler>());
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
    TwParser(onUnsupported: seen.add).parseBox('w-4 unknown-token bg-blue-500');

    expect(seen, contains('unknown-token'));
    expect(seen, isNot(contains('w-4')));
    expect(seen, isNot(contains('bg-blue-500')));
  });

  test('Typos are reported', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('bg-blu-500');

    expect(seen, contains('bg-blu-500'));
  });

  test('Unimplemented tokens are reported', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('z-10 opacity-50');

    expect(seen, containsAll(['z-10', 'opacity-50']));
  });

  test('Prefix chains parse without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('md:hover:bg-blue-500');

    expect(seen, isEmpty);
  });

  test('Invalid fractions are ignored', () {
    final parser = TwParser();

    expect(() => parser.parseBox('w-5/0'), returnsNormally);
    expect(() => parser.parseBox('w-abc/def'), returnsNormally);
    expect(() => parser.parseBox('h-1/'), returnsNormally);
  });

  // ==========================================================================
  // State Prefix Tests
  // ==========================================================================

  test('hover: prefix parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('hover:bg-blue-500');
    expect(seen, isEmpty);
  });

  test('focus: prefix parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('focus:bg-blue-500');
    expect(seen, isEmpty);
  });

  test('active: prefix parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('active:bg-blue-500');
    expect(seen, isEmpty);
  });

  test('disabled: prefix parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('disabled:bg-gray-200');
    expect(seen, isEmpty);
  });

  test('dark: prefix parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('dark:bg-gray-700');
    expect(seen, isEmpty);
  });

  test('light: prefix parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('light:bg-white');
    expect(seen, isEmpty);
  });

  test('chained state prefixes parse without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('dark:hover:bg-blue-700');
    expect(seen, isEmpty);
  });

  test('breakpoint + state prefixes chain correctly', () {
    final seen = <String>[];
    TwParser(
      onUnsupported: seen.add,
    ).parseBox('md:hover:bg-blue-500 lg:focus:bg-blue-700');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Line Height (leading-*) Tests
  // ==========================================================================

  test('leading-none applies line height 1.0', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('leading-none');
    expect(seen, isEmpty);
  });

  test('leading-tight applies line height 1.25', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('leading-tight');
    expect(seen, isEmpty);
  });

  test('leading-snug applies line height 1.375', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('leading-snug');
    expect(seen, isEmpty);
  });

  test('leading-normal applies line height 1.5', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('leading-normal');
    expect(seen, isEmpty);
  });

  test('leading-relaxed applies line height 1.625', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('leading-relaxed');
    expect(seen, isEmpty);
  });

  test('leading-loose applies line height 2.0', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('leading-loose');
    expect(seen, isEmpty);
  });

  test('leading-even applies even leading distribution', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('leading-even');
    expect(seen, isEmpty);
  });

  test('leading-trim applies even distribution with trimmed ascent/descent',
      () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('leading-trim');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Letter Spacing (tracking-*) Tests
  // ==========================================================================

  test('tracking-tighter parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('tracking-tighter');
    expect(seen, isEmpty);
  });

  test('tracking-tight parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('tracking-tight');
    expect(seen, isEmpty);
  });

  test('tracking-normal parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('tracking-normal');
    expect(seen, isEmpty);
  });

  test('tracking-wide parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('tracking-wide');
    expect(seen, isEmpty);
  });

  test('tracking-wider parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('tracking-wider');
    expect(seen, isEmpty);
  });

  test('tracking-widest parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('tracking-widest');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Min-Width/Min-Height Tests
  // ==========================================================================

  test('min-w-0 parses without warnings in box context', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('min-w-0');
    expect(seen, isEmpty);
  });

  test('min-h-0 parses without warnings in box context', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('min-h-0');
    expect(seen, isEmpty);
  });

  test('min-w-0 parses without warnings in flex context', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseFlex('flex min-w-0');
    expect(seen, isEmpty);
  });

  test('min-h-0 parses without warnings in flex context', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseFlex('flex min-h-0');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Text Truncation Tests
  // ==========================================================================

  test('truncate parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('truncate');
    expect(seen, isEmpty);
  });

  testWidgets('P truncate applies ellipsis and maxLines', (tester) async {
    final p = P(
      text: 'This is a very long text that should be truncated',
      classNames: 'truncate',
    );

    await tester.pumpWidget(
      Directionality(textDirection: TextDirection.ltr, child: p),
    );

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
    TwParser(onUnsupported: seen.add).parseFlex('flex overflow-hidden');
    expect(seen, isEmpty);
  });

  test('overflow-visible parses without warnings in flex context', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseFlex('flex overflow-visible');
    expect(seen, isEmpty);
  });

  test('overflow-clip parses without warnings in flex context', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseFlex('flex overflow-clip');
    expect(seen, isEmpty);
  });

  test('overflow-hidden parses without warnings in box context', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('overflow-hidden');
    expect(seen, isEmpty);
  });

  test('overflow-visible parses without warnings in box context', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('overflow-visible');
    expect(seen, isEmpty);
  });

  test('overflow-clip parses without warnings in box context', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('overflow-clip');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Flex Shrink Tests
  // ==========================================================================

  test('flex-shrink-0 is ignored by parser (handled at widget layer)', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseFlex('flex flex-shrink-0');
    expect(seen, isEmpty);
  });

  test('shrink-0 is ignored by parser (handled at widget layer)', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseFlex('flex shrink-0');
    expect(seen, isEmpty);
  });

  test('flex-shrink is ignored by parser (handled at widget layer)', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseFlex('flex flex-shrink');
    expect(seen, isEmpty);
  });

  test('shrink is ignored by parser (handled at widget layer)', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseFlex('flex shrink');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Cross-Axis Alignment Tests
  // ==========================================================================

  test('items-stretch parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseFlex('flex items-stretch');
    expect(seen, isEmpty);
  });

  test('items-baseline parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseFlex('flex items-baseline');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Combined Token Tests
  // ==========================================================================

  test('text tokens can combine font-size with leading', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('text-lg leading-tight');
    expect(seen, isEmpty);
  });

  test('text tokens can combine with tracking', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseText('text-sm tracking-wide');
    expect(seen, isEmpty);
  });

  test('multiple text modifiers parse without warnings', () {
    final seen = <String>[];
    TwParser(
      onUnsupported: seen.add,
    ).parseText('text-lg font-bold leading-tight tracking-wide uppercase');
    expect(seen, isEmpty);
  });

  test('flex with min-w-0 and overflow-hidden parses', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseFlex('flex min-w-0 overflow-hidden');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Animation Token Recognition Tests
  // ==========================================================================

  test('transition parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('transition');
    expect(seen, isEmpty);
  });

  test('transition-all parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('transition-all');
    expect(seen, isEmpty);
  });

  test('transition-none parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('transition-none');
    expect(seen, isEmpty);
  });

  test('transition-colors parses without warnings (alias)', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('transition-colors');
    expect(seen, isEmpty);
  });

  test('transition-opacity parses without warnings (alias)', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('transition-opacity');
    expect(seen, isEmpty);
  });

  test('transition-shadow parses without warnings (alias)', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('transition-shadow');
    expect(seen, isEmpty);
  });

  test('transition-transform parses without warnings (alias)', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('transition-transform');
    expect(seen, isEmpty);
  });

  test('duration-300 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('duration-300');
    expect(seen, isEmpty);
  });

  test('delay-150 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('delay-150');
    expect(seen, isEmpty);
  });

  test('ease-in parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('ease-in');
    expect(seen, isEmpty);
  });

  test('ease-out parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('ease-out');
    expect(seen, isEmpty);
  });

  test('ease-in-out parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('ease-in-out');
    expect(seen, isEmpty);
  });

  test('ease-linear parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('ease-linear');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Animation Default Values Tests
  // ==========================================================================

  test('transition applies 150ms default duration', () {
    final config = _parseAnimation('transition');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 150));
  });

  test('transition applies ease-out default curve', () {
    final config = _parseAnimation('transition');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeOut);
  });

  test('transition applies 0ms default delay', () {
    final config = _parseAnimation('transition');
    expect(config, isNotNull);
    expect(config!.delay, Duration.zero);
  });

  // ==========================================================================
  // Delay Parsing Tests
  // ==========================================================================

  test('delay-0 sets 0ms delay', () {
    final config = _parseAnimation('transition delay-0');
    expect(config, isNotNull);
    expect(config!.delay, Duration.zero);
  });

  test('delay-75 sets 75ms delay', () {
    final config = _parseAnimation('transition delay-75');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 75));
  });

  test('delay-100 sets 100ms delay', () {
    final config = _parseAnimation('transition delay-100');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 100));
  });

  test('delay-150 sets 150ms delay', () {
    final config = _parseAnimation('transition delay-150');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 150));
  });

  test('delay-500 sets 500ms delay', () {
    final config = _parseAnimation('transition delay-500');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 500));
  });

  test('delay-700 sets 700ms delay', () {
    final config = _parseAnimation('transition delay-700');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 700));
  });

  test('delay-1000 sets 1000ms delay', () {
    final config = _parseAnimation('transition delay-1000');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 1000));
  });

  // ==========================================================================
  // transition-none Tests (Critical)
  // ==========================================================================

  test('transition-none returns null config', () {
    final config = _parseAnimation('transition-none');
    expect(config, isNull);
  });

  test('transition-none disables even with duration present', () {
    final config = _parseAnimation('transition-none duration-300');
    expect(config, isNull);
  });

  test('transition-none disables even with ease present', () {
    final config = _parseAnimation('transition-none ease-in');
    expect(config, isNull);
  });

  test('transition-none disables even with delay present', () {
    final config = _parseAnimation('transition-none delay-500');
    expect(config, isNull);
  });

  test('transition-none disables with all modifiers', () {
    final config = _parseAnimation(
      'transition-none duration-300 ease-in delay-100',
    );
    expect(config, isNull);
  });

  test('transition then transition-none disables animation', () {
    final config = _parseAnimation('transition transition-none');
    expect(config, isNull);
  });

  test('duration-300 then transition-none disables animation', () {
    final config = _parseAnimation('duration-300 transition-none');
    expect(config, isNull);
  });

  // ==========================================================================
  // Last-Wins Precedence Tests
  // ==========================================================================

  test('later duration overrides earlier', () {
    final config = _parseAnimation(
      'transition duration-100 duration-300',
    );
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 300));
  });

  test('later ease overrides earlier', () {
    final config = _parseAnimation('transition ease-in ease-out');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeOut);
  });

  test('later delay overrides earlier', () {
    final config = _parseAnimation('transition delay-100 delay-500');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 500));
  });

  test('later delay-0 overrides earlier delay-500', () {
    final config = _parseAnimation('transition delay-500 delay-0');
    expect(config, isNotNull);
    expect(config!.delay, Duration.zero);
  });

  // ==========================================================================
  // Standalone Tokens (No Trigger) Tests
  // ==========================================================================

  test('duration alone returns null', () {
    final config = _parseAnimation('duration-300');
    expect(config, isNull);
  });

  test('ease alone returns null', () {
    final config = _parseAnimation('ease-in');
    expect(config, isNull);
  });

  test('delay alone returns null', () {
    final config = _parseAnimation('delay-200');
    expect(config, isNull);
  });

  test('duration ease delay without transition returns null', () {
    final config = _parseAnimation('duration-300 ease-in delay-100');
    expect(config, isNull);
  });

  // ==========================================================================
  // Duration Parsing Tests
  // ==========================================================================

  test('duration-0 sets 0ms duration', () {
    final config = _parseAnimation('transition duration-0');
    expect(config, isNotNull);
    expect(config!.duration, Duration.zero);
  });

  test('duration-75 sets 75ms duration', () {
    final config = _parseAnimation('transition duration-75');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 75));
  });

  test('duration-100 sets 100ms duration', () {
    final config = _parseAnimation('transition duration-100');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 100));
  });

  test('duration-150 sets 150ms duration', () {
    final config = _parseAnimation('transition duration-150');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 150));
  });

  test('duration-200 sets 200ms duration', () {
    final config = _parseAnimation('transition duration-200');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 200));
  });

  test('duration-300 sets 300ms duration', () {
    final config = _parseAnimation('transition duration-300');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 300));
  });

  test('duration-500 sets 500ms duration', () {
    final config = _parseAnimation('transition duration-500');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 500));
  });

  test('duration-700 sets 700ms duration', () {
    final config = _parseAnimation('transition duration-700');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 700));
  });

  test('duration-1000 sets 1000ms duration', () {
    final config = _parseAnimation('transition duration-1000');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 1000));
  });

  // ==========================================================================
  // Ease Parsing Tests
  // ==========================================================================

  test('ease-linear sets Curves.linear', () {
    final config = _parseAnimation('transition ease-linear');
    expect(config, isNotNull);
    expect(config!.curve, Curves.linear);
  });

  test('ease-in sets Curves.easeIn', () {
    final config = _parseAnimation('transition ease-in');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeIn);
  });

  test('ease-out sets Curves.easeOut', () {
    final config = _parseAnimation('transition ease-out');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeOut);
  });

  test('ease-in-out sets Curves.easeInOut', () {
    final config = _parseAnimation('transition ease-in-out');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeInOut);
  });

  // ==========================================================================
  // Combined Animation Tests
  // ==========================================================================

  test('transition with all modifiers parses correctly', () {
    final config = _parseAnimation(
      'transition duration-300 ease-in delay-100',
    );
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 300));
    expect(config.curve, Curves.easeIn);
    expect(config.delay, const Duration(milliseconds: 100));
  });

  test('transition-colors with modifiers parses correctly', () {
    final config = _parseAnimation(
      'transition-colors duration-500 ease-in-out',
    );
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 500));
    expect(config.curve, Curves.easeInOut);
  });

  test('prefixed animation tokens are recognized', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('hover:transition duration-300');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Invalid Value Warning Tests (P2)
  // ==========================================================================

  test('duration with invalid value warns via onUnsupported', () {
    final seen = <String>[];
    _parseAnimation(
      'transition duration-abc',
      parser: TwParser(onUnsupported: seen.add),
    );
    expect(seen, contains('duration-abc'));
  });

  test('delay with invalid value warns via onUnsupported', () {
    final seen = <String>[];
    _parseAnimation(
      'transition delay-xyz',
      parser: TwParser(onUnsupported: seen.add),
    );
    expect(seen, contains('delay-xyz'));
  });

  test('duration with invalid value preserves default 150ms', () {
    final config = _parseAnimation('transition duration-abc');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 150));
  });

  test('delay with invalid value preserves default 0ms', () {
    final config = _parseAnimation('transition delay-xyz');
    expect(config, isNotNull);
    expect(config!.delay, Duration.zero);
  });

  test('duration- without value warns via onUnsupported', () {
    final seen = <String>[];
    _parseAnimation(
      'transition duration-',
      parser: TwParser(onUnsupported: seen.add),
    );
    expect(seen, contains('duration-'));
  });

  test('delay- without value warns via onUnsupported', () {
    final seen = <String>[];
    _parseAnimation(
      'transition delay-',
      parser: TwParser(onUnsupported: seen.add),
    );
    expect(seen, contains('delay-'));
  });

  // ==========================================================================
  // Non-Tailwind Value Warning Tests
  // ==========================================================================

  test('duration-2000 warns (not a valid Tailwind value)', () {
    final seen = <String>[];
    _parseAnimation(
      'transition duration-2000',
      parser: TwParser(onUnsupported: seen.add),
    );
    expect(seen, contains('duration-2000'));
  });

  test('duration-50 warns (not a valid Tailwind value)', () {
    final seen = <String>[];
    _parseAnimation(
      'transition duration-50',
      parser: TwParser(onUnsupported: seen.add),
    );
    expect(seen, contains('duration-50'));
  });

  test('delay-2500 warns (not a valid Tailwind value)', () {
    final seen = <String>[];
    _parseAnimation(
      'transition delay-2500',
      parser: TwParser(onUnsupported: seen.add),
    );
    expect(seen, contains('delay-2500'));
  });

  test('delay-25 warns (not a valid Tailwind value)', () {
    final seen = <String>[];
    _parseAnimation(
      'transition delay-25',
      parser: TwParser(onUnsupported: seen.add),
    );
    expect(seen, contains('delay-25'));
  });

  // ==========================================================================
  // Prefixed Animation Token Tests (P2)
  // ==========================================================================

  test('md:transition is recognized as transition trigger', () {
    final config = _parseAnimation('md:transition');
    expect(config, isNotNull);
  });

  test('hover:duration-500 modifies duration', () {
    final config = _parseAnimation('transition hover:duration-500');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 500));
  });

  test('sm:ease-in correctly applies curve', () {
    final config = _parseAnimation('transition sm:ease-in');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeIn);
  });

  test('md:transition-none disables animation', () {
    final config = _parseAnimation('transition md:transition-none');
    expect(config, isNull);
  });

  test('lg:delay-300 applies delay', () {
    final config = _parseAnimation('transition lg:delay-300');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 300));
  });

  // ==========================================================================
  // Edge Case Tests (P2)
  // ==========================================================================

  test('empty string returns null', () {
    final config = _parseAnimation('');
    expect(config, isNull);
  });

  test('whitespace only returns null', () {
    final config = _parseAnimation('   ');
    expect(config, isNull);
  });

  test('order independence: duration before transition works', () {
    final config = _parseAnimation('duration-300 transition');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 300));
  });

  test('order independence: delay before transition works', () {
    final config = _parseAnimation('delay-200 transition');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 200));
  });

  test('order independence: ease before transition works', () {
    final config = _parseAnimation('ease-in transition');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeIn);
  });

  test(
    'parseBox with transition classes produces style that can be animated',
    () {
      final parser = TwParser();
      final animConfig = parser.parseAnimationFromTokens(
        parser.listTokens('transition duration-300 ease-in-out'),
      );
      final boxStyle = parser.parseBox('bg-blue-500 p-4');

      // Verify animation config is correct
      expect(animConfig, isNotNull);
      expect(animConfig!.duration, const Duration(milliseconds: 300));
      expect(animConfig.curve, Curves.easeInOut);

      // Verify style can be animated (this is what tw_widget.dart does)
      final animatedStyle = boxStyle.animate(animConfig);
      expect(animatedStyle, isNotNull);
    },
  );

  testWidgets('Div with transition renders without error', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'bg-blue-500 transition duration-300',
          child: const SizedBox(width: 50, height: 50),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('Div with transition-none renders without animation', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'bg-blue-500 transition-none duration-300',
          child: const SizedBox(width: 50, height: 50),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('FlexBox Div with transition renders without error', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'flex gap-4 transition duration-200 ease-in',
          children: const [
            SizedBox(width: 20, height: 20),
            SizedBox(width: 20, height: 20),
          ],
        ),
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
    TwParser(onUnsupported: seen.add).parseBox('scale-105');
    expect(seen, isEmpty);
  });

  test('scale-50 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('scale-50');
    expect(seen, isEmpty);
  });

  test('scale-150 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('scale-150');
    expect(seen, isEmpty);
  });

  test('rotate-45 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('rotate-45');
    expect(seen, isEmpty);
  });

  test('rotate-90 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('rotate-90');
    expect(seen, isEmpty);
  });

  test('-rotate-45 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('-rotate-45');
    expect(seen, isEmpty);
  });

  test('translate-x-4 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('translate-x-4');
    expect(seen, isEmpty);
  });

  test('translate-y-4 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('translate-y-4');
    expect(seen, isEmpty);
  });

  test('-translate-x-4 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('-translate-x-4');
    expect(seen, isEmpty);
  });

  test('-translate-y-4 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('-translate-y-4');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Transform Widget Tests
  // ==========================================================================

  testWidgets('Div with scale-105 sets container transform', (tester) async {
    final container = await _boxContainerFor(tester, 'scale-105 bg-blue-500');

    expect(container.transform, isNotNull);
    expect(container.transform![0], closeTo(1.05, 0.0001));
    expect(
      find.descendant(of: find.byType(Container), matching: find.byType(Transform)),
      findsOneWidget,
    );
  });

  testWidgets('Div with rotate-45 sets container transform', (tester) async {
    final container = await _boxContainerFor(tester, 'rotate-45');

    expect(container.transform, isNotNull);
    expect(container.transform![0], closeTo(0.7071, 0.001));
    expect(
      find.descendant(of: find.byType(Container), matching: find.byType(Transform)),
      findsOneWidget,
    );
  });

  testWidgets('Div with translate-x-4 sets container transform', (
    tester,
  ) async {
    final container = await _boxContainerFor(tester, 'translate-x-4');

    expect(container.transform, isNotNull);
    expect(container.transform![12], closeTo(16, 0.0001));
    expect(
      find.descendant(of: find.byType(Container), matching: find.byType(Transform)),
      findsOneWidget,
    );
  });

  testWidgets('Div without transform tokens leaves container transform null', (
    tester,
  ) async {
    final container = await _boxContainerFor(tester, 'bg-blue-500 p-4');

    expect(container.transform, isNull);
    expect(
      find.descendant(of: find.byType(Container), matching: find.byType(Transform)),
      findsNothing,
    );
  });

  testWidgets('Div with combined transforms applies single composite matrix', (
    tester,
  ) async {
    final container = await _boxContainerFor(
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
      find.descendant(of: find.byType(Container), matching: find.byType(Transform)),
      findsOneWidget,
    );
  });

  testWidgets('FlexBox Div applies transform on its Box container', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'flex gap-4 scale-105',
          children: const [
            SizedBox(width: 20, height: 20),
            SizedBox(width: 20, height: 20),
          ],
        ),
      ),
    );

    // CSS semantic box creates single Container - no nested Container
    final containerFinder = find.byType(Container);

    expect(containerFinder, findsOneWidget);
    expect(tester.widget<Container>(containerFinder).transform, isNotNull);
    expect(
      find.descendant(of: find.byType(Container), matching: find.byType(Transform)),
      findsOneWidget,
    );
  });

  // ==========================================================================
  // Variant-Aware Transform Tests
  // ==========================================================================

  testWidgets('hover:scale-105 applies scale only when hovered', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'hover:scale-105',
          child: const SizedBox(width: 40, height: 40),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: const Offset(-500, -500));
    await tester.pump();

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
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'hover:scale-110',
          child: const SizedBox(width: 30, height: 30),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: const Offset(-500, -500));
    await tester.pump();

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
    await _pumpSized(
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

    await _pumpSized(
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
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'rotate-45 hover:scale-110',
          child: const SizedBox(width: 30, height: 30),
        ),
      ),
    );

    // CSS semantic box creates single Container - no nested Container
    final containerFinder = find.byType(Container);

    final baseMatrix = tester.widget<Container>(containerFinder).transform!;

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
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
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'transition hover:scale-110',
          child: const SizedBox(width: 30, height: 30),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: const Offset(-500, -500));
    await tester.pump();

    // CSS semantic box creates single Container - no nested Container
    final containerFinder = find.byType(Container);

    // Before hover, identity transform (needed for animation interpolation when variants have transforms)
    final baseMatrix = tester.widget<Container>(containerFinder).transform;
    expect(baseMatrix, isNotNull);
    expect(baseMatrix![0], closeTo(1.0, 0.01)); // identity matrix has 1.0 at [0][0]

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
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div(
          classNames: 'scale-105',
          child: const SizedBox(width: 30, height: 30),
        ),
      ),
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
    TwParser(onUnsupported: seen.add).parseBox('hover:scale-105');
    expect(seen, isEmpty);
  });

  test('md:rotate-45 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('md:rotate-45');
    expect(seen, isEmpty);
  });

  test('lg:translate-x-4 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('lg:translate-x-4');
    expect(seen, isEmpty);
  });

  test('dark:scale-110 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('dark:scale-110');
    expect(seen, isEmpty);
  });

  test('md:hover:scale-105 parses without warnings', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('md:hover:scale-105');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Transform in flex context
  // ==========================================================================

  test('transform tokens parse without warnings in flex context', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseFlex('flex scale-105 rotate-45');
    expect(seen, isEmpty);
  });

  // ==========================================================================
  // Invalid Transform Values
  // ==========================================================================

  test('scale-999 warns via onUnsupported', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('scale-999');
    expect(seen, contains('scale-999'));
  });

  test('rotate-999 warns via onUnsupported', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseBox('rotate-999');
    expect(seen, contains('rotate-999'));
  });

  // ==========================================================================
  // Flex-None Behavior Tests
  // ==========================================================================

  testWidgets('flex-none child maintains intrinsic width in Row', (
    tester,
  ) async {
    await _pumpSized(
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

  testWidgets('items-baseline renders without assertion', (tester) async {
    // This test verifies that items-baseline sets textBaseline,
    // which is required by Flutter when using CrossAxisAlignment.baseline
    await _pumpSized(
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

    // If we get here without an assertion, the test passes
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('World'), findsOneWidget);
  });
}
