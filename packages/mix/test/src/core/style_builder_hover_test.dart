import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('StyleBuilder hover functionality', () {
    testWidgets('hover variant changes style when mouse enters and exits', (
      tester,
    ) async {
      // Create a style with blue background that changes to red on hover
      final style = BoxSpecAttribute()
          .color(Colors.blue)
          .width(100)
          .height(100)
          .onHovered(
            BoxSpecAttribute().color(Colors.red).width(100).height(100),
          );

      Color? currentColor;

      // Verify the style has widget states
      expect(
        style.widgetStates.isNotEmpty,
        isTrue,
        reason: 'Style should have widget states for hover',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StyleBuilder<BoxSpec>(
                style: style,
                builder: (context, spec) {
                  currentColor = (spec?.decoration as BoxDecoration?)?.color;
                  return Container(
                    key: const Key('test_container'),
                    width: spec?.constraints?.minWidth,
                    height: spec?.constraints?.minHeight,
                    decoration: spec?.decoration,
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Initially should be blue (not hovered)
      expect(currentColor, Colors.blue);

      // Create a mouse pointer and hover over the widget
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(
        tester.getCenter(find.byKey(const Key('test_container'))),
      );
      await tester.pump();

      // Should now be red (hovered)
      expect(currentColor, Colors.red);

      // Move mouse away
      await gesture.moveTo(const Offset(-100, -100));
      await tester.pump();

      // Should be back to blue (not hovered)
      expect(currentColor, Colors.blue);

      await gesture.removePointer();
    });

    testWidgets('Box widget with onHover changes style correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Box(
                key: const Key('test_box'),
                style: BoxSpecAttribute()
                    .color(Colors.green)
                    .width(150)
                    .height(150)
                    .onHovered(BoxSpecAttribute().color(Colors.orange)),
                child: const Text('Hover me'),
              ),
            ),
          ),
        ),
      );

      // Find the container inside the Box widget
      final containerFinder = find.descendant(
        of: find.byKey(const Key('test_box')),
        matching: find.byType(Container),
      );

      // Get initial color
      Container container = tester.widget<Container>(containerFinder.first);
      BoxDecoration? decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.green);

      // Create a mouse pointer and hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byKey(const Key('test_box'))));
      await tester.pump();
      await tester.pump();

      // Check color after hover
      container = tester.widget<Container>(containerFinder.first);
      decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.orange);

      // Move mouse away
      await gesture.moveTo(const Offset(-100, -100));
      await tester.pump();
      await tester.pump();

      // Check color after mouse leaves
      container = tester.widget<Container>(containerFinder.first);
      decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.green);

      await gesture.removePointer();
    });
  });
}
