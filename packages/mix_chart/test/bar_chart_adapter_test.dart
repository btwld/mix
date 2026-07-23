import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  testWidgets('maps grouped, floating, and stacked bars', (tester) async {
    final chart = BarChart(
      groups: [
        BarGroup(
          id: 'q1',
          label: 'Q1',
          bars: [
            BarValue(
              id: 'revenue',
              label: 'Revenue',
              fromY: 2,
              toY: 12,
              segments: [
                BarSegment(id: 'product', label: 'Product', fromY: 2, toY: 7),
                BarSegment(
                  id: 'services',
                  label: 'Services',
                  fromY: 7,
                  toY: 12,
                  style: .color(const Color(0xFFF97316)),
                ),
              ],
              style: .width(22),
            ),
          ],
        ),
      ],
      yAxis: ChartAxis.numeric(min: 0, max: 15),
      selectedItems: {
        const BarSelectionKey.segment(
          groupId: 'q1',
          barId: 'revenue',
          segmentId: 'services',
        ),
      },
      style: .alignment(BarAlignment.spaceBetween)
          .groupSpacing(24)
          .barSpacing(7)
          .bar(
            .color(const Color(0xFF4F46E5))
                .width(16)
                .background(.show(true).toY(15).color(const Color(0xFFE2E8F0))),
          )
          .segment(.label(.fontSize(10))),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SizedBox(width: 480, height: 280, child: chart)),
      ),
    );

    final backend = tester.widget<fl.BarChart>(find.byType(fl.BarChart));
    final data = backend.data;
    final group = data.barGroups.single;
    final rod = group.barRods.single;

    expect(data.minY, 0);
    expect(data.maxY, 15);
    expect(data.groupsSpace, 24);
    expect(data.alignment, fl.BarChartAlignment.spaceBetween);
    expect(group.barsSpace, 7);
    expect(rod.fromY, 2);
    expect(rod.toY, 12);
    expect(rod.width, 24);
    expect(rod.backDrawRodData.show, isTrue);
    expect(rod.backDrawRodData.toY, 15);
    expect(rod.rodStackItems, hasLength(2));
    expect(rod.rodStackItems.last.color, const Color(0xFFF97316));
    expect(rod.rodStackItems.last.borderSide.width, 2);
    expect(rod.rodStackItems.first.label, 'Product');
  });

  testWidgets('snaps reordered bar topology', (tester) async {
    Widget host(List<BarValue> bars) => MaterialApp(
      home: SizedBox(
        width: 300,
        height: 200,
        child: BarChart(
          groups: [BarGroup(id: 'group', label: 'Group', bars: bars)],
          dataTransition: const ChartDataTransition(
            duration: Duration(seconds: 1),
          ),
        ),
      ),
    );
    final first = BarValue(id: 'first', label: 'First', toY: 1);
    final second = BarValue(id: 'second', label: 'Second', toY: 2);

    await tester.pumpWidget(host([first, second]));
    await tester.pumpWidget(host([second, first]));

    expect(
      tester.widget<fl.BarChart>(find.byType(fl.BarChart)).duration,
      Duration.zero,
    );
  });

  testWidgets('per-item solid paints override inherited gradients', (
    tester,
  ) async {
    const inheritedGradient = LinearGradient(
      colors: [Color(0xFF111111), Color(0xFF222222)],
    );
    const barColor = Color(0xFFEF4444);
    const backgroundColor = Color(0xFF22C55E);
    const segmentColor = Color(0xFF3B82F6);

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 300,
          height: 200,
          child: BarChart(
            groups: [
              BarGroup(
                id: 'group',
                label: 'Group',
                bars: [
                  BarValue(
                    id: 'bar',
                    label: 'Bar',
                    toY: 2,
                    segments: [
                      BarSegment(
                        id: 'segment',
                        label: 'Segment',
                        fromY: 0,
                        toY: 2,
                        style: .color(segmentColor),
                      ),
                    ],
                    style: .color(barColor).background(.color(backgroundColor)),
                  ),
                ],
              ),
            ],
            style: .bar(
              .gradient(
                inheritedGradient,
              ).background(.show(true).gradient(inheritedGradient)),
            ).segment(.gradient(inheritedGradient)),
          ),
        ),
      ),
    );

    final rod = tester
        .widget<fl.BarChart>(find.byType(fl.BarChart))
        .data
        .barGroups
        .single
        .barRods
        .single;

    expect(rod.color, barColor);
    expect(rod.gradient, isNull);
    expect(rod.backDrawRodData.color, backgroundColor);
    expect(rod.backDrawRodData.gradient, isNull);
    expect(rod.rodStackItems.single.color, segmentColor);
    expect(rod.rodStackItems.single.gradient, isNull);
  });

  testWidgets('selection scopes repeated local IDs to their parent marks', (
    tester,
  ) async {
    BarGroup group(Object groupId) => BarGroup(
      id: groupId,
      label: '$groupId',
      bars: [
        BarValue(
          id: 'actual',
          label: 'Actual',
          toY: 2,
          segments: [
            BarSegment(id: 'amount', label: 'Amount', fromY: 0, toY: 2),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 300,
          height: 200,
          child: BarChart(
            groups: [group('first'), group('second')],
            selectedItems: {
              const BarSelectionKey.segment(
                groupId: 'second',
                barId: 'actual',
                segmentId: 'amount',
              ),
            },
          ),
        ),
      ),
    );

    final rods = tester
        .widget<fl.BarChart>(find.byType(fl.BarChart))
        .data
        .barGroups
        .map((group) => group.barRods.single)
        .toList();

    expect(rods[0].width, 14);
    expect(rods[0].rodStackItems.single.borderSide, BorderSide.none);
    expect(rods[1].width, 16);
    expect(rods[1].rodStackItems.single.borderSide.width, 2);
  });
}
