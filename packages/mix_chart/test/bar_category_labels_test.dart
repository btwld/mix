import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

List<BarGroup> _groups(List<String> labels) => [
  for (final (index, label) in labels.indexed)
    BarGroup(
      id: index,
      label: label,
      bars: [BarValue(id: 'v', label: 'Orders', toY: index + 1.0)],
    ),
];

Future<void> _pump(WidgetTester tester, BarChart chart) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: 640, height: 220, child: chart),
      ),
    ),
  ),
);

/// Bottom label texts with their rendered rectangles.
List<(String, Rect)> _bottomLabels(WidgetTester tester) => [
  for (final element in find.byType(fl.SideTitleWidget).evaluate())
    if ((element.widget as fl.SideTitleWidget).meta.axisSide ==
        fl.AxisSide.bottom)
      for (final text
          in find
              .descendant(
                of: find.byWidget(element.widget),
                matching: find.byType(Text),
              )
              .evaluate())
        (
          (text.widget as Text).data!,
          tester.getRect(find.byWidget(text.widget)),
        ),
];

void main() {
  testWidgets('keeps every label when they fit', (tester) async {
    await _pump(
      tester,
      BarChart(groups: _groups(['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'])),
    );

    expect(_bottomLabels(tester).map((label) => label.$1), [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
    ]);
  });

  testWidgets('steps over labels that would overlap', (tester) async {
    await _pump(tester, BarChart(groups: _groups(_months)));

    final labels = _bottomLabels(tester);
    expect(labels.first.$1, 'January');
    expect(labels.length, lessThan(_months.length));
    for (var index = 1; index < labels.length; index++) {
      expect(
        labels[index].$2.left,
        greaterThanOrEqualTo(labels[index - 1].$2.right),
        reason: '"${labels[index].$1}" overlaps "${labels[index - 1].$1}"',
      );
    }
  });

  testWidgets('keeps custom label widgets', (tester) async {
    await _pump(
      tester,
      BarChart(
        groups: _groups(_months),
        xAxis: ChartAxis.numeric(
          labelBuilder: (context, label) => Text(label.formattedValue),
        ),
      ),
    );

    expect(find.text('February'), findsOneWidget);
    expect(find.text('December'), findsOneWidget);
  });
}
