import 'package:flutter/material.dart';

import 'grid/grid_example.dart';
import 'wrap/main.dart';

/// Opens the layout catalog. Each gallery also has its own entry point.
void main() => runApp(const LayoutsApp());

/// A small launcher for the responsive layout examples.
class LayoutsApp extends StatelessWidget {
  const LayoutsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mix Layouts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B5BD6)),
        scaffoldBackgroundColor: const Color(0xFFF5F5FA),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Mix Layouts')),
        body: Builder(
          builder: (context) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
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
                subtitle: const Text(
                  'Responsive tracks, cards, and dashboards.',
                ),
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
          ),
        ),
      ),
    );
  }
}
