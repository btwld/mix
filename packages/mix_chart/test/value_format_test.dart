import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

final _series = [
  LineSeries(
    id: 'teams',
    label: 'Teams',
    points: [
      ChartPoint(id: 'a', x: 0, y: 1088),
      ChartPoint(id: 'b', x: 1, y: 0.1 + 0.2),
    ],
  ),
];

final _groups = [
  BarGroup(
    id: 'apr',
    label: 'Apr',
    bars: [BarValue(id: 'orders', label: 'Orders', toY: 8)],
  ),
];

/// A y-axis formatter that hides every other tick, as dashboards do.
String _sparseTicks(double value) =>
    value.round().isEven ? '${value.round()}' : '';

Future<void> _pump(WidgetTester tester, Widget chart) => tester.pumpWidget(
  MaterialApp(home: SizedBox(width: 320, height: 200, child: chart)),
);

List<String> _lineTooltips(WidgetTester tester) {
  final data = tester.widget<fl.LineChart>(find.byType(fl.LineChart)).data;
  final bar = data.lineBarsData.single;

  return [
    for (final spot in bar.spots)
      data.lineTouchData.touchTooltipData
          .getTooltipItems([fl.LineBarSpot(bar, 0, spot)])
          .single!
          .text,
  ];
}

String _barTooltip(WidgetTester tester) {
  final data = tester.widget<fl.BarChart>(find.byType(fl.BarChart)).data;
  final group = data.barGroups.single;

  return data.barTouchData.touchTooltipData
      .getTooltipItem(group, 0, group.barRods.single, 0)!
      .text;
}

String? _summary(WidgetTester tester, String label) =>
    tester.getSemantics(find.bySemanticsLabel(label)).value;

void main() {
  group('default value text', () {
    testWidgets('line tooltips and semantics drop .0 and float noise', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, LineChart(semanticsLabel: 'Teams', series: _series));

      expect(_lineTooltips(tester), ['Teams\n1088', 'Teams\n0.3']);
      expect(_summary(tester, 'Teams'), 'Teams: 1088, 0.3');
      semantics.dispose();
    });

    testWidgets('bar tooltips, labels and semantics drop .0', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(
        tester,
        BarChart(
          semanticsLabel: 'Orders',
          groups: _groups,
          style: .bar(.label(.fontSize(10))),
        ),
      );

      expect(_barTooltip(tester), 'Apr · Orders\n8');
      final rod = tester
          .widget<fl.BarChart>(find.byType(fl.BarChart))
          .data
          .barGroups
          .single
          .barRods
          .single;
      expect(rod.label.text, '8');
      expect(_summary(tester, 'Orders'), 'Apr: Orders 8');
      semantics.dispose();
    });

    testWidgets('pie labels, tooltips and semantics drop .0', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(
        tester,
        PieChart(
          semanticsLabel: 'Channels',
          slices: [PieSlice(id: 'direct', label: 'Direct', value: 56)],
        ),
      );

      final section = tester
          .widget<fl.PieChart>(find.byType(fl.PieChart))
          .data
          .sections
          .single;
      expect(section.title, 'Direct\n56');
      expect(_summary(tester, 'Channels'), 'Direct: 56');
      semantics.dispose();
    });
  });

  group('valueFormatter', () {
    testWidgets('formats line tooltips and semantics', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(
        tester,
        LineChart(
          semanticsLabel: 'Teams',
          series: _series,
          yAxis: ChartAxis.numeric(labelFormatter: (_) => 'axis'),
          valueFormatter: (value) => '${value.toStringAsFixed(1)} teams',
        ),
      );

      expect(_lineTooltips(tester).first, 'Teams\n1088.0 teams');
      expect(_summary(tester, 'Teams'), 'Teams: 1088.0 teams, 0.3 teams');
      semantics.dispose();
    });

    testWidgets('formats bar tooltips, labels and semantics', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(
        tester,
        BarChart(
          semanticsLabel: 'Orders',
          groups: _groups,
          valueFormatter: (value) => '${value.round()} orders',
          style: .bar(.label(.fontSize(10))),
        ),
      );

      expect(_barTooltip(tester), 'Apr · Orders\n8 orders');
      expect(_summary(tester, 'Orders'), 'Apr: Orders 8 orders');
      semantics.dispose();
    });
  });

  group('y-axis formatter fallback', () {
    testWidgets('is still used for tooltips when it returns text', (
      tester,
    ) async {
      await _pump(
        tester,
        LineChart(
          series: _series,
          yAxis: ChartAxis.numeric(labelFormatter: (value) => '\$$value'),
        ),
      );

      expect(_lineTooltips(tester).first, 'Teams\n\$1088.0');
    });

    testWidgets('never empties a tooltip or summary', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(
        tester,
        BarChart(
          semanticsLabel: 'Orders',
          groups: [
            BarGroup(
              id: 'may',
              label: 'May',
              bars: [BarValue(id: 'orders', label: 'Orders', toY: 9)],
            ),
          ],
          yAxis: ChartAxis.numeric(labelFormatter: _sparseTicks),
        ),
      );

      expect(_barTooltip(tester), 'May · Orders\n9');
      expect(_summary(tester, 'Orders'), 'May: Orders 9');
      semantics.dispose();
    });
  });
}
