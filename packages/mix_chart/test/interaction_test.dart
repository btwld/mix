import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  testWidgets('line interactions return public IDs and drive widget tooltips', (
    tester,
  ) async {
    final hovered = <LineChartHit?>[];
    LineChartHit? tapped;

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 320,
          height: 200,
          child: LineChart(
            series: [
              LineSeries(
                id: 'revenue',
                label: 'Revenue',
                points: [ChartPoint(id: 'jan', x: 0, y: 12)],
              ),
            ],
            hitTestRadius: 18,
            onPointHover: hovered.add,
            onPointTap: (hit) => tapped = hit,
            tooltipBuilder: (context, hit) => const Text('Point tooltip'),
          ),
        ),
      ),
    );

    final backend = tester.widget<fl.LineChart>(find.byType(fl.LineChart));
    final bar = backend.data.lineBarsData.single;
    final response = fl.LineTouchResponse(
      touchLocation: const Offset(120, 80),
      touchChartCoordinate: const Offset(0, 12),
      lineBarSpots: [fl.TouchLineBarSpot(bar, 0, bar.spots.single, 0)],
    );
    final hoverEvent = fl.FlPointerHoverEvent(
      const PointerHoverEvent(position: Offset(120, 80)),
    );

    backend.data.lineTouchData.touchCallback!(hoverEvent, response);
    await tester.pump();

    expect(backend.data.lineTouchData.touchSpotThreshold, 18);
    expect(hovered.single?.seriesId, 'revenue');
    expect(hovered.single?.pointId, 'jan');
    expect(find.text('Point tooltip'), findsOneWidget);

    backend.data.lineTouchData.touchCallback!(
      fl.FlTapUpEvent(
        TapUpDetails(
          kind: PointerDeviceKind.mouse,
          localPosition: const Offset(120, 80),
        ),
      ),
      response,
    );
    expect(tapped?.seriesId, 'revenue');
    expect(tapped?.pointId, 'jan');

    backend.data.lineTouchData.touchCallback!(
      fl.FlPointerExitEvent(const PointerExitEvent(position: Offset(330, 80))),
      null,
    );
    await tester.pump();

    expect(hovered.last, isNull);
    expect(find.text('Point tooltip'), findsNothing);
  });

  testWidgets('bar taps translate group, bar, and segment IDs', (tester) async {
    BarChartHit? tapped;

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 320,
          height: 200,
          child: BarChart(
            groups: [
              BarGroup(
                id: 'q1',
                label: 'Q1',
                bars: [
                  BarValue(
                    id: 'revenue',
                    label: 'Revenue',
                    toY: 12,
                    segments: [
                      BarSegment(
                        id: 'product',
                        label: 'Product',
                        fromY: 0,
                        toY: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ],
            hitTestPadding: const EdgeInsets.all(9),
            onBarTap: (hit) => tapped = hit,
          ),
        ),
      ),
    );

    final backend = tester.widget<fl.BarChart>(find.byType(fl.BarChart));
    final group = backend.data.barGroups.single;
    final rod = group.barRods.single;
    final response = fl.BarTouchResponse(
      touchLocation: const Offset(100, 70),
      touchChartCoordinate: const Offset(0, 12),
      spot: fl.BarTouchedSpot(
        group,
        0,
        rod,
        0,
        rod.rodStackItems.single,
        0,
        const fl.FlSpot(0, 12),
        const Offset(100, 70),
      ),
    );

    backend.data.barTouchData.touchCallback!(
      fl.FlTapUpEvent(
        TapUpDetails(
          kind: PointerDeviceKind.mouse,
          localPosition: const Offset(100, 70),
        ),
      ),
      response,
    );

    expect(
      backend.data.barTouchData.touchExtraThreshold,
      const EdgeInsets.all(9),
    );
    expect(tapped?.groupId, 'q1');
    expect(tapped?.barId, 'revenue');
    expect(tapped?.segmentId, 'product');
  });

  testWidgets('pie hover and tap return stable slice IDs', (tester) async {
    PieChartHit? hovered;
    PieChartHit? tapped;

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 240,
          height: 240,
          child: PieChart(
            slices: [PieSlice(id: 'mobile', label: 'Mobile', value: 64)],
            onSliceHover: (hit) => hovered = hit,
            onSliceTap: (hit) => tapped = hit,
          ),
        ),
      ),
    );

    final backend = tester.widget<fl.PieChart>(find.byType(fl.PieChart));
    final response = fl.PieTouchResponse(
      touchLocation: const Offset(120, 60),
      touchedSection: fl.PieTouchedSection(
        backend.data.sections.single,
        0,
        45,
        60,
      ),
    );

    backend.data.pieTouchData.touchCallback!(
      fl.FlPointerHoverEvent(
        const PointerHoverEvent(position: Offset(120, 60)),
      ),
      response,
    );
    await tester.pump();
    expect(hovered?.sliceId, 'mobile');
    expect(find.text('Mobile\n64.0'), findsOneWidget);

    backend.data.pieTouchData.touchCallback!(
      fl.FlTapUpEvent(
        TapUpDetails(
          kind: PointerDeviceKind.mouse,
          localPosition: const Offset(120, 60),
        ),
      ),
      response,
    );
    expect(tapped?.sliceId, 'mobile');
  });
}
