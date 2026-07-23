import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/core/providers/constraint_scope.dart';
import 'package:mix/src/layout/grid_box.dart';
import 'package:mix/src/layout/grid_track.dart';
import 'package:mix/src/layout/render_grid.dart';

void main() {
  group('computeTrackSizes', () {
    test('fixed tracks ignore free space', () {
      final sizes = computeTrackSizes(
        tracks: const [GridTrack.fixed(100), GridTrack.fixed(50)],
        freeSpace: 400,
        gap: 0,
      );
      expect(sizes, [100, 50]);
    });

    test('fr tracks share remaining after fixed and gaps', () {
      // free=300, fixed=100, gaps=2×10 → remaining=180; 1fr+1fr → 90 each
      final sizes = computeTrackSizes(
        tracks: const [
          GridTrack.fixed(100),
          GridTrack.fr(1),
          GridTrack.fr(1),
        ],
        freeSpace: 300,
        gap: 10,
      );
      expect(sizes[0], 100);
      expect(sizes[1], closeTo(90, 0.001));
      expect(sizes[2], closeTo(90, 0.001));
    });

    test('2fr vs 1fr ratio', () {
      final sizes = computeTrackSizes(
        tracks: const [GridTrack.fr(2), GridTrack.fr(1)],
        freeSpace: 300,
        gap: 0,
      );
      expect(sizes[0], closeTo(200, 0.001));
      expect(sizes[1], closeTo(100, 0.001));
    });

    test('gap math at track boundaries via axisExtent', () {
      final sizes = [100.0, 100.0, 100.0];
      expect(axisExtent(sizes, 10), 320); // 300 + 2*10
      expect(trackOrigin(sizes, 10, 0), 0);
      expect(trackOrigin(sizes, 10, 1), 110);
      expect(trackOrigin(sizes, 10, 2), 220);
    });
  });

  group('computeGridLayout', () {
    test('row-major auto-placement', () {
      final result = computeGridLayout(
        constraints: const BoxConstraints.tightFor(width: 300, height: 200),
        columns: const [GridTrack.fr(1), GridTrack.fr(1), GridTrack.fr(1)],
        rows: const [],
        columnGap: 0,
        rowGap: 0,
        childCount: 5,
      );

      expect(result.cells.length, 5);
      expect(result.cells[0].column, 0);
      expect(result.cells[0].row, 0);
      expect(result.cells[3].column, 0);
      expect(result.cells[3].row, 1);
      expect(result.cells[4].column, 1);
      expect(result.cells[4].row, 1);
      expect(result.columnSizes.every((s) => s == 100), isTrue);
    });

    test('unbounded height uses min height for free space', () {
      final result = computeGridLayout(
        constraints: const BoxConstraints(maxWidth: 300, minHeight: 0),
        columns: const [GridTrack.fr(1)],
        rows: const [GridTrack.fixed(40), GridTrack.fixed(40)],
        columnGap: 0,
        rowGap: 8,
        childCount: 2,
      );

      // free height is minHeight (0) when unbounded max → fr rows get 0;
      // fixed rows still contribute.
      expect(result.rowSizes, [40.0, 40.0]);
      expect(result.size.height, 88); // 40+40+8 gap
    });
  });

  group('RenderMixGrid live == dry', () {
    testWidgets('live size equals dry size for deterministic children', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 300,
              height: 200,
              child: MixGrid(
                columns: const [
                  GridTrack.fixed(100),
                  GridTrack.fr(2),
                  GridTrack.fr(1),
                ],
                rows: const [GridTrack.fr(1), GridTrack.fr(1)],
                columnGap: 10,
                rowGap: 10,
                children: List.generate(
                  6,
                  (i) => ColoredBox(
                    key: Key('c$i'),
                    color: Colors.primaries[i % Colors.primaries.length],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      final live = render.size;
      final dry = render.getDryLayout(
        const BoxConstraints.tightFor(width: 300, height: 200),
      );
      expect(live, dry);
      expect(live, const Size(300, 200));

      // fixed 100 + gap 10 + remaining 190 split 2:1 → 100, ~126.67, ~63.33
      expect(render.columns.length, 3);
    });

    testWidgets('each child laid out exactly once per performLayout', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: MixGrid(
                columns: const [GridTrack.fr(1), GridTrack.fr(1)],
                children: const [
                  SizedBox(key: Key('a')),
                  SizedBox(key: Key('b')),
                  SizedBox(key: Key('c')),
                ],
              ),
            ),
          ),
        ),
      );

      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      expect(render.childLayoutCount, 3);

      // Trigger another layout with same constraints.
      render.childLayoutCount = 0;
      render.markNeedsLayout();
      await tester.pump();
      expect(render.childLayoutCount, 3);
    });

    testWidgets('gap math at track boundaries positions children', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 220, // 100 + 20 gap + 100
              height: 100,
              child: MixGrid(
                columns: const [GridTrack.fixed(100), GridTrack.fixed(100)],
                rows: const [GridTrack.fixed(100)],
                columnGap: 20,
                children: const [
                  SizedBox(key: Key('left')),
                  SizedBox(key: Key('right')),
                ],
              ),
            ),
          ),
        ),
      );

      final left = tester.getTopLeft(find.byKey(const Key('left')));
      final right = tester.getTopLeft(find.byKey(const Key('right')));
      expect(right.dx - left.dx, 120); // 100 width + 20 gap
    });
  });

  group('GridBox + onConstraints composition', () {
    testWidgets('dashboard collapse: 1fr 2fr 1fr → 1 col under maxWidth', (
      tester,
    ) async {
      final width = ValueNotifier(900.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: ValueListenableBuilder<double>(
              valueListenable: width,
              builder: (context, w, _) {
                return SizedBox(
                  width: w,
                  height: 300,
                  child: GridBox(
                    style: GridBoxStyler(
                      columns: const [
                        GridTrack.fixed(80),
                        GridTrack.fr(2),
                        GridTrack.fr(1),
                      ],
                      columnGap: 8,
                      rowGap: 8,
                    ).onConstraints(
                      const Breakpoint(maxWidth: 560),
                      GridBoxStyler(
                        columns: const [GridTrack.fr(1)],
                        columnGap: 8,
                        rowGap: 8,
                      ),
                    ),
                    children: List.generate(
                      3,
                      (i) => ColoredBox(
                        key: Key('cell$i'),
                        color: Colors.primaries[i],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      var render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      expect(render.columns.length, 3);
      expect(find.byType(ConstraintScope), findsOneWidget);

      width.value = 400;
      await tester.pumpAndSettle();

      render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      expect(render.columns.length, 1);

      width.dispose();
    });

    testWidgets('gallery 3×N collapses to one column', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 300,
              height: 400,
              child: GridBox(
                style: GridBoxStyler(
                  columns: const [
                    GridTrack.fr(1),
                    GridTrack.fr(1),
                    GridTrack.fr(1),
                  ],
                  columnGap: 8,
                  rowGap: 8,
                ).onConstraints(
                  const Breakpoint(maxWidth: 560),
                  GridBoxStyler(
                    columns: const [GridTrack.fr(1)],
                    columnGap: 8,
                    rowGap: 8,
                  ),
                ),
                children: List.generate(
                  6,
                  (i) => ColoredBox(
                    key: Key('g$i'),
                    color: Colors.primaries[i % Colors.primaries.length],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      expect(render.columns.length, 1);
      // 6 children in 1 column → 6 rows auto
      expect(render.childCount, 6);
    });
  });
}
