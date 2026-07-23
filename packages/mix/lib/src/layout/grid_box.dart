import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../core/helpers.dart';
import '../core/spec.dart';
import '../core/style.dart';
import '../core/style_spec.dart';
import '../core/style_widget.dart';
import '../modifiers/widget_modifier_config.dart';
import '../style/abstracts/styler.dart';
import 'grid_track.dart';
import 'render_grid.dart';

/// Minimal grid geometry spec for the Spike 3 render slice.
///
/// Hand-written (no codegen) to keep the spike under ~1k LOC and avoid
/// generator investment until the render contract is proven.
@immutable
final class GridBoxSpec extends Spec<GridBoxSpec> with Diagnosticable {
  final List<GridTrack> columns;
  final List<GridTrack> rows;
  final double columnGap;
  final double rowGap;

  const GridBoxSpec({
    this.columns = const [GridTrack.fr(1)],
    this.rows = const [],
    this.columnGap = 0,
    this.rowGap = 0,
  });

  @override
  GridBoxSpec copyWith({
    List<GridTrack>? columns,
    List<GridTrack>? rows,
    double? columnGap,
    double? rowGap,
  }) {
    return GridBoxSpec(
      columns: columns ?? this.columns,
      rows: rows ?? this.rows,
      columnGap: columnGap ?? this.columnGap,
      rowGap: rowGap ?? this.rowGap,
    );
  }

  @override
  GridBoxSpec lerp(GridBoxSpec? other, double t) {
    if (other == null) return this;
    // Snap geometry; no continuous track lerp in the spike.

    return t < 0.5 ? this : other;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty('columns', columns))
      ..add(IterableProperty('rows', rows))
      ..add(DoubleProperty('columnGap', columnGap))
      ..add(DoubleProperty('rowGap', rowGap));
  }

  @override
  List<Object?> get props => [columns, rows, columnGap, rowGap];
}

/// Fluent style for [GridBox], including [onConstraints] via [MixStyler].
///
/// Geometry fields are nullable so partial merges (e.g. attaching variants)
/// do not clobber earlier values with constructor defaults.
class GridBoxStyler extends MixStyler<GridBoxStyler, GridBoxSpec> {
  final List<GridTrack>? _columns;
  final List<GridTrack>? _rows;
  final double? _columnGap;
  final double? _rowGap;

  const GridBoxStyler({
    List<GridTrack>? columns,
    List<GridTrack>? rows,
    double? columnGap,
    double? rowGap,
    super.variants,
    super.modifier,
    super.animation,
  }) : _columns = columns,
       _rows = rows,
       _columnGap = columnGap,
       _rowGap = rowGap;

  List<GridTrack> get columns => _columns ?? const [GridTrack.fr(1)];
  List<GridTrack> get rows => _rows ?? const [];
  double get columnGap => _columnGap ?? 0;
  double get rowGap => _rowGap ?? 0;

  GridBoxStyler columnsTracks(List<GridTrack> value) =>
      merge(GridBoxStyler(columns: value));

  GridBoxStyler rowsTracks(List<GridTrack> value) =>
      merge(GridBoxStyler(rows: value));

  GridBoxStyler gap(double value) =>
      merge(GridBoxStyler(columnGap: value, rowGap: value));

  GridBoxStyler columnGapValue(double value) =>
      merge(GridBoxStyler(columnGap: value));

  GridBoxStyler rowGapValue(double value) =>
      merge(GridBoxStyler(rowGap: value));

  @override
  GridBoxStyler animate(AnimationConfig value) =>
      merge(GridBoxStyler(animation: value));

  @override
  GridBoxStyler variants(List<VariantStyle<GridBoxSpec>> value) =>
      merge(GridBoxStyler(variants: value));

  @override
  GridBoxStyler wrap(WidgetModifierConfig value) =>
      merge(GridBoxStyler(modifier: value));

  @override
  StyleSpec<GridBoxSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: GridBoxSpec(
        columns: columns,
        rows: rows,
        columnGap: columnGap,
        rowGap: rowGap,
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  GridBoxStyler merge(covariant GridBoxStyler? other) {
    if (other == null) return this;

    return GridBoxStyler(
      columns: other._columns ?? _columns,
      rows: other._rows ?? _rows,
      columnGap: other._columnGap ?? _columnGap,
      rowGap: other._rowGap ?? _rowGap,
      variants: MixOps.mergeVariants($variants, other.$variants),
      modifier: other.$modifier ?? $modifier,
      animation: other.$animation ?? $animation,
    );
  }

  @override
  List<Object?> get props => [
    _columns,
    _rows,
    _columnGap,
    _rowGap,
    $variants,
    $modifier,
    $animation,
  ];
}

/// Grid host: [MixGrid] driven by [GridBoxStyler] / [GridBoxSpec].
///
/// Spike prototype — not exported from `mix.dart`.
class GridBox extends StyleWidget<GridBoxSpec> {
  const GridBox({
    super.style = const GridBoxStyler(),
    super.styleSpec,
    super.key,
    this.children = const <Widget>[],
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context, GridBoxSpec spec) {
    return MixGrid(
      columns: spec.columns,
      rows: spec.rows,
      columnGap: spec.columnGap,
      rowGap: spec.rowGap,
      children: children,
    );
  }
}
