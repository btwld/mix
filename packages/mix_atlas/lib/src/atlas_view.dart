import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'component_atlas.dart';
import 'scenario.dart';

/// Renders a [ComponentAtlas] as a static grid: rows x scenario columns.
///
/// Each cell forces the scenario's widget states through normal Mix style
/// resolution, so components can use their ordinary `style` parameter even
/// when they install nested interaction providers.
class AtlasView extends StatelessWidget {
  const AtlasView({
    super.key,
    required this.atlas,
    this.title,
    this.labelColor = const Color(0x99000000),
    this.cellPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
  });

  final ComponentAtlas atlas;

  /// Optional heading, e.g. `button - fortal-light`.
  final String? title;

  final Color labelColor;

  final EdgeInsets cellPadding;

  TextStyle get _labelStyle => .new(
    color: labelColor,
    fontSize: 11,
    fontWeight: .w500,
    decoration: .none,
    fontFamily: 'Roboto',
  );

  @override
  Widget build(BuildContext context) {
    atlas.validate();
    final tableRows = _tableRows(atlas);

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        if (title != null)
          Padding(
            padding: const .only(bottom: 16),
            child: Text(
              title!,
              style: _labelStyle.copyWith(fontSize: 14, fontWeight: .w600),
            ),
          ),
        Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          defaultVerticalAlignment: .middle,
          children: [
            TableRow(
              children: [
                const SizedBox.shrink(),
                for (final scenario in atlas.scenarios)
                  Padding(
                    padding: cellPadding,
                    child: Text(
                      scenario.label ?? scenario.id,
                      style: _labelStyle,
                      textAlign: .center,
                    ),
                  ),
              ],
            ),
            for (final tableRow in tableRows)
              if (tableRow.row case final row?)
                TableRow(
                  children: [
                    Padding(
                      padding: cellPadding,
                      child: Text(tableRow.label, style: _labelStyle),
                    ),
                    for (final scenario in atlas.scenarios)
                      Padding(
                        padding: cellPadding,
                        child: Center(
                          child: _AtlasCell(row: row, scenario: scenario),
                        ),
                      ),
                  ],
                )
              else
                TableRow(
                  children: [
                    Padding(
                      padding: cellPadding,
                      child: Text(
                        tableRow.label,
                        style: _labelStyle.copyWith(fontWeight: .w700),
                      ),
                    ),
                    for (final _ in atlas.scenarios) const SizedBox.shrink(),
                  ],
                ),
          ],
        ),
      ],
    );
  }
}

List<({AtlasRow? row, String label})> _tableRows(ComponentAtlas atlas) {
  if (atlas.rowAxes.isEmpty) {
    return [
      for (final row in atlas.rows) (row: row, label: row.label ?? row.id),
    ];
  }

  final result = <({AtlasRow? row, String label})>[];
  List<String>? previousGroups;
  for (final row in atlas.rows) {
    final groups = atlas.rowAxes
        .take(atlas.rowAxes.length - 1)
        .map((axis) => row.values[axis.id]!.label)
        .toList();
    var ancestorChanged = previousGroups == null;
    for (var depth = 0; depth < groups.length; depth++) {
      ancestorChanged =
          ancestorChanged ||
          previousGroups!.length <= depth ||
          previousGroups[depth] != groups[depth];
      if (ancestorChanged) {
        result.add((row: null, label: groups[depth]));
      }
    }
    final rowLabel = row.values[atlas.rowAxes.last.id]!.label;
    result.add((row: row, label: rowLabel));
    previousGroups = groups;
  }

  return result;
}

class _AtlasCell extends StatelessWidget {
  const _AtlasCell({required this.row, required this.scenario});

  final AtlasRow row;
  final AtlasScenario scenario;

  @override
  Widget build(BuildContext context) {
    return WidgetStateStyleOverride(
      states: scenario.states,
      child: WidgetStateProvider(
        states: scenario.states,
        child: Builder(
          builder: (context) =>
              row.builder(context, AtlasCellContext(scenario)),
        ),
      ),
    );
  }
}
