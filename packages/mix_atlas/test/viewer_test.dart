import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas/golden.dart';
import 'package:mix_atlas/mix_atlas.dart';

import 'support/reference_catalog.dart';

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
      background: const Color(0xff15171c),
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

AtlasCatalog _groupedCatalog() => AtlasCatalog(
  id: 'grouped',
  label: 'Grouped system',
  themes: [
    AtlasTheme('day', background: Colors.white, builder: (_, child) => child),
  ],
  atlases: [
    ComponentAtlas(
      id: 'badge',
      label: 'Badge',
      rowAxes: const [
        AtlasAxis('variant', 'Variant'),
        AtlasAxis('size', 'Size'),
      ],
      scenarios: const [AtlasScenario('rest', label: 'Resting')],
      rows: [
        for (final (variant, size) in [
          ('solid', 'small'),
          ('solid', 'large'),
          ('outline', 'small'),
          ('outline', 'large'),
        ])
          AtlasRow(
            '$variant-$size',
            (context, cell) => SizedBox(
              width: size == 'small' ? 56 : 88,
              height: size == 'small' ? 28 : 36,
              child: ColoredBox(
                color: variant == 'solid'
                    ? const Color(0xff3157d5)
                    : const Color(0xffdce4ff),
              ),
            ),
            values: {
              'variant': AtlasAxisValue(variant, _humanize(variant)),
              'size': AtlasAxisValue(size, _humanize(size)),
            },
          ),
      ],
    ),
  ],
);

const _themeScopeColor = Color(0xffff00ff);

AtlasCatalog _themeScopeCatalog() => AtlasCatalog(
  id: 'theme-scope',
  themes: [
    AtlasTheme(
      'custom',
      background: Colors.white,
      builder: (_, child) => Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(primary: _themeScopeColor),
        ),
        child: child,
      ),
    ),
  ],
  atlases: [
    ComponentAtlas(
      id: 'probe',
      scenarios: const [AtlasScenario('default')],
      rows: [
        AtlasRow(
          'default',
          (context, cell) => ColoredBox(
            key: const ValueKey('theme-scope-cell'),
            color: Theme.of(context).colorScheme.primary,
            child: const SizedBox(width: 20, height: 20),
          ),
        ),
      ],
    ),
  ],
);

/// A cell that pushes an overlay route onto the local [AtlasOverlayHost]
/// Navigator, mirroring how a dialog atlas opens its modal.
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

  testWidgets('viewer exposes search, details, and declared atlas order', (
    tester,
  ) async {
    await _setViewport(tester, const Size(1440, 900));
    final catalog = _catalog();

    await tester.pumpWidget(_ViewerHarness(catalog: catalog));
    await tester.pump();

    expect(find.text('Custom system'), findsOneWidget);
    expect(find.byKey(const ValueKey('selected-atlas-title')), findsOneWidget);
    expect(find.byKey(const ValueKey('atlas-story-canvas')), findsOneWidget);
    expect(find.text('1 cells'), findsOneWidget);

    final zeta = find.byKey(const ValueKey('catalog-item-zeta'));
    final alpha = find.byKey(const ValueKey('catalog-item-alpha'));
    expect(tester.getTopLeft(zeta).dy, lessThan(tester.getTopLeft(alpha).dy));

    await tester.enterText(
      find.byKey(const ValueKey('catalog-search')),
      'alpha',
    );
    await tester.pump();
    expect(zeta, findsNothing);
    expect(alpha, findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('clear-catalog-search')));
    await tester.pump();
    expect(zeta, findsOneWidget);
    expect(alpha, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports slash, enter, and escape keyboard search', (
    tester,
  ) async {
    await _setViewport(tester, const Size(1440, 900));
    final catalog = _catalog();
    final controller = AtlasCatalogController(catalog);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ViewerHarness(catalog: catalog, controller: controller),
    );
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.slash);
    await tester.pump();
    var editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.focusNode.hasFocus, isTrue);

    await tester.enterText(
      find.byKey(const ValueKey('catalog-search')),
      'alpha',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    expect(controller.selection?.atlasId, 'alpha');

    editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.focusNode.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.controller.text, isEmpty);
    expect(find.text('Atlases'), findsOneWidget);
  });

  testWidgets('compact layout keeps catalog and themes available', (
    tester,
  ) async {
    await _setViewport(tester, const Size(720, 900));
    final catalog = _catalog();
    final controller = AtlasCatalogController(
      catalog,
      atlasId: 'alpha',
      themeId: 'night',
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ViewerHarness(catalog: catalog, controller: controller),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('compact-catalog-rail')), findsOneWidget);
    expect(find.byKey(const ValueKey('catalog-item-zeta')), findsOneWidget);
    expect(find.byKey(const ValueKey('catalog-item-alpha')), findsOneWidget);
    expect(find.byKey(const ValueKey('theme-night')), findsOneWidget);
    expect(find.text('Alpha control'), findsWidgets);
    final canvasContext = tester.element(
      find.byKey(const ValueKey('atlas-story-canvas')),
    );
    expect(Theme.of(canvasContext).brightness, Brightness.dark);
    expect(
      MediaQuery.platformBrightnessOf(canvasContext),
      Brightness.dark,
      reason: 'Mix onDark variants must resolve from the selected atlas theme.',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('theme builder scope reaches story components', (tester) async {
    await tester.pumpWidget(_ViewerHarness(catalog: _themeScopeCatalog()));

    final cell = tester.widget<ColoredBox>(
      find.byKey(const ValueKey('theme-scope-cell')),
    );
    expect(cell.color, _themeScopeColor);
  });

  testWidgets('story canvas aligns final-axis values and shows details', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _setViewport(tester, const Size(1440, 900));
    final catalog = _groupedCatalog();

    await tester.pumpWidget(_ViewerHarness(catalog: catalog));
    await tester.pump();

    final small = find.byKey(const ValueKey('story-cell-rest-solid-small'));
    final large = find.byKey(const ValueKey('story-cell-rest-solid-large'));
    expect(small, findsOneWidget);
    expect(large, findsOneWidget);
    expect(tester.getCenter(small).dy, tester.getCenter(large).dy);
    expect(tester.getTopLeft(small).dx, lessThan(tester.getTopLeft(large).dx));
    expect(
      find.bySemanticsLabel('Show atlas details, 4 cells'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('atlas-details-trigger')));
    await tester.pump();

    final popover = find.byKey(const ValueKey('atlas-details-popover'));
    expect(popover, findsOneWidget);
    for (final label in [
      'Atlas details',
      'Scenario',
      'Variants',
      'Sizes',
      'Cells',
    ]) {
      expect(
        find.descendant(of: popover, matching: find.text(label)),
        findsOneWidget,
      );
    }
    for (final value in ['Resting', '2', '4']) {
      expect(
        find.descendant(of: popover, matching: find.text(value)),
        findsWidgets,
      );
    }

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(popover, findsNothing);
    expect(tester.takeException(), isNull);
    semantics.dispose();
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

  testWidgets('swapping the catalog rebuilds with a fresh controller', (
    tester,
  ) async {
    await tester.pumpWidget(_ViewerHarness(catalog: _catalog()));
    expect(find.text('Zeta control'), findsWidgets);

    await tester.pumpWidget(_ViewerHarness(catalog: _overlayCatalog()));
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
      _ViewerHarness(catalog: catalog, controller: controller),
    );
    await tester.pumpAndSettle();
    expect(find.text('leak-first'), findsOneWidget);

    controller.select(atlasId: 'second');
    await tester.pumpAndSettle();
    expect(find.text('second-cell'), findsOneWidget);
    expect(find.text('leak-first'), findsNothing);
  });

  testWidgets('desktop light viewer matches its reference image', (
    tester,
  ) async {
    if (!_supportsViewerGoldens()) return;
    await _setViewport(tester, const Size(1440, 900));
    final controller = AtlasCatalogController(referenceCatalog);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ViewerHarness(
        catalog: referenceCatalog,
        controller: controller,
        captureKey: _captureKey,
      ),
    );
    await tester.pump();

    await expectLater(
      find.byKey(_captureKey),
      matchesGoldenFile('viewer_goldens/atlas-viewer-desktop-light.png'),
    );
  });

  testWidgets('compact dark viewer matches its reference image', (
    tester,
  ) async {
    if (!_supportsViewerGoldens()) return;
    await _setViewport(tester, const Size(720, 900));
    final controller = AtlasCatalogController(
      referenceCatalog,
      themeId: 'dark',
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ViewerHarness(
        catalog: referenceCatalog,
        controller: controller,
        captureKey: _captureKey,
      ),
    );
    await tester.pump();

    await expectLater(
      find.byKey(_captureKey),
      matchesGoldenFile('viewer_goldens/atlas-viewer-compact-dark.png'),
    );
  });

  testWidgets('desktop search and details match their reference image', (
    tester,
  ) async {
    if (!_supportsViewerGoldens()) return;
    await _setViewport(tester, const Size(1440, 900));
    final controller = AtlasCatalogController(referenceCatalog);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ViewerHarness(
        catalog: referenceCatalog,
        controller: controller,
        captureKey: _captureKey,
      ),
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const ValueKey('catalog-search')),
      'button',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('atlas-details-trigger')));
    await tester.pump();

    await expectLater(
      find.byKey(_captureKey),
      matchesGoldenFile(
        'viewer_goldens/atlas-viewer-desktop-search-details-light.png',
      ),
    );
  });
}

const _captureKey = ValueKey('viewer-capture');

class _ViewerHarness extends StatelessWidget {
  const _ViewerHarness({
    required this.catalog,
    this.controller,
    this.captureKey,
  });

  final AtlasCatalog catalog;
  final AtlasCatalogController? controller;
  final Key? captureKey;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RepaintBoundary(
      key: captureKey,
      child: AtlasCatalogViewer(catalog: catalog, controller: controller),
    ),
  );
}

Future<void> _setViewport(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

String _humanize(String value) =>
    '${value[0].toUpperCase()}${value.substring(1)}';

bool _supportsViewerGoldens() {
  if (AtlasGoldens.platforms.contains(Platform.operatingSystem)) return true;
  markTestSkipped(
    'Viewer goldens are generated on ${AtlasGoldens.platforms}; '
    'rendering differs on ${Platform.operatingSystem}.',
  );

  return false;
}
