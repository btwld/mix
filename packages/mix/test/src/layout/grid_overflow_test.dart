// ignore_for_file: implementation_imports

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/layout/render_grid.dart';

void main() {
  test('contentSize preserves overflowing fixed tracks on both axes', () {
    final result = computeGridLayout(
      constraints: const BoxConstraints.tightFor(width: 100, height: 60),
      columns: const [GridTrack.fixed(80), GridTrack.fixed(70)],
      rows: const [GridTrack.fixed(40), GridTrack.fixed(30)],
      columnGap: 10,
      rowGap: 5,
      childCount: 4,
    );

    expect(result.size, const Size(100, 60));
    expect(result.contentSize, const Size(160, 75));
    expect(result.columnSizes, [80, 70]);
    expect(result.rowSizes, [40, 30]);
    expect(result.cells[3].offset, const Offset(90, 45));
  });

  test('Grid clip behavior defaults to none and resolves through the spec', () {
    const defaultStyle = GridBoxStyler();
    const clippedStyle = GridBoxStyler(clipBehavior: .hardEdge);

    expect(defaultStyle.$clipBehavior, isNull);
    expect(clippedStyle.$clipBehavior, Clip.hardEdge);
    expect(
      GridBoxSpec(
        columns: const [GridTrack.fixed(10)],
        clipBehavior: .antiAlias,
      ).clipBehavior,
      Clip.antiAlias,
    );
  });

  test('onConstraints rejects clipBehavior with an actionable message', () {
    expect(
      () => const GridBoxStyler().onConstraints(
        Breakpoint.maxWidth(400),
        const GridBoxStyler(clipBehavior: .hardEdge),
      ),
      throwsA(
        isA<FlutterError>()
            .having(
              (error) => error.toString(),
              'message',
              contains('clipBehavior'),
            )
            .having(
              (error) => error.toString(),
              'message',
              contains('base GridBoxStyler'),
            ),
      ),
    );
  });

  testWidgets('overflow with clipping exposes the Grid paint clip', (
    tester,
  ) async {
    final overflowErrors = <FlutterErrorDetails>[];
    final previousOnError = FlutterError.onError;
    FlutterError.onError = overflowErrors.add;
    try {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 60,
              child: MixGrid(
                spec: GridBoxSpec(
                  columns: const [GridTrack.fixed(160)],
                  rows: const [GridTrack.fixed(75)],
                  clipBehavior: .hardEdge,
                ),
                children: const [ColoredBox(color: Colors.blue)],
              ),
            ),
          ),
        ),
      );
    } finally {
      FlutterError.onError = previousOnError;
    }

    final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
    expect(overflowErrors, isNotEmpty);
    expect(render.size, const Size(100, 60));
    expect(
      render.describeApproximatePaintClip(render.firstChild!),
      Offset.zero & render.size,
    );
  });

  testWidgets('Clip.none paints overflow while Clip.hardEdge hides it', (
    tester,
  ) async {
    final overflowErrors = <FlutterErrorDetails>[];
    final previousOnError = FlutterError.onError;
    FlutterError.onError = overflowErrors.add;
    try {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: RepaintBoundary(
              key: const Key('paint-boundary'),
              child: ColoredBox(
                color: Colors.white,
                child: SizedBox(
                  width: 340,
                  height: 120,
                  child: Stack(
                    clipBehavior: .none,
                    children: const [
                      Positioned(
                        left: 20,
                        top: 20,
                        child: SizedBox(
                          width: 80,
                          height: 60,
                          child: _OverflowingGrid(
                            color: Colors.red,
                            clipBehavior: .none,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 180,
                        top: 20,
                        child: SizedBox(
                          width: 80,
                          height: 60,
                          child: _OverflowingGrid(
                            color: Colors.blue,
                            clipBehavior: .hardEdge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } finally {
      FlutterError.onError = previousOnError;
    }

    final pixels = await _capturePixels(tester, const [
      Offset(120, 40),
      Offset(280, 40),
    ]);
    expect(overflowErrors, isNotEmpty);
    expect(pixels[0], const Color(0xFFF44336));
    expect(pixels[1], const Color(0xFFFFFFFF));
  });

  testWidgets('two-axis overflow reports Grid-specific remediation', (
    tester,
  ) async {
    final errors = <FlutterErrorDetails>[];
    final previousOnError = FlutterError.onError;
    FlutterError.onError = errors.add;
    try {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 60,
              child: MixGrid(
                spec: GridBoxSpec(
                  columns: const [GridTrack.fixed(80), GridTrack.fixed(70)],
                  rows: const [GridTrack.fixed(40), GridTrack.fixed(30)],
                  columnGap: 10,
                  rowGap: 5,
                ),
                children: const [
                  ColoredBox(color: Colors.red),
                  ColoredBox(color: Colors.green),
                  ColoredBox(color: Colors.blue),
                  ColoredBox(color: Colors.orange),
                ],
              ),
            ),
          ),
        ),
      );
    } finally {
      FlutterError.onError = previousOnError;
    }

    final message = errors.map((details) => details.toString()).join('\n');
    expect(message, contains('RenderMixGrid overflowed'));
    expect(message, contains('right'));
    expect(message, contains('bottom'));
    expect(message, contains('Fixed GridTrack'));
    expect(message, contains('Clip.hardEdge'));
    expect(message, contains('scrollable'));
  });

  testWidgets('overflow outside Grid bounds is never hit-testable', (
    tester,
  ) async {
    final overflowErrors = <FlutterErrorDetails>[];
    final previousOnError = FlutterError.onError;
    FlutterError.onError = overflowErrors.add;
    try {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 240,
              height: 100,
              child: Stack(
                clipBehavior: .none,
                children: [
                  Positioned(
                    left: 20,
                    top: 20,
                    width: 80,
                    height: 60,
                    child: MixGrid(
                      spec: GridBoxSpec(
                        columns: const [GridTrack.fixed(140)],
                        rows: const [GridTrack.fixed(60)],
                      ),
                      children: const [ColoredBox(color: Colors.red)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } finally {
      FlutterError.onError = previousOnError;
    }

    final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
    expect(overflowErrors, isNotEmpty);
    final inside = BoxHitTestResult();
    final outside = BoxHitTestResult();

    expect(render.hitTest(inside, position: const Offset(40, 30)), isTrue);
    expect(render.hitTest(outside, position: const Offset(110, 30)), isFalse);
    expect(render.describeApproximatePaintClip(render.firstChild!), isNull);
  });

  testWidgets('updating the same Grid clears its overflow clip layer', (
    tester,
  ) async {
    Widget build(double trackWidth) {
      return MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 100,
            height: 60,
            child: GridBox(
              key: const Key('grid'),
              style: GridBoxStyler(
                columns: [GridTrack.fixed(trackWidth)],
                rows: const [GridTrack.fixed(60)],
                clipBehavior: .hardEdge,
              ),
              children: const [ColoredBox(color: Colors.blue)],
            ),
          ),
        ),
      );
    }

    final overflowErrors = <FlutterErrorDetails>[];
    final previousOnError = FlutterError.onError;
    FlutterError.onError = overflowErrors.add;
    try {
      await tester.pumpWidget(build(140));
    } finally {
      FlutterError.onError = previousOnError;
    }
    final render = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
    expect(overflowErrors, isNotEmpty);
    expect(render.clipBehavior, Clip.hardEdge);
    expect(render, paints..clipRect());

    await tester.pumpWidget(build(80));

    // Re-querying the same finder verifies that the keyed render object was reused.
    // ignore: avoid-duplicate-initializers
    final updated = tester.renderObject<RenderMixGrid>(find.byType(MixGrid));
    expect(updated, same(render));
    expect(updated.describeApproximatePaintClip(updated.firstChild!), isNull);
    expect(updated, isNot(paints..clipRect()));
  });
}

class _OverflowingGrid extends StatelessWidget {
  const _OverflowingGrid({required this.color, required this.clipBehavior});

  final Color color;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return MixGrid(
      spec: GridBoxSpec(
        columns: const [GridTrack.fixed(140)],
        rows: const [GridTrack.fixed(60)],
        clipBehavior: clipBehavior,
      ),
      children: [ColoredBox(color: color)],
    );
  }
}

Future<List<Color>> _capturePixels(
  WidgetTester tester,
  List<Offset> offsets,
) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const Key('paint-boundary')),
  );
  final colors = await tester.runAsync(() async {
    final image = await boundary.toImage();
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    expect(data, isNotNull);
    final bytes = data!.buffer.asUint8List();
    final colors = <Color>[];
    for (final offset in offsets) {
      final pixelOffset =
          (offset.dy.toInt() * image.width + offset.dx.toInt()) * 4;
      colors.add(
        Color.fromARGB(
          bytes[pixelOffset + 3],
          bytes[pixelOffset],
          bytes[pixelOffset + 1],
          bytes[pixelOffset + 2],
        ),
      );
    }
    image.dispose();

    return colors;
  });

  return colors!;
}
