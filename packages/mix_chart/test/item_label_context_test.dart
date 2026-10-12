import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  for (final raw in [false, true]) {
    testWidgets('item typography updates with context raw=$raw', (
      tester,
    ) async {
      final dark = ValueNotifier(false);
      addTearDown(dark.dispose);
      final common = TextStyler()
          .fontSize(20)
          .fontFamily('Common')
          .letterSpacing(1.5)
          .onDark(.fontSize(28));
      final override = TextStyler()
          .color(Colors.red)
          .onDark(.color(Colors.blue));
      const rawText = StyleSpec(
        spec: TextSpec(
          style: TextStyle(fontSize: 31, fontFamily: 'Raw', letterSpacing: 2),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: ValueListenableBuilder<bool>(
            valueListenable: dark,
            builder: (_, value, _) => MediaQuery(
              data: MediaQueryData(
                platformBrightness: value ? Brightness.dark : Brightness.light,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 260,
                    height: 200,
                    child: PieChart(
                      style: PieChartStyler().slice(
                        PieSliceStyler().label(common),
                      ),
                      styleSpec: raw
                          ? const StyleSpec(
                              spec: PieChartSpec(
                                slice: StyleSpec(
                                  spec: PieSliceSpec(label: rawText),
                                ),
                              ),
                            )
                          : null,
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
                      styleSpec: raw
                          ? const StyleSpec(
                              spec: BarChartSpec(
                                bar: StyleSpec(spec: BarSpec(label: rawText)),
                                segment: StyleSpec(
                                  spec: BarSegmentSpec(label: rawText),
                                ),
                              ),
                            )
                          : null,
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
          ),
        ),
      );
      for (final value in [false, true, false]) {
        dark.value = value;
        await tester.pump();
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
          expect(text?.fontSize, raw ? 31 : (value ? 28 : 20));
          expect(text?.fontFamily, raw ? 'Raw' : 'Common');
          expect(text?.letterSpacing, raw ? 2 : 1.5);
          expect(text?.color, value ? Colors.blue : Colors.red);
        }
      }
    });
  }
}
