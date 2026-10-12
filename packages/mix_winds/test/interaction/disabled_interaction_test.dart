import 'package:flutter/gestures.dart';
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

double _effectiveOpacity(WidgetTester tester, Key key) {
  final finder = find.descendant(
    of: find.byKey(key),
    matching: find.byType(Opacity),
  );
  if (finder.evaluate().isEmpty) return 1;
  expect(finder, findsOneWidget);
  return tester.widget<Opacity>(finder).opacity;
}

void main() {
  testWidgets('D1 disabled and enabled variants resolve as exact inverses', (
    tester,
  ) async {
    const subject = Key('d1-div');

    await _pumpApp(
      tester,
      const Pressable(
        enabled: false,
        child: Div(
          key: subject,
          classNames:
              'w-20 h-20 bg-red-500 disabled:opacity-50 enabled:bg-blue-500',
        ),
      ),
    );
    expect(_effectiveOpacity(tester, subject), 0.5);
    expect(_decorationColor(tester, subject), _red500);

    await _pumpApp(
      tester,
      const Pressable(
        child: Div(
          key: subject,
          classNames:
              'w-20 h-20 bg-red-500 disabled:opacity-50 enabled:bg-blue-500',
        ),
      ),
    );
    expect(_effectiveOpacity(tester, subject), 1);
    expect(_decorationColor(tester, subject), _blue500);
  });

  testWidgets('D2 disabled blocks tap, keyboard activation, and hover style', (
    tester,
  ) async {
    const subject = Key('d2-div');
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    var presses = 0;
    await _pumpApp(
      tester,
      Pressable(
        enabled: false,
        focusNode: focusNode,
        onPress: () => presses++,
        child: const Div(
          key: subject,
          classNames: 'w-20 h-20 bg-red-500 hover:bg-blue-500',
        ),
      ),
    );

    await tester.tap(_containerInside(subject), warnIfMissed: false);
    await tester.pump();
    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(-100, -100));
    await mouse.moveTo(tester.getCenter(_containerInside(subject)));
    await tester.pump();
    final hoverColor = _decorationColor(tester, subject);
    await mouse.removePointer();

    expect([presses, focusNode.hasFocus, hoverColor], [0, false, _red500]);
  });

  testWidgets('D3 disabled Button exposes disabled non-actionable semantics', (
    tester,
  ) async {
    const subject = Key('d3-button');
    await _pumpApp(
      tester,
      const Button(
        key: subject,
        classNames: 'w-20 h-20',
        semanticsLabel: 'Disabled action',
        onPressed: null,
      ),
    );

    expect(
      tester.getSemantics(
        find.descendant(
          of: find.byKey(subject),
          matching: find.byType(Pressable),
        ),
      ),
      isSemantics(
        label: 'Disabled action',
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
        hasTapAction: false,
      ),
    );
  });

  testWidgets('D4 tab traversal skips a disabled Pressable', (tester) async {
    final before = FocusNode(debugLabel: 'before');
    final disabled = FocusNode(debugLabel: 'disabled');
    final after = FocusNode(debugLabel: 'after');
    addTearDown(before.dispose);
    addTearDown(disabled.dispose);
    addTearDown(after.dispose);

    await _pumpApp(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Pressable(
            focusNode: before,
            onPress: () {},
            child: const SizedBox(width: 80, height: 40),
          ),
          Pressable(
            enabled: false,
            focusNode: disabled,
            onPress: () {},
            child: const SizedBox(width: 80, height: 40),
          ),
          Pressable(
            focusNode: after,
            onPress: () {},
            child: const SizedBox(width: 80, height: 40),
          ),
        ],
      ),
    );

    before.requestFocus();
    await tester.pumpAndSettle();
    expect(before.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(
      [before.hasFocus, disabled.hasFocus, after.hasFocus],
      [false, false, true],
    );
  });
}
