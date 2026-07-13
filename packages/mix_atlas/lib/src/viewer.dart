import 'package:flutter/material.dart';

import 'component_atlas.dart';
import 'atlas_view.dart';
import 'theme.dart';

@immutable
class AtlasCatalogSelection {
  final String atlasId;

  final String themeId;
  const AtlasCatalogSelection({required this.atlasId, required this.themeId});

  @override
  bool operator ==(Object other) =>
      other is AtlasCatalogSelection &&
      other.atlasId == atlasId &&
      other.themeId == themeId;

  @override
  int get hashCode => Object.hash(atlasId, themeId);
}

class AtlasCatalogController extends ChangeNotifier {
  final AtlasCatalog catalog;

  AtlasCatalogSelection? _selection;
  AtlasCatalogController(this.catalog, {String? atlasId, String? themeId})
    : _selection = _normalize(catalog, atlasId, themeId);

  static AtlasCatalogSelection? _normalize(
    AtlasCatalog catalog,
    String? atlasId,
    String? themeId,
  ) {
    if (catalog.atlases.isEmpty || catalog.themes.isEmpty) return null;
    final atlas = catalog.atlases.firstWhere(
      (item) => item.id == atlasId,
      orElse: () => catalog.atlases.first,
    );
    final theme = catalog.themes.firstWhere(
      (item) => item.id == themeId,
      orElse: () => catalog.themes.first,
    );

    return AtlasCatalogSelection(atlasId: atlas.id, themeId: theme.id);
  }

  AtlasCatalogSelection? get selection => _selection;

  void select({String? atlasId, String? themeId}) {
    final next = _normalize(
      catalog,
      atlasId ?? _selection?.atlasId,
      themeId ?? _selection?.themeId,
    );
    if (next == _selection) return;
    _selection = next;
    notifyListeners();
  }
}

class AtlasCatalogViewer extends StatefulWidget {
  const AtlasCatalogViewer({super.key, required this.catalog, this.controller});

  final AtlasCatalog catalog;
  final AtlasCatalogController? controller;

  @override
  State<AtlasCatalogViewer> createState() => _AtlasCatalogViewerState();
}

class _AtlasCatalogViewerState extends State<AtlasCatalogViewer> {
  late AtlasCatalogController _controller;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    assert(
      widget.controller == null ||
          identical(widget.controller!.catalog, widget.catalog),
      'AtlasCatalogViewer.controller must be built from the same catalog '
      'passed to the viewer.',
    );
    _controller = widget.controller ?? AtlasCatalogController(widget.catalog);
  }

  Widget _buildViewer() {
    final selection = _controller.selection!;
    final atlas = widget.catalog.atlases.firstWhere(
      (item) => item.id == selection.atlasId,
    );
    final theme = widget.catalog.themes.firstWhere(
      (item) => item.id == selection.themeId,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 800;
        final sidebar = _Sidebar(
          catalog: widget.catalog,
          controller: _controller,
          search: _search,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.catalog.label ?? widget.catalog.id),
            backgroundColor: const Color(0xff202733),
            foregroundColor: Colors.white,
          ),
          body: Row(
            children: [
              if (wide) SizedBox(width: 280, child: sidebar),
              Expanded(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    _InspectorHeader(
                      atlas: atlas,
                      theme: theme,
                      themes: widget.catalog.themes,
                      onTheme: (id) => _controller.select(themeId: id),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: .horizontal,
                          child: theme.builder(
                            context,
                            ColoredBox(
                              color: theme.background,
                              child: Padding(
                                padding: const .all(32),
                                child: IgnorePointer(
                                  child: AtlasView(
                                    // Key by atlas id so switching atlases
                                    // rebuilds a fresh atlas subtree. Overlay
                                    // cells host a local Navigator whose routes
                                    // (incl. imperatively pushed dialogs) would
                                    // otherwise survive element reuse and leak
                                    // into the next atlas's cells.
                                    key: ValueKey(atlas.id),
                                    atlas: atlas,
                                    title: atlas.label ?? atlas.id,
                                    labelColor: theme.brightness == .dark
                                        ? const Color(0x99ffffff)
                                        : const Color(0x99000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          drawer: wide ? null : Drawer(child: SafeArea(child: sidebar)),
          backgroundColor: const Color(0xffeef1f5),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant AtlasCatalogViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller &&
        oldWidget.catalog == widget.catalog) {
      return;
    }
    if (oldWidget.controller == null) _controller.dispose();
    _controller = widget.controller ?? AtlasCatalogController(widget.catalog);
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.catalog.atlases.isEmpty || widget.catalog.themes.isEmpty) {
      return const ColoredBox(
        color: Color(0xfff4f6f8),
        child: Center(child: Text('No atlases to display')),
      );
    }

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => _buildViewer(),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.catalog,
    required this.controller,
    required this.search,
  });
  final AtlasCatalog catalog;
  final AtlasCatalogController controller;
  final TextEditingController search;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xfff8fafc),
      child: Column(
        children: [
          Padding(
            padding: const .all(16),
            child: TextField(
              controller: search,
              decoration: const InputDecoration(
                labelText: 'Search components',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: search,
              builder: (context, value, _) {
                final query = value.text.trim().toLowerCase();
                final items = catalog.atlases.where((item) {
                  return item.id.toLowerCase().contains(query) ||
                      (item.label ?? '').toLowerCase().contains(query);
                }).toList();

                return ListView(
                  children: [
                    for (final item in items)
                      ListTile(
                        title: Text(item.label ?? item.id),
                        subtitle: Text(
                          item.id,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                        onTap: () {
                          controller.select(atlasId: item.id);
                          if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
                            Navigator.of(context).pop();
                          }
                        },
                        selected: controller.selection?.atlasId == item.id,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InspectorHeader extends StatelessWidget {
  const _InspectorHeader({
    required this.atlas,
    required this.theme,
    required this.themes,
    required this.onTheme,
  });
  final ComponentAtlas atlas;
  final AtlasTheme theme;
  final List<AtlasTheme> themes;
  final ValueChanged<String> onTheme;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .all(20),
    child: Wrap(
      spacing: 24,
      runSpacing: 12,
      crossAxisAlignment: .center,
      children: [
        Text(
          atlas.label ?? atlas.id,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          '${atlas.rows.length} rows × ${atlas.scenarios.length} scenarios = '
          '${atlas.rows.length * atlas.scenarios.length} cells',
          style: const TextStyle(fontFamily: 'monospace'),
        ),
        DropdownButton<String>(
          items: [
            for (final item in themes)
              DropdownMenuItem(
                value: item.id,
                child: Text(item.label ?? item.id),
              ),
          ],
          value: theme.id,
          onChanged: (value) {
            if (value != null) onTheme(value);
          },
        ),
      ],
    ),
  );
}

/// A local Navigator and Overlay that keeps component overlays inside its box.
class AtlasOverlayHost extends StatelessWidget {
  const AtlasOverlayHost({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => ClipRect(
    child: Navigator(
      onGenerateRoute: (_) => PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            Material(type: .transparency, child: child),
        transitionDuration: .zero,
        reverseTransitionDuration: .zero,
        opaque: false,
        barrierColor: Colors.transparent,
      ),
    ),
  );
}
