import 'package:flutter/material.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

import '../app_controller.dart';
import 'atlas_theme.dart';
import 'common.dart';

class AtlasCatalogScreen extends StatelessWidget {
  const AtlasCatalogScreen({required this.controller, super.key});

  final AtlasAppController controller;

  @override
  Widget build(BuildContext context) {
    final capture = controller.current!;
    final selectedId = controller.reviewContext?.componentId;
    final catalogComponent = capture.catalog.components
        .where((component) => component.id == selectedId)
        .firstOrNull;
    final component = capture.componentDocuments
        .where((document) => document.id == selectedId)
        .firstOrNull;
    final themeId =
        controller.reviewContext?.themeId ?? capture.manifest.themes.first.id;
    if (component == null) {
      return catalogComponent == null
          ? const AtlasEmptyState(
              title: 'Captured component is unavailable',
              message: 'Choose another component from the catalog.',
            )
          : _RenderedCatalog(
              capture: capture,
              component: catalogComponent,
              themeId: themeId,
            );
    }

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _CatalogTitle(controller: controller, component: component),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const .all(22),
            child: AtlasPanel(
              padding: const .all(0),
              child: SingleChildScrollView(
                scrollDirection: .horizontal,
                child: _RecipeMatrix(
                  controller: controller,
                  capture: capture,
                  component: component,
                  themeId: themeId,
                ),
              ),
            ),
          ),
        ),
        _SelectionBar(controller: controller),
      ],
    );
  }
}

class _RenderedCatalog extends StatelessWidget {
  const _RenderedCatalog({
    required this.capture,
    required this.component,
    required this.themeId,
  });

  final AtlasCapture capture;
  final AtlasCatalogComponent component;
  final String themeId;

  @override
  Widget build(BuildContext context) {
    final asset = component.assets[themeId];
    final image = asset == null ? null : capture.files[asset.imagePath];
    final metadata = capture.atlasMetadata['${component.id}/$themeId'];
    if (asset == null || image == null || metadata == null) {
      return const AtlasEmptyState(
        title: 'Rendered evidence is unavailable',
        message: 'The selected theme has no validated contact-sheet oracle.',
      );
    }

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .fromLTRB(24, 20, 24, 18),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                component.label,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: .w700),
              ),
              const SizedBox(height: 5),
              Text(
                'Real producer contact sheet · $themeId · '
                '${capture.receipt.requestedRef}',
                style: const TextStyle(
                  color: AtlasPalette.textMuted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AtlasBadge('${metadata.rowCount} rows'),
                  AtlasBadge('${metadata.columnCount} columns'),
                  const AtlasBadge('Rendered evidence', success: true),
                  const AtlasBadge(
                    'Portable inspection not captured',
                    warning: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ColoredBox(
            color: AtlasPalette.surfaceMuted,
            child: InteractiveViewer(
              boundaryMargin: const .all(80),
              constrained: false,
              minScale: 0.1,
              maxScale: 4,
              child: Padding(
                padding: const .all(24),
                child: Semantics(
                  label: '${component.label}, rendered $themeId contact sheet',
                  child: Image.memory(
                    image,
                    key: ValueKey('rendered-oracle-${component.id}-$themeId'),
                    filterQuality: FilterQuality.high,
                    gaplessPlayback: true,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          width: 640,
                          height: 360,
                          child: Center(
                            child: Text(
                              'Rendered evidence could not be decoded.',
                              style: TextStyle(color: AtlasPalette.textMuted),
                            ),
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const .symmetric(vertical: 11, horizontal: 22),
          decoration: const BoxDecoration(
            color: AtlasPalette.surface,
            border: Border(top: BorderSide(color: AtlasPalette.border)),
          ),
          child: Text(
            asset.imagePath,
            style: const TextStyle(color: AtlasPalette.textMuted, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _CatalogTitle extends StatelessWidget {
  const _CatalogTitle({required this.controller, required this.component});

  final AtlasAppController controller;
  final AtlasComponentDocument component;

  @override
  Widget build(BuildContext context) {
    final capture = controller.current!;
    final rows = component.recipes.length;
    final columns = component.states.length;

    return Padding(
      padding: const .fromLTRB(24, 20, 24, 18),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            component.label,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: .w700),
          ),
          const SizedBox(height: 5),
          Text(
            'Actual captured recipe × state matrix · ${capture.receipt.requestedRef}',
            style: const TextStyle(color: AtlasPalette.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AtlasBadge('$rows recipes'),
              AtlasBadge('$columns states'),
              AtlasBadge('${capture.manifest.themes.length} themes'),
              AtlasBadge(
                '${capture.validatedStyleDocumentCount} style docs',
                success: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecipeMatrix extends StatelessWidget {
  const _RecipeMatrix({
    required this.controller,
    required this.capture,
    required this.component,
    required this.themeId,
  });

  final AtlasAppController controller;
  final AtlasCapture capture;
  final AtlasComponentDocument component;
  final String themeId;

  @override
  Widget build(BuildContext context) {
    final states = component.states.values.toList();

    return Table(
      defaultColumnWidth: const FixedColumnWidth(196),
      border: const TableBorder(
        horizontalInside: BorderSide(color: AtlasPalette.border),
        verticalInside: BorderSide(color: AtlasPalette.border),
      ),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: AtlasPalette.surfaceMuted),
          children: [
            const _HeaderCell('Recipe'),
            for (final state in states) _HeaderCell(state.id),
          ],
        ),
        for (final recipe in component.recipes)
          TableRow(
            children: [
              _RecipeLabel(recipe: recipe),
              for (final state in states)
                _ComponentCell(
                  controller: controller,
                  capture: capture,
                  component: component,
                  recipe: recipe,
                  state: state,
                  themeId: themeId,
                ),
            ],
          ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: Center(
      child: Text(
        label,
        style: const TextStyle(
          color: AtlasPalette.textMuted,
          fontSize: 11,
          fontWeight: .w700,
        ),
      ),
    ),
  );
}

class _RecipeLabel extends StatelessWidget {
  const _RecipeLabel({required this.recipe});

  final AtlasComponentRecipe recipe;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 112,
    child: Padding(
      padding: const .all(14),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .start,
        spacing: 5,
        children: [
          Text(
            recipe.id,
            style: const TextStyle(fontSize: 12, fontWeight: .w700),
          ),
          Text(
            recipe.properties.entries
                .map((entry) => '${entry.key}: ${entry.value ?? 'null'}')
                .join(' · '),
            style: const TextStyle(color: AtlasPalette.textMuted, fontSize: 10),
            overflow: .ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    ),
  );
}

class _ComponentCell extends StatelessWidget {
  const _ComponentCell({
    required this.controller,
    required this.capture,
    required this.component,
    required this.recipe,
    required this.state,
    required this.themeId,
  });

  final AtlasAppController controller;
  final AtlasCapture capture;
  final AtlasComponentDocument component;
  final AtlasComponentRecipe recipe;
  final AtlasComponentState state;
  final String themeId;

  @override
  Widget build(BuildContext context) {
    final review = controller.reviewContext;
    final selected =
        review?.recipeId == recipe.id && review?.stateId == state.id;

    return Semantics(
      excludeSemantics: true,
      selected: selected,
      button: true,
      label: '${component.label}, ${recipe.id}, ${state.id}, $themeId',
      child: InkWell(
        key: ValueKey('cell-${recipe.id}-${state.id}'),
        onTap: () =>
            controller.selectCell(recipeId: recipe.id, stateId: state.id),
        child: AnimatedContainer(
          padding: const .all(12),
          decoration: BoxDecoration(
            color: selected ? AtlasPalette.accentSoft : AtlasPalette.surface,
            border: selected
                ? .all(color: AtlasPalette.accent, width: 2)
                : null,
          ),
          height: 112,
          duration: const Duration(milliseconds: 120),
          child: Center(
            child: FittedBox(
              fit: .scaleDown,
              child: AtlasPortableComponent(
                capture: capture,
                component: component,
                selection: AtlasComponentSelection(
                  recipeId: recipe.id,
                  stateId: state.id,
                  themeId: themeId,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionBar extends StatelessWidget {
  const _SelectionBar({required this.controller});

  final AtlasAppController controller;

  @override
  Widget build(BuildContext context) {
    final review = controller.reviewContext!;
    final hasEvidence = controller.currentIndex!.propertyEvidence.any(
      (evidence) =>
          evidence.componentId == review.componentId &&
          evidence.recipeId == review.recipeId &&
          evidence.themeId == review.themeId,
    );

    return Container(
      padding: const .symmetric(vertical: 12, horizontal: 22),
      decoration: const BoxDecoration(
        color: AtlasPalette.surface,
        border: Border(top: BorderSide(color: AtlasPalette.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final selection = Text(
            '${review.componentId ?? '—'} / ${review.recipeId ?? '—'} / '
            '${review.stateId ?? '—'} / ${review.themeId ?? '—'}',
            style: const TextStyle(fontSize: 12, fontWeight: .w600),
            overflow: .ellipsis,
          );
          final actions = Row(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: controller.hasCompatibleComparison
                    ? () => controller.navigate(.compare)
                    : null,
                child: const Text('Compare'),
              ),
              FilledButton(
                onPressed: hasEvidence
                    ? () => controller.navigate(.inspect)
                    : null,
                child: const Text('Inspect declared data'),
              ),
            ],
          );

          if (constraints.maxWidth < 620) {
            return Column(
              crossAxisAlignment: .stretch,
              spacing: 8,
              children: [
                selection,
                Align(alignment: Alignment.centerRight, child: actions),
              ],
            );
          }

          return Row(
            spacing: 16,
            children: [
              Expanded(child: selection),
              actions,
            ],
          );
        },
      ),
    );
  }
}
