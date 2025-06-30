import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mix/mix.dart';
import 'package:remix/src/helpers/mix_controller_mixin.dart';

extension WidgetTesterExt on WidgetTester {
  Future<void> pumpRxWidget(Widget child) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }
}

enum FindPosition {
  first,
  last,
}

T findWidgetInFlex<T extends Widget>(
  WidgetTester tester, {
  required Type parentType,
  required Type widgetType,
  required FindPosition findPosition,
}) {
  final flexFinder = find.descendant(
    of: find.byType(parentType),
    matching: find.byWidgetPredicate((widget) => widget is Flex),
  );
  final flexWidget = tester.widget<Flex>(flexFinder);
  final targetChild = findPosition == FindPosition.last
      ? flexWidget.children.last
      : flexWidget.children.first;

  final widgetFinder = find.descendant(
    of: find.byWidget(targetChild),
    matching: find.byWidgetPredicate((widget) => widget is T),
  );

  return tester.widget<T>(widgetFinder);
}

class ValueHolder<T> {
  T value;

  ValueHolder({required this.value});
}

@isTest
void testTapWidget(
  String description,
  Widget Function(ValueHolder<bool> value) child, {
  required bool shouldExpectPress,
}) {
  testWidgets(description, (WidgetTester tester) async {
    final valueHolder = ValueHolder<bool>(value: false);
    final widget = child(valueHolder);
    await tester.pumpRxWidget(widget);

    final gesture = await tester.startGesture(
      tester.getCenter(find.byWidget(widget)),
    );

    await tester.pumpAndSettle();

    final state = tester.state(find.byWidget(widget)) as MixControllerMixin;
    expect(state.mixController.has(WidgetState.pressed), shouldExpectPress);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(valueHolder.value, shouldExpectPress);
  });
}

@isTest
void testHoverWidget(
  String description,
  Widget Function() child, {
  required bool shouldExpectHover,
}) {
  testWidgets(description, (WidgetTester tester) async {
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;

    final widget = child();
    await tester.pumpRxWidget(widget);

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(tester.getCenter(find.byWidget(widget)));

    await tester.pumpAndSettle();
    final state =
        tester.widget<MixWidgetStateModel>(find.byType(MixWidgetStateModel));

    expect(state.hovered, shouldExpectHover);

    await gesture.removePointer();
    await tester.pumpAndSettle();

    final stateAfter =
        tester.widget<MixWidgetStateModel>(find.byType(MixWidgetStateModel));
    expect(stateAfter.hovered, false);
  });
}

@isTest
void testFocusWidget(
  String description,
  Widget Function(FocusNode focusNode) childBuilder, {
  required bool shouldExpectFocus,
}) {
  testWidgets(description, (WidgetTester tester) async {
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    final focusNode = FocusNode();

    final widget = childBuilder(focusNode);
    await tester.pumpRxWidget(widget);

    focusNode.requestFocus();
    await tester.pumpAndSettle();

    final state =
        tester.widget<MixWidgetStateModel>(find.byType(MixWidgetStateModel));

    expect(state.focused, shouldExpectFocus);

    focusNode.unfocus();
    await tester.pumpAndSettle();

    final stateAfter =
        tester.widget<MixWidgetStateModel>(find.byType(MixWidgetStateModel));

    expect(stateAfter.focused, false);
  });
}

@isTest
void testSelectStateWidget(
  String description,
  Widget Function(ValueNotifier<bool> holder) childBuilder, {
  required bool shouldExpectSelect,
}) {
  testWidgets(description, (WidgetTester tester) async {
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;

    final holder = ValueNotifier<bool>(false);
    late Widget widget;
    await tester.pumpRxWidget(
      ListenableBuilder(
        listenable: holder,
        builder: (context, child) {
          widget = childBuilder(holder);
          return widget;
        },
      ),
    );

    await tester.tap(find.byWidget(widget));
    await tester.pumpAndSettle();

    final state =
        tester.widget<MixWidgetStateModel>(find.byType(MixWidgetStateModel));

    expect(state.selected, shouldExpectSelect);
    expect(holder.value, shouldExpectSelect);
  });
}
