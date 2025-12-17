import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

void main() {
  testWidgets('smoke test: renders nested Div and P without warnings', (
    tester,
  ) async {
    final unsupported = <String>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 240,
          height: 180,
          child: Div(
            classNames: 'md:flex flex-col gap-4 p-4 w-full h-full bg-blue-500',
            onUnsupported: unsupported.add,
            children: const [
              P(text: 'Title', classNames: 'text-white font-semibold text-xl'),
              Div(
                classNames: 'flex gap-2',
                children: [
                  P(
                    text: 'Primary',
                    classNames: 'bg-white text-blue-700 px-3 py-1 rounded',
                  ),
                  P(
                    text: 'Secondary',
                    classNames: 'bg-blue-700 text-white px-3 py-1 rounded',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // CSS semantic widgets use Flex directly instead of FlexBox
    // Two flex divs: outer with md:flex and inner with flex
    expect(find.byType(Flex), findsNWidgets(2));
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Primary'), findsOneWidget);
    expect(find.text('Secondary'), findsOneWidget);
    expect(unsupported, isEmpty);
  });
}
