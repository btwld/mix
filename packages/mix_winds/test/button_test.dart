import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_winds/mix_winds.dart';

import 'winds_test_helpers.dart';

void main() {
  testWidgets('forwards the supported Pressable option set', (tester) async {
    final focusNode = FocusNode();
    final controller = WidgetStatesController();
    addTearDown(focusNode.dispose);
    addTearDown(controller.dispose);
    void onPressed() {}
    void onLongPress() {}
    void onFocusChange(bool _) {}
    KeyEventResult onKeyEvent(FocusNode _, KeyEvent _) =>
        KeyEventResult.ignored;
    final actions = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => null),
    };

    await pumpLtr(
      tester,
      Button(
        classNames: 'flex w-20 h-10 bg-blue-500',
        onPressed: onPressed,
        onLongPress: onLongPress,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        onKeyEvent: onKeyEvent,
        controller: controller,
        actions: actions,
        enableFeedback: true,
        hitTestBehavior: HitTestBehavior.translucent,
        autofocus: true,
        mouseCursor: SystemMouseCursors.help,
        canRequestFocus: false,
        excludeFromSemantics: true,
        semanticsLabel: 'Tailwind button',
        children: const [SizedBox(width: 8), SizedBox(width: 8)],
      ),
    );

    final pressable = tester.widget<Pressable>(find.byType(Pressable));
    expect(pressable.onPress, same(onPressed));
    expect(pressable.onLongPress, same(onLongPress));
    expect(pressable.onFocusChange, same(onFocusChange));
    expect(pressable.focusNode, same(focusNode));
    expect(pressable.onKeyEvent, same(onKeyEvent));
    expect(pressable.controller, same(controller));
    expect(pressable.actions, same(actions));
    expect(pressable.enabled, isTrue);
    expect(pressable.enableFeedback, isTrue);
    expect(pressable.hitTestBehavior, HitTestBehavior.translucent);
    expect(pressable.autofocus, isTrue);
    expect(pressable.mouseCursor, SystemMouseCursors.help);
    expect(pressable.canRequestFocus, isFalse);
    expect(pressable.excludeFromSemantics, isTrue);
    expect(pressable.semanticsLabel, 'Tailwind button');
    expect(pressable.semanticsRole, PressableSemanticsRole.button);
    expect(find.byType(Flex), findsOneWidget);
  });

  testWidgets('onPressed enables button semantics and its tap action', (
    tester,
  ) async {
    const subject = Key('enabled-button');
    var presses = 0;
    await pumpSized(
      tester,
      Button(
        key: subject,
        classNames: 'w-20 h-10',
        semanticsLabel: 'Save changes',
        onPressed: () => presses++,
      ),
    );

    final pressable = tester.widget<Pressable>(find.byType(Pressable));
    expect(pressable.enabled, isTrue);
    expect(pressable.semanticsRole, PressableSemanticsRole.button);
    expect(
      tester.getSemantics(find.byType(Pressable)),
      isSemantics(
        label: 'Save changes',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        hasLongPressAction: false,
      ),
    );

    await tester.tapAt(tester.getCenter(find.byType(Container)));
    await tester.pump();
    expect(presses, 1);
  });

  testWidgets('uses visible Span text as one merged accessible button name', (
    tester,
  ) async {
    var semanticsDisposed = false;
    final semanticsHandle = tester.ensureSemantics();
    void disposeSemantics() {
      if (semanticsDisposed) return;
      semanticsDisposed = true;
      semanticsHandle.dispose();
    }

    addTearDown(disposeSemantics);
    try {
      await pumpSized(
        tester,
        Button(
          classNames: 'w-20 h-10',
          onPressed: () {},
          child: const Span(text: 'Save'),
        ),
      );

      expect(find.bySemanticsLabel('Save'), findsOneWidget);
      final buttonNode = tester.getSemantics(find.byType(Pressable));
      expect(
        buttonNode,
        isSemantics(
          label: 'Save',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
          hasLongPressAction: false,
        ),
      );
      expect(buttonNode.childrenCountInTraversalOrder, 0);
    } finally {
      disposeSemantics();
    }
  });

  testWidgets('null onPressed disables a button with no other action', (
    tester,
  ) async {
    const subject = Key('disabled-button');
    await pumpSized(
      tester,
      const Button(
        key: subject,
        classNames: 'w-20 h-10',
        semanticsLabel: 'Disabled action',
        onPressed: null,
      ),
    );

    final pressable = tester.widget<Pressable>(find.byType(Pressable));
    expect(pressable.enabled, isFalse);
    expect(pressable.onPress, isNull);
    expect(pressable.semanticsRole, PressableSemanticsRole.button);
    expect(
      tester.getSemantics(find.byType(Pressable)),
      isSemantics(
        label: 'Disabled action',
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
        hasTapAction: false,
        hasLongPressAction: false,
      ),
    );
  });

  testWidgets('onLongPress keeps a null-onPressed button actionable', (
    tester,
  ) async {
    const subject = Key('long-press-button');
    var longPresses = 0;
    await pumpSized(
      tester,
      Button(
        key: subject,
        classNames: 'w-20 h-20',
        semanticsLabel: 'More options',
        onPressed: null,
        onLongPress: () => longPresses++,
      ),
    );

    final pressable = tester.widget<Pressable>(find.byType(Pressable));
    expect(pressable.enabled, isTrue);
    expect(pressable.onPress, isNull);
    expect(
      tester.getSemantics(find.byType(Pressable)),
      isSemantics(
        label: 'More options',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: false,
        hasLongPressAction: true,
      ),
    );

    await tester.longPressAt(tester.getCenter(find.byType(Container)));
    await tester.pump();
    expect(longPresses, 1);
  });

  testWidgets('shares held state with its Tailwind border box', (tester) async {
    var presses = 0;
    await pumpSized(
      tester,
      Button(
        classNames: 'w-20 h-20 bg-red-500 active:bg-blue-500',
        onPressed: () => presses++,
      ),
      width: 200,
      height: 120,
    );

    final container = find.byType(Container);
    Color? color() =>
        (tester.widget<Container>(container).decoration as BoxDecoration?)
            ?.color;

    expect(color(), const Color(0xFFFB2C36));
    final gesture = await tester.startGesture(tester.getCenter(container));
    await tester.pump();
    expect(color(), const Color(0xFF2B7FFF));

    await gesture.up();
    await tester.pump();
    expect(color(), const Color(0xFFFB2C36));
    expect(presses, 1);
  });
}
