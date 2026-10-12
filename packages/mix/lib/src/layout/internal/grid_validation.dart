import 'package:flutter/rendering.dart';

import '../grid_track.dart';

String gridTracksToString(List<GridTrack> tracks) {
  return [
    for (final track in tracks)
      switch (track) {
        FixedGridTrack(:final size) => 'GridTrack.fixed($size)',
        FrGridTrack(:final fraction) => 'GridTrack.fr($fraction)',
        AutoGridTrack() => 'GridTrack.auto()',
      },
  ].join(', ');
}

/// Rejects fractional tracks when their axis has no finite available extent.
void rejectFractionalGridTracksOnUnboundedAxis({
  required List<GridTrack> tracks,
  required Axis axis,
  required BoxConstraints constraints,
}) {
  if (!tracks.any((track) => track is FrGridTrack)) return;

  final bounded = axis == .horizontal
      ? constraints.hasBoundedWidth
      : constraints.hasBoundedHeight;
  if (bounded) return;

  final axisName = axis == .horizontal ? 'width' : 'height';
  throw FlutterError.fromParts([
    ErrorSummary('Grid fractional tracks require a bounded $axisName axis.'),
    ErrorDescription(
      'Axis: $axisName\n'
      'Constraints: $constraints\n'
      'Tracks: [${gridTracksToString(tracks)}]',
    ),
    ErrorHint(
      'Valid fixes:\n'
      '• Replace fractional tracks with GridTrack.fixed on this axis.\n'
      '• Place the grid under a bounded constraint '
      '(SizedBox, Expanded in a bounded Flex, etc.).\n'
      '• Use GridTrack.auto() for content-sized rows (not columns).',
    ),
  ]);
}
