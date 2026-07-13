import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'component_atlas.dart';
import 'scenario.dart';
import 'theme.dart';

/// Presents a component atlas as compact, scenario-first stories.
///
/// The canonical `AtlasView` keeps the row-by-scenario layout used by golden
/// snapshots. This live-viewer canvas pivots the final row axis into adjacent
/// cells, making size and variant comparisons easier to scan without changing
/// the generated atlas artifacts.
class AtlasStoryCanvas extends StatelessWidget {
  const AtlasStoryCanvas({
    super.key,
    required this.atlas,
    required this.theme,
    this.compact = false,
    this.minimumCellWidth = 180,
  });

  static double minimumWidth(
    ComponentAtlas atlas, {
    required bool compact,
    double minimumCellWidth = 180,
  }) {
    final groups = _groupRows(atlas);
    final columns = groups.fold<int>(
      1,
      (current, group) => math.max(current, group.rows.length),
    );
    final labelWidth = _showsGroupLabels(atlas)
        ? (compact ? 104.0 : 128.0)
        : 0.0;
    final cellWidth = atlas.rowAxes.isEmpty ? 480.0 : minimumCellWidth;

    return labelWidth + (columns * cellWidth) + 48;
  }

  final ComponentAtlas atlas;
  final AtlasTheme theme;

  final bool compact;

  /// Minimum width allocated to each value on the final row axis.
  final double minimumCellWidth;

  @override
  Widget build(BuildContext context) {
    atlas.validate();
    final groups = _groupRows(atlas);
    final colors = Theme.of(context).colorScheme;

    return Container(
      key: const ValueKey('atlas-story-canvas'),
      decoration: BoxDecoration(
        color: theme.background,
        border: .all(color: colors.outlineVariant),
        borderRadius: .circular(8),
      ),
      clipBehavior: .antiAlias,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          for (var index = 0; index < atlas.scenarios.length; index++) ...[
            if (index > 0)
              ColoredBox(
                color: colors.surfaceContainerLow,
                child: const SizedBox(height: 12),
              ),
            _ScenarioStory(
              atlas: atlas,
              scenario: atlas.scenarios[index],
              groups: groups,
              compact: compact,
            ),
          ],
        ],
      ),
    );
  }
}

class _ScenarioStory extends StatelessWidget {
  const _ScenarioStory({
    required this.atlas,
    required this.scenario,
    required this.groups,
    required this.compact,
  });

  final ComponentAtlas atlas;
  final AtlasScenario scenario;
  final List<_RowGroup> groups;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      key: ValueKey('scenario-story-${scenario.id}'),
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        SizedBox(
          height: 48,
          child: Padding(
            padding: const .symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  scenario.label ?? _humanize(scenario.id),
                  style: _textStyle(
                    color: colors.onSurface,
                    fontSize: 12,
                    weight: .w600,
                  ),
                ),
                const Spacer(),
                Text(
                  _scenarioMeta(atlas, groups),
                  style: _textStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(color: colors.outlineVariant, height: 1),
        for (var index = 0; index < groups.length; index++) ...[
          _StoryRow(
            atlas: atlas,
            scenario: scenario,
            group: groups[index],
            compact: compact,
          ),
          if (index < groups.length - 1)
            Container(color: colors.outlineVariant, height: 1),
        ],
      ],
    );
  }
}

class _StoryRow extends StatelessWidget {
  const _StoryRow({
    required this.atlas,
    required this.scenario,
    required this.group,
    required this.compact,
  });

  final ComponentAtlas atlas;
  final AtlasScenario scenario;
  final _RowGroup group;
  final bool compact;

  @override
  Widget build(BuildContext context) => Container(
    key: ValueKey('story-row-${scenario.id}-${group.key}'),
    constraints: const BoxConstraints(minHeight: 88),
    child: Row(
      crossAxisAlignment: .center,
      children: [
        if (_showsGroupLabels(atlas))
          SizedBox(
            width: compact ? 104 : 128,
            child: Padding(
              padding: const .symmetric(horizontal: 12),
              child: Text(
                group.label ?? '',
                style: _textStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  weight: .w600,
                ),
              ),
            ),
          ),
        for (final row in group.rows)
          Expanded(
            child: _StoryCell(atlas: atlas, row: row, scenario: scenario),
          ),
      ],
    ),
  );
}

class _StoryCell extends StatelessWidget {
  const _StoryCell({
    required this.atlas,
    required this.row,
    required this.scenario,
  });

  final ComponentAtlas atlas;
  final AtlasRow row;
  final AtlasScenario scenario;

  @override
  Widget build(BuildContext context) {
    final caption = _cellCaption(atlas, row);

    return Padding(
      key: ValueKey('story-cell-${scenario.id}-${row.id}'),
      padding: const .symmetric(vertical: 12, horizontal: 12),
      child: Column(
        mainAxisSize: .min,
        children: [
          IgnorePointer(
            child: WidgetStateStyleOverride(
              states: scenario.states,
              child: WidgetStateProvider(
                states: scenario.states,
                child: Builder(
                  builder: (context) =>
                      row.builder(context, AtlasCellContext(scenario)),
                ),
              ),
            ),
          ),
          if (caption != null) ...[
            const SizedBox(height: 4),
            Text(
              caption,
              style: _textStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RowGroup {
  final String key;

  final String? label;
  final List<AtlasRow> rows;
  const _RowGroup({required this.key, required this.label, required this.rows});
}

List<_RowGroup> _groupRows(ComponentAtlas atlas) {
  if (atlas.rowAxes.isEmpty) {
    if (atlas.rows.length <= 1) {
      return [_RowGroup(key: 'default', label: null, rows: atlas.rows)];
    }

    return [
      for (final row in atlas.rows)
        _RowGroup(
          key: row.id,
          label: row.label ?? _humanize(row.id),
          rows: [row],
        ),
    ];
  }

  if (atlas.rowAxes.length == 1) {
    return [
      _RowGroup(key: atlas.rowAxes.first.id, label: null, rows: atlas.rows),
    ];
  }

  final groupingAxes = atlas.rowAxes.take(atlas.rowAxes.length - 1).toList();
  final result = <_RowGroup>[];
  var currentKey = '';
  var currentLabel = '';
  var currentRows = <AtlasRow>[];

  for (final row in atlas.rows) {
    final values = [for (final axis in groupingAxes) row.values[axis.id]!];
    final key = values.map((value) => value.id).join('\u0000');
    if (currentRows.isNotEmpty && key != currentKey) {
      result.add(
        _RowGroup(key: currentKey, label: currentLabel, rows: currentRows),
      );
      currentRows = <AtlasRow>[];
    }
    currentKey = key;
    currentLabel = values.map((value) => value.label).join(' / ');
    currentRows.add(row);
  }

  if (currentRows.isNotEmpty) {
    result.add(
      _RowGroup(key: currentKey, label: currentLabel, rows: currentRows),
    );
  }

  return result;
}

bool _showsGroupLabels(ComponentAtlas atlas) =>
    atlas.rowAxes.length > 1 ||
    (atlas.rowAxes.isEmpty && atlas.rows.length > 1);

String? _cellCaption(ComponentAtlas atlas, AtlasRow row) {
  if (atlas.rowAxes.isEmpty) return null;

  return row.values[atlas.rowAxes.last.id]!.label;
}

String _scenarioMeta(ComponentAtlas atlas, List<_RowGroup> groups) {
  if (atlas.rowAxes.isEmpty) {
    return '${atlas.rows.length} ${atlas.rows.length == 1 ? 'row' : 'rows'}';
  }
  final count = groups.fold<int>(
    0,
    (current, group) => math.max(current, group.rows.length),
  );
  final axis = atlas.rowAxes.last;
  final noun = count == 1
      ? axis.label.toLowerCase()
      : '${axis.label.toLowerCase()} values';

  return '$count $noun';
}

String _humanize(String value) => value
    .split('-')
    .where((part) => part.isNotEmpty)
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join(' ');

TextStyle _textStyle({
  required Color color,
  required double fontSize,
  FontWeight weight = .w400,
}) => .new(
  color: color,
  fontSize: fontSize,
  fontWeight: weight,
  height: 1.35,
  fontFamily: 'Roboto',
);
