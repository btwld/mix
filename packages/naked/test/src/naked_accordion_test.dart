import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
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
        controller: AccordionController(),
        initialExpandedValues: initialExpandedValues,
        children: [
          NakedAccordionItem<String>(
            value: 'item1',
            trigger: (_) => const Text('Trigger 1'),
            child: const Text('Content 1'),
          ),
          NakedAccordionItem<String>(
            value: 'item2',
            trigger: (_) => const Text('Trigger 2'),
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

  group('Expansion Behavior', () {
    StatefulBuilder buildAccordionWIthTrigger({
      required AccordionController<String> controller,
      List<String> initialExpandedValues = const [],
    }) {
      return StatefulBuilder(builder: (context, setState) {
        return NakedAccordion<String>(
          controller: controller,
          onTriggerPressed: (value) => setState(() {
            controller.toggle(value);
          }),
          initialExpandedValues: initialExpandedValues,
          children: [
            NakedAccordionItem<String>(
              value: 'item1',
              trigger: (_) => const NakedAccordionTrigger<String>(
                child: Text('Trigger 1'),
              ),
              child: const Text('Content 1'),
            ),
            NakedAccordionItem(
              value: 'item2',
              trigger: (_) => const NakedAccordionTrigger<String>(
                child: Text('Trigger 2'),
              ),
              child: const Text('Content 2'),
            ),
          ],
        );
      });
    }

    testWidgets('expands and collapses items correctly when clicked',
        (WidgetTester tester) async {
      final controller = AccordionController<String>();

      await tester.pumpMaterialWidget(
        buildAccordionWIthTrigger(controller: controller),
      );

      // Initially both items should be collapsed
      expect(find.text('Trigger 1'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Trigger 2'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);

      // Clicking first trigger should expand first item
      await tester.tap(find.text('Trigger 1'));
      await tester.pump();

      expect(find.text('Trigger 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Trigger 2'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);

      // Clicking second trigger should expand second item
      await tester.tap(find.text('Trigger 2'));
      await tester.pump();

      expect(find.text('Trigger 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Trigger 2'), findsOneWidget);
      expect(find.text('Content 2'), findsOneWidget);

      // Clicking first trigger again should collapse first item
      await tester.tap(find.text('Trigger 1'));
      await tester.pump();

      expect(find.text('Trigger 1'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Trigger 2'), findsOneWidget);
      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets(
        'expands and collapses items correctly even with initialExpandedValues',
        (WidgetTester tester) async {
      final controller = AccordionController<String>();
      await tester.pumpMaterialWidget(
        buildAccordionWIthTrigger(
          controller: controller,
          initialExpandedValues: const ['item1'],
        ),
      );

      expect(find.text('Trigger 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Trigger 2'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);

      await tester.tap(find.text('Trigger 1'));
      await tester.pump();

      expect(find.text('Trigger 1'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Trigger 2'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);

      await tester.tap(find.text('Trigger 2'));
      await tester.pump();

      expect(find.text('Trigger 1'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Trigger 2'), findsOneWidget);
      expect(find.text('Content 2'), findsOneWidget);
    });
  });

  group('State Management and Callbacks', () {
    testWidgets(
        'onTriggerPressed callback is fired when any trigger is pressed',
        (WidgetTester tester) async {
      String? lastPressedTriggerValue;

      await tester.pumpMaterialWidget(
        NakedAccordion<String>(
          controller: AccordionController(),
          onTriggerPressed: (value) => lastPressedTriggerValue = value,
          children: [
            NakedAccordionItem(
              value: 'item1',
              trigger: (_) => const NakedAccordionTrigger<String>(
                child: Text('Trigger 1'),
              ),
              child: const Text('Content 1'),
            ),
            NakedAccordionItem<String>(
              value: 'item2',
              trigger: (_) => const NakedAccordionTrigger<String>(
                child: Text('Trigger 2'),
              ),
              child: const Text('Content 2'),
            ),
          ],
        ),
      );

      // Expand item
      await tester.tap(find.text('Trigger 1'));
      await tester.pump();

      expect(lastPressedTriggerValue, 'item1');

      // Collapse item
      await tester.tap(find.text('Trigger 2'));
      await tester.pumpAndSettle();

      expect(lastPressedTriggerValue, 'item2');
    });
  });

  group('Trigger Interaction', () {
    final triggerKey = UniqueKey();
    Widget buildAccordionUseCase({
      void Function(bool)? onHoverState,
      void Function(bool)? onPressedState,
      void Function(bool)? onFocusState,
      List<String> initialExpandedValues = const [],
      FocusNode? focusNode,
    }) {
      return NakedAccordion<String>(
        initialExpandedValues: initialExpandedValues,
        controller: AccordionController(),
        children: [
          NakedAccordionItem(
            value: 'item1',
            trigger: (_) => NakedAccordionTrigger<String>(
              key: triggerKey,
              onHoverState: onHoverState,
              onPressedState: onPressedState,
              onFocusState: onFocusState,
              focusNode: focusNode,
              child: const Text('Trigger 1'),
            ),
            child: const Text('Content 1'),
          ),
        ],
      );
    }

    testWidgets('calls onHoverState when hovered', (WidgetTester tester) async {
      bool isHovered = false;

      await tester.pumpMaterialWidget(
        buildAccordionUseCase(
          onHoverState: (value) => isHovered = value,
        ),
      );

      await tester.simulateHover(
        triggerKey,
        onHover: () {
          expect(isHovered, true);
        },
      );
    });

    testWidgets('calls onPressedState on tap down/up',
        (WidgetTester tester) async {
      bool isPressed = false;

      await tester.pumpMaterialWidget(
        buildAccordionUseCase(
          onPressedState: (value) => isPressed = value,
        ),
      );

      final gesture =
          await tester.press(find.byType(NakedAccordionTrigger<String>));
      await tester.pump();
      expect(isPressed, true);

      await gesture.up();
      await tester.pump();
      expect(isPressed, false);
    });

    testWidgets('calls onFocusState when focused/unfocused',
        (WidgetTester tester) async {
      bool isFocused = false;
      final focusNode = FocusNode();

      await tester.pumpMaterialWidget(
        buildAccordionUseCase(
          focusNode: focusNode,
          onFocusState: (value) => isFocused = value,
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      expect(isFocused, true);

      focusNode.unfocus();
      await tester.pump();
      expect(isFocused, false);
    });
  });

  group('Accessibility', () {
    testWidgets('triggers have proper semantic properties',
        (WidgetTester tester) async {
      final controller = AccordionController<String>();

      await tester.pumpMaterialWidget(
        StatefulBuilder(builder: (context, setState) {
          return NakedAccordion<String>(
            controller: controller,
            onTriggerPressed: (value) => setState(() {
              controller.toggle(value);
            }),
            children: [
              NakedAccordionItem(
                value: 'item1',
                semanticLabel: 'First Section',
                trigger: (_) => const NakedAccordionTrigger<String>(
                  semanticLabel: 'First Section Header',
                  child: Text('Trigger 1'),
                ),
                child: const Text('Content 1'),
              ),
            ],
          );
        }),
      );

      // Get semantic node for trigger
      final SemanticsNode triggerNode =
          tester.getSemantics(find.text('Trigger 1'));

      // Verify semantic properties
      expect(triggerNode.label, 'First Section Header');
      expect(triggerNode.hasFlag(SemanticsFlag.isButton), true);
      expect(triggerNode.hasFlag(SemanticsFlag.isToggled), false);

      // Expand the accordion
      await tester.tap(find.text('Trigger 1'));
      await tester.pump();

      // Get semantic node for trigger again after expansion
      final SemanticsNode expandedTriggerNode =
          tester.getSemantics(find.text('Trigger 1'));

      // Verify it's now toggled
      expect(expandedTriggerNode.hasFlag(SemanticsFlag.isToggled), true);

      // Verify content is accessible
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('supports keyboard activation', (WidgetTester tester) async {
      final controller = AccordionController<String>();
      const triggerTextKey = Key('trigger');
      const triggerTextKey2 = Key('trigger2');
      await tester.pumpMaterialWidget(
        StatefulBuilder(builder: (context, setState) {
          return NakedAccordion<String>(
            controller: controller,
            onTriggerPressed: (value) => setState(() {
              controller.toggle(value);
            }),
            children: [
              NakedAccordionItem<String>(
                value: 'item1',
                trigger: (_) => const NakedAccordionTrigger<String>(
                  child: Text(
                    'Trigger 1',
                    key: triggerTextKey,
                  ),
                ),
                child: const Text('Content 1'),
              ),
              NakedAccordionItem<String>(
                value: 'item2',
                trigger: (_) => const NakedAccordionTrigger<String>(
                  child: Text(
                    'Trigger 2',
                    key: triggerTextKey2,
                  ),
                ),
                child: const Text('Content 2'),
              ),
            ],
          );
        }),
      );

      // Initially content is hidden
      expect(find.text('Content 1'), findsNothing);

      // Focus the trigger
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      final triggerTextFinder = find.byKey(triggerTextKey);

      // Ensure it's focused
      final focusNode = Focus.of(tester.element(triggerTextFinder));
      expect(focusNode.hasFocus, true);

      // Press space to activate
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      // Verify the accordion expanded
      expect(find.text('Content 1'), findsOneWidget);

      // press tab to focus on the next trigger
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      final triggerTextFinder2 = find.byKey(triggerTextKey2);
      final focusNode2 = Focus.of(tester.element(triggerTextFinder2));
      expect(focusNode2.hasFocus, true);

      // press space to activate
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(find.text('Content 2'), findsOneWidget);
    });
  });

  group('Disabled States', () {
    testWidgets('disabled item prevents interaction',
        (WidgetTester tester) async {
      final controller = AccordionController<String>();
      final triggerKey = UniqueKey();
      final triggerKey2 = UniqueKey();

      await tester.pumpMaterialWidget(
        StatefulBuilder(builder: (context, setState) {
          void handlePress(String value) {
            setState(() {
              controller.toggle(value);
            });
          }

          return NakedAccordion<String>(
            controller: controller,
            onTriggerPressed: handlePress,
            children: [
              NakedAccordionItem<String>(
                value: 'item1',
                enabled: false,
                trigger: (_) => NakedAccordionTrigger<String>(
                  key: triggerKey,
                  child: const Text('Trigger 1'),
                ),
                child: const Text('Content 1'),
              ),
              NakedAccordionItem(
                value: 'item2',
                trigger: (_) => NakedAccordionTrigger<String>(
                  key: triggerKey2,
                  child: const Text('Trigger 2'),
                ),
                child: const Text('Content 2'),
              ),
            ],
          );
        }),
      );

      // Attempt to expand disabled item
      await tester.tap(find.text('Trigger 1'));
      await tester.pumpAndSettle();

      // Content should remain collapsed
      expect(find.text('Content 1'), findsNothing);

      // Check cursor is forbidden for disabled item
      tester.expectCursor(
        SystemMouseCursors.forbidden,
        on: triggerKey,
      );

      // Non-disabled item should have click cursor and work normally
      tester.expectCursor(
        SystemMouseCursors.click,
        on: triggerKey2,
      );

      // Expand enabled item
      await tester.tap(find.text('Trigger 2'));
      await tester.pumpAndSettle();

      // Content should expand
      expect(find.text('Content 2'), findsOneWidget);
    });
  });
}
