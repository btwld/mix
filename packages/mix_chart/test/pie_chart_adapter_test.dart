import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  testWidgets('maps pie slices and donut presentation', (tester) async {
    final chart = PieChart(
      slices: [
        PieSlice(id: 'mobile', label: 'Mobile', value: 64),
        PieSlice(
          id: 'desktop',
          label: 'Desktop',
          value: 36,
          style: .color(const Color(0xFF06B6D4)).radius(72),
        ),
      ],
      selectedSliceIds: const {'desktop'},
      valueFormatter: (value) => '${value.toInt()}%',
      style: .centerRadius(42)
          .centerColor(const Color(0xFFF8FAFC))
          .sliceSpacing(4)
          .startAngle(-120)
          .sunbeamLabels(true)
          .slice(.radius(64).label(.fontSize(11)).cornerRadius(5)),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SizedBox(width: 320, height: 280, child: chart)),
      ),
    );

    final backend = tester.widget<fl.PieChart>(find.byType(fl.PieChart));
    final data = backend.data;

    expect(data.centerSpaceRadius, 42);
    expect(data.centerSpaceColor, const Color(0xFFF8FAFC));
    expect(data.sectionsSpace, 4);
    expect(data.startDegreeOffset, -120);
    expect(data.titleSunbeamLayout, isTrue);
    expect(data.sections, hasLength(2));
    expect(data.sections.first.radius, 64);
    expect(data.sections.first.title, 'Mobile\n64%');
    expect(data.sections.last.color, const Color(0xFF06B6D4));
    expect(data.sections.last.radius, 80);
    expect(data.sections.last.cornerRadius, 5);
  });

  testWidgets('renders empty and zero-sum pies without a renderer crash', (
    tester,
  ) async {
    for (final slices in <List<PieSlice>>[
      const [],
      [PieSlice(id: 'zero', label: 'Zero', value: 0)],
    ]) {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 200,
            height: 200,
            child: PieChart(slices: slices),
          ),
        ),
      );

      expect(find.byType(fl.PieChart), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('snaps reordered slice topology', (tester) async {
    Widget host(List<PieSlice> slices) => MaterialApp(
      home: SizedBox(
        width: 240,
        height: 240,
        child: PieChart(
          slices: slices,
          dataTransition: const ChartDataTransition(
            duration: Duration(seconds: 1),
          ),
        ),
      ),
    );
    final first = PieSlice(id: 'first', label: 'First', value: 1);
    final second = PieSlice(id: 'second', label: 'Second', value: 2);

    await tester.pumpWidget(host([first, second]));
    await tester.pumpWidget(host([second, first]));

    expect(
      tester.widget<fl.PieChart>(find.byType(fl.PieChart)).duration,
      Duration.zero,
    );
  });

  testWidgets('per-slice solid paint overrides an inherited gradient', (
    tester,
  ) async {
    const inheritedGradient = LinearGradient(
      colors: [Color(0xFF111111), Color(0xFF222222)],
    );
    const sliceColor = Color(0xFFEF4444);

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 240,
          height: 240,
          child: PieChart(
            slices: [
              PieSlice(
                id: 'slice',
                label: 'Slice',
                value: 1,
                style: .color(sliceColor),
              ),
            ],
            style: .slice(.gradient(inheritedGradient)),
          ),
        ),
      ),
    );

    final section = tester
        .widget<fl.PieChart>(find.byType(fl.PieChart))
        .data
        .sections
        .single;

    expect(section.color, sliceColor);
    expect(section.gradient, isNull);
  });

  testWidgets('applies frame quarter turns to the pie start angle', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 240,
          height: 240,
          child: PieChart(
            slices: [PieSlice(id: 'slice', label: 'Slice', value: 1)],
            style: .startAngle(-90).frame(.rotationQuarterTurns(1)),
          ),
        ),
      ),
    );

    final data = tester.widget<fl.PieChart>(find.byType(fl.PieChart)).data;
    expect(data.startDegreeOffset, 0);
  });
}
