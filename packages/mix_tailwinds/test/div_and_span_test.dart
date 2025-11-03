import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

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

  testWidgets('Div defaults to Box when flex tokens missing', (tester) async {
    final widget = Directionality(
      textDirection: TextDirection.ltr,
      child: Div(
        classNames: 'bg-blue-500 p-4',
        child: const SizedBox(),
      ),
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

  testWidgets('Span forwards text style tokens', (tester) async {
    final span = Span(
      text: 'Hello',
      classNames: 'text-blue-500 font-bold',
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: span,
      ),
    );

    final text = tester.widget<Text>(find.text('Hello'));
    expect(text.style?.color, const Color(0xFF3B82F6));
    expect(text.style?.fontWeight, FontWeight.w700);
  });

  test('flex-* item tokens trigger unsupported callback', () {
    final seen = <String>[];
    TwParserV2(onUnsupported: seen.add).parseFlex('flex flex-1 flex-grow');
    expect(seen, ['flex-1', 'flex-grow']);
  });

  test('wantsFlex detects prefixed flex tokens', () {
    final parser = TwParserV2();
    expect(parser.wantsFlex({'sm:flex'}), isTrue);
    expect(parser.wantsFlex({'md:flex-row'}), isTrue);
    expect(parser.wantsFlex({'lg:flex-col'}), isTrue);
    expect(parser.wantsFlex({'md:hover:flex'}), isTrue);
    expect(parser.wantsFlex({'bg-blue-500'}), isFalse);
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
    TwParserV2(onUnsupported: seen.add)
        .parseBox('w-4 unknown-token bg-blue-500');

    expect(seen, contains('unknown-token'));
    expect(seen, isNot(contains('w-4')));
    expect(seen, isNot(contains('bg-blue-500')));
  });

  test('Typos are reported', () {
    final seen = <String>[];
    TwParserV2(onUnsupported: seen.add).parseBox('bg-blu-500');

    expect(seen, contains('bg-blu-500'));
  });

  test('Unimplemented tokens are reported', () {
    final seen = <String>[];
    TwParserV2(onUnsupported: seen.add).parseBox('z-10 opacity-50');

    expect(seen, containsAll(['z-10', 'opacity-50']));
  });
}
