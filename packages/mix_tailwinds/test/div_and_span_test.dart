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
}
