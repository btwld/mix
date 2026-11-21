import 'package:flutter/foundation.dart';

/// How a grid track is sized.
///
/// Rows accept fixed, fractional, and content-sized [GridTrack.auto] tracks.
/// Columns accept only fixed and fractional tracks; content-sized columns
/// are intentionally outside this API. Because one type covers both axes,
/// "auto is rows-only" is enforced at runtime rather than by the type system.
// Design note, deliberately not part of the published API docs: splitting this
// into row and column hierarchies was considered and rejected. It would not
// remove the equivalent check in the wire codec — JSON is untyped, so the
// schema must reject `auto` under `columns` regardless of the Dart type — and
// the factories below have static type `GridTrack`, so axis-specific lists
// would force duplicate factories or give up the dot-shorthand
// (`.columns([.fr(1)])`) this API is built around. The trade is one runtime
// throw against those two costs; do not split without re-checking both.
@immutable
sealed class GridTrack {
  /// Creates the base value for a concrete Grid track.
  const GridTrack();

  /// A track with a fixed [size] in logical pixels.
  ///
  /// [size] must resolve to a finite, non-negative value. A `SpaceToken`
  /// reference can be used when the track is supplied through
  /// `GridBoxStyler`; validation runs after token resolution.
  const factory GridTrack.fixed(double size) = FixedGridTrack;

  /// A track with [fraction] shares of the remaining free space.
  ///
  /// Remaining space is calculated after fixed tracks, auto tracks, and gaps.
  /// For example, `fr(2)` receives twice as much remaining space as `fr(1)`.
  /// [fraction] must resolve to a finite value greater than zero, and the
  /// track's axis must be bounded.
  const factory GridTrack.fr(double fraction) = FrGridTrack;

  /// A vertical track sized to the tallest child assigned to that row.
  ///
  /// Valid only in `rows` and `autoRows`. Column tracks reject this kind.
  const factory GridTrack.auto() = AutoGridTrack;
}

/// Track with a fixed size in logical pixels.
@immutable
final class FixedGridTrack extends GridTrack {
  /// The requested logical-pixel extent.
  final double size;

  /// Creates a fixed track with [size].
  ///
  /// Geometry is validated when a `GridBoxSpec` is created, after any token
  /// reference has been resolved by `GridBoxStyler`.
  const FixedGridTrack(this.size);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FixedGridTrack && other.size == size;

  @override
  String toString() => 'GridTrack.fixed($size)';

  @override
  int get hashCode => size.hashCode;
}

/// Track that takes a fraction of remaining free space after fixed tracks.
@immutable
final class FrGridTrack extends GridTrack {
  /// The track's relative share of remaining free space.
  final double fraction;

  /// Creates a fractional track with [fraction] shares.
  ///
  /// Geometry is validated when a `GridBoxSpec` is created, after any token
  /// reference has been resolved by `GridBoxStyler`.
  const FrGridTrack(this.fraction);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrGridTrack && other.fraction == fraction;

  @override
  String toString() => 'GridTrack.fr($fraction)';

  @override
  int get hashCode => fraction.hashCode;
}

/// Vertical track sized to the tallest assigned child's natural height.
@immutable
final class AutoGridTrack extends GridTrack {
  /// Creates a content-sized row track.
  const AutoGridTrack();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AutoGridTrack;

  @override
  String toString() => 'GridTrack.auto()';

  @override
  int get hashCode => runtimeType.hashCode;
}
