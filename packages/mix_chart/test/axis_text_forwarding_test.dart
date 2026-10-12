import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  testWidgets('raw axis specs preserve common strut fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 400,
          height: 250,
          child: LineChart(
            series: [
              LineSeries(
                id: 's',
                label: 'S',
                points: [
                  ChartPoint(id: 'a', x: 0, y: 0),
                  ChartPoint(id: 'b', x: 1, y: 1),
                ],
              ),
            ],
            xAxis: ChartAxis.numeric(
              min: 0,
              max: 1,
              interval: 1,
              labelFormatter: (_) => 'Raw',
            ),
            styleSpec: const StyleSpec(
              spec: LineChartSpec(
                axis: StyleSpec(
                  spec: ChartAxisSpec(
                    label: StyleSpec(
                      spec: TextSpec(
                        strutStyle: StrutStyle(
                          fontSize: 16,
                          height: 1.3,
                          leadingDistribution: TextLeadingDistribution.even,
                          debugLabel: 'Common strut',
                          fontFamily: 'Primary',
                          fontFamilyFallback: ['Fallback'],
                          package: 'axis_fonts',
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
                xAxis: StyleSpec(
                  spec: ChartAxisSpec(
                    label: StyleSpec(
                      spec: TextSpec(strutStyle: StrutStyle(height: 1.6)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final labels = tester.widgetList<Text>(find.text('Raw')).toList();
    expect(labels, isNotEmpty);
    for (final label in labels) {
      expect(label.strutStyle!.fontSize, 16);
      expect(label.strutStyle!.height, 1.6);
      expect(
        label.strutStyle!.leadingDistribution,
        TextLeadingDistribution.even,
      );
      expect(label.strutStyle!.debugLabel, 'Common strut');
      expect(label.strutStyle!.fontFamily, 'packages/axis_fonts/Primary');
      expect(label.strutStyle!.fontFamilyFallback, [
        'packages/axis_fonts/Fallback',
      ]);
      expect(label.textAlign, TextAlign.end);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('specific axis modifier replaces common modifier metadata', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 400,
          height: 250,
          child: LineChart(
            series: [
              LineSeries(
                id: 's',
                label: 'S',
                points: [
                  ChartPoint(id: 'a', x: 0, y: 0),
                  ChartPoint(id: 'b', x: 1, y: 1),
                ],
              ),
            ],
            xAxis: ChartAxis.numeric(
              min: 0,
              max: 1,
              interval: 1,
              labelFormatter: (_) => 'Modified',
            ),
            style: LineChartStyler()
                .axis(
                  ChartAxisStyler().label(
                    TextStyler().wrap(
                      WidgetModifierConfig.modifiers([
                        OpacityModifierMix(opacity: 0.2),
                      ]),
                    ),
                  ),
                )
                .xAxis(
                  ChartAxisStyler().label(
                    TextStyler().wrap(
                      WidgetModifierConfig.modifiers([
                        OpacityModifierMix(opacity: 0.7),
                      ]),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
    final labels = find.text('Modified');
    expect(labels, findsWidgets);
    for (final element in labels.evaluate()) {
      final modifiers = <Opacity>[];
      element.visitAncestorElements((ancestor) {
        if (ancestor.widget case final Opacity opacity) modifiers.add(opacity);
        return true;
      });
      expect(modifiers.map((w) => w.opacity), [0.7]);
    }
  });

  for (final bar in [false, true]) {
    testWidgets(
      '${bar ? 'bar' : 'line'} preserves common fields and specific overrides',
      (tester) async {
        final common = ChartAxisStyler().label(
          TextStyler()
              .style(
                TextStyleMix(
                  fontFamilyFallback: ['FallbackFont'],
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  height: 1.4,
                  letterSpacing: 0.8,
                  wordSpacing: 1.5,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.green,
                  decorationStyle: TextDecorationStyle.dashed,
                  decorationThickness: 2,
                ),
              )
              .strutStyle(StrutStyleMix(fontSize: 16, height: 1.3))
              .fontFamily('CommonFont')
              .fontSize(15)
              .color(Colors.purple)
              .textAlign(TextAlign.end)
              .maxLines(2)
              .softWrap(false)
              .overflow(TextOverflow.fade)
              .textDirection(TextDirection.rtl)
              .textScaler(const TextScaler.linear(1.2))
              .textWidthBasis(TextWidthBasis.longestLine)
              .textHeightBehavior(
                TextHeightBehaviorMix(applyHeightToFirstAscent: false),
              )
              .locale(const Locale('fr'))
              .semanticsLabel('Accessible tick')
              .selectionColor(Colors.orange)
              .uppercase(),
        );
        final specific = ChartAxisStyler().label(
          TextStyler()
              .fontSize(19)
              .textAlign(TextAlign.center)
              .strutStyle(StrutStyleMix(height: 1.6)),
        );
        final axis = ChartAxis.numeric(
          min: 0,
          max: 1,
          interval: 1,
          labelFormatter: (_) => 'audit',
        );
        final chart = bar
            ? BarChart(
                groups: [
                  BarGroup(
                    id: 'a',
                    label: 'A',
                    bars: [BarValue(id: 'v', label: 'V', toY: 1)],
                  ),
                ],
                xAxis: axis,
                style: BarChartStyler().axis(common).xAxis(specific),
              )
            : LineChart(
                series: [
                  LineSeries(
                    id: 's',
                    label: 'S',
                    points: [
                      ChartPoint(id: 'a', x: 0, y: 0),
                      ChartPoint(id: 'b', x: 1, y: 1),
                    ],
                  ),
                ],
                xAxis: axis,
                style: LineChartStyler().axis(common).xAxis(specific),
              );
        await tester.pumpWidget(
          MaterialApp(home: SizedBox(width: 400, height: 250, child: chart)),
        );
        final labels = tester
            .widgetList<Text>(find.byType(Text))
            .where((w) => w.data == 'AUDIT')
            .toList();
        expect(labels, isNotEmpty);
        for (final label in labels) {
          expect(label.style!.fontFamily, 'CommonFont');
          expect(label.style!.fontFamilyFallback, ['FallbackFont']);
          expect(label.style!.fontStyle, FontStyle.italic);
          expect(label.style!.fontWeight, FontWeight.w300);
          expect(label.style!.height, 1.4);
          expect(label.style!.letterSpacing, 0.8);
          expect(label.style!.wordSpacing, 1.5);
          expect(label.style!.decoration, TextDecoration.underline);
          expect(label.style!.decorationColor, Colors.green);
          expect(label.style!.decorationStyle, TextDecorationStyle.dashed);
          expect(label.style!.decorationThickness, 2);
          expect(label.strutStyle!.fontSize, 16);
          expect(label.strutStyle!.height, 1.6);
          expect(label.style!.fontSize, 19);
          expect(label.style!.color, Colors.purple);
          expect(label.textAlign, TextAlign.center);
          expect(label.maxLines, 2);
          expect(label.softWrap, false);
          expect(label.overflow, TextOverflow.fade);
          expect(label.textDirection, TextDirection.rtl);
          expect(label.textScaler!.scale(10), 12);
          expect(label.textWidthBasis, TextWidthBasis.longestLine);
          expect(label.textHeightBehavior!.applyHeightToFirstAscent, false);
          expect(label.locale, const Locale('fr'));
          expect(label.semanticsLabel, 'Accessible tick');
          expect(label.selectionColor, Colors.orange);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('custom axis builder remains authoritative', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 400,
          height: 250,
          child: LineChart(
            series: [
              LineSeries(
                id: 's',
                label: 'S',
                points: [
                  ChartPoint(id: 'a', x: 0, y: 0),
                  ChartPoint(id: 'b', x: 1, y: 1),
                ],
              ),
            ],
            xAxis: ChartAxis.numeric(
              min: 0,
              max: 1,
              interval: 1,
              labelBuilder: (_, _) =>
                  const Text('Custom', textAlign: TextAlign.left),
            ),
            style: LineChartStyler().axis(
              ChartAxisStyler().label(
                TextStyler().uppercase().textAlign(TextAlign.end),
              ),
            ),
          ),
        ),
      ),
    );
    final labels = tester.widgetList<Text>(find.text('Custom')).toList();
    expect(labels, isNotEmpty);
    for (final label in labels) {
      expect(label.textAlign, TextAlign.left);
    }
    expect(find.text('CUSTOM'), findsNothing);
  });

  testWidgets('axis labels retain text flow and typography', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 400,
          height: 250,
          child: LineChart(
            xAxis: ChartAxis.numeric(
              min: 0,
              max: 1,
              interval: 1,
              labelFormatter: (_) => 'Audit',
            ),
            series: [
              LineSeries(
                id: 's',
                label: 'Series',
                points: [
                  ChartPoint(id: 'a', x: 0, y: 0),
                  ChartPoint(id: 'b', x: 1, y: 1),
                ],
              ),
            ],
            style: LineChartStyler().axis(
              ChartAxisStyler().label(
                TextStyler()
                    .fontFamily('AuditFont')
                    .fontSize(17)
                    .fontWeight(FontWeight.w300)
                    .textAlign(TextAlign.end)
                    .maxLines(2)
                    .softWrap(false)
                    .overflow(TextOverflow.fade),
              ),
            ),
          ),
        ),
      ),
    );
    final labels = tester
        .widgetList<RichText>(find.byType(RichText))
        .where((w) => w.text.toPlainText() == 'Audit')
        .toList();
    expect(labels, isNotEmpty);
    for (final label in labels) {
      expect(label.text.style!.fontFamily, 'AuditFont');
      expect(label.text.style!.fontSize, 17);
      expect(label.text.style!.fontWeight, FontWeight.w300);
      expect(label.textAlign, TextAlign.end);
      expect(label.maxLines, 2);
      expect(label.softWrap, false);
      expect(label.overflow, TextOverflow.fade);
    }
  });
}
