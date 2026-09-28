import 'package:flutter/material.dart';
import 'package:mix_chart/mix_chart.dart';

const _palette = [Color(0xFF3B6EF5), Color(0xFF8EACF8), Color(0xFFBED0FA)];

void main() => runApp(
  const MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(width: 440, height: 260, child: LineExample()),
      ),
    ),
  ),
);

class LineExample extends StatelessWidget {
  const LineExample({super.key});

  @override
  Widget build(BuildContext context) => LineChart(
    semanticsLabel: 'Weekly line chart',
    series: [
      LineSeries(
        id: 'visits',
        label: 'Visits',
        points: [
          for (var i = 0; i < 7; i++)
            ChartPoint(
              id: 'day-$i',
              x: i.toDouble(),
              y: [18, 26, 31, 47, 35, 44, 58][i].toDouble(),
            ),
        ],
      ),
    ],
    style: LineChartStyler()
        .palette(_palette)
        .frame(.showBorder(false))
        .grid(.showHorizontal(false).showVertical(false))
        .series(.stroke(.width(3)).marker(.show(true).radius(4))),
  );
}
