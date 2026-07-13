import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas/mix_atlas.dart';

Widget _cell(BuildContext context, AtlasCellContext cell) => const Text('cell');

AtlasCatalog _catalog() => AtlasCatalog(
  id: 'custom',
  label: 'Custom system',
  themes: [
    AtlasTheme(
      'day',
      label: 'Day',
      background: Colors.white,
      builder: (context, child) => child,
    ),
    AtlasTheme(
      'night',
      label: 'Night',
      brightness: Brightness.dark,
      background: Colors.black,
      builder: (context, child) => child,
    ),
  ],
  atlases: [
    ComponentAtlas(
      id: 'zeta',
      label: 'Zeta control',
      scenarios: const [AtlasScenario('rest', label: 'Resting')],
      rows: [AtlasRow('plain', _cell, label: 'Plain row')],
    ),
    ComponentAtlas(
      id: 'alpha',
      label: 'Alpha control',
      scenarios: const [AtlasScenario('rest')],
      rows: [AtlasRow('plain', _cell)],
    ),
  ],
);

/// A cell that pushes an overlay route onto the local [AtlasOverlayHost]
/// Navigator, mirroring how the Dialog atlas opens its modal.
class _PushingCell extends StatefulWidget {
  const _PushingCell(this.label);
  final String label;

  @override
  State<_PushingCell> createState() => _PushingCellState();
}

class _PushingCellState extends State<_PushingCell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).push(
        PageRouteBuilder<void>(
          opaque: false,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          pageBuilder: (context, animation, secondaryAnimation) =>
              Center(child: Text(widget.label)),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox(width: 40, height: 40);
}

/// Two atlases whose cells share the `SizedBox > AtlasOverlayHost` shape,
/// so their local Navigators reuse the same element across an atlas switch.
AtlasCatalog _overlayCatalog() => AtlasCatalog(
  id: 'overlays',
  themes: [
    AtlasTheme('day', background: Colors.white, builder: (_, child) => child),
  ],
  atlases: [
    ComponentAtlas(
      id: 'first',
      scenarios: const [AtlasScenario('rest')],
      rows: [
        AtlasRow(
          'plain',
          (context, cell) => const SizedBox(
            width: 120,
            height: 80,
            child: AtlasOverlayHost(child: _PushingCell('leak-first')),
          ),
        ),
      ],
    ),
    ComponentAtlas(
      id: 'second',
      scenarios: const [AtlasScenario('rest')],
      rows: [
        AtlasRow(
          'plain',
          (context, cell) => const SizedBox(
            width: 120,
            height: 80,
            child: AtlasOverlayHost(child: Center(child: Text('second-cell'))),
          ),
        ),
      ],
    ),
  ],
);

void main() {
  test('controller normalizes invalid IDs and keeps declared defaults', () {
    final controller = AtlasCatalogController(
      _catalog(),
      atlasId: 'missing',
      themeId: 'missing',
    );
    expect(
      controller.selection,
      const AtlasCatalogSelection(atlasId: 'zeta', themeId: 'day'),
    );
    controller.select(atlasId: 'alpha', themeId: 'night');
    expect(
      controller.selection,
      const AtlasCatalogSelection(atlasId: 'alpha', themeId: 'night'),
    );
  });

  testWidgets('viewer exposes labels, coverage, search, and declared order', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: AtlasCatalogViewer(catalog: _catalog())),
    );
    expect(find.text('Custom system'), findsOneWidget);
    expect(find.text('1 rows × 1 scenarios = 1 cells'), findsOneWidget);
    expect(find.text('Zeta control'), findsWidgets);
    expect(find.text('Alpha control'), findsOneWidget);
    final tiles = tester.widgetList<ListTile>(find.byType(ListTile)).toList();
    expect((tiles[0].title! as Text).data, 'Zeta control');
    expect((tiles[1].title! as Text).data, 'Alpha control');
    await tester.enterText(find.byType(TextField), 'alpha');
    await tester.pump();
    expect(find.text('Zeta control'), findsNWidgets(2));
    expect(find.text('Alpha control'), findsOneWidget);
  });

  testWidgets('compact viewer uses a drawer', (tester) async {
    tester.view.physicalSize = const Size(600, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(home: AtlasCatalogViewer(catalog: _catalog())),
    );
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
  });

  testWidgets('empty catalog has a useful state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AtlasCatalogViewer(
          catalog: AtlasCatalog(id: 'empty', themes: [], atlases: []),
        ),
      ),
    );
    expect(find.text('No atlases to display'), findsOneWidget);
  });

  testWidgets('atlas uses human labels and metadata retains IDs', (
    tester,
  ) async {
    final catalog = _catalog();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AtlasView(atlas: catalog.atlases.first),
      ),
    );
    expect(find.text('Resting'), findsOneWidget);
    expect(find.text('Plain row'), findsOneWidget);
  });

  testWidgets('swapping the catalog rebuilds with a fresh controller', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: AtlasCatalogViewer(catalog: _catalog())),
    );
    expect(find.text('Zeta control'), findsWidgets);

    await tester.pumpWidget(
      MaterialApp(home: AtlasCatalogViewer(catalog: _overlayCatalog())),
    );
    await tester.pumpAndSettle();
    expect(find.text('leak-first'), findsOneWidget);
    expect(find.text('Zeta control'), findsNothing);
  });

  testWidgets('switching atlases disposes stale overlay-host routes', (
    tester,
  ) async {
    final catalog = _overlayCatalog();
    final controller = AtlasCatalogController(catalog);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: AtlasCatalogViewer(catalog: catalog, controller: controller),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('leak-first'), findsOneWidget);

    controller.select(atlasId: 'second');
    await tester.pumpAndSettle();
    expect(find.text('second-cell'), findsOneWidget);
    expect(find.text('leak-first'), findsNothing);
  });
}
