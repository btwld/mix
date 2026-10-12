import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets/controls.dart';
import '../widgets/demo_card.dart';

class PlaygroundScreen extends StatelessWidget {
  const PlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context) => const DefaultTabController(
    length: 3,
    child: Column(
      children: [
        TabBar(
          tabs: [
            Tab(text: 'Line'),
            Tab(text: 'Bar'),
            Tab(text: 'Pie'),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [_LinePlayground(), _BarPlayground(), _PiePlayground()],
          ),
        ),
      ],
    ),
  );
}

Widget _controls(BuildContext context, List<Widget> children) => Card(
  margin: EdgeInsets.zero,
  child: Padding(
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live style controls',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    ),
  ),
);

class _LinePlayground extends StatefulWidget {
  const _LinePlayground();

  @override
  State<_LinePlayground> createState() => _LinePlaygroundState();
}

class _LinePlaygroundState extends State<_LinePlayground> {
  double _width = 3;
  double _radius = 4;
  bool _area = true;
  bool _curved = true;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      DemoCard(
        title: 'Presentation animation',
        caption:
            'The generated Spec lerps while renderer data duration stays zero.',
        child: LineChart(
          key: const Key('line-playground-chart'),
          series: revenueSeries(),
          xAxis: ChartAxis.numeric(interval: 1, labelFormatter: weekdayLabel),
          yAxis: ChartAxis.numeric(min: 0, max: 55, interval: 10),
          style: LineChartStyler()
              .palette(resolvedChartPalette(context))
              .axis(.label(.fontSize(11).color(const Color(0xFF64748B))))
              .grid(.showVertical(false).stroke(.color(chartGrid()).width(1)))
              .series(
                .stroke(.width(_width))
                    .curve(_curved ? LineCurve.curved : LineCurve.straight)
                    .marker(.show(true).radius(_radius))
                    .belowArea(
                      .show(_area).color(
                        chartSeries1.resolve(context).withValues(alpha: .14),
                      ),
                    ),
              )
              .frame(.showBorder(false).clip(true))
              .animate(
                AnimationConfig.easeInOut(const Duration(milliseconds: 280)),
              ),
        ),
      ),
      const SizedBox(height: 16),
      _controls(context, [
        LabeledSlider(
          label: 'Stroke width',
          value: _width,
          min: 1,
          max: 7,
          divisions: 12,
          onChanged: (value) => setState(() => _width = value),
        ),
        LabeledSlider(
          label: 'Marker radius',
          value: _radius,
          min: 2,
          max: 8,
          divisions: 12,
          onChanged: (value) => setState(() => _radius = value),
        ),
        LabeledSwitch(
          label: 'Curved',
          value: _curved,
          onChanged: (value) => setState(() => _curved = value),
        ),
        LabeledSwitch(
          label: 'Area fill',
          value: _area,
          onChanged: (value) => setState(() => _area = value),
        ),
      ]),
    ],
  );
}

class _BarPlayground extends StatefulWidget {
  const _BarPlayground();

  @override
  State<_BarPlayground> createState() => _BarPlaygroundState();
}

class _BarPlaygroundState extends State<_BarPlayground> {
  double _width = 16;
  double _radius = 6;
  bool _stacked = false;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      DemoCard(
        title: _stacked ? 'Stacked data' : 'Grouped data',
        caption: 'Swap public models independently from the shared Mix style.',
        child: BarChart(
          key: const Key('bar-playground-chart'),
          groups: _stacked ? stackedRevenue() : groupedRevenue(),
          yAxis: ChartAxis.numeric(min: 0, max: 65, interval: 10),
          style: BarChartStyler()
              .palette(resolvedChartPalette(context))
              .axis(.label(.fontSize(11)))
              .grid(.showVertical(false).stroke(.color(chartGrid()).width(1)))
              .bar(
                .width(
                  _stacked ? _width + 6 : _width,
                ).borderRadius(BorderRadius.circular(_radius)),
              )
              .segment(.border(const BorderSide(color: Colors.white, width: 1)))
              .frame(.showBorder(false).clip(true))
              .animate(
                AnimationConfig.easeInOut(const Duration(milliseconds: 280)),
              ),
        ),
      ),
      const SizedBox(height: 16),
      _controls(context, [
        LabeledSlider(
          label: 'Bar width',
          value: _width,
          min: 8,
          max: 28,
          divisions: 20,
          onChanged: (value) => setState(() => _width = value),
        ),
        LabeledSlider(
          label: 'Corner radius',
          value: _radius,
          min: 0,
          max: 14,
          divisions: 14,
          onChanged: (value) => setState(() => _radius = value),
        ),
        LabeledSwitch(
          label: 'Stacked data',
          value: _stacked,
          onChanged: (value) => setState(() => _stacked = value),
        ),
      ]),
    ],
  );
}

class _PiePlayground extends StatefulWidget {
  const _PiePlayground();

  @override
  State<_PiePlayground> createState() => _PiePlaygroundState();
}

class _PiePlaygroundState extends State<_PiePlayground> {
  double _center = 42;
  double _gap = 3;
  bool _labels = false;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      DemoCard(
        title: 'Donut geometry',
        caption: 'Center, gap, labels, and colors are ordinary style values.',
        child: PieChart(
          key: const Key('pie-playground-chart'),
          slices: channelSlices(),
          valueFormatter: (value) => '${value.toInt()}%',
          style: PieChartStyler()
              .palette(resolvedChartPalette(context))
              .centerRadius(_center)
              .centerColor(Theme.of(context).colorScheme.surface)
              .sliceSpacing(_gap)
              .slice(.radius(72).showLabel(_labels).cornerRadius(5))
              .animate(
                AnimationConfig.easeInOut(const Duration(milliseconds: 280)),
              ),
        ),
      ),
      const SizedBox(height: 16),
      _controls(context, [
        LabeledSlider(
          label: 'Center radius',
          value: _center,
          min: 0,
          max: 64,
          divisions: 16,
          onChanged: (value) => setState(() => _center = value),
        ),
        LabeledSlider(
          label: 'Slice gap',
          value: _gap,
          min: 0,
          max: 10,
          divisions: 10,
          onChanged: (value) => setState(() => _gap = value),
        ),
        LabeledSwitch(
          label: 'Labels',
          value: _labels,
          onChanged: (value) => setState(() => _labels = value),
        ),
      ]),
    ],
  );
}
