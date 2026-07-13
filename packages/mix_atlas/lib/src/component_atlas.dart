import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'scenario.dart';
import 'theme.dart';

/// Handed to cell builders with the active scenario applied.
///
/// Build any widget normally and pass its Mix styler through the component's
/// ordinary `style` parameter. The atlas forces [AtlasScenario.states] during
/// style resolution. Map structural component properties such as `enabled`,
/// `loading`, or `selected` from this context in the builder.
class AtlasCellContext {
  final AtlasScenario scenario;

  const AtlasCellContext(this.scenario);

  Set<WidgetState> get states => scenario.states;
  bool get hovered => states.contains(WidgetState.hovered);
  bool get pressed => states.contains(WidgetState.pressed);
  bool get focused => states.contains(WidgetState.focused);
  bool get disabled => states.contains(WidgetState.disabled);
  bool get selected => states.contains(WidgetState.selected);
  bool get error => states.contains(WidgetState.error);

  T? prop<T>(String key) => scenario.props[key] as T?;

  T propOr<T>(String key, T fallback) =>
      (scenario.props[key] as T?) ?? fallback;

  /// Resolves [style] eagerly with this scenario's widget states forced.
  ///
  /// This is an optional advanced escape hatch for components that accept a
  /// pre-resolved `styleSpec`. Prefer the normal `style` API so component
  /// defaults and the complete style-resolution path remain active.
  /// [context] must be the cell builder's context (below the atlas's
  /// state and theme scopes).
  StyleSpec<S> resolve<S extends Spec<S>>(
    BuildContext context,
    Style<S> style,
  ) {
    assert(
      WidgetStateProvider.of(context) != null,
      'AtlasCellContext.resolve must be called with the cell builder context so '
      'forced widget states are visible to style resolution.',
    );

    return style.build(context);
  }
}

/// Builds one cell of a component atlas for a given scenario.
///
/// The builder may return any widget. Components should use their normal Mix
/// `style` parameter and map structural props from [AtlasCellContext].
typedef AtlasCellBuilder =
    Widget Function(BuildContext context, AtlasCellContext cell);

/// A row of a component atlas, typically one component variant.
@immutable
class AtlasRow {
  /// Identifier shown as the row label and recorded in the manifest.
  final String id;

  final String? label;
  final AtlasCellBuilder builder;

  /// Values for each axis declared by [ComponentAtlas.rowAxes].
  final Map<String, AtlasAxisValue> values;

  const AtlasRow(this.id, this.builder, {this.label, this.values = const {}});
}

@immutable
class AtlasAxis {
  final String id;

  final String label;
  const AtlasAxis(this.id, this.label);
}

@immutable
class AtlasAxisValue {
  final String id;

  final String label;
  const AtlasAxisValue(this.id, this.label);
}

/// A component's full atlas: rows (variants) crossed with scenario columns.
@immutable
class ComponentAtlas {
  /// Component identifier used in golden file paths and the manifest.
  final String id;

  final String? label;
  final List<AtlasScenario> scenarios;

  final List<AtlasRow> rows;

  /// Ordered axes used to group and label rows.
  final List<AtlasAxis> rowAxes;

  const ComponentAtlas({
    required this.id,
    required this.scenarios,
    required this.rows,
    this.label,
    this.rowAxes = const [],
  });

  /// Validates identifiers and the row/scenario matrix before rendering.
  void validate() {
    _requireId(id, 'atlas');
    _requireUnique(scenarios.map((item) => item.id), 'scenario');
    _requireUnique(rowAxes.map((item) => item.id), 'axis');
    _requireUnique(rows.map((item) => item.id), 'row');

    final axisIds = rowAxes.map((axis) => axis.id).toSet();
    final combinations = <String>{};
    for (final row in rows) {
      final valueIds = row.values.keys.toSet();
      final missing = axisIds.difference(valueIds);
      final unknown = valueIds.difference(axisIds);
      if (missing.isNotEmpty || unknown.isNotEmpty) {
        throw ArgumentError(
          'Row "${row.id}" has invalid axis values '
          '(missing: ${missing.toList()}, unknown: ${unknown.toList()}).',
        );
      }
      for (final value in row.values.values) {
        _requireId(value.id, 'axis value');
      }
      if (rowAxes.isNotEmpty) {
        final combination = rowAxes
            .map((axis) => row.values[axis.id]!.id)
            .join('\u0000');
        if (!combinations.add(combination)) {
          throw ArgumentError('Duplicate axis combination on row "${row.id}".');
        }
      }
    }
  }
}

void _requireId(String id, String kind) {
  if (id.trim().isEmpty) throw ArgumentError('$kind ID must not be empty.');
}

void _requireUnique(Iterable<String> ids, String kind) {
  final seen = <String>{};
  for (final id in ids) {
    _requireId(id, kind);
    if (!seen.add(id)) throw ArgumentError('Duplicate $kind ID "$id".');
  }
}

/// Shared source of themes and atlases for snapshots and future viewers.
@immutable
class AtlasCatalog {
  final String id;

  final String? label;
  final List<AtlasTheme> themes;
  final List<ComponentAtlas> atlases;
  const AtlasCatalog({
    required this.id,
    required this.themes,
    required this.atlases,
    this.label,
  });

  void validate() {
    _requireId(id, 'catalog');
    _requireUnique(themes.map((item) => item.id), 'theme');
    _requireUnique(atlases.map((item) => item.id), 'atlas');
    for (final atlas in atlases) {
      atlas.validate();
    }
  }
}
