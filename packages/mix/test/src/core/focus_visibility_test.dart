import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

const _boxKey = Key('focus-visible-box');

Future<FocusNode> _pumpFocusable(WidgetTester tester) async {
  final focusNode = FocusNode();
  addTearDown(focusNode.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: Align(
        alignment: Alignment.topLeft,
        child: Pressable(
          focusNode: focusNode,
          child: Box(
            key: _boxKey,
            style: BoxStyler()
                .size(100, 100)
                .color(Colors.blue)
                .onFocusVisible(.color(Colors.red)),
          ),
        ),
      ),
    ),
  );

  return focusNode;
}

Color? _colorOf(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.descendant(of: find.byKey(_boxKey), matching: find.byType(Container)),
  );

  return (container.decoration as BoxDecoration?)?.color;
}

// Presses away from the box, so focus stays where it is.
Future<void> _pressOutside(
  WidgetTester tester, {
  PointerDeviceKind kind = .mouse,
}) async {
  await tester.tapAt(const Offset(400, 400), kind: kind);
  await tester.pumpAndSettle();
}

void main() {
  const desktop = TargetPlatformVariant({.macOS});

  group('FocusVisibility', () {
    testWidgets('keyboard input shows focus and a mouse press hides it', (
      tester,
    ) async {
      final focusNode = await _pumpFocusable(tester);
      focusNode.requestFocus();
      await tester.pumpAndSettle();
      // Before any input, desktop follows Flutter's traditional default.
      expect(_colorOf(tester), Colors.red);

      await _pressOutside(tester);
      expect(focusNode.hasFocus, isTrue);
      expect(FocusVisibility.isVisible, isFalse);
      expect(_colorOf(tester), Colors.blue);

      await tester.sendKeyEvent(.arrowDown);
      await tester.pump();
      expect(FocusVisibility.isVisible, isTrue);
      expect(_colorOf(tester), Colors.red);
    }, variant: desktop);

    testWidgets('focus moved in code after a mouse press stays hidden', (
      tester,
    ) async {
      final focusNode = await _pumpFocusable(tester);
      await _pressOutside(tester);

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);
      expect(_colorOf(tester), Colors.blue);
    }, variant: desktop);

    testWidgets('Tab after a mouse press shows focus', (tester) async {
      final focusNode = await _pumpFocusable(tester);
      await _pressOutside(tester);

      await tester.sendKeyEvent(.tab);
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);
      expect(_colorOf(tester), Colors.red);
    }, variant: desktop);

    testWidgets(
      'modifier keys and shortcuts do not count as keyboard input',
      (tester) async {
        final focusNode = await _pumpFocusable(tester);
        focusNode.requestFocus();
        await _pressOutside(tester);

        for (final modifier in [
          LogicalKeyboardKey.shiftLeft,
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.metaLeft,
          LogicalKeyboardKey.altLeft,
        ]) {
          await tester.sendKeyEvent(modifier);
        }
        await tester.sendKeyDownEvent(.metaLeft);
        await tester.sendKeyEvent(.keyB);
        await tester.sendKeyUpEvent(.metaLeft);
        await tester.sendKeyDownEvent(.controlLeft);
        await tester.sendKeyEvent(.keyB);
        await tester.sendKeyUpEvent(.controlLeft);
        await tester.pump();
        expect(_colorOf(tester), Colors.blue);

        await tester.sendKeyDownEvent(.shiftLeft);
        await tester.sendKeyEvent(.tab);
        await tester.sendKeyUpEvent(.shiftLeft);
        await tester.pump();
        expect(FocusVisibility.isVisible, isTrue);
      },
      variant: desktop,
    );

    for (final readOnly in [false, true]) {
      testWidgets(
        'a mouse press into a ${readOnly ? 'read-only' : 'editable'} text '
        'field ${readOnly ? 'hides' : 'shows'} focus',
        (tester) async {
          final controller = TextEditingController(text: 'text');
          addTearDown(controller.dispose);
          await tester.pumpWidget(
            MaterialApp(
              home: Material(
                child: TextField(controller: controller, readOnly: readOnly),
              ),
            ),
          );

          await tester.tap(find.byType(EditableText), kind: .mouse);
          await tester.pump();
          expect(
            tester
                .widget<EditableText>(find.byType(EditableText))
                .focusNode
                .hasFocus,
            isTrue,
          );
          expect(FocusVisibility.isVisible, !readOnly);
        },
        variant: desktop,
      );
    }

    testWidgets('a touch press hides focus', (tester) async {
      final focusNode = await _pumpFocusable(tester);
      await tester.sendKeyEvent(.tab);
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);
      expect(_colorOf(tester), Colors.red);

      await _pressOutside(tester, kind: .touch);
      expect(_colorOf(tester), Colors.blue);
    });

    testWidgets('alwaysTraditional shows focus after a pointer press', (
      tester,
    ) async {
      final focusManager = FocusManager.instance;
      final previousStrategy = focusManager.highlightStrategy;
      addTearDown(() => focusManager.highlightStrategy = previousStrategy);
      await _pumpFocusable(tester);
      await _pressOutside(tester);

      focusManager.highlightStrategy = .alwaysTraditional;
      expect(FocusVisibility.isVisible, isTrue);
    }, variant: desktop);

    testWidgets('alwaysTouch hides focus after keyboard input', (tester) async {
      final focusManager = FocusManager.instance;
      final previousStrategy = focusManager.highlightStrategy;
      addTearDown(() => focusManager.highlightStrategy = previousStrategy);
      await _pumpFocusable(tester);

      focusManager.highlightStrategy = .alwaysTouch;
      await tester.sendKeyEvent(.arrowDown);
      expect(FocusVisibility.isVisible, isFalse);
    }, variant: desktop);

    testWidgets('notifies listeners when visibility changes', (tester) async {
      await _pumpFocusable(tester);
      var notifications = 0;
      void listener() => notifications++;
      final listenable = FocusVisibility.listenable..addListener(listener);
      addTearDown(() => listenable.removeListener(listener));

      await _pressOutside(tester);
      await _pressOutside(tester);
      expect(notifications, 1);

      await tester.sendKeyEvent(.arrowDown);
      expect(notifications, 2);
    }, variant: desktop);
  });
}
