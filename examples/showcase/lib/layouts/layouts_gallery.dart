import 'package:flutter/material.dart';

import 'grid/grid_example.dart';
import 'wrap/main.dart';

/// Opens the two interactive layout galleries from the shared examples app.
class LayoutsGalleryScreen extends StatelessWidget {
  const LayoutsGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Layouts', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('Explore responsive WrapBox and GridBox layouts.'),
        const SizedBox(height: 24),
        ListTile(
          title: const Text('WrapBox'),
          subtitle: const Text('Flow chips and tags onto new lines.'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const WrapBoxExampleScreen(),
            ),
          ),
        ),
        ListTile(
          title: const Text('GridBox'),
          subtitle: const Text('Responsive tracks, cards, and dashboards.'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => Theme(
                data: gridExampleTheme,
                child: const GridBoxExampleScreen(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
