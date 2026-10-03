import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('BoxStyler.pressable', () {
    test(
      'returns a PressableBox with the receiver and constructor defaults',
      () {
        final style = BoxStyler().padding(.all(16)).color(Colors.blue);
        const child = Text('Save');
        final PressableBox box = style.pressable(child: child);
        const defaults = PressableBox(child: child);

        expect(box.style, same(style));
        expect(box.child, same(child));
        expect(box.key, defaults.key);
        expect(box.onPress, defaults.onPress);
        expect(box.onLongPress, defaults.onLongPress);
        expect(box.focusNode, defaults.focusNode);
        expect(box.autofocus, defaults.autofocus);
        expect(box.enableFeedback, defaults.enableFeedback);
        expect(box.onFocusChange, defaults.onFocusChange);
        expect(box.mouseCursor, defaults.mouseCursor);
        expect(box.canRequestFocus, defaults.canRequestFocus);
        expect(box.excludeFromSemantics, defaults.excludeFromSemantics);
        expect(box.semanticsLabel, defaults.semanticsLabel);
        expect(box.semanticsRole, defaults.semanticsRole);
        expect(box.onKeyEvent, defaults.onKeyEvent);
        expect(box.controller, defaults.controller);
        expect(box.actions, defaults.actions);
        expect(box.hitTestBehavior, defaults.hitTestBehavior);
        expect(box.enabled, defaults.enabled);
      },
    );

    test('forwards every interaction option unchanged', () {
      final style = BoxStyler();
      const key = Key('save');
      const child = Text('Save');
      void onPress() {}
      void onLongPress() {}
      void onFocusChange(bool focused) {}
      KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) =>
          KeyEventResult.handled;
      final focusNode = FocusNode();
      final controller = WidgetStatesController();
      final actions = <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => null),
      };
      addTearDown(focusNode.dispose);
      addTearDown(controller.dispose);

      final box = style.pressable(
        key: key,
        child: child,
        onPress: onPress,
        onLongPress: onLongPress,
        focusNode: focusNode,
        autofocus: true,
        enableFeedback: true,
        onFocusChange: onFocusChange,
        mouseCursor: SystemMouseCursors.help,
        canRequestFocus: false,
        excludeFromSemantics: true,
        semanticsLabel: 'Save changes',
        semanticsRole: PressableSemanticsRole.link,
        onKeyEvent: onKeyEvent,
        controller: controller,
        actions: actions,
        hitTestBehavior: HitTestBehavior.translucent,
        enabled: false,
      );

      expect(box.style, same(style));
      expect(box.key, key);
      expect(box.child, same(child));
      expect(box.onPress, same(onPress));
      expect(box.onLongPress, same(onLongPress));
      expect(box.focusNode, same(focusNode));
      expect(box.autofocus, isTrue);
      expect(box.enableFeedback, isTrue);
      expect(box.onFocusChange, same(onFocusChange));
      expect(box.mouseCursor, SystemMouseCursors.help);
      expect(box.canRequestFocus, isFalse);
      expect(box.excludeFromSemantics, isTrue);
      expect(box.semanticsLabel, 'Save changes');
      expect(box.semanticsRole, PressableSemanticsRole.link);
      expect(box.onKeyEvent, same(onKeyEvent));
      expect(box.controller, same(controller));
      expect(box.actions, same(actions));
      expect(box.hitTestBehavior, HitTestBehavior.translucent);
      expect(box.enabled, isFalse);
    });

    testWidgets('resolves pressed styling and activates the composed widget', (
      tester,
    ) async {
      var presses = 0;
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);
      final style = BoxStyler()
          .size(100, 50)
          .color(Colors.blue)
          .onPressed(.color(Colors.red));

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: style.pressable(
              controller: controller,
              onPress: () => presses++,
              child: const Text('Save'),
            ),
          ),
        ),
      );

      final boxFinder = find.byType(Box);
      Color? backgroundColor() {
        final container = tester.widget<Container>(
          find.descendant(of: boxFinder, matching: find.byType(Container)),
        );

        return (container.decoration as BoxDecoration).color;
      }

      expect(tester.widget<Box>(boxFinder).style, same(style));
      expect(backgroundColor(), Colors.blue);

      final gesture = await tester.startGesture(tester.getCenter(boxFinder));
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.value, contains(WidgetState.pressed));
      expect(backgroundColor(), Colors.red);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(presses, 1);
      expect(controller.value, isNot(contains(WidgetState.pressed)));
      expect(backgroundColor(), Colors.blue);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
