import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

import '../app_controller.dart';
import 'atlas_theme.dart';
import 'common.dart';

typedef _EvidencePair = ({
  AtlasPropertyEvidence? before,
  AtlasPropertyEvidence? after,
});

class AtlasCompareScreen extends StatelessWidget {
  const AtlasCompareScreen({required this.controller, super.key});

  final AtlasAppController controller;

  List<_EvidencePair> _changedEvidence() {
    final review = controller.reviewContext!;
    bool matches(AtlasPropertyEvidence item) =>
        item.componentId == review.componentId &&
        item.recipeId == review.recipeId &&
        item.themeId == review.themeId;
    final before = {
      for (final item in controller.baselineIndex!.propertyEvidence.where(
        matches,
      ))
        _key(item): item,
    };
    final after = {
      for (final item in controller.currentIndex!.propertyEvidence.where(
        matches,
      ))
        _key(item): item,
    };
    final keys = {...before.keys, ...after.keys}.toList()..sort();

    return [
      for (final key in keys)
        if (_value(before[key]) != _value(after[key]))
          (before: before[key], after: after[key]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final review = controller.reviewContext;
    if (review?.componentId == null ||
        review?.recipeId == null ||
        review?.stateId == null ||
        review?.themeId == null) {
      return const AtlasEmptyState(
        title: 'Choose a captured cell',
        message:
            'Compare preserves an exact component, recipe, state, and theme selection from Catalog.',
      );
    }
    if (!controller.hasCompatibleComparison) {
      return const AtlasEmptyState(
        title: 'Comparison unavailable',
        message:
            'Baseline and current captures must share catalog identity and protocol format.',
      );
    }
    final pairs = _changedEvidence();

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .fromLTRB(24, 18, 24, 16),
          child: Row(
            children: [
              IconButton(
                onPressed: controller.pop,
                tooltip: 'Back',
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 4,
                  children: [
                    Text(
                      'Compare · ${review!.componentId ?? '—'}',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontWeight: .w700),
                    ),
                    Text(
                      '${review.recipeId ?? '—'} / ${review.stateId ?? '—'} / '
                      '${review.themeId ?? '—'}',
                      style: const TextStyle(
                        color: AtlasPalette.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              AtlasBadge('${pairs.length} declared property changes'),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: const .all(22),
            children: [
              Row(
                crossAxisAlignment: .start,
                spacing: 14,
                children: [
                  Expanded(
                    child: _RevisionPreview(
                      controller: controller,
                      baseline: true,
                    ),
                  ),
                  Expanded(
                    child: _RevisionPreview(
                      controller: controller,
                      baseline: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Changed declared properties',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: .w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Each value traces to a capture file and JSON pointer. Atlas does not infer the runtime winner.',
                style: TextStyle(color: AtlasPalette.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 12),
              if (pairs.isEmpty)
                const AtlasPanel(
                  child: Text(
                    'No declared property changes exist for this exact selection.',
                  ),
                )
              else
                for (final pair in pairs) ...[
                  _PropertyChangeRow(
                    pair: pair,
                    onInspect: () {
                      controller.selectProperty(pair.after ?? pair.before!);
                      controller.navigate(.inspect);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RevisionPreview extends StatelessWidget {
  const _RevisionPreview({required this.controller, required this.baseline});

  final AtlasAppController controller;
  final bool baseline;

  @override
  Widget build(BuildContext context) {
    final capture = baseline ? controller.baseline! : controller.current!;
    final review = controller.reviewContext!;
    final component = capture.componentDocuments
        .where((item) => item.id == review.componentId)
        .firstOrNull;
    final recipe = component?.recipes
        .where((item) => item.id == review.recipeId)
        .firstOrNull;
    final state = component?.states[review.stateId];
    final supportsTheme =
        component?.oracles.containsKey(review.themeId) ?? false;

    return AtlasPanel(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  baseline
                      ? 'Baseline · ${review.baselineRef}'
                      : 'Current · ${review.currentRef}',
                  style: const TextStyle(fontWeight: .w700),
                ),
              ),
              AtlasBadge(shortCommit(capture.receipt.resolvedCommit)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: AtlasPalette.surfaceMuted,
              borderRadius: .circular(9),
            ),
            height: 180,
            child:
                component == null ||
                    recipe == null ||
                    state == null ||
                    !supportsTheme
                ? const AtlasEmptyState(
                    title: 'Reconstruction unavailable',
                    message:
                        'This revision does not contain the selected portable recipe, state, or theme.',
                    icon: Icons.extension_off_outlined,
                  )
                : Center(
                    child: FittedBox(
                      fit: .scaleDown,
                      child: AtlasPortableComponent(
                        capture: capture,
                        component: component,
                        selection: AtlasComponentSelection(
                          recipeId: recipe.id,
                          stateId: state.id,
                          themeId: review.themeId!,
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AtlasBadge(
                supportsTheme ? 'Portable reconstruction' : 'Unsupported',
                warning: !supportsTheme,
                success: supportsTheme,
              ),
              AtlasBadge(
                component?.oracles[review.themeId] != null
                    ? 'Contact-sheet oracle available'
                    : 'No oracle',
                warning: component?.oracles[review.themeId] == null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PropertyChangeRow extends StatelessWidget {
  const _PropertyChangeRow({required this.pair, required this.onInspect});

  final _EvidencePair pair;
  final VoidCallback onInspect;

  @override
  Widget build(BuildContext context) {
    final evidence = pair.after ?? pair.before!;

    return AtlasPanel(
      padding: const .symmetric(vertical: 13, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: .start,
              spacing: 3,
              children: [
                Text(
                  '${evidence.slotId} · ${evidence.property}',
                  style: const TextStyle(fontSize: 12, fontWeight: .w700),
                ),
                Text(
                  '${evidence.sourcePath}${evidence.jsonPointer}',
                  style: const TextStyle(
                    color: AtlasPalette.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              _display(pair.before),
              style: const TextStyle(fontSize: 11),
            ),
          ),
          const Padding(
            padding: .symmetric(horizontal: 10),
            child: Icon(
              Icons.arrow_forward,
              size: 16,
              color: AtlasPalette.textMuted,
            ),
          ),
          Expanded(
            child: Text(
              _display(pair.after),
              style: const TextStyle(fontSize: 11),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(onPressed: onInspect, child: const Text('Inspect')),
        ],
      ),
    );
  }
}

String _key(AtlasPropertyEvidence evidence) =>
    '${evidence.slotId}|${evidence.selector}|${evidence.property}|${evidence.jsonPointer}';

String _value(AtlasPropertyEvidence? evidence) => evidence == null
    ? '<absent>'
    : jsonEncode({
        'literal': evidence.literalValue,
        'tokenKind': evidence.tokenKind,
        'tokenName': evidence.tokenName,
        'theme': evidence.capturedThemeValue,
      });

String _display(AtlasPropertyEvidence? evidence) {
  if (evidence == null) return 'Not declared';
  if (evidence.tokenName != null) {
    return '${evidence.tokenKind ?? 'token'}/${evidence.tokenName}\n'
        '${evidence.capturedThemeValue ?? 'Theme value unavailable'}';
  }

  return evidence.literalValue?.toString() ?? 'null';
}
