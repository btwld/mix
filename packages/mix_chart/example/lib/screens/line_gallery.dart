import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_chart/mix_chart.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets/demo_card.dart';

class LineGallery extends StatelessWidget {
  const LineGallery({super.key});

  @override
  Widget build(BuildContext context) => const GalleryList(
    title: 'Line & area',
    description:
        'A Mix-first API for curves, areas, steps, labels, interaction, and motion.',
    children: [
      _RevenueDemo(),
      _MultiSeriesDemo(),
      _StepGapDemo(),
      _WidgetAxisDemo(),
    ],
  );
}

LineChartStyler _lineStyle(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return LineChartStyler()
      .frame(.backgroundColor(Colors.transparent).showBorder(false).clip(true))
      .axis(
        .label(
          .fontSize(11)
              .fontWeight(FontWeight.w600)
              .color(dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
        ),
      )
      .grid(
        .showVertical(false).stroke(
          .color(
            dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ).width(1),
        ),
      )
      .series(.stroke(.width(3)).marker(.show(false)));
}

class _RevenueDemo extends StatefulWidget {
  const _RevenueDemo();

  @override
  State<_RevenueDemo> createState() => _RevenueDemoState();
}

class _RevenueDemoState extends State<_RevenueDemo> {
  LinePointKey? _selected;

  @override
  Widget build(BuildContext context) => DemoCard(
    title: 'Revenue momentum',
    caption: 'Tap a point. Its scoped key stays in application state.',
    child: LineChart(
      semanticsLabel: 'Weekly revenue',
      series: revenueSeries(includeComparison: false),
      xAxis: ChartAxis.numeric(interval: 1, labelFormatter: weekdayLabel),
      yAxis: ChartAxis.numeric(
        min: 0,
        max: 55,
        interval: 10,
        labelFormatter: compactCurrency,
      ),
      selectedPoints: {?_selected},
      onPointTap: (hit) => setState(() => _selected = hit.selectionKey),
      tooltipBuilder: (context, hit) {
        final point = hit as LineChartHit;
        return _Tooltip(title: 'Revenue', value: compactCurrency(point.y));
      },
      style: _lineStyle(context)
          .palette(const [Color(0xFF6366F1)])
          .series(
            .curve(LineCurve.curved)
                .smoothness(.35)
                .marker(.show(true).radius(3.5))
                .belowArea(
                  .show(true).gradient(
                    const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x446366F1), Color(0x006366F1)],
                    ),
                  ),
                ),
          ),
    ),
  );
}

class _MultiSeriesDemo extends StatelessWidget {
  const _MultiSeriesDemo();

  @override
  Widget build(BuildContext context) {
    final data = revenueSeries();
    return DemoCard(
      title: 'Per-series overrides',
      caption: 'A common chart style with one precise override on Plan.',
      child: LineChart(
        series: [
          data.first,
          LineSeries(
            id: data.last.id,
            label: data.last.label,
            points: data.last.points,
            style: .stroke(.dashArray([6, 5]).width(2.5)).marker(.show(true)),
          ),
        ],
        xAxis: ChartAxis.numeric(interval: 1, labelFormatter: weekdayLabel),
        yAxis: ChartAxis.numeric(
          min: 0,
          max: 55,
          interval: 10,
          labelFormatter: compactCurrency,
        ),
        style: _lineStyle(context)
            .palette(const [Color(0xFF0EA5E9), Color(0xFFF97316)])
            .series(.curve(LineCurve.curved)),
      ),
    );
  }
}

class _StepGapDemo extends StatelessWidget {
  const _StepGapDemo();

  @override
  Widget build(BuildContext context) => DemoCard(
    title: 'Steps, gaps & Mix motion',
    caption: 'Nullable values create gaps; presentation animates through Mix.',
    child: LineChart(
      series: stepSeries(),
      xAxis: ChartAxis.numeric(interval: 1, labelFormatter: weekdayLabel),
      yAxis: ChartAxis.numeric(min: 10, max: 36, interval: 5),
      style: _lineStyle(context)
          .palette(const [Color(0xFF10B981)])
          .series(.stroke(.width(3)).marker(.show(true).shape(.square)))
          .animate(
            AnimationConfig.easeInOut(const Duration(milliseconds: 300)),
          ),
    ),
  );
}

class _WidgetAxisDemo extends StatelessWidget {
  const _WidgetAxisDemo();

  @override
  Widget build(BuildContext context) => DemoCard(
    title: 'Widget labels & viewport',
    caption:
        'Axis builders stay Flutter-native; pan and zoom stay backend-neutral.',
    child: LineChart(
      series: revenueSeries(includeComparison: false),
      viewport: ChartViewport(axis: ChartScaleAxis.horizontal, maxScale: 3),
      xAxis: ChartAxis.numeric(
        interval: 1,
        labelFormatter: weekdayLabel,
        labelBuilder: (context, label) => DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Text(label.formattedValue),
          ),
        ),
      ),
      yAxis: ChartAxis.numeric(min: 0, max: 55, interval: 10),
      style: _lineStyle(context)
          .palette(resolvedChartPalette(context))
          .xAxis(.reservedSize(38).labelSpace(10).fitInside(true))
          .series(.curve(LineCurve.curved).marker(.show(true))),
    ),
  );
}

class _Tooltip extends StatelessWidget {
  const _Tooltip({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFF0F172A),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 14)],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF94A3B8))),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}
