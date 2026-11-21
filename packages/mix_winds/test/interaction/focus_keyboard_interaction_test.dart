import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_winds/mix_winds.dart';

const _red500 = Color(0xFFFB2C36);
const _blue500 = Color(0xFF2B7FFF);

Future<void> _pumpApp(WidgetTester tester, Widget child) async {
  await tester.binding.setSurfaceSize(const Size(500, 400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      home: Align(alignment: Alignment.topLeft, child: child),
    ),
  );
  await tester.pump();
}

Finder _containerInside(Key key) =>
    find.descendant(of: find.byKey(key), matching: find.byType(Container));

Color? _decorationColor(WidgetTester tester, Key key) {
  final finder = _containerInside(key);
  expect(finder, findsOneWidget);
  final container = tester.widget<Container>(finder);
  return (container.decoration as BoxDecoration?)?.color;
}

void main() {
  testWidgets('C1 focus changes a Pressable child Div decoration', (
    tester,
  ) async {
    const subject = Key('c1-div');
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await _pumpApp(
      tester,
      Pressable(
        focusNode: focusNode,
        onPress: () {},
        child: const Div(
          key: subject,
          classNames: 'w-20 h-20 bg-red-500 focus:bg-blue-500',
        ),
      ),
    );

    expect(_decorationColor(tester, subject), _red500);
    focusNode.requestFocus();
    await tester.pumpAndSettle();

    expect(focusNode.hasFocus, isTrue);
    expect(_decorationColor(tester, subject), _blue500);
  });

  testWidgets('C2 Space and Enter activate a focused Pressable', (
    tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    var presses = 0;
    await _pumpApp(
      tester,
      Pressable(
        focusNode: focusNode,
        onPress: () => presses++,
        child: const Div(classNames: 'w-20 h-20 bg-red-500'),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(presses, 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(presses, 2);
  });

  testWidgets('C3 Space hold drives active styling until key release', (
    tester,
  ) async {
    const subject = Key('c3-div');
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await _pumpApp(
      tester,
      Button(
        key: subject,
        classNames: 'w-20 h-20 bg-red-500 active:bg-blue-500',
        focusNode: focusNode,
        onPressed: () {},
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.pump();
    final colorWhileHeld = _decorationColor(tester, subject);

    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.pump();
    final colorAfterRelease = _decorationColor(tester, subject);

    expect([colorWhileHeld, colorAfterRelease], [_blue500, _red500]);
  });

  testWidgets('C4 focus-visible stays off when a pointer tap requests focus', (
    tester,
  ) async {
    const subject = Key('c4-div');
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await _pumpApp(
      tester,
      Button(
        key: subject,
        classNames: 'w-20 h-20 bg-red-500 focus-visible:bg-blue-500',
        focusNode: focusNode,
        onPressed: focusNode.requestFocus,
      ),
    );

    await tester.tap(_containerInside(subject));
    await tester.pump();
    final focused = focusNode.hasFocus;
    final colorAfterPointerFocus = _decorationColor(tester, subject);
    focusNode.unfocus();
    await tester.pump();

    expect([focused, colorAfterPointerFocus], [true, _red500]);
  });
}
