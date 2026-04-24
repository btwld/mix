import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/core/internal/mix_interaction_detector.dart';

Color? _boxColor(WidgetTester tester) {
  final container = tester.widget<Container>(find.byType(Container));
  return (container.decoration as BoxDecoration?)?.color;
}

Future<void> _pump(WidgetTester tester, BoxStyler style,
    {WidgetStatesController? controller}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: StyleBuilder<BoxSpec>(
        style: style,
        controller: controller,
        builder: (context, spec) => Container(
          decoration: spec.decoration,
          constraints: spec.constraints,
        ),
      ),
    ),
  );
}

void main() {
  group('onBuilder inline resolution', () {
    testWidgets('later inline fields override builder output', (tester) async {
      final style = BoxStyler()
          .color(Colors.green)
          .onBuilder((context) => BoxStyler().color(Colors.red))
          .color(Colors.blue);

      await _pump(tester, style);

      expect(_boxColor(tester), Colors.blue);
    });

    testWidgets('builder output overrides earlier inline fields', (tester) async {
      final style = BoxStyler()
          .color(Colors.green)
          .color(Colors.blue)
          .onBuilder((context) => BoxStyler().color(Colors.red));

      await _pump(tester, style);

      expect(_boxColor(tester), Colors.red);
    });

    testWidgets('multiple onBuilder calls preserve chain order', (tester) async {
      final style = BoxStyler()
          .color(Colors.black)
          .onBuilder((context) => BoxStyler().color(Colors.red))
          .color(Colors.green)
          .onBuilder((context) => BoxStyler().color(Colors.yellow))
          .color(Colors.blue);

      await _pump(tester, style);

      expect(_boxColor(tester), Colors.blue);
    });

    testWidgets('widget-state variant after onBuilder applies on top of builder',
        (tester) async {
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);

      final style = BoxStyler()
          .onBuilder((context) => BoxStyler().color(Colors.red))
          .onHovered(BoxStyler().color(Colors.blue));

      await _pump(tester, style, controller: controller);
      expect(_boxColor(tester), Colors.red);

      controller.update(WidgetState.hovered, true);
      await tester.pump();
      expect(_boxColor(tester), Colors.blue);
    });

    testWidgets(
      'widget-state variant in tail still triggers MixInteractionDetector',
      (tester) async {
        final style = BoxStyler()
            .onBuilder((context) => BoxStyler().color(Colors.red))
            .onHovered(BoxStyler().color(Colors.blue));

        await tester.pumpWidget(
          MaterialApp(
            home: StyleBuilder<BoxSpec>(
              style: style,
              builder: (context, spec) => Container(
                decoration: spec.decoration,
              ),
            ),
          ),
        );

        expect(find.byType(MixInteractionDetector), findsOneWidget);
      },
    );

    testWidgets('inline builder returning a style with variants resolves both',
        (tester) async {
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);

      final style = BoxStyler()
          .color(Colors.green)
          .onBuilder(
            (context) => BoxStyler()
                .color(Colors.red)
                .onHovered(BoxStyler().color(Colors.blue)),
          );

      await _pump(tester, style, controller: controller);
      expect(_boxColor(tester), Colors.red);

      controller.update(WidgetState.hovered, true);
      await tester.pump();
      expect(_boxColor(tester), Colors.blue);
    });

    testWidgets('inline builder coexists with widget modifiers on both sides',
        (tester) async {
      final style = BoxStyler()
          .onBuilder(
            (context) => BoxStyler().wrap(WidgetModifierConfig.opacity(0.5)),
          )
          .wrap(
            WidgetModifierConfig.padding(EdgeInsetsGeometryMix.all(10)),
          )
          .color(Colors.red);

      await _pump(tester, style);

      expect(find.byType(Opacity), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(_boxColor(tester), Colors.red);
    });

    testWidgets('animation config set inside onBuilder propagates', (tester) async {
      final animation = AnimationConfig.curve(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );

      final style = BoxStyler()
          .onBuilder((context) => BoxStyler().animate(animation))
          .color(Colors.red);

      await tester.pumpWidget(
        MaterialApp(
          home: StyleBuilder<BoxSpec>(
            style: style,
            builder: (context, spec) {
              return Container(decoration: spec.decoration);
            },
          ),
        ),
      );

      expect(find.byType(StyleAnimationBuilder<BoxSpec>), findsOneWidget);
      expect(_boxColor(tester), Colors.red);
    });
  });
}
