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
      final style = BoxStyler()
          .color(Colors.blue)
          .width(100)
          .height(100)
          .onHovered(
            BoxStyler()
                .color(Colors.red)
                .width(100)
                .height(100)
                .alignment(Alignment.center),
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
                  currentColor = (spec.decoration as BoxDecoration?)?.color;
                  return Container(
                    key: const Key('test_container'),
                    width: spec.constraints?.minWidth,
                    height: spec.constraints?.minHeight,
                    decoration: spec.decoration,
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
                style: BoxStyler()
                    .color(Colors.green)
                    .width(150)
                    .height(150)
                    .onHovered(BoxStyler().color(Colors.orange)),
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

    testWidgets(
      'homepage hover card example animates scale without a base transform',
      (tester) async {
        // Mirrors the homepage showcase pattern:
        // BoxStyler().animate(...).onHovered(BoxStyler().scale(1.02))
        final style = BoxStyler()
            .width(260)
            .height(120)
            .paddingAll(20)
            .borderRounded(18)
            .color(Colors.indigo.shade400)
            .animate(.easeInOut(220.ms))
            .onHovered(BoxStyler().color(Colors.indigo.shade500).scale(1.02));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Box(key: const Key('hover_card'), style: style),
              ),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);

        await gesture.moveTo(
          tester.getCenter(find.byKey(const Key('hover_card'))),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 110));

        expect(tester.takeException(), isNull);

        await gesture.moveTo(const Offset(-100, -100));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 110));

        expect(tester.takeException(), isNull);

        await gesture.removePointer();
      },
    );

    testWidgets(
      'hover with animate(reverse:) uses forward on enter and reverse on exit',
      (tester) async {
        // Forward enter is slow (300ms), reverse exit is fast (60ms). We pump
        // partway through each to assert the correct timing config drives the
        // transition without throwing.
        final style = BoxStyler()
            .color(Colors.blue)
            .width(100)
            .height(100)
            .animate(.linear(300.ms))
            .onHovered(
              BoxStyler()
                  .color(Colors.red)
                  .scale(1.02)
                  .animate(.linear(300.ms), reverse: .linear(60.ms)),
            );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Box(key: const Key('reverse_card'), style: style),
              ),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);

        // Enter: forward (300ms) drives. Settle the animation fully.
        await gesture.moveTo(
          tester.getCenter(find.byKey(const Key('reverse_card'))),
        );
        await tester.pump();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Exit: reverse (60ms) drives. Pump less than forward duration to make
        // sure the fast exit config completed the transition.
        await gesture.moveTo(const Offset(-100, -100));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 80));
        expect(tester.takeException(), isNull);

        await tester.pumpAndSettle();
        await gesture.removePointer();
      },
    );

    testWidgets('inherited base reversible config does not break hover enter', (
      tester,
    ) async {
      // The base owns a reversible config and the hover style inherits it.
      // Enter should use the forward config rather than the reverse one.
      final style = BoxStyler()
          .color(Colors.blue)
          .width(100)
          .height(100)
          .animate(.linear(120.ms), reverse: .linear(60.ms))
          .onHovered(BoxStyler().color(Colors.red).scale(1.02));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Box(key: const Key('inherited_card'), style: style),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      await gesture.moveTo(
        tester.getCenter(find.byKey(const Key('inherited_card'))),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 70));
      expect(tester.takeException(), isNull);

      await tester.pumpAndSettle();
      await gesture.moveTo(const Offset(-100, -100));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await gesture.removePointer();
    });
  });
}
