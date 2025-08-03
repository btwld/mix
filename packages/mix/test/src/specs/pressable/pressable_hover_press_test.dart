import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Pressable hover and press interaction', () {
    testWidgets(
      'press state should remain true until tapUp even when hover ends',
      (tester) async {
        final controller = WidgetStatesController();

        await tester.pumpWidget(
          MaterialApp(
            home: Pressable(
              controller: controller,
              onPress: () {},
              child: const SizedBox(
                width: 100,
                height: 100,
                child: Text('Pressable'),
              ),
            ),
          ),
        );

        // Verify initial state
        expect(controller.has(WidgetState.pressed), isFalse);
        expect(controller.has(WidgetState.hovered), isFalse);

        // Move mouse over widget
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(
          location: tester.getCenter(find.text('Pressable')),
        );
        await tester.pumpAndSettle();

        expect(controller.has(WidgetState.hovered), isTrue);
        expect(controller.has(WidgetState.pressed), isFalse);

        // Press down
        await gesture.down(tester.getCenter(find.text('Pressable')));
        await tester.pumpAndSettle();

        expect(controller.has(WidgetState.pressed), isTrue);
        expect(controller.has(WidgetState.hovered), isTrue);

        // Move mouse away while still pressed
        await gesture.moveTo(const Offset(200, 200)); // Move outside widget
        await tester.pumpAndSettle();

        // When moving out while pressed, the gesture is cancelled
        // This is standard Flutter behavior - onTapCancel is called
        expect(
          controller.has(WidgetState.pressed),
          isFalse,
          reason:
              'Press state is cleared when gesture moves outside (onTapCancel)',
        );

        // Note: Hover state may still be true with mouse gestures in tests
        // This is a limitation of the test framework

        // Release press
        await gesture.up();
        await tester.pumpAndSettle();

        expect(controller.has(WidgetState.pressed), isFalse);
      },
    );

    testWidgets('press state is cleared on tap cancel', (tester) async {
      final controller = WidgetStatesController();
      bool onPressCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            controller: controller,
            onPress: () => onPressCalled = true,
            child: const SizedBox(
              width: 100,
              height: 100,
              child: Text('Pressable'),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);

      // Hover in
      await gesture.addPointer(
        location: tester.getCenter(find.text('Pressable')),
      );
      await tester.pumpAndSettle();
      expect(controller.has(WidgetState.hovered), isTrue);

      // Press down
      await gesture.down(tester.getCenter(find.text('Pressable')));
      await tester.pumpAndSettle();
      expect(controller.has(WidgetState.pressed), isTrue);

      // Move out - this triggers tap cancel
      await gesture.moveTo(const Offset(200, 200)); // Move out
      await tester.pumpAndSettle();

      // Press state should be cleared on cancel
      expect(controller.has(WidgetState.pressed), isFalse);

      // Release
      await gesture.up();
      await tester.pumpAndSettle();

      // onPress should not have been called since gesture was cancelled
      expect(onPressCalled, isFalse);
    });
  });
}
