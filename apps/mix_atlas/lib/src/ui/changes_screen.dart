import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

import '../app_controller.dart';
import 'atlas_theme.dart';
import 'common.dart';

class AtlasChangesScreen extends StatelessWidget {
  const AtlasChangesScreen({required this.controller, super.key});

  final AtlasAppController controller;

  void _open(AtlasDeclaredChange change) {
    if (change.category == .tokenDefinition &&
        change.tokenKind != null &&
        change.tokenName != null) {
      controller.selectToken(kind: change.tokenKind!, name: change.tokenName!);
      controller.navigate(.tokenUsage);

      return;
    }
    final componentId = change.componentId;
    if (componentId != null &&
        controller.reviewContext?.componentId != componentId &&
        controller.current!.componentDocuments.any(
          (component) => component.id == componentId,
        )) {
      controller.selectComponent(componentId);
    }
    final component = controller.current!.componentDocuments
        .where((item) => item.id == componentId)
        .firstOrNull;
    final recipeId = change.recipeId;
    if (component != null &&
        recipeId != null &&
        component.recipes.any((recipe) => recipe.id == recipeId)) {
      controller.selectCell(
        recipeId: recipeId,
        stateId:
            controller.reviewContext?.stateId ??
            component.states.keys.firstOrNull ??
            'default',
      );
    }
    if (change.themeId case final themeId?
        when controller.current!.manifest.themes.any(
          (theme) => theme.id == themeId,
        )) {
      controller.selectTheme(themeId);
    }
    final slotId = change.slotId;
    if (component != null &&
        slotId != null &&
        component.slots.containsKey(slotId)) {
      controller.selectSlot(slotId);
    }
    final evidence =
        [
          ...?controller.currentIndex?.propertyEvidence,
          ...?controller.baselineIndex?.propertyEvidence,
        ].where((item) {
          if (change.sourcePath != null &&
              item.sourcePath != change.sourcePath) {
            return false;
          }
          if (change.jsonPointer != null &&
              item.jsonPointer != change.jsonPointer) {
            return false;
          }
          if (change.themeId != null && item.themeId != change.themeId) {
            return false;
          }

          return change.property == null || item.property == change.property;
        }).firstOrNull;
    if (evidence != null) controller.selectProperty(evidence);
    controller.navigate(.compare);
  }

  @override
  Widget build(BuildContext context) {
    if (controller.baseline == null || controller.current == null) {
      return const AtlasEmptyState(
        title: 'Comparison unavailable',
        message:
            'Changes require the main baseline capture. Catalog and Inspect remain available for the current revision.',
        icon: Icons.link_off,
      );
    }
    final comparison = AtlasCaptureComparison.compare(
      controller.baseline!,
      controller.current!,
      baselineIndex: controller.baselineIndex,
      currentIndex: controller.currentIndex,
    );
    if (!comparison.compatibility.isCompatible) {
      return AtlasEmptyState(
        title: 'Captures cannot be compared',
        message:
            comparison.compatibility.reason ??
            'The selected captures use incompatible contracts.',
        icon: Icons.link_off,
      );
    }
    if (!comparison.hasChanges) {
      return const AtlasEmptyState(
        title: 'No declared changes',
        message:
            'Baseline and current resolve to the same capture data. Atlas found no added, removed, or modified declared evidence.',
        icon: Icons.check_circle_outline,
      );
    }
    final changes = comparison.changes;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .fromLTRB(24, 20, 24, 18),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Declared changes',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(fontWeight: .w700),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Clipboard.setData(
                      ClipboardData(text: _copySummary(controller, comparison)),
                    ),
                    tooltip: 'Copy change summary',
                    icon: const Icon(Icons.copy_all_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'Capture evidence changed; this is not a claim of visual regression, runtime impact, or a release decision.',
                style: TextStyle(color: AtlasPalette.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AtlasBadge(
                    '${comparison.count(kind: .added)} added',
                    success: true,
                  ),
                  AtlasBadge(
                    '${comparison.count(kind: .removed)} removed',
                    warning: true,
                  ),
                  AtlasBadge('${comparison.count(kind: .modified)} modified'),
                  for (final category in AtlasDeclaredChangeCategory.values)
                    if (comparison.count(category: category) > 0)
                      AtlasBadge(
                        '${comparison.count(category: category)} ${_categoryLabel(category)}',
                      ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            padding: const .all(22),
            itemBuilder: (context, index) => _ChangeRow(
              change: changes[index],
              onOpen: () => _open(changes[index]),
            ),
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemCount: changes.length,
          ),
        ),
      ],
    );
  }
}

String _copySummary(
  AtlasAppController controller,
  AtlasCaptureComparison comparison,
) {
  final review = controller.reviewContext;
  final repository =
      review?.repository ?? controller.current!.receipt.repository;
  final baselineRef = review?.baselineRef ?? 'main';
  final currentRef =
      review?.currentRef ?? controller.current!.receipt.requestedRef;
  final lines = [
    'Mix Atlas declared change summary',
    '$repository · $baselineRef → $currentRef',
    '${comparison.count(kind: .added)} added · '
        '${comparison.count(kind: .removed)} removed · '
        '${comparison.count(kind: .modified)} modified',
    '',
    for (final change in comparison.changes)
      [
        change.kind.name,
        change.category.name,
        change.id,
        ?change.sourcePath,
        ?change.jsonPointer,
      ].join('\t'),
  ];

  return lines.join('\n');
}

class _ChangeRow extends StatelessWidget {
  const _ChangeRow({required this.change, required this.onOpen});

  final AtlasDeclaredChange change;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final canOpen = change.componentId != null || change.tokenName != null;
    final tokenChange = change.category == .tokenDefinition;

    return AtlasPanel(
      padding: const .symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(_icon(change.kind), size: 18, color: _color(change.kind)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 3,
              children: [
                Text(
                  change.id,
                  style: const TextStyle(fontSize: 12, fontWeight: .w600),
                ),
                Text(
                  [
                    _categoryTitle(change.category),
                    ?change.sourcePath,
                    ?change.jsonPointer,
                  ].join(' · '),
                  style: const TextStyle(
                    color: AtlasPalette.textMuted,
                    fontSize: 11,
                  ),
                  overflow: .ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          AtlasBadge(
            change.kind.name,
            warning: change.kind == .removed,
            success: change.kind == .added,
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: canOpen ? onOpen : null,
            child: Text(tokenChange ? 'Token Usage' : 'Compare'),
          ),
        ],
      ),
    );
  }
}

IconData _icon(AtlasDeclaredChangeKind kind) => switch (kind) {
  .added => Icons.add_circle_outline,
  .removed => Icons.remove_circle_outline,
  .modified => Icons.change_circle_outlined,
};

Color _color(AtlasDeclaredChangeKind kind) => switch (kind) {
  .added => AtlasPalette.success,
  .removed => AtlasPalette.warning,
  .modified => AtlasPalette.accent,
};

String _categoryLabel(AtlasDeclaredChangeCategory category) =>
    switch (category) {
      .component => 'components',
      .recipe => 'recipes',
      .theme => 'themes',
      .slot => 'slots',
      .styleTerm => 'style terms',
      .tokenDefinition => 'token definitions',
      .tokenReference => 'token references',
      .diagnostic => 'diagnostics',
      .visualOracle => 'oracle hashes',
    };

String _categoryTitle(AtlasDeclaredChangeCategory category) =>
    switch (category) {
      .component => 'Portable component',
      .recipe => 'Component recipe',
      .theme => 'Captured theme',
      .slot => 'Anatomy slot',
      .styleTerm => 'Declared style term',
      .tokenDefinition => 'Theme token definition',
      .tokenReference => 'Exact token reference',
      .diagnostic => 'Structured diagnostic',
      .visualOracle => 'Rendered contact-sheet oracle',
    };
