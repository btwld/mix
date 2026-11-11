import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

final _slices = [
  PieSlice(id: 'direct', label: 'Direct', value: 56),
  PieSlice(id: 'partners', label: 'Partners', value: 29),
  PieSlice(id: 'other', label: 'Other', value: 15),
];

Future<List<double>> _radii(
  WidgetTester tester,
  double side, {
  PieChartStyler style = const PieChartStyler.create(),
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Center(
        child: SizedBox.square(
          dimension: side,
          child: PieChart(slices: _slices, style: style),
        ),
      ),
    ),
  );

  return [
    for (final section
        in tester.widget<fl.PieChart>(find.byType(fl.PieChart)).data.sections)
      section.radius,
  ];
}

void main() {
  testWidgets('keeps 80px slices when the pie fits', (tester) async {
    expect(await _radii(tester, 360), everyElement(80));
  });

  testWidgets('thins slices to fit a small box', (tester) async {
    final radii = await _radii(tester, 120);

    // Half the box, less room for the default 8px selection expansion.
    expect(radii, everyElement(60 - 8));
  });

  testWidgets('keeps room for the selection just above 80px', (tester) async {
    final radii = await _radii(tester, 170);

    // An 85px half box holds an 80px slice but not its 8px expansion.
    expect(radii, everyElement(85 - 8));
  });

  testWidgets('fits a donut ring around its hole', (tester) async {
    final radii = await _radii(
      tester,
      160,
      style: PieChartStyler().centerRadius(40).selectedSliceRadiusOffset(4),
    );

    expect(radii, everyElement(80 - 40 - 4));
  });

  testWidgets('an explicit slice radius wins', (tester) async {
    final radii = await _radii(
      tester,
      120,
      style: PieChartStyler().slice(PieSliceStyler().radius(70)),
    );

    expect(radii, everyElement(70));
  });
}
