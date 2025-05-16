import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/naked.dart';

import 'helpers/simulate_hover.dart';

Widget _anyWidget() => const SizedBox(
      width: 200,
      height: 40,
    );

void main() {
  const testKey = Key('test-slider');
  const double minValue = 0.0;
  const double maxValue = 1.0;

  group('Basic Functionality', () {
    testWidgets('child renders correctly', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        NakedSlider(
          value: 0.5,
          onChanged: (_) {},
          child: const Text('Hello, world!'),
        ),
      );
      expect(find.text('Hello, world!'), findsOneWidget);
    });

    testWidgets('value changes when dragged horizontally',
        (WidgetTester tester) async {
      double value = 0.5;
      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: value,
          onChanged: (newValue) => value = newValue,
          child: _anyWidget(),
        ),
      );

      final sliderFinder = find.byKey(testKey);

      // Drag to the right
      await tester.drag(sliderFinder, const Offset(50.0, 0.0));
      await tester.pumpAndSettle();
      expect(value, greaterThan(0.5));

      // Drag to the left
      await tester.drag(sliderFinder, const Offset(-80.0, 0.0));
      await tester.pumpAndSettle();
      expect(value, lessThan(0.5));
    });

    testWidgets('value changes when dragged vertically',
        (WidgetTester tester) async {
      double value = 0.5;
      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: value,
          direction: Axis.vertical,
          onChanged: (newValue) => value = newValue,
          child: _anyWidget(),
        ),
      );

      final sliderFinder = find.byKey(testKey);

      // Drag up (increases value)
      await tester.drag(sliderFinder, const Offset(0.0, -50.0));
      await tester.pumpAndSettle();
      expect(value, greaterThan(0.5));

      // Drag down (decreases value)
      await tester.drag(sliderFinder, const Offset(0.0, 80.0));
      await tester.pumpAndSettle();
      expect(value, lessThan(0.5));
    });

    testWidgets('constrains value between min and max',
        (WidgetTester tester) async {
      double value = 0.5;
      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: value,
          min: 0.2,
          max: 0.8,
          onChanged: (newValue) => value = newValue,
          child: _anyWidget(),
        ),
      );

      final sliderFinder = find.byKey(testKey);

      // Try to drag beyond maximum
      await tester.drag(sliderFinder, const Offset(200.0, 0.0));
      await tester.pumpAndSettle();
      expect(value, 0.8);

      // Try to drag below minimum
      await tester.drag(sliderFinder, const Offset(-200.0, 0.0));
      await tester.pumpAndSettle();
      expect(value, 0.2);
    });

    testWidgets('does not respond when disabled', (WidgetTester tester) async {
      double value = 0.5;
      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: value,
          enabled: false,
          onChanged: (newValue) => value = newValue,
          child: _anyWidget(),
        ),
      );

      final sliderFinder = find.byKey(testKey);

      // Try to drag
      await tester.drag(sliderFinder, const Offset(50.0, 0.0));
      await tester.pumpAndSettle();

      // Value should not change
      expect(value, 0.5);
    });

    testWidgets('does not respond when onChanged is null',
        (WidgetTester tester) async {
      double value = 0.5;
      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: value,
          onChanged: null,
          child: _anyWidget(),
        ),
      );

      final sliderFinder = find.byKey(testKey);

      // Try to drag
      await tester.drag(sliderFinder, const Offset(50.0, 0.0));
      await tester.pumpAndSettle();

      // No error should occur and value remains unchanged
      expect(value, 0.5);
    });

    testWidgets('supports discrete divisions', (WidgetTester tester) async {
      double value = 0.5;
      await tester.pumpMaterialWidget(
        StatefulBuilder(
          builder: (context, setState) => NakedSlider(
            key: testKey,
            value: value,
            divisions: 4,
            onChanged: (newValue) => setState(() => value = newValue),
            child: _anyWidget(),
          ),
        ),
      );

      final sliderFinder = find.byKey(testKey);

      await tester.drag(sliderFinder, const Offset(30.0, 0.0));
      await tester.pumpAndSettle();
      expect(value, 0.75);

      await tester.drag(sliderFinder, const Offset(-30.0, 0.0));
      await tester.pumpAndSettle();
      expect(value, 0.5);
    });
  });

  group('State Callbacks', () {
    testWidgets('does not call state callbacks when disabled',
        (WidgetTester tester) async {
      bool isHovered = false;
      bool isDragging = false;
      bool isFocused = false;

      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: 0.5,
          enabled: false,
          onChanged: (_) {},
          onHoverState: (value) => isHovered = value,
          onDraggingState: (value) => isDragging = value,
          onFocusState: (value) => isFocused = value,
          child: _anyWidget(),
        ),
      );

      // Test hover
      await tester.simulateHover(testKey, onHover: () {
        expect(isHovered, false);
      });

      // Test drag
      final gesture =
          await tester.startGesture(tester.getCenter(find.byKey(testKey)));
      await tester.pump();
      expect(isDragging, false);
      await gesture.up();
      await tester.pump();
      expect(isDragging, false);

      // Test focus
      final focusNode = FocusNode();
      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: 0.5,
          enabled: false,
          focusNode: focusNode,
          onChanged: (_) {},
          onFocusState: (value) => isFocused = value,
          child: _anyWidget(),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      expect(isFocused, false);
    });

    testWidgets('calls onHoverState when hovered', (WidgetTester tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;

      bool isHovered = false;
      await tester.pumpMaterialWidget(
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: NakedSlider(
            key: testKey,
            value: 0.5,
            onChanged: (_) {},
            onHoverState: (value) => isHovered = value,
            child: _anyWidget(),
          ),
        ),
      );

      await tester.simulateHover(testKey, onHover: () {
        expect(isHovered, true);
      });

      expect(isHovered, false);
    });

    testWidgets('calls onDraggingState when dragged',
        (WidgetTester tester) async {
      bool isDragging = false;
      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: 0.5,
          onChanged: (_) {},
          onDraggingState: (value) => isDragging = value,
          child: _anyWidget(),
        ),
      );

      final sliderFinder = find.byKey(testKey);

      // Start dragging
      final gesture = await tester.startGesture(tester.getCenter(sliderFinder));
      await tester.pump();
      expect(isDragging, true);

      // End dragging
      await gesture.up();
      await tester.pump();
      expect(isDragging, false);
    });

    testWidgets('calls onFocusState when focused/unfocused',
        (WidgetTester tester) async {
      bool isFocused = false;
      final focusNode = FocusNode();

      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: 0.5,
          focusNode: focusNode,
          onChanged: (_) {},
          onFocusState: (value) => isFocused = value,
          child: _anyWidget(),
        ),
      );

      // Focus the slider
      focusNode.requestFocus();
      await tester.pump();
      expect(isFocused, true);

      // Unfocus
      focusNode.unfocus();
      await tester.pump();
      expect(isFocused, false);
    });

    testWidgets('fires onDragStart and onDragEnd callbacks',
        (WidgetTester tester) async {
      bool dragStarted = false;
      double? endValue;

      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: 0.5,
          onChanged: (_) {},
          onDragStart: () => dragStarted = true,
          onDragEnd: (value) => endValue = value,
          child: _anyWidget(),
        ),
      );

      final sliderFinder = find.byKey(testKey);

      // Start and end drag
      await tester.drag(sliderFinder, const Offset(30.0, 0.0));
      await tester.pumpAndSettle();

      expect(dragStarted, true);
      expect(endValue, isNotNull);
    });
  });

  group('Keyboard Interaction', () {
    testWidgets(
        'responds to (right/left) and (up/down) keys in (horizontal/vertical) mode',
        (WidgetTester tester) async {
      for (final direction in [Axis.horizontal, Axis.vertical]) {
        double value = 0.5;
        final focusNode = FocusNode();

        await tester.pumpMaterialWidget(
          StatefulBuilder(builder: (context, setState) {
            return NakedSlider(
              key: testKey,
              value: value,
              keyboardStep: 0.1,
              focusNode: focusNode,
              direction: direction,
              onChanged: (newValue) => setState(() => value = newValue),
              child: _anyWidget(),
            );
          }),
        );

        // Focus the slider
        focusNode.requestFocus();
        await tester.pump();

        for (final keyTest in [
          (key: LogicalKeyboardKey.arrowRight, expectedValue: 0.6),
          (key: LogicalKeyboardKey.arrowLeft, expectedValue: 0.5),
          (key: LogicalKeyboardKey.arrowUp, expectedValue: 0.6),
          (key: LogicalKeyboardKey.arrowDown, expectedValue: 0.5),
        ]) {
          await tester.sendKeyEvent(keyTest.key);
          await tester.pump();
          expect(value, keyTest.expectedValue);
        }
      }
    });

    testWidgets('jumps to next division when dragged with divisions enabled',
        (WidgetTester tester) async {
      double value = 0.3;
      final focusNode = FocusNode();
      await tester.pumpMaterialWidget(
        StatefulBuilder(builder: (context, setState) {
          return NakedSlider(
            key: testKey,
            value: value,
            divisions: 4,
            focusNode: focusNode,
            onChanged: (newValue) => setState(() => value = newValue),
            child: _anyWidget(),
          );
        }),
      );

      // Focus the slider
      focusNode.requestFocus();
      await tester.pump();

      // Press right arrow to increase value (0.3 -> 0.5)
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(value, 0.5);

      // Press left arrow to decrease value (0.5 -> 0.25)
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(value, 0.25);
    });

    testWidgets('home/end keys jump to min/max', (WidgetTester tester) async {
      double value = 0.5;
      final focusNode = FocusNode();

      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: value,
          focusNode: focusNode,
          onChanged: (newValue) => value = newValue,
          child: _anyWidget(),
        ),
      );

      // Focus the slider
      focusNode.requestFocus();
      await tester.pump();

      // Press home key
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(value, minValue);

      // Press end key
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(value, maxValue);
    });
  });

  group('Accessibility', () {
    testWidgets('provides semantic slider property',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: 0.5,
          onChanged: (_) {},
          child: _anyWidget(),
        ),
      );

      final semantics = tester.getSemantics(find.byKey(testKey));
      expect(semantics.hasFlag(SemanticsFlag.isSlider), true);
    });

    testWidgets('provides semantic label', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: 0.5,
          semanticLabel: 'Custom Label',
          onChanged: (_) {},
          child: _anyWidget(),
        ),
      );

      final semantics = tester.getSemantics(find.byKey(testKey));
      expect(semantics.label, 'Custom Label');
    });

    testWidgets('shows correct enabled/disabled state',
        (WidgetTester tester) async {
      for (var enabled in [true, false]) {
        await tester.pumpMaterialWidget(
          NakedSlider(
            key: testKey,
            value: 0.5,
            enabled: enabled,
            onChanged: (_) {},
            child: _anyWidget(),
          ),
        );

        final semantics = tester.getSemantics(find.byKey(testKey));
        expect(semantics.hasFlag(SemanticsFlag.isEnabled), enabled);
      }
    });
  });

  group('Cursor', () {
    testWidgets('shows appropriate cursor based on interactive state',
        (WidgetTester tester) async {
      const enabledKey = Key('enabled');
      const disabledKey = Key('disabled');

      await tester.pumpMaterialWidget(
        Column(
          children: [
            NakedSlider(
              key: enabledKey,
              value: 0.5,
              onChanged: (_) {},
              child: _anyWidget(),
            ),
            NakedSlider(
              key: disabledKey,
              value: 0.5,
              enabled: false,
              onChanged: (_) {},
              child: _anyWidget(),
            ),
          ],
        ),
      );

      tester.expectCursor(
        SystemMouseCursors.click,
        on: enabledKey,
      );

      tester.expectCursor(
        SystemMouseCursors.forbidden,
        on: disabledKey,
      );
    });
  });

  group('RTL Support', () {
    testWidgets('arrow keys work correctly in RTL mode',
        (WidgetTester tester) async {
      double value = 0.5;
      final focusNode = FocusNode();

      await tester.pumpMaterialWidget(
        Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: StatefulBuilder(builder: (context, setState) {
              return NakedSlider(
                key: testKey,
                value: value,
                keyboardStep: 0.1,
                focusNode: focusNode,
                onChanged: (newValue) => setState(() => value = newValue),
                child: _anyWidget(),
              );
            }),
          ),
        ),
      );

      // Focus the slider
      focusNode.requestFocus();
      await tester.pump();

      // In RTL, right arrow should decrease value
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(value, 0.4);

      // In RTL, left arrow should increase value
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(value, 0.5);
    });
  });

  group('Additional Features', () {
    testWidgets('uses custom cursor when provided',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        NakedSlider(
          key: testKey,
          value: 0.5,
          cursor: SystemMouseCursors.precise,
          onChanged: (_) {},
          child: _anyWidget(),
        ),
      );

      tester.expectCursor(
        SystemMouseCursors.precise,
        on: testKey,
      );
    });

    testWidgets('large keyboard step with shift key',
        (WidgetTester tester) async {
      double value = 0.5;
      final focusNode = FocusNode();

      await tester.pumpMaterialWidget(
        StatefulBuilder(builder: (context, setState) {
          return NakedSlider(
            key: testKey,
            value: value,
            keyboardStep: 0.01,
            largeKeyboardStep: 0.2,
            focusNode: focusNode,
            onChanged: (newValue) => setState(() => value = newValue),
            child: _anyWidget(),
          );
        }),
      );

      // Focus the slider
      focusNode.requestFocus();
      await tester.pump();

      // Simulate pressing Shift+Right Arrow
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);

      await tester.pump();

      expect(value, 0.7);
    });

    testWidgets('works with custom min/max range', (WidgetTester tester) async {
      double value = 0.0;

      await tester.pumpMaterialWidget(
        StatefulBuilder(builder: (context, setState) {
          return NakedSlider(
            key: testKey,
            value: value,
            min: -100.0,
            max: 100.0,
            onChanged: (newValue) => setState(() => value = newValue),
            child: _anyWidget(),
          );
        }),
      );

      final sliderFinder = find.byKey(testKey);

      // Drag to the right
      await tester.drag(sliderFinder, const Offset(50.0, 0.0));
      await tester.pumpAndSettle();

      expect(value, greaterThan(0.0));
      expect(value, lessThan(100.0));
    });

    testWidgets('properly handles focus traversal',
        (WidgetTester tester) async {
      final focusNode1 = FocusNode();
      final focusNode2 = FocusNode();
      final focusNode3 = FocusNode();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(focusNode: focusNode1),
              NakedSlider(
                value: 0.5,
                focusNode: focusNode2,
                onChanged: (_) {},
                child: _anyWidget(),
              ),
              TextField(focusNode: focusNode3),
            ],
          ),
        ),
      ));

      // Focus the first text field
      focusNode1.requestFocus();
      await tester.pump();
      expect(focusNode1.hasFocus, true);

      // Press tab to move to the slider
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(focusNode2.hasFocus, true);

      // Press tab again to move to the next text field
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(focusNode3.hasFocus, true);
    });
  });
}
