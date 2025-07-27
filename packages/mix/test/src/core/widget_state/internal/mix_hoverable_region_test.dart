import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/widget_state/cursor_position.dart';
import 'package:mix/src/core/widget_state/internal/mix_hoverable_region.dart';
import 'package:mix/src/core/widget_state/widget_state_provider.dart';

void main() {
  group('MixHoverableRegion', () {
    testWidgets('updates disabled state when enabled changes', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();

      await tester.pumpWidget(
        MaterialApp(
          home: MixHoverableRegion(
            controller: controller,
            enabled: false,
            child: Container(key: const Key('test')),
          ),
        ),
      );

      // Should start disabled when enabled is false
      expect(controller.has(WidgetState.disabled), isTrue);

      // Update to enabled
      await tester.pumpWidget(
        MaterialApp(
          home: MixHoverableRegion(
            controller: controller,
            enabled: true,
            child: Container(key: const Key('test')),
          ),
        ),
      );

      expect(controller.has(WidgetState.disabled), isFalse);
    });

    testWidgets('updates hovered state on mouse enter/exit', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      bool? lastHoverState;

      await tester.pumpWidget(
        MaterialApp(
          home: MixHoverableRegion(
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
          home: MixHoverableRegion(
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
          home: MixHoverableRegion(
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

    testWidgets('does not respond to hover when disabled', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();
      bool hoverCallbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: MixHoverableRegion(
            controller: controller,
            enabled: false,
            onHoverChange: (hovered) => hoverCallbackCalled = true,
            child: SizedBox(key: const Key('test'), width: 100, height: 100),
          ),
        ),
      );

      // Create a mouse pointer
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      // Move mouse over widget
      await gesture.moveTo(tester.getCenter(find.byKey(const Key('test'))));
      await tester.pump();

      // Should not update hover state or call callback when disabled
      expect(controller.has(WidgetState.hovered), isFalse);
      expect(hoverCallbackCalled, isFalse);

      await gesture.removePointer();
    });

    testWidgets('provides WidgetStateScope to descendants', (
      WidgetTester tester,
    ) async {
      final controller = WidgetStatesController();

      await tester.pumpWidget(
        MaterialApp(
          home: MixHoverableRegion(
            controller: controller,
            enabled: false, // This will set disabled to true
            child: Builder(
              builder: (context) {
                final hasDisabled = WidgetStateProvider.hasState(
                  context,
                  WidgetState.disabled,
                );
                return Text(hasDisabled ? 'disabled' : 'enabled');
              },
            ),
          ),
        ),
      );

      expect(find.text('disabled'), findsOneWidget);

      // Update state by rebuilding with enabled = true
      await tester.pumpWidget(
        MaterialApp(
          home: MixHoverableRegion(
            controller: controller,
            enabled: true,
            child: Builder(
              builder: (context) {
                final hasDisabled = WidgetStateProvider.hasState(
                  context,
                  WidgetState.disabled,
                );
                return Text(hasDisabled ? 'disabled' : 'enabled');
              },
            ),
          ),
        ),
      );

      expect(find.text('enabled'), findsOneWidget);
    });

    testWidgets('disposes controller when not provided externally', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: MixHoverableRegion(child: Container())),
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
          home: MixHoverableRegion(controller: controller, child: Container()),
        ),
      );

      // Remove widget
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      // Controller should still be usable
      expect(() => controller.disabled = true, returnsNormally);
    });
  });
}
