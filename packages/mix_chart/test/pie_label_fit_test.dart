import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

Future<List<fl.PieChartSectionData>> sections(
  WidgetTester tester, {
  double side = 120,
  double scale = 1,
  PieChartStyler? style,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: Center(
          child: SizedBox.square(
            dimension: side,
            child: PieChart(
              slices: [
                PieSlice(id: 'a', label: 'Direct', value: 56),
                PieSlice(id: 'b', label: 'Partners', value: 29),
                PieSlice(id: 'c', label: 'Other', value: 15),
              ],
              style: style ?? const PieChartStyler.create(),
            ),
          ),
        ),
      ),
    ),
  );
  return tester.widget<fl.PieChart>(find.byType(fl.PieChart)).data.sections;
}

void main() {
  testWidgets('small pie uses readable values instead of overflowing names', (
    tester,
  ) async {
    final data = await sections(tester);
    expect(data.map((s) => s.title), ['56', '29', '15']);
    expect(data.map((s) => s.showTitle), [true, true, false]);
  });
  testWidgets('large text omits labels that cannot fit without shrinking', (
    tester,
  ) async {
    final data = await sections(tester, scale: 3);
    expect(data.every((s) => !s.showTitle), isTrue);
  });
  testWidgets('a thin donut does not paint text across the hole', (
    tester,
  ) async {
    final data = await sections(
      tester,
      style: PieChartStyler().centerRadius(40),
    );
    expect(data.every((s) => !s.showTitle), isTrue);
  });
  testWidgets('explicit label position retains caller placement', (
    tester,
  ) async {
    final data = await sections(
      tester,
      style: PieChartStyler().slice(.labelPosition(1.2)),
    );
    expect(data[1].title, 'Partners\n29');
    expect(data[1].showTitle, isTrue);
  });
}
