import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('StyleBuilder hover functionality', () {
    Future<void> expectHoverColors(
      WidgetTester tester, {
      required BoxStyler style,
      required Color initial,
      required Color hovered,
      Brightness platformBrightness = Brightness.light,
    }) async {
      Color? currentColor;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              size: const Size(800, 600),
              platformBrightness: platformBrightness,
            ),
            child: Center(
              child: StyleBuilder<BoxSpec>(
                style: style,
                builder: (context, spec) {
                  currentColor = (spec.decoration as BoxDecoration?)?.color;

                  return Container(
                    key: const Key('nested-hover-target'),
                    constraints: spec.constraints,
                    decoration: spec.decoration,
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(currentColor, initial, reason: 'before hover');

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(
        tester.getCenter(find.byKey(const Key('nested-hover-target'))),
      );
      await tester.pump();

      expect(currentColor, hovered, reason: 'while hovered');

      // Leaving must restore the original style too — a variant that latches on
      // is just as broken as one that never activates.
      await gesture.moveTo(Offset.zero);
      await tester.pump();

      expect(currentColor, initial, reason: 'after hover exit');

      await gesture.removePointer();
    }

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

    group('nested widget-state dependency discovery', () {
      testWidgets('tracks a negated hover variant', (tester) async {
        final style = BoxStyler()
            .size(100, 100)
            .color(Colors.blue)
            .onNot(
              ContextVariant.widgetState(WidgetState.hovered),
              BoxStyler().color(Colors.red),
            );

        await expectHoverColors(
          tester,
          style: style,
          initial: Colors.red,
          hovered: Colors.blue,
        );
      });

      testWidgets('tracks hover nested under a breakpoint', (tester) async {
        final style = BoxStyler()
            .size(100, 100)
            .color(Colors.blue)
            .onBreakpoint(
              const Breakpoint.minWidth(0),
              BoxStyler().onHovered(BoxStyler().color(Colors.red)),
            );

        await expectHoverColors(
          tester,
          style: style,
          initial: Colors.blue,
          hovered: Colors.red,
        );
      });

      testWidgets('tracks hover nested under dark mode', (tester) async {
        final style = BoxStyler()
            .size(100, 100)
            .color(Colors.blue)
            .onDark(BoxStyler().onHovered(BoxStyler().color(Colors.red)));

        await expectHoverColors(
          tester,
          style: style,
          initial: Colors.blue,
          hovered: Colors.red,
          platformBrightness: Brightness.dark,
        );
      });

      testWidgets('tracks hover when breakpoint nesting is reversed', (
        tester,
      ) async {
        final style = BoxStyler()
            .size(100, 100)
            .color(Colors.blue)
            .onHovered(
              BoxStyler().onBreakpoint(
                const Breakpoint.minWidth(0),
                BoxStyler().color(Colors.red),
              ),
            );

        await expectHoverColors(
          tester,
          style: style,
          initial: Colors.blue,
          hovered: Colors.red,
        );
      });

      testWidgets('tracks a nested pressed variant', (tester) async {
        Color? currentColor;

        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: StyleBuilder<BoxSpec>(
                style: BoxStyler()
                    .size(100, 100)
                    .color(Colors.blue)
                    .onBreakpoint(
                      const Breakpoint.minWidth(0),
                      BoxStyler().onPressed(BoxStyler().color(Colors.red)),
                    ),
                builder: (context, spec) {
                  currentColor = (spec.decoration as BoxDecoration?)?.color;

                  return Container(
                    key: const Key('nested-press-target'),
                    constraints: spec.constraints,
                    decoration: spec.decoration,
                  );
                },
              ),
            ),
          ),
        );

        expect(currentColor, Colors.blue, reason: 'before press');

        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(const Key('nested-press-target'))),
        );
        await tester.pump();

        expect(currentColor, Colors.red, reason: 'while pressed');

        await gesture.up();
        await tester.pump();

        expect(currentColor, Colors.blue, reason: 'after release');
      });

      test('discovers the disabled dependency behind onEnabled', () {
        // onEnabled is the public path that produces NotVariant(WidgetState),
        // so it is the case users actually hit.
        final style = BoxStyler()
            .color(Colors.blue)
            .onEnabled(BoxStyler().color(Colors.red));

        expect(style.widgetStates, {WidgetState.disabled});
      });

      test('ignores hover under an un-applied named variant', () {
        const primary = NamedVariant('primary');
        final style = BoxStyler().variant(
          primary,
          BoxStyler().onHovered(BoxStyler()),
        );

        expect(style.widgetStates, isEmpty);
        expect(style.applyVariants([primary]).widgetStates, {
          WidgetState.hovered,
        });
      });

      test('handles cyclic nested variant styles by identity', () {
        final variants = <VariantStyle<BoxSpec>>[];
        final cyclicStyle = BoxStyler(variants: variants);
        variants.add(
          VariantStyle(ContextVariant.brightness(Brightness.dark), cyclicStyle),
        );
        variants.add(
          VariantStyle(
            ContextVariant.widgetState(WidgetState.hovered),
            BoxStyler(),
          ),
        );
        final rootStyle = BoxStyler().onDark(cyclicStyle);

        expect(rootStyle.widgetStates, {WidgetState.hovered});
      });
    });

    group('interaction detector mounting', () {
      // The detector wraps its child in an opaque Listener, so mounting it
      // swallows pointer events that would otherwise fall through. It only
      // earns that cost for states it can actually drive from pointer input.
      Future<bool> reachesWidgetBeneath(
        WidgetTester tester,
        BoxStyler style,
      ) async {
        var tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => tapped = true,
                    child: const SizedBox.expand(),
                  ),
                ),
                Center(
                  child: Box(
                    key: const Key('overlay-box'),
                    style: style,
                    child: const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        );

        await tester.tapAt(
          tester.getCenter(find.byKey(const Key('overlay-box'))),
        );
        await tester.pump();

        return tapped;
      }

      // Every style below paints nothing, so the box itself never absorbs the
      // hit and any difference comes from the detector alone.
      testWidgets('a style with no widget states stays transparent to taps', (
        tester,
      ) async {
        expect(
          await reachesWidgetBeneath(tester, BoxStyler().size(100, 100)),
          isTrue,
        );
      });

      testWidgets('onEnabled alone stays transparent to taps', (tester) async {
        // disabled can only come from a controller or an ancestor scope, both
        // of which bypass the detector, so mounting it would be pure cost.
        expect(
          await reachesWidgetBeneath(
            tester,
            BoxStyler().size(100, 100).onEnabled(BoxStyler().size(100, 100)),
          ),
          isTrue,
        );
      });

      testWidgets('un-applied named-variant hover stays transparent to taps', (
        tester,
      ) async {
        const primary = NamedVariant('primary');

        expect(
          await reachesWidgetBeneath(
            tester,
            BoxStyler()
                .size(100, 100)
                .variant(
                  primary,
                  BoxStyler().onHovered(BoxStyler().size(100, 100)),
                ),
          ),
          isTrue,
        );
      });

      testWidgets('a nested hover variant does mount the detector', (
        tester,
      ) async {
        expect(
          await reachesWidgetBeneath(
            tester,
            BoxStyler()
                .size(100, 100)
                .onBreakpoint(
                  const Breakpoint.minWidth(0),
                  BoxStyler().onHovered(BoxStyler().size(100, 100)),
                ),
          ),
          isFalse,
        );
      });

      testWidgets('an ancestor does not hijack a descendant hover scope', (
        tester,
      ) async {
        // A descendant reuses an ancestor's state scope instead of opening its
        // own, so an ancestor that mounts a detector it cannot use would make
        // the descendant hover on the *ancestor's* bounds.
        Color? innerColor;

        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: Box(
                key: const Key('outer'),
                style: BoxStyler()
                    .size(400, 400)
                    .onDisabled(BoxStyler().color(Colors.grey)),
                child: Center(
                  child: StyleBuilder<BoxSpec>(
                    style: BoxStyler()
                        .size(50, 50)
                        .color(Colors.blue)
                        .onHovered(BoxStyler().color(Colors.red)),
                    builder: (context, spec) {
                      innerColor = (spec.decoration as BoxDecoration?)?.color;

                      return Container(
                        key: const Key('inner'),
                        constraints: spec.constraints,
                        decoration: spec.decoration,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);

        // Inside the outer box, far outside the inner one.
        await gesture.moveTo(
          tester.getCenter(find.byKey(const Key('outer'))) +
              const Offset(150, 150),
        );
        await tester.pump();

        expect(innerColor, Colors.blue, reason: 'hovering the ancestor only');

        await gesture.moveTo(tester.getCenter(find.byKey(const Key('inner'))));
        await tester.pump();

        expect(innerColor, Colors.red, reason: 'hovering the descendant');

        await gesture.removePointer();
      });

      testWidgets('scope lookup ignores unrelated state changes', (
        tester,
      ) async {
        final controller = WidgetStatesController();
        addTearDown(controller.dispose);
        var builds = 0;
        final child = StyleBuilder<BoxSpec>(
          style: BoxStyler().size(50, 50),
          builder: (context, spec) {
            builds++;

            return Container(constraints: spec.constraints);
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: ListenableBuilder(
              listenable: controller,
              builder: (context, _) =>
                  WidgetStateProvider(states: controller.value, child: child),
            ),
          ),
        );
        expect(builds, 1);

        controller.selected = true;
        await tester.pump();

        expect(
          builds,
          1,
          reason: 'checking for an ancestor scope must not subscribe to it',
        );
      });
    });
  });
}
