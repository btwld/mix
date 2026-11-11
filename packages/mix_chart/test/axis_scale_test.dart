import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:mix_chart/src/backend/fl_chart/fl_axis_scale.dart';

const _audit = [1088.0, 1102.0, 1150.0, 1171.0, 1236.0, 1284.0];

LineSeries _series(List<double?> values) => LineSeries(
  id: 'teams',
  label: 'Teams',
  points: [
    for (final (index, y) in values.indexed)
      ChartPoint(id: index, x: index.toDouble(), y: y),
  ],
);

List<BarGroup> _groups(List<double> values) => [
  for (final (index, value) in values.indexed)
    BarGroup(
      id: index,
      label: 'G$index',
      bars: [BarValue(id: 'v', label: 'Value', toY: value)],
    ),
];

Future<void> _pump(WidgetTester tester, Widget chart) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: 360, height: 220, child: chart),
      ),
    ),
  ),
);

fl.LineChartData _lineData(WidgetTester tester) =>
    tester.widget<fl.LineChart>(find.byType(fl.LineChart)).data;

fl.BarChartData _barData(WidgetTester tester) =>
    tester.widget<fl.BarChart>(find.byType(fl.BarChart)).data;

/// Default label texts rendered on [side], in axis order.
List<String> _labels(WidgetTester tester, fl.AxisSide side) => [
  for (final element in find.byType(fl.SideTitleWidget).evaluate())
    if ((element.widget as fl.SideTitleWidget).meta.axisSide == side)
      for (final text
          in find
              .descendant(
                of: find.byWidget(element.widget),
                matching: find.byType(Text),
              )
              .evaluate())
        (text.widget as Text).data!,
];

void main() {
  group('value axis left to the data', () {
    testWidgets('rounds bounds out to the tick step', (tester) async {
      await _pump(tester, LineChart(series: [_series(_audit)]));

      final data = _lineData(tester);
      final titles = data.titlesData.leftTitles.sideTitles;
      expect(data.minY, 1050);
      expect(data.maxY, 1300);
      expect(titles.interval, 50);
      expect(titles.minIncluded, isTrue);
      expect(titles.maxIncluded, isTrue);
    });

    testWidgets('labels round ticks only, never the raw extremes', (
      tester,
    ) async {
      await _pump(tester, LineChart(series: [_series(_audit)]));

      final labels = _labels(tester, fl.AxisSide.left);
      expect(labels, ['1.05K', '1.1K', '1.15K', '1.2K', '1.25K', '1.3K']);
      expect(labels, isNot(contains('1.088K')));
      expect(labels, isNot(contains('1.284K')));
    });

    testWidgets('rounds bar value bounds, including negative values', (
      tester,
    ) async {
      await _pump(tester, BarChart(groups: _groups([-4, 6, -2, 8, -9, 3])));

      final data = _barData(tester);
      expect(data.minY, -10);
      expect(data.maxY, 10);
      expect(_labels(tester, fl.AxisSide.left), ['-10', '-5', '0', '5', '10']);
    });

    testWidgets('rounds an explicit interval out to its own step', (
      tester,
    ) async {
      await _pump(
        tester,
        LineChart(
          series: [_series(_audit)],
          yAxis: ChartAxis.numeric(interval: 100),
        ),
      );

      final data = _lineData(tester);
      expect(data.minY, 1000);
      expect(data.maxY, 1300);
      expect(_labels(tester, fl.AxisSide.left), ['1K', '1.1K', '1.2K', '1.3K']);
    });

    testWidgets('rounds only the bound the caller leaves open', (tester) async {
      await _pump(
        tester,
        LineChart(series: [_series(_audit)], yAxis: ChartAxis.numeric(min: 0)),
      );

      final data = _lineData(tester);
      expect(data.minY, 0);
      expect(data.maxY, greaterThanOrEqualTo(1284));
      final step = data.titlesData.leftTitles.sideTitles.interval!;
      expect(flIsOnTick(data.maxY, step), isTrue);
    });
  });

  group('whole-number data', () {
    testWidgets('never steps by fractions on the x axis', (tester) async {
      await _pump(tester, LineChart(series: [_series(_audit)]));

      final data = _lineData(tester);
      expect(data.titlesData.bottomTitles.sideTitles.interval, 1);
      expect(_labels(tester, fl.AxisSide.bottom), [
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
      ]);
    });

    testWidgets('never steps by fractions on a short value axis', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 360,
              height: 400,
              child: BarChart(groups: _groups([1, 3, 2, 0, 2, 1])),
            ),
          ),
        ),
      );

      expect(_barData(tester).titlesData.leftTitles.sideTitles.interval, 1);
      expect(_labels(tester, fl.AxisSide.left), ['0', '1', '2', '3']);
    });

    testWidgets('fractional data keeps fractional steps', (tester) async {
      await _pump(
        tester,
        LineChart(
          series: [
            _series([0.12, 0.48, 0.35, 0.91, 0.66, 0.08]),
          ],
        ),
      );

      final data = _lineData(tester);
      expect(data.minY, 0);
      expect(data.maxY, 1);
      expect(data.titlesData.leftTitles.sideTitles.interval, 0.2);
    });
  });

  group('grid', () {
    testWidgets('follows the axis step', (tester) async {
      await _pump(tester, LineChart(series: [_series(_audit)]));

      final data = _lineData(tester);
      expect(data.gridData.horizontalInterval, 50);
      expect(data.gridData.verticalInterval, 1);
      expect(data.baselineY, 1050);
    });

    testWidgets('follows an explicit axis interval', (tester) async {
      await _pump(
        tester,
        BarChart(
          groups: _groups([52, 68, 74, 88]),
          yAxis: ChartAxis.numeric(min: 0, max: 100, interval: 25),
        ),
      );

      expect(_barData(tester).gridData.horizontalInterval, 25);
    });

    testWidgets('keeps an interval set by the grid style', (tester) async {
      await _pump(
        tester,
        LineChart(
          series: [_series(_audit)],
          yAxis: ChartAxis.numeric(interval: 100),
          style: .grid(.horizontalInterval(20).verticalInterval(2)),
        ),
      );

      final data = _lineData(tester);
      expect(data.gridData.horizontalInterval, 20);
      expect(data.gridData.verticalInterval, 2);
      expect(data.titlesData.leftTitles.sideTitles.interval, 100);
      // Ticks and grid lines share an origin both steps divide.
      expect(data.baselineY, 1000);
    });
  });

  group('explicit axis settings win', () {
    testWidgets('bounds, interval and bound labels', (tester) async {
      await _pump(
        tester,
        LineChart(
          series: [_series(_audit)],
          yAxis: ChartAxis.numeric(
            min: 1088,
            max: 1284,
            interval: 50,
            minIncluded: true,
            maxIncluded: true,
          ),
        ),
      );

      final data = _lineData(tester);
      final titles = data.titlesData.leftTitles.sideTitles;
      expect(data.minY, 1088);
      expect(data.maxY, 1284);
      expect(titles.interval, 50);
      expect(titles.minIncluded, isTrue);
      expect(titles.maxIncluded, isTrue);
    });

    testWidgets('excluded bounds stay excluded even on a tick', (tester) async {
      await _pump(
        tester,
        LineChart(
          series: [_series(_audit)],
          yAxis: ChartAxis.numeric(
            min: 1000,
            max: 1300,
            minIncluded: false,
            maxIncluded: false,
          ),
        ),
      );

      final titles = _lineData(tester).titlesData.leftTitles.sideTitles;
      expect(titles.minIncluded, isFalse);
      expect(titles.maxIncluded, isFalse);
    });

    testWidgets('an explicit off-tick bound is not labelled by default', (
      tester,
    ) async {
      await _pump(
        tester,
        LineChart(
          series: [_series(_audit)],
          yAxis: ChartAxis.numeric(min: 1088, interval: 50),
        ),
      );

      final labels = _labels(tester, fl.AxisSide.left);
      expect(_lineData(tester).minY, 1088);
      expect(labels.first, '1.1K');
      expect(labels, isNot(contains('1.088K')));
    });

    testWidgets('a padded dashboard axis keeps its labels', (tester) async {
      await _pump(
        tester,
        BarChart(
          groups: _groups([52, 68, 74, 88]),
          yAxis: ChartAxis.numeric(
            min: -12.5,
            max: 112.5,
            interval: 25,
            minIncluded: false,
            maxIncluded: false,
          ),
        ),
      );

      final data = _barData(tester);
      expect(data.minY, -12.5);
      expect(data.maxY, 112.5);
      expect(_labels(tester, fl.AxisSide.left), ['0', '25', '50', '75', '100']);
    });
  });

  group('zoomable axes', () {
    testWidgets('let the renderer refine ticks from round values', (
      tester,
    ) async {
      await _pump(
        tester,
        LineChart(
          series: [_series(_audit)],
          viewport: ChartViewport(axis: .vertical),
        ),
      );

      final data = _lineData(tester);
      expect(data.minY, 1050);
      expect(data.maxY, 1300);
      expect(data.titlesData.leftTitles.sideTitles.interval, isNull);
      expect(data.gridData.horizontalInterval, isNull);
      expect(data.baselineY, 0);
      // The x axis does not zoom, so it keeps the resolved step.
      expect(data.titlesData.bottomTitles.sideTitles.interval, 1);
    });
  });

  group('degenerate data', () {
    testWidgets('centres a single point', (tester) async {
      await _pump(
        tester,
        LineChart(
          series: [
            _series([42]),
          ],
        ),
      );

      final data = _lineData(tester);
      expect(data.minY, lessThan(42));
      expect(data.maxY, greaterThan(42));
      expect(data.minY + data.maxY, 84);
      expect(data.minX, lessThan(0));
      expect(data.maxX, greaterThan(0));
      expect(_labels(tester, fl.AxisSide.bottom), ['0']);
    });

    testWidgets('keeps zero as the floor of all-zero data', (tester) async {
      await _pump(tester, BarChart(groups: _groups([0, 0, 0])));

      final data = _barData(tester);
      expect(data.minY, 0);
      expect(data.maxY, 1);
      expect(_labels(tester, fl.AxisSide.left), ['0', '1']);
    });

    testWidgets('leaves an empty chart to the renderer', (tester) async {
      await _pump(tester, LineChart(series: const []));

      final data = _lineData(tester);
      expect(data.minY, isNaN);
      expect(data.maxY, isNaN);
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps explicit x bounds on a chart without points', (
      tester,
    ) async {
      await _pump(
        tester,
        LineChart(
          series: [
            _series([null, null]),
          ],
          xAxis: ChartAxis.numeric(min: 0, max: 10),
        ),
      );

      final data = _lineData(tester);
      expect(data.minX, 0);
      expect(data.maxX, 10);
      expect(data.titlesData.bottomTitles.sideTitles.interval, isNull);
    });
  });

  group('tick text', () {
    test('matches fl_chart 1.3 on every supported renderer version', () {
      expect(flFormatTick(1050, 1300, 1050, 50), '1.05K');
      expect(flFormatTick(1050, 1300, 1100, 50), '1.1K');
      expect(flFormatTick(0, 5000000, 2500000, 1000000), '2.5M');
      expect(flFormatTick(0, 1, 0.2, 0.2), '0.2');
      expect(flFormatTick(-10, 10, -5, 5), '-5');
      expect(flFormatTick(-1, 1, -0.0, 0.5), '0');
    });

    test('nice steps are 1, 2 or 5 times a power of ten', () {
      expect(flNiceStep(39.2), 50);
      expect(flNiceStep(0.71), 0.5);
      expect(flNiceStep(1.57), 1);
      expect(flNiceStep(0.172), 0.2);
      expect(flNiceStep(256.8), 200);
      expect(flNiceStep(2.6), 5);
      expect(flNiceStep(8), 10);
    });
  });
}
