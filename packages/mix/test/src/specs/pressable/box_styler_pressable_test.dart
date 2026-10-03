import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('callable pressable builders', () {
    test('BoxStyler terminates composition and preserves style identity', () {
      final style = BoxStyler().padding(.all(16)).color(Colors.blue);
      final builder = style.pressable();
      const child = Text('Save');
      const key = Key('save');
      final pressable = builder(key: key, child: child);

      expect(pressable, isA<Pressable>());
      expect(pressable.key, key);
      expect(pressable.child, isA<Box>());
      final box = pressable.child as Box;
      expect(box.style, same(style));
      expect(box.child, same(child));
    });

    test('forwards the complete Pressable surface', () {
      final focusNode = FocusNode();
      final controller = WidgetStatesController();
      addTearDown(focusNode.dispose);
      addTearDown(controller.dispose);
      void onPress() {}
      void onLongPress() {}
      void onFocusChange(bool _) {}
      KeyEventResult onKeyEvent(FocusNode _, KeyEvent _) =>
          KeyEventResult.handled;
      final actions = <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => null),
      };

      final pressable = BoxStyler().pressable()(
        key: const Key('action'),
        child: const Text('Save'),
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

      expect(pressable.onPress, same(onPress));
      expect(pressable.onLongPress, same(onLongPress));
      expect(pressable.focusNode, same(focusNode));
      expect(pressable.autofocus, isTrue);
      expect(pressable.enableFeedback, isTrue);
      expect(pressable.onFocusChange, same(onFocusChange));
      expect(pressable.mouseCursor, SystemMouseCursors.help);
      expect(pressable.canRequestFocus, isFalse);
      expect(pressable.excludeFromSemantics, isTrue);
      expect(pressable.semanticsLabel, 'Save changes');
      expect(pressable.semanticsRole, PressableSemanticsRole.link);
      expect(pressable.onKeyEvent, same(onKeyEvent));
      expect(pressable.controller, same(controller));
      expect(pressable.actions, same(actions));
      expect(pressable.hitTestBehavior, HitTestBehavior.translucent);
      expect(pressable.enabled, isFalse);
    });

    testWidgets('state variants resolve inside the Pressable boundary', (
      tester,
    ) async {
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);
      final style = BoxStyler()
          .size(100, 50)
          .color(Colors.blue)
          .onPressed(.color(Colors.red));

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: style.pressable()(
              controller: controller,
              onPress: () {},
              child: const Text('Save'),
            ),
          ),
        ),
      );
      Color? color() {
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(Box),
            matching: find.byType(Container),
          ),
        );
        return (container.decoration as BoxDecoration).color;
      }

      expect(color(), Colors.blue);
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(Box)),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(color(), Colors.red);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(color(), Colors.blue);
    });
  });
}
