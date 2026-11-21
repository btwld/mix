import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

final _series = [
  LineSeries(
    id: 'revenue',
    label: 'Revenue',
    points: [
      for (final (index, y) in const [1088.0, 1150.0, 1284.0].indexed)
        ChartPoint(id: index, x: index.toDouble(), y: y),
    ],
  ),
];

String _currency(double value) => '\$${value.toStringAsFixed(2)} USD';

Future<void> _pump(
  WidgetTester tester,
  LineChart chart, {
  TextScaler textScaler = TextScaler.noScaling,
}) => tester.pumpWidget(
  MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(textScaler: textScaler),
      child: Scaffold(body: SizedBox(width: 360, height: 220, child: chart)),
    ),
  ),
);

double _leftReserved(WidgetTester tester) => tester
    .widget<fl.LineChart>(find.byType(fl.LineChart))
    .data
    .titlesData
    .leftTitles
    .sideTitles
    .reservedSize;

void main() {
  testWidgets('keeps the default space when the ticks fit', (tester) async {
    await _pump(
      tester,
      LineChart(
        series: _series,
        yAxis: ChartAxis.numeric(labelFormatter: (value) => '1'),
      ),
    );

    expect(_leftReserved(tester), 44);
  });

  testWidgets('grows to fit long ticks on one line', (tester) async {
    await _pump(
      tester,
      LineChart(
        series: _series,
        yAxis: ChartAxis.numeric(labelFormatter: _currency),
      ),
    );

    expect(_leftReserved(tester), greaterThan(44));
    final ticks = tester
        .renderObjectList<RenderParagraph>(find.textContaining('USD'))
        .toList();
    expect(ticks, isNotEmpty);
    for (final tick in ticks) {
      expect(
        tick.size.height,
        lessThan(11 * 1.2 * 1.5),
        reason: '"${tick.text.toPlainText()}" wrapped onto a second line',
      );
    }
  });

  testWidgets('grows with the text scale', (tester) async {
    await _pump(
      tester,
      LineChart(series: _series),
      textScaler: const TextScaler.linear(2),
    );

    expect(_leftReserved(tester), greaterThan(44));
  });

  testWidgets('an explicit reserved size wins', (tester) async {
    await _pump(
      tester,
      LineChart(
        series: _series,
        yAxis: ChartAxis.numeric(labelFormatter: _currency),
        style: .yAxis(.reservedSize(36)),
      ),
    );

    expect(_leftReserved(tester), 36);
  });

  testWidgets('custom label widgets keep the default space', (tester) async {
    await _pump(
      tester,
      LineChart(
        series: _series,
        yAxis: ChartAxis.numeric(
          labelFormatter: _currency,
          labelBuilder: (context, label) => const SizedBox.square(dimension: 4),
        ),
      ),
    );

    expect(_leftReserved(tester), 44);
  });
}
