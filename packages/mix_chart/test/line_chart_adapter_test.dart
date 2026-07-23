import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  testWidgets('maps line data and Mix presentation into fl_chart', (
    tester,
  ) async {
    final chart = LineChart(
      series: [
        LineSeries(
          id: 'revenue',
          label: 'Revenue',
          points: [
            ChartPoint(id: 'jan', x: 0, y: 4),
            ChartPoint(id: 'gap', x: 1),
            ChartPoint(id: 'mar', x: 2, y: 9),
          ],
          style: .curve(LineCurve.stepBefore).stroke(.width(5)),
        ),
      ],
      xAxis: ChartAxis.numeric(min: 0, max: 2, interval: 1),
      yAxis: ChartAxis.numeric(
        min: 0,
        max: 10,
        labelFormatter: (value) => 'USD ${value.toInt()}',
      ),
      viewport: ChartViewport(axis: ChartScaleAxis.horizontal, maxScale: 4),
      selectedPointIds: const {'mar'},
      style:
          .frame(
                .backgroundColor(
                  const Color(0xFFF8FAFC),
                ).showBorder(true).clip(true),
              )
              .axis(.label(.fontSize(13)))
              .grid(.stroke(.color(const Color(0xFFCBD5E1)).width(2)))
              .series(
                .stroke(
                  .color(const Color(0xFF4F46E5)).width(3),
                ).marker(.show(false)),
              ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SizedBox(width: 480, height: 280, child: chart)),
      ),
    );

    final backend = tester.widget<fl.LineChart>(find.byType(fl.LineChart));
    final data = backend.data;
    final series = data.lineBarsData.single;

    expect(data.minX, 0);
    expect(data.maxX, 2);
    expect(data.minY, 0);
    expect(data.maxY, 10);
    expect(data.backgroundColor, const Color(0xFFF8FAFC));
    expect(data.borderData.show, isTrue);
    expect(data.clipData.any, isTrue);
    expect(data.gridData.getDrawingHorizontalLine(0).strokeWidth, 2);
    expect(data.titlesData.leftTitles.sideTitles.showTitles, isTrue);
    expect(data.titlesData.topTitles.sideTitles.showTitles, isFalse);
    expect(series.spots[1], fl.FlSpot.nullSpot);
    expect(series.barWidth, 5);
    expect(series.isStepLineChart, isTrue);
    expect(
      series.lineChartStepData.stepDirection,
      fl.LineChartStepData.stepDirectionBackward,
    );
    expect(series.dotData.show, isTrue);
    expect(backend.transformationConfig.scaleAxis, fl.FlScaleAxis.horizontal);
    expect(backend.transformationConfig.maxScale, 4);
  });

  testWidgets('disables renderer interpolation for reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 300,
            height: 200,
            child: LineChart(
              series: [
                LineSeries(
                  id: 'series',
                  label: 'Series',
                  points: [ChartPoint(id: 'point', x: 0, y: 1)],
                ),
              ],
              dataTransition: const ChartDataTransition(
                duration: Duration(seconds: 1),
              ),
            ),
          ),
        ),
      ),
    );

    expect(
      tester.widget<fl.LineChart>(find.byType(fl.LineChart)).duration,
      Duration.zero,
    );
  });

  testWidgets('resolves optional consumer-owned Mix tokens', (tester) async {
    const brand = ColorToken('brand.chart');

    await tester.pumpWidget(
      MaterialApp(
        home: MixScope(
          tokens: {brand: const Color(0xFF7C3AED)},
          child: SizedBox(
            width: 300,
            height: 200,
            child: LineChart(
              series: [
                LineSeries(
                  id: 'series',
                  label: 'Series',
                  points: [ChartPoint(id: 'point', x: 0, y: 1)],
                ),
              ],
              style: .series(.stroke(.color(brand()))),
            ),
          ),
        ),
      ),
    );

    final backend = tester.widget<fl.LineChart>(find.byType(fl.LineChart));
    expect(backend.data.lineBarsData.single.color, const Color(0xFF7C3AED));
  });

  testWidgets('snaps topology changes and animates compatible updates', (
    tester,
  ) async {
    LineSeries series(String pointId, double y) => LineSeries(
      id: 'series',
      label: 'Series',
      points: [ChartPoint(id: pointId, x: 0, y: y)],
    );
    Widget host(LineSeries value) => MaterialApp(
      home: SizedBox(
        width: 300,
        height: 200,
        child: LineChart(
          series: [value],
          dataTransition: const ChartDataTransition(
            duration: Duration(seconds: 1),
          ),
        ),
      ),
    );

    await tester.pumpWidget(host(series('first', 1)));
    await tester.pumpWidget(host(series('replacement', 2)));
    expect(
      tester.widget<fl.LineChart>(find.byType(fl.LineChart)).duration,
      Duration.zero,
    );

    await tester.pumpWidget(host(series('replacement', 3)));
    expect(
      tester.widget<fl.LineChart>(find.byType(fl.LineChart)).duration,
      const Duration(seconds: 1),
    );
  });
}
