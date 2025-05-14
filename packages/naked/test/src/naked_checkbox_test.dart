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
        NakedCheckbox(
          value: false,
          onChanged: (_) {},
          child: const Text('Checkbox Label'),
        ),
      );

      expect(find.text('Checkbox Label'), findsOneWidget);
    });

    testWidgets('handles tap to toggle state', (WidgetTester tester) async {
      bool isChecked = false;
      await tester.pumpMaterialWidget(
        NakedCheckbox(
          value: isChecked,
          onChanged: (value) => isChecked = value!,
          child: const Text('Checkbox Label'),
        ),
      );

      await tester.tap(find.byType(NakedCheckbox));
      expect(isChecked, isTrue);
    });

    testWidgets('does not respond when disabled', (WidgetTester tester) async {
      bool isChecked = false;
      await tester.pumpMaterialWidget(
        NakedCheckbox(
          value: isChecked,
          onChanged: (value) => isChecked = value!,
          enabled: false,
          child: const Text('Checkbox Label'),
        ),
      );

      await tester.tap(find.byType(NakedCheckbox));
      expect(isChecked, isFalse);
    });

    testWidgets('does not respond when onChanged is null',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        const NakedCheckbox(
          value: false,
          onChanged: null,
          child: Text('Checkbox Label'),
        ),
      );

      await tester.tap(find.byType(NakedCheckbox));
      // No error should occur
    });
  });

  group('State Callbacks', () {
    testWidgets('does not call state callbacks when disabled',
        (WidgetTester tester) async {
      final key = UniqueKey();

      bool isHovered = false;
      bool isPressed = false;
      bool isFocused = false;

      await tester.pumpMaterialWidget(
        NakedCheckbox(
          key: key,
          value: false,
          onChanged: (_) {},
          enabled: false,
          onHoverState: (value) => isHovered = value,
          onPressedState: (value) => isPressed = value,
          onFocusState: (value) => isFocused = value,
          child: const Text('Checkbox Label'),
        ),
      );

      // Test hover
      await tester.simulateHover(key, onHover: () {
        expect(isHovered, false);
      });

      expect(isHovered, false);

      // Test press
      final pressGesture = await tester.press(find.byType(NakedCheckbox));
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
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;

      final textKey = GlobalKey();

      bool isHovered = false;
      await tester.pumpMaterialWidget(
        Padding(
          padding: const EdgeInsets.all(1),
          child: NakedCheckbox(
            value: false,
            onChanged: (_) {},
            onHoverState: (value) => isHovered = value,
            child: Text('Checkbox Label', key: textKey),
          ),
        ),
      );

      final finder = find.byKey(textKey);

      // Create a test pointer and simulate hover over the widget
      final TestPointer testPointer = TestPointer(1, PointerDeviceKind.mouse);
      final Offset hoverPosition = tester.getCenter(finder);
      await tester.sendEventToBinding(testPointer.hover(hoverPosition));
      await tester.pump();

      expect(isHovered, isTrue); // Should be hovering now

      // Move pointer out of widget
      await tester.sendEventToBinding(testPointer.hover(Offset.zero));
      await tester.pump();

      expect(isHovered, isFalse);
    });

    testWidgets('calls onPressedState on tap down/up',
        (WidgetTester tester) async {
      bool isPressed = false;
      await tester.pumpMaterialWidget(
        NakedCheckbox(
          value: false,
          onChanged: (_) {},
          onPressedState: (value) => isPressed = value,
          child: const Text('Checkbox Label'),
        ),
      );

      final gesture = await tester.press(find.byType(NakedCheckbox));
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

      await tester.pumpMaterialWidget(
        NakedCheckbox(
          value: false,
          onChanged: (_) {},
          focusNode: focusNode,
          onFocusState: (value) => isFocused = value,
          child: const Text('Checkbox Label'),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      expect(isFocused, true);

      // Focus elsewhere
      final focusNodeCheckbox = FocusNode();
      final focusNodeOther = FocusNode();

      await tester.pumpMaterialWidget(
        Column(
          children: [
            NakedCheckbox(
              value: false,
              onChanged: (_) {},
              focusNode: focusNodeCheckbox,
              onFocusState: (value) => isFocused = value,
              child: const Text('Checkbox Label'),
            ),
            m.TextButton(
              onPressed: () {},
              focusNode: focusNodeOther,
              child: const Text('Other Element'),
            ),
          ],
        ),
      );

      focusNodeCheckbox.requestFocus();
      await tester.pump();
      expect(isFocused, true);

      focusNodeOther.requestFocus();
      await tester.pump();
      expect(isFocused, false);
    });
  });

  group('Keyboard Interaction', () {
    testWidgets('toggles with Space key', (WidgetTester tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;

      bool isChecked = false;

      final focusNode = FocusNode();
      await tester.pumpMaterialWidget(
        NakedCheckbox(
          value: isChecked,
          autofocus: true,
          onChanged: (value) => isChecked = value!,
          focusNode: focusNode,
          child: const Text('Checkbox Label'),
        ),
      );

      expect(isChecked, false);

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(isChecked, true);
    });

    testWidgets('toggles with Enter key', (WidgetTester tester) async {
      bool isChecked = false;
      await tester.pumpMaterialWidget(
        NakedCheckbox(
          value: isChecked,
          onChanged: (value) => isChecked = value!,
          focusNode: FocusNode()..requestFocus(),
          child: const Text('Checkbox Label'),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(isChecked, true);
    });
  });

  group('Tristate', () {
    testWidgets(
        'cycles through states false -> true -> null when tristate is enabled',
        (WidgetTester tester) async {
      bool? value = false;

      await tester.pumpMaterialWidget(
        StatefulBuilder(builder: (context, setState) {
          return NakedCheckbox(
            value: value,
            tristate: true,
            onChanged: (newValue) {
              setState(() {
                value = newValue;
              });
            },
            child: const Text('Checkbox Label'),
          );
        }),
      );

      await tester.tap(find.byType(NakedCheckbox));
      expect(value, true);

      await tester.pump();
      await tester.tap(find.byType(NakedCheckbox));
      expect(value, null);

      await tester.pump();
      await tester.tap(find.byType(NakedCheckbox));
      expect(value, false);
    });

    testWidgets(
        'throws assertion error when value is null but tristate is false, since null values are only allowed in tristate mode',
        (WidgetTester tester) async {
      expect(
        () => NakedCheckbox(
          value: null,
          tristate: false,
          onChanged: (_) {},
          child: const Text('Checkbox Label'),
        ),
        throwsAssertionError,
      );
    });
  });

  group('Accessibility', () {
    testWidgets('provides semantic checkbox property',
        (WidgetTester tester) async {
      final key = UniqueKey();
      await tester.pumpMaterialWidget(
        NakedCheckbox(
          key: key,
          value: true,
          onChanged: (_) {},
          child: const Text('Checkbox Label'),
        ),
      );

      final semantics = tester.getSemantics(find.byKey(key));
      expect(semantics.hasFlag(SemanticsFlag.hasCheckedState), true);
      expect(semantics.hasFlag(SemanticsFlag.isChecked), true);
    });

    testWidgets('provides semantic tristate', (WidgetTester tester) async {
      final key = UniqueKey();
      await tester.pumpMaterialWidget(
        NakedCheckbox(
          key: key,
          value: false,
          tristate: true,
          onChanged: (_) {},
          child: const Text('Checkbox Label'),
        ),
      );

      final semantics = tester.getSemantics(find.byKey(key));
      expect(semantics.hasFlag(SemanticsFlag.isCheckStateMixed), false);
    });

    testWidgets('applies custom semantic label when provided',
        (WidgetTester tester) async {
      final key = UniqueKey();
      await tester.pumpMaterialWidget(
        NakedCheckbox(
          key: key,
          value: false,
          onChanged: (_) {},
          semanticLabel: 'Custom Checkbox Label',
          child: const SizedBox.square(
            dimension: 10,
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byKey(key));
      expect(semantics.label, 'Custom Checkbox Label');
    });

    testWidgets('shows correct enabled/disabled state',
        (WidgetTester tester) async {
      final key = UniqueKey();
      for (var enabled in [true, false]) {
        await tester.pumpMaterialWidget(
          NakedCheckbox(
            key: key,
            value: false,
            onChanged: (_) {},
            enabled: enabled,
            child: const SizedBox.square(
              dimension: 10,
            ),
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
            NakedCheckbox(
              key: keyEnabled,
              value: false,
              onChanged: (_) {},
              child: const Text('Enabled Checkbox'),
            ),
            NakedCheckbox(
              key: keyDisabled,
              value: false,
              onChanged: (_) {},
              enabled: false,
              child: const Text('Disabled Checkbox'),
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

    testWidgets('supports custom cursor', (WidgetTester tester) async {
      final key = UniqueKey();

      await tester.pumpMaterialWidget(
        NakedCheckbox(
          key: key,
          value: false,
          onChanged: (_) {},
          cursor: SystemMouseCursors.help,
          child: const Text('Custom Cursor Checkbox'),
        ),
      );

      tester.expectCursor(
        SystemMouseCursors.help,
        on: key,
      );
    });
  });
}
