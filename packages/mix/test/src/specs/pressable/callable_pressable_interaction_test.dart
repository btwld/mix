import 'dart:ui' show SemanticsAction, SemanticsActionEvent;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  testWidgets(
    'reused builders resolve tokens and animated variants in context',
    (tester) async {
      const token = ColorToken('surface');
      final button = BoxStyler()
          .size(100, 60)
          .color(token())
          .onPressed(.color(Colors.red))
          .animate(
            .curve(
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
            ),
          )
          .pressable();
      final label = TextStyler()
          .color(Colors.black)
          .onPressed(.color(Colors.white));
      await tester.pumpWidget(
        MaterialApp(
          home: Row(
            children: [
              MixScope(
                tokens: {token: Colors.blue},
                child: button(key: const Key('blue'), child: label('Blue')),
              ),
              MixScope(
                tokens: {token: Colors.green},
                child: button(key: const Key('green'), child: label('Green')),
              ),
            ],
          ),
        ),
      );
      Color? surface(String key) =>
          (tester
                      .widget<Container>(
                        find.descendant(
                          of: find.byKey(Key(key)),
                          matching: find.byType(Container),
                        ),
                      )
                      .decoration
                  as BoxDecoration)
              .color;
      expect(surface('blue'), Colors.blue);
      expect(surface('green'), Colors.green);
      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const Key('blue'))),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(surface('blue'), isNot(Colors.blue));
      expect(surface('blue'), isNot(Colors.red));
      expect(surface('green'), Colors.green);
      final text = tester.widget<Text>(
        find.descendant(
          of: find.byKey(const Key('blue')),
          matching: find.byType(Text),
        ),
      );
      expect(text.style?.color, Colors.white);
      await tester.pump(const Duration(milliseconds: 50));
      expect(surface('blue'), Colors.red);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(surface('blue'), Colors.blue);
    },
  );

  testWidgets('pointer cancellation clears state without activation', (
    tester,
  ) async {
    final controller = WidgetStatesController();
    addTearDown(controller.dispose);
    var presses = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: BoxStyler().size(100, 60).pressable()(
            controller: controller,
            onPress: () => presses++,
          ),
        ),
      ),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(Pressable)),
    );
    await tester.pump();
    expect(controller.pressed, isTrue);
    await gesture.cancel();
    await tester.pump();
    expect(controller.pressed, isFalse);
    expect(presses, 0);
  });

  testWidgets('reused builder owns independent internal interaction state', (
    tester,
  ) async {
    final button = BoxStyler().size(100, 60).pressable();
    final states = <String, bool>{};
    Widget probe(String name) => Builder(
      builder: (context) {
        states[name] = WidgetStateProvider.hasStateOf(
          context,
          WidgetState.pressed,
        );
        return Text(name);
      },
    );
    final first = button(key: const Key('first'), child: probe('first'));
    final second = button(key: const Key('second'), child: probe('second'));
    expect(first.child.key, isNull);
    expect(second.child.key, isNull);
    await tester.pumpWidget(
      MaterialApp(
        home: Center(child: Row(children: [first, second])),
      ),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('first'))),
    );
    await tester.pump();
    expect(states, {'first': true, 'second': false});
    await gesture.up();
    await tester.pump();
    expect(states, {'first': false, 'second': false});
    expect(tester.takeException(), isNull);
  });

  for (final isSwitch in [false, true]) {
    testWidgets(
      'builder preserves external ${isSwitch ? 'switch' : 'checkbox'} semantics',
      (tester) async {
        var presses = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: Semantics(
                key: const Key('semantic-owner'),
                container: true,
                label: 'Preference',
                checked: isSwitch ? null : true,
                toggled: isSwitch ? true : null,
                onTap: () => presses++,
                child: BoxStyler().size(100, 60).pressable()(
                  excludeFromSemantics: true,
                  onPress: () => presses++,
                ),
              ),
            ),
          ),
        );
        expect(
          tester.getSemantics(find.byKey(const Key('semantic-owner'))),
          matchesSemantics(
            label: 'Preference',
            hasCheckedState: !isSwitch,
            isChecked: !isSwitch,
            hasToggledState: isSwitch,
            isToggled: isSwitch,
            hasTapAction: true,
          ),
        );
        await tester.tap(find.byType(Pressable));
        expect(presses, 1);
        tester.binding.performSemanticsAction(
          SemanticsActionEvent(
            type: SemanticsAction.tap,
            viewId: tester.view.viewId,
            nodeId: tester
                .getSemantics(find.byKey(const Key('semantic-owner')))
                .id,
          ),
        );
        await tester.pump();
        expect(presses, 2);
      },
    );
  }

  testWidgets(
    'feedback honors defaults, opt-in, long press and disabled state',
    (tester) async {
      final calls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          calls.add(call);
          return null;
        },
      );
      addTearDown(() {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        );
      });
      final button = BoxStyler().size(100, 60).pressable();
      var presses = 0;
      var holds = 0;
      Future<void> pumpButton({
        bool feedback = false,
        bool enabled = true,
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Center(
              child: button(
                enabled: enabled,
                enableFeedback: feedback,
                onPress: () => presses++,
                onLongPress: () => holds++,
              ),
            ),
          ),
        );
        calls.clear();
      }

      await pumpButton();
      await tester.tap(find.byType(Pressable));
      await tester.pump();
      expect(presses, 1);
      expect(calls.where((call) => call.method == 'SystemSound.play'), isEmpty);

      await pumpButton(feedback: true);
      await tester.tap(find.byType(Pressable));
      await tester.pump();
      expect(presses, 2);
      expect(
        calls
            .where((call) => call.method == 'SystemSound.play')
            .single
            .arguments,
        'SystemSoundType.click',
      );
      calls.clear();
      await tester.longPress(find.byType(Pressable));
      await tester.pump();
      expect(holds, 1);
      expect(presses, 2);
      expect(
        calls.where((call) => call.method == 'HapticFeedback.vibrate'),
        hasLength(1),
      );

      await pumpButton(feedback: true, enabled: false);
      await tester.tap(find.byType(Pressable));
      await tester.longPress(find.byType(Pressable));
      await tester.pump();
      expect(presses, 2);
      expect(holds, 1);
      expect(
        calls.where(
          (call) =>
              call.method == 'SystemSound.play' ||
              call.method == 'HapticFeedback.vibrate',
        ),
        isEmpty,
      );
    },
  );

  for (final role in [
    PressableSemanticsRole.button,
    PressableSemanticsRole.link,
  ]) {
    testWidgets('Text builder retains $role keyboard behavior', (tester) async {
      final node = FocusNode();
      final controller = WidgetStatesController();
      addTearDown(node.dispose);
      addTearDown(controller.dispose);
      var presses = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: TextStyler().pressable()(
              'Settings',
              onPress: () => presses++,
              semanticsRole: role,
              focusNode: node,
              controller: controller,
            ),
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();
      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(controller.pressed, role == PressableSemanticsRole.button);
      await tester.sendKeyRepeatEvent(LogicalKeyboardKey.space);
      expect(presses, 0);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      expect(presses, role == PressableSemanticsRole.button ? 1 : 0);

      presses = 0;
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyRepeatEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(controller.pressed, isTrue);
      expect(presses, 0);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(controller.pressed, isFalse);
      expect(presses, 1);
    });
  }
}
