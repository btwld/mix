import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../core/breakpoint.dart';
import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/style_spec.dart';
import '../core/style_widget.dart';
import '../modifiers/widget_modifier_config.dart';
import '../style/abstracts/styler.dart';
import '../theme/tokens/token_refs.dart';
import 'grid_box_spec.dart';
import 'grid_track.dart';
import 'render_grid.dart';

export 'grid_box_spec.dart';

/// Fluent style for [GridBox].
///
/// Geometry fields are nullable so partial merges (e.g. attaching variants)
/// do not clobber earlier values with constructor defaults.
///
/// Constraint-responsive geometry uses Grid-only [onConstraints] — patches
/// may contain columns, rows, autoRows, and gaps only. Paint configuration such
/// as [clipBehavior] remains on the base style. Constraint branches are
/// snapshotted into [GridBoxSpec] at [resolve] and applied at render time.
///
/// [clipBehavior] defaults to [Clip.none]. Fixed tracks keep their declared
/// size when they overflow; clipping changes paint containment, not geometry.
/// Numeric geometry accepts `SpaceToken` and `DoubleToken` references and
/// resolves them before [GridBoxSpec] validation.
class GridBoxStyler extends MixStyler<GridBoxStyler, GridBoxSpec>
    implements StylerFieldMetadata {
  /// Unresolved column tracks, or `null` to use one `fr(1)` column.
  final List<GridTrack>? $columns;

  /// Unresolved explicit row tracks, or `null` to use no explicit rows.
  final List<GridTrack>? $rows;

  /// Unresolved track repeated for rows required beyond [$rows].
  ///
  /// `null` means no override, in which case implicit rows use
  /// [GridTrack.auto].
  final GridTrack? $autoRows;

  /// Unresolved logical-pixel gap between columns.
  final double? $columnGap;

  /// Unresolved logical-pixel gap between rows.
  final double? $rowGap;

  /// Paint clipping policy, defaulting to [Clip.none] after resolution.
  final Clip? $clipBehavior;

  /// Ordered local-constraint branches attached by [onConstraints].
  final List<GridConstraintBranch>? $constraintBranches;

  /// Creates a potentially partial Grid style.
  ///
  /// Null geometry fields remain unset so this style can merge cleanly with
  /// other styles and variants.
  const GridBoxStyler({
    List<GridTrack>? columns,
    List<GridTrack>? rows,
    GridTrack? autoRows,
    double? columnGap,
    double? rowGap,
    Clip? clipBehavior,
    List<GridConstraintBranch>? constraintBranches,
    super.variants,
    super.modifier,
    super.animation,
  }) : $columns = columns,
       $rows = rows,
       $autoRows = autoRows,
       $columnGap = columnGap,
       $rowGap = rowGap,
       $clipBehavior = clipBehavior,
       $constraintBranches = constraintBranches;

  /// Creates a style with the given [columns].
  ///
  /// The list must contain at least one track. Fractional columns require a
  /// bounded width.
  factory GridBoxStyler.columns(List<GridTrack> columns) =>
      GridBoxStyler(columns: columns);

  /// Creates a style with [count] equally sized `fr(1)` columns.
  ///
  /// Throws an [ArgumentError] when [count] is less than one.
  factory GridBoxStyler.equalColumns(int count) =>
      GridBoxStyler(columns: _equalFractionalColumns(count));

  /// Creates a style with the given explicit [rows].
  factory GridBoxStyler.rows(List<GridTrack> rows) => GridBoxStyler(rows: rows);

  /// Creates a style that repeats [autoRows] for undeclared rows.
  ///
  /// Children are placed row-major. Each row needed beyond [rows] uses this
  /// track. Omitting it leaves implicit rows on [GridTrack.auto], so they
  /// size to their tallest child. A fixed track is a hard height; a
  /// fractional track requires bounded height.
  factory GridBoxStyler.autoRows(GridTrack autoRows) =>
      GridBoxStyler(autoRows: autoRows);

  /// Creates a style that sets both Grid gaps to [gap].
  factory GridBoxStyler.gap(double gap) =>
      GridBoxStyler(columnGap: gap, rowGap: gap);

  /// Creates a style with the logical-pixel [columnGap].
  factory GridBoxStyler.columnGap(double columnGap) =>
      GridBoxStyler(columnGap: columnGap);

  /// Creates a style with the logical-pixel [rowGap].
  factory GridBoxStyler.rowGap(double rowGap) => GridBoxStyler(rowGap: rowGap);

  /// Creates a style with [clipBehavior] as its paint clipping policy.
  factory GridBoxStyler.clipBehavior(Clip clipBehavior) =>
      GridBoxStyler(clipBehavior: clipBehavior);

  /// Creates a style with one local constraint branch.
  factory GridBoxStyler.onConstraints(
    Breakpoint breakpoint,
    GridBoxStyler patch,
  ) => GridBoxStyler().onConstraints(breakpoint, patch);

  /// Creates a Grid style using [animation] for implicit style changes.
  ///
  /// Same-length track lists interpolate when corresponding track kinds
  /// match. Different counts or kinds snap at the animation midpoint.
  factory GridBoxStyler.animate(AnimationConfig animation) =>
      GridBoxStyler().animate(animation);

  /// Replaces the column tracks with [value].
  GridBoxStyler columns(List<GridTrack> value) =>
      merge(GridBoxStyler(columns: value));

  /// Replaces the columns with [count] equally sized `fr(1)` tracks.
  ///
  /// Throws an [ArgumentError] when [count] is less than one.
  GridBoxStyler equalColumns(int count) =>
      columns(_equalFractionalColumns(count));

  /// Replaces the explicit row tracks with [value].
  GridBoxStyler rows(List<GridTrack> value) =>
      merge(GridBoxStyler(rows: value));

  /// Sets the track repeated for each row required beyond explicit [rows].
  ///
  /// Use [GridTrack.auto] for unknown content height. Omit this method to
  /// get the same default on implicit rows.
  GridBoxStyler autoRows(GridTrack value) =>
      merge(GridBoxStyler(autoRows: value));

  /// Sets both the column and row gap to [value].
  GridBoxStyler gap(double value) =>
      merge(GridBoxStyler(columnGap: value, rowGap: value));

  /// Sets the logical-pixel gap between adjacent columns.
  GridBoxStyler columnGap(double value) =>
      merge(GridBoxStyler(columnGap: value));

  /// Sets the logical-pixel gap between adjacent rows.
  GridBoxStyler rowGap(double value) => merge(GridBoxStyler(rowGap: value));

  /// Sets the paint clipping policy without changing Grid geometry.
  GridBoxStyler clipBehavior(Clip value) =>
      merge(GridBoxStyler(clipBehavior: value));

  /// Attaches a Grid-only constraint branch applied at render time.
  ///
  /// [breakpoint] observes the bounded maximum size offered to this Grid.
  /// Unlike [onBreakpoint], it does not observe the viewport. [patch] may set
  /// columns, rows, autoRows, and gaps only. Modifiers, animations, ordinary
  /// variants, nested constraint branches, and empty patches are rejected.
  /// Selection runs during layout without rebuilding the widget tree.
  /// Constraint selection is immediate even when the base style uses
  /// [animate]; it is not an implicit animation target.
  GridBoxStyler onConstraints(Breakpoint breakpoint, GridBoxStyler patch) {
    final layoutPatch = _createValidatedConstraintPatch(patch);

    return merge(
      GridBoxStyler(
        constraintBranches: [
          GridConstraintBranch(breakpoint: breakpoint, patch: layoutPatch),
        ],
      ),
    );
  }

  /// Adds implicit animation to compatible Grid geometry changes.
  ///
  /// Fixed sizes, fractional weights, row tracks, compatible `autoRows`, and
  /// gaps interpolate when their topology is compatible. Auto-to-auto stays
  /// constant. Track-count or track-kind changes, clipping, and constraint
  /// patches snap at the midpoint. A local [onConstraints] branch switch
  /// remains immediate because it occurs during layout without producing a
  /// new resolved style.
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
    final spec = GridBoxSpec(
      columns: _resolveGridTracks(context, $columns ?? const [GridTrack.fr(1)]),
      rows: _resolveGridTracks(context, $rows ?? const []),
      autoRows: _resolveOptionalGridTrack(context, $autoRows),
      columnGap: _resolveGridDouble(context, $columnGap ?? 0),
      rowGap: _resolveGridDouble(context, $rowGap ?? 0),
      clipBehavior: $clipBehavior ?? .none,
      constraintBranches: [
        for (final branch in $constraintBranches ?? const [])
          GridConstraintBranch(
            breakpoint: _resolveConstraintBreakpoint(
              context,
              branch.breakpoint,
            ),
            patch: _resolveGridLayoutPatch(context, branch.patch),
          ),
      ],
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  GridBoxStyler merge(covariant GridBoxStyler? other) {
    if (other == null) return this;

    final mergedConstraintBranches =
        $constraintBranches == null && other.$constraintBranches == null
        ? null
        : <GridConstraintBranch>[
            ...?$constraintBranches,
            ...?other.$constraintBranches,
          ];

    return GridBoxStyler(
      columns: other.$columns ?? $columns,
      rows: other.$rows ?? $rows,
      autoRows: other.$autoRows ?? $autoRows,
      columnGap: other.$columnGap ?? $columnGap,
      rowGap: other.$rowGap ?? $rowGap,
      clipBehavior: other.$clipBehavior ?? $clipBehavior,
      constraintBranches: mergedConstraintBranches,
      variants: MixOps.mergeVariants($variants, other.$variants),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
      animation: MixOps.mergeAnimation($animation, other.$animation),
    );
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'columns',
    'rows',
    'autoRows',
    'columnGap',
    'rowGap',
    'clipBehavior',
    'constraintBranches',
    'variants',
    'modifier',
    'animation',
  };

  @override
  List<Object?> get props => [
    $columns,
    $rows,
    $autoRows,
    $columnGap,
    $rowGap,
    $clipBehavior,
    $constraintBranches,
    $variants,
    $modifier,
    $animation,
  ];
}

List<GridTrack> _equalFractionalColumns(int count) {
  if (count < 1) {
    throw ArgumentError.value(count, 'count', 'Must be at least 1.');
  }

  return List<GridTrack>.unmodifiable(
    List.filled(count, const GridTrack.fr(1)),
  );
}

List<GridTrack> _resolveGridTracks(
  BuildContext context,
  Iterable<GridTrack> tracks,
) => [for (final track in tracks) _resolveGridTrack(context, track)];

GridTrack? _resolveOptionalGridTrack(BuildContext context, GridTrack? track) =>
    track == null ? null : _resolveGridTrack(context, track);

GridTrack _resolveGridTrack(BuildContext context, GridTrack track) {
  return switch (track) {
    FixedGridTrack(:final size) => GridTrack.fixed(
      _resolveGridDouble(context, size),
    ),
    FrGridTrack(:final fraction) => GridTrack.fr(
      _resolveGridDouble(context, fraction),
    ),
    AutoGridTrack() => track,
  };
}

double _resolveGridDouble(BuildContext context, double value) {
  return Prop.value(value).resolveProp(context);
}

GridLayoutPatch _resolveGridLayoutPatch(
  BuildContext context,
  GridLayoutPatch patch,
) {
  final columns = patch.columns;
  final rows = patch.rows;
  final autoRows = patch.autoRows;
  final columnGap = patch.columnGap;
  final rowGap = patch.rowGap;

  return GridLayoutPatch(
    columns: columns == null ? null : _resolveGridTracks(context, columns),
    rows: rows == null ? null : _resolveGridTracks(context, rows),
    autoRows: _resolveOptionalGridTrack(context, autoRows),
    columnGap: columnGap == null
        ? null
        : _resolveGridDouble(context, columnGap),
    rowGap: rowGap == null ? null : _resolveGridDouble(context, rowGap),
  );
}

Breakpoint _resolveConstraintBreakpoint(
  BuildContext context,
  Breakpoint breakpoint,
) {
  if (breakpoint case BreakpointRef(:final token)) {
    return token.resolve(context);
  }

  return breakpoint;
}

GridLayoutPatch _createValidatedConstraintPatch(GridBoxStyler patch) {
  if (patch.$modifier != null) {
    throw FlutterError.fromParts([
      ErrorSummary(
        'GridBoxStyler.onConstraints patch cannot include modifiers.',
      ),
      ErrorDescription(
        'Constraint patches may only set columns, rows, autoRows, and gaps.',
      ),
      ErrorHint('Move modifiers to the base GridBoxStyler.'),
    ]);
  }
  if (patch.$animation != null) {
    throw FlutterError.fromParts([
      ErrorSummary(
        'GridBoxStyler.onConstraints patch cannot include animation.',
      ),
      ErrorDescription(
        'Constraint patches may only set columns, rows, autoRows, and gaps.',
      ),
      ErrorHint('Move animation to the base GridBoxStyler.'),
    ]);
  }
  if (patch.$variants != null && patch.$variants!.isNotEmpty) {
    throw FlutterError.fromParts([
      ErrorSummary(
        'GridBoxStyler.onConstraints patch cannot include ordinary variants.',
      ),
      ErrorDescription(
        'Constraint patches may only set columns, rows, autoRows, and gaps.',
      ),
      ErrorHint('Attach variants on the base GridBoxStyler instead.'),
    ]);
  }
  final nestedConstraintBranches = patch.$constraintBranches;
  if (nestedConstraintBranches != null && nestedConstraintBranches.isNotEmpty) {
    throw FlutterError.fromParts([
      ErrorSummary(
        'GridBoxStyler.onConstraints patch cannot nest constraint branches.',
      ),
      ErrorDescription(
        'Chain onConstraints on the base styler; do not nest branches in a patch.',
      ),
    ]);
  }
  if (patch.$clipBehavior != null) {
    throw FlutterError.fromParts([
      ErrorSummary(
        'GridBoxStyler.onConstraints patch cannot include clipBehavior.',
      ),
      ErrorDescription(
        'Constraint patches are geometry-only; clipping is a paint policy.',
      ),
      ErrorHint('Move clipBehavior to the base GridBoxStyler.'),
    ]);
  }
  final columns = patch.$columns;
  final rows = patch.$rows;
  final layoutPatch = GridLayoutPatch(
    columns: columns == null ? null : List<GridTrack>.unmodifiable(columns),
    rows: rows == null ? null : List<GridTrack>.unmodifiable(rows),
    autoRows: patch.$autoRows,
    columnGap: patch.$columnGap,
    rowGap: patch.$rowGap,
  );
  if (layoutPatch.isEmpty) {
    throw FlutterError.fromParts([
      ErrorSummary('GridBoxStyler.onConstraints patch must set geometry.'),
      ErrorDescription(
        'An empty patch (no columns, rows, autoRows, or gaps) is not allowed.',
      ),
      ErrorHint(
        'Set at least one of columns, rows, autoRows, columnGap, or rowGap.',
      ),
    ]);
  }

  return layoutPatch;
}

/// Multi-child Grid widget driven by [GridBoxStyler] and [GridBoxSpec].
class GridBox extends StyleWidget<GridBoxSpec> {
  /// Creates a Grid that places [children] in row-major order.
  const GridBox({
    super.style = const GridBoxStyler(),
    super.styleSpec,
    super.key,
    this.children = const <Widget>[],
  });

  /// Children placed into cells in row-major order.
  final List<Widget> children;

  @override
  Widget build(BuildContext context, GridBoxSpec spec) {
    return MixGrid(spec: spec, children: children);
  }
}
