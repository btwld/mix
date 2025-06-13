import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/naked.dart';

import 'helpers/simulate_hover.dart';

const _key = Key('radioButton');

void main() {
  group('Structural Tests', () {
    testWidgets('renders child widget correctly', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          groupValue: null,
          onChanged: (_) {},
          child: const NakedRadio<String>(
            value: 'test',
            child: Text('Test Radio'),
          ),
        ),
      );

      expect(find.text('Test Radio'), findsOneWidget);
    });

    testWidgets('throws FlutterError when used outside NakedRadioGroup',
        (WidgetTester tester) async {
      FlutterErrorDetails? errorDetails;
      FlutterError.onError = (FlutterErrorDetails details) {
        errorDetails = details;
      };

      await tester.pumpMaterialWidget(
        const NakedRadio<String>(
          value: 'test',
          child: SizedBox(width: 24, height: 24),
        ),
      );

      await tester.pump();

      expect(errorDetails?.exception, isA<FlutterError>());
    });
  });

  group('Selection Behavior Tests', () {
    testWidgets('handles tap to select', (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          groupValue: null,
          onChanged: (value) => selectedValue = value,
          child: const NakedRadio<String>(
            value: 'test',
            child: SizedBox(width: 24, height: 24),
          ),
        ),
      );

      await tester.tap(find.byType(NakedRadio<String>));
      expect(selectedValue, 'test');
    });

    testWidgets('maintains selected state when matching group value',
        (WidgetTester tester) async {
      String? selectedValue = 'test';
      bool wasChanged = false;

      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          groupValue: selectedValue,
          onChanged: (_) => wasChanged = true,
          child: const NakedRadio<String>(
            value: 'test',
            child: SizedBox(width: 24, height: 24),
          ),
        ),
      );

      await tester.tap(find.byType(NakedRadio<String>));
      expect(wasChanged,
          isFalse); // Should not call onChanged when already selected
    });
  });

  group('State Callback Tests', () {
    testWidgets('reports hover state changes', (WidgetTester tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      bool isHovered = false;

      await tester.pumpMaterialWidget(
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: NakedRadioGroup<String>(
            groupValue: 'test',
            onChanged: (_) {},
            child: NakedRadio<String>(
              key: _key,
              value: 'test',
              onHoverState: (value) => isHovered = value,
              child: Container(
                width: 24,
                height: 24,
                color: Colors.red,
              ),
            ),
          ),
        ),
      );

      await tester.simulateHover(_key, onHover: () {
        expect(isHovered, true);
      });
      expect(isHovered, false);
    });

    testWidgets('reports pressed state changes', (WidgetTester tester) async {
      bool isPressed = false;

      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          groupValue: null,
          onChanged: (_) {},
          child: NakedRadio<String>(
            value: 'test',
            onPressedState: (value) => isPressed = value,
            child: const SizedBox(width: 24, height: 24),
          ),
        ),
      );

      final gesture = await tester.press(find.byType(NakedRadio<String>));
      await tester.pump();
      expect(isPressed, true);

      await gesture.up();
      await tester.pump();
      expect(isPressed, false);
    });

    testWidgets('reports focus state changes', (WidgetTester tester) async {
      bool isFocused = false;
      final focusNode = FocusNode();

      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          groupValue: null,
          onChanged: (_) {},
          child: NakedRadio<String>(
            value: 'test',
            onFocusState: (value) => isFocused = value,
            focusNode: focusNode,
            child: const SizedBox(width: 24, height: 24),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      expect(isFocused, true);

      focusNode.unfocus();
      await tester.pump();
      expect(isFocused, false);
    });
  });

  group('Accessibility Tests', () {
    testWidgets('provides correct semantic properties',
        (WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          groupValue: 'test', // Selected
          onChanged: (_) {},
          child: NakedRadio<String>(
            key: key,
            value: 'test',
            child: const SizedBox(width: 24, height: 24),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byKey(key));
      expect(semantics.hasFlag(SemanticsFlag.isChecked), true);
      expect(semantics.hasFlag(SemanticsFlag.isEnabled), true);
    });

    testWidgets('handles keyboard selection with Space and Enter keys',
        (WidgetTester tester) async {
      String? selectedValue;
      final focusNode = FocusNode();

      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          groupValue: null,
          onChanged: (value) => selectedValue = value,
          child: NakedRadio<String>(
            value: 'test',
            focusNode: focusNode,
            child: const SizedBox(width: 24, height: 24),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();

      for (final key in [LogicalKeyboardKey.space, LogicalKeyboardKey.enter]) {
        await tester.sendKeyEvent(key);
        await tester.pump();
        expect(selectedValue, 'test');
        selectedValue = null;
      }
    });

    testWidgets('properly manages focus', (WidgetTester tester) async {
      bool isFocused = false;
      final focusNode = FocusNode();

      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          groupValue: null,
          onChanged: (_) {},
          child: NakedRadio<String>(
            value: 'test',
            focusNode: focusNode,
            onFocusState: (value) => isFocused = value,
            child: const SizedBox(width: 24, height: 24),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      expect(isFocused, true);
      expect(focusNode.hasFocus, true);
    });

    testWidgets('uses custom focus node when provided',
        (WidgetTester tester) async {
      final customFocusNode = FocusNode();

      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          groupValue: null,
          onChanged: (_) {},
          child: NakedRadio<String>(
            value: 'test',
            focusNode: customFocusNode,
            child: const SizedBox(width: 24, height: 24),
          ),
        ),
      );

      customFocusNode.requestFocus();
      await tester.pump();
      expect(customFocusNode.hasFocus, true);
    });
  });

  group('Interactivity Tests', () {
    testWidgets('disables interaction when RadioButton is disabled',
        (WidgetTester tester) async {
      bool wasChanged = false;

      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          groupValue: null,
          onChanged: (_) => wasChanged = true,
          child: const NakedRadio<String>(
            value: 'test',
            enabled: false,
            child: SizedBox(width: 24, height: 24),
          ),
        ),
      );

      await tester.tap(find.byType(NakedRadio<String>));
      expect(wasChanged, false);
    });

    testWidgets('disables interaction when group is disabled',
        (WidgetTester tester) async {
      bool wasChanged = false;

      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          groupValue: null,
          onChanged: (_) => wasChanged = true,
          enabled: false,
          child: const NakedRadio<String>(
            value: 'test',
            child: SizedBox(width: 24, height: 24),
          ),
        ),
      );

      await tester.tap(find.byType(NakedRadio<String>));
      expect(wasChanged, false);
    });

    testWidgets('shows forbidden cursor when disabled',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          groupValue: null,
          onChanged: (_) {},
          child: const NakedRadio<String>(
            key: _key,
            value: 'test',
            enabled: false,
            child: SizedBox(width: 24, height: 24),
          ),
        ),
      );

      tester.expectCursor(
        SystemMouseCursors.forbidden,
        on: _key,
      );
    });

    testWidgets('uses custom cursor when specified',
        (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        NakedRadioGroup<String>(
          key: _key,
          groupValue: null,
          onChanged: (_) {},
          child: const NakedRadio<String>(
            value: 'test',
            cursor: SystemMouseCursors.help,
            child: SizedBox(width: 24, height: 24),
          ),
        ),
      );

      tester.expectCursor(
        SystemMouseCursors.help,
        on: _key,
      );
    });
  });
}
