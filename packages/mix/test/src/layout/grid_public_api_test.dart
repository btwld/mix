import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('GridBoxStyler.call', () {
    test('returns a GridBox with this style, key and children', () {
      final GridBoxStyler style = .equalColumns(2).gap(10);
      const key = ValueKey('grid');
      const children = <Widget>[SizedBox(), SizedBox()];

      final GridBox grid = style(key: key, children: children);

      expect(grid.style, same(style));
      expect(grid.key, same(key));
      expect(grid.children, same(children));
    });

    test('defaults to no key and empty children', () {
      const style = GridBoxStyler();

      final grid = style();

      expect(grid.style, same(style));
      expect(grid.key, isNull);
      expect(grid.children, isEmpty);
    });

    testWidgets('lays out the same as the GridBox constructor', (tester) async {
      final GridBoxStyler style = .columns([
        .fixed(80),
        .fr(1),
      ]).autoRows(.fixed(40)).columnGap(10).rowGap(8);
      const key = ValueKey('grid');
      const children = <Widget>[
        SizedBox(key: ValueKey('first')),
        SizedBox(key: ValueKey('second')),
        SizedBox(key: ValueKey('third')),
      ];

      Future<void> pump(Widget grid) => tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: SizedBox(width: 300, child: grid)),
        ),
      );

      List<Rect> bounds() => [
        tester.getRect(find.byKey(key)),
        for (final child in children) tester.getRect(find.byKey(child.key!)),
      ];

      await pump(GridBox(key: key, style: style, children: children));
      final constructorBounds = bounds();
      expect(constructorBounds.first.size, const Size(300, 88));
      expect(constructorBounds[1].size, const Size(80, 40));
      expect(constructorBounds[2].size, const Size(210, 40));
      expect(
        constructorBounds[3].topLeft - constructorBounds[1].topLeft,
        const Offset(0, 48),
      );

      await tester.pumpWidget(const SizedBox.shrink());
      await pump(style(key: key, children: children));

      expect(bounds(), constructorBounds);
    });
  });

  test('Grid public API supports nested dot shorthand composition', () {
    final GridBoxStyler style = .columns([
      .fixed(220),
      .fr(2),
    ]).gap(16).onConstraints(.maxWidth(720), .columns([.fr(1)]).gap(8));

    expect(style.$columns, const [GridTrack.fixed(220), GridTrack.fr(2)]);
    expect(style.$columnGap, 16);
    expect(style.$rowGap, 16);
    expect(
      style.$constraintBranches!.single.breakpoint,
      const Breakpoint.maxWidth(720),
    );
    expect(style.$constraintBranches!.single.patch.columns, const [
      GridTrack.fr(1),
    ]);
    expect(style.$constraintBranches!.single.patch.columnGap, 8);
    expect(const GridBox(), isA<GridBox>());
  });

  test('Grid geometry factories expose the complete fluent surface', () {
    final GridBoxStyler geometry = .rows([
      .fixed(80),
    ]).autoRows(.fixed(120)).columnGap(4).rowGap(8).clipBehavior(.hardEdge);
    final GridBoxStyler constrained = .onConstraints(
      .maxHeight(480),
      .rows([.fixed(64)]),
    );

    expect(geometry.$rows, const [GridTrack.fixed(80)]);
    expect(geometry.$autoRows, const GridTrack.fixed(120));
    expect(geometry.$columnGap, 4);
    expect(geometry.$rowGap, 8);
    expect(geometry.$clipBehavior, Clip.hardEdge);
    expect(
      constrained.$constraintBranches!.single.breakpoint,
      const Breakpoint.maxHeight(480),
    );
  });

  test('GridTrack.auto is a fieldless row track', () {
    expect(const GridTrack.auto(), const AutoGridTrack());
    expect(const GridTrack.auto(), const GridTrack.auto());
    expect(const GridTrack.auto().toString(), 'GridTrack.auto()');
    expect(
      const GridBoxStyler().autoRows(.auto()).$autoRows,
      const GridTrack.auto(),
    );
    expect(const GridBoxStyler().rows([.auto()]).$rows, const [
      GridTrack.auto(),
    ]);
    expect(
      () => GridBoxSpec(columns: const [GridTrack.auto()]),
      throwsA(
        isA<FlutterError>()
            .having(
              (error) => error.toString(),
              'message',
              contains('vertical-only'),
            )
            .having(
              (error) => error.toString(),
              'message',
              contains('rows or autoRows'),
            ),
      ),
    );
  });

  test('equalColumns creates repeated one-fraction tracks', () {
    final GridBoxStyler factory = .equalColumns(3);
    final chained = GridBoxStyler().equalColumns(2);

    expect(factory.$columns, const [
      GridTrack.fr(1),
      GridTrack.fr(1),
      GridTrack.fr(1),
    ]);
    expect(chained.$columns, const [GridTrack.fr(1), GridTrack.fr(1)]);
    expect(
      () => factory.$columns!.add(const GridTrack.fr(1)),
      throwsUnsupportedError,
    );
    expect(() => GridBoxStyler.equalColumns(0), throwsArgumentError);
    expect(() => GridBoxStyler().equalColumns(-1), throwsArgumentError);
  });
}
