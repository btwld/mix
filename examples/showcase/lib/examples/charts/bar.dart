import 'package:flutter/material.dart';
import 'package:mix_chart/mix_chart.dart';

const _palette = [Color(0xFF3B6EF5), Color(0xFF8EACF8), Color(0xFFBED0FA)];

void main() => runApp(
  const MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(width: 440, height: 260, child: BarExample()),
      ),
    ),
  ),
);

class BarExample extends StatelessWidget {
  const BarExample({super.key});

  @override
  Widget build(BuildContext context) => BarChart(
    semanticsLabel: 'Six-column bar chart',
    groups: [
      for (var i = 0; i < 6; i++)
        BarGroup(
          id: 'month-$i',
          label: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'][i],
          bars: [
            BarValue(
              id: 'value',
              label: 'Value',
              toY: [19, 36, 57, 39, 27, 65][i].toDouble(),
            ),
          ],
        ),
    ],
    style: BarChartStyler()
        .palette(_palette)
        .frame(.showBorder(false))
        .grid(.showHorizontal(false).showVertical(false))
        .bar(.width(24).borderRadius(BorderRadius.circular(4))),
  );
}
