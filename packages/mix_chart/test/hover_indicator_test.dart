import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

LineSeries _series({LineSeriesStyler? style}) => LineSeries(
  id: 'teams',
  label: 'Teams',
  points: [
    ChartPoint(id: 'a', x: 0, y: 4),
    ChartPoint(id: 'b', x: 1, y: 6),
  ],
  style: style,
);

Future<fl.TouchedSpotIndicatorData> _indicator(
  WidgetTester tester,
  LineChart chart,
) async {
  await tester.pumpWidget(
    MaterialApp(home: SizedBox(width: 320, height: 200, child: chart)),
  );
  final data = tester.widget<fl.LineChart>(find.byType(fl.LineChart)).data;
  final bar = data.lineBarsData.single;

  return data.lineTouchData.getTouchedSpotIndicator(bar, [1]).single!;
}

fl.FlDotCirclePainter _dot(fl.TouchedSpotIndicatorData indicator) {
  final bar = fl.LineChartBarData(spots: const [fl.FlSpot(1, 6)]);

  return indicator.touchedSpotDotData.getDotPainter(
        const fl.FlSpot(1, 6),
        0,
        bar,
        0,
      )
      as fl.FlDotCirclePainter;
}

void main() {
  testWidgets('defaults to a hairline and the selected marker', (tester) async {
    final indicator = await _indicator(tester, LineChart(series: [_series()]));

    expect(indicator.indicatorBelowLine.strokeWidth, 1);
    final dot = _dot(indicator);
    expect(dot.radius, closeTo(4 * 1.35, 1e-9));
    expect(dot.strokeColor, Colors.white);
    expect(dot.strokeWidth, 2);
  });

  testWidgets('follows the grid stroke and marker styles', (tester) async {
    final indicator = await _indicator(
      tester,
      LineChart(
        series: [_series()],
        style: LineChartStyler()
            .grid(
              ChartGridStyler().stroke(
                ChartStrokeStyler().color(const Color(0xFF123456)).width(2),
              ),
            )
            .series(
              LineSeriesStyler().marker(
                ChartMarkerStyler()
                    .radius(3)
                    .borderColor(const Color(0xFFFAFAFA))
                    .borderWidth(1),
              ),
            ),
      ),
    );

    expect(indicator.indicatorBelowLine.color, const Color(0xFF123456));
    expect(indicator.indicatorBelowLine.strokeWidth, 2);
    final dot = _dot(indicator);
    expect(dot.radius, closeTo(3 * 1.35, 1e-9));
    expect(dot.strokeColor, const Color(0xFFFAFAFA));
    expect(dot.strokeWidth, 1);
  });

  testWidgets('uses the per-series marker and colour', (tester) async {
    final indicator = await _indicator(
      tester,
      LineChart(
        series: [
          _series(
            style: LineSeriesStyler()
                .stroke(ChartStrokeStyler().color(const Color(0xFF0EA5E9)))
                .marker(ChartMarkerStyler().radius(6)),
          ),
        ],
      ),
    );

    final dot = _dot(indicator);
    expect(dot.radius, closeTo(6 * 1.35, 1e-9));
    expect(dot.color, const Color(0xFF0EA5E9));
  });
}
