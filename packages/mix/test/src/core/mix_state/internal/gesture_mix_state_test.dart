import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/widget_state/internal/gesture_mix_state.dart';
import 'package:mix/src/core/widget_state/internal/mix_widget_state_builder.dart';
import 'package:mix/src/core/widget_state/widget_state_controller.dart';

void main() {
  group('GesturableWidget', () {
    const key = Key('context_key');
    const unpressDelay = Duration(milliseconds: 500);

    final controller = WidgetStatesController();

    GestureMixStateWidget buildGestureMixStateWidget({
      Duration unpressDelay = unpressDelay,
      Function()? onTap,
      Function()? onLongPress,
      Function(DragStartDetails)? onPanStart,
      Function(DragDownDetails)? onPanDown,
      Function(DragUpdateDetails)? onPanUpdate,
      Function(DragEndDetails)? onPanEnd,
    }) {
      return GestureMixStateWidget(
        controller: controller,
        onTap: onTap,
        onLongPress: onLongPress,
        unpressDelay: unpressDelay,
        onPanStart: onPanStart,
        onPanDown: onPanDown,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: MixWidgetStateBuilder(
          controller: controller,
          builder: (_) => const SizedBox(
            key: key,
            height: 100,
            width: 100,
          ),
        ),
      );
    }

    testWidgets('should update press state when tapped', (tester) async {
      bool onTapCalled = false;
      await tester.pumpWidget(
        buildGestureMixStateWidget(
          onTap: () {
            onTapCalled = true;
          },
        ),
      );

      await tester.tap(find.byType(GestureMixStateWidget));
      await tester.pump();

      final context = tester.element(find.byKey(key));

      expect(
        MixWidgetState.hasStateOf(context, WidgetState.pressed),
        isTrue,
        reason: 'GesturableState should be pressed immediately after tap',
      );
      expect(onTapCalled, isTrue);
    });

    testWidgets('should update long press state when long pressed',
        (tester) async {
      bool onLongPressCalled = false;
      await tester.pumpWidget(
        buildGestureMixStateWidget(
          onLongPress: () {
            onLongPressCalled = true;
          },
        ),
      );

      await tester.longPress(find.byType(GestureMixStateWidget));
      final context = tester.element(find.byKey(key));

      expect(onLongPressCalled, isTrue);
      expect(
        LongPressInheritedState.of(context).longPressed,
        isTrue,
      );
    });

    testWidgets('should update press state after delay when tapped',
        (tester) async {
      await tester.pumpWidget(
        buildGestureMixStateWidget(
          onTap: () {},
          unpressDelay: const Duration(milliseconds: 100),
        ),
      );

      await tester.tap(find.byType(GestureMixStateWidget));
      await tester.pump();
      final context = tester.element(find.byKey(key));
      expect(
        MixWidgetState.hasStateOf(context, WidgetState.pressed),
        isTrue,
        reason: 'GesturableState should be pressed immediately after tap',
      );

      await tester.pump(
        const Duration(milliseconds: 50),
      );
      expect(
        MixWidgetState.hasStateOf(context, WidgetState.pressed),
        isTrue,
        reason: 'GesturableState should still be pressed 50ms after tap',
      );

      await tester.pump(
        const Duration(milliseconds: 100),
      );
      expect(
        MixWidgetState.hasStateOf(context, WidgetState.pressed),
        isFalse,
        reason:
            'GesturableState should be unpressed after unpressDelay has passed',
      );
    });

    testWidgets('should not update press state when disabled', (tester) async {
      await tester.pumpWidget(
        buildGestureMixStateWidget(
          onTap: () {},
          unpressDelay: Duration.zero,
        ),
      );

      await tester.tap(find.byType(GestureMixStateWidget));
      final context = tester.element(find.byKey(key));
      expect(MixWidgetState.hasStateOf(context, WidgetState.pressed), isFalse);
    });

    testWidgets('GesturableWidget pan functions test', (
      WidgetTester tester,
    ) async {
      bool isPanStartCalled = false;
      bool isPanDownCalled = false;
      bool isPanUpdateCalled = false;
      bool isPanEndCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: buildGestureMixStateWidget(
            onPanStart: (details) {
              isPanStartCalled = true;
            },
            onPanDown: (details) {
              isPanDownCalled = true;
            },
            onPanUpdate: (details) {
              isPanUpdateCalled = true;
            },
            onPanEnd: (details) {
              isPanEndCalled = true;
            },
            unpressDelay: Duration.zero,
          ),
        ),
      );

      final gesturableWidget = find.byType(GestureMixStateWidget);
      expect(gesturableWidget, findsOneWidget);

      final gesturableWidgetCenter = tester.getCenter(gesturableWidget);
      final gesture = await tester.startGesture(gesturableWidgetCenter);
      await gesture.moveBy(const Offset(50, 50), timeStamp: Durations.medium1);
      // move back to the original position
      await gesture.moveBy(const Offset(-50, -50),
          timeStamp: Durations.medium1);
      await gesture.up();

      // move it again but cancel it
      await gesture.down(gesturableWidgetCenter);

      await gesture.moveBy(const Offset(50, 50));
      await gesture.cancel(timeStamp: const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 200));

      expect(
        isPanStartCalled,
        isTrue,
        reason: 'onPanStart was not called',
      );
      expect(
        isPanDownCalled,
        isTrue,
        reason: 'onPanDown was not called',
      );
      expect(
        isPanUpdateCalled,
        isTrue,
        reason: 'onPanUpdate was not called',
      );
      expect(
        isPanEndCalled,
        isTrue,
        reason: 'onPanEnd was not called',
      );
    });

    testWidgets(
      'should propagate the onTap when it doesn\'t receive null',
      (tester) async {
        bool onTapCalled = false;

        await tester.pumpWidget(
          GestureDetector(
            onTap: () {
              onTapCalled = true;
            },
            child: buildGestureMixStateWidget(),
          ),
        );

        await tester.tap(find.byType(GestureMixStateWidget));

        expect(onTapCalled, isTrue);
      },
    );
  });
}
