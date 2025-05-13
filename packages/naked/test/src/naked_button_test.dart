import 'dart:ui';

import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/naked.dart';

extension _WidgetTesterX on WidgetTester {
  Future<void> pumpButton(Widget widget) async {
    await pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: widget,
    ));
  }

  Future<TestGesture> simulateHover(Type type) async {
    final gesture = await createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await pump();

    await gesture.moveTo(getCenter(find.byType(type)));
    await pump();

    return gesture;
  }

  void expectCursor(SystemMouseCursor cursor, {required Finder on}) async {
    final enabledMouseRegion = widget<MouseRegion>(
        find.ancestor(of: on, matching: find.byType(MouseRegion)).first);

    expect(enabledMouseRegion.cursor, cursor);
  }
}

void main() {
  group('Basic Functionality', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpButton(
        NakedButton(
          child: const Text('Test Button'),
          onPressed: () {},
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('handles tap when enabled', (WidgetTester tester) async {
      bool wasPressed = false;
      await tester.pumpButton(
        NakedButton(
          onPressed: () => wasPressed = true,
          child: const Text('Test Button'),
        ),
      );

      await tester.tap(find.byType(NakedButton));
      expect(wasPressed, isTrue);
    });

    testWidgets('does not respond when disabled', (WidgetTester tester) async {
      bool wasPressed = false;
      await tester.pumpButton(
        NakedButton(
          onPressed: () => wasPressed = true,
          enabled: false,
          child: const Text('Test Button'),
        ),
      );

      await tester.tap(find.byType(NakedButton));
      expect(wasPressed, isFalse);
    });

    testWidgets('does not respond when onPressed is null',
        (WidgetTester tester) async {
      await tester.pumpButton(
        const NakedButton(
          onPressed: null,
          child: Text('Test Button'),
        ),
      );

      await tester.tap(find.byType(NakedButton));
      // No error should occur
    });
  });

  group('State Callbacks', () {
    testWidgets('does not call state callbacks when disabled',
        (WidgetTester tester) async {
      bool isHovered = false;
      bool isPressed = false;
      bool isFocused = false;

      await tester.pumpButton(
        NakedButton(
          onPressed: () {},
          enabled: false,
          onHoverState: (value) => isHovered = value,
          onPressedState: (value) => isPressed = value,
          onFocusState: (value) => isFocused = value,
          child: const Text('Test Button'),
        ),
      );

      // Test hover
      final hoverGesture = await tester.simulateHover(NakedButton);
      expect(isHovered, false);
      await hoverGesture.moveTo(Offset.zero);
      await tester.pump();
      expect(isHovered, false);

      // Test press
      final pressGesture = await tester.press(find.byType(NakedButton));
      await tester.pump();
      expect(isPressed, false);
      await pressGesture.up();
      await tester.pump();
      expect(isPressed, false);

      // Test focus
      final focusNode = FocusNode();
      focusNode.requestFocus();
      await tester.pump();
      expect(isFocused, false);
      focusNode.unfocus();
      await tester.pump();
      expect(isFocused, false);
    });

    testWidgets('calls onHoverState when hovered', (WidgetTester tester) async {
      bool isHovered = false;
      await tester.pumpButton(
        Padding(
          padding: const EdgeInsets.all(1),
          child: NakedButton(
            onPressed: () {},
            onHoverState: (value) => isHovered = value,
            child: const Text('Test Button'),
          ),
        ),
      );

      final gesture = await tester.simulateHover(NakedButton);
      expect(isHovered, true);

      await gesture.moveTo(Offset.zero);
      await tester.pump();
      expect(isHovered, false);
    });

    testWidgets('calls onPressedState on tap down/up',
        (WidgetTester tester) async {
      bool isPressed = false;
      await tester.pumpButton(
        NakedButton(
          onPressed: () {},
          onPressedState: (value) => isPressed = value,
          child: const Text('Test Button'),
        ),
      );

      final gesture = await tester.press(find.byType(NakedButton));
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

      await tester.pumpButton(
        NakedButton(
          onPressed: () {},
          focusNode: focusNode,
          onFocusState: (value) => isFocused = value,
          child: const Text('Test Button'),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      expect(isFocused, true);

      // Focus elsewhere
      final focusNodeNakedButton = FocusNode();
      final focusNodeOtherButton = FocusNode();

      await tester.pumpButton(
        Column(
          children: [
            NakedButton(
              onPressed: () {},
              focusNode: focusNodeNakedButton,
              onFocusState: (value) => isFocused = value,
              child: const Text('Test Button'),
            ),
            m.TextButton(
              onPressed: () {},
              focusNode: focusNodeOtherButton,
              child: const Text('Other Button'),
            ),
          ],
        ),
      );

      focusNodeNakedButton.requestFocus();
      await tester.pump();
      expect(isFocused, true);

      focusNodeOtherButton.requestFocus();
      await tester.pump();
      expect(isFocused, false);
    });
  });

  group('Keyboard Interaction', () {
    testWidgets('activates with Space key', (WidgetTester tester) async {
      bool wasPressed = false;
      await tester.pumpButton(
        NakedButton(
          onPressed: () => wasPressed = true,
          child: const Text('Test Button'),
        ),
      );

      await tester.tap(find.byType(NakedButton));
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(wasPressed, true);
    });

    testWidgets('activates with Enter key', (WidgetTester tester) async {
      bool wasPressed = false;
      await tester.pumpButton(
        NakedButton(
          onPressed: () => wasPressed = true,
          child: const Text('Test Button'),
        ),
      );

      await tester.tap(find.byType(NakedButton));
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(wasPressed, true);
    });

    testWidgets('updates pressed state with keyboard activation',
        (WidgetTester tester) async {
      bool isPressed = false;
      await tester.pumpButton(
        NakedButton(
          onPressed: () {},
          focusNode: FocusNode()..requestFocus(),
          onPressedState: (value) => isPressed = value,
          child: const Text('Test Button'),
        ),
      );

      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(isPressed, true);

      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(isPressed, false);
    });
  });

  group('Accessibility', () {
    testWidgets('provides semantic button property',
        (WidgetTester tester) async {
      await tester.pumpButton(
        NakedButton(
          onPressed: () {},
          child: const Text('Test Button'),
        ),
      );

      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.hasFlag(SemanticsFlag.isButton), true);
    });

    testWidgets('shows correct enabled/disabled state',
        (WidgetTester tester) async {
      for (var enabled in [true, false]) {
        await tester.pumpButton(
          NakedButton(
            onPressed: () {},
            enabled: enabled,
            child: const Text('Test Button'),
          ),
        );

        final semantics = tester.getSemantics(find.byType(Semantics).first);
        expect(semantics.hasFlag(SemanticsFlag.isEnabled), enabled);
      }
    });
  });

  group('Cursor', () {
    testWidgets('shows appropriate cursor based on interactive state',
        (WidgetTester tester) async {
      await tester.pumpButton(
        Column(
          children: [
            NakedButton(
              onPressed: () {},
              child: const Text('Enabled Button'),
            ),
            NakedButton(
              onPressed: () {},
              enabled: false,
              child: const Text('Disabled Button'),
            ),
          ],
        ),
      );

      tester.expectCursor(
        SystemMouseCursors.click,
        on: find.text('Enabled Button'),
      );

      tester.expectCursor(
        SystemMouseCursors.forbidden,
        on: find.text('Disabled Button'),
      );
    });
  });
}
