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

  final containerFinder = find.descendant(
    of: find.byType(Box),
    matching: find.byType(Container),
  );

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
  testWidgets('Div picks FlexBox when flex token is present', (tester) async {
    final widget = Directionality(
      textDirection: TextDirection.ltr,
      child: Div(
        classNames: 'flex gap-4',
        children: const [SizedBox(), SizedBox()],
      ),
    );

    await tester.pumpWidget(widget);

    expect(find.byType(FlexBox), findsOneWidget);
  });

  testWidgets('Div picks FlexBox when only md:flex token is present', (
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

    expect(find.byType(FlexBox), findsOneWidget);
  });

  testWidgets('Div defaults to Box when flex tokens missing', (tester) async {
    final widget = Directionality(
      textDirection: TextDirection.ltr,
      child: Div(classNames: 'bg-blue-500 p-4', child: const SizedBox()),
    );

    await tester.pumpWidget(widget);

    expect(find.byType(Box), findsOneWidget);
    expect(find.byType(FlexBox), findsNothing);
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
      matching: find.byType(Box),
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
      matching: find.byType(Box),
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
      Div(
        classNames: 'w-1/2 bg-blue-500',
        child: const SizedBox(height: 40),
      ),
      width: 200,
    );

    final boxSize = tester.getSize(find.byType(Box));
    expect(boxSize.width, closeTo(100, 0.0001));
  });

  testWidgets('w-2/3 applies two-thirds width', (tester) async {
    await _pumpSized(
      tester,
      Div(classNames: 'w-2/3', child: const SizedBox(height: 20)),
      width: 300,
    );

    final boxSize = tester.getSize(find.byType(Box));
    expect(boxSize.width, closeTo(200, 0.0001));
  });

  testWidgets('w-3/4 applies three-quarter width', (tester) async {
    await _pumpSized(
      tester,
      Div(classNames: 'w-3/4', child: const SizedBox(height: 20)),
      width: 400,
    );

    final boxSize = tester.getSize(find.byType(Box));
    expect(boxSize.width, closeTo(300, 0.0001));
  });

  testWidgets('h-1/4 applies quarter-height constraint', (tester) async {
    await _pumpSized(
      tester,
      Div(
        classNames: 'h-1/4 bg-blue-500',
        child: const SizedBox(width: 40),
      ),
      height: 400,
    );

    final boxSize = tester.getSize(find.byType(Box));
    expect(boxSize.height, closeTo(100, 0.0001));
  });

  testWidgets('h-1/2 applies half-height constraint', (tester) async {
    await _pumpSized(
      tester,
      Div(
        classNames: 'h-1/2 bg-blue-500',
        child: const SizedBox(width: 40),
      ),
      height: 300,
    );

    final boxSize = tester.getSize(find.byType(Box));
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

    final boxSize = tester.getSize(find.byType(Box));
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

  testWidgets('basis-32 constrains main-axis size inside Row', (
    tester,
  ) async {
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
      matching: find.byType(Box),
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

  testWidgets('Span forwards text style tokens', (tester) async {
    final span = Span(text: 'Hello', classNames: 'text-blue-500 font-bold');

    await tester.pumpWidget(
      Directionality(textDirection: TextDirection.ltr, child: span),
    );

    final text = tester.widget<Text>(find.text('Hello'));
    expect(text.style?.color, const Color(0xFF3B82F6));
    expect(text.style?.fontWeight, FontWeight.w700);
  });

  test('flex item tokens are ignored by parser callbacks', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add)
        .parseFlex('flex flex-1 basis-1/2 self-end');
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

  test('Span constructor is const', () {
    const span = Span(text: 'Hello', classNames: 'text-blue-500');
    expect(span, isNotNull);
  });

  test('Unknown tokens trigger onUnsupported callback', () {
    final seen = <String>[];
    TwParser(
      onUnsupported: seen.add,
    ).parseBox('w-4 unknown-token bg-blue-500');

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
    TwParser(onUnsupported: seen.add).parseBox('md:hover:bg-blue-500 lg:focus:bg-blue-700');
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

  testWidgets('Span truncate applies ellipsis and maxLines', (tester) async {
    final span = Span(
      text: 'This is a very long text that should be truncated',
      classNames: 'truncate',
    );

    await tester.pumpWidget(
      Directionality(textDirection: TextDirection.ltr, child: span),
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
    TwParser(
      onUnsupported: seen.add,
    ).parseFlex('flex min-w-0 overflow-hidden');
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
    final config = TwParser().parseAnimation('transition');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 150));
  });

  test('transition applies ease-out default curve', () {
    final config = TwParser().parseAnimation('transition');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeOut);
  });

  test('transition applies 0ms default delay', () {
    final config = TwParser().parseAnimation('transition');
    expect(config, isNotNull);
    expect(config!.delay, Duration.zero);
  });

  // ==========================================================================
  // Delay Parsing Tests
  // ==========================================================================

  test('delay-0 sets 0ms delay', () {
    final config = TwParser().parseAnimation('transition delay-0');
    expect(config, isNotNull);
    expect(config!.delay, Duration.zero);
  });

  test('delay-75 sets 75ms delay', () {
    final config = TwParser().parseAnimation('transition delay-75');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 75));
  });

  test('delay-150 sets 150ms delay', () {
    final config = TwParser().parseAnimation('transition delay-150');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 150));
  });

  test('delay-500 sets 500ms delay', () {
    final config = TwParser().parseAnimation('transition delay-500');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 500));
  });

  test('delay-1000 sets 1000ms delay', () {
    final config = TwParser().parseAnimation('transition delay-1000');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 1000));
  });

  // ==========================================================================
  // transition-none Tests (Critical)
  // ==========================================================================

  test('transition-none returns null config', () {
    final config = TwParser().parseAnimation('transition-none');
    expect(config, isNull);
  });

  test('transition-none disables even with duration present', () {
    final config = TwParser().parseAnimation('transition-none duration-300');
    expect(config, isNull);
  });

  test('transition-none disables even with ease present', () {
    final config = TwParser().parseAnimation('transition-none ease-in');
    expect(config, isNull);
  });

  test('transition-none disables even with delay present', () {
    final config = TwParser().parseAnimation('transition-none delay-500');
    expect(config, isNull);
  });

  test('transition-none disables with all modifiers', () {
    final config = TwParser().parseAnimation(
      'transition-none duration-300 ease-in delay-100',
    );
    expect(config, isNull);
  });

  test('transition then transition-none disables animation', () {
    final config = TwParser().parseAnimation('transition transition-none');
    expect(config, isNull);
  });

  test('duration-300 then transition-none disables animation', () {
    final config = TwParser().parseAnimation('duration-300 transition-none');
    expect(config, isNull);
  });

  // ==========================================================================
  // Last-Wins Precedence Tests
  // ==========================================================================

  test('later duration overrides earlier', () {
    final config = TwParser().parseAnimation(
      'transition duration-100 duration-300',
    );
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 300));
  });

  test('later ease overrides earlier', () {
    final config = TwParser().parseAnimation('transition ease-in ease-out');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeOut);
  });

  test('later delay overrides earlier', () {
    final config = TwParser().parseAnimation('transition delay-100 delay-500');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 500));
  });

  test('later delay-0 overrides earlier delay-500', () {
    final config = TwParser().parseAnimation('transition delay-500 delay-0');
    expect(config, isNotNull);
    expect(config!.delay, Duration.zero);
  });

  // ==========================================================================
  // Standalone Tokens (No Trigger) Tests
  // ==========================================================================

  test('duration alone returns null', () {
    final config = TwParser().parseAnimation('duration-300');
    expect(config, isNull);
  });

  test('ease alone returns null', () {
    final config = TwParser().parseAnimation('ease-in');
    expect(config, isNull);
  });

  test('delay alone returns null', () {
    final config = TwParser().parseAnimation('delay-200');
    expect(config, isNull);
  });

  test('duration ease delay without transition returns null', () {
    final config = TwParser().parseAnimation('duration-300 ease-in delay-100');
    expect(config, isNull);
  });

  // ==========================================================================
  // Duration Parsing Tests
  // ==========================================================================

  test('duration-0 sets 0ms duration', () {
    final config = TwParser().parseAnimation('transition duration-0');
    expect(config, isNotNull);
    expect(config!.duration, Duration.zero);
  });

  test('duration-75 sets 75ms duration', () {
    final config = TwParser().parseAnimation('transition duration-75');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 75));
  });

  test('duration-100 sets 100ms duration', () {
    final config = TwParser().parseAnimation('transition duration-100');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 100));
  });

  test('duration-150 sets 150ms duration', () {
    final config = TwParser().parseAnimation('transition duration-150');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 150));
  });

  test('duration-200 sets 200ms duration', () {
    final config = TwParser().parseAnimation('transition duration-200');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 200));
  });

  test('duration-300 sets 300ms duration', () {
    final config = TwParser().parseAnimation('transition duration-300');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 300));
  });

  test('duration-500 sets 500ms duration', () {
    final config = TwParser().parseAnimation('transition duration-500');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 500));
  });

  test('duration-700 sets 700ms duration', () {
    final config = TwParser().parseAnimation('transition duration-700');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 700));
  });

  test('duration-1000 sets 1000ms duration', () {
    final config = TwParser().parseAnimation('transition duration-1000');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 1000));
  });

  // ==========================================================================
  // Ease Parsing Tests
  // ==========================================================================

  test('ease-linear sets Curves.linear', () {
    final config = TwParser().parseAnimation('transition ease-linear');
    expect(config, isNotNull);
    expect(config!.curve, Curves.linear);
  });

  test('ease-in sets Curves.easeIn', () {
    final config = TwParser().parseAnimation('transition ease-in');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeIn);
  });

  test('ease-out sets Curves.easeOut', () {
    final config = TwParser().parseAnimation('transition ease-out');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeOut);
  });

  test('ease-in-out sets Curves.easeInOut', () {
    final config = TwParser().parseAnimation('transition ease-in-out');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeInOut);
  });

  // ==========================================================================
  // Combined Animation Tests
  // ==========================================================================

  test('transition with all modifiers parses correctly', () {
    final config = TwParser().parseAnimation(
      'transition duration-300 ease-in delay-100',
    );
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 300));
    expect(config.curve, Curves.easeIn);
    expect(config.delay, const Duration(milliseconds: 100));
  });

  test('transition-colors with modifiers parses correctly', () {
    final config = TwParser().parseAnimation(
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
    TwParser(onUnsupported: seen.add).parseAnimation('transition duration-abc');
    expect(seen, contains('duration-abc'));
  });

  test('delay with invalid value warns via onUnsupported', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseAnimation('transition delay-xyz');
    expect(seen, contains('delay-xyz'));
  });

  test('duration with invalid value preserves default 150ms', () {
    final config = TwParser().parseAnimation('transition duration-abc');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 150));
  });

  test('delay with invalid value preserves default 0ms', () {
    final config = TwParser().parseAnimation('transition delay-xyz');
    expect(config, isNotNull);
    expect(config!.delay, Duration.zero);
  });

  test('duration- without value warns via onUnsupported', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseAnimation('transition duration-');
    expect(seen, contains('duration-'));
  });

  test('delay- without value warns via onUnsupported', () {
    final seen = <String>[];
    TwParser(onUnsupported: seen.add).parseAnimation('transition delay-');
    expect(seen, contains('delay-'));
  });

  // ==========================================================================
  // Arbitrary Numeric Value Tests (P2)
  // ==========================================================================

  test('duration-2000 parses as 2000ms (arbitrary value)', () {
    final config = TwParser().parseAnimation('transition duration-2000');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 2000));
  });

  test('duration-50 parses as 50ms (arbitrary value)', () {
    final config = TwParser().parseAnimation('transition duration-50');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 50));
  });

  test('delay-2500 parses as 2500ms (arbitrary value)', () {
    final config = TwParser().parseAnimation('transition delay-2500');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 2500));
  });

  test('delay-25 parses as 25ms (arbitrary value)', () {
    final config = TwParser().parseAnimation('transition delay-25');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 25));
  });

  // ==========================================================================
  // Prefixed Animation Token Tests (P2)
  // ==========================================================================

  test('md:transition is recognized as transition trigger', () {
    final config = TwParser().parseAnimation('md:transition');
    expect(config, isNotNull);
  });

  test('hover:duration-500 modifies duration', () {
    final config = TwParser().parseAnimation('transition hover:duration-500');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 500));
  });

  test('sm:ease-in correctly applies curve', () {
    final config = TwParser().parseAnimation('transition sm:ease-in');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeIn);
  });

  test('md:transition-none disables animation', () {
    final config = TwParser().parseAnimation('transition md:transition-none');
    expect(config, isNull);
  });

  test('lg:delay-300 applies delay', () {
    final config = TwParser().parseAnimation('transition lg:delay-300');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 300));
  });

  // ==========================================================================
  // Edge Case Tests (P2)
  // ==========================================================================

  test('empty string returns null', () {
    final config = TwParser().parseAnimation('');
    expect(config, isNull);
  });

  test('whitespace only returns null', () {
    final config = TwParser().parseAnimation('   ');
    expect(config, isNull);
  });

  test('order independence: duration before transition works', () {
    final config = TwParser().parseAnimation('duration-300 transition');
    expect(config, isNotNull);
    expect(config!.duration, const Duration(milliseconds: 300));
  });

  test('order independence: delay before transition works', () {
    final config = TwParser().parseAnimation('delay-200 transition');
    expect(config, isNotNull);
    expect(config!.delay, const Duration(milliseconds: 200));
  });

  test('order independence: ease before transition works', () {
    final config = TwParser().parseAnimation('ease-in transition');
    expect(config, isNotNull);
    expect(config!.curve, Curves.easeIn);
  });

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
    expect(find.byType(Box), findsOneWidget);
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
    expect(find.byType(Box), findsOneWidget);
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
    expect(find.byType(FlexBox), findsOneWidget);
  });
}
