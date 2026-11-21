import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

Widget _box(BoxStyler style, WidgetStatesController controller) =>
    Directionality(
      textDirection: TextDirection.ltr,
      child: StyleBuilder<BoxSpec>(
        style: style,
        controller: controller,
        builder: (_, spec) =>
            ColoredBox(color: (spec.decoration as BoxDecoration).color!),
      ),
    );

Color _color(WidgetTester tester) =>
    tester.widget<ColoredBox>(find.byType(ColoredBox)).color;

void main() {
  testWidgets(
    'a new variant uses its forward timing, then its own exit timing',
    (tester) async {
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);
      final style = BoxStyler()
          .color(Colors.blue)
          .animate(.linear(200.ms), reverse: .linear(40.ms))
          .onHovered(
            BoxStyler()
                .color(Colors.red)
                .wrap(
                  WidgetModifierConfig.modifiers([
                    PaddingModifierMix(padding: EdgeInsetsGeometryMix.all(10)),
                    OpacityModifierMix(opacity: 0.5),
                  ]),
                )
                .animate(
                  .linear(300.ms),
                  reverse: CurveAnimationConfig.linear(100.ms, delay: 20.ms),
                ),
          );
      await tester.pumpWidget(
        MixScope(
          orderOfModifiers: const [OpacityModifier, PaddingModifier],
          child: _box(style, controller),
        ),
      );

      controller.update(WidgetState.hovered, true);
      await tester.pump();
      await tester.pump(150.ms);
      expect(_color(tester), Color.lerp(Colors.blue, Colors.red, 0.5));
      await tester.pump(150.ms);
      expect(_color(tester), Colors.red);

      controller.update(WidgetState.hovered, false);
      await tester.pump();
      await tester.pump(10.ms);
      expect(_color(tester), isSameColorAs(Colors.red));
      await tester.pump(60.ms);
      expect(
        _color(tester),
        isSameColorAs(Color.lerp(Colors.red, Colors.blue, 0.5)!),
      );
      expect(
        find.descendant(
          of: find.byType(Opacity),
          matching: find.byType(Padding),
        ),
        findsOneWidget,
      );
      await tester.pump(50.ms);
      expect(_color(tester), Colors.blue);
    },
  );

  testWidgets('a new variant takes over an exit to the same target', (
    tester,
  ) async {
    final controller = WidgetStatesController({WidgetState.hovered});
    addTearDown(controller.dispose);
    final style = BoxStyler()
        .color(Colors.blue)
        .animate(.linear(100.ms))
        .onHovered(
          BoxStyler()
              .color(Colors.red)
              .animate(.linear(100.ms), reverse: .linear(400.ms)),
        )
        .onFocused(BoxStyler().color(Colors.blue).animate(.linear(100.ms)));
    await tester.pumpWidget(_box(style, controller));
    expect(_color(tester), Colors.red);

    controller.update(WidgetState.hovered, false);
    await tester.pump();
    await tester.pump(100.ms);
    final handoffColor = Color.lerp(Colors.red, Colors.blue, 0.25)!;
    expect(_color(tester), isSameColorAs(handoffColor));

    controller.update(WidgetState.focused, true);
    await tester.pump();
    expect(_color(tester), isSameColorAs(handoffColor));
    await tester.pump(50.ms);
    expect(
      _color(tester),
      isSameColorAs(Color.lerp(handoffColor, Colors.blue, 0.5)!),
    );
    await tester.pump(50.ms);
    expect(_color(tester), Colors.blue);
  });

  testWidgets('equal configs do not hide which variant deactivated', (
    tester,
  ) async {
    final controller = WidgetStatesController({
      WidgetState.hovered,
      WidgetState.pressed,
    });
    addTearDown(controller.dispose);
    final config = ReversibleAnimationConfig(
      forward: .linear(200.ms),
      reverse: .linear(100.ms),
    );
    final style = BoxStyler()
        .onPressed(
          BoxStyler().onHovered(BoxStyler().color(Colors.blue).animate(config)),
        )
        .onFocused(
          BoxStyler().onHovered(BoxStyler().color(Colors.red).animate(config)),
        );
    await tester.pumpWidget(_box(style, controller));

    controller.update(WidgetState.pressed, false);
    controller.update(WidgetState.focused, true);
    await tester.pump();
    await tester.pump(100.ms);
    expect(_color(tester), Color.lerp(Colors.blue, Colors.red, 0.5));
    await tester.pump(100.ms);
    expect(_color(tester), Colors.red);

    controller.update(WidgetState.pressed, true);
    await tester.pump();
    expect(_color(tester), Colors.red);

    controller.update(WidgetState.focused, false);
    await tester.pump();
    await tester.pump(50.ms);
    expect(_color(tester), Color.lerp(Colors.red, Colors.blue, 0.5));
    await tester.pump(50.ms);
    expect(_color(tester), Colors.blue);
  });

  testWidgets('a reverse transition survives equivalent parent rebuilds', (
    tester,
  ) async {
    final controller = WidgetStatesController({WidgetState.hovered});
    addTearDown(controller.dispose);
    BoxStyler style() => BoxStyler()
        .color(Colors.blue)
        .onHovered(
          BoxStyler()
              .color(Colors.red)
              .animate(.linear(100.ms), reverse: .linear(300.ms)),
        );
    await tester.pumpWidget(_box(style(), controller));
    expect(_color(tester), Colors.red);

    controller.update(WidgetState.hovered, false);
    await tester.pump();
    await tester.pump(75.ms);
    final quarter = Color.lerp(Colors.red, Colors.blue, 0.25);
    expect(_color(tester), quarter);
    await tester.pumpWidget(_box(style(), controller));
    expect(_color(tester), quarter);
    await tester.pump(150.ms);
    expect(_color(tester), Color.lerp(Colors.red, Colors.blue, 0.75));
    await tester.pump(75.ms);
    expect(_color(tester), Colors.blue);

    controller.update(WidgetState.hovered, true);
    await tester.pump();
    await tester.pump(100.ms);
    controller.update(WidgetState.hovered, false);
    await tester.pump();
    await tester.pump(75.ms);
    expect(_color(tester), quarter);
    await tester.pumpWidget(_box(BoxStyler().color(Colors.green), controller));
    expect(_color(tester), quarter);
    await tester.pump(150.ms);
    expect(_color(tester), Color.lerp(quarter, Colors.green, 0.5));
    await tester.pump(150.ms);
    expect(_color(tester), Colors.green);
    await tester.pump(1.ms);
    await tester.pumpWidget(_box(BoxStyler().color(Colors.blue), controller));
    expect(_color(tester), Colors.blue);
  });

  testWidgets('a spring exit starts at the interrupted curve value', (
    tester,
  ) async {
    final controller = WidgetStatesController();
    addTearDown(controller.dispose);
    var completions = 0;
    final reverse = SpringAnimationConfig(
      spring: SpringDescription.withDampingRatio(mass: 1, stiffness: 100),
      onEnd: () => completions++,
    );
    final style = BoxStyler()
        .color(Colors.blue)
        .onHovered(
          BoxStyler()
              .color(Colors.red)
              .animate(.linear(400.ms), reverse: reverse),
        );
    await tester.pumpWidget(_box(style, controller));

    controller.update(WidgetState.hovered, true);
    await tester.pump();
    await tester.pump(100.ms);
    final interrupted = Color.lerp(Colors.blue, Colors.red, 0.25);
    expect(_color(tester), interrupted);

    controller.update(WidgetState.hovered, false);
    await tester.pump();
    expect(_color(tester), interrupted);
    await tester.pump(100.ms);
    final progress = SpringSimulation(reverse.spring, 0, 1, 0).x(0.1);
    expect(_color(tester), Color.lerp(interrupted, Colors.blue, progress));
    expect(completions, 0);
    await tester.pump(2.s);
    expect(_color(tester), isSameColorAs(Colors.blue));
    expect(completions, 1);
  });

  testWidgets('a phase target runs instead of an implicit exit', (
    tester,
  ) async {
    final controller = WidgetStatesController({WidgetState.hovered});
    final trigger = ValueNotifier(false);
    addTearDown(controller.dispose);
    addTearDown(trigger.dispose);
    var completions = 0;
    final style = BoxStyler()
        .color(Colors.blue)
        .phaseAnimation<Color>(
          trigger: trigger,
          phases: [Colors.blue, Colors.green],
          styleBuilder: (color, style) => style.color(color),
          configBuilder: (_) => .linear(100.ms, onEnd: () => completions++),
        )
        .onHovered(
          BoxStyler()
              .color(Colors.red)
              .animate(.linear(100.ms), reverse: .linear(300.ms)),
        );
    await tester.pumpWidget(_box(style, controller));
    expect(_color(tester), Colors.red);

    controller.update(WidgetState.hovered, false);
    await tester.pump();
    expect(_color(tester), Colors.blue);
    trigger.value = true;
    await tester.pump();
    await tester.pump(50.ms);
    expect(_color(tester), Color.lerp(Colors.blue, Colors.green, 0.5));
    expect(completions, 0);
    await tester.pump(151.ms);
    expect(_color(tester), Colors.blue);
    expect(completions, 1);
  });

  testWidgets('GridBoxStyler animates variant geometry in both directions', (
    tester,
  ) async {
    final controller = WidgetStatesController();
    addTearDown(controller.dispose);
    double? gap;
    await tester.pumpWidget(
      StyleBuilder<GridBoxSpec>(
        style: GridBoxStyler()
            .columnGap(0)
            .onHovered(
              GridBoxStyler.animate(
                .linear(200.ms),
                reverse: .linear(100.ms),
              ).columnGap(20),
            ),
        controller: controller,
        builder: (_, spec) {
          gap = spec.columnGap;
          return const SizedBox.shrink();
        },
      ),
    );

    controller.update(WidgetState.hovered, true);
    await tester.pump();
    await tester.pump(100.ms);
    expect(gap, 10);
    await tester.pump(100.ms);
    expect(gap, 20);

    controller.update(WidgetState.hovered, false);
    await tester.pump();
    await tester.pump(50.ms);
    expect(gap, 10);
    await tester.pump(50.ms);
    expect(gap, 0);
  });
}
