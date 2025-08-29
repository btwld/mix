import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/internal/mix_interaction_detector.dart';
import 'package:mix/src/core/pointer_position.dart';
import 'package:mix/src/core/providers/widget_state_provider.dart';

void main() {
  group('MixInteractionDetector', () {
    testWidgets('initializes with disabled state when enabled is false', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();

      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            enabled: false,
            child: const SizedBox(key: Key('test'), width: 100, height: 100),
          ),
        ),
      );

      // Should be disabled initially
      expect(controller.has(WidgetState.disabled), isTrue);
    });

    testWidgets('updates disabled state when enabled changes', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();

      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            enabled: false,
            child: const SizedBox(key: Key('test'), width: 100, height: 100),
          ),
        ),
      );

      expect(controller.has(WidgetState.disabled), isTrue);

      // Update to enabled
      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            enabled: true,
            child: const SizedBox(key: Key('test'), width: 100, height: 100),
          ),
        ),
      );

      expect(controller.has(WidgetState.disabled), isFalse);
    });

    testWidgets('does not respond to interactions when disabled', (
      WidgetTester tester,
    ) async {
      bool? lastHoverState;

      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            enabled: false,
            onHoverChange: (hovered) => lastHoverState = hovered,
            child: const SizedBox(key: Key('test'), width: 100, height: 100),
          ),
        ),
      );

      // When disabled on initialization, should emit false hover callback
      expect(lastHoverState, isFalse);
      
      // Try to interact - should not respond
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byKey(const Key('test'))));
      await tester.pump();

      expect(lastHoverState, isFalse);

      // Try to tap - should not respond. Tap the detector itself to avoid hit-test warnings when disabled.
      await tester.tap(find.byType(MixInteractionDetector));
      await tester.pump();

      // Should still be false (no hover events should get through)
      expect(lastHoverState, isFalse);

      await gesture.removePointer();
    });

    testWidgets('clears transient states when becoming disabled', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      bool? lastHoverState;

      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            enabled: true,
            onHoverChange: (hovered) => lastHoverState = hovered,
            child: const SizedBox(key: Key('test'), width: 100, height: 100),
          ),
        ),
      );

      // First hover over the widget
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byKey(const Key('test'))));
      await tester.pump();

      expect(controller.has(WidgetState.hovered), isTrue);
      expect(lastHoverState, isTrue);

      // Disable the widget
      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            enabled: false,
            onHoverChange: (hovered) => lastHoverState = hovered,
            child: const SizedBox(key: Key('test'), width: 100, height: 100),
          ),
        ),
      );

      // Should clear hover state and call callback
      expect(controller.has(WidgetState.hovered), isFalse);
      expect(controller.has(WidgetState.disabled), isTrue);
      expect(lastHoverState, isFalse);

      await gesture.removePointer();
    });

    testWidgets('tracks press state on pointer down/up', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();

      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            child: SizedBox(key: const Key('test'), width: 100, height: 100),
          ),
        ),
      );

      // Initially not pressed
      expect(controller.has(WidgetState.pressed), isFalse);

      // Tap down on widget
      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const Key('test'))),
      );
      await tester.pump();

      // Should be pressed
      expect(controller.has(WidgetState.pressed), isTrue);

      // Complete the tap by releasing
      await gesture.up();
      await tester.pump();

      // Should no longer be pressed
      expect(controller.has(WidgetState.pressed), isFalse);
    });

    testWidgets('updates hovered state on mouse enter/exit', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      bool? lastHoverState;

      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            onHoverChange: (hovered) => lastHoverState = hovered,
            child: SizedBox(key: const Key('test'), width: 100, height: 100),
          ),
        ),
      );

      // Initially not hovered
      expect(controller.has(WidgetState.hovered), isFalse);

      // Create a mouse pointer
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      // Move mouse over widget
      await gesture.moveTo(tester.getCenter(find.byKey(const Key('test'))));
      await tester.pump();

      expect(controller.has(WidgetState.hovered), isTrue);
      expect(lastHoverState, isTrue);

      // Move mouse away - ensure it's outside the widget bounds
      await gesture.moveTo(const Offset(-100, -100));
      await tester.pump();

      expect(controller.has(WidgetState.hovered), isFalse);
      expect(lastHoverState, isFalse);

      await gesture.removePointer();
    });

    testWidgets('tracks mouse position when widgets are listening', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      PointerPosition? capturedPosition;

      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            child: Builder(
              builder: (context) {
                capturedPosition = PointerPosition.of(context);
                return SizedBox(
                  key: const Key('test'),
                  width: 100,
                  height: 100,
                );
              },
            ),
          ),
        ),
      );

      // Create a mouse pointer
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      // Move mouse to center of widget
      final center = tester.getCenter(find.byKey(const Key('test')));
      await gesture.moveTo(center);
      await tester.pump();

      // Force a rebuild to capture the position
      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            child: Builder(
              builder: (context) {
                capturedPosition = PointerPosition.of(context);
                return SizedBox(
                  key: const Key('test'),
                  width: 100,
                  height: 100,
                );
              },
            ),
          ),
        ),
      );

      // Position should be tracked (center is at 0,0 in alignment coordinates)
      expect(capturedPosition, isNotNull);
      expect(capturedPosition!.position, equals(Alignment.center));

      await gesture.removePointer();
    });

    testWidgets('clears pressed state when dragging outside bounds', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();

      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            child: SizedBox(key: const Key('test'), width: 100, height: 100),
          ),
        ),
      );

      // Start a press
      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const Key('test'))),
      );
      await tester.pump();

      expect(controller.has(WidgetState.pressed), isTrue);

      // Drag outside the widget bounds
      await gesture.moveTo(const Offset(-50, -50));
      await tester.pump();

      // Pressed state should be cleared
      expect(controller.has(WidgetState.pressed), isFalse);

      await gesture.up();
    });

    testWidgets('provides WidgetStateProvider to descendants', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();

      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            child: Builder(
              builder: (context) {
                final hasHovered = WidgetStateProvider.hasStateOf(
                  context,
                  WidgetState.hovered,
                );
                return Text(hasHovered ? 'hovered' : 'not hovered');
              },
            ),
          ),
        ),
      );

      expect(find.text('not hovered'), findsOneWidget);

      // Simulate hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(
        tester.getCenter(find.byType(MixInteractionDetector)),
      );
      await tester.pump();

      expect(find.text('hovered'), findsOneWidget);

      await gesture.removePointer();
    });

    testWidgets('disposes controller when not provided externally', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: MixInteractionDetector(child: Container())),
      );

      // Remove widget to trigger disposal
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      // No exception should be thrown
    });

    testWidgets('does not dispose external controller', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();

      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            child: Container(),
          ),
        ),
      );

      // Remove widget
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      // Controller should still be usable
      expect(
        () => controller.update(WidgetState.disabled, true),
        returnsNormally,
      );
    });

    testWidgets('no setState during build when initializing with disabled state', (
      WidgetTester tester,
    ) async {
      // Track if any setState during build errors occur
      final errors = <FlutterErrorDetails>[];
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.toString().contains('setState() or markNeedsBuild() called during build')) {
          errors.add(details);
        }
        originalOnError?.call(details);
      };
      
      try {
        // Test with internal controller - disabled initially
        await tester.pumpWidget(
          MaterialApp(
            home: MixInteractionDetector(
              enabled: false,
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        );
        
        expect(errors, isEmpty, reason: 'Should not cause setState during build with internal controller');
        
        // Test with external controller - disabled initially
        final controller = WidgetStatesController();
        await tester.pumpWidget(
          MaterialApp(
            home: MixInteractionDetector(
              controller: controller,
              enabled: false,
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        );
        
        expect(errors, isEmpty, reason: 'Should not cause setState during build with external controller');
        
        // Test with enabled initially
        await tester.pumpWidget(
          MaterialApp(
            home: MixInteractionDetector(
              controller: controller,
              enabled: true,
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        );
        
        expect(errors, isEmpty, reason: 'Should not cause setState during build when enabled');
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('IgnorePointer blocks all interactions when disabled', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      bool? lastHoverValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            enabled: false,
            onHoverChange: (hovered) => lastHoverValue = hovered,
            child: const SizedBox(key: Key('test'), width: 100, height: 100),
          ),
        ),
      );
      
      // Should be disabled and hover callback should have been called with false
      expect(controller.has(WidgetState.disabled), isTrue);
      expect(controller.has(WidgetState.hovered), isFalse);
      expect(lastHoverValue, isFalse);
      
      // Try to interact - should be blocked by IgnorePointer
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byKey(const Key('test'))));
      await tester.pump();
      
      expect(controller.has(WidgetState.hovered), isFalse);
      expect(lastHoverValue, isFalse); // Should still be false
      
      // Try to tap - should be blocked. Tap the detector to avoid hit-test warnings when disabled.
      await tester.tap(find.byType(MixInteractionDetector));
      await tester.pump();
      
      expect(controller.has(WidgetState.pressed), isFalse);
      expect(lastHoverValue, isFalse); // Should still be false
      
      await gesture.removePointer();
    });

    testWidgets('simplified pressed state works correctly', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            controller: controller,
            child: const SizedBox(key: Key('test'), width: 100, height: 100),
          ),
        ),
      );
      
      // Test single gesture
      final gesture = await tester.startGesture(tester.getCenter(find.byKey(const Key('test'))));
      await tester.pump();
      expect(controller.has(WidgetState.pressed), isTrue);
      
      await gesture.up();
      await tester.pump();
      expect(controller.has(WidgetState.pressed), isFalse);
    });

    testWidgets('callback fires even without provider listeners', (
      WidgetTester tester,
    ) async {
      PointerPosition? capturedPosition;
      
      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            onPointerPositionChange: (position) {
              capturedPosition = position;
            },
            child: const SizedBox(key: Key('test'), width: 100, height: 100),
          ),
        ),
      );
      
      // Move mouse to trigger position callback
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byKey(const Key('test'))));
      await tester.pump();
      
      expect(capturedPosition, isNotNull, reason: 'Callback should fire even without provider listeners');
      expect(capturedPosition!.position, equals(Alignment.center));
      
      await gesture.removePointer();
    });

    testWidgets('zero-size widget does not crash on hover', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MixInteractionDetector(
            child: const SizedBox(key: Key('test'), width: 0, height: 0),
          ),
        ),
      );
      
      // Should not crash when hovering over zero-size widget
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(const Offset(50, 50));
      await tester.pump();
      
      // No assertion needed - just checking it doesn't crash
      await gesture.removePointer();
    });
  });
}
