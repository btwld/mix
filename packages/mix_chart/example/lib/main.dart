import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'screens/bar_gallery.dart';
import 'screens/dashboard_screen.dart';
import 'screens/line_gallery.dart';
import 'screens/pie_gallery.dart';
import 'screens/playground_screen.dart';
import 'theme.dart';

const _initialScreen = int.fromEnvironment('MIX_CHART_SCREEN');
const _initialDark = bool.fromEnvironment('MIX_CHART_DARK');

void main() => runApp(const GalleryApp());

class GalleryApp extends StatefulWidget {
  const GalleryApp({super.key});

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  Brightness _brightness = _initialDark ? Brightness.dark : Brightness.light;
  DemoThemePreset _preset = DemoThemePreset.indigo;

  void _toggleBrightness() => setState(() {
    _brightness = _brightness == Brightness.light
        ? Brightness.dark
        : Brightness.light;
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mix_chart gallery',
      theme: galleryMaterialTheme(_preset, _brightness),
      builder: (context, child) {
        final inheritedMedia = MediaQuery.of(context);
        return MediaQuery(
          data: inheritedMedia.copyWith(platformBrightness: _brightness),
          child: MixScope(
            tokens: demoTokens(_preset, _brightness),
            child: child!,
          ),
        );
      },
      home: GalleryShell(
        brightness: _brightness,
        preset: _preset,
        onToggleBrightness: _toggleBrightness,
        onPresetChanged: (value) => setState(() => _preset = value),
      ),
    );
  }
}

// Kept as a compatibility alias for the original example and downstream tests.
class DashboardApp extends GalleryApp {
  const DashboardApp({super.key});
}

class GalleryShell extends StatefulWidget {
  const GalleryShell({
    super.key,
    required this.brightness,
    required this.preset,
    required this.onToggleBrightness,
    required this.onPresetChanged,
  });

  final Brightness brightness;
  final DemoThemePreset preset;
  final VoidCallback onToggleBrightness;
  final ValueChanged<DemoThemePreset> onPresetChanged;

  @override
  State<GalleryShell> createState() => _GalleryShellState();
}

class _GalleryShellState extends State<GalleryShell> {
  int _selectedIndex = _initialScreen;

  static const _screens = <Widget>[
    LineGallery(),
    BarGallery(),
    PieGallery(),
    PlaygroundScreen(),
    DashboardScreen(),
  ];

  static const _destinations = <NavigationDestination>[
    NavigationDestination(icon: Icon(Icons.show_chart), label: 'Line'),
    NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Bar'),
    NavigationDestination(icon: Icon(Icons.pie_chart), label: 'Pie'),
    NavigationDestination(icon: Icon(Icons.tune), label: 'Playground'),
    NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
  ];

  void _select(int value) => setState(() => _selectedIndex = value);

  @override
  Widget build(BuildContext context) {
    final dark = widget.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 840;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
          appBar: AppBar(
            title: const Text('mix_chart'),
            actions: [
              PopupMenuButton<DemoThemePreset>(
                key: const Key('theme-preset-switcher'),
                tooltip: 'Theme preset: ${widget.preset.label}',
                icon: const Icon(Icons.palette_outlined),
                initialValue: widget.preset,
                onSelected: widget.onPresetChanged,
                itemBuilder: (context) => [
                  for (final preset in DemoThemePreset.values)
                    PopupMenuItem(value: preset, child: Text(preset.label)),
                ],
              ),
              IconButton(
                tooltip: dark ? 'Use light mode' : 'Use dark mode',
                icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
                onPressed: widget.onToggleBrightness,
              ),
            ],
          ),
          body: isWide
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: _select,
                      labelType: NavigationRailLabelType.all,
                      destinations: [
                        for (final destination in _destinations)
                          NavigationRailDestination(
                            icon: destination.icon,
                            selectedIcon: destination.selectedIcon,
                            label: Text(destination.label),
                          ),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: _screens[_selectedIndex]),
                  ],
                )
              : _screens[_selectedIndex],
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _select,
                  destinations: _destinations,
                ),
        );
      },
    );
  }
}
