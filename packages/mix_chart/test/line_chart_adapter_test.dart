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
      selectedPoints: {const LinePointKey(seriesId: 'revenue', pointId: 'mar')},
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

  testWidgets('per-series solid paints override inherited gradients', (
    tester,
  ) async {
    const inheritedGradient = LinearGradient(
      colors: [Color(0xFF111111), Color(0xFF222222)],
    );
    const strokeColor = Color(0xFFEF4444);
    const belowColor = Color(0xFF22C55E);
    const aboveColor = Color(0xFF3B82F6);

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 300,
          height: 200,
          child: LineChart(
            series: [
              LineSeries(
                id: 'series',
                label: 'Series',
                points: [ChartPoint(id: 'point', x: 0, y: 1)],
                style: .stroke(
                  .color(strokeColor),
                ).belowArea(.color(belowColor)).aboveArea(.color(aboveColor)),
              ),
            ],
            style: .series(
              .stroke(.gradient(inheritedGradient))
                  .belowArea(.show(true).gradient(inheritedGradient))
                  .aboveArea(.show(true).gradient(inheritedGradient)),
            ),
          ),
        ),
      ),
    );

    final series = tester
        .widget<fl.LineChart>(find.byType(fl.LineChart))
        .data
        .lineBarsData
        .single;

    expect(series.color, strokeColor);
    expect(series.gradient, isNull);
    expect(series.belowBarData.color, belowColor);
    expect(series.belowBarData.gradient, isNull);
    expect(series.aboveBarData.color, aboveColor);
    expect(series.aboveBarData.gradient, isNull);
  });

  testWidgets('selected duplicate-coordinate point remains addressable', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 300,
          height: 200,
          child: LineChart(
            series: [
              LineSeries(
                id: 'series',
                label: 'Series',
                points: [
                  ChartPoint(id: 'first', x: 0, y: 1),
                  ChartPoint(id: 'second', x: 0, y: 1),
                ],
              ),
            ],
            selectedPoints: {
              const LinePointKey(seriesId: 'series', pointId: 'second'),
            },
          ),
        ),
      ),
    );

    final series = tester
        .widget<fl.LineChart>(find.byType(fl.LineChart))
        .data
        .lineBarsData
        .single;

    expect(series.dotData.checkToShowDot(series.spots[1], series), isTrue);
  });

  testWidgets('selection scopes repeated point IDs to their series', (
    tester,
  ) async {
    LineSeries series(Object id) => LineSeries(
      id: id,
      label: '$id',
      points: [ChartPoint(id: 'shared', x: 0, y: 1)],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 300,
          height: 200,
          child: LineChart(
            series: [series('first'), series('second')],
            selectedPoints: {
              const LinePointKey(seriesId: 'second', pointId: 'shared'),
            },
          ),
        ),
      ),
    );

    final bars = tester
        .widget<fl.LineChart>(find.byType(fl.LineChart))
        .data
        .lineBarsData;

    expect(bars[0].dotData.show, isFalse);
    expect(bars[1].dotData.show, isTrue);
  });

  testWidgets('rejects invalid grid intervals with a public argument error', (
    tester,
  ) async {
    Widget host(LineChartStyler style) => MaterialApp(
      home: SizedBox(
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
          style: style,
        ),
      ),
    );

    for (final interval in [0.0, -1.0, double.nan, double.infinity]) {
      await tester.pumpWidget(
        host(LineChartStyler.grid(.horizontalInterval(interval))),
      );
      final error = tester.takeException();

      expect(error, isA<ArgumentError>());
      expect((error! as ArgumentError).name, 'horizontalInterval');

      await tester.pumpWidget(const SizedBox.shrink());
    }

    await tester.pumpWidget(
      host(LineChartStyler.grid(ChartGridStyler.verticalInterval(-1))),
    );
    final error = tester.takeException();

    expect(error, isA<ArgumentError>());
    expect((error! as ArgumentError).name, 'verticalInterval');
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

  testWidgets('snaps transitions between drawable points and gaps', (
    tester,
  ) async {
    Widget host(double? y) => MaterialApp(
      home: SizedBox(
        width: 300,
        height: 200,
        child: LineChart(
          series: [
            LineSeries(
              id: 'series',
              label: 'Series',
              points: [ChartPoint(id: 'point', x: 0, y: y)],
            ),
          ],
          dataTransition: const ChartDataTransition(
            duration: Duration(seconds: 1),
          ),
        ),
      ),
    );

    for (final transition in <(double?, double?)>[(1, null), (null, 1)]) {
      await tester.pumpWidget(host(transition.$1));
      await tester.pumpWidget(host(transition.$2));

      expect(
        tester.widget<fl.LineChart>(find.byType(fl.LineChart)).duration,
        Duration.zero,
      );

      await tester.pumpWidget(const SizedBox.shrink());
    }
  });
}
