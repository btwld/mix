import 'dart:math' as math;

import 'package:flutter/foundation.dart' show precisionErrorTolerance;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'grid_box_spec.dart';
import 'grid_track.dart';
import 'internal/grid_geometry.dart';
import 'internal/grid_validation.dart';

/// Computes concrete track sizes for fixed, auto, and fr tracks.
///
/// Auto tracks contribute [autoExtents] at the matching index, then remaining
/// free space is shared by fractional tracks. Shared by live layout, dry
/// layout, and the fixed/fr fast path.
List<double> computeTrackSizes({
  required List<GridTrack> tracks,
  required double freeSpace,
  required double gap,
  List<double>? autoExtents,
}) {
  if (tracks.isEmpty) return const [];

  var fixedSum = 0.0;
  var frSum = 0.0;
  for (var index = 0; index < tracks.length; index++) {
    switch (tracks[index]) {
      case FixedGridTrack(:final size):
        fixedSum += size;
      case AutoGridTrack():
        fixedSum += _autoExtentAt(autoExtents, index);
      case FrGridTrack(:final fraction):
        frSum += fraction;
    }
  }

  final gapTotal = tracks.length > 1 ? gap * (tracks.length - 1) : 0.0;
  final remaining = (freeSpace - fixedSum - gapTotal).clamp(
    0.0,
    double.infinity,
  );
  final frUnit = frSum > 0 ? remaining / frSum : 0.0;

  return [
    for (var index = 0; index < tracks.length; index++)
      switch (tracks[index]) {
        FixedGridTrack(:final size) => size,
        AutoGridTrack() => _autoExtentAt(autoExtents, index),
        FrGridTrack(:final fraction) => frUnit * fraction,
      },
  ];
}

double _autoExtentAt(List<double>? autoExtents, int index) {
  if (autoExtents == null || index >= autoExtents.length) {
    throw FlutterError.fromParts([
      ErrorSummary('GridTrack.auto() requires a measured row extent.'),
      ErrorDescription(
        'Track $index is auto but no measured height was provided.',
      ),
      ErrorHint(
        'Measure auto-row children at their column width before resolving '
        'row sizes.',
      ),
    ]);
  }

  return autoExtents[index];
}

/// Total size along an axis for the given track sizes and gap.
double axisExtent(List<double> sizes, double gap) {
  if (sizes.isEmpty) return 0;
  final sum = sizes.fold<double>(0, (a, b) => a + b);

  return sum + (sizes.length > 1 ? gap * (sizes.length - 1) : 0);
}

/// Origin offsets for tracks with the given sizes and gap.
List<double> computeTrackOrigins(List<double> sizes, double gap) {
  final origins = <double>[];
  var origin = 0.0;
  for (final size in sizes) {
    origins.add(origin);
    origin += size + gap;
  }

  return origins;
}

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
  /// The constrained size reported to the parent.
  final Size size;

  /// Full track-and-gap extent before parent constraints are applied.
  final Size contentSize;
  final List<double> columnSizes;
  final List<double> rowSizes;

  /// Row tracks after implicit rows were resolved, parallel to [rowSizes].
  ///
  /// [RenderMixGrid.performLayout] needs the track *kind*, not just the size,
  /// to decide which children may keep a tight cell constraint.
  final List<GridTrack> rowTracks;
  final List<GridCellGeometry> cells;

  const GridLayoutResult({
    required this.size,
    required this.contentSize,
    required this.columnSizes,
    required this.rowSizes,
    required this.rowTracks,
    required this.cells,
  });
}

/// Computes grid geometry from tracks, gaps, and optional auto-row extents.
///
/// Children are placed row-major into a matrix of [columns] × [rows].
/// [rows] must already include implicit tracks. Callers that grow rows from
/// [childCount] resolve that list first so live and shared layout cannot
/// disagree. When no row is [GridTrack.auto], sizes use only fixed/fr rules
/// and parent constraints. Auto rows consume [autoRowHeights] at the matching
/// row index before remaining bounded height is given to fractional rows.
///
/// When [childCount] is 0 and [rows] is empty, no automatic rows are produced.
GridLayoutResult computeGridLayout({
  required BoxConstraints constraints,
  required List<GridTrack> columns,
  required List<GridTrack> rows,
  required double columnGap,
  required double rowGap,
  required int childCount,
  List<double>? autoRowHeights,
}) {
  assert(columns.isNotEmpty, 'Grid requires at least one column track.');

  final colCount = columns.length;

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
    tracks: rows,
    freeSpace: freeHeight,
    gap: rowGap,
    autoExtents: autoRowHeights,
  );

  final intrinsicWidth = axisExtent(columnSizes, columnGap);
  final intrinsicHeight = axisExtent(rowSizes, rowGap);
  final size = constraints.constrain(Size(intrinsicWidth, intrinsicHeight));
  final columnOrigins = computeTrackOrigins(columnSizes, columnGap);
  final rowOrigins = computeTrackOrigins(rowSizes, rowGap);

  final cells = <GridCellGeometry>[];
  for (var i = 0; i < childCount; i++) {
    final column = i % colCount;
    final row = i ~/ colCount;
    if (row >= rowSizes.length) break;
    cells.add(
      GridCellGeometry(
        column: column,
        row: row,
        offset: Offset(columnOrigins[column], rowOrigins[row]),
        size: Size(columnSizes[column], rowSizes[row]),
      ),
    );
  }

  return GridLayoutResult(
    size: size,
    contentSize: Size(intrinsicWidth, intrinsicHeight),
    columnSizes: columnSizes,
    rowSizes: rowSizes,
    rowTracks: rows,
    cells: cells,
  );
}

/// Expands explicit [rows] with [autoRows] until every child has a row.
List<GridTrack> _resolveEffectiveGridRows({
  required BoxConstraints constraints,
  required int columnCount,
  required List<GridTrack> rows,
  required GridTrack autoRows,
  required int childCount,
}) {
  final requiredRowCount = childCount == 0
      ? 0
      : ((childCount + columnCount - 1) ~/ columnCount);
  final missingRowCount = requiredRowCount - rows.length;
  if (missingRowCount > 0 &&
      autoRows is FrGridTrack &&
      !constraints.hasBoundedHeight) {
    throw FlutterError.fromParts([
      ErrorSummary(
        'Grid autoRows requires a bounded height for fractional tracks.',
      ),
      ErrorDescription(
        'The grid needs $missingRowCount additional rows under $constraints, '
        'but autoRows is $autoRows.',
      ),
      ErrorHint(
        'Use GridTrack.fixed or GridTrack.auto() for autoRows, or place the '
        'grid under a bounded height.',
      ),
    ]);
  }

  return [
    ...rows,
    if (missingRowCount > 0) ...List.filled(missingRowCount, autoRows),
  ];
}

/// Multi-child render object for [GridBoxSpec].
///
/// Supports fixed, fractional, and vertical auto tracks, row/column gaps,
/// row-major auto-placement, and render-time constraint branch selection via
/// [GridBoxSpec]. Fixed-track overflow is diagnosed on both axes and
/// optionally clipped by the spec. Excludes spans, named areas, content-sized
/// columns, RTL, and baseline.
class RenderMixGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData>,
        DebugOverflowIndicatorMixin {
  GridBoxSpec _spec;
  Size _contentSize = .zero;
  final LayerHandle<ClipRectLayer> _clipRectLayer =
      LayerHandle<ClipRectLayer>();

  RenderMixGrid({List<RenderBox>? children, required GridBoxSpec spec})
    : _spec = spec {
    addAll(children);
  }

  GridLayoutResult _compute(
    BoxConstraints constraints, {
    required ChildLayouter measureChild,
  }) {
    final geometry = _spec.resolveGeometryForConstraints(constraints);
    final effectiveRows = _resolveEffectiveGridRows(
      constraints: constraints,
      columnCount: geometry.columns.length,
      rows: geometry.rows,
      autoRows: geometry.autoRows,
      childCount: childCount,
    );
    final autoRowHeights = _hasAutoTrack(effectiveRows)
        ? _measureAutoRowHeights(
            constraints: constraints,
            geometry: geometry,
            effectiveRows: effectiveRows,
            measureChild: measureChild,
          )
        : null;

    return computeGridLayout(
      constraints: constraints,
      columns: geometry.columns,
      rows: effectiveRows,
      columnGap: geometry.columnGap,
      rowGap: geometry.rowGap,
      childCount: childCount,
      autoRowHeights: autoRowHeights,
    );
  }

  List<double> _measureAutoRowHeights({
    required BoxConstraints constraints,
    required GridResolvedGeometry geometry,
    required List<GridTrack> effectiveRows,
    required ChildLayouter measureChild,
  }) {
    final freeWidth = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : constraints.minWidth;
    final columnSizes = computeTrackSizes(
      tracks: geometry.columns,
      freeSpace: freeWidth,
      gap: geometry.columnGap,
    );
    final heights = List<double>.filled(effectiveRows.length, 0);
    final columnCount = geometry.columns.length;

    var index = 0;
    var child = firstChild;
    while (child != null) {
      final row = index ~/ columnCount;
      if (row < effectiveRows.length && effectiveRows[row] is AutoGridTrack) {
        final column = index % columnCount;
        final measured = measureChild(
          child,
          BoxConstraints.tightFor(width: columnSizes[column]),
        );
        if (!measured.height.isFinite) {
          throw _autoRowNeedsFiniteHeight(row, measured.height);
        }
        heights[row] = math.max(heights[row], measured.height);
      }
      child = (child.parentData! as MultiChildLayoutParentData).nextSibling;
      index++;
    }

    return heights;
  }

  /// Intrinsic extent after branch selection.
  ///
  /// Fractional tracks on the queried axis throw the same actionable
  /// [FlutterError] as unbounded layout (no LayoutBuilder cascade). Vertical
  /// auto rows use each child's max intrinsic height at the resolved column
  /// width.
  double _computeIntrinsicExtent({
    required Axis axis,
    required double crossExtent,
  }) {
    final BoxConstraints constraints = .new(
      maxWidth: axis == .vertical && crossExtent.isFinite
          ? crossExtent
          : .infinity,
      maxHeight: axis == .horizontal && crossExtent.isFinite
          ? crossExtent
          : .infinity,
    );
    final geometry = _spec.resolveGeometryForConstraints(constraints);
    final effectiveTracks = axis == .horizontal
        ? geometry.columns
        : _resolveEffectiveGridRows(
            constraints: constraints,
            columnCount: geometry.columns.length,
            rows: geometry.rows,
            autoRows: geometry.autoRows,
            childCount: childCount,
          );

    rejectFractionalGridTracksOnUnboundedAxis(
      tracks: effectiveTracks,
      axis: axis,
      constraints: constraints,
    );

    if (axis == .vertical && _hasAutoTrack(effectiveTracks)) {
      return _computeAutoRowIntrinsicHeight(
        geometry: geometry,
        effectiveRows: effectiveTracks,
        width: crossExtent,
      );
    }

    var sum = 0.0;
    for (final track in effectiveTracks) {
      switch (track) {
        case FixedGridTrack(:final size):
          sum += size;
        // An auto track never reaches here — the branch above returns first,
        // and columns reject auto during validation. The case exists only to
        // satisfy the sealed exhaustiveness check. A fractional track has no
        // intrinsic contribution because its size comes from free space.
        case AutoGridTrack():
        case FrGridTrack():
          break;
      }
    }
    if (effectiveTracks.length > 1) {
      final gap = axis == .horizontal ? geometry.columnGap : geometry.rowGap;
      sum += gap * (effectiveTracks.length - 1);
    }

    return sum;
  }

  double _computeAutoRowIntrinsicHeight({
    required GridResolvedGeometry geometry,
    required List<GridTrack> effectiveRows,
    required double width,
  }) {
    final columnSizes = computeTrackSizes(
      tracks: geometry.columns,
      freeSpace: width.isFinite ? width : 0.0,
      gap: geometry.columnGap,
    );
    final columnCount = geometry.columns.length;
    final autoRowHeights = List<double>.filled(effectiveRows.length, 0);

    // Mirrors _measureAutoRowHeights so the intrinsic answer and the laid-out
    // size are derived the same way; only the per-child measurement differs.
    var index = 0;
    var child = firstChild;
    while (child != null) {
      final row = index ~/ columnCount;
      if (row < effectiveRows.length && effectiveRows[row] is AutoGridTrack) {
        final column = index % columnCount;
        autoRowHeights[row] = math.max(
          autoRowHeights[row],
          child.getMaxIntrinsicHeight(columnSizes[column]),
        );
      }
      child = (child.parentData! as MultiChildLayoutParentData).nextSibling;
      index++;
    }

    final rowExtents = <double>[
      for (var row = 0; row < effectiveRows.length; row++)
        switch (effectiveRows[row]) {
          FixedGridTrack(:final size) => size,
          AutoGridTrack() => autoRowHeights[row],
          // A fractional row never reaches here: an intrinsic height query is
          // always built with an unbounded max height, and
          // rejectFractionalGridTracksOnUnboundedAxis has already thrown on
          // these tracks. The case exists only to satisfy the sealed
          // exhaustiveness check; 0.0 matches what free space would give.
          FrGridTrack() => 0.0,
        },
    ];

    return axisExtent(rowExtents, geometry.rowGap);
  }

  /// Final layout constraint for [child] in [cell], used by [performLayout].
  ///
  /// Fixed and fr rows keep the tight cell: their height never depends on the
  /// child, and tightness is the documented hard-constraint contract.
  ///
  /// An auto row's height is derived from its children, so those children must
  /// stay inside the grid's relayout boundary. A fully tight constraint would
  /// make the child its own boundary (see [RenderObject.layout]), so a later
  /// child-only change would never reach the grid and the row would keep the
  /// height measured on the first pass. Leaving max height unbounded keeps the
  /// constraint loose enough to propagate, while the min height stretches
  /// shorter siblings to fill the row.
  ///
  /// A child that already fills its row gets back the *exact* constraint
  /// [_measureAutoRowHeights] used, so [RenderObject.layout] takes its
  /// `!_needsLayout && constraints == _constraints` early return instead of
  /// running the subtree a second time. Every auto row has at least one such
  /// child, which is what stops nested auto grids from multiplying layout
  /// passes per level. Keep this constraint identical to the measure-pass one;
  /// widening it here would silently reintroduce the second pass.
  BoxConstraints _cellConstraints(
    RenderBox child,
    GridCellGeometry cell, {
    required bool isAutoRow,
  }) {
    if (!isAutoRow) return BoxConstraints.tight(cell.size);
    // Safe to read: auto-row children were laid out with parentUsesSize during
    // the measure pass. A row's height is the max of those measurements, so
    // `>=` only ever matches a child that needs no stretching.
    if (child.size.height >= cell.size.height) {
      return BoxConstraints.tightFor(width: cell.size.width);
    }

    return BoxConstraints(
      minWidth: cell.size.width,
      maxWidth: cell.size.width,
      minHeight: cell.size.height,
    );
  }

  bool get _hasVisualOverflow =>
      _contentSize.width - size.width > precisionErrorTolerance ||
      _contentSize.height - size.height > precisionErrorTolerance;

  GridBoxSpec get spec => _spec;

  Clip get clipBehavior => _spec.clipBehavior;

  /// Single equality-checked immutable spec setter.
  ///
  /// Constraint changes mark needsLayout only — no widget rebuild.
  set spec(GridBoxSpec value) {
    if (_spec == value) return;
    _spec = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _computeIntrinsicExtent(axis: .horizontal, crossExtent: height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _computeIntrinsicExtent(axis: .horizontal, crossExtent: height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _computeIntrinsicExtent(axis: .vertical, crossExtent: width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _computeIntrinsicExtent(axis: .vertical, crossExtent: width);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _compute(
      constraints,
      measureChild: ChildLayoutHelper.dryLayoutChild,
    ).size;
  }

  @override
  void performLayout() {
    final result = _compute(
      constraints,
      measureChild: ChildLayoutHelper.layoutChild,
    );
    size = result.size;
    _contentSize = result.contentSize;
    assert(result.cells.length == childCount);

    var index = 0;
    var child = firstChild;
    while (child != null) {
      final parentData = child.parentData! as MultiChildLayoutParentData;
      final cell = result.cells[index];
      final isAutoRow = result.rowTracks[cell.row] is AutoGridTrack;
      child.layout(
        _cellConstraints(child, cell, isAutoRow: isAutoRow),
        parentUsesSize: isAutoRow,
      );
      parentData.offset = cell.offset;
      child = parentData.nextSibling;
      index++;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (clipBehavior != .none && _hasVisualOverflow) {
      _clipRectLayer.layer = context.pushClipRect(
        needsCompositing,
        offset,
        Offset.zero & size,
        defaultPaint,
        clipBehavior: clipBehavior,
        oldLayer: _clipRectLayer.layer,
      );
    } else {
      _clipRectLayer.layer = null;
      defaultPaint(context, offset);
    }

    assert(() {
      if (!_hasVisualOverflow || size.isEmpty) return true;
      final overflowSize = Size(
        _contentSize.width > size.width ? _contentSize.width : size.width,
        _contentSize.height > size.height ? _contentSize.height : size.height,
      );
      paintOverflowIndicator(
        context,
        offset,
        Offset.zero & size,
        Offset.zero & overflowSize,
        overflowHints: [
          ErrorDescription(
            'The Grid tracks and gaps require $_contentSize, but the parent '
            'constrained $runtimeType to $size.',
          ),
          ErrorHint(
            'Fixed GridTrack sizes intentionally do not shrink. Reduce fixed '
            'tracks or gaps, replace suitable tracks with GridTrack.fr on a '
            'bounded axis, or give the GridBox more space.',
          ),
          ErrorHint(
            'If the larger content is intentional, put GridBox in a scrollable '
            'or set clipBehavior to Clip.hardEdge (or another non-none Clip). '
            'Clip.none deliberately leaves overflow visible.',
          ),
          ErrorHint(
            'Use GridTrack.auto() for unknown content height. Fixed tracks are '
            'hard constraints and do not grow to fit overflowing children.',
          ),
        ],
      );

      return true;
    }());
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  Rect? describeApproximatePaintClip(RenderObject child) {
    if (clipBehavior == .none || !_hasVisualOverflow) return null;

    return Offset.zero & size;
  }

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }
}

bool _hasAutoTrack(Iterable<GridTrack> tracks) =>
    tracks.any((track) => track is AutoGridTrack);

FlutterError _autoRowNeedsFiniteHeight(int row, double measuredHeight) {
  return FlutterError.fromParts([
    ErrorSummary('Grid auto rows require children with a finite height.'),
    ErrorDescription(
      'A child in row $row could not determine a finite height under '
      'unbounded vertical constraints.',
    ),
    ErrorDescription('Measured height: $measuredHeight'),
    ErrorHint(
      'Auto rows measure children at their column width with a loose '
      'height. Use finite-height content such as text or intrinsic boxes. '
      'Do not place Expanded, Spacer, or fractional-height layout inside '
      'an auto row in a vertical scroll view.',
    ),
  ]);
}

/// Internal widget host for [RenderMixGrid].
class MixGrid extends MultiChildRenderObjectWidget {
  const MixGrid({super.key, required this.spec, super.children});

  final GridBoxSpec spec;

  @override
  RenderMixGrid createRenderObject(BuildContext context) {
    return RenderMixGrid(spec: spec);
  }

  @override
  void updateRenderObject(BuildContext context, RenderMixGrid renderObject) {
    renderObject.spec = spec;
  }
}
