import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/override_modifiers_order.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  testWidgets('FlexBox', (WidgetTester tester) async {
    final paddingAttr = $box.padding(10);
    final marginAttr = $box.margin(15);
    final alignmentAttr = $box.alignment.center();
    final clipAttr = $box.clipBehavior.hardEdge();
    final mainAxisAttr = $flex.mainAxisAlignment.center();
    final crossAxisAttr = $flex.crossAxisAlignment.center();

    final boxDecorationAttr = $box.decoration(
      border: Border.all(color: Colors.red, width: 1, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(10),
      color: Colors.red,
    );

    await tester.pumpStyledWidget(
      FlexBox(
        style: Style(
          paddingAttr,
          marginAttr,
          alignmentAttr,
          clipAttr,
          boxDecorationAttr,
          mainAxisAttr,
          crossAxisAttr,
        ),
        direction: Axis.horizontal,
        children: const [],
      ),
    );

    final flexFinder = find.byType(Flex);
    final containerFinder = find.byType(Container);
    final flexWidget = tester.widget<Flex>(flexFinder);
    final containerWidget = tester.widget<Container>(containerFinder);

    expect(containerWidget.padding, const EdgeInsets.all(10));
    expect(containerWidget.margin, const EdgeInsets.all(15));
    expect(containerWidget.alignment, Alignment.center);
    expect(containerWidget.clipBehavior, Clip.hardEdge);
    expect(
      containerWidget.decoration,
      BoxDecoration(
        color: Colors.red,
        border:
            Border.all(color: Colors.red, width: 1, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10),
      ),
    );
    expect(flexWidget.mainAxisAlignment, MainAxisAlignment.center);
    expect(flexWidget.crossAxisAlignment, CrossAxisAlignment.center);
  });

  testWidgets(
    'FlexBox should apply modifiers only once',
    (tester) async {
      await tester.pumpMaterialApp(
        FlexBox(
          style: Style(
            $box.height(100),
            $box.width(100),
            $with.align(),
          ),
          direction: Axis.horizontal,
          children: const [
            FlexBox(
              direction: Axis.horizontal,
              children: [],
            ),
          ],
        ),
      );

      expect(find.byType(Align), findsOneWidget);
    },
  );

  testWidgets('FlexBox handles onEnd', (WidgetTester tester) async {
    var countPressTime = 0;
    var countOnEnd = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: PressableBox(
          onPress: () {
            countPressTime++;
          },
          child: FlexBox(
            style: Style(
              $flexbox.height(50),
              $flexbox.width(50),
              $flexbox.wrap.transform.scale(1),
              $on.press(
                $flexbox.wrap.transform.scale(1.5),
              ),
            ).animate(
              onEnd: () {
                countOnEnd++;
              },
            ),
            direction: Axis.horizontal,
            children: const [Box()],
          ),
        ),
      ),
    );

    final pressableFinder = find.byType(Pressable);
    await tester.tap(pressableFinder);

    await tester.pumpAndSettle();

    expect(countPressTime, 1);
    expect(countOnEnd, 2);
  });

  testWidgets('FlexBox handles onEnd #2', (WidgetTester tester) async {
    var countPressTime = 0;
    var countOnEnd = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: PressableBox(
          onPress: () {
            countPressTime++;
          },
          child: FlexBox(
            style: Style(
              $box.height(50),
              $box.width(50),
              $box.wrap.transform.scale(1),
              $on.press(
                $box.wrap.transform.scale(1.5),
              ),
            ).animate(
              onEnd: () {
                countOnEnd++;
              },
            ),
            direction: Axis.horizontal,
            children: const [Box()],
          ),
        ),
      ),
    );

    final pressableFinder = find.byType(Pressable);
    await tester.tap(pressableFinder);

    await tester.pumpAndSettle();

    expect(countPressTime, 1);
    expect(countOnEnd, 2);
  });

  testWidgets(
      'FlexBoxSpec properties should match Flex and Container properties',
      (WidgetTester tester) async {
    final flexBoxSpec = FlexBoxSpec(
      box: BoxSpec(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
        ),
        transform: Matrix4.rotationZ(0.1),
        transformAlignment: Alignment.topLeft,
        clipBehavior: Clip.antiAlias,
        width: 150,
        height: 100,
      ),
      flex: const FlexSpec(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        direction: Axis.horizontal,
        verticalDirection: VerticalDirection.down,
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic,
      ),
    );

    const flexBoxKey = Key('flexbox');
    final flexBox = FlexBoxSpecWidget(
      key: flexBoxKey,
      spec: flexBoxSpec,
      direction: Axis.horizontal,
      children: const [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: flexBox,
        ),
      ),
    );

    final flexBoxFinder = find.byKey(flexBoxKey);
    expect(flexBoxFinder, findsOneWidget);

    final containerWidget = tester.widget<Container>(find.descendant(
      of: flexBoxFinder,
      matching: find.byType(Container),
    ));

    final flexWidget = tester.widget<Flex>(find.descendant(
      of: flexBoxFinder,
      matching: find.byType(Flex),
    ));

    expect(containerWidget.alignment, flexBoxSpec.box.alignment);
    expect(containerWidget.padding, flexBoxSpec.box.padding);
    expect(containerWidget.margin, flexBoxSpec.box.margin);
    expect(containerWidget.decoration, flexBoxSpec.box.decoration);
    expect(containerWidget.foregroundDecoration,
        flexBoxSpec.box.foregroundDecoration);
    expect(containerWidget.transform, flexBoxSpec.box.transform);
    expect(
        containerWidget.transformAlignment, flexBoxSpec.box.transformAlignment);
    expect(containerWidget.clipBehavior, flexBoxSpec.box.clipBehavior);

    expect(flexWidget.mainAxisAlignment, flexBoxSpec.flex.mainAxisAlignment);
    expect(flexWidget.crossAxisAlignment, flexBoxSpec.flex.crossAxisAlignment);
    expect(flexWidget.mainAxisSize, flexBoxSpec.flex.mainAxisSize);
    expect(flexWidget.direction, flexBoxSpec.flex.direction);
    expect(flexWidget.verticalDirection, flexBoxSpec.flex.verticalDirection);
    expect(flexWidget.textDirection, flexBoxSpec.flex.textDirection);
    expect(flexWidget.textBaseline, flexBoxSpec.flex.textBaseline);
  });

  testWidgets(
    'Renders modifiers in the correct order with many overrides',
    (tester) async {
      testOverrideModifiersOrder(
        tester,
        widgetBuilder: (style, orderOfModifiers) {
          return FlexBox(
            style: style,
            orderOfModifiers: orderOfModifiers,
            direction: Axis.horizontal,
            children: const [],
          );
        },
      );
    },
  );
}
