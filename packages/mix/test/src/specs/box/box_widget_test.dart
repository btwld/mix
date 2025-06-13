import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/override_modifiers_order.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  testWidgets('Box', (WidgetTester tester) async {
    final paddingAttr = $box.padding(10);
    final marginAttr = $box.margin(15);
    final alignmentAttr = $box.alignment.center();
    final clipAttr = $box.clipBehavior.hardEdge();

    final boxDecorationAttr = $box.decoration(
      border: Border.all(color: Colors.red, width: 1, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(10),
      color: Colors.red,
    );

    await tester.pumpStyledWidget(
      Box(
        style: Style(
          paddingAttr,
          marginAttr,
          alignmentAttr,
          clipAttr,
          boxDecorationAttr,
        ),
      ),
    );

    final containerFinder = find.byType(Container);
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
  });

  testWidgets(
    'Box should apply modifiers only once',
    (tester) async {
      await tester.pumpMaterialApp(
        Box(
          style: Style(
            $box.height(100),
            $box.width(100),
            $with.align(),
          ),
          child: const Box(),
        ),
      );

      expect(find.byType(Align), findsOneWidget);
    },
  );

  testWidgets('Box handles onEnd', (WidgetTester tester) async {
    var countPressTime = 0;
    var countOnEnd = 0;

    await tester.pumpWidget(
      PressableBox(
        onPress: () {
          countPressTime++;
        },
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
        child: const Box(),
      ),
    );

    final containerFinder = find.byType(Pressable);
    await tester.tap(containerFinder);

    await tester.pumpAndSettle();

    expect(countPressTime, 1);
    expect(countOnEnd, 2);
  });

  testWidgets('BoxSpec properties should match Container properties',
      (WidgetTester tester) async {
    final boxSpec = BoxSpec(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(minWidth: 100, maxHeight: 200),
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
    );

    const containerKey = Key('container');
    final container = Container(
      key: containerKey,
      alignment: boxSpec.alignment,
      padding: boxSpec.padding,
      margin: boxSpec.margin,
      constraints: boxSpec.constraints,
      decoration: boxSpec.decoration,
      foregroundDecoration: boxSpec.foregroundDecoration,
      transform: boxSpec.transform,
      transformAlignment: boxSpec.transformAlignment,
      clipBehavior: boxSpec.clipBehavior ?? Clip.none,
      width: boxSpec.width,
      height: boxSpec.height,
    );

    const boxKey = Key('box');
    final box = BoxSpecWidget(key: boxKey, spec: boxSpec);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              box,
              container,
            ],
          ),
        ),
      ),
    );

    final containerFinder = find.byKey(containerKey);
    expect(containerFinder, findsOneWidget);

    final boxFinder = find.byKey(boxKey);
    expect(boxFinder, findsOneWidget);

    final containerWidget = tester.widget<Container>(containerFinder);
    final boxWidget = tester.widget<Container>(find.descendant(
      of: boxFinder,
      matching: find.byType(Container),
    ));

    expect(containerWidget.alignment, boxWidget.alignment);
    expect(containerWidget.padding, boxWidget.padding);
    expect(containerWidget.margin, boxWidget.margin);
    expect(containerWidget.constraints, boxWidget.constraints);
    expect(containerWidget.decoration, boxWidget.decoration);
    expect(
        containerWidget.foregroundDecoration, boxWidget.foregroundDecoration);
    expect(containerWidget.transform, boxWidget.transform);
    expect(containerWidget.transformAlignment, boxWidget.transformAlignment);
    expect(containerWidget.clipBehavior, boxWidget.clipBehavior);
    expect(containerWidget.constraints, boxWidget.constraints);
  });

  testWidgets('AnimatedBoxSpecWidget should animate spec changes',
      (WidgetTester tester) async {
    final boxSpec1 = BoxSpec(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(minWidth: 100, maxHeight: 200),
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
      width: null,
      height: null,
    );

    final boxSpec2 = BoxSpec(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 16),
      constraints: const BoxConstraints(minWidth: 200, maxHeight: 300),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: Colors.yellow, width: 4),
      ),
      transform: Matrix4.rotationZ(0.3),
      transformAlignment: Alignment.bottomRight,
      clipBehavior: Clip.hardEdge,
      width: null,
      height: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: AnimatedBoxSpecWidget(
          spec: boxSpec1,
          duration: const Duration(milliseconds: 500),
        ),
      ),
    );

    expect(find.byType(AnimatedBoxSpecWidget), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: AnimatedBoxSpecWidget(
          spec: boxSpec2,
          duration: const Duration(milliseconds: 500),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 250));

    final boxWidget = tester.widget<Container>(find.byType(Container));
    expect(boxWidget.alignment, isNot(equals(boxSpec1.alignment)));
    expect(boxWidget.alignment, isNot(equals(boxSpec2.alignment)));
    expect(boxWidget.padding, isNot(equals(boxSpec1.padding)));
    expect(boxWidget.padding, isNot(equals(boxSpec2.padding)));
    expect(boxWidget.margin, isNot(equals(boxSpec1.margin)));
    expect(boxWidget.margin, isNot(equals(boxSpec2.margin)));
    expect(boxWidget.constraints, isNot(equals(boxSpec1.constraints)));
    expect(boxWidget.constraints, isNot(equals(boxSpec2.constraints)));
    expect(boxWidget.decoration, isNot(equals(boxSpec1.decoration)));
    expect(boxWidget.decoration, isNot(equals(boxSpec2.decoration)));
    expect(boxWidget.foregroundDecoration,
        isNot(equals(boxSpec1.foregroundDecoration)));
    expect(boxWidget.foregroundDecoration,
        isNot(equals(boxSpec2.foregroundDecoration)));
    expect(boxWidget.transform, isNot(equals(boxSpec1.transform)));
    expect(boxWidget.transform, isNot(equals(boxSpec2.transform)));
    expect(boxWidget.transformAlignment,
        isNot(equals(boxSpec1.transformAlignment)));
    expect(boxWidget.transformAlignment,
        isNot(equals(boxSpec2.transformAlignment)));
    expect(boxWidget.clipBehavior, isNot(equals(boxSpec1.clipBehavior)));
    expect(boxWidget.clipBehavior, equals(boxSpec2.clipBehavior));

    await tester.pumpAndSettle();

    final animatedBoxWidget = tester.widget<Container>(find.byType(Container));
    expect(animatedBoxWidget.alignment, boxSpec2.alignment);
    expect(animatedBoxWidget.padding, boxSpec2.padding);
    expect(animatedBoxWidget.margin, boxSpec2.margin);
    expect(animatedBoxWidget.constraints, boxSpec2.constraints);
    expect(animatedBoxWidget.decoration, boxSpec2.decoration);
    expect(
        animatedBoxWidget.foregroundDecoration, boxSpec2.foregroundDecoration);
    expect(animatedBoxWidget.transform, boxSpec2.transform);
    expect(animatedBoxWidget.transformAlignment, boxSpec2.transformAlignment);
    expect(animatedBoxWidget.clipBehavior, boxSpec2.clipBehavior);
  });

  testWidgets('AnimatedBoxSpecWidget should apply child widget',
      (WidgetTester tester) async {
    const childKey = Key('child');
    const childWidget = Text('Child', key: childKey);

    await tester.pumpWidget(
      const MaterialApp(
        home: AnimatedBoxSpecWidget(
          spec: BoxSpec(),
          duration: Duration(milliseconds: 500),
          child: childWidget,
        ),
      ),
    );

    expect(find.byKey(childKey), findsOneWidget);
  });

  testWidgets(
    'Renders modifiers in the correct order with many overrides',
    (tester) async {
      testOverrideModifiersOrder(
        tester,
        widgetBuilder: (style, orderOfModifiers) {
          return Box(
            style: style,
            orderOfModifiers: orderOfModifiers,
          );
        },
      );
    },
  );
}
