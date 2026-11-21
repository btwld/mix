import 'package:flutter/material.dart';
import 'package:mix_chart/mix_chart.dart';

import '../data.dart';
import '../widgets/demo_card.dart';

class PieGallery extends StatelessWidget {
  const PieGallery({super.key});

  @override
  Widget build(BuildContext context) => const GalleryList(
    title: 'Pie & donut',
    description:
        'Slices, labels, badges, corners, selection, and safe empty states.',
    children: [_ChannelPieDemo(), _DonutDemo(), _BadgeDemo(), _EmptyDemo()],
  );
}

class _ChannelPieDemo extends StatelessWidget {
  const _ChannelPieDemo();

  @override
  Widget build(BuildContext context) => DemoCard(
    title: 'Traffic channels',
    caption: 'A direct-value palette and generated nested label styling.',
    child: PieChart(
      semanticsLabel: 'Traffic by device',
      slices: channelSlices(),
      valueFormatter: (value) => '${value.toInt()}%',
      style: PieChartStyler()
          .palette(const [
            Color(0xFF6366F1),
            Color(0xFF06B6D4),
            Color(0xFFF97316),
            Color(0xFFEC4899),
          ])
          .startAngle(-90)
          .sliceSpacing(3)
          .slice(
            .radius(84)
                .label(.fontSize(11).fontWeight(FontWeight.w700))
                .labelPosition(.62)
                .cornerRadius(5),
          ),
    ),
  );
}

class _DonutDemo extends StatefulWidget {
  const _DonutDemo();

  @override
  State<_DonutDemo> createState() => _DonutDemoState();
}

class _DonutDemoState extends State<_DonutDemo> {
  Object? _selected = 'core';

  @override
  Widget build(BuildContext context) => DemoCard(
    title: 'Interactive product mix',
    caption: 'Donut selection expands one stable slice ID.',
    child: PieChart(
      slices: productSlices(),
      selectedSliceIds: {?_selected},
      onSliceTap: (hit) => setState(() => _selected = hit.sliceId),
      valueFormatter: (value) => '${value.toInt()}%',
      style: PieChartStyler()
          .palette(const [
            Color(0xFF0EA5E9),
            Color(0xFF14B8A6),
            Color(0xFFF59E0B),
          ])
          .centerRadius(54)
          .centerColor(Theme.of(context).colorScheme.surface)
          .sliceSpacing(4)
          .slice(.radius(68).showLabel(false).cornerRadius(7))
          .tooltip(
            .backgroundColor(const Color(0xFF0F172A))
                .borderRadius(BorderRadius.circular(12))
                .padding(
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                ),
          ),
    ),
  );
}

class _BadgeDemo extends StatelessWidget {
  const _BadgeDemo();

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.phone_iphone,
      Icons.laptop_mac,
      Icons.tablet,
      Icons.tv,
    ];
    final source = channelSlices();

    return DemoCard(
      title: 'Ordinary Flutter badges',
      caption: 'Badge widgets cross the API boundary without renderer types.',
      child: PieChart(
        slices: [
          for (var index = 0; index < source.length; index++)
            PieSlice(
              id: source[index].id,
              label: source[index].label,
              value: source[index].value,
              badge: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    icons[index],
                    size: 15,
                    color: const Color(0xFF334155),
                  ),
                ),
              ),
            ),
        ],
        style: PieChartStyler()
            .palette(const [
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
              Color(0xFFF97316),
              Color(0xFFEAB308),
            ])
            .centerRadius(32)
            .slice(.radius(70).showLabel(false).badgePosition(.92)),
      ),
    );
  }
}

class _EmptyDemo extends StatelessWidget {
  const _EmptyDemo();

  @override
  Widget build(BuildContext context) => DemoCard(
    title: 'Safe empty state',
    caption: 'Empty and all-zero data never reaches renderer division.',
    child: Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          semanticsLabel: 'No channel data',
          slices: [PieSlice(id: 'empty', label: 'No data', value: 0)],
          style: PieChartStyler().centerRadius(52),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 6),
            const Text('No data yet'),
          ],
        ),
      ],
    ),
  );
}
