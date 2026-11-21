// ignore_for_file: implementation_imports

import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/layout/render_grid.dart';

void main() {
  test('seeded fixed/fr layouts preserve the complete Grid contract', () {
    const seed = 0x4D4958;
    const iterations = 500;
    final random = Random(seed);

    for (var iteration = 0; iteration < iterations; iteration++) {
      final columnCount = 1 + random.nextInt(5);
      final childCount = random.nextInt(17);
      final requiredRows = childCount == 0
          ? 0
          : (childCount + columnCount - 1) ~/ columnCount;
      final explicitRowCount = requiredRows == 0
          ? 0
          : random.nextInt(requiredRows + 1);
      final missingRowCount = requiredRows - explicitRowCount;
      final columns = _tracks(random, columnCount);
      final rows = _tracks(random, explicitRowCount);
      final autoRows = missingRowCount == 0 ? null : _track(random);
      final effectiveRows = <GridTrack>[
        ...rows,
        if (missingRowCount > 0) ...List.filled(missingRowCount, autoRows!),
      ];
      final columnGap = random.nextInt(25).toDouble();
      final rowGap = random.nextDouble() * 24;
      final width = 40 + random.nextInt(761).toDouble();
      final height = 40 + random.nextInt(561).toDouble();
      final constraints = BoxConstraints.tightFor(width: width, height: height);
      final reason = 'seed=$seed iteration=$iteration';

      final result = computeGridLayout(
        constraints: constraints,
        columns: columns,
        rows: effectiveRows,
        columnGap: columnGap,
        rowGap: rowGap,
        childCount: childCount,
      );

      _expectFiniteNonNegative(result.columnSizes, reason);
      _expectFiniteNonNegative(result.rowSizes, reason);
      _expectFixedTracksPreserved(columns, result.columnSizes, reason);
      _expectFixedTracksPreserved(effectiveRows, result.rowSizes, reason);
      _expectFractionalRatios(columns, result.columnSizes, reason);
      _expectFractionalRatios(effectiveRows, result.rowSizes, reason);
      expect(
        result.contentSize.width,
        closeTo(_extent(result.columnSizes, columnGap), 1e-8),
        reason: reason,
      );
      expect(
        result.contentSize.height,
        closeTo(_extent(result.rowSizes, rowGap), 1e-8),
        reason: reason,
      );
      expect(result.size, Size(width, height), reason: reason);
      expect(result.cells, hasLength(childCount), reason: reason);

      for (var index = 0; index < result.cells.length; index++) {
        final cell = result.cells[index];
        expect(cell.column, index % columnCount, reason: reason);
        expect(cell.row, index ~/ columnCount, reason: reason);
        expect(
          cell.offset.dx,
          closeTo(_origin(result.columnSizes, columnGap, cell.column), 1e-8),
          reason: reason,
        );
        expect(
          cell.offset.dy,
          closeTo(_origin(result.rowSizes, rowGap, cell.row), 1e-8),
          reason: reason,
        );
        expect(
          cell.size,
          Size(result.columnSizes[cell.column], result.rowSizes[cell.row]),
          reason: reason,
        );
      }

      final children = <RenderBox>[
        for (var index = 0; index < childCount; index++)
          RenderConstrainedBox(additionalConstraints: const BoxConstraints()),
      ];
      final render = RenderMixGrid(
        spec: GridBoxSpec(
          columns: columns,
          rows: rows,
          autoRows: autoRows,
          columnGap: columnGap,
          rowGap: rowGap,
        ),
        children: children,
      );
      final drySize = render.getDryLayout(constraints);
      render.layout(constraints);
      expect(render.size, drySize, reason: reason);
      render.removeAll();
      render.dispose();
      for (final child in children) {
        child.dispose();
      }
    }
  });

  test('seeded auto rows size to the per-row child maximum', () {
    const seed = 0x4155544F;
    const iterations = 200;
    final random = Random(seed);

    for (var iteration = 0; iteration < iterations; iteration++) {
      final columnCount = 1 + random.nextInt(4);
      final childCount = 1 + random.nextInt(12);
      final requiredRows = (childCount + columnCount - 1) ~/ columnCount;
      final childHeights = List<double>.generate(
        childCount,
        (_) => 8 + random.nextInt(80).toDouble(),
      );
      final expectedRows = List<double>.filled(requiredRows, 0);
      for (var index = 0; index < childCount; index++) {
        final row = index ~/ columnCount;
        expectedRows[row] = max(expectedRows[row], childHeights[index]);
      }
      final rowGap = random.nextInt(17).toDouble();
      final width = 80.0 + random.nextInt(401);
      final constraints = BoxConstraints(maxWidth: width);
      final reason = 'seed=$seed iteration=$iteration';

      final result = computeGridLayout(
        constraints: constraints,
        columns: List<GridTrack>.filled(columnCount, const GridTrack.fr(1)),
        rows: List<GridTrack>.filled(requiredRows, const GridTrack.auto()),
        columnGap: 0,
        rowGap: rowGap,
        childCount: childCount,
        autoRowHeights: expectedRows,
      );

      expect(result.rowSizes, expectedRows, reason: reason);
      expect(
        result.contentSize.height,
        closeTo(_extent(expectedRows, rowGap), 1e-8),
        reason: reason,
      );
      expect(result.cells, hasLength(childCount), reason: reason);
      for (var index = 0; index < result.cells.length; index++) {
        final cell = result.cells[index];
        expect(cell.row, index ~/ columnCount, reason: reason);
        expect(
          cell.offset.dy,
          closeTo(_origin(result.rowSizes, rowGap, cell.row), 1e-8),
          reason: reason,
        );
        expect(cell.size.height, expectedRows[cell.row], reason: reason);
      }

      final children = <RenderBox>[
        for (final height in childHeights)
          RenderConstrainedBox(
            additionalConstraints: BoxConstraints.tightFor(height: height),
          ),
      ];
      final render = RenderMixGrid(
        spec: GridBoxSpec(
          columns: List<GridTrack>.filled(columnCount, const GridTrack.fr(1)),
          rowGap: rowGap,
        ),
        children: children,
      );
      final drySize = render.getDryLayout(constraints);
      render.layout(constraints);
      expect(render.size, drySize, reason: reason);
      expect(render.size.height, result.contentSize.height, reason: reason);
      render.removeAll();
      render.dispose();
      for (final child in children) {
        child.dispose();
      }
    }
  });
}

List<GridTrack> _tracks(Random random, int count) {
  return List.generate(count, (_) => _track(random));
}

GridTrack _track(Random random) {
  if (random.nextBool()) {
    return GridTrack.fixed(random.nextInt(241).toDouble());
  }

  return GridTrack.fr(1 + random.nextInt(4).toDouble());
}

void _expectFiniteNonNegative(List<double> sizes, String reason) {
  for (final size in sizes) {
    expect(size.isFinite, isTrue, reason: reason);
    expect(size, greaterThanOrEqualTo(0), reason: reason);
  }
}

void _expectFixedTracksPreserved(
  List<GridTrack> tracks,
  List<double> sizes,
  String reason,
) {
  for (var index = 0; index < tracks.length; index++) {
    if (tracks[index] case FixedGridTrack(:final size)) {
      expect(sizes[index], size, reason: reason);
    }
  }
}

void _expectFractionalRatios(
  List<GridTrack> tracks,
  List<double> sizes,
  String reason,
) {
  final indices = <int>[
    for (var index = 0; index < tracks.length; index++)
      if (tracks[index] is FrGridTrack) index,
  ];
  if (indices.length < 2) return;

  final first = indices.first;
  final firstFraction = (tracks[first] as FrGridTrack).fraction;
  for (final index in indices.skip(1)) {
    final fraction = (tracks[index] as FrGridTrack).fraction;
    expect(
      sizes[first] * fraction,
      closeTo(sizes[index] * firstFraction, 1e-8),
      reason: reason,
    );
  }
}

double _extent(List<double> sizes, double gap) {
  if (sizes.isEmpty) return 0;

  return sizes.reduce((total, size) => total + size) + gap * (sizes.length - 1);
}

double _origin(List<double> sizes, double gap, int index) {
  var result = gap * index;
  for (var before = 0; before < index; before++) {
    result += sizes[before];
  }

  return result;
}
