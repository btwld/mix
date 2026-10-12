import 'package:flutter/foundation.dart' show FlutterError;
import 'package:flutter/widgets.dart' show Clip;
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
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
