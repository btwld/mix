import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'widget_state_test_helper.dart';

void main() {
  group('WidgetStateTestHelper', () {
    testWidgets('expectState works correctly', (tester) async {
      final controller = WidgetStatesController();

      // Test initial state
      WidgetStateTestHelper.expectState(
        controller,
        WidgetState.hovered,
        isActive: false,
      );

      // Set state and test
      controller.hovered = true;
      WidgetStateTestHelper.expectState(
        controller,
        WidgetState.hovered,
        isActive: true,
      );

      controller.dispose();
    });

    testWidgets('testTap triggers tap callback', (tester) async {
      final controller = WidgetStatesController();
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            controller: controller,
            onPress: () => wasPressed = true,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      // Test tap functionality
      await WidgetStateTestHelper.testTap(tester, find.byType(Pressable));

      // Verify callback was triggered
      expect(wasPressed, isTrue);

      // Verify press state manually
      WidgetStateTestHelper.expectState(
        controller,
        WidgetState.pressed,
        isActive: true,
      );

      // Wait for timers to clear press state
      await WidgetStateTestHelper.waitForTimers(tester);
      WidgetStateTestHelper.expectState(
        controller,
        WidgetState.pressed,
        isActive: false,
      );

      controller.dispose();
    });

    testWidgets('testLongPress triggers long press callback', (tester) async {
      final controller = WidgetStatesController();
      bool wasLongPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            controller: controller,
            onLongPress: () => wasLongPressed = true,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      // Test long press
      await WidgetStateTestHelper.testLongPress(tester, find.byType(Pressable));

      // Verify callback was triggered
      expect(wasLongPressed, isTrue);

      controller.dispose();
    });

    testWidgets('verifyDisabledBehavior prevents interactions', (tester) async {
      final controller = WidgetStatesController();
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            controller: controller,
            enabled: false, // Start disabled
            onPress: () => wasPressed = true,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      // Test disabled behavior
      await WidgetStateTestHelper.verifyDisabledBehavior(
        tester,
        find.byType(Pressable),
        controller,
      );

      // Verify callback was NOT triggered
      expect(wasPressed, isFalse);

      controller.dispose();
    });

    testWidgets('testManualStateChanges works correctly', (tester) async {
      final controller = WidgetStatesController();

      await tester.pumpWidget(MaterialApp(home: Container()));

      // Test manual state changes
      WidgetStateTestHelper.testManualStateChanges(controller);

      // Additional verification
      controller.hovered = true;
      WidgetStateTestHelper.expectState(
        controller,
        WidgetState.hovered,
        isActive: true,
      );

      controller.dispose();
    });

    testWidgets('simulateMouseMovement runs without interfering', (
      tester,
    ) async {
      final controller = WidgetStatesController();

      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            controller: controller,
            onPress: () {},
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      // Simulate mouse movement - should not throw or interfere
      await WidgetStateTestHelper.simulateMouseMovement(
        tester,
        find.byType(Pressable),
      );

      // Verify no unexpected states were set
      expect(controller.value, isEmpty);

      controller.dispose();
    });

    testWidgets('verifyStates checks multiple states at once', (tester) async {
      final controller = WidgetStatesController();

      await tester.pumpWidget(MaterialApp(home: Container()));

      // Set up states
      controller.pressed = true;
      controller.focused = true;

      // Test state verification
      WidgetStateTestHelper.verifyStates(controller, {
        WidgetState.pressed: true,
        WidgetState.focused: true,
        WidgetState.hovered: false,
        WidgetState.disabled: false,
      });

      controller.dispose();
    });
  });
}
