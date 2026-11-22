import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/core/internal/variant_activation.dart';

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

/// Builds the spec outside StyleBuilder and overrides its animation, the way
/// a downstream component library feeds built specs into the animator.
Widget _builtSpecBox(
  BoxStyler style,
  Set<WidgetState> states,
) => Directionality(
  textDirection: TextDirection.ltr,
  child: WidgetStateProvider(
    states: states,
    child: Builder(
      builder: (context) {
        final built = style.build(context);

        return StyleAnimationBuilder<BoxSpec>(
          spec: built.copyWith(animation: built.animation ?? .linear(400.ms)),
          builder: (_, spec) =>
              ColoredBox(color: (spec.spec.decoration as BoxDecoration).color!),
        );
      },
    ),
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
          .animate(.reversible(.linear(200.ms), reverse: .linear(40.ms)))
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
                  .reversible(
                    .linear(300.ms),
                    reverse: CurveAnimationConfig.linear(100.ms, delay: 20.ms),
                  ),
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
              .animate(.reversible(.linear(100.ms), reverse: .linear(400.ms))),
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

  testWidgets(
    'a deactivated owner retimes an in-flight enter to the same target',
    (tester) async {
      final controller = WidgetStatesController({WidgetState.hovered});
      addTearDown(controller.dispose);
      final style = BoxStyler()
          .color(Colors.blue)
          .onHovered(BoxStyler().color(Colors.red))
          .onFocused(
            BoxStyler()
                .color(Colors.blue)
                .animate(
                  .reversible(.linear(400.ms), reverse: .linear(100.ms)),
                ),
          );
      await tester.pumpWidget(_box(style, controller));
      expect(_color(tester), Colors.red);

      controller.update(WidgetState.hovered, false);
      controller.update(WidgetState.focused, true);
      await tester.pump();
      await tester.pump(50.ms);
      await tester.pumpWidget(_box(style, controller));
      await tester.pump(50.ms);
      final handoffColor = Color.lerp(Colors.red, Colors.blue, 0.25)!;
      expect(_color(tester), isSameColorAs(handoffColor));

      controller.update(WidgetState.focused, false);
      await tester.pump();
      expect(_color(tester), isSameColorAs(handoffColor));
      await tester.pump(50.ms);
      expect(
        _color(tester),
        isSameColorAs(Color.lerp(handoffColor, Colors.blue, 0.5)!),
      );
      await tester.pump(50.ms);
      expect(_color(tester), Colors.blue);
      await tester.pumpAndSettle();

      controller.update(WidgetState.hovered, true);
      await tester.pump();
      expect(_color(tester), Colors.red);
      controller.update(WidgetState.hovered, false);
      controller.update(WidgetState.focused, true);
      await tester.pump();
      await tester.pump(400.ms);
      expect(_color(tester), Colors.blue);
      controller.update(WidgetState.focused, false);
      await tester.pump();
      await tester.pump(1.ms);
      expect(_color(tester), Colors.blue);
      expect(tester.hasRunningAnimations, isFalse);
    },
  );

  testWidgets('equal configs do not hide which variant deactivated', (
    tester,
  ) async {
    final controller = WidgetStatesController({
      WidgetState.hovered,
      WidgetState.pressed,
    });
    addTearDown(controller.dispose);
    final config = AnimationConfig.reversible(
      .linear(200.ms),
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
              .animate(.reversible(.linear(100.ms), reverse: .linear(300.ms))),
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
              .animate(.reversible(.linear(400.ms), reverse: reverse)),
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
              .animate(.reversible(.linear(100.ms), reverse: .linear(300.ms))),
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
                .reversible(.linear(200.ms), reverse: .linear(100.ms)),
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

  testWidgets('a built spec copied with an animation keeps its exit timing', (
    tester,
  ) async {
    final style = BoxStyler()
        .color(Colors.blue)
        .onHovered(
          BoxStyler()
              .color(Colors.red)
              .animate(.reversible(.linear(200.ms), reverse: .linear(100.ms))),
        );
    await tester.pumpWidget(_builtSpecBox(style, const {}));
    expect(_color(tester), Colors.blue);

    await tester.pumpWidget(_builtSpecBox(style, const {WidgetState.hovered}));
    await tester.pump(100.ms);
    expect(_color(tester), Color.lerp(Colors.blue, Colors.red, 0.5));
    await tester.pump(100.ms);
    expect(_color(tester), Colors.red);

    await tester.pumpWidget(_builtSpecBox(style, const {}));
    await tester.pump(50.ms);
    expect(_color(tester), Color.lerp(Colors.red, Colors.blue, 0.5));
    await tester.pump(50.ms);
    expect(_color(tester), Colors.blue);
  });

  testWidgets('a built spec with an active variant equals a plain StyleSpec', (
    tester,
  ) async {
    final style = BoxStyler()
        .color(Colors.blue)
        .onHovered(
          BoxStyler()
              .color(Colors.red)
              .animate(.reversible(.linear(200.ms), reverse: .linear(100.ms))),
        );
    late StyleSpec<BoxSpec> built;
    await tester.pumpWidget(
      WidgetStateProvider(
        states: const {WidgetState.hovered},
        child: Builder(
          builder: (context) {
            built = style.build(context);

            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(readVariantActivation(built), isNotNull);
    final plain = StyleSpec(
      spec: built.spec,
      animation: built.animation,
      widgetModifiers: built.widgetModifiers,
    );
    expect(readVariantActivation(plain), isNull);
    expect(built, equals(plain));
    expect(plain, equals(built));
    expect(built.hashCode, plain.hashCode);
    expect(readVariantActivation(built.copyWith()), isNotNull);
    expect(readVariantActivation(built.lerp(plain, 0.5)), isNull);
  });

  testWidgets('a variant that stays active does not use its exit timing', (
    tester,
  ) async {
    final controller = WidgetStatesController({WidgetState.hovered});
    addTearDown(controller.dispose);
    Widget box(BoxStyler style) => Directionality(
      textDirection: TextDirection.ltr,
      child: StyleBuilder<BoxSpec>(
        style: style,
        controller: controller,
        builder: (_, spec) =>
            Align(alignment: spec.alignment!, child: const SizedBox.shrink()),
      ),
    );
    Alignment alignment() =>
        tester.widget<Align>(find.byType(Align)).alignment as Alignment;

    await tester.pumpWidget(
      box(
        BoxStyler().onHovered(
          BoxStyler()
              .alignment(Alignment.centerLeft)
              .animate(.reversible(.linear(400.ms), reverse: .linear(100.ms))),
        ),
      ),
    );
    expect(alignment(), Alignment.centerLeft);

    // Hover stays active. Only its style changes, and it drops the animation.
    await tester.pumpWidget(
      box(BoxStyler().onHovered(BoxStyler().alignment(Alignment.centerRight))),
    );
    await tester.pump(100.ms);
    expect(
      alignment(),
      Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.25),
    );
    await tester.pump(300.ms);
    expect(alignment(), Alignment.centerRight);
  });

  testWidgets('a curve subclass keeps its own timing in both directions', (
    tester,
  ) async {
    final controller = WidgetStatesController();
    addTearDown(controller.dispose);
    const slow = _SlowCurve();
    final style = BoxStyler()
        .color(Colors.blue)
        .onHovered(
          BoxStyler()
              .color(Colors.red)
              .animate(.reversible(slow, reverse: slow)),
        );
    await tester.pumpWidget(_box(style, controller));

    controller.update(WidgetState.hovered, true);
    await tester.pump();
    await tester.pump(100.ms);
    expect(_color(tester), Color.lerp(Colors.blue, Colors.red, 0.5));
    await tester.pump(100.ms);
    expect(_color(tester), Colors.red);

    controller.update(WidgetState.hovered, false);
    await tester.pump();
    await tester.pump(100.ms);
    expect(_color(tester), Color.lerp(Colors.red, Colors.blue, 0.5));
    await tester.pump(100.ms);
    expect(_color(tester), Colors.blue);
  });
}

/// Runs for twice its nominal duration, as a downstream subclass might.
class _SlowCurve extends CurveAnimationConfig {
  const _SlowCurve()
    : super(duration: const Duration(milliseconds: 100), curve: Curves.linear);

  @override
  Duration get totalDuration => const Duration(milliseconds: 200);
}
