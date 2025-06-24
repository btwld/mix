import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mix/mix.dart';
import 'package:remix/src/helpers/mix_controller_mixin.dart';

Future<void> pumpRxWidget(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
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
    await pumpRxWidget(tester, widget);

    final gesture = await tester.startGesture(
      tester.getCenter(find.byWidget(widget)),
    );

    final state = tester.state(find.byWidget(widget)) as MixControllerMixin;

    expect(state.mixController.has(WidgetState.pressed), shouldExpectPress);
    await gesture.up();
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
    await pumpRxWidget(tester, widget);

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(tester.getCenter(find.byWidget(widget)));

    final state = tester.state(find.byWidget(widget)) as MixControllerMixin;

    expect(state.mixController.has(WidgetState.hovered), shouldExpectHover);

    await gesture.removePointer();

    expect(state.mixController.has(WidgetState.hovered), false);
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
    await pumpRxWidget(tester, widget);

    focusNode.requestFocus();
    await tester.pump();

    final state = tester.state(find.byWidget(widget)) as MixControllerMixin;

    expect(state.mixController.has(WidgetState.focused), shouldExpectFocus);

    focusNode.unfocus();
    await tester.pump();

    expect(state.mixController.has(WidgetState.focused), false);
  });
}
