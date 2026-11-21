import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/breakpoint.dart';
import '../core/spec.dart';
import 'grid_track.dart';
import 'internal/grid_validation.dart';

/// Partial geometry override for a constraint-matched branch.
///
/// Null fields preserve the prior value when the branch is applied.
@immutable
final class GridLayoutPatch {
  /// Replacement column tracks, or `null` to preserve prior columns.
  final List<GridTrack>? columns;

  /// Replacement explicit row tracks, or `null` to preserve prior rows.
  final List<GridTrack>? rows;

  /// Replacement repeated row track, or `null` to preserve the prior track.
  final GridTrack? autoRows;

  /// Replacement gap between columns, or `null` to preserve the prior gap.
  final double? columnGap;

  /// Replacement gap between rows, or `null` to preserve the prior gap.
  final double? rowGap;

  /// Creates a partial geometry override.
  ///
  /// At least one field must be non-null when the patch is attached to a
  /// [GridConstraintBranch].
  const GridLayoutPatch({
    this.columns,
    this.rows,
    this.autoRows,
    this.columnGap,
    this.rowGap,
  });

  /// Whether this patch changes any geometry field.
  bool get isEmpty =>
      columns == null &&
      rows == null &&
      autoRows == null &&
      columnGap == null &&
      rowGap == null;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GridLayoutPatch &&
            listEquals(columns, other.columns) &&
            listEquals(rows, other.rows) &&
            autoRows == other.autoRows &&
            columnGap == other.columnGap &&
            rowGap == other.rowGap;
  }

  @override
  String toString() {
    final cols = columns;
    final rws = rows;

    return 'GridLayoutPatch('
        'columns: ${cols == null ? 'null' : gridTracksToString(cols)}, '
        'rows: ${rws == null ? 'null' : gridTracksToString(rws)}, '
        'autoRows: ${autoRows ?? 'null'}, '
        'columnGap: ${columnGap ?? 'null'}, '
        'rowGap: ${rowGap ?? 'null'})';
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(columns ?? const []),
    Object.hashAll(rows ?? const []),
    autoRows,
    columnGap,
    rowGap,
  );
}

/// One local-constraint branch: [breakpoint] to [patch].
///
/// Unlike `onBreakpoint`, which observes the viewport through `MediaQuery`,
/// this breakpoint is matched against the bounded maximum size offered by the
/// Grid's parent. Branches are applied in declaration order at layout time.
@immutable
final class GridConstraintBranch {
  /// The local size range that activates [patch].
  final Breakpoint breakpoint;

  /// Geometry applied when [breakpoint] matches.
  final GridLayoutPatch patch;

  /// Creates a local constraint branch from [breakpoint] and [patch].
  const GridConstraintBranch({required this.breakpoint, required this.patch});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GridConstraintBranch &&
            breakpoint == other.breakpoint &&
            patch == other.patch;
  }

  @override
  String toString() =>
      'GridConstraintBranch(breakpoint: $breakpoint, patch: $patch)';

  @override
  int get hashCode => Object.hash(breakpoint, patch);
}

/// Immutable, validated geometry resolved from [GridBoxStyler].
///
/// This is the sole complete Grid geometry carrier. Branch selection happens
/// during live and dry layout, not while building the widget tree.
@immutable
final class GridBoxSpec extends Spec<GridBoxSpec> with Diagnosticable {
  /// Column tracks used for row-major placement.
  final List<GridTrack> columns;

  /// Explicit row tracks reserved by the Grid.
  final List<GridTrack> rows;

  /// Track repeated for each row required beyond [rows].
  ///
  /// `null` means no override, in which case implicit rows use
  /// [GridTrack.auto].
  final GridTrack? autoRows;

  /// Logical-pixel gap between adjacent columns.
  final double columnGap;

  /// Logical-pixel gap between adjacent rows.
  final double rowGap;

  /// How overflowing Grid content is clipped while painting.
  final Clip clipBehavior;

  /// Ordered local-constraint branches evaluated during layout.
  final List<GridConstraintBranch> constraintBranches;

  const GridBoxSpec._({
    required this.columns,
    required this.rows,
    required this.autoRows,
    required this.columnGap,
    required this.rowGap,
    required this.clipBehavior,
    required this.constraintBranches,
  });

  /// Creates a validated spec and snapshots every caller-owned collection.
  factory GridBoxSpec({
    List<GridTrack> columns = const [GridTrack.fr(1)],
    List<GridTrack> rows = const [],
    GridTrack? autoRows,
    double columnGap = 0,
    double rowGap = 0,
    Clip clipBehavior = .none,
    List<GridConstraintBranch> constraintBranches = const [],
  }) {
    final spec = GridBoxSpec._(
      columns: List<GridTrack>.unmodifiable(columns),
      rows: List<GridTrack>.unmodifiable(rows),
      autoRows: autoRows,
      columnGap: columnGap,
      rowGap: rowGap,
      clipBehavior: clipBehavior,
      constraintBranches: List<GridConstraintBranch>.unmodifiable([
        for (final branch in constraintBranches)
          GridConstraintBranch(
            breakpoint: branch.breakpoint,
            patch: _snapshotPatch(branch.patch),
          ),
      ]),
    );
    _validateGridSpecGeometry(spec);

    return spec;
  }

  /// Returns a validated copy with each non-null argument replaced.
  @override
  GridBoxSpec copyWith({
    List<GridTrack>? columns,
    List<GridTrack>? rows,
    GridTrack? autoRows,
    double? columnGap,
    double? rowGap,
    Clip? clipBehavior,
    List<GridConstraintBranch>? constraintBranches,
  }) {
    return GridBoxSpec(
      columns: columns ?? this.columns,
      rows: rows ?? this.rows,
      autoRows: autoRows ?? this.autoRows,
      columnGap: columnGap ?? this.columnGap,
      rowGap: rowGap ?? this.rowGap,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      constraintBranches: constraintBranches ?? this.constraintBranches,
    );
  }

  /// Interpolates compatible Grid geometry toward [other].
  ///
  /// Fixed tracks interpolate with fixed tracks, fractional tracks with
  /// fractional tracks, and auto tracks with auto tracks when their lists
  /// have the same length and kinds. Gaps also interpolate. Incompatible
  /// track lists, nullable or mismatched [autoRows], [clipBehavior], and
  /// [constraintBranches] switch at `t = 0.5`. Progress outside the `0...1`
  /// interval is clamped so geometry stays valid.
  @override
  GridBoxSpec lerp(GridBoxSpec? other, double t) {
    if (other == null) return this;

    final progress = t.clamp(0.0, 1.0);

    return GridBoxSpec(
      columns: _lerpGridTracks(columns, other.columns, progress),
      rows: _lerpGridTracks(rows, other.rows, progress),
      autoRows: _lerpOptionalGridTrack(autoRows, other.autoRows, progress),
      columnGap: ui.lerpDouble(columnGap, other.columnGap, progress)!,
      rowGap: ui.lerpDouble(rowGap, other.rowGap, progress)!,
      clipBehavior: progress < 0.5 ? clipBehavior : other.clipBehavior,
      constraintBranches: progress < 0.5
          ? constraintBranches
          : other.constraintBranches,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty('columns', columns))
      ..add(IterableProperty('rows', rows))
      ..add(DiagnosticsProperty('autoRows', autoRows))
      ..add(DoubleProperty('columnGap', columnGap))
      ..add(DoubleProperty('rowGap', rowGap))
      ..add(
        EnumProperty<Clip>(
          'clipBehavior',
          clipBehavior,
          defaultValue: Clip.none,
        ),
      )
      ..add(IterableProperty('constraintBranches', constraintBranches));
  }

  @override
  List<Object?> get props => [
    columns,
    rows,
    autoRows,
    columnGap,
    rowGap,
    clipBehavior,
    constraintBranches,
  ];
}

List<GridTrack> _lerpGridTracks(
  List<GridTrack> start,
  List<GridTrack> end,
  double t,
) {
  if (!_gridTrackListsAreCompatible(start, end)) {
    return t < 0.5 ? start : end;
  }

  return [
    for (var index = 0; index < start.length; index++)
      _lerpCompatibleGridTrack(start[index], end[index], t),
  ];
}

bool _gridTrackListsAreCompatible(List<GridTrack> start, List<GridTrack> end) {
  if (start.length != end.length) return false;

  for (var index = 0; index < start.length; index++) {
    if (!_gridTracksAreCompatible(start[index], end[index])) return false;
  }

  return true;
}

GridTrack? _lerpOptionalGridTrack(GridTrack? start, GridTrack? end, double t) {
  if (start == null || end == null || !_gridTracksAreCompatible(start, end)) {
    return t < 0.5 ? start : end;
  }

  return _lerpCompatibleGridTrack(start, end, t);
}

bool _gridTracksAreCompatible(GridTrack start, GridTrack end) {
  return switch ((start, end)) {
    (FixedGridTrack(), FixedGridTrack()) => true,
    (FrGridTrack(), FrGridTrack()) => true,
    (AutoGridTrack(), AutoGridTrack()) => true,
    _ => false,
  };
}

GridTrack _lerpCompatibleGridTrack(GridTrack start, GridTrack end, double t) {
  return switch ((start, end)) {
    (
      FixedGridTrack(size: final startSize),
      FixedGridTrack(size: final endSize),
    ) =>
      GridTrack.fixed(ui.lerpDouble(startSize, endSize, t)!),
    (
      FrGridTrack(fraction: final startFraction),
      FrGridTrack(fraction: final endFraction),
    ) =>
      GridTrack.fr(ui.lerpDouble(startFraction, endFraction, t)!),
    (AutoGridTrack(), AutoGridTrack()) => start,
    _ => throw StateError('Grid track interpolation requires matching types.'),
  };
}

void _validateGridSpecGeometry(GridBoxSpec spec) {
  final columns = spec.columns;
  if (columns.isEmpty) {
    throw FlutterError.fromParts([
      ErrorSummary('GridBoxSpec requires at least one column track.'),
      ErrorDescription('columns was empty.'),
      ErrorHint('Provide at least one fixed or fractional column track.'),
    ]);
  }

  _validateTracks(columns, axisLabel: 'columns');
  _validateTracks(spec.rows, axisLabel: 'rows', allowAuto: true);
  if (spec.autoRows case final track?) {
    _validateTracks([track], axisLabel: 'autoRows', allowAuto: true);
  }
  _validateGap(spec.columnGap, label: 'columnGap');
  _validateGap(spec.rowGap, label: 'rowGap');

  for (final branch in spec.constraintBranches) {
    _validateConstraintBreakpoint(branch.breakpoint);
    final patch = branch.patch;
    if (patch.isEmpty) {
      throw FlutterError.fromParts([
        ErrorSummary('GridLayoutPatch must set geometry.'),
        ErrorDescription(
          'A constraint branch supplied an empty patch with no columns, rows, '
          'autoRows, or gaps.',
        ),
        ErrorHint(
          'Set at least one geometry field or remove the constraint branch.',
        ),
      ]);
    }
    final patchColumns = patch.columns;
    final patchRows = patch.rows;
    final patchAutoRows = patch.autoRows;
    final patchColumnGap = patch.columnGap;
    final patchRowGap = patch.rowGap;

    if (patchColumns != null) {
      if (patchColumns.isEmpty) {
        throw FlutterError.fromParts([
          ErrorSummary(
            'GridLayoutPatch.columns must contain at least one track.',
          ),
          ErrorDescription('A constraint branch supplied empty columns.'),
          ErrorHint(
            'Omit columns to preserve the prior value, or supply tracks.',
          ),
        ]);
      }
      _validateTracks(patchColumns, axisLabel: 'patch.columns');
    }
    if (patchRows != null) {
      _validateTracks(patchRows, axisLabel: 'patch.rows', allowAuto: true);
    }
    if (patchAutoRows != null) {
      _validateTracks(
        [patchAutoRows],
        axisLabel: 'patch.autoRows',
        allowAuto: true,
      );
    }
    if (patchColumnGap != null) {
      _validateGap(patchColumnGap, label: 'patch.columnGap');
    }
    if (patchRowGap != null) {
      _validateGap(patchRowGap, label: 'patch.rowGap');
    }
  }
}

void _validateConstraintBreakpoint(Breakpoint breakpoint) {
  final (:minWidth, :maxWidth, :minHeight, :maxHeight) =
      _readConstraintBreakpoint(breakpoint);

  final values = {
    'minWidth': minWidth,
    'maxWidth': maxWidth,
    'minHeight': minHeight,
    'maxHeight': maxHeight,
  };
  if (values.values.every((value) => value == null)) {
    throw FlutterError.fromParts([
      ErrorSummary('Grid constraint breakpoint must contain a size bound.'),
      ErrorHint('Set at least one minimum or maximum width or height.'),
    ]);
  }

  for (final MapEntry(:key, :value) in values.entries) {
    if (value != null && (!value.isFinite || value < 0)) {
      throw FlutterError.fromParts([
        ErrorSummary('Invalid Grid constraint breakpoint $key.'),
        ErrorDescription('$key must be finite and non-negative; got $value.'),
      ]);
    }
  }

  if (minWidth != null && maxWidth != null && minWidth > maxWidth) {
    throw FlutterError.fromParts([
      ErrorSummary('Invalid Grid constraint breakpoint width range.'),
      ErrorDescription('minWidth ($minWidth) exceeds maxWidth ($maxWidth).'),
    ]);
  }
  if (minHeight != null && maxHeight != null && minHeight > maxHeight) {
    throw FlutterError.fromParts([
      ErrorSummary('Invalid Grid constraint breakpoint height range.'),
      ErrorDescription(
        'minHeight ($minHeight) exceeds maxHeight ($maxHeight).',
      ),
    ]);
  }
}

({double? minWidth, double? maxWidth, double? minHeight, double? maxHeight})
_readConstraintBreakpoint(Breakpoint breakpoint) {
  try {
    return (
      minWidth: breakpoint.minWidth,
      maxWidth: breakpoint.maxWidth,
      minHeight: breakpoint.minHeight,
      maxHeight: breakpoint.maxHeight,
    );
  } on UnsupportedError catch (error, stackTrace) {
    Error.throwWithStackTrace(
      FlutterError.fromParts([
        ErrorSummary('Grid constraint breakpoint must be resolved.'),
        ErrorDescription('$error'),
        ErrorHint(
          'Resolve breakpoint tokens through GridBoxStyler.onConstraints rather '
          'than constructing GridBoxSpec with an unresolved token reference.',
        ),
      ]),
      stackTrace,
    );
  }
}

GridLayoutPatch _snapshotPatch(GridLayoutPatch patch) {
  final columns = patch.columns;
  final rows = patch.rows;

  return GridLayoutPatch(
    columns: columns == null ? null : List<GridTrack>.unmodifiable(columns),
    rows: rows == null ? null : List<GridTrack>.unmodifiable(rows),
    autoRows: patch.autoRows,
    columnGap: patch.columnGap,
    rowGap: patch.rowGap,
  );
}

void _validateTracks(
  List<GridTrack> tracks, {
  required String axisLabel,
  bool allowAuto = false,
}) {
  for (var i = 0; i < tracks.length; i++) {
    final track = tracks[i];
    switch (track) {
      case FixedGridTrack(:final size):
        if (!size.isFinite || size < 0) {
          throw FlutterError.fromParts([
            ErrorSummary('Invalid fixed grid track on $axisLabel[$i].'),
            ErrorDescription(
              'Fixed track size must be finite and non-negative; got $size.',
            ),
            ErrorHint('Use GridTrack.fixed with a finite size ≥ 0.'),
          ]);
        }
      case FrGridTrack(:final fraction):
        if (!fraction.isFinite || fraction <= 0) {
          throw FlutterError.fromParts([
            ErrorSummary('Invalid fractional grid track on $axisLabel[$i].'),
            ErrorDescription(
              'Fractional track must be finite and greater than zero; '
              'got $fraction.',
            ),
            ErrorHint('Use GridTrack.fr with a finite fraction > 0.'),
          ]);
        }
      case AutoGridTrack():
        if (!allowAuto) {
          throw FlutterError.fromParts([
            ErrorSummary('GridTrack.auto() is only valid for rows.'),
            ErrorDescription('$axisLabel[$i] used GridTrack.auto().'),
            ErrorHint(
              'GridTrack.auto() is vertical-only. Use it in rows or autoRows '
              'after column widths are known. Content-sized columns are not '
              'supported.',
            ),
          ]);
        }
    }
  }
}

void _validateGap(double gap, {required String label}) {
  if (!gap.isFinite || gap < 0) {
    throw FlutterError.fromParts([
      ErrorSummary('Invalid grid gap ($label).'),
      ErrorDescription('Gaps must be finite and non-negative; got $gap.'),
      ErrorHint('Use a finite gap ≥ 0.'),
    ]);
  }
}
