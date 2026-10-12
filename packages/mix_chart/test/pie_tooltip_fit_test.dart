import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  for (final custom in [false, true]) {
    testWidgets('pie default fitting and live updates custom=$custom', (
      tester,
    ) async {
      final fitting = ValueNotifier<bool?>(null);
      addTearDown(fitting.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 240,
              height: 240,
              child: ValueListenableBuilder<bool?>(
                valueListenable: fitting,
                builder: (_, value, _) => PieChart(
                  slices: [PieSlice(id: 'm', label: 'Mobile', value: 64)],
                  tooltipBuilder: custom
                      ? (_, _) => const SizedBox(
                          key: ValueKey('custom-tooltip'),
                          width: 80,
                          height: 40,
                        )
                      : null,
                  style: PieChartStyler().tooltip(
                    value == null
                        ? const ChartTooltipStyler.create()
                        : ChartTooltipStyler()
                              .fitHorizontally(value)
                              .fitVertically(value),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final backend = tester.widget<fl.PieChart>(find.byType(fl.PieChart));
      final chart = tester.getRect(find.byType(fl.PieChart));
      backend.data.pieTouchData.touchCallback!(
        fl.FlPointerHoverEvent(const PointerHoverEvent(position: Offset(2, 2))),
        fl.PieTouchResponse(
          touchLocation: const Offset(2, 2),
          touchedSection: fl.PieTouchedSection(
            backend.data.sections.single,
            0,
            45,
            60,
          ),
        ),
      );
      await tester.pump();
      final tooltipFinder = custom
          ? find.byKey(const ValueKey('custom-tooltip'))
          : find.byWidgetPredicate(
              (widget) =>
                  widget is DecoratedBox &&
                  widget.decoration is BoxDecoration &&
                  (widget.decoration as BoxDecoration).color ==
                      const Color(0xFF0F172A),
            );
      for (final value in [null, false, true]) {
        fitting.value = value;
        await tester.pump();
        final tooltip = tester.getRect(tooltipFinder);
        final fits = custom || value != false;
        expect(
          tooltip.left,
          fits ? greaterThanOrEqualTo(chart.left) : lessThan(chart.left),
        );
        expect(
          tooltip.top,
          fits ? greaterThanOrEqualTo(chart.top) : lessThan(chart.top),
        );
      }
    });
  }

  for (final horizontal in [true, false]) {
    for (final vertical in [true, false]) {
      testWidgets('pie fitting horizontal=$horizontal vertical=$vertical', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: SizedBox(
                width: 240,
                height: 240,
                child: PieChart(
                  slices: [PieSlice(id: 'm', label: 'Mobile', value: 64)],
                  style: PieChartStyler().tooltip(
                    ChartTooltipStyler()
                        .fitHorizontally(horizontal)
                        .fitVertically(vertical),
                  ),
                ),
              ),
            ),
          ),
        );
        final backend = tester.widget<fl.PieChart>(find.byType(fl.PieChart));
        final chart = tester.getRect(find.byType(fl.PieChart));
        backend.data.pieTouchData.touchCallback!(
          fl.FlPointerHoverEvent(
            const PointerHoverEvent(position: Offset(2, 2)),
          ),
          fl.PieTouchResponse(
            touchLocation: const Offset(2, 2),
            touchedSection: fl.PieTouchedSection(
              backend.data.sections.single,
              0,
              45,
              60,
            ),
          ),
        );
        await tester.pump();
        final tooltip = tester.getRect(
          find.byWidgetPredicate(
            (widget) =>
                widget is DecoratedBox &&
                widget.decoration is BoxDecoration &&
                (widget.decoration as BoxDecoration).color ==
                    const Color(0xFF0F172A),
          ),
        );
        expect(
          tooltip.left,
          horizontal ? greaterThanOrEqualTo(chart.left) : lessThan(chart.left),
        );
        expect(
          tooltip.top,
          vertical ? greaterThanOrEqualTo(chart.top) : lessThan(chart.top),
        );
      });
    }
  }
}
