import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

import '../app_controller.dart';
import 'atlas_theme.dart';
import 'common.dart';

class AtlasInspectScreen extends StatelessWidget {
  const AtlasInspectScreen({required this.controller, super.key});

  final AtlasAppController controller;

  @override
  Widget build(BuildContext context) {
    final capture = controller.current!;
    final review = controller.reviewContext;
    final component = capture.componentDocuments
        .where((item) => item.id == review?.componentId)
        .firstOrNull;
    final recipe = component?.recipes
        .where((item) => item.id == review?.recipeId)
        .firstOrNull;
    final state = component?.states[review?.stateId];
    if (component == null ||
        recipe == null ||
        state == null ||
        review?.themeId == null) {
      return const AtlasEmptyState(
        title: 'Nothing selected to inspect',
        message:
            'Choose an exact Catalog cell before opening declared evidence.',
      );
    }
    final slotId = review!.slotId ?? component.slots.keys.first;
    final evidence = controller.currentIndex!.propertyEvidence
        .where(
          (item) =>
              item.componentId == component.id &&
              item.recipeId == recipe.id &&
              item.themeId == review.themeId &&
              item.slotId == slotId,
        )
        .toList();
    final styleReference = recipe.styleFor(slotId);

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .fromLTRB(20, 14, 20, 13),
          child: Row(
            children: [
              IconButton(
                onPressed: controller.pop,
                tooltip: 'Back',
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 3,
                  children: [
                    Text(
                      'Inspect · ${component.label}',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontWeight: .w700),
                    ),
                    Text(
                      '${recipe.id} / ${state.id} / '
                      '${review.themeId ?? '—'} / $slotId',
                      style: const TextStyle(
                        color: AtlasPalette.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const AtlasBadge('Declared evidence'),
              const SizedBox(width: 8),
              const AtlasBadge('Runtime · Not captured', warning: true),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: Row(
            crossAxisAlignment: .stretch,
            children: [
              SizedBox(
                width: 430,
                child: _AnatomyPreview(
                  controller: controller,
                  capture: capture,
                  component: component,
                  recipe: recipe,
                  state: state,
                  themeId: review.themeId!,
                  selectedSlot: slotId,
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: _EvidenceList(
                  controller: controller,
                  evidence: evidence,
                  reference: styleReference,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnatomyPreview extends StatelessWidget {
  const _AnatomyPreview({
    required this.controller,
    required this.capture,
    required this.component,
    required this.recipe,
    required this.state,
    required this.themeId,
    required this.selectedSlot,
  });

  final AtlasAppController controller;
  final AtlasCapture capture;
  final AtlasComponentDocument component;
  final AtlasComponentRecipe recipe;
  final AtlasComponentState state;
  final String themeId;
  final String selectedSlot;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const .all(20),
    children: [
      Text(
        'Portable reconstruction',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: .w700),
      ),
      const SizedBox(height: 6),
      const Text(
        'The selected anatomy slot is named below; Atlas does not infer runtime layout bounds.',
        style: TextStyle(color: AtlasPalette.textMuted, fontSize: 12),
      ),
      const SizedBox(height: 16),
      Container(
        decoration: BoxDecoration(
          color: AtlasPalette.surface,
          border: .all(color: AtlasPalette.accent, width: 2),
          borderRadius: .circular(12),
        ),
        height: 230,
        child: Stack(
          children: [
            Center(
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
            Positioned(
              left: 10,
              top: 10,
              child: AtlasBadge('Slot · $selectedSlot', success: true),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      Text(
        'Anatomy slots',
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: .w700),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final slot in component.slots.values)
            ChoiceChip(
              label: Text('${slot.id} · ${slot.kind.name}'),
              onSelected: (_) => controller.selectSlot(slot.id),
              selected: slot.id == selectedSlot,
            ),
        ],
      ),
    ],
  );
}

class _EvidenceList extends StatelessWidget {
  const _EvidenceList({
    required this.controller,
    required this.evidence,
    required this.reference,
  });

  final AtlasAppController controller;
  final List<AtlasPropertyEvidence> evidence;
  final AtlasSlotStyle reference;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const .all(20),
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              'Declared properties',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: .w700),
            ),
          ),
          AtlasBadge(
            reference.isSupported ? '${evidence.length} terms' : 'Unsupported',
            warning: !reference.isSupported,
          ),
        ],
      ),
      const SizedBox(height: 6),
      Text(
        reference.isSupported
            ? reference.documentPath!
            : 'No portable style document exists for this slot.',
        style: const TextStyle(color: AtlasPalette.textMuted, fontSize: 11),
      ),
      const SizedBox(height: 14),
      if (!reference.isSupported)
        for (final diagnostic in reference.diagnostics) ...[
          AtlasPanel(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: AtlasPalette.warning,
                    ),
                    Expanded(
                      child: Text(
                        diagnostic.code,
                        style: const TextStyle(fontWeight: .w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(diagnostic.message, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 5),
                Text(
                  diagnostic.path,
                  style: const TextStyle(
                    color: AtlasPalette.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ]
      else if (evidence.isEmpty)
        const AtlasEmptyState(
          title: 'No declared leaf terms',
          message:
              'The protocol document is valid but declares no inspectable properties beyond its type.',
          icon: Icons.data_object,
        )
      else
        for (final item in evidence) ...[
          _EvidenceCard(controller: controller, evidence: item),
          const SizedBox(height: 8),
        ],
    ],
  );
}

class _EvidenceCard extends StatelessWidget {
  const _EvidenceCard({required this.controller, required this.evidence});

  final AtlasAppController controller;
  final AtlasPropertyEvidence evidence;

  @override
  Widget build(BuildContext context) {
    final declared = evidence.tokenName == null
        ? (evidence.literalValue?.toString() ?? 'null')
        : '${evidence.tokenKind ?? 'token'}/${evidence.tokenName}';

    return AtlasPanel(
      padding: const .all(14),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    evidence.property,
                    style: const TextStyle(fontSize: 13, fontWeight: .w700),
                  ),
                ),
                AtlasBadge(evidence.selector),
                IconButton(
                  onPressed: () => Clipboard.setData(
                    ClipboardData(
                      text:
                          '${evidence.sourcePath}${evidence.jsonPointer}\n$declared',
                    ),
                  ),
                  tooltip: 'Copy property details',
                  icon: const Icon(Icons.copy, size: 17),
                ),
              ],
            ),
            const SizedBox(height: 9),
            _Detail(label: 'Declared value', value: declared),
            _Detail(
              label: 'Captured theme value',
              value: evidence.capturedThemeValue ?? 'Not token-backed',
            ),
            const _Detail(label: 'Runtime value', value: 'Not captured'),
            _Detail(
              label: 'JSON pointer',
              value: '${evidence.sourcePath}${evidence.jsonPointer}',
            ),
            if (evidence.mergeSource != null)
              _Detail(label: 'Merge source', value: '${evidence.mergeSource}'),
            if (evidence.tokenName != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    controller.selectProperty(evidence);
                    controller.navigate(.tokenUsage);
                  },
                  icon: const Icon(Icons.account_tree_outlined, size: 17),
                  label: const Text('Open Token Usage'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .only(bottom: 6),
    child: Row(
      crossAxisAlignment: .start,
      children: [
        SizedBox(
          width: 145,
          child: Text(
            label,
            style: const TextStyle(color: AtlasPalette.textMuted, fontSize: 11),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: .w500),
          ),
        ),
      ],
    ),
  );
}
