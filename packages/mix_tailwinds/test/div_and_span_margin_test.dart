import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

import 'div_and_span_test_helpers.dart';

void main() {
  group('P margin utilities', () {
    testWidgets('P without margin renders without Padding wrapper', (
      tester,
    ) async {
      await pumpLtr(
        tester,
        const P(text: 'Hello', classNames: 'text-lg font-bold'),
      );

      expect(find.byType(StyledText), findsOneWidget);
      expect(find.byType(Padding), findsNothing);
      final root = find.byType(P);
      expect(root, findsOneWidget);
      expect(tester.element(root).widget, isA<P>());
    });

    testWidgets('P with mb-4 applies bottom margin via Padding', (
      tester,
    ) async {
      await pumpLtr(
        tester,
        const P(text: 'Paragraph', classNames: 'text-sm mb-4'),
      );

      final edgeInsets = singlePaddingInsets(tester);
      expect(edgeInsets.bottom, 16);
      expect(edgeInsets.top, 0);
      expect(edgeInsets.left, 0);
      expect(edgeInsets.right, 0);
    });

    testWidgets('P with m-4 applies margin on all sides', (tester) async {
      await pumpLtr(tester, const P(text: 'Spaced', classNames: 'm-4'));

      final edgeInsets = singlePaddingInsets(tester);
      expect(edgeInsets.top, 16);
      expect(edgeInsets.right, 16);
      expect(edgeInsets.bottom, 16);
      expect(edgeInsets.left, 16);
    });

    testWidgets('P with mx-4 my-2 applies horizontal and vertical margins', (
      tester,
    ) async {
      await pumpLtr(tester, const P(text: 'Mixed', classNames: 'mx-4 my-2'));

      final edgeInsets = singlePaddingInsets(tester);
      expect(edgeInsets.left, 16);
      expect(edgeInsets.right, 16);
      expect(edgeInsets.top, 8);
      expect(edgeInsets.bottom, 8);
    });

    testWidgets('P with individual margins mt-2 mr-4 mb-6 ml-8', (
      tester,
    ) async {
      await pumpLtr(
        tester,
        const P(text: 'Individual', classNames: 'mt-2 mr-4 mb-6 ml-8'),
      );

      final edgeInsets = singlePaddingInsets(tester);
      expect(edgeInsets.top, 8);
      expect(edgeInsets.right, 16);
      expect(edgeInsets.bottom, 24);
      expect(edgeInsets.left, 32);
    });

    testWidgets('P margin combined with text styles', (tester) async {
      await pumpLtr(
        tester,
        const P(
          text: 'Styled',
          classNames: 'text-slate-300 text-sm mb-4 font-medium',
        ),
      );

      expect(find.byType(StyledText), findsOneWidget);
      expect(singlePaddingInsets(tester).bottom, 16);
    });

    testWidgets('P margin expands the hit-testable layout bounds', (
      tester,
    ) async {
      await pumpLtr(
        tester,
        const SizedBox(
          width: 200,
          child: P(text: 'Hit', classNames: 'mt-8'),
        ),
      );

      final paddingSize = tester.getSize(find.byType(Padding));
      final textSize = tester.getSize(find.byType(StyledText));

      expect(paddingSize.height, greaterThan(textSize.height));
      expect(paddingSize.height - textSize.height, 32);
    });
  });

  group('H1-H6 margin utilities', () {
    testWidgets('H1 with mb-4 applies bottom margin', (tester) async {
      await pumpLtr(
        tester,
        const H1(text: 'Heading', classNames: 'text-4xl font-bold mb-4'),
      );

      expect(singlePaddingInsets(tester).bottom, 16);
    });

    testWidgets('H2 with my-4 applies vertical margins', (tester) async {
      await pumpLtr(
        tester,
        const H2(text: 'Section', classNames: 'text-3xl my-4'),
      );

      final edgeInsets = singlePaddingInsets(tester);
      expect(edgeInsets.top, 16);
      expect(edgeInsets.bottom, 16);
    });

    testWidgets('H3 with m-2 applies margin all sides', (tester) async {
      await pumpLtr(
        tester,
        const H3(text: 'Subsection', classNames: 'text-2xl m-2'),
      );

      final edgeInsets = singlePaddingInsets(tester);
      expect(edgeInsets.top, 8);
      expect(edgeInsets.right, 8);
      expect(edgeInsets.bottom, 8);
      expect(edgeInsets.left, 8);
    });

    testWidgets('H4 without margin renders without Padding', (tester) async {
      await pumpLtr(
        tester,
        const H4(text: 'Title', classNames: 'text-xl font-semibold'),
      );

      expect(find.byType(StyledText), findsOneWidget);
      expect(find.byType(Padding), findsNothing);
    });

    testWidgets('H5 with mb-1 applies small bottom margin', (tester) async {
      await pumpLtr(
        tester,
        const H5(text: 'Label', classNames: 'text-lg mb-1'),
      );

      expect(singlePaddingInsets(tester).bottom, 4);
    });

    testWidgets('H6 with mx-2 applies horizontal margins', (tester) async {
      await pumpLtr(
        tester,
        const H6(text: 'Small', classNames: 'text-base mx-2'),
      );

      final edgeInsets = singlePaddingInsets(tester);
      expect(edgeInsets.left, 8);
      expect(edgeInsets.right, 8);
      expect(edgeInsets.top, 0);
      expect(edgeInsets.bottom, 0);
    });
  });
}
