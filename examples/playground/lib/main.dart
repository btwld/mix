import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'basics/getting_started.dart';
import 'layouts/layouts_gallery.dart';
import 'snacks/gallery.dart';
import 'snacks/theme.dart';
import 'ui/ui.dart';

const _uiTheme = UiThemeData.light();

final _titleStyle = TextStyler()
    .fontSize(24)
    .fontWeight(.w700)
    .color(UiTokens.foreground());
final _descriptionStyle = TextStyler()
    .fontSize(14)
    .color(UiTokens.mutedForeground());

void main() => runApp(const MixExamplesApp());

/// One home for the introductory lesson, layout galleries, and Mix snacks.
class MixExamplesApp extends StatelessWidget {
  const MixExamplesApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Mix examples',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _uiTheme.primary),
      scaffoldBackgroundColor: _uiTheme.background,
    ),
    builder: (context, child) => UiThemeScope(mode: .light, child: child!),
    home: const _ExamplesHome(),
  );
}

enum _Section { basics, layouts, snacks }

class _ExamplesHome extends StatefulWidget {
  const _ExamplesHome();

  @override
  State<_ExamplesHome> createState() => _ExamplesHomeState();
}

class _ExamplesHomeState extends State<_ExamplesHome> {
  _Section _section = _Section.basics;

  void _selectSection(int index) {
    setState(() => _section = _Section.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    final content = switch (_section) {
      _Section.basics => const GettingStartedDemo(),
      _Section.layouts => const LayoutsGalleryScreen(),
      _Section.snacks => Theme(
        data: snacksMaterialTheme(),
        child: MixScope(
          colors: snacksColors(),
          radii: snacksRadii(),
          child: const ColoredBox(
            color: Color(0xFF07070B),
            child: SnacksGalleryScreen(),
          ),
        ),
      ),
    };

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 720;
            return Padding(
              padding: EdgeInsets.all(compact ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  UiCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _titleStyle('Mix examples'),
                                  const SizedBox(height: 4),
                                  _descriptionStyle(
                                    'Small lessons for expressive Flutter styling.',
                                  ),
                                ],
                              ),
                            ),
                            const UiBadge.secondary(label: 'Mix 2'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final section in _Section.values)
                              UiButton(
                                label: _sectionLabel(section),
                                variant: _section == section
                                    ? .primary
                                    : .secondary,
                                size: .small,
                                onPressed: () => _selectSection(section.index),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: content),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _sectionLabel(_Section section) => switch (section) {
    _Section.basics => 'Basics',
    _Section.layouts => 'Layouts',
    _Section.snacks => 'Snacks',
  };
}
