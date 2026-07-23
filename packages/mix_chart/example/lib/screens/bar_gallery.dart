import 'package:flutter/material.dart';
import 'package:mix_chart/mix_chart.dart';

import '../data.dart';
import '../widgets/demo_card.dart';

class BarGallery extends StatelessWidget {
  const BarGallery({super.key});

  @override
  Widget build(BuildContext context) => const GalleryList(
    title: 'Bar charts',
    description:
        'Grouped, stacked, floating, gradient, labeled, and tracked bars.',
    children: [_GroupedDemo(), _StackedDemo(), _FloatingDemo(), _TrackedDemo()],
  );
}

BarChartStyler _barStyle(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return BarChartStyler()
      .frame(.showBorder(false).clip(true))
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
      .bar(.width(15).borderRadius(BorderRadius.circular(6)))
      .groupSpacing(20)
      .barSpacing(5);
}

class _GroupedDemo extends StatelessWidget {
  const _GroupedDemo();

  @override
  Widget build(BuildContext context) => DemoCard(
    title: 'Actual vs plan',
    caption: 'Grouped bars use stable local IDs and a concise shared style.',
    child: BarChart(
      semanticsLabel: 'Monthly actual and planned revenue',
      groups: groupedRevenue(),
      yAxis: ChartAxis.numeric(
        min: 0,
        max: 65,
        interval: 10,
        labelFormatter: compactCurrency,
      ),
      style: _barStyle(
        context,
      ).palette(const [Color(0xFF6366F1), Color(0xFFC7D2FE)]),
    ),
  );
}

class _StackedDemo extends StatelessWidget {
  const _StackedDemo();

  @override
  Widget build(BuildContext context) => DemoCard(
    title: 'Revenue mix',
    caption: 'Stacked segments are public models with their own Mix Styler.',
    child: BarChart(
      groups: stackedRevenue(),
      yAxis: ChartAxis.numeric(
        min: 0,
        max: 65,
        interval: 10,
        labelFormatter: compactCurrency,
      ),
      style: _barStyle(context)
          .palette(const [Color(0xFF0EA5E9), Color(0xFF14B8A6)])
          .bar(.width(24).borderRadius(BorderRadius.circular(7)))
          .segment(.border(const BorderSide(color: Colors.white, width: 1))),
    ),
  );
}

class _FloatingDemo extends StatelessWidget {
  const _FloatingDemo();

  @override
  Widget build(BuildContext context) => DemoCard(
    title: 'Floating changes',
    caption: 'fromY and toY support gains, declines, and range-style marks.',
    child: BarChart(
      groups: floatingChanges(),
      yAxis: ChartAxis.numeric(min: 8, max: 34, interval: 5),
      style: _barStyle(context)
          .palette(const [Color(0xFFF97316)])
          .bar(
            .width(22)
                .gradient(
                  const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFFF97316), Color(0xFFFBBF24)],
                  ),
                )
                .borderRadius(BorderRadius.circular(8)),
          ),
    ),
  );
}

class _TrackedDemo extends StatefulWidget {
  const _TrackedDemo();

  @override
  State<_TrackedDemo> createState() => _TrackedDemoState();
}

class _TrackedDemoState extends State<_TrackedDemo> {
  BarSelectionKey? _selected;

  @override
  Widget build(BuildContext context) => DemoCard(
    title: 'Tracks, labels & selection',
    caption: 'Tap a bar to derive selection from its scoped public key.',
    child: BarChart(
      groups: [
        for (final group in groupedRevenue())
          BarGroup(id: group.id, label: group.label, bars: [group.bars.first]),
      ],
      selectedItems: {?_selected},
      onBarTap: (hit) => setState(() => _selected = hit.selectionKey),
      yAxis: ChartAxis.numeric(min: 0, max: 65, interval: 10),
      style: _barStyle(context)
          .palette(const [Color(0xFF8B5CF6)])
          .bar(
            .width(20)
                .label(.fontSize(10).fontWeight(FontWeight.w700))
                .background(
                  .show(true)
                      .fromY(0)
                      .toY(65)
                      .color(
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF293548)
                            : const Color(0xFFEEF2FF),
                      ),
                ),
          ),
    ),
  );
}
