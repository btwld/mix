import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  testWidgets('line chart exposes one deterministic summary node', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 320,
          height: 200,
          child: LineChart(
            semanticsLabel: 'Sales performance',
            yAxis: ChartAxis.numeric(
              labelFormatter: (value) => 'USD ${value.toInt()}',
            ),
            series: [
              LineSeries(
                id: 'revenue',
                label: 'Revenue',
                points: [
                  ChartPoint(id: 'jan', x: 0, y: 12),
                  ChartPoint(id: 'gap', x: 1),
                  ChartPoint(id: 'feb', x: 2, y: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final node = tester.getSemantics(
      find.bySemanticsLabel('Sales performance'),
    );
    expect(node.value, 'Revenue: USD 12, USD 18');
    semantics.dispose();
  });

  testWidgets('summary can be overridden or excluded', (tester) async {
    final semantics = tester.ensureSemantics();

    Widget chart({required bool exclude}) => MaterialApp(
      home: SizedBox(
        width: 240,
        height: 200,
        child: PieChart(
          semanticsLabel: 'Channel split',
          semanticsValue: 'Most sessions are mobile',
          excludeFromSemantics: exclude,
          slices: [PieSlice(id: 'mobile', label: 'Mobile', value: 64)],
        ),
      ),
    );

    await tester.pumpWidget(chart(exclude: false));
    expect(
      tester.getSemantics(find.bySemanticsLabel('Channel split')).value,
      'Most sessions are mobile',
    );

    await tester.pumpWidget(chart(exclude: true));
    expect(find.bySemanticsLabel('Channel split'), findsNothing);
    semantics.dispose();
  });

  testWidgets('empty charts retain root semantics', (tester) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.rtl,
        child: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: SizedBox(
            width: 240,
            height: 200,
            child: PieChart(semanticsLabel: 'No data yet', slices: const []),
          ),
        ),
      ),
    );

    final node = tester.getSemantics(find.bySemanticsLabel('No data yet'));
    expect(node.value, isEmpty);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('a caller-owned viewport controller is not disposed', (
    tester,
  ) async {
    final controller = TransformationController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 300,
          height: 200,
          child: LineChart(
            viewport: ChartViewport(
              axis: ChartScaleAxis.horizontal,
              controller: controller,
            ),
            series: [
              LineSeries(
                id: 'series',
                label: 'Series',
                points: [ChartPoint(id: 'point', x: 0, y: 1)],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpWidget(const SizedBox());

    expect(() => controller.value = Matrix4.identity(), returnsNormally);
  });
}
