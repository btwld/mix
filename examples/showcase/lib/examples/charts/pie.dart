import 'package:flutter/material.dart';
import 'package:mix_chart/mix_chart.dart';

const _palette = [Color(0xFF3B6EF5), Color(0xFF8EACF8), Color(0xFFBED0FA)];

void main() => runApp(
  const MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(width: 440, height: 260, child: PieExample()),
      ),
    ),
  ),
);

class PieExample extends StatelessWidget {
  const PieExample({super.key});

  @override
  Widget build(BuildContext context) => PieChart(
    semanticsLabel: 'Three-slice pie chart',
    slices: [
      PieSlice(id: 'a', label: 'A', value: 42),
      PieSlice(id: 'b', label: 'B', value: 33),
      PieSlice(id: 'c', label: 'C', value: 25),
    ],
    style: PieChartStyler()
        .palette(_palette)
        .sliceSpacing(3)
        .slice(.showLabel(false).radius(75)),
  );
}
