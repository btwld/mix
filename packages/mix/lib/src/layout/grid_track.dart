import 'package:flutter/foundation.dart';

/// How a grid track is sized.
///
/// Spike scope: only [fixed] and [fr]. Content-sized tracks are excluded.
@immutable
sealed class GridTrack {
  const GridTrack();

  /// Fixed pixel size.
  const factory GridTrack.fixed(double size) = FixedGridTrack;

  /// Fractional share of remaining free space.
  const factory GridTrack.fr(double fraction) = FrGridTrack;
}

/// Track with a fixed size in logical pixels.
@immutable
final class FixedGridTrack extends GridTrack {
  final double size;

  const FixedGridTrack(this.size) : assert(size >= 0);

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
  final double fraction;

  const FrGridTrack(this.fraction) : assert(fraction > 0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrGridTrack && other.fraction == fraction;

  @override
  String toString() => 'GridTrack.fr($fraction)';

  @override
  int get hashCode => fraction.hashCode;
}

/// Computes concrete track sizes for fixed + fr tracks under a free-space axis.
///
/// Shared by live layout and dry layout so both paths return the same sizes.
List<double> computeTrackSizes({
  required List<GridTrack> tracks,
  required double freeSpace,
  required double gap,
}) {
  if (tracks.isEmpty) return const [];

  var fixedSum = 0.0;
  var frSum = 0.0;
  for (final track in tracks) {
    switch (track) {
      case FixedGridTrack(:final size):
        fixedSum += size;
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
    for (final track in tracks)
      switch (track) {
        FixedGridTrack(:final size) => size,
        FrGridTrack(:final fraction) => frUnit * fraction,
      },
  ];
}

/// Total size along an axis for the given track sizes and gap.
double axisExtent(List<double> sizes, double gap) {
  if (sizes.isEmpty) return 0;
  final sum = sizes.fold<double>(0, (a, b) => a + b);

  return sum + (sizes.length > 1 ? gap * (sizes.length - 1) : 0);
}

/// Origin offset of track [index] given sizes and gap.
double trackOrigin(List<double> sizes, double gap, int index) {
  var origin = 0.0;
  for (var i = 0; i < index; i++) {
    origin += sizes[i] + gap;
  }

  return origin;
}
