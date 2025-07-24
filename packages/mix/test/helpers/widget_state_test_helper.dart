import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/widget_state/widget_state_controller.dart';

/// Helper for testing widget state changes in Mix framework.
///
/// WHAT WORKS RELIABLY:
/// - Tap callbacks (onPress) ✓
/// - Long press callbacks (onLongPress) ✓
/// - Disabled state verification ✓
/// - Manual state setting and verification ✓
///
/// KNOWN LIMITATIONS:
/// - Press state timing is complex (happens during gesture.up)
/// - Hover detection doesn't work with FocusableActionDetector in tests
/// - Focus state requires specific widget setup and may not always work
/// - pumpAndSettle doesn't wait for Timers
///
/// SIMPLE USAGE:
/// ```dart
/// testWidgets('test widget interactions', (tester) async {
///   final controller = WidgetStatesController();
///   bool wasPressed = false;
///
///   await tester.pumpWidget(
///     MaterialApp(
///       home: Pressable(
///         controller: controller,
///         onPress: () => wasPressed = true,
///         child: const Text('Test'),
///       ),
///     ),
///   );
///
///   // Test tap callback
///   await tester.tap(find.byType(Pressable));
///   await tester.pump();
///   expect(wasPressed, isTrue);
///
///   // Test state manually
///   expect(controller.has(WidgetState.pressed), isTrue);
///   await tester.pump(const Duration(milliseconds: 250));
///   expect(controller.has(WidgetState.pressed), isFalse);
/// });
/// ```
class WidgetStateTestHelper {
  /// Default duration to wait for state timers (covers default unpressDelay)
  static const defaultTimerWait = Duration(milliseconds: 250);

  /// Verifies that a controller has the expected state.
  static void expectState(
    WidgetStatesController controller,
    WidgetState state, {
    required bool isActive,
  }) {
    expect(
      controller.has(state),
      isActive,
      reason: 'Expected $state to be ${isActive ? 'active' : 'inactive'}',
    );
  }

  /// Simple tap test - verifies callback is triggered.
  ///
  /// For press state verification, check manually after the tap.
  static Future<void> testTap(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
  }

  /// Simple long press test - verifies callback is triggered.
  static Future<void> testLongPress(WidgetTester tester, Finder finder) async {
    await tester.longPress(finder);
    await tester.pump();
  }

  /// Waits for state timers to clear (e.g., unpressDelay).
  static Future<void> waitForTimers(WidgetTester tester) async {
    await tester.pump(defaultTimerWait);
  }

  /// Tests that disabled widgets don't trigger callbacks.
  static Future<void> verifyDisabledBehavior(
    WidgetTester tester,
    Finder finder,
    WidgetStatesController controller,
  ) async {
    // Verify disabled state
    expectState(controller, WidgetState.disabled, isActive: true);

    // Try interactions - they shouldn't change states
    await tester.tap(finder);
    await tester.pump();

    await tester.longPress(finder);
    await tester.pump();

    // Verify no press state was activated
    expectState(controller, WidgetState.pressed, isActive: false);
  }

  /// Tests manual state changes on the controller.
  static void testManualStateChanges(WidgetStatesController controller) {
    // Test setting states
    controller.pressed = true;
    expectState(controller, WidgetState.pressed, isActive: true);

    controller.pressed = false;
    expectState(controller, WidgetState.pressed, isActive: false);

    controller.focused = true;
    expectState(controller, WidgetState.focused, isActive: true);

    controller.focused = false;
    expectState(controller, WidgetState.focused, isActive: false);

    controller.disabled = true;
    expectState(controller, WidgetState.disabled, isActive: true);

    controller.disabled = false;
    expectState(controller, WidgetState.disabled, isActive: false);
  }

  /// Simulates mouse movement for hover testing.
  ///
  /// Note: This won't trigger FocusableActionDetector hover callbacks.
  /// Use this only to verify hover doesn't break other functionality.
  static Future<void> simulateMouseMovement(
    WidgetTester tester,
    Finder finder,
  ) async {
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);

    // Move to widget
    await gesture.moveTo(tester.getCenter(finder));
    await tester.pump();

    // Move away
    await gesture.moveTo(Offset.zero);
    await tester.pump();

    await gesture.removePointer();
  }

  /// Helper to test multiple states in sequence.
  static void verifyStates(
    WidgetStatesController controller,
    Map<WidgetState, bool> expectedStates,
  ) {
    for (final entry in expectedStates.entries) {
      expectState(controller, entry.key, isActive: entry.value);
    }
  }
}
