import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  final contract = mixProtocol;

  JsonMap encode(Object styler) {
    return switch (contract.encodeStyle(styler)) {
      MixProtocolSuccess<JsonMap>(:final value) => value,
      MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
    };
  }

  T decode<T extends Object>(JsonMap payload) {
    return switch (contract.decodeStyle<T>(payload)) {
      MixProtocolSuccess<T>(:final value) => value,
      MixProtocolFailure<T>(:final errors) => fail('$errors'),
    };
  }

  test('grid_box canonical payload covers geometry and style metadata', () {
    final payload = <String, Object>{
      'v': 1,
      'type': 'grid_box',
      'columns': [
        {'type': 'fixed', 'size': 220.0},
        {'type': 'fr', 'fraction': 2.0},
      ],
      'rows': [
        {'type': 'fixed', 'size': 120.0},
      ],
      'autoRows': {'type': 'fixed', 'size': 96.0},
      'columnGap': 16.0,
      'rowGap': 12.0,
      'clipBehavior': 'hardEdge',
      'constraintBranches': [
        {
          'breakpoint': {'maxWidth': 720.0, 'maxHeight': 900.0},
          'patch': {
            'columns': [
              {'type': 'fr', 'fraction': 1.0},
            ],
            'columnGap': 8.0,
            'rowGap': 8.0,
          },
        },
        {
          'breakpoint': {'token': 'breakpoint.grid.compact'},
          'patch': {
            'autoRows': {'type': 'fixed', 'size': 80.0},
          },
        },
      ],
      'variants': [
        {
          'kind': 'named',
          'name': 'dense',
          'style': {'type': 'grid_box', 'columnGap': 4.0, 'rowGap': 4.0},
        },
      ],
      'modifiers': [
        {'type': 'opacity', 'opacity': 0.75},
      ],
      'animation': {'duration': 120, 'curve': 'easeInOut', 'delay': 0},
    };

    final decoded = decode<GridBoxStyler>(payload);

    expect(encode(decoded), payload);
    expect(tokenReferencesOf(decoded), {
      const MixProtocolTokenReference('breakpoints', 'breakpoint.grid.compact'),
    });
  });

  test('grid_box round-trips fieldless auto tracks without token refs', () {
    final payload = <String, Object>{
      'v': 1,
      'type': 'grid_box',
      'columns': [
        {'type': 'fr', 'fraction': 1.0},
        {'type': 'fr', 'fraction': 1.0},
      ],
      'rows': [
        {'type': 'auto'},
      ],
      'autoRows': {'type': 'auto'},
      'constraintBranches': [
        {
          'breakpoint': {'maxWidth': 520.0},
          'patch': {
            'autoRows': {'type': 'auto'},
            'rows': [
              {'type': 'auto'},
            ],
          },
        },
      ],
    };

    final decoded = decode<GridBoxStyler>(payload);

    expect(encode(decoded), payload);
    expect(decoded.$rows, const [GridTrack.auto()]);
    expect(decoded.$autoRows, const GridTrack.auto());
    expect(
      decoded.$constraintBranches!.single.patch.autoRows,
      const GridTrack.auto(),
    );
    expect(tokenReferencesOf(decoded), isEmpty);
  });

  test('lenient decode drops the smallest unrecognized grid track', () {
    (GridBoxStyler, List<String>) lenient(JsonMap payload) {
      final result = contract.decodeStyle<GridBoxStyler>(
        payload,
        options: const MixProtocolDecodeOptions(
          mode: MixProtocolDecodeMode.lenient,
        ),
      );

      return switch (result) {
        MixProtocolSuccess<GridBoxStyler>(:final value, :final warnings) => (
          value,
          [for (final warning in warnings) warning.path],
        ),
        MixProtocolFailure<GridBoxStyler>(:final errors) => fail('$errors'),
      };
    }

    // A list entry loses only that entry; sibling tracks survive.
    final (rowStyle, rowWarnings) = lenient({
      'v': 1,
      'type': 'grid_box',
      'columns': [
        {'type': 'fr', 'fraction': 1.0},
      ],
      'rows': [
        {'type': 'fixed', 'size': 40.0},
        {'type': 'minmax', 'min': 1.0, 'max': 2.0},
      ],
    });
    expect(rowWarnings, ['/rows/1/type']);
    expect(rowStyle.$rows, const [GridTrack.fixed(40)]);

    // A scalar field loses the whole field, which resolves back to the
    // implicit GridTrack.auto() default rather than a decode failure.
    final (autoStyle, autoWarnings) = lenient({
      'v': 1,
      'type': 'grid_box',
      'columns': [
        {'type': 'fr', 'fraction': 1.0},
      ],
      'autoRows': {'type': 'minmax', 'min': 1.0, 'max': 2.0},
    });
    expect(autoWarnings, ['/autoRows/type']);
    expect(autoStyle.$autoRows, isNull);

    // `auto` is unrecognized under columns, so lenient mode drops that column
    // instead of failing the way strict mode does.
    final (columnStyle, columnWarnings) = lenient({
      'v': 1,
      'type': 'grid_box',
      'columns': [
        {'type': 'fr', 'fraction': 1.0},
        {'type': 'auto'},
      ],
    });
    expect(columnWarnings, ['/columns/1/type']);
    expect(columnStyle.$columns, const [GridTrack.fr(1)]);
  });

  test('runtime grid style round-trips without losing branch order', () {
    final style = GridBoxStyler(
      columns: const [GridTrack.fixed(200), GridTrack.fr(2)],
      rows: const [GridTrack.fixed(100)],
      autoRows: const GridTrack.fixed(84),
      columnGap: 16,
      rowGap: 12,
      clipBehavior: Clip.antiAlias,
      constraintBranches: [
        const GridConstraintBranch(
          breakpoint: Breakpoint(maxWidth: 900, minHeight: 400),
          patch: GridLayoutPatch(columnGap: 10),
        ),
        GridConstraintBranch(
          breakpoint: const BreakpointToken('breakpoint.grid.compact')(),
          patch: const GridLayoutPatch(columns: [GridTrack.fr(1)], rowGap: 8),
        ),
      ],
      variants: [
        VariantStyle(
          const NamedVariant('dense'),
          const GridBoxStyler(rowGap: 4),
        ),
      ],
      modifier: WidgetModifierConfig.opacity(0.5),
      animation: CurveAnimationConfig.easeInOut(
        const Duration(milliseconds: 120),
      ),
    );

    final payload = encode(style);
    final decoded = decode<GridBoxStyler>(payload);

    expect(decoded, style);
    expect(encode(decoded), payload);
    expect(
      decoded.$constraintBranches!.map((branch) => branch.breakpoint),
      orderedEquals([
        const Breakpoint(maxWidth: 900, minHeight: 400),
        const BreakpointToken('breakpoint.grid.compact')(),
      ]),
    );
  });

  test('grid_box round-trips tokenized tracks and gaps', () {
    final payload = <String, Object>{
      'v': 1,
      'type': 'grid_box',
      'columns': [
        {
          'type': 'fixed',
          'size': {r'$token': 'space.grid.track', 'kind': 'space'},
        },
        {
          'type': 'fr',
          'fraction': {r'$token': 'double.grid.fraction', 'kind': 'double'},
        },
      ],
      'autoRows': {
        'type': 'fixed',
        'size': {r'$token': 'space.grid.auto-row', 'kind': 'space'},
      },
      'columnGap': {r'$token': 'space.grid.column-gap', 'kind': 'space'},
      'rowGap': {r'$token': 'space.grid.row-gap', 'kind': 'space'},
      'constraintBranches': [
        {
          'breakpoint': {'maxWidth': 600.0},
          'patch': {
            'columns': [
              {
                'type': 'fixed',
                'size': {
                  r'$token': 'space.grid.compact-track',
                  'kind': 'space',
                },
              },
            ],
            'rowGap': {r'$token': 'space.grid.compact-gap', 'kind': 'space'},
          },
        },
      ],
    };

    final decoded = decode<GridBoxStyler>(payload);

    expect(encode(decoded), payload);
    expect(tokenReferencesOf(decoded), {
      const MixProtocolTokenReference('spaces', 'space.grid.track'),
      const MixProtocolTokenReference('doubles', 'double.grid.fraction'),
      const MixProtocolTokenReference('spaces', 'space.grid.auto-row'),
      const MixProtocolTokenReference('spaces', 'space.grid.column-gap'),
      const MixProtocolTokenReference('spaces', 'space.grid.row-gap'),
      const MixProtocolTokenReference('spaces', 'space.grid.compact-track'),
      const MixProtocolTokenReference('spaces', 'space.grid.compact-gap'),
    });
  });

  test('grid_box rejects invalid geometry and constraint branches', () {
    final invalidFields = <String, Object>{
      'empty columns': <Object>[],
      'zero fraction': [
        {'type': 'fr', 'fraction': 0.0},
      ],
      'negative fixed size': [
        {'type': 'fixed', 'size': -1.0},
      ],
      'infinite fixed size': [
        {'type': 'fixed', 'size': double.infinity},
      ],
      'infinite fraction': [
        {'type': 'fr', 'fraction': double.infinity},
      ],
      'auto column': [
        {'type': 'auto'},
      ],
    };

    for (final MapEntry(key: label, value: columns) in invalidFields.entries) {
      final result = contract.decodeStyle<GridBoxStyler>({
        'v': 1,
        'type': 'grid_box',
        'columns': columns,
      });

      expect(result, isA<MixProtocolFailure<GridBoxStyler>>(), reason: label);
    }

    for (final branch in <JsonMap>[
      {
        'breakpoint': <String, Object>{},
        'patch': {'columnGap': 8.0},
      },
      {
        'breakpoint': {'token': 'breakpoint.compact', 'maxWidth': 600.0},
        'patch': {'columnGap': 8.0},
      },
      {
        'breakpoint': {'minWidth': 700.0, 'maxWidth': 600.0},
        'patch': {'columnGap': 8.0},
      },
      {
        'breakpoint': {'maxWidth': double.infinity},
        'patch': {'columnGap': 8.0},
      },
      {
        'breakpoint': {'maxWidth': 600.0},
        'patch': <String, Object>{},
      },
    ]) {
      final result = contract.decodeStyle<GridBoxStyler>({
        'v': 1,
        'type': 'grid_box',
        'constraintBranches': [branch],
      });

      expect(
        result,
        isA<MixProtocolFailure<GridBoxStyler>>(),
        reason: '$branch',
      );
    }

    expect(
      contract.decodeStyle<GridBoxStyler>({
        'v': 1,
        'type': 'grid_box',
        'columnGap': double.infinity,
      }),
      isA<MixProtocolFailure<GridBoxStyler>>(),
    );
  });

  test('grid_box encoding rejects invalid runtime geometry', () {
    final invalidStyles = <(String, GridBoxStyler)>[
      ('empty columns', const GridBoxStyler(columns: [])),
      (
        'infinite fixed track',
        const GridBoxStyler(columns: [GridTrack.fixed(double.infinity)]),
      ),
      ('infinite gap', const GridBoxStyler(columnGap: double.infinity)),
      (
        'empty patch',
        const GridBoxStyler(
          constraintBranches: [
            GridConstraintBranch(
              breakpoint: Breakpoint(maxWidth: 600),
              patch: GridLayoutPatch(),
            ),
          ],
        ),
      ),
      (
        'inverted breakpoint range',
        const GridBoxStyler(
          constraintBranches: [
            GridConstraintBranch(
              breakpoint: Breakpoint(minWidth: 700, maxWidth: 600),
              patch: GridLayoutPatch(columnGap: 8),
            ),
          ],
        ),
      ),
    ];

    for (final (label, style) in invalidStyles) {
      expect(
        contract.encodeStyle(style),
        isA<MixProtocolFailure<JsonMap>>(),
        reason: label,
      );
    }
  });

  test('exported schema contains the complete grid_box field surface', () {
    final schema = contract.exportStyleJsonSchema();
    final branches = (schema['anyOf']! as List).cast<JsonMap>();
    final branch = branches.singleWhere((candidate) {
      final properties = candidate['properties']! as JsonMap;
      final type = properties['type']! as JsonMap;

      return type['const'] == 'grid_box';
    });
    final properties = branch['properties']! as JsonMap;

    expect(properties.keys.toSet(), {
      'v',
      'type',
      'columns',
      'rows',
      'autoRows',
      'columnGap',
      'rowGap',
      'clipBehavior',
      'constraintBranches',
      'variants',
      'modifiers',
      'animation',
    });
  });
}
