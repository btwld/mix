import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  for (final isBar in [false, true]) {
    for (final styled in [false, true]) {
      testWidgets('tooltip alignment/direction on bar=$isBar styled=$styled', (
        tester,
      ) async {
        final tooltip = styled
            ? ChartTooltipStyler().text(
                TextStyler()
                    .fontSize(19)
                    .textAlign(TextAlign.end)
                    .textDirection(TextDirection.rtl),
              )
            : const ChartTooltipStyler.create();
        await tester.pumpWidget(
          MaterialApp(
            home: SizedBox(
              width: 320,
              height: 200,
              child: isBar
                  ? BarChart(
                      groups: [
                        BarGroup(
                          id: 'g',
                          label: 'Group',
                          bars: [BarValue(id: 'b', label: 'Bar', toY: 12)],
                        ),
                      ],
                      style: BarChartStyler().tooltip(tooltip),
                    )
                  : LineChart(
                      series: [
                        LineSeries(
                          id: 's',
                          label: 'Series',
                          points: [ChartPoint(id: 'p', x: 0, y: 12)],
                        ),
                      ],
                      style: LineChartStyler().tooltip(tooltip),
                    ),
            ),
          ),
        );
        if (isBar) {
          final chart = tester.widget<fl.BarChart>(find.byType(fl.BarChart));
          final group = chart.data.barGroups.single;
          final item = chart.data.barTouchData.touchTooltipData.getTooltipItem(
            group,
            0,
            group.barRods.single,
            0,
          )!;
          expect(item.textStyle.fontSize, styled ? 19 : 12);
          expect(item.textAlign, styled ? TextAlign.end : TextAlign.center);
          expect(
            item.textDirection,
            styled ? TextDirection.rtl : TextDirection.ltr,
          );
        } else {
          final chart = tester.widget<fl.LineChart>(find.byType(fl.LineChart));
          final series = chart.data.lineBarsData.single;
          final item = chart.data.lineTouchData.touchTooltipData
              .getTooltipItems([fl.LineBarSpot(series, 0, series.spots.single)])
              .single!;
          expect(item.textStyle.fontSize, styled ? 19 : 12);
          expect(item.textAlign, styled ? TextAlign.end : TextAlign.center);
          expect(
            item.textDirection,
            styled ? TextDirection.rtl : TextDirection.ltr,
          );
        }
      });
    }
  }
}
