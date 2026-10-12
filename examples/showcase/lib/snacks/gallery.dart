import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'catalog.dart';
import 'theme.dart';
import 'widgets/demo_card.dart';

export 'catalog.dart';

class SnacksGalleryScreen extends StatefulWidget {
  const SnacksGalleryScreen({super.key});

  @override
  State<SnacksGalleryScreen> createState() => _SnacksGalleryScreenState();
}

class _SnacksGalleryScreenState extends State<SnacksGalleryScreen> {
  SnackGroup? _group;

  @override
  Widget build(BuildContext context) {
    final demos = [
      for (final demo in snackDemos)
        if (_group == null || demo.group == _group) demo,
    ];
    final GridBoxStyler catalog = .equalColumns(
      2,
    ).gap(16).onConstraints(.maxWidth(720), .equalColumns(1).gap(12));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ColumnBox(
            style: FlexBoxStyler()
                .padding(.all(24))
                .spacing(8)
                .crossAxisAlignment(.start),
            children: [
              StyledText('Mix Snacks', style: snacksTitle().fontSize(32)),
              StyledText(
                'The React Bits /c/micro catalog, rebuilt with Mix stylers, springs, and keyframes.',
                style: snacksMuted(15),
              ),
              const SizedBox(height: 8),
              WrapBox(
                style: WrapBoxStyler().spacing(8).runSpacing(8),
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _group == null,
                    onPress: () => setState(() => _group = null),
                  ),
                  for (final group in SnackGroup.values)
                    _FilterChip(
                      label: group.label,
                      selected: _group == group,
                      onPress: () => setState(() => _group = group),
                    ),
                ],
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          sliver: SliverToBoxAdapter(
            child: GridBox(
              key: const Key('snacks-catalog'),
              style: catalog,
              children: [
                for (final demo in demos)
                  DemoCard(
                    key: Key('demo-${demo.title}'),
                    title: demo.title,
                    caption: demo.caption,
                    sourceAsset: demo.sourceAsset,
                    child: demo.builder(context),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onPress,
  });

  final String label;
  final bool selected;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return PressableBox(
      onPress: onPress,
      style: BoxStyler()
          .padding(.horizontal(12))
          .padding(.vertical(8))
          .shape(.stadium())
          .color(selected ? $ink() : $track())
          .onPressed(.scale(0.97))
          .animate(.spring(280.ms, bounce: 0.08)),
      child: StyledText(
        label,
        style: TextStyler()
            .fontSize(12)
            .fontWeight(.w600)
            .color(selected ? $page() : $ink()),
      ),
    );
  }
}
