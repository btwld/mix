import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_example/layouts/grid/grid_example.dart';

import 'helpers/grid_example_test_fonts.dart';
import 'helpers/tolerant_golden_file_comparator.dart';

const _boundaryKey = Key('grid-golden-boundary');

void main() {
  setUpAll(loadGridExampleTestFonts);

  testWidgets('gallery switches real-world scenario and offered width', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const GridBoxExampleApp());

    expect(find.byType(GridBox), findsNWidgets(2));
    expect(find.byKey(const Key('dashboard-metrics-grid')), findsOneWidget);

    await tester.tap(find.text('Card catalog'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('catalog-grid')), findsOneWidget);

    await tester.tap(find.text('Compact'));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(const Key('catalog-grid'))).width, 334);
    expect(
      tester.getSize(find.byKey(const Key('catalog-card-1'))).height,
      greaterThan(
        tester.getSize(find.byKey(const Key('catalog-card-0'))).height,
      ),
    );

    await tester.tap(find.text('Media gallery'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('gallery-grid')), findsOneWidget);

    await tester.tap(find.text('Animation'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('animated-grid')), findsOneWidget);
  });

  testWidgets(
    'catalog rows follow unequal card content instead of one height',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: Center(
              child: SizedBox(width: 1120, child: CatalogGridPreview()),
            ),
          ),
        ),
      );

      final rowZero = tester
          .getSize(find.byKey(const Key('catalog-card-0')))
          .height;
      final rowOne = tester
          .getSize(find.byKey(const Key('catalog-card-3')))
          .height;
      expect(rowZero, isNot(rowOne));
      expect(
        tester.getSize(find.byKey(const Key('catalog-card-1'))).height,
        rowZero,
      );
      expect(
        tester.getSize(find.byKey(const Key('catalog-card-4'))).height,
        rowOne,
      );
    },
  );

  testWidgets('animation example interpolates tracks, rows, and gaps', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(840, 620));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: Material(
          child: Center(
            child: SizedBox(width: 704, child: AnimatedGridPreview()),
          ),
        ),
      ),
    );

    final leading = find.byKey(const Key('animation-card-reach'));
    final trailing = find.byKey(const Key('animation-card-spend'));

    double trackRatio() =>
        tester.getSize(leading).width / tester.getSize(trailing).width;
    double columnGap() =>
        tester.getTopLeft(trailing).dx - tester.getTopRight(leading).dx;

    expect(trackRatio(), moreOrLessEquals(1));
    expect(tester.getSize(leading).height, 112);
    expect(columnGap(), 12);

    await tester.tap(find.byKey(const Key('animation-toggle')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(trackRatio(), inExclusiveRange(1, 2));
    expect(tester.getSize(leading).height, inExclusiveRange(112, 148));
    expect(columnGap(), inExclusiveRange(12, 20));

    await tester.pumpAndSettle();

    expect(trackRatio(), moreOrLessEquals(2));
    expect(tester.getSize(leading).height, 148);
    expect(columnGap(), 20);
    expect(find.text('Focused allocation'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final golden in _goldens) {
    testWidgets('${golden.name} matches its golden', (tester) async {
      useTolerantGoldenFileComparator(
        'grid_box_example_test.dart',
        precisionTolerance: golden.precisionTolerance,
      );
      await tester.binding.setSurfaceSize(golden.surfaceSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: gridExampleTestFontFamily,
          ),
          home: Material(
            color: const Color(0xFFF4F5FA),
            child: Center(
              child: GridShowcase(
                kind: golden.kind,
                width: golden.width,
                boundaryKey: _boundaryKey,
              ),
            ),
          ),
        ),
      );

      if (golden.focusAnimation) {
        await tester.tap(find.byKey(const Key('animation-toggle')));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byKey(_boundaryKey),
        matchesGoldenFile('goldens/grid_${golden.name}.png'),
      );
    });
  }
}

class _GridGolden {
  const _GridGolden(
    this.name,
    this.kind,
    this.width,
    this.surfaceSize, {
    this.precisionTolerance = defaultGoldenDiffTolerance,
    this.focusAnimation = false,
  });

  final String name;
  final GridExampleKind kind;
  final double width;
  final Size surfaceSize;
  final double precisionTolerance;
  final bool focusAnimation;
}

const _goldens = [
  _GridGolden(
    'dashboard_wide',
    GridExampleKind.dashboard,
    1120,
    Size(1200, 560),
  ),
  _GridGolden(
    'dashboard_medium',
    GridExampleKind.dashboard,
    760,
    Size(840, 860),
  ),
  _GridGolden(
    'dashboard_compact',
    GridExampleKind.dashboard,
    390,
    Size(450, 1120),
  ),
  _GridGolden('catalog_wide', GridExampleKind.catalog, 1120, Size(1200, 660)),
  _GridGolden('catalog_compact', GridExampleKind.catalog, 390, Size(450, 1400)),
  _GridGolden('gallery_wide', GridExampleKind.gallery, 1120, Size(1200, 520)),
  // Dense gradients and rounded edges differ slightly between Skia platforms.
  _GridGolden(
    'gallery_compact',
    GridExampleKind.gallery,
    390,
    Size(450, 820),
    precisionTolerance: 0.04,
  ),
  // Animation text, icons, and rounded card edges rasterize just beyond the
  // shared macOS/Linux tolerance; geometry is asserted by the test above.
  _GridGolden(
    'animation_balanced',
    GridExampleKind.animation,
    760,
    Size(840, 540),
    precisionTolerance: 0.04,
  ),
  _GridGolden(
    'animation_focused',
    GridExampleKind.animation,
    760,
    Size(840, 620),
    precisionTolerance: 0.04,
    focusAnimation: true,
  ),
];
