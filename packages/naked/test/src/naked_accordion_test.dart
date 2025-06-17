import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/naked.dart';

import 'helpers/simulate_hover.dart';

Widget builder(bool isExpanded, {required String text}) {
  return isExpanded ? Text(text) : const SizedBox.shrink();
}

void main() {
  group('Basic Functionality', () {
    Widget buildAccordion({
      List<String> initialExpandedValues = const [],
    }) {
      return NakedAccordion<String>(
        controller: NakedAccordionController(),
        initialExpandedValues: initialExpandedValues,
        children: [
          NakedAccordionItem<String>(
            value: 'item1',
            trigger: (_, __, ___) => const Text('Trigger 1'),
            child: const Text('Content 1'),
          ),
          NakedAccordionItem<String>(
            value: 'item2',
            trigger: (_, __, ___) => const Text('Trigger 2'),
            child: const Text('Content 2'),
          ),
        ],
      );
    }

    testWidgets('renders triggers correctly when closed',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        buildAccordion(),
      );

      expect(find.text('Trigger 1'), findsOneWidget);
      expect(find.text('Trigger 2'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Content 2'), findsNothing);
    });

    testWidgets('initially expands items based on initialExpandedValues',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        buildAccordion(initialExpandedValues: const ['item1']),
      );

      await tester.pumpAndSettle();

      expect(find.text('Trigger 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Trigger 2'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);
    });
  });

  group('Focus State', () {
    late bool focusState;

    Widget buildFocusableAccordion({
      required FocusNode focusNode,
      required bool autoFocus,
    }) {
      return NakedAccordion<String>(
        controller: NakedAccordionController<String>(),
        children: [
          NakedAccordionItem<String>(
            value: 'item1',
            trigger: (_, __, ___) => const Text('Trigger 1'),
            onFocusState: (focused) => focusState = focused,
            autoFocus: autoFocus,
            focusNode: focusNode,
            child: const Text('Content 1'),
          ),
        ],
      );
    }

    setUp(() {
      focusState = false;
    });

    testWidgets('onFocusState callback is triggered when focused',
        (WidgetTester tester) async {
      final focusNode = FocusNode();
      await tester.pumpMaterialWidget(buildFocusableAccordion(
        focusNode: focusNode,
        autoFocus: false,
      ));

      // Focus the accordion item
      focusNode.requestFocus();
      await tester.pump();
      expect(focusState, true);

      // Remove focus
      focusNode.unfocus();
      await tester.pump();
      expect(focusState, false);
    });

    testWidgets('autofocus works correctly', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        NakedAccordion<String>(
          controller: NakedAccordionController<String>(),
          children: [
            NakedAccordionItem<String>(
              value: 'item1',
              trigger: (_, __, ___) => const Text('Trigger 1'),
              onFocusState: (focused) => focusState = focused,
              autoFocus: true,
              child: const Text('Content 1'),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();
      expect(focusState, true);
    });
  });

  group('Controlled Expansion', () {
    late NakedAccordionController<String> controller;

    setUp(() {
      controller = NakedAccordionController<String>();
    });

    Widget buildControlledAccordion() {
      return NakedAccordion<String>(
        controller: controller,
        children: [
          NakedAccordionItem<String>(
            value: 'item1',
            trigger: (context, isExpanded, toggle) {
              return GestureDetector(
                onTap: toggle,
                child: Text(isExpanded ? 'Close 1' : 'Open 1'),
              );
            },
            child: const Text('Content 1'),
          ),
          NakedAccordionItem<String>(
            value: 'item2',
            trigger: (context, isExpanded, toggle) {
              return GestureDetector(
                onTap: toggle,
                child: Text(isExpanded ? 'Close 2' : 'Open 2'),
              );
            },
            child: const Text('Content 2'),
          ),
        ],
      );
    }

    testWidgets('controller.open() expands an item',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(buildControlledAccordion());

      expect(find.text('Open 1'), findsOneWidget);
      expect(find.text('Open 2'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Content 2'), findsNothing);

      controller.open('item1');
      await tester.pump();

      expect(find.text('Close 1'), findsOneWidget);
      expect(find.text('Open 2'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);
    });

    testWidgets('controller.close() collapses an item',
        (WidgetTester tester) async {
      controller.open('item1');
      await tester.pumpMaterialWidget(buildControlledAccordion());

      expect(find.text('Close 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);

      controller.close('item1');
      await tester.pump();

      expect(find.text('Open 1'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
    });

    testWidgets('controller.toggle() toggles item expansion',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(buildControlledAccordion());

      expect(find.text('Open 1'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);

      controller.toggle('item1');
      await tester.pump();

      expect(find.text('Close 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);

      controller.toggle('item1');
      await tester.pump();

      expect(find.text('Open 1'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
    });

    testWidgets('controller respects min expanded items',
        (WidgetTester tester) async {
      controller = NakedAccordionController<String>(min: 1);
      controller.open('item1');

      await tester.pumpMaterialWidget(buildControlledAccordion());

      expect(find.text('Close 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);

      controller.close('item1');
      await tester.pump();

      // Should not close because min=1
      expect(find.text('Close 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('controller respects max expanded items',
        (WidgetTester tester) async {
      controller = NakedAccordionController<String>(max: 1);

      await tester.pumpMaterialWidget(buildControlledAccordion());

      controller.open('item1');
      await tester.pump();

      expect(find.text('Close 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Open 2'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);

      controller.open('item2');
      await tester.pump();

      // item1 should close when item2 opens because max=1
      expect(find.text('Open 1'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Close 2'), findsOneWidget);
      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets('controller respects both min and max constraints',
        (WidgetTester tester) async {
      controller = NakedAccordionController<String>(min: 1, max: 1);

      await tester.pumpMaterialWidget(buildControlledAccordion());

      // Open first item
      controller.open('item1');
      await tester.pump();

      expect(find.text('Close 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Open 2'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);

      // Open second item - both should remain open since max=2
      controller.open('item2');
      await tester.pump();

      expect(find.text('Open 1'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Close 2'), findsOneWidget);
      expect(find.text('Content 2'), findsOneWidget);

      // Try to close item1 - should fail since min=1 and item2 would be only one open
      controller.close('item2');
      await tester.pump();

      expect(find.text('Open 1'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Close 2'), findsOneWidget);
      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets('controller.clear() collapses all items',
        (WidgetTester tester) async {
      controller.open('item1');
      controller.open('item2');

      await tester.pumpMaterialWidget(buildControlledAccordion());

      expect(find.text('Close 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Close 2'), findsOneWidget);
      expect(find.text('Content 2'), findsOneWidget);

      controller.clear();
      await tester.pump();

      expect(find.text('Open 1'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Open 2'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);
    });

    testWidgets('controller.openAll() expands multiple items',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(buildControlledAccordion());

      expect(find.text('Open 1'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Open 2'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);

      controller.openAll(['item1', 'item2']);
      await tester.pump();

      expect(find.text('Close 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Close 2'), findsOneWidget);
      expect(find.text('Content 2'), findsOneWidget);
    });
  });
}
