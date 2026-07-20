import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rendering_pipeline/scenarios/card_grid.dart';
import 'package:rendering_pipeline/src/benchmark_border_geometry.dart';

void main() {
  testWidgets(
    'directional card fixtures stay directional through active states',
    (tester) async {
      const card = ProductCardData(
        id: targetCardId,
        title: 'Directional card',
        subtitle: 'Fixture contract',
        badge: 'TEST',
        disabled: false,
      );

      for (final implementation in BenchmarkImplementation.values) {
        final controllers = BenchmarkControllerSet(const [card]);
        addTearDown(controllers.dispose);
        final app = BenchmarkApp(
          implementation: implementation,
          track: BenchmarkTrack.isolation,
          cards: const [card],
          controllers: controllers,
          borderGeometry: BenchmarkBorderGeometry.directional,
        );

        await tester.pumpWidget(app);

        BorderDirectional currentBorder() {
          final container = tester.widget<Container>(
            find.byKey(const ValueKey<String>('card-surface-2')),
          );
          final decoration = container.decoration! as BoxDecoration;

          return decoration.border! as BorderDirectional;
        }

        expect(currentBorder().top.color, const Color(0xffc7ccd4));
        expect(currentBorder().top.width, 1);

        controllers[0].update(WidgetState.hovered, true);
        await tester.pump();
        expect(currentBorder().top.color, const Color(0xff4d74d1));
        expect(currentBorder().top.width, 1);

        controllers[0].update(WidgetState.selected, true);
        await tester.pump();
        final selected = currentBorder();
        expect(selected.top.color, const Color(0xff2457c5));
        expect(selected.top.width, 2);
        expect(selected.top, selected.bottom);
        expect(selected.bottom, selected.start);
        expect(selected.start, selected.end);

        await tester.pumpWidget(const SizedBox.shrink());
      }
    },
  );
}
