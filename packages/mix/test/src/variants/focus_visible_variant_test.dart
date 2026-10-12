import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('FocusVisibleVariant', () {
    late FocusHighlightStrategy previousStrategy;

    setUp(() {
      previousStrategy = FocusManager.instance.highlightStrategy;
    });

    tearDown(() {
      FocusManager.instance.highlightStrategy = previousStrategy;
    });

    Color? colorOf(WidgetTester tester) {
      final container = tester.widget<Container>(
        find.byKey(const Key('target')),
      );

      return (container.decoration as BoxDecoration?)?.color;
    }

    Widget buildStyle(BoxStyler style, WidgetStatesController controller) {
      return MaterialApp(
        home: StyleBuilder<BoxSpec>(
          controller: controller,
          style: style,
          builder: (context, spec) =>
              Container(key: const Key('target'), decoration: spec.decoration),
        ),
      );
    }

    Widget buildWithController(WidgetStatesController controller) {
      return buildStyle(
        BoxStyler()
            .size(50, 50)
            .color(Colors.blue)
            .onFocusVisible(BoxStyler().color(Colors.red)),
        controller,
      );
    }

    testWidgets('tracks highlight mode without a Pressable ancestor', (
      tester,
    ) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTouch;
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);
      controller.focused = true;

      await tester.pumpWidget(buildWithController(controller));
      expect(colorOf(tester), Colors.blue);

      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      await tester.pump();
      expect(colorOf(tester), Colors.red);

      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTouch;
      await tester.pump();
      expect(colorOf(tester), Colors.blue);
    });

    testWidgets('needs focused state, not just traditional highlighting', (
      tester,
    ) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(buildWithController(controller));
      expect(colorOf(tester), Colors.blue);

      controller.focused = true;
      await tester.pump();
      expect(colorOf(tester), Colors.red);
    });

    testWidgets('a forced state override wins over the input modality', (
      tester,
    ) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTouch;

      await tester.pumpWidget(
        MaterialApp(
          home: WidgetStateStyleOverride(
            states: const {WidgetState.focused},
            child: Box(
              key: const Key('target'),
              style: BoxStyler()
                  .size(50, 50)
                  .color(Colors.blue)
                  .onFocusVisible(BoxStyler().color(Colors.red)),
            ),
          ),
        ),
      );

      expect(
        (tester
                    .widget<Container>(
                      find.descendant(
                        of: find.byKey(const Key('target')),
                        matching: find.byType(Container),
                      ),
                    )
                    .decoration
                as BoxDecoration?)
            ?.color,
        Colors.red,
      );
    });

    group('merge priority', () {
      final selected = ContextVariant.widgetState(WidgetState.selected);

      WidgetStatesController selectedAndFocusVisible() {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        final controller = WidgetStatesController();
        addTearDown(controller.dispose);
        controller.selected = true;
        controller.focused = true;

        return controller;
      }

      testWidgets('beats a widget-state variant declared before it', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildStyle(
            BoxStyler()
                .size(50, 50)
                .variant(selected, BoxStyler().color(Colors.red))
                .onFocusVisible(BoxStyler().color(Colors.blue)),
            selectedAndFocusVisible(),
          ),
        );

        expect(colorOf(tester), Colors.blue);
      });

      testWidgets('loses to a widget-state variant declared after it', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildStyle(
            BoxStyler()
                .size(50, 50)
                .onFocusVisible(BoxStyler().color(Colors.blue))
                .variant(selected, BoxStyler().color(Colors.red)),
            selectedAndFocusVisible(),
          ),
        );

        expect(colorOf(tester), Colors.red);
      });
    });
  });
}
