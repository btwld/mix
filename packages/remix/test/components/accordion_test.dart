import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxAccordion', () {
    group('Constructor', () {
      const initialExpandedValues = ['section1'];
      const variants = [Variant('primary')];
      final style = RxAccordionStyle();
      final children = [
        RxAccordionItem(
          title: 'Section 1',
          value: 'section1',
          child: const Text('Content for section 1'),
        ),
        RxAccordionItem(
          title: 'Section 2',
          value: 'section2',
          child: const Text('Content for section 2'),
        ),
      ];
      final controller = RxAccordionController<String>(
        min: 0,
        max: 1,
      );
      const defaultTrailingIcon = Icons.add;

      testWidgets('should initialize with correct properties', (tester) async {
        final accordion = RxAccordion(
          initialExpandedValues: initialExpandedValues,
          variants: variants,
          style: style,
          controller: controller,
          defaultTrailingIcon: defaultTrailingIcon,
          children: children,
        );

        await tester.pumpRxWidget(accordion);

        expect(accordion.children, children);
        expect(accordion.initialExpandedValues, initialExpandedValues);
        expect(accordion.variants, variants);
        expect(accordion.style, style);
        expect(accordion.defaultTrailingIcon, defaultTrailingIcon);
        expect(accordion.controller, controller);
        expect(accordion.defaultTrailingIcon, defaultTrailingIcon);
      });

      testWidgets('should render correct UI output', (tester) async {
        final accordion = RxAccordion(
          initialExpandedValues: initialExpandedValues,
          children: children,
        );

        await tester.pumpRxWidget(accordion);

        final section1Finder = find.text('Section 1');
        final section2Finder = find.text('Section 2');
        expect(section1Finder, findsOneWidget);
        expect(section2Finder, findsOneWidget);
      });
    });

    group('Interactions', () {
      testWidgets('should expand and collapse sections', (tester) async {
        final children = [
          RxAccordionItem(
            title: 'Section 1',
            value: 'section1',
            child: const Text('Content for section 1'),
          ),
        ];

        final accordion = RxAccordion<String>(
          initialExpandedValues: const [],
          children: children,
        );

        await tester.pumpRxWidget(accordion);

        final section1Finder = find.text('Section 1');
        final contentFinder = find.text('Content for section 1');

        expect(section1Finder, findsOneWidget);
        expect(contentFinder, findsNothing);

        await tester.tap(section1Finder);
        await tester.pumpAndSettle();

        expect(contentFinder, findsOneWidget);

        await tester.tap(section1Finder);
        await tester.pumpAndSettle();

        expect(contentFinder, findsNothing);
      });
    });

    // testWidgets('should apply style correctly', (tester) async {
    //   final style = RxAccordionStyle()..header.color.blue();

    //   final accordion = RxAccordion(
    //     style: style,
    //     children: [
    //       RxAccordionItem(
    //         title: 'Section 1',
    //         value: 'section1',
    //         child: const Text('Content for section 1'),
    //       ),
    //     ],
    //   );

    //   await tester.pumpRxWidget(accordion);

    //   final section1Finder = find.text('Section 1');
    //   final textWidget = tester.widget<Text>(section1Finder);
    //   expect(textWidget.style?.color, Colors.blue);
    // });
  });
}
