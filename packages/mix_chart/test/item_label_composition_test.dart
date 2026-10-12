import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  for (final replace in [false, true]) {
    testWidgets('explicit label typography wins replace=$replace', (
      tester,
    ) async {
      final common = TextStyler().fontSize(24).fontWeight(FontWeight.w700);
      final override = TextStyler()
          .fontSize(17)
          .color(Colors.red)
          .inherit(!replace);
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              SizedBox(
                width: 260,
                height: 200,
                child: PieChart(
                  style: PieChartStyler().slice(PieSliceStyler().label(common)),
                  slices: [
                    PieSlice(
                      id: 'p',
                      label: 'Pie',
                      value: 1,
                      style: PieSliceStyler().label(override),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 260,
                height: 200,
                child: BarChart(
                  style: BarChartStyler()
                      .bar(BarStyler().label(common))
                      .segment(BarSegmentStyler().label(common)),
                  groups: [
                    BarGroup(
                      id: 'g',
                      label: 'Group',
                      bars: [
                        BarValue(
                          id: 'b',
                          label: 'Bar',
                          toY: 4,
                          style: BarStyler().label(override),
                          segments: [
                            BarSegment(
                              id: 's',
                              label: 'Segment',
                              fromY: 0,
                              toY: 4,
                              style: BarSegmentStyler().label(override),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      final pie = tester.widget<fl.PieChart>(find.byType(fl.PieChart));
      final rod = tester
          .widget<fl.BarChart>(find.byType(fl.BarChart))
          .data
          .barGroups
          .single
          .barRods
          .single;
      for (final text in [
        pie.data.sections.single.titleStyle,
        rod.label.style,
        rod.rodStackItems.single.labelStyle,
      ]) {
        expect(text?.fontSize, 17);
        expect(text?.color, Colors.red);
        expect(text?.fontWeight, replace ? isNull : FontWeight.w700);
        expect(text?.inherit, !replace);
      }
    });
  }
  testWidgets('per-slice color preserves common label typography', (
    tester,
  ) async {
    final common = PieSliceStyler().label(
      TextStyler().fontSize(24).fontWeight(FontWeight.w700),
    );
    final override = PieSliceStyler().label(TextStyler().color(Colors.red));
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 320,
          height: 280,
          child: PieChart(
            style: PieChartStyler().slice(common),
            slices: [
              PieSlice(id: 'base', label: 'Base', value: 1),
              PieSlice(
                id: 'override',
                label: 'Override',
                value: 1,
                style: override,
              ),
            ],
          ),
        ),
      ),
    );
    final context = tester.element(find.byType(fl.PieChart));
    final composed = common
        .merge(override)
        .build(context)
        .spec
        .label!
        .spec
        .style!;
    expect(composed.fontSize, 24);
    expect(composed.fontWeight, FontWeight.w700);
    expect(composed.color, Colors.red);
    final sections = tester
        .widget<fl.PieChart>(find.byType(fl.PieChart))
        .data
        .sections;
    expect(sections.first.titleStyle?.fontSize, 24);
    expect(sections.last.titleStyle?.color, Colors.red);
    expect(sections.last.titleStyle?.fontSize, 24);
    expect(sections.last.titleStyle?.fontWeight, FontWeight.w700);
  });
  for (final segment in [false, true]) {
    testWidgets('item colors preserve common label fonts segment=$segment', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            width: 320,
            height: 280,
            child: BarChart(
              style: BarChartStyler()
                  .bar(
                    BarStyler().label(
                      TextStyler().fontSize(24).fontWeight(FontWeight.w700),
                    ),
                  )
                  .segment(
                    BarSegmentStyler().label(
                      TextStyler().fontSize(22).fontWeight(FontWeight.w500),
                    ),
                  ),
              groups: [
                BarGroup(
                  id: 'g',
                  label: 'Group',
                  bars: [
                    BarValue(
                      id: 'b',
                      label: 'Bar',
                      toY: 4,
                      style: BarStyler().label(TextStyler().color(Colors.red)),
                      segments: [
                        BarSegment(
                          id: 's',
                          label: 'Segment',
                          fromY: 0,
                          toY: 4,
                          style: BarSegmentStyler().label(
                            TextStyler().color(Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
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
      expect(rod.label.style?.color, Colors.red);
      expect(rod.rodStackItems.single.labelStyle?.color, Colors.blue);
      final text = segment
          ? rod.rodStackItems.single.labelStyle
          : rod.label.style;
      expect(text?.fontSize, segment ? 22 : 24);
      expect(text?.fontWeight, segment ? FontWeight.w500 : FontWeight.w700);
    });
  }
}
