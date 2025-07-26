// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/widget_state/widget_state_provider.dart';

class TrackRebuildWidget<T> extends StatefulWidget {
  final String text;
  final T Function(BuildContext) stateBuilder;

  const TrackRebuildWidget({
    super.key,
    required this.text,
    required this.stateBuilder,
  });

  @override
  // ignore: library_private_types_in_public_api
  TrackRebuildWidgetState createState() => TrackRebuildWidgetState();

  static TrackRebuildWidgetState findState(WidgetTester tester, String text) {
    return tester.state(
      find.byWidgetPredicate(
        (widget) => widget is TrackRebuildWidget && widget.text == text,
      ),
    );
  }
}

class TrackRebuildWidgetState<T> extends State<TrackRebuildWidget<T>> {
  int buildCount = 0;
  T? state;

  @override
  Widget build(BuildContext context) {
    buildCount++;
    state = widget.stateBuilder(context);

    return Text(widget.text);
  }
}

extension on WidgetStatesController {
  /// Batch updates the state of the widget with multiple state changes.
  ///
  /// [updates] is a list of tuples, where each tuple contains a state [key]
  /// and a boolean [add] indicating whether to add or remove the state.
  /// Listeners are notified if any state has changed.
  void batch(List<(WidgetState, bool)> updates) {
    var valueHasChanged = false;
    for (final update in updates) {
      final key = update.$1;
      final add = update.$2;
      if (add) {
        valueHasChanged |= value.add(key);
      } else {
        valueHasChanged |= value.remove(key);
      }
    }

    if (valueHasChanged) {
      notifyListeners();
    }
  }
}

void main() {
  group('WidgetStatesController', () {
    test('initial state values', () {
      final controller = WidgetStatesController();
      expect(controller.has(WidgetState.disabled), isFalse);
      expect(controller.has(WidgetState.hovered), isFalse);
      expect(controller.has(WidgetState.focused), isFalse);
      expect(controller.has(WidgetState.pressed), isFalse);
      expect(controller.has(WidgetState.dragged), isFalse);
      expect(controller.has(WidgetState.selected), isFalse);
    });

    test('update individual state', () {
      final controller = WidgetStatesController();

      controller.disabled = true;
      expect(controller.has(WidgetState.disabled), isTrue);

      controller.hovered = true;
      expect(controller.has(WidgetState.hovered), isTrue);

      controller.focused = true;
      expect(controller.has(WidgetState.focused), isTrue);

      controller.pressed = true;
      expect(controller.has(WidgetState.pressed), isTrue);

      controller.dragged = true;
      expect(controller.has(WidgetState.dragged), isTrue);

      controller.selected = true;
      expect(controller.has(WidgetState.selected), isTrue);
    });

    test('batch update states', () {
      final controller = WidgetStatesController();

      controller.batch([
        (WidgetState.disabled, true),
        (WidgetState.hovered, true),
        (WidgetState.focused, true),
      ]);

      expect(controller.has(WidgetState.disabled), isTrue);
      expect(controller.has(WidgetState.hovered), isTrue);
      expect(controller.has(WidgetState.focused), isTrue);
      expect(controller.has(WidgetState.pressed), isFalse);
      expect(controller.has(WidgetState.dragged), isFalse);
      expect(controller.has(WidgetState.selected), isFalse);
    });

    test('notifyListeners called on state change', () {
      final controller = WidgetStatesController();

      var notifyListenersCallCount = 0;
      controller.addListener(() => notifyListenersCallCount++);

      controller.update(WidgetState.disabled, true);
      expect(notifyListenersCallCount, 1);

      controller.batch([
        (WidgetState.hovered, true),
        (WidgetState.focused, true),
      ]);
      expect(notifyListenersCallCount, 2);

      // No change, should not notify
      controller.pressed = false;
      expect(notifyListenersCallCount, 2);
    });
  });
  group('MixWidgetStateModel', () {
    testWidgets('of finds model', (tester) async {
      final controller = WidgetStatesController();

      controller.disabled = true;
      controller.hovered = true;
      controller.focused = true;
      controller.pressed = true;
      controller.dragged = true;
      controller.selected = true;
      controller.error = true;

      await tester.pumpWidget(
        MaterialApp(
          home: WidgetStateScope(states: controller.value, child: Container()),
        ),
      );
      final scope = tester.element(find.byType(Container))
          .dependOnInheritedWidgetOfExactType<WidgetStateScope>();
      final foundStates = scope?.states;
      expect(foundStates, isNotNull);
      expect(foundStates!.contains(WidgetState.disabled), isTrue);
      expect(foundStates.contains(WidgetState.hovered), isTrue);
      expect(foundStates.contains(WidgetState.focused), isTrue);
      expect(foundStates.contains(WidgetState.pressed), isTrue);
      expect(foundStates.contains(WidgetState.dragged), isTrue);
      expect(foundStates.contains(WidgetState.selected), isTrue);
      expect(foundStates.contains(WidgetState.error), isTrue);
    });

    testWidgets('hasState returns if state is set', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WidgetStateScope(
            states: {WidgetState.disabled},
            child: Builder(
              builder: (context) {
                expect(
                  WidgetStateScope.hasState(context, WidgetState.disabled),
                  isTrue,
                );
                expect(
                  WidgetStateScope.hasState(context, WidgetState.hovered),
                  isFalse,
                );
                return Container();
              },
            ),
          ),
        ),
      );
    });

    test('updateShouldNotify returns true if value changed', () {
      final oldModel = WidgetStateScope(states: {}, child: Container());
      final newModel = WidgetStateScope(
        states: {WidgetState.disabled},
        child: Container(),
      );

      expect(newModel.updateShouldNotify(oldModel), isTrue);
    });

    test('updateShouldNotifyDependent returns if a dependency changed', () {
      final oldModel = WidgetStateScope(states: {}, child: Container());
      final newModel = WidgetStateScope(
        states: {WidgetState.disabled},
        child: Container(),
      );

      expect(
        newModel.updateShouldNotifyDependent(oldModel, {
          WidgetState.disabled,
        }),
        isTrue,
      );
      expect(
        newModel.updateShouldNotifyDependent(oldModel, {
          WidgetState.hovered,
        }),
        isFalse,
      );
    });
  });

  testWidgets('PressableState updates widgets correctly', (
    WidgetTester tester,
  ) async {
    bool hovered = false;
    bool pressed = false;

    bool focused = false;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final controller = WidgetStatesController();

            controller.disabled = false;
            controller.hovered = hovered;
            controller.pressed = pressed;
            controller.focused = focused;

            return Column(
              children: [
                ListenableBuilder(
                  listenable: controller,
                  builder: (BuildContext context, _) {
                    return Column(
                      children: [
                        Text(
                          'Disabled: ${controller.has(WidgetState.disabled)}',
                        ),
                        Text('Hovered: ${controller.has(WidgetState.hovered)}'),
                        Text('Pressed: ${controller.has(WidgetState.pressed)}'),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      hovered = !hovered;
                      pressed = !pressed;
                      focused = !focused;
                    });
                  },
                  child: const Text('Update State'),
                ),
              ],
            );
          },
        ),
      ),
    );

    expect(find.text('Disabled: false'), findsOneWidget);
    expect(find.text('Hovered: false'), findsOneWidget);
    expect(find.text('Pressed: false'), findsOneWidget);
    expect(find.text('Focused: false'), findsNothing);

    await tester.tap(find.text('Update State'));
    await tester.pump();

    expect(find.text('Disabled: false'), findsOneWidget);
    expect(find.text('Hovered: true'), findsOneWidget);
    expect(find.text('Pressed: true'), findsOneWidget);
    expect(find.text('Focused: true'), findsNothing);
  });

  testWidgets('ListenableBuilder updates all children on state change', (
    WidgetTester tester,
  ) async {
    final controller = WidgetStatesController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return WidgetStateScope(
                states: controller.value,
                child: PressableStateTestWidget(),
              );
            },
          ),
        ),
      ),
    );

    TrackRebuildWidgetState getDisabled() {
      return TrackRebuildWidget.findState(tester, 'disabled');
    }

    TrackRebuildWidgetState getHovered() {
      return TrackRebuildWidget.findState(tester, 'hovered');
    }

    TrackRebuildWidgetState getPressed() {
      return TrackRebuildWidget.findState(tester, 'pressed');
    }

    var disabled = getDisabled();
    var hovered = getHovered();
    var pressed = getPressed();

    expect(
      disabled.buildCount,
      1,
      reason: 'Disabled state should not have rebuilt',
    );
    expect(
      disabled.state,
      false,
      reason: 'Disabled state should initially be false',
    );
    expect(
      hovered.buildCount,
      1,
      reason: 'Hovered state should not have rebuilt',
    );
    expect(
      hovered.state,
      false,
      reason: 'Hovered state should initially be false',
    );
    expect(
      pressed.buildCount,
      1,
      reason: 'Pressed state should not have rebuilt',
    );
    expect(
      pressed.state,
      false,
      reason: 'Pressed state should initially be false',
    );

    controller.hovered = true;
    await tester.pump();

    disabled = getDisabled();
    hovered = getHovered();
    pressed = getPressed();

    // Note: In the simplified implementation, all children rebuild when any state changes
    // This is a trade-off for simpler code vs the old implementation's selective rebuilds
    expect(
      disabled.buildCount,
      2,
      reason: 'All children rebuild when controller notifies',
    );
    expect(
      disabled.state,
      false,
      reason: 'Disabled state should remain false when hovered changes',
    );
    expect(
      hovered.buildCount,
      2,
      reason: 'Hovered state should rebuild when set to true',
    );
    expect(
      hovered.state,
      true,
      reason: 'Hovered state should be true after being set',
    );
    expect(
      pressed.buildCount,
      2,
      reason: 'All children rebuild when controller notifies',
    );
    expect(
      pressed.state,
      false,
      reason: 'Pressed state should remain false when hovered changes',
    );

    controller.pressed = true;
    await tester.pump();

    disabled = getDisabled();
    hovered = getHovered();
    pressed = getPressed();

    expect(
      disabled.buildCount,
      3,
      reason: 'All children rebuild when controller notifies',
    );
    expect(
      disabled.state,
      false,
      reason: 'Disabled state should remain false when pressed changes',
    );
    expect(
      hovered.buildCount,
      3,
      reason: 'All children rebuild when controller notifies',
    );
    expect(
      hovered.state,
      true,
      reason: 'Hovered state should remain true when pressed changes',
    );
    expect(
      pressed.buildCount,
      3,
      reason: 'All children rebuild when controller notifies',
    );
    expect(
      pressed.state,
      true,
      reason: 'Pressed state should be true after being set',
    );

    // Note: No pump() here as no state was changed

    disabled = getDisabled();
    hovered = getHovered();
    pressed = getPressed();

    expect(
      disabled.buildCount,
      3,
      reason: 'Build count remains from previous state changes',
    );
    expect(
      disabled.state,
      false,
      reason: 'Disabled state should remain false when long pressed changes',
    );
    expect(
      hovered.buildCount,
      3,
      reason: 'Build count remains from previous state changes',
    );
    expect(
      hovered.state,
      true,
      reason: 'Hovered state should remain true when long pressed changes',
    );
    expect(
      pressed.buildCount,
      3,
      reason: 'Build count remains from previous state changes',
    );
    expect(
      pressed.state,
      true,
      reason: 'Pressed state should remain true when long pressed changes',
    );

    controller.disabled = true;

    await tester.pump();

    disabled = getDisabled();
    hovered = getHovered();
    pressed = getPressed();

    expect(
      disabled.buildCount,
      4,
      reason: 'All children rebuild when controller notifies',
    );
    expect(
      disabled.state,
      true,
      reason: 'Disabled state should be true after being set',
    );
    expect(
      hovered.buildCount,
      4,
      reason: 'All children rebuild when controller notifies',
    );
    expect(
      hovered.state,
      true,
      reason: 'Hovered state should remain true when disabled changes',
    );
    expect(
      pressed.buildCount,
      4,
      reason: 'All children rebuild when controller notifies',
    );
    expect(
      pressed.state,
      true,
      reason: 'Pressed state should remain true when disabled changes',
    );
  });
}

class PressableStateTestWidget extends StatefulWidget {
  const PressableStateTestWidget({super.key});

  @override
  State createState() => _PressableStateTestWidgetState();
}

class _PressableStateTestWidgetState extends State<PressableStateTestWidget> {
  bool Function(BuildContext) _widgetStateOf(WidgetState state) {
    return (BuildContext context) {
      return WidgetStateScope.hasState(context, state);
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: Column(
        children: [
          TrackRebuildWidget(
            text: 'disabled',
            stateBuilder: _widgetStateOf(WidgetState.disabled),
          ),
          TrackRebuildWidget(
            text: 'hovered',
            stateBuilder: _widgetStateOf(WidgetState.hovered),
          ),
          TrackRebuildWidget(
            text: 'pressed',
            stateBuilder: _widgetStateOf(WidgetState.pressed),
          ),
        ],
      ),
    );
  }
}
