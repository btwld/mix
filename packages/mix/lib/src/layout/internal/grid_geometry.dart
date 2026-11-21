import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../../core/breakpoint.dart';
import '../grid_box_spec.dart';
import '../grid_track.dart';
import 'grid_validation.dart';

/// Geometry after branch selection and before track sizing and placement.
///
/// Omitted [autoRows] becomes [GridTrack.auto] here. Styler and patch fields
/// stay nullable so a missing value still means "no override".
@immutable
final class GridResolvedGeometry {
  final List<GridTrack> columns;
  final List<GridTrack> rows;
  final GridTrack autoRows;
  final double columnGap;
  final double rowGap;

  const GridResolvedGeometry({
    required this.columns,
    required this.rows,
    required this.autoRows,
    required this.columnGap,
    required this.rowGap,
  });
}

extension GridBoxSpecGeometry on GridBoxSpec {
  /// Applies matching constraint branches in declaration order.
  GridResolvedGeometry resolveGeometryForConstraints(
    BoxConstraints constraints,
  ) {
    var resolvedColumns = columns;
    var resolvedRows = rows;
    var resolvedAutoRows = autoRows;
    var resolvedColumnGap = columnGap;
    var resolvedRowGap = rowGap;

    for (final branch in constraintBranches) {
      if (!_matchesBreakpointConstraints(branch.breakpoint, constraints)) {
        continue;
      }
      final patch = branch.patch;
      resolvedColumns = patch.columns ?? resolvedColumns;
      resolvedRows = patch.rows ?? resolvedRows;
      resolvedAutoRows = patch.autoRows ?? resolvedAutoRows;
      resolvedColumnGap = patch.columnGap ?? resolvedColumnGap;
      resolvedRowGap = patch.rowGap ?? resolvedRowGap;
    }

    rejectFractionalGridTracksOnUnboundedAxis(
      tracks: resolvedColumns,
      axis: .horizontal,
      constraints: constraints,
    );
    rejectFractionalGridTracksOnUnboundedAxis(
      tracks: resolvedRows,
      axis: .vertical,
      constraints: constraints,
    );

    return GridResolvedGeometry(
      columns: resolvedColumns,
      rows: resolvedRows,
      autoRows: resolvedAutoRows ?? const GridTrack.auto(),
      columnGap: resolvedColumnGap,
      rowGap: resolvedRowGap,
    );
  }
}

bool _matchesBreakpointConstraints(
  Breakpoint breakpoint,
  BoxConstraints constraints,
) {
  final constrainsWidth =
      breakpoint.minWidth != null || breakpoint.maxWidth != null;
  final constrainsHeight =
      breakpoint.minHeight != null || breakpoint.maxHeight != null;

  if (constrainsWidth && !constraints.hasBoundedWidth) return false;
  if (constrainsHeight && !constraints.hasBoundedHeight) return false;

  return breakpoint.matches(
    Size(
      constraints.hasBoundedWidth ? constraints.maxWidth : 0,
      constraints.hasBoundedHeight ? constraints.maxHeight : 0,
    ),
  );
}
