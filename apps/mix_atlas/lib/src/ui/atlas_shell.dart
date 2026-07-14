import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../models/destination.dart';
import 'atlas_theme.dart';
import 'catalog_screen.dart';
import 'changes_screen.dart';
import 'compare_screen.dart';
import 'inspect_screen.dart';
import 'source_landing.dart';
import 'token_usage_screen.dart';
import 'common.dart';

class AtlasShell extends StatelessWidget {
  const AtlasShell({required this.controller, super.key});

  final AtlasAppController controller;

  Widget _body() => switch (controller.loadState) {
    .empty || .error => AtlasSourceLanding(controller: controller),
    .loading => const _LoadingState(),
    .ready => Row(
      children: [
        _ComponentSidebar(controller: controller),
        const VerticalDivider(width: 1),
        Expanded(
          child: Column(
            children: [
              if (controller.baselineLoadError != null)
                _BaselineWarning(controller: controller),
              Expanded(child: _screen()),
            ],
          ),
        ),
      ],
    ),
  };

  Widget _screen() => switch (controller.destination) {
    .catalog => AtlasCatalogScreen(controller: controller),
    .changes => AtlasChangesScreen(controller: controller),
    .compare => AtlasCompareScreen(controller: controller),
    .inspect => AtlasInspectScreen(controller: controller),
    .tokenUsage => AtlasTokenUsageScreen(controller: controller),
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        _Header(controller: controller),
        const Divider(height: 1),
        Expanded(child: _body()),
      ],
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final AtlasAppController controller;

  @override
  Widget build(BuildContext context) {
    final capture = controller.current;
    final review = controller.reviewContext;

    return SizedBox(
      height: 68,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showReceipt = capture != null && constraints.maxWidth >= 1100;
          final compactControls = constraints.maxWidth < 760;

          return Padding(
            padding: const .symmetric(horizontal: 18),
            child: Row(
              children: [
                const Icon(Icons.grid_view_rounded, color: AtlasPalette.accent),
                const SizedBox(width: 9),
                const Text(
                  'Mix Atlas',
                  style: TextStyle(fontSize: 16, fontWeight: .w700),
                ),
                if (showReceipt) ...[
                  const SizedBox(width: 18),
                  Container(color: AtlasPalette.border, width: 1, height: 26),
                  const SizedBox(width: 18),
                  Flexible(
                    child: Text(
                      '${review?.repository ?? capture.receipt.repository}  ·  '
                      '${review?.baselineRef ?? 'main'} → ${review?.currentRef ?? capture.receipt.requestedRef}  ·  '
                      '${shortCommit(capture.receipt.resolvedCommit)}',
                      style: const TextStyle(
                        color: AtlasPalette.textMuted,
                        fontSize: 12,
                      ),
                      overflow: .ellipsis,
                    ),
                  ),
                ],
                const Spacer(),
                if (capture != null) ...[
                  _NavButton(
                    label: 'Catalog',
                    selected: controller.destination == .catalog,
                    onPressed: () => controller.navigate(.catalog),
                  ),
                  _NavButton(
                    label: 'Changes',
                    selected: controller.destination == .changes,
                    onPressed: controller.hasCompatibleComparison
                        ? () => controller.navigate(.changes)
                        : null,
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<AtlasDestination>(
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: AtlasDestination.compare,
                        enabled: controller.hasCompatibleComparison,
                        child: const Text('Compare'),
                      ),
                      const PopupMenuItem(
                        value: AtlasDestination.inspect,
                        child: Text('Inspect'),
                      ),
                      const PopupMenuItem(
                        value: AtlasDestination.tokenUsage,
                        child: Text('Token Usage'),
                      ),
                    ],
                    onSelected: controller.navigate,
                    tooltip: 'Review mode',
                    child: Padding(
                      padding: const .symmetric(vertical: 8, horizontal: 8),
                      child: compactControls
                          ? const Icon(Icons.more_horiz, size: 20)
                          : const Row(
                              children: [
                                Text('Review'),
                                Icon(Icons.expand_more, size: 18),
                              ],
                            ),
                    ),
                  ),
                  if (!compactControls) ...[
                    const SizedBox(width: 8),
                    _ThemePicker(controller: controller),
                  ],
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BaselineWarning extends StatelessWidget {
  const _BaselineWarning({required this.controller});

  final AtlasAppController controller;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: 'Baseline unavailable',
    child: Container(
      padding: const .symmetric(vertical: 10, horizontal: 20),
      color: AtlasPalette.warningSoft,
      width: .infinity,
      child: Row(
        crossAxisAlignment: .start,
        spacing: 12,
        children: [
          const Padding(
            padding: .only(top: 1),
            child: Icon(
              Icons.warning_amber_rounded,
              size: 20,
              color: AtlasPalette.warning,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 3,
              children: [
                const Text(
                  'Baseline unavailable',
                  style: TextStyle(fontWeight: .w700),
                ),
                Text(
                  'The current capture is open. Catalog and Inspect remain '
                  'available; Changes and Compare require the '
                  '${controller.reviewContext?.baselineRef ?? 'main'} '
                  'baseline.',
                  style: const TextStyle(
                    color: AtlasPalette.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Tooltip(
            message:
                controller.baselineLoadError?.toString() ??
                'Baseline failed to load.',
            child: const Icon(
              Icons.info_outline,
              size: 18,
              color: AtlasPalette.textMuted,
            ),
          ),
        ],
      ),
    ),
  );
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: selected ? AtlasPalette.accent : AtlasPalette.textMuted,
      backgroundColor: selected ? AtlasPalette.accentSoft : Colors.transparent,
    ),
    child: Text(label),
  );
}

class _ThemePicker extends StatelessWidget {
  const _ThemePicker({required this.controller});

  final AtlasAppController controller;

  @override
  Widget build(BuildContext context) {
    final themes = controller.current!.manifest.themes;
    final selected = controller.reviewContext?.themeId;

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        items: [
          for (final theme in themes)
            DropdownMenuItem(value: theme.id, child: Text(theme.id)),
        ],
        value: themes.any((theme) => theme.id == selected)
            ? selected
            : themes.first.id,
        onChanged: (value) {
          if (value != null) controller.selectTheme(value);
        },
      ),
    );
  }
}

class _ComponentSidebar extends StatefulWidget {
  const _ComponentSidebar({required this.controller});

  final AtlasAppController controller;

  @override
  State<_ComponentSidebar> createState() => _ComponentSidebarState();
}

class _ComponentSidebarState extends State<_ComponentSidebar> {
  var query = '';

  @override
  Widget build(BuildContext context) {
    final components = widget.controller.current!.catalog.components
        .where(
          (component) =>
              component.label.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    final selected = widget.controller.reviewContext?.componentId;

    return SizedBox(
      width: 238,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Padding(
            padding: const .all(14),
            child: TextField(
              key: const ValueKey('component-search'),
              decoration: const InputDecoration(
                hintText: 'Search components',
                isDense: true,
                prefixIcon: Icon(Icons.search, size: 19),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          Padding(
            padding: const .fromLTRB(16, 2, 16, 8),
            child: Text(
              '${components.length} captured components',
              style: const TextStyle(
                color: AtlasPalette.textMuted,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const .symmetric(horizontal: 8),
              children: [
                for (final component in components)
                  ListTile(
                    leading: const Icon(Icons.widgets_outlined, size: 18),
                    title: Text(
                      component.label,
                      style: const TextStyle(fontSize: 13),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                    onTap: () =>
                        widget.controller.selectComponent(component.id),
                    selected: component.id == selected,
                    selectedTileColor: AtlasPalette.accentSoft,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: 'Validating capture files and protocol documents',
    child: ExcludeSemantics(
      child: Row(
        key: const ValueKey('capture-loading-skeleton'),
        children: [
          Container(
            padding: const .all(14),
            color: AtlasPalette.surface,
            width: 238,
            child: const Column(
              crossAxisAlignment: .stretch,
              children: [
                _SkeletonBlock(height: 42),
                SizedBox(height: 18),
                _SkeletonBlock(width: 112, height: 10),
                SizedBox(height: 18),
                _SkeletonBlock(height: 38),
                SizedBox(height: 8),
                _SkeletonBlock(height: 38),
                SizedBox(height: 8),
                _SkeletonBlock(height: 38),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(
              padding: const .all(28),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Validating capture files and protocol documents…',
                          style: TextStyle(
                            color: AtlasPalette.textMuted,
                            fontSize: 12,
                          ),
                          overflow: .ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const _SkeletonBlock(width: 238, height: 24),
                  const SizedBox(height: 10),
                  const _SkeletonBlock(width: 420, height: 12),
                  const SizedBox(height: 28),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 900 ? 3 : 2;
                        final spacing = 14.0;
                        final width =
                            (constraints.maxWidth - spacing * (columns - 1)) /
                            columns;

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            for (var index = 0; index < columns * 2; index += 1)
                              _SkeletonBlock(width: width, height: 148),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({this.width, required this.height});

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AtlasPalette.surfaceMuted,
      border: .all(color: AtlasPalette.border),
      borderRadius: .circular(8),
    ),
    width: width,
    height: height,
  );
}
