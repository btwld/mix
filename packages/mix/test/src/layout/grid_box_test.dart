// ignore_for_file: implementation_imports

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/layout/internal/grid_geometry.dart';
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
        tracks: const [GridTrack.fixed(100), GridTrack.fr(1), GridTrack.fr(1)],
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

    test('gap math produces the expected extent and track origins', () {
      final sizes = [100.0, 100.0, 100.0];
      expect(axisExtent(sizes, 10), 320); // 300 + 2*10
      expect(computeTrackOrigins(sizes, 10), [0, 110, 220]);
    });
  });

  group('computeGridLayout', () {
    test('fixed auto rows shrink-wrap under unbounded height', () {
      final result = computeGridLayout(
        constraints: const BoxConstraints(maxWidth: 100),
        columns: const [GridTrack.fixed(100)],
        rows: const [
          GridTrack.fixed(40),
          GridTrack.fixed(40),
          GridTrack.fixed(40),
        ],
        columnGap: 0,
        rowGap: 8,
        childCount: 3,
      );

      expect(result.rowSizes, [40.0, 40.0, 40.0]);
      expect(result.size, const Size(100, 136));
    });

    test(
      'auto rows use provided measured heights before fractional remainder',
      () {
        final result = computeGridLayout(
          constraints: const BoxConstraints.tightFor(width: 200, height: 200),
          columns: const [GridTrack.fr(1), GridTrack.fr(1)],
          rows: const [GridTrack.auto(), GridTrack.auto()],
          columnGap: 0,
          rowGap: 10,
          childCount: 4,
          autoRowHeights: const [40, 70],
        );

        expect(result.rowSizes, [40.0, 70.0]);
        expect(result.cells[2].offset.dy, 50);
        expect(result.contentSize.height, 120);
      },
    );

    test('fractional auto rows name the configured track when unbounded', () {
      final child = RenderConstrainedBox(
        additionalConstraints: const BoxConstraints.tightFor(
          width: 10,
          height: 10,
        ),
      );
      final render = RenderMixGrid(
        spec: GridBoxSpec(
          columns: const [GridTrack.fixed(100)],
          autoRows: const GridTrack.fr(1),
        ),
        children: [child],
      );
      try {
        expect(
          () => render.getDryLayout(const BoxConstraints(maxWidth: 100)),
          throwsA(
            isA<FlutterError>()
                .having(
                  (error) => error.toString(),
                  'message',
                  contains('autoRows'),
                )
                .having(
                  (error) => error.toString(),
                  'message',
                  contains('bounded height'),
                )
                .having(
                  (error) => error.toString(),
                  'message',
                  contains('GridTrack.fr(1'),
                ),
          ),
        );
      } finally {
        render.removeAll();
        render.dispose();
        child.dispose();
      }
    });

    test('row-major auto-placement', () {
      final result = computeGridLayout(
        constraints: const BoxConstraints.tightFor(width: 300, height: 200),
        columns: const [GridTrack.fr(1), GridTrack.fr(1), GridTrack.fr(1)],
        rows: const [GridTrack.fr(1), GridTrack.fr(1)],
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

    test('unbounded height with fixed rows uses fixed sizes', () {
      final result = computeGridLayout(
        constraints: const BoxConstraints(maxWidth: 300, minHeight: 0),
        columns: const [GridTrack.fixed(100)],
        rows: const [GridTrack.fixed(40), GridTrack.fixed(40)],
        columnGap: 0,
        rowGap: 8,
        childCount: 2,
      );

      expect(result.rowSizes, [40.0, 40.0]);
      expect(result.size.height, 88); // 40+40+8 gap
    });

    test('no auto rows when there are no children', () {
      final result = computeGridLayout(
        constraints: const BoxConstraints(maxWidth: 100, maxHeight: 100),
        columns: const [GridTrack.fixed(100)],
        rows: const [],
        columnGap: 0,
        rowGap: 0,
        childCount: 0,
      );

      expect(result.rowSizes, isEmpty);
      expect(result.cells, isEmpty);
      // Loose constraints: intrinsic height collapses to zero with no rows.
      expect(result.size.height, 0);
    });
  });

  group('Breakpoint constraint matching', () {
    GridBoxSpec specFor(Breakpoint breakpoint) {
      return GridBoxSpec(
        columns: const [GridTrack.fixed(100)],
        constraintBranches: [
          GridConstraintBranch(
            breakpoint: breakpoint,
            patch: const GridLayoutPatch(columnGap: 1),
          ),
        ],
      );
    }

    bool matches(Breakpoint breakpoint, BoxConstraints constraints) {
      final geometry = specFor(
        breakpoint,
      ).resolveGeometryForConstraints(constraints);

      return geometry.columnGap == 1;
    }

    test('maxWidth is inclusive and evaluates the offered maximum width', () {
      const breakpoint = Breakpoint.maxWidth(560);

      expect(matches(breakpoint, const BoxConstraints(maxWidth: 560)), isTrue);
      expect(matches(breakpoint, const BoxConstraints(maxWidth: 561)), isFalse);
      expect(
        matches(breakpoint, const BoxConstraints(minWidth: 400)),
        isFalse,
        reason: 'an unbounded width is not a concrete offered width',
      );
    });

    test('supports width and height ranges over bounded offered maxima', () {
      const breakpoint = Breakpoint(
        minWidth: 400,
        maxWidth: 560,
        minHeight: 200,
        maxHeight: 400,
      );

      expect(
        matches(
          breakpoint,
          const BoxConstraints.tightFor(width: 400, height: 200),
        ),
        isTrue,
      );
      expect(
        matches(
          breakpoint,
          const BoxConstraints.tightFor(width: 560, height: 400),
        ),
        isTrue,
      );
      expect(
        matches(
          breakpoint,
          const BoxConstraints.tightFor(width: 399, height: 300),
        ),
        isFalse,
      );
      expect(
        matches(breakpoint, const BoxConstraints(maxWidth: 500)),
        isFalse,
        reason: 'a constrained height breakpoint needs bounded height',
      );
    });

    test('validates breakpoints before they cross the render boundary', () {
      expect(
        () => specFor(const Breakpoint.maxWidth(-1)),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => specFor(const Breakpoint.maxWidth(.infinity)),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => specFor(const Breakpoint.widthRange(600, 500)),
        throwsA(isA<FlutterError>()),
      );
    });
  });

  group('GridBoxSpec', () {
    test('constructor validates and snapshots all caller-owned lists', () {
      final columns = [const GridTrack.fr(1), const GridTrack.fr(1)];
      final branchColumns = [const GridTrack.fr(1)];

      final spec = GridBoxSpec(
        columns: columns,
        constraintBranches: [
          GridConstraintBranch(
            breakpoint: Breakpoint.maxWidth(400),
            patch: GridLayoutPatch(columns: branchColumns),
          ),
        ],
      );

      columns.add(const GridTrack.fr(1));
      branchColumns.add(const GridTrack.fixed(10));

      expect(spec.columns, hasLength(2));
      expect(spec.constraintBranches.single.patch.columns, hasLength(1));
      expect(
        () => spec.columns.add(const GridTrack.fr(1)),
        throwsUnsupportedError,
      );
      expect(
        () => spec.constraintBranches.add(
          GridConstraintBranch(
            breakpoint: Breakpoint.maxWidth(300),
            patch: const GridLayoutPatch(columnGap: 4),
          ),
        ),
        throwsUnsupportedError,
      );
    });

    test('branch matching is inclusive and declaration ordered', () {
      final spec = GridBoxSpec(
        columns: const [GridTrack.fr(1), GridTrack.fr(1), GridTrack.fr(1)],
        constraintBranches: [
          GridConstraintBranch(
            breakpoint: Breakpoint.maxWidth(560),
            patch: const GridLayoutPatch(columns: [GridTrack.fr(1)]),
          ),
          GridConstraintBranch(
            breakpoint: Breakpoint.maxWidth(400),
            patch: const GridLayoutPatch(
              columns: [GridTrack.fixed(50), GridTrack.fixed(50)],
            ),
          ),
        ],
      );

      // Width 400 matches both maxWidth 560 and maxWidth 400; later wins.
      final at400 = spec.resolveGeometryForConstraints(
        const BoxConstraints.tightFor(width: 400, height: 100),
      );
      expect(at400.columns, hasLength(2));
      expect(at400.columns.first, isA<FixedGridTrack>());

      // Width 500 matches only first branch.
      final at500 = spec.resolveGeometryForConstraints(
        const BoxConstraints.tightFor(width: 500, height: 100),
      );
      expect(at500.columns, hasLength(1));

      // Width 600 matches none — base geometry.
      final at600 = spec.resolveGeometryForConstraints(
        const BoxConstraints.tightFor(width: 600, height: 100),
      );
      expect(at600.columns, hasLength(3));

      // Inclusive: exactly maxWidth matches.
      final at560 = spec.resolveGeometryForConstraints(
        const BoxConstraints.tightFor(width: 560, height: 100),
      );
      expect(at560.columns, hasLength(1));
    });

    test('partial patches preserve prior values', () {
      final spec = GridBoxSpec(
        columns: const [GridTrack.fr(1), GridTrack.fr(1)],
        rows: const [GridTrack.fixed(40)],
        columnGap: 8,
        rowGap: 4,
        constraintBranches: [
          GridConstraintBranch(
            breakpoint: Breakpoint.maxWidth(500),
            patch: const GridLayoutPatch(columnGap: 16),
          ),
        ],
      );

      final g = spec.resolveGeometryForConstraints(
        const BoxConstraints.tightFor(width: 400, height: 100),
      );
      expect(g.columns, hasLength(2));
      expect(g.rows, hasLength(1));
      expect(g.columnGap, 16);
      expect(g.rowGap, 4);
    });

    test('width breakpoint selects a branch when height is unbounded', () {
      final spec = GridBoxSpec(
        columns: const [GridTrack.fixed(50), GridTrack.fixed(50)],
        rows: const [GridTrack.fixed(40)],
        constraintBranches: [
          GridConstraintBranch(
            breakpoint: Breakpoint.maxWidth(500),
            patch: const GridLayoutPatch(columns: [GridTrack.fixed(100)]),
          ),
        ],
      );

      final narrow = spec.resolveGeometryForConstraints(
        const BoxConstraints(maxWidth: 400),
      );
      expect(narrow.columns, hasLength(1));
    });

    test('uses value equality for snapped geometry', () {
      final cols = [const GridTrack.fr(1), const GridTrack.fr(1)];
      final a = GridBoxSpec(
        columns: List.unmodifiable(List.of(cols)),
        columnGap: 8,
      );
      final b = GridBoxSpec(
        columns: List.unmodifiable(const [GridTrack.fr(1), GridTrack.fr(1)]),
        columnGap: 8,
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('lerp interpolates compatible tracks, rows, auto rows, and gaps', () {
      final start = GridBoxSpec(
        columns: const [GridTrack.fixed(100), GridTrack.fr(1)],
        rows: const [GridTrack.fixed(40)],
        autoRows: const GridTrack.fixed(20),
        columnGap: 4,
        rowGap: 6,
        clipBehavior: Clip.none,
        constraintBranches: const [
          GridConstraintBranch(
            breakpoint: Breakpoint.maxWidth(400),
            patch: GridLayoutPatch(columnGap: 2),
          ),
        ],
      );
      final end = GridBoxSpec(
        columns: const [GridTrack.fixed(200), GridTrack.fr(3)],
        rows: const [GridTrack.fixed(80)],
        autoRows: const GridTrack.fixed(60),
        columnGap: 20,
        rowGap: 10,
        clipBehavior: Clip.hardEdge,
        constraintBranches: const [
          GridConstraintBranch(
            breakpoint: Breakpoint.maxWidth(500),
            patch: GridLayoutPatch(columnGap: 8),
          ),
        ],
      );

      final midpoint = start.lerp(end, 0.5);

      expect(midpoint.columns, const [GridTrack.fixed(150), GridTrack.fr(2)]);
      expect(midpoint.rows, const [GridTrack.fixed(60)]);
      expect(midpoint.autoRows, const GridTrack.fixed(40));
      expect(midpoint.columnGap, 12);
      expect(midpoint.rowGap, 8);
      expect(midpoint.clipBehavior, Clip.hardEdge);
      expect(midpoint.constraintBranches, end.constraintBranches);
      expect(start.lerp(end, -0.5), start);
      expect(start.lerp(end, 1.5), end);
    });

    test('lerp snaps incompatible track topology at the midpoint', () {
      final start = GridBoxSpec(
        columns: const [GridTrack.fixed(100), GridTrack.fr(1)],
      );
      final differentType = GridBoxSpec(
        columns: const [GridTrack.fr(1), GridTrack.fr(1)],
      );
      final differentCount = GridBoxSpec(columns: const [GridTrack.fr(1)]);

      expect(start.lerp(differentType, 0.49).columns, start.columns);
      expect(start.lerp(differentType, 0.5).columns, differentType.columns);
      expect(start.lerp(differentCount, 0.49).columns, start.columns);
      expect(start.lerp(differentCount, 0.5).columns, differentCount.columns);
    });

    test('lerp keeps auto-to-auto stable and snaps auto-to-numeric', () {
      final auto = GridBoxSpec(
        columns: const [GridTrack.fixed(100)],
        rows: const [GridTrack.auto()],
        autoRows: const GridTrack.auto(),
      );
      final alsoAuto = GridBoxSpec(
        columns: const [GridTrack.fixed(100)],
        rows: const [GridTrack.auto()],
        autoRows: const GridTrack.auto(),
      );
      final fixed = GridBoxSpec(
        columns: const [GridTrack.fixed(100)],
        rows: const [GridTrack.fixed(40)],
        autoRows: const GridTrack.fixed(20),
      );

      expect(auto.lerp(alsoAuto, 0.5).rows, const [GridTrack.auto()]);
      expect(auto.lerp(alsoAuto, 0.5).autoRows, const GridTrack.auto());
      expect(auto.lerp(fixed, 0.49).rows, const [GridTrack.auto()]);
      expect(auto.lerp(fixed, 0.49).autoRows, const GridTrack.auto());
      expect(auto.lerp(fixed, 0.5).rows, const [GridTrack.fixed(40)]);
      expect(auto.lerp(fixed, 0.5).autoRows, const GridTrack.fixed(20));
    });
  });

  group('GridBoxSpec validation', () {
    test('empty columns throws', () {
      expect(
        () => GridBoxSpec(columns: const []),
        throwsA(isA<FlutterError>()),
      );
    });

    test('infinite fixed track and non-finite gaps throw FlutterError', () {
      expect(
        () => GridBoxSpec(columns: const [GridTrack.fixed(-1)]),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => GridBoxSpec(columns: const [GridTrack.fr(0)]),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => GridBoxSpec(columns: [FixedGridTrack(.infinity)]),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () =>
            GridBoxSpec(columns: const [GridTrack.fr(1)], columnGap: .infinity),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => GridBoxSpec(columns: const [GridTrack.fr(1)], rowGap: -2),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => GridBoxSpec(columns: [FrGridTrack(.infinity)]),
        throwsA(isA<FlutterError>()),
      );
    });

    test('constructor rejects invalid branch geometry', () {
      expect(
        () => GridBoxSpec(
          constraintBranches: [
            GridConstraintBranch(
              breakpoint: Breakpoint.maxWidth(100),
              patch: const GridLayoutPatch(),
            ),
          ],
        ),
        throwsA(
          isA<FlutterError>().having(
            (error) => error.toString(),
            'message',
            contains('empty patch'),
          ),
        ),
      );
      expect(
        () => GridBoxSpec(
          columns: const [GridTrack.fr(1)],
          constraintBranches: [
            GridConstraintBranch(
              breakpoint: Breakpoint.maxWidth(100),
              patch: GridLayoutPatch(columns: [FixedGridTrack(.infinity)]),
            ),
          ],
        ),
        throwsA(isA<FlutterError>()),
      );
    });

    test('unbounded fractional axis throws actionable FlutterError', () {
      final config = GridBoxSpec(
        columns: [GridTrack.fr(1)],
        rows: [GridTrack.fixed(40)],
      );

      Object? error;
      try {
        config.resolveGeometryForConstraints(
          const BoxConstraints(maxHeight: 100),
        );
      } catch (e) {
        error = e;
      }
      expect(error, isA<FlutterError>());
      final text = error?.toString() ?? '';
      expect(text, contains('bounded width'));
      expect(text, contains('Axis: width'));
      expect(text, contains('Tracks:'));
      expect(text, contains('fixed'));
    });

    test('fixed tracks under unbounded constraints succeed', () {
      final config = GridBoxSpec(
        columns: [GridTrack.fixed(80), GridTrack.fixed(80)],
        rows: [GridTrack.fixed(40)],
      );
      final g = config.resolveGeometryForConstraints(const BoxConstraints());
      expect(g.columns, hasLength(2));
    });
  });

  group('GridBoxStyler.onConstraints patch rules', () {
    test('rejects modifiers, animations, variants, nested branches, empty', () {
      expect(
        () => GridBoxStyler().onConstraints(
          Breakpoint.maxWidth(400),
          GridBoxStyler().wrap(const WidgetModifierConfig()),
        ),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => GridBoxStyler().onConstraints(
          Breakpoint.maxWidth(400),
          GridBoxStyler().animate(
            const CurveAnimationConfig(
              duration: Duration(milliseconds: 100),
              curve: Curves.linear,
            ),
          ),
        ),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => GridBoxStyler().onConstraints(
          Breakpoint.maxWidth(400),
          GridBoxStyler().onDark(const GridBoxStyler()),
        ),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => GridBoxStyler()
            .onConstraints(
              Breakpoint.maxWidth(400),
              const GridBoxStyler(columns: [GridTrack.fr(1)]),
            )
            .onConstraints(
              Breakpoint.maxWidth(300),
              GridBoxStyler().onConstraints(
                Breakpoint.maxWidth(200),
                const GridBoxStyler(columns: [GridTrack.fr(1)]),
              ),
            ),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => GridBoxStyler().onConstraints(
          Breakpoint.maxWidth(400),
          const GridBoxStyler(),
        ),
        throwsA(isA<FlutterError>()),
      );
    });

    test('merge appends constraint branches and merges geometry', () {
      final a = GridBoxStyler(columns: const [GridTrack.fr(1), GridTrack.fr(1)])
          .onConstraints(
            Breakpoint.maxWidth(560),
            const GridBoxStyler(columns: [GridTrack.fr(1)]),
          );
      final b = const GridBoxStyler(columnGap: 8).onConstraints(
        Breakpoint.maxWidth(400),
        const GridBoxStyler(columnGap: 4),
      );

      final merged = a.merge(b);
      expect(merged.$constraintBranches, hasLength(2));
      expect(merged.$columnGap, 8);
      expect(merged.$columns, hasLength(2));
    });

    test('base modifiers merge via MixOps.mergeModifier', () {
      final base = GridBoxStyler().wrap(WidgetModifierConfig.opacity(0.5));
      final other = GridBoxStyler().wrap(WidgetModifierConfig.opacity(0.8));
      final merged = base.merge(other);
      expect(merged.$modifier, isNotNull);
      // Merged config is a new object combining both.
      expect(merged.$modifier, isNot(same(base.$modifier)));
    });
  });

  group('GridBoxStyler resolution and animation', () {
    testWidgets('resolves tokens in base and constraint Grid geometry', (
      tester,
    ) async {
      const fixedTrack = SpaceToken('grid.track.fixed');
      const fractionalTrack = DoubleToken('grid.track.fraction');
      const automaticRow = SpaceToken('grid.row.auto');
      const gap = SpaceToken('grid.gap');
      const compactTrack = SpaceToken('grid.track.compact');

      final style =
          GridBoxStyler(
            columns: [
              GridTrack.fixed(fixedTrack()),
              GridTrack.fr(fractionalTrack()),
            ],
            rows: [GridTrack.fixed(fixedTrack())],
            autoRows: GridTrack.fixed(automaticRow()),
            columnGap: gap(),
            rowGap: gap(),
          ).onConstraints(
            const Breakpoint.maxWidth(400),
            GridBoxStyler(
              columns: [GridTrack.fixed(compactTrack())],
              autoRows: GridTrack.fixed(automaticRow()),
              columnGap: gap(),
              rowGap: gap(),
            ),
          );

      await tester.pumpWidget(
        MaterialApp(
          home: MixScope(
            spaces: {
              fixedTrack: 80,
              automaticRow: 32,
              gap: 12,
              compactTrack: 240,
            },
            doubles: {fractionalTrack: 2},
            child: Center(
              child: SizedBox(
                width: 300,
                height: 200,
                child: GridBox(style: style),
              ),
            ),
          ),
        ),
      );

      final spec = tester
          .renderObject<RenderMixGrid>(find.byType(MixGrid))
          .spec;
      expect(spec.columns, const [GridTrack.fixed(80), GridTrack.fr(2)]);
      expect(spec.rows, const [GridTrack.fixed(80)]);
      expect(spec.autoRows, const GridTrack.fixed(32));
      expect(spec.columnGap, 12);
      expect(spec.rowGap, 12);
      expect(spec.constraintBranches.single.patch.columns, const [
        GridTrack.fixed(240),
      ]);
      expect(
        spec.constraintBranches.single.patch.autoRows,
        const GridTrack.fixed(32),
      );
      expect(spec.constraintBranches.single.patch.columnGap, 12);
      expect(spec.constraintBranches.single.patch.rowGap, 12);
    });

    testWidgets('validates token values after Grid geometry resolves', (
      tester,
    ) async {
      const invalidTrack = SpaceToken('grid.track.invalid');

      await tester.pumpWidget(
        MaterialApp(
          home: MixScope(
            spaces: {invalidTrack: -1},
            child: GridBox(
              style: GridBoxStyler(columns: [GridTrack.fixed(invalidTrack())]),
            ),
          ),
        ),
      );

      expect(
        tester.takeException(),
        isA<FlutterError>().having(
          (error) => error.toString(),
          'message',
          contains('finite and non-negative'),
        ),
      );
    });

    testWidgets('animate interpolates compatible Grid geometry on screen', (
      tester,
    ) async {
      var expanded = false;
      late StateSetter updateGrid;

      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: StatefulBuilder(
              builder: (context, setState) {
                updateGrid = setState;

                return SizedBox(
                  width: 400,
                  height: 200,
                  child: GridBox(
                    style:
                        GridBoxStyler(
                          columns: [
                            GridTrack.fixed(expanded ? 200 : 100),
                            GridTrack.fr(expanded ? 3 : 1),
                          ],
                          rows: [GridTrack.fixed(expanded ? 100 : 40)],
                          autoRows: GridTrack.fixed(expanded ? 80 : 20),
                          columnGap: expanded ? 40 : 0,
                          rowGap: expanded ? 20 : 0,
                        ).animate(
                          AnimationConfig.linear(const Duration(seconds: 1)),
                        ),
                    children: const [
                      SizedBox(key: Key('animated-left')),
                      SizedBox(key: Key('animated-right')),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(const Key('animated-left'))),
        const Size(100, 40),
      );

      updateGrid(() => expanded = true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final midpoint = tester
          .renderObject<RenderMixGrid>(find.byType(MixGrid))
          .spec;
      expect(midpoint.columns, const [GridTrack.fixed(150), GridTrack.fr(2)]);
      expect(midpoint.rows, const [GridTrack.fixed(70)]);
      expect(midpoint.autoRows, const GridTrack.fixed(50));
      expect(midpoint.columnGap, 20);
      expect(midpoint.rowGap, 10);
      expect(
        tester.getSize(find.byKey(const Key('animated-left'))),
        const Size(150, 70),
      );
      final left = tester.getTopLeft(find.byKey(const Key('animated-left')));
      final right = tester.getTopLeft(find.byKey(const Key('animated-right')));
      expect(right.dx - left.dx, 170);

      await tester.pump(const Duration(milliseconds: 500));
      expect(
        tester.getSize(find.byKey(const Key('animated-left'))),
        const Size(200, 100),
      );
      expect(tester.takeException(), isNull);
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
                spec: GridBoxSpec(
                  columns: [
                    GridTrack.fixed(100),
                    GridTrack.fr(2),
                    GridTrack.fr(1),
                  ],
                  rows: [GridTrack.fr(1), GridTrack.fr(1)],
                  columnGap: 10,
                  rowGap: 10,
                ),
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
      expect(render.spec.columns.length, 3);
    });

    testWidgets('loose fixed auto rows produce meaningful live/dry parity', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: .min,
                children: [
                  MixGrid(
                    spec: GridBoxSpec(
                      columns: const [
                        GridTrack.fixed(100),
                        GridTrack.fixed(100),
                      ],
                      autoRows: const GridTrack.fixed(40),
                      columnGap: 10,
                      rowGap: 8,
                    ),
                    children: const [SizedBox(), SizedBox(), SizedBox()],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      final dry = render.getDryLayout(const BoxConstraints(maxWidth: 300));

      expect(render.size, const Size(210, 88));
      expect(dry, render.size);
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
                spec: GridBoxSpec(
                  columns: [GridTrack.fr(1), GridTrack.fr(1)],
                  autoRows: GridTrack.fr(1),
                ),
                children: const [
                  _LayoutCallCounter(key: Key('a')),
                  _LayoutCallCounter(key: Key('b')),
                  _LayoutCallCounter(key: Key('c')),
                ],
              ),
            ),
          ),
        ),
      );

      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      final counters = tester
          .renderObjectList<_RenderLayoutCallCounter>(
            find.byType(_LayoutCallCounter),
          )
          .toList();
      expect(counters, hasLength(3));
      expect(counters.map((counter) => counter.layoutCount), everyElement(1));

      for (final counter in counters) {
        counter.layoutCount = 0;
      }
      render.markNeedsLayout();
      await tester.pump();
      expect(counters.map((counter) => counter.layoutCount), everyElement(1));
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
                spec: GridBoxSpec(
                  columns: [GridTrack.fixed(100), GridTrack.fixed(100)],
                  rows: [GridTrack.fixed(100)],
                  columnGap: 20,
                ),
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

    testWidgets('hit testing hits the child at its laid-out offset', (
      tester,
    ) async {
      var leftTaps = 0;
      var rightTaps = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 220,
              height: 100,
              child: MixGrid(
                spec: GridBoxSpec(
                  columns: [GridTrack.fixed(100), GridTrack.fixed(100)],
                  rows: [GridTrack.fixed(100)],
                  columnGap: 20,
                ),
                children: [
                  GestureDetector(
                    key: const Key('left'),
                    onTap: () => leftTaps++,
                    behavior: .opaque,
                  ),
                  GestureDetector(
                    key: const Key('right'),
                    onTap: () => rightTaps++,
                    behavior: .opaque,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final rightCenter = tester.getCenter(find.byKey(const Key('right')));
      await tester.tapAt(rightCenter);

      expect(rightTaps, 1);
      expect(leftTaps, 0);
    });
  });

  group('GridBox render-time onConstraints', () {
    testWidgets(
      'onBreakpoint observes the viewport while onConstraints observes the container',
      (tester) async {
        const baseColumns = [GridTrack.fr(1), GridTrack.fr(1), GridTrack.fr(1)];
        const narrowColumns = [GridTrack.fr(1)];

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(1000, 800)),
              child: Column(
                children: [
                  SizedBox(
                    width: 400,
                    height: 100,
                    child: GridBox(
                      style: GridBoxStyler(columns: baseColumns).onBreakpoint(
                        const Breakpoint.maxWidth(560),
                        const GridBoxStyler(columns: narrowColumns),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    height: 100,
                    child: GridBox(
                      style: GridBoxStyler(columns: baseColumns).onConstraints(
                        const Breakpoint.maxWidth(560),
                        const GridBoxStyler(columns: narrowColumns),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        final renders = tester
            .renderObjectList<RenderMixGrid>(find.byType(MixGrid))
            .toList();
        expect(renders, hasLength(2));
        expect(renders.first.spec.columns, hasLength(3));
        expect(
          renders.last.spec
              .resolveGeometryForConstraints(renders.last.constraints)
              .columns,
          hasLength(1),
        );
      },
    );

    testWidgets('onConstraints resolves breakpoint tokens before layout', (
      tester,
    ) async {
      const compact = BreakpointToken('grid.breakpoint.compact');

      await tester.pumpWidget(
        MaterialApp(
          home: MixScope(
            breakpoints: {compact: const Breakpoint.maxWidth(560)},
            child: Center(
              child: SizedBox(
                width: 400,
                height: 100,
                child: GridBox(
                  style:
                      GridBoxStyler(
                        columns: const [
                          GridTrack.fr(1),
                          GridTrack.fr(1),
                          GridTrack.fr(1),
                        ],
                      ).onConstraints(
                        compact(),
                        const GridBoxStyler(columns: [GridTrack.fr(1)]),
                      ),
                ),
              ),
            ),
          ),
        ),
      );

      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      expect(
        render.spec.constraintBranches.single.breakpoint,
        const Breakpoint.maxWidth(560),
      );
      expect(
        render.spec.resolveGeometryForConstraints(render.constraints).columns,
        hasLength(1),
      );
    });

    testWidgets('three-to-one column switch via layout without child rebuild', (
      tester,
    ) async {
      // Honest contract: branch selection runs in performLayout. Hold the
      // MixGrid + child widget *instances* stable while only the parent
      // SizedBox width changes, so Element.updateChild short-circuits on
      // identical child widgets and Builders do not re-run.
      var childBuilds = 0;
      final config = GridBoxSpec(
        columns: const [GridTrack.fixed(80), GridTrack.fr(2), GridTrack.fr(1)],
        autoRows: const GridTrack.fr(1),
        columnGap: 8,
        rowGap: 8,
        constraintBranches: [
          GridConstraintBranch(
            breakpoint: Breakpoint.maxWidth(560),
            patch: const GridLayoutPatch(
              columns: [GridTrack.fr(1)],
              columnGap: 8,
              rowGap: 8,
            ),
          ),
        ],
      );

      // Created once — reused across pumps so child Elements are not updated.
      final children = <Widget>[
        Builder(
          builder: (context) {
            childBuilds++;

            return const ColoredBox(key: Key('cell0'), color: Colors.red);
          },
        ),
        Builder(
          builder: (context) {
            childBuilds++;

            return const ColoredBox(key: Key('cell1'), color: Colors.green);
          },
        ),
        Builder(
          builder: (context) {
            childBuilds++;

            return const ColoredBox(key: Key('cell2'), color: Colors.blue);
          },
        ),
      ];
      final grid = MixGrid(spec: config, children: children);

      await tester.pumpWidget(
        MaterialApp(
          home: Center(child: SizedBox(width: 900, height: 300, child: grid)),
        ),
      );

      expect(find.byType(LayoutBuilder), findsNothing);
      final buildsAfterWide = childBuilds;
      expect(buildsAfterWide, 3);

      // Wide: three columns → cell0 and cell1 share the first row.
      final wide0 = tester.getTopLeft(find.byKey(const Key('cell0')));
      final wide1 = tester.getTopLeft(find.byKey(const Key('cell1')));
      expect(wide1.dx, greaterThan(wide0.dx));
      expect(wide1.dy, wide0.dy);

      // Only parent constraints change; same MixGrid/child instances.
      await tester.pumpWidget(
        MaterialApp(
          home: Center(child: SizedBox(width: 400, height: 300, child: grid)),
        ),
      );

      // Branch selection must not rebuild children.
      expect(childBuilds, buildsAfterWide);

      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      final geometry = render.spec.resolveGeometryForConstraints(
        const BoxConstraints.tightFor(width: 400, height: 300),
      );
      expect(geometry.columns.length, 1);

      // Narrow: one column → children stack vertically.
      final narrowOffsets = [
        tester.getTopLeft(find.byKey(const Key('cell0'))),
        tester.getTopLeft(find.byKey(const Key('cell1'))),
      ];
      expect(narrowOffsets[1].dx, narrowOffsets[0].dx);
      expect(narrowOffsets[1].dy, greaterThan(narrowOffsets[0].dy));
    });

    testWidgets(
      'spec snapshot prevents caller list mutation from reaching render',
      (tester) async {
        final cols = [
          const GridTrack.fr(1),
          const GridTrack.fr(1),
          const GridTrack.fr(1),
        ];
        final config = GridBoxSpec(
          columns: cols,
          autoRows: const GridTrack.fr(1),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: SizedBox(
                width: 300,
                height: 100,
                child: MixGrid(
                  spec: config,
                  children: const [SizedBox(key: Key('only'))],
                ),
              ),
            ),
          ),
        );

        final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
        final snappedColumns = render.spec.columns;
        expect(snappedColumns, hasLength(3));
        // The spec owns its snapshot before it reaches the render boundary.
        expect(identical(snappedColumns, cols), isFalse);

        cols.add(const GridTrack.fr(1));
        expect(render.spec.columns, same(snappedColumns));
        expect(
          () => render.spec.columns.add(const GridTrack.fr(1)),
          throwsUnsupportedError,
        );
      },
    );

    testWidgets(
      'GridBoxStyler.onConstraints dashboard collapse under offered width',
      (tester) async {
        final width = ValueNotifier(900.0);
        addTearDown(width.dispose);

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
                      style:
                          GridBoxStyler(
                            columns: const [
                              GridTrack.fixed(80),
                              GridTrack.fr(2),
                              GridTrack.fr(1),
                            ],
                            autoRows: const GridTrack.fr(1),
                            columnGap: 8,
                            rowGap: 8,
                          ).onConstraints(
                            Breakpoint.maxWidth(560),
                            const GridBoxStyler(
                              columns: [GridTrack.fr(1)],
                              columnGap: 8,
                              rowGap: 8,
                            ),
                          ),
                      children: const [
                        ColoredBox(key: Key('cell0'), color: Colors.red),
                        ColoredBox(key: Key('cell1'), color: Colors.green),
                        ColoredBox(key: Key('cell2'), color: Colors.blue),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );

        var render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
        expect(render.spec.columns.length, 3);
        expect(find.byType(LayoutBuilder), findsNothing);

        width.value = 400;
        await tester.pump();

        render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
        final geometry = render.spec.resolveGeometryForConstraints(
          const BoxConstraints.tightFor(width: 400, height: 300),
        );
        expect(geometry.columns.length, 1);

        final narrow0 = tester.getTopLeft(find.byKey(const Key('cell0')));
        final narrow1 = tester.getTopLeft(find.byKey(const Key('cell1')));
        expect(narrow1.dx, narrow0.dx);
        expect(narrow1.dy, greaterThan(narrow0.dy));
      },
    );

    testWidgets('gallery 3×N collapses to one column under narrow width', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 300,
              height: 400,
              child: GridBox(
                style:
                    GridBoxStyler(
                      columns: const [
                        GridTrack.fr(1),
                        GridTrack.fr(1),
                        GridTrack.fr(1),
                      ],
                      autoRows: const GridTrack.fr(1),
                      columnGap: 8,
                      rowGap: 8,
                    ).onConstraints(
                      Breakpoint.maxWidth(560),
                      const GridBoxStyler(
                        columns: [GridTrack.fr(1)],
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
      final geometry = render.spec.resolveGeometryForConstraints(
        const BoxConstraints.tightFor(width: 300, height: 400),
      );
      expect(geometry.columns.length, 1);
      expect(render.childCount, 6);

      // Live layout places all six in one column (6 rows).
      final first = tester.getTopLeft(find.byKey(const Key('g0')));
      final second = tester.getTopLeft(find.byKey(const Key('g1')));
      expect(second.dx, first.dx);
      expect(second.dy, greaterThan(first.dy));
    });
  });

  group('intrinsic / unbounded diagnostics', () {
    testWidgets('fixed auto rows shrink-wrap inside a Column', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: .min,
              children: [
                GridBox(
                  style: const GridBoxStyler(
                    columns: [GridTrack.fixed(100)],
                    autoRows: GridTrack.fixed(40),
                    rowGap: 8,
                  ),
                  children: const [
                    SizedBox(key: Key('column-0')),
                    SizedBox(key: Key('column-1')),
                    SizedBox(key: Key('column-2')),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      expect(render.size, const Size(100, 136));
      expect(
        tester.getTopLeft(find.byKey(const Key('column-2'))).dy,
        tester.getTopLeft(find.byKey(const Key('column-0'))).dy + 96,
      );
    });

    testWidgets('fixed auto rows shrink-wrap inside a vertical scroll view', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 100,
              child: SingleChildScrollView(
                child: GridBox(
                  style: const GridBoxStyler(
                    columns: [GridTrack.fixed(100)],
                    autoRows: GridTrack.fixed(40),
                    rowGap: 8,
                  ),
                  children: const [
                    SizedBox(key: Key('scroll-0')),
                    SizedBox(key: Key('scroll-1')),
                    SizedBox(key: Key('scroll-2')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      expect(render.size, const Size(100, 136));
    });

    testWidgets('fixed-row Grid under IntrinsicHeight succeeds', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: IntrinsicHeight(
              child: MixGrid(
                spec: GridBoxSpec(
                  columns: [GridTrack.fixed(50), GridTrack.fixed(50)],
                  rows: [GridTrack.fixed(40)],
                  columnGap: 4,
                ),
                children: const [
                  SizedBox(key: Key('a')),
                  SizedBox(key: Key('b')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      expect(render.size.height, 40);
    });

    testWidgets(
      'fractional tracks on unbounded intrinsic axis produce Grid diagnostic',
      (tester) async {
        final captured = <String>[];
        final oldOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          captured.add(details.exceptionAsString());
          // Swallow so the test harness does not aggregate secondary failures.
        };

        try {
          await tester.pumpWidget(
            MaterialApp(
              home: Center(
                child: IntrinsicHeight(
                  child: MixGrid(
                    spec: GridBoxSpec(
                      columns: [GridTrack.fixed(50)],
                      rows: [GridTrack.fr(1)],
                    ),
                    children: const [SizedBox(key: Key('a'))],
                  ),
                ),
              ),
            ),
          );
        } finally {
          FlutterError.onError = oldOnError;
        }
        // Drain any residual exception stored by the binding.
        tester.takeException();

        final messages = captured.join('\n');
        expect(messages, isNotEmpty);
        // Expect a Grid fractional diagnostic — not LayoutBuilder cascade.
        expect(messages, contains('fractional'));
        expect(messages, contains('bounded height'));
        expect(messages, isNot(contains('LayoutBuilder')));
        expect(messages, isNot(contains('_RenderLayoutBuilder')));
      },
    );
  });

  group('content-sized auto rows', () {
    test('resolved geometry defaults omitted autoRows to auto', () {
      final spec = GridBoxSpec(
        columns: const [GridTrack.fr(1), GridTrack.fr(1)],
      );
      final geometry = spec.resolveGeometryForConstraints(
        const BoxConstraints.tightFor(width: 400, height: 200),
      );

      expect(geometry.autoRows, const GridTrack.auto());
    });

    testWidgets('omitted autoRows sizes implicit rows to content', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 200,
              child: GridBox(
                style: GridBoxStyler(
                  columns: [GridTrack.fr(1), GridTrack.fr(1)],
                ),
                children: [
                  SizedBox(key: Key('a'), height: 30),
                  SizedBox(key: Key('b'), height: 50),
                  SizedBox(key: Key('c'), height: 20),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      expect(render.size, const Size(200, 70));
      expect(tester.getSize(find.byKey(const Key('a'))), const Size(100, 50));
      expect(tester.getSize(find.byKey(const Key('b'))), const Size(100, 50));
      expect(tester.getSize(find.byKey(const Key('c'))), const Size(100, 20));
      expect(
        tester.getTopLeft(find.byKey(const Key('c'))).dy,
        tester.getTopLeft(find.byKey(const Key('a'))).dy + 50,
      );
    });

    testWidgets('explicit autoRows and rows use the same content rule', (
      tester,
    ) async {
      Future<Size> pump(GridBoxStyler style) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 120,
                child: GridBox(
                  style: style,
                  children: const [
                    SizedBox(key: Key('left'), height: 18),
                    SizedBox(key: Key('right'), height: 42),
                  ],
                ),
              ),
            ),
          ),
        );

        return tester.renderObject<RenderMixGrid>(find.byType(MixGrid)).size;
      }

      final omitted = await pump(
        const GridBoxStyler(columns: [GridTrack.fr(1), GridTrack.fr(1)]),
      );
      final automatic = await pump(
        const GridBoxStyler(
          columns: [GridTrack.fr(1), GridTrack.fr(1)],
          autoRows: GridTrack.auto(),
        ),
      );
      final explicit = await pump(
        const GridBoxStyler(
          columns: [GridTrack.fr(1), GridTrack.fr(1)],
          rows: [GridTrack.auto()],
        ),
      );

      expect(omitted, const Size(120, 42));
      expect(automatic, omitted);
      expect(explicit, omitted);
    });

    testWidgets(
      'scroll-view two-column auto rows size to independently measured text',
      (tester) async {
        const texts = [
          'Short',
          'This catalog card wraps to several lines at a 194-pixel width so the first row is taller than a single line.',
          'A medium-length product blurb that still wraps once.',
          'Tiny',
        ];
        const gap = 12.0;
        const width = 400.0;
        const cellWidth = 194.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                height: 600,
                child: SingleChildScrollView(
                  child: GridBox(
                    style: const GridBoxStyler(
                      columns: [GridTrack.fr(1), GridTrack.fr(1)],
                      columnGap: gap,
                      rowGap: gap,
                    ),
                    children: [
                      for (var index = 0; index < texts.length; index++)
                        Text(texts[index], key: Key('copy-$index')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
        final naturalHeights = [
          for (var index = 0; index < texts.length; index++)
            tester
                .renderObject<RenderBox>(find.byKey(Key('copy-$index')))
                .getDryLayout(const BoxConstraints.tightFor(width: cellWidth))
                .height,
        ];
        final firstRow = math.max(naturalHeights[0], naturalHeights[1]);
        final secondRow = math.max(naturalHeights[2], naturalHeights[3]);
        final firstOrigin = tester.getTopLeft(find.byKey(const Key('copy-0')));
        final secondOrigin = tester.getTopLeft(find.byKey(const Key('copy-2')));

        // Guards the fixture rather than the Grid: the assertions below are
        // written against measured text, so if font metrics ever made every
        // string fit one line they would all still pass while proving nothing
        // about content sizing. Both rows must stay genuinely unequal, and
        // each row must be taller than its shortest member.
        expect(firstRow, greaterThan(secondRow));
        expect(firstRow, greaterThan(naturalHeights[0]));
        expect(secondRow, greaterThan(naturalHeights[3]));

        expect(
          tester.getSize(find.byKey(const Key('copy-0'))).width,
          cellWidth,
        );
        expect(
          tester.getSize(find.byKey(const Key('copy-0'))).height,
          firstRow,
        );
        expect(
          tester.getSize(find.byKey(const Key('copy-1'))).height,
          firstRow,
        );
        expect(
          tester.getSize(find.byKey(const Key('copy-2'))).height,
          secondRow,
        );
        expect(secondOrigin.dy, firstOrigin.dy + firstRow + gap);
        expect(render.size, Size(width, firstRow + gap + secondRow));
      },
    );

    testWidgets('mixed auto and fixed rows keep both rules', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              child: GridBox(
                style: GridBoxStyler(
                  columns: [GridTrack.fixed(100)],
                  rows: [GridTrack.auto(), GridTrack.fixed(50)],
                ),
                children: [
                  SizedBox(key: Key('auto'), height: 24),
                  SizedBox(key: Key('fixed'), height: 10),
                ],
              ),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(const Key('auto'))),
        const Size(100, 24),
      );
      expect(
        tester.getSize(find.byKey(const Key('fixed'))),
        const Size(100, 50),
      );
      expect(
        tester.renderObject<RenderMixGrid>(find.byType(MixGrid)).size,
        const Size(100, 74),
      );
    });

    testWidgets('mixed auto and fr rows consume remaining bounded height', (
      tester,
    ) async {
      Future<void> pump({required bool tight}) async {
        final grid = GridBox(
          style: const GridBoxStyler(
            columns: [GridTrack.fixed(100)],
            rows: [GridTrack.auto(), GridTrack.fr(1)],
            rowGap: 10,
          ),
          children: const [
            SizedBox(key: Key('auto'), height: 40),
            SizedBox(key: Key('flex')),
          ],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: tight
                  ? SizedBox(width: 100, height: 200, child: grid)
                  : SizedBox(
                      width: 100,
                      height: 200,
                      child: OverflowBox(
                        maxHeight: 200,
                        minHeight: 0,
                        alignment: Alignment.topLeft,
                        child: grid,
                      ),
                    ),
            ),
          ),
        );
      }

      await pump(tight: true);
      expect(tester.getSize(find.byKey(const Key('auto'))).height, 40);
      expect(tester.getSize(find.byKey(const Key('flex'))).height, 150);

      await pump(tight: false);
      expect(tester.getSize(find.byKey(const Key('auto'))).height, 40);
      expect(tester.getSize(find.byKey(const Key('flex'))).height, 150);
    });

    testWidgets(
      'auto-row content that exceeds a bounded parent still overflows',
      (tester) async {
        final overflowErrors = <FlutterErrorDetails>[];
        final previousOnError = FlutterError.onError;
        FlutterError.onError = overflowErrors.add;
        try {
          await tester.pumpWidget(
            const MaterialApp(
              home: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 100,
                  height: 40,
                  child: GridBox(
                    style: GridBoxStyler(columns: [GridTrack.fixed(100)]),
                    children: [SizedBox(height: 90)],
                  ),
                ),
              ),
            ),
          );
        } finally {
          FlutterError.onError = previousOnError;
        }

        expect(overflowErrors, isNotEmpty);
        expect(
          overflowErrors.first.exception.toString(),
          contains('RenderMixGrid overflowed'),
        );
        expect(
          tester.renderObject<RenderMixGrid>(find.byType(MixGrid)).size,
          const Size(100, 40),
        );
      },
    );

    testWidgets(
      'onConstraints remeasures auto rows at the new cell width without rebuilds',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 600));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        var childBuilds = 0;
        final children = <Widget>[
          Builder(
            builder: (context) {
              childBuilds++;

              return const _WidthDrivenHeight(
                key: Key('wide-child'),
                factor: 0.5,
              );
            },
          ),
        ];
        final grid = MixGrid(
          spec: GridBoxSpec(
            columns: const [GridTrack.fr(1), GridTrack.fr(1)],
            constraintBranches: [
              GridConstraintBranch(
                breakpoint: Breakpoint.maxWidth(500),
                patch: const GridLayoutPatch(columns: [GridTrack.fr(1)]),
              ),
            ],
          ),
          children: children,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: 700, height: 400, child: grid),
            ),
          ),
        );

        expect(childBuilds, 1);
        expect(tester.getSize(find.byKey(const Key('wide-child'))).height, 175);

        await tester.pumpWidget(
          MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: 400, height: 400, child: grid),
            ),
          ),
        );

        expect(childBuilds, 1);
        expect(tester.getSize(find.byKey(const Key('wide-child'))).height, 200);
      },
    );

    testWidgets('a child that already fills its auto row is not relaid out', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 100,
              height: 200,
              child: MixGrid(
                spec: GridBoxSpec(
                  columns: const [GridTrack.fixed(100)],
                  rows: const [GridTrack.auto(), GridTrack.fixed(40)],
                ),
                children: const [
                  _LayoutCallCounter(key: Key('auto'), height: 30),
                  _LayoutCallCounter(key: Key('fixed'), height: 10),
                ],
              ),
            ),
          ),
        ),
      );

      final counters = tester
          .renderObjectList<_RenderLayoutCallCounter>(
            find.byType(_LayoutCallCounter),
          )
          .toList();
      // The auto-row child is measured, then handed the same constraint again
      // so RenderObject.layout early-returns: two calls, one relayout.
      expect(counters[0].layoutCount, 2);
      expect(counters[0].performLayoutCount, 1);
      expect(counters[1].layoutCount, 1);
      expect(counters[1].performLayoutCount, 1);
    });

    testWidgets('a shorter auto-row sibling is relaid out to fill the row', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 200,
              child: MixGrid(
                spec: GridBoxSpec(
                  columns: const [GridTrack.fixed(100), GridTrack.fixed(100)],
                ),
                children: const [
                  _LayoutCallCounter(key: Key('short'), height: 20),
                  _LayoutCallCounter(key: Key('tall'), height: 60),
                ],
              ),
            ),
          ),
        ),
      );

      final counters = tester
          .renderObjectList<_RenderLayoutCallCounter>(
            find.byType(_LayoutCallCounter),
          )
          .toList();
      expect(counters[0].performLayoutCount, 2, reason: 'stretched to 60');
      expect(counters[1].performLayoutCount, 1, reason: 'already 60 tall');
      expect(tester.getSize(find.byKey(const Key('short'))).height, 60);
    });

    testWidgets('nesting auto grids does not multiply leaf layout passes', (
      tester,
    ) async {
      // The measure pass hands each level the same constraint its parent used,
      // so a leaf that fills its row stays at one relayout no matter how deep
      // the nesting goes. Without that, cost is 2^depth.
      Widget nest(int depth) {
        Widget current = const _LayoutCallCounter(key: Key('leaf'), height: 25);
        for (var level = 0; level < depth; level++) {
          current = GridBox(
            style: const GridBoxStyler(columns: [GridTrack.fixed(100)]),
            children: [current],
          );
        }

        return current;
      }

      for (final depth in [1, 2, 3]) {
        // Force a fresh render object so counts never carry across depths.
        await tester.pumpWidget(const SizedBox());
        await tester.pumpWidget(
          MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: 100, child: nest(depth)),
            ),
          ),
        );

        final leaf = tester.renderObject<_RenderLayoutCallCounter>(
          find.byKey(const Key('leaf')),
        );
        expect(leaf.performLayoutCount, 1, reason: 'depth=$depth');
        expect(tester.getSize(find.byKey(const Key('leaf'))).height, 25);
      }
    });

    testWidgets('live and dry sizes match for deterministic auto-row boxes', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 200,
              child: MixGrid(
                spec: GridBoxSpec(
                  columns: const [GridTrack.fixed(100), GridTrack.fixed(100)],
                  autoRows: const GridTrack.auto(),
                  rowGap: 8,
                ),
                children: const [
                  SizedBox(height: 20),
                  SizedBox(height: 36),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      );

      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      final dry = render.getDryLayout(const BoxConstraints(maxWidth: 200));
      expect(render.size, const Size(200, 56));
      expect(dry, render.size);
    });

    testWidgets('vertical intrinsic height is the per-row max plus gaps', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 200,
              child: MixGrid(
                spec: GridBoxSpec(
                  columns: const [GridTrack.fr(1), GridTrack.fr(1)],
                  rowGap: 8,
                ),
                children: const [
                  SizedBox(height: 20),
                  SizedBox(height: 36),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      );

      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      expect(render.getMaxIntrinsicHeight(200), 56);
      expect(render.getMinIntrinsicHeight(200), 56);
    });

    testWidgets('incomplete last auto row stays well-defined', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 200,
              child: GridBox(
                style: GridBoxStyler(
                  columns: [GridTrack.fr(1), GridTrack.fr(1)],
                  rowGap: 6,
                ),
                children: [
                  SizedBox(height: 10),
                  SizedBox(height: 14),
                  SizedBox(key: Key('last'), height: 22),
                ],
              ),
            ),
          ),
        ),
      );

      final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      expect(render.size, const Size(200, 42));
      expect(
        tester.getSize(find.byKey(const Key('last'))),
        const Size(100, 22),
      );
    });

    testWidgets(
      'a child that cannot dry-layout reports Flutter dry-layout failure',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 200,
                height: 200,
                child: GridBox(
                  style: const GridBoxStyler(columns: [GridTrack.fixed(200)]),
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return const SizedBox(height: 40);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
        expect(
          () => render.getDryLayout(
            const BoxConstraints.tightFor(width: 200, height: 200),
          ),
          throwsA(
            isA<FlutterError>()
                .having(
                  (error) => error.toString(),
                  'message',
                  contains('dry layout'),
                )
                .having(
                  (error) => error.toString(),
                  'message',
                  isNot(contains('finite height')),
                ),
          ),
        );
      },
    );

    testWidgets(
      'an expanding auto-row child reports Flutter unbounded-flex error',
      (tester) async {
        final captured = <String>[];
        final previousOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          captured.add(details.exceptionAsString());
        };
        try {
          await tester.pumpWidget(
            const MaterialApp(
              home: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 200,
                  child: SingleChildScrollView(
                    child: GridBox(
                      style: GridBoxStyler(columns: [GridTrack.fr(1)]),
                      children: [
                        Column(children: [Expanded(child: SizedBox())]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } finally {
          FlutterError.onError = previousOnError;
        }
        final leftover = tester.takeException();
        if (leftover != null) {
          captured.add(leftover.toString());
        }

        final messages = captured.join('\n');
        expect(messages, contains('non-zero flex'));
        expect(messages, contains('incoming height constraints are unbounded'));
        expect(
          messages,
          isNot(
            contains('Grid auto rows require children with a finite height'),
          ),
        );
      },
    );

    testWidgets(
      'an auto-row child that throws StateError reports that StateError',
      (tester) async {
        final captured = <String>[];
        final previousOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          captured.add(details.exceptionAsString());
        };
        try {
          await tester.pumpWidget(
            const MaterialApp(
              home: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 200,
                  child: GridBox(
                    style: GridBoxStyler(columns: [GridTrack.fixed(200)]),
                    children: [_ThrowingLayoutBox()],
                  ),
                ),
              ),
            ),
          );
        } finally {
          FlutterError.onError = previousOnError;
        }
        final leftover = tester.takeException();
        if (leftover != null) {
          captured.add(leftover.toString());
        }

        final messages = captured.join('\n');
        expect(messages, contains('child-specific bug: index out of range'));
        expect(
          messages,
          isNot(
            contains('Grid auto rows require children with a finite height'),
          ),
        );
      },
    );

    testWidgets(
      'a child that does not implement computeDryLayout reports Flutter dry-layout failure',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 200,
                height: 200,
                child: GridBox(
                  style: GridBoxStyler(columns: [GridTrack.fixed(200)]),
                  children: [_NoDryLayoutBox()],
                ),
              ),
            ),
          ),
        );

        final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
        expect(
          () => render.getDryLayout(
            const BoxConstraints.tightFor(width: 200, height: 200),
          ),
          throwsA(
            isA<FlutterError>()
                .having(
                  (error) => error.toString(),
                  'message',
                  contains('does not implement "computeDryLayout"'),
                )
                .having(
                  (error) => error.toString(),
                  'message',
                  isNot(contains('finite height')),
                ),
          ),
        );
      },
    );

    testWidgets(
      'omitted autoRows grows a content-sized row beyond explicit rows',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 100,
                child: GridBox(
                  style: GridBoxStyler(
                    columns: [GridTrack.fixed(100)],
                    rows: [GridTrack.fixed(40)],
                  ),
                  children: [
                    SizedBox(height: 10),
                    SizedBox(key: Key('tall'), height: 72),
                  ],
                ),
              ),
            ),
          ),
        );

        final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
        expect(render.size.height, isNot(40));
        expect(render.size.height, 112);
        expect(
          tester.getSize(find.byKey(const Key('tall'))),
          const Size(100, 72),
        );
      },
    );

    testWidgets('an auto row re-measures when only the child changes', (
      tester,
    ) async {
      // A tight cell constraint would make the child its own relayout
      // boundary, so a child-only change would never reach the grid and the
      // row would keep its first measured height.
      Widget build(double height) => MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 100,
            child: GridBox(
              style: const GridBoxStyler(columns: [GridTrack.fixed(100)]),
              children: [SizedBox(key: const Key('a'), height: height)],
            ),
          ),
        ),
      );

      await tester.pumpWidget(build(30));
      expect(tester.getSize(find.byKey(const Key('a'))), const Size(100, 30));
      expect(
        tester.renderObject<RenderMixGrid>(find.byType(MixGrid)).size.height,
        30,
      );

      await tester.pumpWidget(build(80));
      expect(tester.getSize(find.byKey(const Key('a'))), const Size(100, 80));
      expect(
        tester.renderObject<RenderMixGrid>(find.byType(MixGrid)).size.height,
        80,
      );

      await tester.pumpWidget(build(15));
      expect(tester.getSize(find.byKey(const Key('a'))), const Size(100, 15));
      expect(
        tester.renderObject<RenderMixGrid>(find.byType(MixGrid)).size.height,
        15,
      );
    });

    testWidgets('an auto row grows when a child resizes itself via setState', (
      tester,
    ) async {
      // The test above drives the height from a parent rebuild, which reaches
      // the grid through the widget tree regardless of the constraint. This
      // one changes height entirely below the grid, with GridBoxSpec untouched
      // so MixGrid.updateRenderObject no-ops. The only path back to the grid is
      // markNeedsLayout propagating past the child, which a tight cell would
      // have stopped by making the child its own relayout boundary. Models the
      // real case: an async image or an expanding tile inside a scroll view.
      final key = GlobalKey<_ResizableState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              child: GridBox(
                style: const GridBoxStyler(columns: [GridTrack.fixed(100)]),
                children: [_Resizable(key: key, initialHeight: 30)],
              ),
            ),
          ),
        ),
      );

      final grid = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
      expect(grid.size.height, 30);

      key.currentState!.setHeight(90);
      await tester.pump();
      expect(grid.size.height, 90, reason: 'row must follow the child upward');

      key.currentState!.setHeight(20);
      await tester.pump();
      expect(grid.size.height, 20, reason: 'and back down');
    });

    testWidgets('an auto-row child still stretches to fill the taller row', (
      tester,
    ) async {
      // The auto-row cell is loose on max height so the child stays inside the
      // grid's relayout boundary. Min height must still stretch the child, and
      // the child must distribute that stretched extent internally.
      await tester.pumpWidget(
        const MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 200,
              child: GridBox(
                style: GridBoxStyler(
                  columns: [GridTrack.fixed(100), GridTrack.fixed(100)],
                ),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(key: Key('top'), height: 10, width: 10),
                      SizedBox(key: Key('bottom'), height: 10, width: 10),
                    ],
                  ),
                  SizedBox(key: Key('tall'), height: 90),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byKey(const Key('tall'))).height, 90);
      expect(tester.getTopLeft(find.byKey(const Key('top'))).dy, 0);
      expect(tester.getTopLeft(find.byKey(const Key('bottom'))).dy, 80);
    });

    testWidgets('a fixed row still hard-constrains a changing child', (
      tester,
    ) async {
      Widget build(double height) => MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 100,
            child: GridBox(
              style: const GridBoxStyler(
                columns: [GridTrack.fixed(100)],
                rows: [GridTrack.fixed(40)],
              ),
              children: [SizedBox(key: const Key('a'), height: height)],
            ),
          ),
        ),
      );

      await tester.pumpWidget(build(10));
      expect(tester.getSize(find.byKey(const Key('a'))), const Size(100, 40));

      await tester.pumpWidget(build(90));
      expect(tester.getSize(find.byKey(const Key('a'))), const Size(100, 40));
    });
  });
}

class _WidthDrivenHeight extends StatelessWidget {
  const _WidthDrivenHeight({super.key, required this.factor});

  final double factor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 1 / factor);
  }
}

class _LayoutCallCounter extends LeafRenderObjectWidget {
  const _LayoutCallCounter({super.key, this.height = 0});

  /// Natural height, so the counter can act as a tall or short auto-row child.
  final double height;

  @override
  _RenderLayoutCallCounter createRenderObject(BuildContext context) {
    return _RenderLayoutCallCounter(height);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderLayoutCallCounter renderObject,
  ) {
    renderObject.naturalHeight = height;
  }
}

class _RenderLayoutCallCounter extends RenderBox {
  _RenderLayoutCallCounter(this._naturalHeight);

  double _naturalHeight;

  int layoutCount = 0;

  /// Times the subtree actually relaid out.
  ///
  /// [layout] can be called without doing any work when the constraints are
  /// unchanged, so this is the metric that tracks real cost.
  int performLayoutCount = 0;

  set naturalHeight(double value) {
    if (_naturalHeight == value) return;
    _naturalHeight = value;
    markNeedsLayout();
  }

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    layoutCount++;
    super.layout(constraints, parentUsesSize: parentUsesSize);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      constraints.constrain(Size(constraints.minWidth, _naturalHeight));

  @override
  void performLayout() {
    performLayoutCount++;
    size = computeDryLayout(constraints);
  }
}

/// Changes its own height from below the grid, without any parent rebuild.
class _Resizable extends StatefulWidget {
  const _Resizable({super.key, required this.initialHeight});

  final double initialHeight;

  @override
  State<_Resizable> createState() => _ResizableState();
}

class _ResizableState extends State<_Resizable> {
  late double _height = widget.initialHeight;

  void setHeight(double value) => setState(() => _height = value);

  @override
  Widget build(BuildContext context) => SizedBox(height: _height);
}

class _ThrowingLayoutBox extends LeafRenderObjectWidget {
  const _ThrowingLayoutBox();

  @override
  RenderBox createRenderObject(BuildContext context) => _RenderThrowingLayout();
}

class _RenderThrowingLayout extends RenderBox {
  @override
  void performLayout() {
    throw StateError('child-specific bug: index out of range');
  }
}

class _NoDryLayoutBox extends LeafRenderObjectWidget {
  const _NoDryLayoutBox();

  @override
  RenderBox createRenderObject(BuildContext context) => _RenderNoDryLayout();
}

class _RenderNoDryLayout extends RenderBox {
  @override
  void performLayout() {
    size = constraints.constrain(const Size(10, 10));
  }
}
