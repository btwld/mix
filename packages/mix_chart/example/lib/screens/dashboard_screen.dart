import 'package:flutter/material.dart';
import 'package:mix_chart/mix_chart.dart';

import '../data.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => CustomScrollView(
    key: const PageStorageKey('dashboard'),
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.all(24),
        sliver: SliverList.list(
          children: [
            _Hero(),
            const SizedBox(height: 18),
            const _Metrics(),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 920;
                final trend = const _TrendPanel();
                final channels = const _ChannelPanel();
                return wide
                    ? const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _TrendPanel()),
                          SizedBox(width: 18),
                          Expanded(child: _ChannelPanel()),
                        ],
                      )
                    : Column(
                        children: [trend, const SizedBox(height: 18), channels],
                      );
              },
            ),
            const SizedBox(height: 18),
            const _RevenuePanel(),
          ],
        ),
      ),
    ],
  );
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF312E81), Color(0xFF4F46E5), Color(0xFF0284C7)],
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [
        BoxShadow(
          color: Color(0x334F46E5),
          blurRadius: 28,
          offset: Offset(0, 14),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MIX ANALYTICS',
                style: TextStyle(
                  color: Color(0xFFC7D2FE),
                  fontSize: 12,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'A chart API that feels native to your design system.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Mix owns the concepts. A mature renderer handles the pixels.',
                style: TextStyle(color: Color(0xFFE0E7FF), height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        const CircleAvatar(
          radius: 28,
          backgroundColor: Color(0x33FFFFFF),
          child: Icon(Icons.auto_graph, color: Colors.white, size: 28),
        ),
      ],
    ),
  );
}

class _Metrics extends StatelessWidget {
  const _Metrics();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth >= 760
          ? (constraints.maxWidth - 36) / 3
          : constraints.maxWidth;
      return Wrap(
        spacing: 18,
        runSpacing: 18,
        children: [
          _Metric(
            width: width,
            label: 'Revenue',
            value: '\$284k',
            change: '+18.4%',
          ),
          _Metric(
            width: width,
            label: 'Active teams',
            value: '1,248',
            change: '+8.1%',
          ),
          _Metric(
            width: width,
            label: 'Conversion',
            value: '12.6%',
            change: '+2.3%',
          ),
        ],
      );
    },
  );
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.width,
    required this.label,
    required this.value,
    required this.change,
  });

  final double width;
  final String label;
  final String value;
  final String change;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: _Panel(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Chip(
            side: BorderSide.none,
            backgroundColor: const Color(0xFFDCFCE7),
            label: Text(
              change,
              style: const TextStyle(
                color: Color(0xFF15803D),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _TrendPanel extends StatelessWidget {
  const _TrendPanel();

  @override
  Widget build(BuildContext context) => _Panel(
    title: 'Weekly momentum',
    subtitle: 'Revenue is 17% ahead of plan',
    child: SizedBox(
      height: 270,
      child: LineChart(
        series: revenueSeries(),
        xAxis: ChartAxis.numeric(interval: 1, labelFormatter: weekdayLabel),
        yAxis: ChartAxis.numeric(
          min: 0,
          max: 55,
          interval: 10,
          labelFormatter: compactCurrency,
        ),
        style: LineChartStyler()
            .palette(const [Color(0xFF6366F1), Color(0xFF94A3B8)])
            .axis(.label(.fontSize(10).color(const Color(0xFF64748B))))
            .grid(
              .showVertical(
                false,
              ).stroke(.color(const Color(0xFFE2E8F0)).width(1)),
            )
            .series(.curve(LineCurve.curved).stroke(.width(3)))
            .frame(.showBorder(false).clip(true)),
      ),
    ),
  );
}

class _ChannelPanel extends StatelessWidget {
  const _ChannelPanel();

  @override
  Widget build(BuildContext context) => _Panel(
    title: 'Channels',
    subtitle: 'Share of qualified traffic',
    child: SizedBox(
      height: 270,
      child: PieChart(
        slices: channelSlices(),
        valueFormatter: (value) => '${value.toInt()}%',
        style: PieChartStyler()
            .palette(const [
              Color(0xFF6366F1),
              Color(0xFF06B6D4),
              Color(0xFFF97316),
              Color(0xFFEC4899),
            ])
            .centerRadius(48)
            .centerColor(Theme.of(context).colorScheme.surface)
            .sliceSpacing(3)
            .slice(.radius(67).showLabel(false).cornerRadius(6)),
      ),
    ),
  );
}

class _RevenuePanel extends StatelessWidget {
  const _RevenuePanel();

  @override
  Widget build(BuildContext context) => _Panel(
    title: 'Monthly performance',
    subtitle: 'Actual compared with operating plan',
    child: SizedBox(
      height: 280,
      child: BarChart(
        groups: groupedRevenue(),
        yAxis: ChartAxis.numeric(
          min: 0,
          max: 65,
          interval: 10,
          labelFormatter: compactCurrency,
        ),
        style: BarChartStyler()
            .palette(const [Color(0xFF4F46E5), Color(0xFFC7D2FE)])
            .axis(.label(.fontSize(10).color(const Color(0xFF64748B))))
            .grid(
              .showVertical(
                false,
              ).stroke(.color(const Color(0xFFE2E8F0)).width(1)),
            )
            .bar(.width(14).borderRadius(BorderRadius.circular(5)))
            .barSpacing(5)
            .groupSpacing(20)
            .frame(.showBorder(false).clip(true)),
      ),
    ),
  );
}

class _Panel extends StatelessWidget {
  const _Panel({this.title, this.subtitle, required this.child});

  final String? title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Theme.of(
          context,
        ).colorScheme.outlineVariant.withValues(alpha: .6),
      ),
      boxShadow: const [BoxShadow(color: Color(0x0F0F172A), blurRadius: 20)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 18),
        ],
        child,
      ],
    ),
  );
}
