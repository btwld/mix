import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Pressable hover and press interaction', () {
    testWidgets(
      'press state clears when the pointer leaves the detector bounds',
      (tester) async {
        final controller = WidgetStatesController();

        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: Pressable(
                controller: controller,
                onPress: () {},
                child: const SizedBox(
                  width: 100,
                  height: 100,
                  child: Text('Pressable'),
                ),
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
        await gesture.moveTo(Offset.zero);
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
          home: Center(
            child: Pressable(
              controller: controller,
              onPress: () => onPressCalled = true,
              child: const SizedBox(
                width: 100,
                height: 100,
                child: Text('Pressable'),
              ),
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
      await gesture.moveTo(Offset.zero);
      await tester.pumpAndSettle();

      // Press state should be cleared on cancel
      expect(controller.has(WidgetState.pressed), isFalse);

      // Release
      await gesture.up();
      await tester.pumpAndSettle();

      // onPress should not have been called since gesture was cancelled
      expect(onPressCalled, isFalse);
    });

    testWidgets('focus loss does not clear a pointer-owned press', (
      tester,
    ) async {
      final focusNode = FocusNode();
      final controller = WidgetStatesController();
      addTearDown(focusNode.dispose);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: Pressable(
              focusNode: focusNode,
              controller: controller,
              onPress: () {},
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
      focusNode.requestFocus();
      await tester.pump();

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(
        location: tester.getCenter(find.byType(Pressable)),
      );
      await gesture.down(tester.getCenter(find.byType(Pressable)));
      await tester.pump();
      expect(controller.pressed, isTrue);

      focusNode.unfocus();
      await tester.pump();
      expect(controller.pressed, isTrue);

      await gesture.up();
      await tester.pump();
      expect(controller.pressed, isFalse);
    });

    testWidgets(
      'press state clears when the pointer drifts past the tap slop',
      (tester) async {
        final controller = WidgetStatesController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: Pressable(
              controller: controller,
              onPress: () {},
              // Large enough that the pointer never leaves the bounds.
              child: const SizedBox.expand(),
            ),
          ),
        );

        final gesture = await tester.startGesture(const Offset(200, 200));
        await tester.pump(const Duration(milliseconds: 120));
        expect(controller.pressed, isTrue);

        await gesture.moveBy(const Offset(0, kTouchSlop / 2));
        await tester.pump();
        expect(
          controller.pressed,
          isTrue,
          reason: 'movement within the slop is still a press',
        );

        await gesture.moveBy(const Offset(0, kTouchSlop));
        await tester.pump();
        expect(controller.pressed, isFalse);

        await gesture.up();
        await tester.pumpAndSettle();
      },
    );

    testWidgets('press state clears while scrolling a list of pressables', (
      tester,
    ) async {
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: ListView.builder(
            itemCount: 30,
            itemExtent: 200,
            itemBuilder: (context, index) => Pressable(
              controller: index == 0 ? controller : null,
              onPress: () {},
              child: SizedBox(height: 200, child: Text('item $index')),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(const Offset(200, 100));
      await tester.pump(const Duration(milliseconds: 120));
      expect(controller.pressed, isTrue);

      // A scrolled item travels with the pointer, so it never leaves the item
      // bounds: only the slop rule can end the press here.
      for (var i = 0; i < 5; i++) {
        await gesture.moveBy(const Offset(0, -8));
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(controller.pressed, isFalse);
      expect(tester.getTopLeft(find.text('item 0')).dy, lessThan(0));

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('only the pointer that started a press can end it', (
      tester,
    ) async {
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: Pressable(
              controller: controller,
              onPress: () {},
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );

      final center = tester.getCenter(find.byType(Pressable));
      final owner = await tester.startGesture(center, pointer: 1);
      final other = await tester.startGesture(
        center + const Offset(1, 1),
        pointer: 2,
      );
      await tester.pump();
      expect(controller.pressed, isTrue);

      await other.up();
      await tester.pump();
      expect(controller.pressed, isTrue, reason: 'the owner is still down');

      await owner.up();
      await tester.pump();
      expect(controller.pressed, isFalse);
    });

    testWidgets('controller swap moves active interaction states', (
      tester,
    ) async {
      final firstController = WidgetStatesController();
      final secondController = WidgetStatesController();
      final focusNode = FocusNode();
      addTearDown(firstController.dispose);
      addTearDown(secondController.dispose);
      addTearDown(focusNode.dispose);
      var useFirstController = true;
      late StateSetter setState;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, stateSetter) {
              setState = stateSetter;

              return Center(
                child: Pressable(
                  focusNode: focusNode,
                  controller: useFirstController
                      ? firstController
                      : secondController,
                  onPress: () {},
                  child: const SizedBox(width: 100, height: 100),
                ),
              );
            },
          ),
        ),
      );

      focusNode.requestFocus();
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      final center = tester.getCenter(find.byType(Pressable));
      await gesture.addPointer(location: center);
      await gesture.down(center);
      await tester.pump();
      expect(firstController.pressed, isTrue);
      expect(firstController.hovered, isTrue);
      expect(firstController.focused, isTrue);

      setState(() => useFirstController = false);
      await tester.pump();
      expect(firstController.pressed, isFalse);
      expect(firstController.hovered, isFalse);
      expect(firstController.focused, isFalse);
      expect(secondController.pressed, isTrue);
      expect(secondController.hovered, isTrue);
      expect(secondController.focused, isTrue);

      await gesture.up();
      await tester.pump();
      expect(secondController.pressed, isFalse);
      expect(secondController.hovered, isTrue);
      expect(secondController.focused, isTrue);

      await gesture.removePointer();
    });

    testWidgets('disposal clears transient states on an external controller', (
      tester,
    ) async {
      final controller = WidgetStatesController();
      final focusNode = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);
      var showPressable = true;
      late StateSetter setState;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, stateSetter) {
              setState = stateSetter;

              return Center(
                child: showPressable
                    ? Pressable(
                        focusNode: focusNode,
                        controller: controller,
                        onPress: () {},
                        child: const SizedBox(width: 100, height: 100),
                      )
                    : const SizedBox(width: 100, height: 100),
              );
            },
          ),
        ),
      );

      focusNode.requestFocus();
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      final center = tester.getCenter(find.byType(Pressable));
      await gesture.addPointer(location: center);
      await gesture.down(center);
      await tester.pump();
      expect(controller.pressed, isTrue);
      expect(controller.hovered, isTrue);
      expect(controller.focused, isTrue);

      setState(() => showPressable = false);
      await tester.pump();
      expect(controller.pressed, isFalse);
      expect(controller.hovered, isFalse);
      expect(controller.focused, isFalse);

      await gesture.up();
      await gesture.removePointer();
    });
  });
}
