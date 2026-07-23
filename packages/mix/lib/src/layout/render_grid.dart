import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'grid_track.dart';

/// Geometry for a laid-out grid cell (row-major auto-placement, no spans).
@immutable
class GridCellGeometry {
  final int column;
  final int row;
  final Offset offset;
  final Size size;

  const GridCellGeometry({
    required this.column,
    required this.row,
    required this.offset,
    required this.size,
  });
}

/// Shared layout result used by both [RenderMixGrid.performLayout] and
/// [RenderMixGrid.computeDryLayout].
@immutable
class GridLayoutResult {
  final Size size;
  final List<double> columnSizes;
  final List<double> rowSizes;
  final List<GridCellGeometry> cells;

  const GridLayoutResult({
    required this.size,
    required this.columnSizes,
    required this.rowSizes,
    required this.cells,
  });
}

/// Computes grid geometry without touching children.
///
/// Children are placed row-major into a matrix of [columns] × enough rows.
/// Track sizes use only fixed/fr rules and parent constraints — no content
/// measurement in this spike slice.
GridLayoutResult computeGridLayout({
  required BoxConstraints constraints,
  required List<GridTrack> columns,
  required List<GridTrack> rows,
  required double columnGap,
  required double rowGap,
  required int childCount,
}) {
  assert(columns.isNotEmpty, 'Grid requires at least one column track.');

  final colCount = columns.length;
  final autoRows = childCount == 0
      ? 0
      : ((childCount + colCount - 1) ~/ colCount);
  final effectiveRows = rows.isEmpty
      ? List.filled(autoRows == 0 ? 1 : autoRows, const GridTrack.fr(1))
      : [
          ...rows,
          // If more children than explicit rows, append 1fr rows.
          if (autoRows > rows.length)
            ...List.filled(autoRows - rows.length, const GridTrack.fr(1)),
        ];

  // Resolve free space: prefer max constraint when finite; else min.
  final freeWidth = constraints.hasBoundedWidth
      ? constraints.maxWidth
      : constraints.minWidth;
  final freeHeight = constraints.hasBoundedHeight
      ? constraints.maxHeight
      : constraints.minHeight;

  final columnSizes = computeTrackSizes(
    tracks: columns,
    freeSpace: freeWidth,
    gap: columnGap,
  );
  final rowSizes = computeTrackSizes(
    tracks: effectiveRows,
    freeSpace: freeHeight,
    gap: rowGap,
  );

  final intrinsicWidth = axisExtent(columnSizes, columnGap);
  final intrinsicHeight = axisExtent(rowSizes, rowGap);
  final size = constraints.constrain(Size(intrinsicWidth, intrinsicHeight));

  final cells = <GridCellGeometry>[];
  for (var i = 0; i < childCount; i++) {
    final column = i % colCount;
    final row = i ~/ colCount;
    if (row >= rowSizes.length) break;
    cells.add(
      GridCellGeometry(
        column: column,
        row: row,
        offset: Offset(
          trackOrigin(columnSizes, columnGap, column),
          trackOrigin(rowSizes, rowGap, row),
        ),
        size: Size(columnSizes[column], rowSizes[row]),
      ),
    );
  }

  return GridLayoutResult(
    size: size,
    columnSizes: columnSizes,
    rowSizes: rowSizes,
    cells: cells,
  );
}

/// Multi-child render object for the GridBox spike.
///
/// Supports fixed + fr tracks, row/column gaps, and row-major auto-placement.
/// Excludes spans, named areas, content-sized tracks, RTL, and baseline.
class RenderMixGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  /// Layout pass counter for tests (reset externally).
  int childLayoutCount = 0;

  List<GridTrack> _columns;
  List<GridTrack> _rows;
  double _columnGap;
  double _rowGap;

  RenderMixGrid({
    List<RenderBox>? children,
    required List<GridTrack> columns,
    List<GridTrack> rows = const [],
    double columnGap = 0,
    double rowGap = 0,
  }) : _columns = columns,
       _rows = rows,
       _columnGap = columnGap,
       _rowGap = rowGap {
    addAll(children);
  }

  GridLayoutResult _compute(BoxConstraints constraints) {
    return computeGridLayout(
      constraints: constraints,
      columns: _columns,
      rows: _rows,
      columnGap: _columnGap,
      rowGap: _rowGap,
      childCount: childCount,
    );
  }

  List<GridTrack> get columns => _columns;
  List<GridTrack> get rows => _rows;
  double get columnGap => _columnGap;
  double get rowGap => _rowGap;

  set columns(List<GridTrack> value) {
    if (listEquals(_columns, value)) return;
    _columns = value;
    markNeedsLayout();
  }

  set rows(List<GridTrack> value) {
    if (listEquals(_rows, value)) return;
    _rows = value;
    markNeedsLayout();
  }

  set columnGap(double value) {
    if (_columnGap == value) return;
    _columnGap = value;
    markNeedsLayout();
  }

  set rowGap(double value) {
    if (_rowGap == value) return;
    _rowGap = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _compute(constraints).size;
  }

  @override
  void performLayout() {
    final result = _compute(constraints);
    size = result.size;

    var index = 0;
    var child = firstChild;
    while (child != null) {
      final parentData = child.parentData! as MultiChildLayoutParentData;
      if (index < result.cells.length) {
        final cell = result.cells[index];
        child.layout(BoxConstraints.tight(cell.size), parentUsesSize: false);
        childLayoutCount++;
        parentData.offset = cell.offset;
      } else {
        child.layout(BoxConstraints.tight(.zero), parentUsesSize: false);
        childLayoutCount++;
        parentData.offset = .zero;
      }
      child = parentData.nextSibling;
      index++;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

/// Widget host for [RenderMixGrid].
///
/// Spike prototype — not exported from `mix.dart`.
class MixGrid extends MultiChildRenderObjectWidget {
  const MixGrid({
    super.key,
    required this.columns,
    this.rows = const [],
    this.columnGap = 0,
    this.rowGap = 0,
    super.children,
  });

  final List<GridTrack> columns;
  final List<GridTrack> rows;
  final double columnGap;
  final double rowGap;

  @override
  RenderMixGrid createRenderObject(BuildContext context) {
    return RenderMixGrid(
      columns: columns,
      rows: rows,
      columnGap: columnGap,
      rowGap: rowGap,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderMixGrid renderObject) {
    renderObject
      ..columns = columns
      ..rows = rows
      ..columnGap = columnGap
      ..rowGap = rowGap;
  }
}
