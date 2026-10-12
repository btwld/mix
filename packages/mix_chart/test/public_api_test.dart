import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  test('factory and instance shorthand compose without backend types', () {
    final fromFactory = LineChartStyler.axis(
      ChartAxisStyler.label(TextStyler.fontSize(11)),
    );
    final fromInstance = LineChartStyler()
        .axis(.label(.fontSize(11)))
        .grid(.stroke(.width(1)))
        .series(.stroke(.color(Colors.indigo).width(3)).marker(.radius(4)));

    expect(fromFactory, isA<LineChartStyler>());
    expect(fromInstance, isA<LineChartStyler>());
  });

  testWidgets('all chart widgets can be built from the public barrel', (
    tester,
  ) async {
    final line = LineChart(
      series: [
        LineSeries(
          id: 'revenue',
          label: 'Revenue',
          points: [
            ChartPoint(id: 'jan', x: 0, y: 2),
            ChartPoint(id: 'feb', x: 1, y: 4),
          ],
        ),
      ],
      style: .axis(.label(.fontSize(11))).grid(.show(true)),
    );
    final bar = BarChart(
      groups: [
        BarGroup(
          id: 'jan',
          label: 'January',
          bars: [BarValue(id: 'revenue', label: 'Revenue', toY: 4)],
        ),
      ],
      style: .bar(.width(16)).axis(.label(.fontSize(11))),
    );
    final pie = PieChart(
      slices: [PieSlice(id: 'mobile', label: 'Mobile', value: 62)],
      style: .centerRadius(32).slice(.radius(80)),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 120, child: line),
              SizedBox(height: 120, child: bar),
              SizedBox(height: 120, child: pie),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(LineChart), findsOneWidget);
    expect(find.byType(BarChart), findsOneWidget);
    expect(find.byType(PieChart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
