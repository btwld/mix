import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Pressable', () {
    testWidgets('renders child widget', (tester) async {
      const childKey = Key('child');

      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(child: Container(key: childKey)),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('calls onPress when tapped', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            onPress: () => wasPressed = true,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.tap(find.byType(Pressable));
      await tester.pumpAndSettle();

      expect(wasPressed, isTrue);
    });

    testWidgets('calls onLongPress when long pressed', (tester) async {
      bool wasLongPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            onLongPress: () => wasLongPressed = true,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.longPress(find.byType(Pressable));
      await tester.pumpAndSettle();

      expect(wasLongPressed, isTrue);
    });

    testWidgets('does not trigger callbacks when disabled', (tester) async {
      bool wasPressed = false;
      bool wasLongPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            enabled: false,
            onPress: () => wasPressed = true,
            onLongPress: () => wasLongPressed = true,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.tap(find.byType(Pressable));
      await tester.longPress(find.byType(Pressable));
      await tester.pumpAndSettle();

      expect(wasPressed, isFalse);
      expect(wasLongPressed, isFalse);
    });

    testWidgets('shows correct mouse cursor when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            onPress: () {},
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(Pressable)));
      await tester.pumpAndSettle();

      expect(
        RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
        SystemMouseCursors.click,
      );
    });

    testWidgets('shows forbidden cursor when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            enabled: false,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(Pressable)));
      await tester.pumpAndSettle();

      expect(
        RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
        SystemMouseCursors.forbidden,
      );
    });

    testWidgets('uses custom mouse cursor when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            mouseCursor: SystemMouseCursors.help,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(Pressable)));
      await tester.pumpAndSettle();

      expect(
        RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
        SystemMouseCursors.help,
      );
    });

    testWidgets('calls onFocusChange when focus changes', (tester) async {
      bool? hasFocus;
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            focusNode: focusNode,
            onFocusChange: (focused) => hasFocus = focused,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(hasFocus, isTrue);

      focusNode.unfocus();
      await tester.pumpAndSettle();
      expect(hasFocus, isFalse);

      focusNode.dispose();
    });

    testWidgets('handles keyboard activation with ActivateIntent', (
      tester,
    ) async {
      bool wasPressed = false;
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            focusNode: focusNode,
            onPress: () => wasPressed = true,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      // Simulate pressing Enter key
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(wasPressed, isTrue);

      // Reset and test with Space key
      wasPressed = false;
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      expect(wasPressed, isTrue);

      focusNode.dispose();
    });

    testWidgets('respects hitTestBehavior', (tester) async {
      bool pressablePressed = false;
      bool backgroundPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => backgroundPressed = true,
                  child: Container(color: Colors.blue),
                ),
              ),
              Center(
                child: Pressable(
                  hitTestBehavior: HitTestBehavior.opaque,
                  onPress: () => pressablePressed = true,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      // Test with opaque behavior - should block background
      await tester.tap(find.byType(Pressable));
      await tester.pumpAndSettle();

      expect(pressablePressed, isTrue);
      expect(backgroundPressed, isFalse);

      // Reset and test with deferToChild behavior
      pressablePressed = false;
      backgroundPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => backgroundPressed = true,
                  child: Container(color: Colors.blue),
                ),
              ),
              Center(
                child: Pressable(
                  hitTestBehavior: HitTestBehavior.deferToChild,
                  onPress: () => pressablePressed = true,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(Pressable));
      await tester.pumpAndSettle();

      // With deferToChild and a Container child, the tap should still be handled
      expect(pressablePressed, isTrue);
      expect(backgroundPressed, isFalse);
    });

    testWidgets('adds semantics when not excluded', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            onPress: () {},
            semanticButtonLabel: 'Test Button',
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(Pressable));
      expect(semantics.label, 'Test Button');
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('excludes semantics when requested', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            onPress: () {},
            excludeFromSemantics: true,
            semanticButtonLabel: 'Test Button',
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Test Button'), findsNothing);
    });

    testWidgets('properly disposes controller when not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Pressable(
            onPress: () {},
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      // Replace with empty container to trigger disposal
      await tester.pumpWidget(MaterialApp(home: SizedBox()));

      // No exceptions should be thrown
      expect(tester.takeException(), isNull);
    });

    testWidgets('uses provided controller', (tester) async {
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

      // Controller should be used
      expect(controller.value.contains(WidgetState.disabled), isFalse);

      controller.dispose();
    });
  });

  group('PressableBox', () {
    testWidgets('renders Box with child', (tester) async {
      const childKey = Key('child');

      await tester.pumpWidget(
        MaterialApp(
          home: PressableBox(child: Text('Test', key: childKey)),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
      expect(find.byType(Box), findsOneWidget);
    });

    testWidgets('applies style to Box', (tester) async {
      final style = BoxStyler().width(200.0).height(100.0).color(Colors.red);

      await tester.pumpWidget(
        MaterialApp(
          home: PressableBox(style: style, child: const Text('Test')),
        ),
      );

      final box = tester.widget<Box>(find.byType(Box));
      expect(box.style, same(style));
    });

    testWidgets('forwards all properties to Pressable', (tester) async {
      bool wasPressed = false;
      bool wasLongPressed = false;
      // ignore: unused_local_variable
      bool? focusChanged;
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: PressableBox(
            onPress: () => wasPressed = true,
            onLongPress: () => wasLongPressed = true,
            onFocusChange: (focus) => focusChanged = focus,
            focusNode: focusNode,
            autofocus: true,
            enabled: true,
            enableFeedback: true,

            hitTestBehavior: HitTestBehavior.deferToChild,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      // Test that Pressable receives all properties
      final pressable = tester.widget<Pressable>(find.byType(Pressable));
      expect(pressable.enabled, isTrue);
      expect(pressable.autofocus, isTrue);
      expect(pressable.focusNode, same(focusNode));

      expect(pressable.hitTestBehavior, HitTestBehavior.deferToChild);

      // Test callbacks work
      await tester.tap(find.byType(PressableBox));
      await tester.pumpAndSettle();
      expect(wasPressed, isTrue);

      await tester.longPress(find.byType(PressableBox));
      await tester.pumpAndSettle();
      expect(wasLongPressed, isTrue);

      focusNode.dispose();
    });
  });
}
