import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_atlas/mix_atlas.dart';

void main() {
  const baseColor = Color(0xFFFFFFFF);
  const hoverColor = Color(0xFF2196F3);
  const pressedColor = Color(0xFF7E57C2);
  const disabledColor = Color(0xFF9E9E9E);

  final style = BoxStyler()
      .size(20, 20)
      .color(baseColor)
      .onHovered(.color(hoverColor))
      .onPressed(.color(pressedColor))
      .onDisabled(.color(disabledColor));

  testWidgets(
    'atlas forces normal component styles through nested interaction scopes',
    (tester) async {
      final atlas = ComponentAtlas(
        id: 'button',
        scenarios: const [
          AtlasScenarios.base,
          AtlasScenarios.hovered,
          AtlasScenarios.pressed,
          AtlasScenarios.disabled,
        ],
        rows: [
          AtlasRow(
            'base',
            (context, cell) => Pressable(
              key: ValueKey('pressable-${cell.scenario.id}'),
              enabled: !cell.disabled,
              child: Box(
                key: ValueKey('box-${cell.scenario.id}'),
                style: style,
              ),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AtlasView(atlas: atlas),
        ),
      );

      Color colorFor(String scenario) {
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byKey(ValueKey('box-$scenario')),
            matching: find.byType(Container),
          ),
        );
        return (container.decoration as BoxDecoration).color!;
      }

      expect(colorFor('default'), baseColor);
      expect(colorFor('hovered'), hoverColor);
      expect(colorFor('pressed'), pressedColor);
      expect(colorFor('disabled'), disabledColor);
      expect(
        tester
            .widget<Pressable>(find.byKey(const ValueKey('pressable-default')))
            .enabled,
        isTrue,
      );
      expect(
        tester
            .widget<Pressable>(find.byKey(const ValueKey('pressable-disabled')))
            .enabled,
        isFalse,
      );
    },
  );

  testWidgets('cell.resolve remains available as an advanced helper', (
    tester,
  ) async {
    final resolvedColors = <String, Color?>{};
    final atlas = ComponentAtlas(
      id: 'box',
      scenarios: const [AtlasScenarios.base, AtlasScenarios.hovered],
      rows: [
        AtlasRow('base', (context, cell) {
          final spec = cell.resolve(context, style);
          final decoration = spec.spec.decoration as BoxDecoration?;
          resolvedColors[cell.scenario.id] = decoration?.color;

          return const SizedBox(width: 10, height: 10);
        }),
      ],
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AtlasView(atlas: atlas),
      ),
    );

    expect(resolvedColors['default'], baseColor);
    expect(resolvedColors['hovered'], hoverColor);
  });
}
