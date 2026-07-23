import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../theme.dart';

class DemoCard extends StatelessWidget {
  const DemoCard({
    super.key,
    required this.title,
    required this.caption,
    required this.child,
    this.height = 240,
  });

  final String title;
  final String caption;
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: demoCardStyler(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(caption, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 20),
          SizedBox(height: height, child: child),
        ],
      ),
    );
  }
}

class GalleryList extends StatelessWidget {
  const GalleryList({
    super.key,
    required this.title,
    required this.description,
    required this.children,
  });

  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey(title),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 6),
                Text(description, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.crossAxisExtent >= 900 ? 2 : 1;
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 380,
                ),
                delegate: SliverChildListDelegate(children),
              );
            },
          ),
        ),
      ],
    );
  }
}
