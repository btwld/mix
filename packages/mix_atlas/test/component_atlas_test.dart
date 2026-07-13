import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas/golden.dart';
import 'package:mix_atlas/mix_atlas.dart';

Widget _cell(BuildContext context, AtlasCellContext cell) => const SizedBox();

void main() {
  testWidgets('legacy rows use their IDs without group headers', (
    tester,
  ) async {
    final atlas = ComponentAtlas(
      id: 'legacy',
      scenarios: const [AtlasScenario('default')],
      rows: [AtlasRow('solid', _cell)],
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AtlasView(atlas: atlas),
      ),
    );
    expect(find.text('solid'), findsOneWidget);
  });

  testWidgets('one axis labels rows without sections', (tester) async {
    final atlas = ComponentAtlas(
      id: 'one-axis',
      rowAxes: const [AtlasAxis('size', 'Size')],
      scenarios: const [AtlasScenario('default')],
      rows: [
        AtlasRow(
          'size1',
          _cell,
          values: const {'size': AtlasAxisValue('size1', 'Size 1')},
        ),
      ],
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AtlasView(atlas: atlas),
      ),
    );
    expect(find.text('Size 1'), findsOneWidget);
    expect(find.text('Size'), findsNothing);
  });

  testWidgets('arbitrary nested axes render headers without building cells', (
    tester,
  ) async {
    var builds = 0;
    Widget builder(BuildContext context, AtlasCellContext cell) {
      builds++;
      return const SizedBox();
    }

    final atlas = ComponentAtlas(
      id: 'nested',
      rowAxes: const [
        AtlasAxis('tone', 'Tone'),
        AtlasAxis('density', 'Density'),
        AtlasAxis('scale', 'Scale'),
      ],
      scenarios: const [AtlasScenario('default')],
      rows: [
        AtlasRow(
          'a',
          builder,
          values: const {
            'tone': AtlasAxisValue('warm', 'Warm'),
            'density': AtlasAxisValue('compact', 'Compact'),
            'scale': AtlasAxisValue('small', 'Small'),
          },
        ),
        AtlasRow(
          'b',
          builder,
          values: const {
            'tone': AtlasAxisValue('cool', 'Cool'),
            'density': AtlasAxisValue('compact', 'Compact'),
            'scale': AtlasAxisValue('large', 'Large'),
          },
        ),
      ],
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AtlasView(atlas: atlas),
      ),
    );
    expect(find.text('Warm'), findsOneWidget);
    expect(find.text('Cool'), findsOneWidget);
    expect(find.text('Compact'), findsNWidgets(2));
    expect(builds, 2);
  });

  test('invalid matrices fail deterministically', () {
    ComponentAtlas atlas({
      List<AtlasAxis> axes = const [AtlasAxis('size', 'Size')],
      Map<String, AtlasAxisValue> values = const {},
      List<AtlasScenario> scenarios = const [AtlasScenario('default')],
    }) => ComponentAtlas(
      id: 'invalid',
      rowAxes: axes,
      scenarios: scenarios,
      rows: [AtlasRow('row', _cell, values: values)],
    );

    expect(atlas().validate, throwsArgumentError);
    expect(
      () => atlas(
        values: const {
          'size': AtlasAxisValue('size1', 'Size 1'),
          'unknown': AtlasAxisValue('x', 'X'),
        },
      ).validate(),
      throwsArgumentError,
    );
    expect(
      () => atlas(
        scenarios: const [AtlasScenario('same'), AtlasScenario('same')],
        values: const {'size': AtlasAxisValue('size1', 'Size 1')},
      ).validate(),
      throwsArgumentError,
    );
    final duplicateCombination = ComponentAtlas(
      id: 'duplicate',
      rowAxes: const [AtlasAxis('size', 'Size')],
      scenarios: const [AtlasScenario('default')],
      rows: [
        AtlasRow(
          'a',
          _cell,
          values: const {'size': AtlasAxisValue('size1', 'Size 1')},
        ),
        AtlasRow(
          'b',
          _cell,
          values: const {'size': AtlasAxisValue('size1', 'Size One')},
        ),
      ],
    );
    expect(duplicateCombination.validate, throwsArgumentError);
  });

  test('structured metadata uses the atlas v1 schema', () {
    final atlas = ComponentAtlas(
      id: 'button',
      rowAxes: const [AtlasAxis('size', 'Size')],
      scenarios: const [AtlasScenario('default')],
      rows: [
        AtlasRow(
          'size1',
          _cell,
          values: const {'size': AtlasAxisValue('size1', 'Size 1')},
        ),
      ],
    );
    final metadata = componentAtlasMetadata(
      atlas,
      AtlasTheme(
        'light',
        background: const Color(0xFFFFFFFF),
        builder: (context, child) => child,
      ),
    );
    expect(metadata['schema'], 'mix_atlas/atlas/v1');
    expect(metadata['rowAxes'], [
      {'id': 'size', 'label': 'Size'},
    ]);
    expect(metadata['rows'], [
      {
        'id': 'size1',
        'values': {
          'size': {'id': 'size1', 'label': 'Size 1'},
        },
      },
    ]);
  });

  test('metadata sorts widget states and recursively normalizes props', () {
    final atlas = ComponentAtlas(
      id: 'button',
      scenarios: const [
        AtlasScenario(
          'configured',
          states: {WidgetState.pressed, WidgetState.hovered},
          props: {
            'zeta': true,
            'config': {
              'z': 3,
              'a': [
                {'last': false, 'first': true},
              ],
            },
            'alpha': null,
          },
        ),
      ],
      rows: [AtlasRow('base', _cell)],
    );
    final metadata = componentAtlasMetadata(
      atlas,
      AtlasTheme(
        'light',
        background: const Color(0xFFFFFFFF),
        builder: (context, child) => child,
      ),
    );
    final column = (metadata['columns'] as List).single as Map;

    expect(column['states'], ['hovered', 'pressed']);
    expect(column['props'], {
      'alpha': null,
      'config': {
        'a': [
          {'first': true, 'last': false},
        ],
        'z': 3,
      },
      'zeta': true,
    });
  });

  test('metadata rejects non-JSON-safe props with scenario and key', () {
    final atlas = ComponentAtlas(
      id: 'button',
      scenarios: [
        AtlasScenario(
          'loading',
          props: {
            'config': {'duration': const Duration(seconds: 1)},
          },
        ),
      ],
      rows: [AtlasRow('base', _cell)],
    );
    final theme = AtlasTheme(
      'light',
      background: const Color(0xFFFFFFFF),
      builder: (context, child) => child,
    );

    expect(
      () => componentAtlasMetadata(atlas, theme),
      throwsA(
        isA<ArgumentError>().having(
          (error) => error.message,
          'message',
          allOf(contains('loading'), contains('config.duration')),
        ),
      ),
    );
  });
}
