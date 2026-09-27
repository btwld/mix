import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

/// Regression test for nested-style variant resolution.
///
/// A [Style] stored inside another [Style]'s [Prop] (a "sub-style", e.g.
/// `FlexBoxStyler`'s nested box) carries its own context variants. Those are
/// applied by [Style.build], not [Style.resolve]. Previously `Prop.resolveProp`
/// resolved nested styles via `resolve()`, silently dropping their variants.
/// See https://github.com/btwld/remix/issues/59.
void main() {
  group('Nested style prop variant resolution', () {
    BoxDecoration? boxDecorationOf(FlexBoxSpec spec) =>
        spec.box?.spec.decoration as BoxDecoration?;

    testWidgets('applies a nested style prop\'s widget-state variant', (
      tester,
    ) async {
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);

      // The hover variant lives on the NESTED box style, while the top-level
      // FlexBoxStyler has no widget-state variants of its own.
      final style = FlexBoxStyler.create(
        box: Prop.maybeMix(
          BoxStyler()
              .color(Colors.blue)
              .onHovered(BoxStyler().color(Colors.red)),
        ),
      );

      Color? boxColor;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyleBuilder<FlexBoxSpec>(
              style: style,
              controller: controller,
              builder: (context, spec) {
                boxColor = boxDecorationOf(spec)?.color;

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // Base state resolves to the nested style's base color.
      expect(boxColor, Colors.blue);

      // Toggling the widget state must activate the nested style's variant.
      controller.update(WidgetState.hovered, true);
      await tester.pumpAndSettle();
      expect(boxColor, Colors.red);

      controller.update(WidgetState.hovered, false);
      await tester.pumpAndSettle();
      expect(boxColor, Colors.blue);
    });

    testWidgets('nested style without variants resolves unchanged', (
      tester,
    ) async {
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);

      final style = FlexBoxStyler.create(
        box: Prop.maybeMix(BoxStyler().color(Colors.green)),
      );

      Color? boxColor;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyleBuilder<FlexBoxSpec>(
              style: style,
              controller: controller,
              builder: (context, spec) {
                boxColor = boxDecorationOf(spec)?.color;

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(boxColor, Colors.green);

      controller.update(WidgetState.hovered, true);
      await tester.pumpAndSettle();
      expect(boxColor, Colors.green);
    });
  });
}
