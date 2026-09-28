import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:url_launcher/url_launcher.dart';

import 'catalog/catalog.dart';
import 'showcase/source_panel.dart';
import 'snacks/gallery.dart';
import 'snacks/theme.dart';
import 'ui/ui.dart';

const _ink = Color(0xFF0C1733);
const _muted = Color(0xFF62708E);
const _blue = Color(0xFF3468F5);
const _edge = Color(0xFFDCE4F0);
const _stage = Color(0xFFF3F6FA);

void main() => runApp(const MixExamplesApp());

/// A catalog of runnable examples wrapped in application-owned Remix recipes.
class MixExamplesApp extends StatelessWidget {
  const MixExamplesApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Mix Examples',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _blue),
      scaffoldBackgroundColor: const Color(0xFFFAFCFF),
      useMaterial3: true,
    ),
    builder: (context, child) => UiThemeScope(mode: .light, child: child!),
    home: const _CatalogHome(),
  );
}

void _open(BuildContext context, Widget page) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

class _PageScaffold extends StatelessWidget {
  const _PageScaffold({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Container(
            height: 54,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: _edge)),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1144),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) => Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst),
                          borderRadius: BorderRadius.circular(6),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              'Mix Examples',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: _ink,
                              ),
                            ),
                          ),
                        ),
                        if (constraints.maxWidth >= 330) ...[
                          const SizedBox(width: 14),
                          UiBadge.secondary(label: 'Mix 2'),
                        ],
                        const Spacer(),
                        if (constraints.maxWidth >= 400)
                          UiButton.ghost(
                            label: 'GitHub',
                            size: .small,
                            onPressed: () => unawaited(
                              launchUrl(
                                Uri.parse('https://github.com/btwld/mix'),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    ),
  );
}

class _CatalogHome extends StatelessWidget {
  const _CatalogHome();

  @override
  Widget build(BuildContext context) => _PageScaffold(
    child: _PageScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explore Mix',
            style: TextStyle(
              fontSize: 34,
              height: 1.1,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Runnable examples for styling, layout, motion, and charts.',
            style: TextStyle(fontSize: 16, color: _muted),
          ),
          const SizedBox(height: 28),
          for (final category in ExampleCategory.values) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    category.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () =>
                      _open(context, _CategoryPage(category: category)),
                  label: const Text('View all'),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                  iconAlignment: IconAlignment.end,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _EntryGrid(
              entries: category == ExampleCategory.snacks
                  ? [
                      for (final title in [
                        'Squish Switch',
                        'Spring Check',
                        'Swipe Row',
                      ])
                        examples.firstWhere((e) => e.title == title),
                    ]
                  : examplesFor(category),
              columns: category == ExampleCategory.core ? 4 : 3,
              compact: true,
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    ),
  );
}

class _PageScroll extends StatelessWidget {
  const _PageScroll({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 48),
    children: [
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1144),
          child: child,
        ),
      ),
    ],
  );
}

class _EntryGrid extends StatelessWidget {
  const _EntryGrid({
    required this.entries,
    required this.columns,
    this.compact = false,
  });
  final List<CatalogExample> entries;
  final int columns;
  final bool compact;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final count = constraints.maxWidth < 560
          ? 1
          : constraints.maxWidth < 850
          ? 2
          : columns;
      const gap = 12.0;
      final width = (constraints.maxWidth - gap * (count - 1)) / count;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final entry in entries)
            SizedBox(
              width: width,
              child: _ExampleTile(entry: entry, compact: compact),
            ),
        ],
      );
    },
  );
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({required this.entry, required this.compact});
  final CatalogExample entry;
  final bool compact;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => _open(
      context,
      entry.category == ExampleCategory.layouts
          ? const _CategoryPage(category: ExampleCategory.layouts)
          : _DetailPage(entry: entry),
    ),
    borderRadius: BorderRadius.circular(10),
    child: UiCard(
      style: CardStyler().padding(.all(11)).borderRadius(.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (compact)
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.asset(
                entry.previewAsset,
                width: double.infinity,
                height: 94,
                fit: BoxFit.cover,
                semanticLabel: '${entry.title} preview',
              ),
            )
          else
            IgnorePointer(child: _PreviewStage(entry: entry, height: 148)),
          const SizedBox(height: 10),
          Text(
            entry.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            entry.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, height: 1.25, color: _muted),
          ),
        ],
      ),
    ),
  );
}

class _PreviewStage extends StatelessWidget {
  const _PreviewStage({required this.entry, required this.height});
  final CatalogExample entry;
  final double height;

  @override
  Widget build(BuildContext context) {
    final snack = entry.snack != null;
    final chart = entry.category == ExampleCategory.charts;
    final lightSnack =
        snack && const {'Squish Switch', 'Peek Rating'}.contains(entry.title);
    final snackScale = height >= 400
        ? 1.8
        : height >= 260
        ? 1.5
        : 1.3;
    final demo = entry.preview(context);
    final live = snack
        ? Theme(
            data: snacksMaterialTheme(),
            child: MixScope(
              colors: snacksColors(),
              radii: snacksRadii(),
              child: demo,
            ),
          )
        : demo;
    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: snack && !lightSnack ? const Color(0xFF222632) : _stage,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: EdgeInsets.all(chart ? 10 : 12),
        child: Center(
          child: chart
              ? SizedBox(
                  width: double.infinity,
                  height: height - 20,
                  child: live,
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: snack
                      ? SizedBox(
                          width: 310 * snackScale,
                          height: 190 * snackScale,
                          child: Center(
                            child: Transform.scale(
                              scale: snackScale,
                              child: live,
                            ),
                          ),
                        )
                      : live,
                ),
        ),
      ),
    );
  }
}

class _CategoryPage extends StatefulWidget {
  const _CategoryPage({required this.category});
  final ExampleCategory category;

  @override
  State<_CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<_CategoryPage> {
  SnackGroup? _filter;

  static const _featuredSnackTitles = [
    'Squish Switch',
    'Hold Button',
    'Swipe Row',
    'Prompt Bar',
  ];

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final entries = examplesFor(category)
        .where((entry) => _filter == null || entry.snack?.group == _filter)
        .toList();
    final featuredSnacks = category != ExampleCategory.snacks
        ? <CatalogExample>[]
        : _filter == null
        ? [
            for (final title in _featuredSnackTitles)
              entries.firstWhere((entry) => entry.title == title),
          ]
        : entries.take(2).toList();
    final remainingSnacks = entries
        .where((entry) => !featuredSnacks.contains(entry))
        .toList();
    return _PageScaffold(
      child: _PageScroll(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Breadcrumbs(category: category),
            const SizedBox(height: 14),
            Text(
              category.title,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
            Text(
              category.description,
              style: const TextStyle(fontSize: 17, color: _muted),
            ),
            if (category == ExampleCategory.snacks) ...[
              const SizedBox(height: 22),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterButton(
                    label: 'All',
                    selected: _filter == null,
                    onTap: () => setState(() => _filter = null),
                  ),
                  for (final group in SnackGroup.values)
                    _FilterButton(
                      label: group.label,
                      selected: _filter == group,
                      onTap: () => setState(() => _filter = group),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            if (category == ExampleCategory.layouts)
              for (final entry in entries) ...[
                _ShowcaseRow(entry: entry),
                const SizedBox(height: 16),
              ]
            else if (category == ExampleCategory.snacks) ...[
              for (final entry in featuredSnacks) ...[
                _ShowcaseRow(entry: entry),
                const SizedBox(height: 20),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _filter == null
                          ? 'More to explore'
                          : 'More ${_filter!.label.toLowerCase()} examples',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                  ),
                  UiBadge.secondary(label: '${remainingSnacks.length} more'),
                ],
              ),
              const SizedBox(height: 12),
              _SnackDirectory(entries: remainingSnacks),
            ] else
              _EntryGrid(
                entries: entries,
                columns: category == ExampleCategory.core ? 4 : 3,
              ),
          ],
        ),
      ),
    );
  }
}

class _SnackDirectory extends StatelessWidget {
  const _SnackDirectory({required this.entries});
  final List<CatalogExample> entries;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth < 650 ? 1 : 2;
      const gap = 12.0;
      final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final entry in entries)
            SizedBox(
              width: width,
              child: InkWell(
                onTap: () => _open(context, _DetailPage(entry: entry)),
                borderRadius: BorderRadius.circular(10),
                child: UiCard(
                  style: CardStyler()
                      .padding(.all(16))
                      .borderRadius(.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.3,
                                color: _muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, color: _blue),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => UiButton(
    label: label,
    variant: selected ? .primary : .outline,
    size: .small,
    style: ButtonStyler().borderRadius(.circular(999)),
    onPressed: onTap,
  );
}

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs({required this.category, this.entry});
  final ExampleCategory category;
  final CatalogExample? entry;

  @override
  Widget build(BuildContext context) => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      TextButton(
        onPressed: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
        child: const Text('Examples'),
      ),
      const Text('/ ', style: TextStyle(color: _muted)),
      if (entry == null)
        Text(category.title, style: const TextStyle(color: _muted))
      else ...[
        TextButton(
          onPressed: () => _open(context, _CategoryPage(category: category)),
          child: Text(category.title),
        ),
        const Text('/ ', style: TextStyle(color: _muted)),
        Text(entry!.title, style: const TextStyle(color: _muted)),
      ],
    ],
  );
}

class _DetailPage extends StatelessWidget {
  const _DetailPage({required this.entry});
  final CatalogExample entry;

  @override
  Widget build(BuildContext context) {
    final siblings = examplesFor(entry.category);
    final index = siblings.indexOf(entry);
    return _PageScaffold(
      child: _PageScroll(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Breadcrumbs(category: entry.category, entry: entry),
            const SizedBox(height: 12),
            Text(
              entry.title,
              style: const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
            Text(
              entry.description,
              style: const TextStyle(fontSize: 18, color: _muted),
            ),
            const SizedBox(height: 24),
            _ShowcaseRow(entry: entry, showTitle: false),
            if (entry.category == ExampleCategory.layouts) ...[
              const SizedBox(height: 32),
              const Text(
                'More layout examples',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 16),
              for (final other in siblings.where((e) => e != entry)) ...[
                _ShowcaseRow(entry: other),
                const SizedBox(height: 16),
              ],
            ],
            const SizedBox(height: 28),
            const Divider(height: 32, color: _edge),
            Row(
              children: [
                if (index > 0)
                  TextButton.icon(
                    onPressed: () =>
                        _open(context, _DetailPage(entry: siblings[index - 1])),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: Text('Previous: ${siblings[index - 1].title}'),
                  ),
                const Spacer(),
                if (index < siblings.length - 1)
                  TextButton.icon(
                    onPressed: () =>
                        _open(context, _DetailPage(entry: siblings[index + 1])),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    iconAlignment: IconAlignment.end,
                    label: Text('Next: ${siblings[index + 1].title}'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowcaseRow extends StatelessWidget {
  const _ShowcaseRow({required this.entry, this.showTitle = true});
  final CatalogExample entry;
  final bool showTitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (showTitle) ...[
        Row(
          children: [
            Expanded(
              child: Text(
                entry.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
            ),
            if (entry.snack != null)
              TextButton.icon(
                onPressed: () => _open(context, _DetailPage(entry: entry)),
                label: const Text('Open example'),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                iconAlignment: IconAlignment.end,
              ),
          ],
        ),
        Text(entry.description, style: const TextStyle(color: _muted)),
        const SizedBox(height: 12),
      ],
      LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 800;
          final isSnackDetail = entry.snack != null && !showTitle;
          final previewHeight = entry.snack == null
              ? (wide ? 370.0 : 280.0)
              : isSnackDetail
              ? (wide ? 420.0 : 240.0)
              : (wide ? 320.0 : 220.0);
          final preview = _DetailPanel(
            title: 'Live preview',
            child: _PreviewStage(entry: entry, height: previewHeight),
          );
          final source = SourcePanel(
            path: entry.source,
            focusClass: entry.snack?.componentName,
            codeHeight: isSnackDetail ? 580 : 370,
            expandable: isSnackDetail,
          );
          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: preview),
                    const SizedBox(width: 16),
                    Expanded(child: source),
                  ],
                )
              : Column(children: [preview, const SizedBox(height: 16), source]);
        },
      ),
    ],
  );
}

class _DetailPanel extends StatelessWidget {
  const _DetailPanel({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => UiCard(
    style: CardStyler().padding(.all(16)).borderRadius(.circular(10)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}
