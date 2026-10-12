import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  for (final mode in ['defaults', 'styled', 'custom']) {
    testWidgets('pie tooltip text: $mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            width: 240,
            height: 240,
            child: PieChart(
              slices: [PieSlice(id: 'mobile', label: 'Mobile', value: 64)],
              tooltipBuilder: mode == 'custom'
                  ? (_, _) => const Text(
                      'Custom',
                      style: TextStyle(fontSize: 9),
                      maxLines: 2,
                    )
                  : null,
              style: mode == 'defaults'
                  ? const PieChartStyler.create()
                  : PieChartStyler().tooltip(
                      ChartTooltipStyler().text(
                        TextStyler()
                            .fontSize(17)
                            .textAlign(TextAlign.end)
                            .maxLines(1)
                            .overflow(TextOverflow.ellipsis),
                      ),
                    ),
            ),
          ),
        ),
      );
      final backend = tester.widget<fl.PieChart>(find.byType(fl.PieChart));
      backend.data.pieTouchData.touchCallback!(
        fl.FlPointerHoverEvent(
          const PointerHoverEvent(position: Offset(120, 60)),
        ),
        fl.PieTouchResponse(
          touchLocation: const Offset(120, 60),
          touchedSection: fl.PieTouchedSection(
            backend.data.sections.single,
            0,
            45,
            60,
          ),
        ),
      );
      await tester.pump();
      final rich = tester.widget<RichText>(
        find.descendant(
          of: find.text(mode == 'custom' ? 'Custom' : 'Mobile\n64.0'),
          matching: find.byType(RichText),
        ),
      );
      expect(
        rich.text.style?.fontSize,
        mode == 'custom'
            ? 9
            : mode == 'defaults'
            ? 12
            : 17,
      );
      if (mode == 'styled') {
        expect(rich.textAlign, TextAlign.end);
        expect(rich.maxLines, 1);
        expect(rich.overflow, TextOverflow.ellipsis);
      } else if (mode == 'defaults') {
        expect(rich.text.style?.color, Colors.white);
        expect(rich.text.style?.fontWeight, FontWeight.w600);
        expect(rich.maxLines, isNull);
      } else {
        expect(rich.maxLines, 2);
        expect(find.text('Mobile\n64.0'), findsNothing);
      }
    });
  }
}
