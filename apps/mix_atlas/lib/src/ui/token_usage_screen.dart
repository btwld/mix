import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

import '../app_controller.dart';
import 'atlas_theme.dart';
import 'common.dart';

class AtlasTokenUsageScreen extends StatefulWidget {
  const AtlasTokenUsageScreen({required this.controller, super.key});

  final AtlasAppController controller;

  @override
  State<AtlasTokenUsageScreen> createState() => _AtlasTokenUsageScreenState();
}

class _AtlasTokenUsageScreenState extends State<AtlasTokenUsageScreen> {
  String? component;
  String? theme;
  AtlasTokenReferenceType? referenceType;
  var selector = '';
  var slot = '';
  var property = '';

  @override
  Widget build(BuildContext context) {
    final allUses = widget.controller.currentIndex!.tokenUses;
    if (allUses.isEmpty) {
      return const AtlasEmptyState(
        title: 'No token references captured',
        message:
            'Token Usage lists exact declared references only; this capture contains none.',
        icon: Icons.account_tree_outlined,
      );
    }
    final review = widget.controller.reviewContext;
    final tokenKind = review?.tokenKind ?? allUses.first.tokenKind;
    final tokenName = review?.tokenName ?? allUses.first.tokenName;
    final uses = allUses
        .where(
          (use) => use.tokenKind == tokenKind && use.tokenName == tokenName,
        )
        .where((use) => component == null || use.componentId == component)
        .where((use) => theme == null || use.themeId == theme)
        .where(
          (use) => referenceType == null || use.referenceType == referenceType,
        )
        .where(
          (use) => use.selector.toLowerCase().contains(selector.toLowerCase()),
        )
        .where((use) => use.slotId.toLowerCase().contains(slot.toLowerCase()))
        .where(
          (use) => use.property.toLowerCase().contains(property.toLowerCase()),
        )
        .toList();
    final exactReferences = uses.map((use) => use.referenceId).toSet().length;
    final components = uses.map((use) => use.componentId).toSet();
    final themes = uses.map((use) => use.themeId).toSet();
    final aliases = uses
        .where((use) => use.referenceType == .alias)
        .map((use) => use.referenceId)
        .toSet()
        .length;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .fromLTRB(20, 14, 20, 13),
          child: Row(
            children: [
              IconButton(
                onPressed: widget.controller.pop,
                tooltip: 'Return to previous review',
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 3,
                  children: [
                    Text(
                      '$tokenKind / $tokenName',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontWeight: .w700),
                    ),
                    const Text(
                      'Exact captured references · not predicted visual impact',
                      style: TextStyle(
                        color: AtlasPalette.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              AtlasBadge('$exactReferences references'),
              const SizedBox(width: 8),
              AtlasBadge('${components.length} components'),
              const SizedBox(width: 8),
              AtlasBadge('${themes.length} themes'),
              const SizedBox(width: 8),
              AtlasBadge('$aliases aliases', warning: aliases > 0),
              const SizedBox(width: 8),
              IconButton(
                onPressed: uses.isEmpty
                    ? null
                    : () => Clipboard.setData(
                        ClipboardData(text: uses.map(_copyLine).join('\n')),
                      ),
                tooltip: 'Copy usage list',
                icon: const Icon(Icons.copy_all_outlined),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        _Filters(
          uses: allUses
              .where(
                (use) =>
                    use.tokenKind == tokenKind && use.tokenName == tokenName,
              )
              .toList(),
          component: component,
          theme: theme,
          referenceType: referenceType,
          onComponent: (value) => setState(() => component = value),
          onTheme: (value) => setState(() => theme = value),
          onReferenceType: (value) => setState(() => referenceType = value),
          onSelector: (value) => setState(() => selector = value),
          onSlot: (value) => setState(() => slot = value),
          onProperty: (value) => setState(() => property = value),
        ),
        const Divider(height: 1),
        Expanded(
          child: uses.isEmpty
              ? const AtlasEmptyState(
                  title: 'No usages match these filters',
                  message:
                      'Clear one or more filters to see exact captured references.',
                  icon: Icons.filter_alt_off_outlined,
                )
              : ListView.separated(
                  padding: const .all(20),
                  itemBuilder: (context, index) => _UsageRow(use: uses[index]),
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemCount: uses.length,
                ),
        ),
      ],
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.uses,
    required this.component,
    required this.theme,
    required this.referenceType,
    required this.onComponent,
    required this.onTheme,
    required this.onReferenceType,
    required this.onSelector,
    required this.onSlot,
    required this.onProperty,
  });

  final List<AtlasTokenUse> uses;
  final String? component;
  final String? theme;
  final AtlasTokenReferenceType? referenceType;
  final ValueChanged<String?> onComponent;
  final ValueChanged<String?> onTheme;
  final ValueChanged<AtlasTokenReferenceType?> onReferenceType;
  final ValueChanged<String> onSelector;
  final ValueChanged<String> onSlot;
  final ValueChanged<String> onProperty;

  @override
  Widget build(BuildContext context) {
    final components = uses.map((use) => use.componentId).toSet().toList()
      ..sort();
    final themes = uses.map((use) => use.themeId).toSet().toList()..sort();

    return Padding(
      padding: const .all(14),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _DropdownFilter(
            label: 'Component',
            value: component,
            values: components,
            onChanged: onComponent,
          ),
          _DropdownFilter(
            label: 'Theme',
            value: theme,
            values: themes,
            onChanged: onTheme,
          ),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<AtlasTokenReferenceType?>(
              items: const [
                DropdownMenuItem(value: null, child: Text('Any')),
                DropdownMenuItem(
                  value: AtlasTokenReferenceType.direct,
                  child: Text('Direct'),
                ),
                DropdownMenuItem(
                  value: AtlasTokenReferenceType.alias,
                  child: Text('Alias'),
                ),
              ],
              initialValue: referenceType,
              onChanged: onReferenceType,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Reference type',
                isDense: true,
              ),
            ),
          ),
          _TextFilter(label: 'State / selector', onChanged: onSelector),
          _TextFilter(label: 'Slot', onChanged: onSlot),
          _TextFilter(label: 'Property', onChanged: onProperty),
        ],
      ),
    );
  }
}

class _DropdownFilter extends StatelessWidget {
  const _DropdownFilter({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> values;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 150,
    child: DropdownButtonFormField<String?>(
      items: [
        const DropdownMenuItem(value: null, child: Text('Any')),
        for (final item in values)
          DropdownMenuItem(
            value: item,
            child: Text(item, overflow: .ellipsis, maxLines: 1),
          ),
      ],
      initialValue: value,
      onChanged: onChanged,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, isDense: true),
    ),
  );
}

class _TextFilter extends StatelessWidget {
  const _TextFilter({required this.label, required this.onChanged});

  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 150,
    child: TextField(
      decoration: InputDecoration(labelText: label, isDense: true),
      onChanged: onChanged,
    ),
  );
}

class _UsageRow extends StatelessWidget {
  const _UsageRow({required this.use});

  final AtlasTokenUse use;

  @override
  Widget build(BuildContext context) => AtlasPanel(
    padding: const .symmetric(vertical: 12, horizontal: 16),
    child: Row(
      spacing: 12,
      children: [
        AtlasBadge(
          use.referenceType == .direct ? 'Direct' : 'Alias',
          warning: use.referenceType == .alias,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            spacing: 4,
            children: [
              Text(
                '${use.componentId} · ${use.recipeId} · ${use.slotId} · ${use.property}',
                style: const TextStyle(fontSize: 12, fontWeight: .w700),
              ),
              Text(
                '${use.selector} · ${use.themeId} · ${use.sourcePath}${use.jsonPointer}',
                style: const TextStyle(
                  color: AtlasPalette.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

String _copyLine(AtlasTokenUse use) =>
    '${use.referenceType.name}\t${use.componentId}\t${use.recipeId}\t${use.selector}\t${use.themeId}\t${use.slotId}\t${use.property}\t${use.sourcePath}${use.jsonPointer}';
