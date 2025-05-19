import 'dart:ui';

import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/naked.dart';

import 'helpers/simulate_hover.dart';

void main() {
  group('Basic Functionality', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        NakedButton(
          child: const Text('Test Button'),
          onPressed: () {},
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('handles tap when enabled', (WidgetTester tester) async {
      bool wasPressed = false;
      await tester.pumpMaterialWidget(
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
      await tester.pumpMaterialWidget(
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
      await tester.pumpMaterialWidget(
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
      final key = UniqueKey();

      await tester.pumpMaterialWidget(
        NakedButton(
          key: key,
          onPressed: () {},
          enabled: false,
          onHoverState: (value) => isHovered = value,
          onPressedState: (value) => isPressed = value,
          onFocusState: (value) => isFocused = value,
          child: const Text('Test Button'),
        ),
      );

      // Test hover
      await tester.simulateHover(key, onHover: () {
        expect(isHovered, false);
      });

      expect(isHovered, false);

      await tester.simulatePress(key, onPressed: () {
        expect(isPressed, false);
      });

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
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      bool isHovered = false;

      final key = UniqueKey();

      await tester.pumpMaterialWidget(
        Padding(
          padding: const EdgeInsets.all(1),
          child: NakedButton(
            key: key,
            onPressed: () {},
            onHoverState: (value) => isHovered = value,
            child: const Text('Test Button'),
          ),
        ),
      );

      await tester.simulateHover(key, onHover: () {
        expect(isHovered, true);
      });

      expect(isHovered, false);
    });

    testWidgets('calls onPressedState on tap down/up',
        (WidgetTester tester) async {
      bool isPressed = false;
      final key = UniqueKey();
      await tester.pumpMaterialWidget(
        NakedButton(
          key: key,
          onPressed: () {},
          onPressedState: (value) => isPressed = value,
          child: const Text('Test Button'),
        ),
      );

      await tester.simulatePress(key, onPressed: () {
        expect(isPressed, true);
      });

      expect(isPressed, false);
    });

    testWidgets('calls onFocusState when focused/unfocused',
        (WidgetTester tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      bool isFocused = false;
      final focusNode = FocusNode();

      await tester.pumpMaterialWidget(
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

      await tester.pumpMaterialWidget(
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

      await tester.pumpMaterialWidget(
        NakedButton(
          autofocus: true,
          onPressed: () => wasPressed = true,
          child: const Text('Test Button'),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(wasPressed, true);
    });

    testWidgets('activates with Enter key', (WidgetTester tester) async {
      bool wasPressed = false;
      await tester.pumpMaterialWidget(
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
  });

  group('Accessibility', () {
    testWidgets('provides semantic button property',
        (WidgetTester tester) async {
      final key = UniqueKey();
      await tester.pumpMaterialWidget(
        NakedButton(
          key: key,
          onPressed: () {},
          child: const Text('Test Button'),
        ),
      );

      final semantics = tester.getSemantics(find.byKey(key));
      expect(semantics.hasFlag(SemanticsFlag.isButton), true);
    });

    testWidgets('shows correct enabled/disabled state',
        (WidgetTester tester) async {
      final key = UniqueKey();
      for (var enabled in [true, false]) {
        await tester.pumpMaterialWidget(
          NakedButton(
            key: key,
            onPressed: () {},
            enabled: enabled,
            child: const Text('Test Button'),
          ),
        );

        final semantics = tester.getSemantics(find.byKey(key));
        expect(semantics.hasFlag(SemanticsFlag.isEnabled), enabled);
      }
    });
  });

  group('Cursor', () {
    testWidgets('shows appropriate cursor based on interactive state',
        (WidgetTester tester) async {
      final keyEnabled = UniqueKey();
      final keyDisabled = UniqueKey();

      await tester.pumpMaterialWidget(
        Column(
          children: [
            NakedButton(
              key: keyEnabled,
              onPressed: () {},
              child: const Text('Enabled Button'),
            ),
            NakedButton(
              key: keyDisabled,
              onPressed: () {},
              enabled: false,
              child: const Text('Disabled Button'),
            ),
          ],
        ),
      );

      tester.expectCursor(
        SystemMouseCursors.click,
        on: keyEnabled,
      );

      tester.expectCursor(
        SystemMouseCursors.forbidden,
        on: keyDisabled,
      );
    });
  });
}
