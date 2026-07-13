import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'atlas_story_canvas.dart';
import 'component_atlas.dart';
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

/// Browsable, responsive shell for a complete [AtlasCatalog].
///
/// The viewer preserves catalog declaration order, supports keyboard search,
/// exposes atlas metadata, and uses [AtlasStoryCanvas] for fast visual
/// comparisons. The supplied [AtlasTheme.builder] still owns the component
/// token scope; this shell only supplies its neutral navigation chrome.
class AtlasCatalogViewer extends StatefulWidget {
  const AtlasCatalogViewer({super.key, required this.catalog, this.controller});

  final AtlasCatalog catalog;
  final AtlasCatalogController? controller;

  @override
  State<AtlasCatalogViewer> createState() => _AtlasCatalogViewerState();
}

class _AtlasCatalogViewerState extends State<AtlasCatalogViewer> {
  static const _desktopBreakpoint = 1040.0;

  late AtlasCatalogController _controller;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode(debugLabel: 'Atlas catalog search');
  bool _detailsOpen = false;

  @override
  void initState() {
    super.initState();
    _attachController();
  }

  void _attachController() {
    assert(
      widget.controller == null ||
          identical(widget.controller!.catalog, widget.catalog),
      'AtlasCatalogViewer.controller must be built from the same catalog '
      'passed to the viewer.',
    );
    _controller = widget.controller ?? AtlasCatalogController(widget.catalog);
    _controller.addListener(_handleSelectionChanged);
  }

  void _handleSelectionChanged() {
    if (_detailsOpen) setState(() => _detailsOpen = false);
  }

  void _focusSearch() => _searchFocusNode.requestFocus();

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.requestFocus();
  }

  void _submitSearch(String query) {
    final results = _filterAtlases(widget.catalog.atlases, query);
    if (results.isEmpty) return;
    _controller.select(atlasId: results.first.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _handleEscape() {
    if (_detailsOpen) {
      setState(() => _detailsOpen = false);

      return;
    }
    if (_searchController.text.isNotEmpty) {
      _clearSearch();

      return;
    }
    _searchFocusNode.unfocus();
  }

  Widget _buildViewer() {
    final selection = _controller.selection!;
    final atlas = widget.catalog.atlases.firstWhere(
      (item) => item.id == selection.atlasId,
    );
    final theme = widget.catalog.themes.firstWhere(
      (item) => item.id == selection.themeId,
    );

    return theme.builder(
      context,
      Builder(
        builder: (context) {
          final viewerTheme = _viewerTheme(theme);
          final mediaQuery =
              (MediaQuery.maybeOf(context) ?? const MediaQueryData()).copyWith(
                platformBrightness: theme.brightness,
              );

          return MediaQuery(
            data: mediaQuery,
            child: Theme(
              data: viewerTheme,
              child: DefaultTextStyle(
                style: _textStyle(
                  color: viewerTheme.colorScheme.onSurface,
                  fontSize: 14,
                ),
                child: CallbackShortcuts(
                  bindings: {
                    const SingleActivator(.slash): _focusSearch,
                    const SingleActivator(.escape): _handleEscape,
                  },
                  child: Focus(
                    autofocus: true,
                    child: Material(
                      color: viewerTheme.colorScheme.surface,
                      child: SafeArea(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final desktop =
                                constraints.maxWidth >= _desktopBreakpoint;

                            return desktop
                                ? _DesktopLayout(
                                    catalog: widget.catalog,
                                    controller: _controller,
                                    atlas: atlas,
                                    theme: theme,
                                    searchController: _searchController,
                                    searchFocusNode: _searchFocusNode,
                                    detailsOpen: _detailsOpen,
                                    onClearSearch: _clearSearch,
                                    onSubmitSearch: _submitSearch,
                                    onToggleDetails: () => setState(
                                      () => _detailsOpen = !_detailsOpen,
                                    ),
                                  )
                                : _CompactLayout(
                                    catalog: widget.catalog,
                                    controller: _controller,
                                    atlas: atlas,
                                    theme: theme,
                                    searchController: _searchController,
                                    searchFocusNode: _searchFocusNode,
                                    detailsOpen: _detailsOpen,
                                    onClearSearch: _clearSearch,
                                    onSubmitSearch: _submitSearch,
                                    onToggleDetails: () => setState(
                                      () => _detailsOpen = !_detailsOpen,
                                    ),
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AtlasCatalogViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller &&
        oldWidget.catalog == widget.catalog) {
      return;
    }
    _controller.removeListener(_handleSelectionChanged);
    if (oldWidget.controller == null) _controller.dispose();
    _attachController();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleSelectionChanged);
    if (widget.controller == null) _controller.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.catalog.atlases.isEmpty || widget.catalog.themes.isEmpty) {
      return const ColoredBox(
        color: Color(0xfff8f9fa),
        child: Center(child: Text('No atlases to display')),
      );
    }

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _searchController,
      builder: (context, value, child) => ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => _buildViewer(),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.catalog,
    required this.controller,
    required this.atlas,
    required this.theme,
    required this.searchController,
    required this.searchFocusNode,
    required this.detailsOpen,
    required this.onClearSearch,
    required this.onSubmitSearch,
    required this.onToggleDetails,
  });

  final AtlasCatalog catalog;
  final AtlasCatalogController controller;
  final ComponentAtlas atlas;
  final AtlasTheme theme;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final bool detailsOpen;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSubmitSearch;
  final VoidCallback onToggleDetails;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: .stretch,
    children: [
      SizedBox(
        width: 256,
        child: _CatalogSidebar(
          catalog: catalog,
          controller: controller,
          searchController: searchController,
          searchFocusNode: searchFocusNode,
          onClearSearch: onClearSearch,
          onSubmitSearch: onSubmitSearch,
        ),
      ),
      Container(color: Theme.of(context).colorScheme.outlineVariant, width: 1),
      Expanded(
        child: _Inspector(
          atlas: atlas,
          theme: theme,
          compact: false,
          detailsOpen: detailsOpen,
          onToggleDetails: onToggleDetails,
        ),
      ),
    ],
  );
}

class _CompactLayout extends StatelessWidget {
  const _CompactLayout({
    required this.catalog,
    required this.controller,
    required this.atlas,
    required this.theme,
    required this.searchController,
    required this.searchFocusNode,
    required this.detailsOpen,
    required this.onClearSearch,
    required this.onSubmitSearch,
    required this.onToggleDetails,
  });

  final AtlasCatalog catalog;
  final AtlasCatalogController controller;
  final ComponentAtlas atlas;
  final AtlasTheme theme;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final bool detailsOpen;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSubmitSearch;
  final VoidCallback onToggleDetails;

  @override
  Widget build(BuildContext context) {
    final results = _filterAtlases(catalog.atlases, searchController.text);

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .fromLTRB(16, 14, 16, 12),
          child: Row(
            children: [
              Expanded(child: _CatalogHeading(catalog: catalog, compact: true)),
              _ThemeControl(catalog: catalog, controller: controller),
            ],
          ),
        ),
        Padding(
          padding: const .fromLTRB(16, 0, 16, 10),
          child: _CatalogSearch(
            controller: searchController,
            focusNode: searchFocusNode,
            onClear: onClearSearch,
            onSubmitted: onSubmitSearch,
          ),
        ),
        _CompactCatalogRail(
          controller: controller,
          atlases: results,
          searching: searchController.text.trim().isNotEmpty,
        ),
        Container(
          color: Theme.of(context).colorScheme.outlineVariant,
          height: 1,
        ),
        Expanded(
          child: _Inspector(
            atlas: atlas,
            theme: theme,
            compact: true,
            detailsOpen: detailsOpen,
            onToggleDetails: onToggleDetails,
          ),
        ),
      ],
    );
  }
}

class _CatalogSidebar extends StatelessWidget {
  const _CatalogSidebar({
    required this.catalog,
    required this.controller,
    required this.searchController,
    required this.searchFocusNode,
    required this.onClearSearch,
    required this.onSubmitSearch,
  });

  final AtlasCatalog catalog;
  final AtlasCatalogController controller;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSubmitSearch;

  @override
  Widget build(BuildContext context) {
    final searching = searchController.text.trim().isNotEmpty;
    final atlases = _filterAtlases(catalog.atlases, searchController.text);
    final colors = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colors.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Padding(
            padding: const .fromLTRB(16, 24, 16, 16),
            child: _CatalogHeading(catalog: catalog),
          ),
          Padding(
            padding: const .fromLTRB(16, 0, 16, 16),
            child: _CatalogSearch(
              controller: searchController,
              focusNode: searchFocusNode,
              onClear: onClearSearch,
              onSubmitted: onSubmitSearch,
            ),
          ),
          Padding(
            padding: const .fromLTRB(16, 0, 16, 8),
            child: _NavigationHeading(
              label: searching ? 'Results' : 'Atlases',
              count: atlases.length,
            ),
          ),
          Expanded(
            child: atlases.isEmpty
                ? const _EmptySearch()
                : ListView.builder(
                    padding: const .fromLTRB(8, 0, 8, 12),
                    itemBuilder: (context, index) {
                      final atlas = atlases[index];
                      final declaredIndex = catalog.atlases.indexOf(atlas);

                      return _CatalogItem(
                        atlas: atlas,
                        index: declaredIndex,
                        selected: controller.selection?.atlasId == atlas.id,
                        onPressed: () => controller.select(atlasId: atlas.id),
                      );
                    },
                    itemCount: atlases.length,
                  ),
          ),
          Container(color: colors.outlineVariant, height: 1),
          Padding(
            padding: const .fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                Text(
                  'Theme',
                  style: _textStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                    weight: .w500,
                  ),
                ),
                const Spacer(),
                _ThemeControl(catalog: catalog, controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogHeading extends StatelessWidget {
  const _CatalogHeading({required this.catalog, this.compact = false});

  final AtlasCatalog catalog;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      spacing: 3,
      children: [
        Text(
          catalog.label ?? 'Components',
          style: _textStyle(
            color: colors.onSurface,
            fontSize: compact ? 16 : 18,
            weight: .w700,
            height: 1.2,
          ),
        ),
        Text(
          '${catalog.atlases.length} atlases',
          style: _textStyle(color: colors.onSurfaceVariant, fontSize: 11),
        ),
      ],
    );
  }
}

class _CatalogSearch extends StatelessWidget {
  const _CatalogSearch({
    required this.controller,
    required this.focusNode,
    required this.onClear,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: colors.outlineVariant),
      borderRadius: .circular(7),
    );

    return Focus(
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent || event.logicalKey != .escape) {
          return KeyEventResult.ignored;
        }
        if (controller.text.isNotEmpty) {
          onClear();
        } else {
          focusNode.unfocus();
        }

        return KeyEventResult.handled;
      },
      child: SizedBox(
        height: 40,
        child: Semantics(
          textField: true,
          label: 'Search components',
          child: TextField(
            key: const ValueKey('catalog-search'),
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Search components',
              hintStyle: _textStyle(
                color: colors.onSurfaceVariant,
                fontSize: 13,
              ),
              contentPadding: const .symmetric(vertical: 10),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 18,
                color: colors.onSurfaceVariant,
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 38),
              suffixIcon: controller.text.isEmpty
                  ? const Padding(
                      padding: .only(right: 8),
                      child: _SlashShortcut(),
                    )
                  : IconButton(
                      key: const ValueKey('clear-catalog-search'),
                      onPressed: onClear,
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.close_rounded, size: 17),
                    ),
              suffixIconConstraints: const BoxConstraints(minWidth: 38),
              filled: true,
              fillColor: colors.surfaceContainerLowest,
              focusedBorder: border.copyWith(
                borderSide: BorderSide(color: colors.primary, width: 1.5),
              ),
              enabledBorder: border,
              border: border,
            ),
            textInputAction: .search,
            style: _textStyle(color: colors.onSurface, fontSize: 13),
            onSubmitted: onSubmitted,
          ),
        ),
      ),
    );
  }
}

class _SlashShortcut extends StatelessWidget {
  const _SlashShortcut();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      excludeSemantics: true,
      label: 'Press slash to search',
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          border: .all(color: colors.outlineVariant),
          borderRadius: .circular(5),
        ),
        width: 22,
        height: 22,
        child: Text(
          '/',
          style: _textStyle(
            color: colors.onSurfaceVariant,
            fontSize: 11,
            weight: .w600,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _NavigationHeading extends StatelessWidget {
  const _NavigationHeading({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          label,
          style: _textStyle(
            color: colors.onSurfaceVariant,
            fontSize: 12,
            weight: .w600,
          ),
        ),
        const Spacer(),
        Text(
          '$count',
          key: const ValueKey('catalog-results-count'),
          style: _textStyle(color: colors.onSurfaceVariant, fontSize: 11),
        ),
      ],
    );
  }
}

class _CatalogItem extends StatelessWidget {
  const _CatalogItem({
    required this.atlas,
    required this.index,
    required this.selected,
    required this.onPressed,
  });

  final ComponentAtlas atlas;
  final int index;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(7);

    return SizedBox(
      width: .infinity,
      height: 44,
      child: Stack(
        children: [
          Positioned.fill(
            child: Semantics(
              selected: selected,
              button: true,
              label: '${atlas.label ?? atlas.id} atlas',
              child: Material(
                key: ValueKey('catalog-item-${atlas.id}'),
                color: selected ? colors.primaryContainer : Colors.transparent,
                borderRadius: radius,
                clipBehavior: .antiAlias,
                child: InkWell(
                  onTap: onPressed,
                  child: Padding(
                    padding: const .symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${(index + 1).toString().padLeft(2, '0')}  '
                        '${atlas.label ?? atlas.id}',
                        style: _textStyle(
                          color: selected
                              ? colors.onPrimaryContainer
                              : colors.onSurface,
                          fontSize: 13,
                          weight: selected ? .w600 : .w500,
                        ),
                        overflow: .ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (selected)
            Positioned(
              left: 0,
              top: 10,
              child: Container(color: colors.primary, width: 2, height: 24),
            ),
        ],
      ),
    );
  }
}

class _CompactCatalogRail extends StatelessWidget {
  const _CompactCatalogRail({
    required this.controller,
    required this.atlases,
    required this.searching,
  });

  final AtlasCatalogController controller;
  final List<ComponentAtlas> atlases;
  final bool searching;

  @override
  Widget build(BuildContext context) {
    if (atlases.isEmpty) {
      return const SizedBox(height: 60, child: _EmptySearch(compact: true));
    }

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (searching)
          Padding(
            padding: const .fromLTRB(16, 0, 16, 4),
            child: _NavigationHeading(label: 'Results', count: atlases.length),
          ),
        SizedBox(
          key: const ValueKey('compact-catalog-rail'),
          height: 48,
          child: ListView.separated(
            scrollDirection: .horizontal,
            padding: const .fromLTRB(16, 4, 16, 8),
            itemBuilder: (context, index) {
              final atlas = atlases[index];

              return _AtlasChoiceChip(
                key: ValueKey('catalog-item-${atlas.id}'),
                label: atlas.label ?? atlas.id,
                semanticLabel: '${atlas.label ?? atlas.id} atlas',
                selected: controller.selection?.atlasId == atlas.id,
                onPressed: () => controller.select(atlasId: atlas.id),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(width: 4),
            itemCount: atlases.length,
          ),
        ),
      ],
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: .all(compact ? 8 : 20),
        child: Column(
          mainAxisSize: .min,
          spacing: 3,
          children: [
            Text(
              'No atlases found',
              style: _textStyle(
                color: colors.onSurfaceVariant,
                fontSize: 12,
                weight: .w600,
              ),
            ),
            Text(
              'Try another name',
              style: _textStyle(color: colors.onSurfaceVariant, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeControl extends StatelessWidget {
  const _ThemeControl({required this.catalog, required this.controller});

  final AtlasCatalog catalog;
  final AtlasCatalogController controller;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: .min,
    children: [
      for (var index = 0; index < catalog.themes.length; index++) ...[
        if (index > 0) const SizedBox(width: 4),
        _AtlasChoiceChip(
          key: ValueKey('theme-${catalog.themes[index].id}'),
          label: catalog.themes[index].label ?? catalog.themes[index].id,
          semanticLabel:
              '${catalog.themes[index].label ?? catalog.themes[index].id} theme',
          selected: controller.selection?.themeId == catalog.themes[index].id,
          onPressed: () => controller.select(themeId: catalog.themes[index].id),
          outlined: true,
        ),
      ],
    ],
  );
}

class _AtlasChoiceChip extends StatelessWidget {
  const _AtlasChoiceChip({
    super.key,
    required this.label,
    required this.semanticLabel,
    required this.selected,
    required this.onPressed,
    this.outlined = false,
  });

  final String label;
  final String semanticLabel;
  final bool selected;
  final VoidCallback onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(6);

    return Semantics(
      selected: selected,
      button: true,
      label: semanticLabel,
      child: Material(
        color: selected ? colors.primaryContainer : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selected
                ? colors.primary.withValues(alpha: 0.55)
                : outlined
                ? colors.outlineVariant
                : Colors.transparent,
          ),
          borderRadius: radius,
        ),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            alignment: Alignment.center,
            padding: const .symmetric(horizontal: 10),
            height: 30,
            constraints: const BoxConstraints(minWidth: 36),
            child: Text(
              label,
              style: _textStyle(
                color: selected
                    ? colors.onPrimaryContainer
                    : colors.onSurfaceVariant,
                fontSize: 12,
                weight: selected ? .w600 : .w500,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _Inspector extends StatelessWidget {
  const _Inspector({
    required this.atlas,
    required this.theme,
    required this.compact,
    required this.detailsOpen,
    required this.onToggleDetails,
  });

  final ComponentAtlas atlas;
  final AtlasTheme theme;
  final bool compact;
  final bool detailsOpen;
  final VoidCallback onToggleDetails;

  @override
  Widget build(BuildContext context) {
    final detailsRegion = Object();

    return Stack(
      clipBehavior: .none,
      children: [
        Positioned.fill(
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              _InspectorHeader(
                atlas: atlas,
                compact: compact,
                detailsOpen: detailsOpen,
                detailsRegion: detailsRegion,
                onToggleDetails: onToggleDetails,
              ),
              Expanded(
                child: _AtlasViewport(
                  atlas: atlas,
                  theme: theme,
                  compact: compact,
                ),
              ),
            ],
          ),
        ),
        if (detailsOpen)
          Positioned(
            key: const ValueKey('atlas-details-popover'),
            top: compact ? 74 : 82,
            right: compact ? 16 : 28,
            child: TapRegion(
              onTapOutside: (_) => onToggleDetails(),
              groupId: detailsRegion,
              child: _AtlasDetailsCard(atlas: atlas),
            ),
          ),
      ],
    );
  }
}

class _InspectorHeader extends StatelessWidget {
  const _InspectorHeader({
    required this.atlas,
    required this.compact,
    required this.detailsOpen,
    required this.detailsRegion,
    required this.onToggleDetails,
  });

  final ComponentAtlas atlas;
  final bool compact;
  final bool detailsOpen;
  final Object detailsRegion;
  final VoidCallback onToggleDetails;

  @override
  Widget build(BuildContext context) {
    final cells = atlas.rows.length * atlas.scenarios.length;
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: .symmetric(
        vertical: compact ? 14 : 20,
        horizontal: compact ? 16 : 28,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      height: compact ? 102 : 116,
      child: Row(
        spacing: 16,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              spacing: 4,
              children: [
                Text(
                  atlas.label ?? atlas.id,
                  key: const ValueKey('selected-atlas-title'),
                  style: _textStyle(
                    color: colors.onSurface,
                    fontSize: compact ? 25 : 30,
                    weight: .w700,
                    height: 1.1,
                    letterSpacing: compact ? -0.4 : -0.7,
                  ),
                  overflow: .ellipsis,
                  maxLines: 1,
                ),
                Text(
                  _axisDescription(atlas),
                  style: _textStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                  overflow: .ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          TapRegion(
            groupId: detailsRegion,
            child: Semantics(
              excludeSemantics: true,
              button: true,
              label:
                  '${detailsOpen ? 'Hide' : 'Show'} atlas details, $cells cells',
              child: Material(
                key: const ValueKey('atlas-details-trigger'),
                color: detailsOpen ? colors.primaryContainer : colors.surface,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: detailsOpen
                        ? colors.primary.withValues(alpha: 0.55)
                        : colors.outlineVariant,
                  ),
                  borderRadius: .circular(6),
                ),
                clipBehavior: .antiAlias,
                child: InkWell(
                  onTap: onToggleDetails,
                  child: Padding(
                    padding: const .symmetric(vertical: 7, horizontal: 12),
                    child: Text(
                      '$cells cells',
                      style: _textStyle(
                        color: detailsOpen
                            ? colors.onPrimaryContainer
                            : colors.onSurfaceVariant,
                        fontSize: 12,
                        weight: .w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AtlasDetailsCard extends StatelessWidget {
  const _AtlasDetailsCard({required this.atlas});

  final ComponentAtlas atlas;

  @override
  Widget build(BuildContext context) {
    final rows = _atlasDetails(atlas);
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      container: true,
      label: 'Atlas details',
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          padding: const .all(12),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            border: .all(color: colors.outlineVariant),
            borderRadius: .circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == .dark ? 0.35 : 0.12,
                ),
                offset: const Offset(0, 8),
                blurRadius: 24,
              ),
            ],
          ),
          width: 232,
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              Text(
                'Atlas details',
                style: _textStyle(
                  color: colors.onSurface,
                  fontSize: 13,
                  weight: .w600,
                ),
              ),
              const SizedBox(height: 10),
              Container(color: colors.outlineVariant, height: 1),
              const SizedBox(height: 8),
              for (final row in rows)
                SizedBox(
                  height: 22,
                  child: Row(
                    children: [
                      Text(
                        row.label,
                        style: _textStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        row.value,
                        style: _textStyle(
                          color: colors.onSurface,
                          fontSize: 12,
                          weight: .w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AtlasViewport extends StatelessWidget {
  const _AtlasViewport({
    required this.atlas,
    required this.theme,
    required this.compact,
  });

  final ComponentAtlas atlas;
  final AtlasTheme theme;
  final bool compact;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.surfaceContainerLow,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final inset = compact ? 12.0 : 24.0;
        final available = math.max(0.0, constraints.maxWidth - (inset * 2));
        final width = math.max(
          available,
          AtlasStoryCanvas.minimumWidth(atlas, compact: compact),
        );

        return SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: .horizontal,
            child: Padding(
              padding: .all(inset),
              child: SizedBox(
                width: width,
                child: AtlasStoryCanvas(
                  // A selected atlas must get a fresh subtree so overlay-host
                  // Navigator routes cannot leak across component switches.
                  key: ValueKey(atlas.id),
                  atlas: atlas,
                  theme: theme,
                  compact: compact,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

List<ComponentAtlas> _filterAtlases(
  List<ComponentAtlas> atlases,
  String query,
) {
  final terms = query
      .trim()
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((term) => term.isNotEmpty)
      .toList();
  if (terms.isEmpty) return atlases;

  return atlases.where((atlas) {
    final haystack = '${atlas.id} ${atlas.label ?? ''}'.toLowerCase();

    return terms.every(haystack.contains);
  }).toList();
}

String _axisDescription(ComponentAtlas atlas) {
  if (atlas.rowAxes.isEmpty) return 'Rows / Scenarios';

  return atlas.rowAxes.map((axis) => axis.label).join(' / ');
}

List<({String label, String value})> _atlasDetails(ComponentAtlas atlas) {
  final result = <({String label, String value})>[];
  if (atlas.scenarios.length == 1) {
    final scenario = atlas.scenarios.first;
    result.add((
      label: 'Scenario',
      value: scenario.label ?? _humanize(scenario.id),
    ));
  } else {
    result.add((label: 'Scenarios', value: '${atlas.scenarios.length}'));
  }
  for (final axis in atlas.rowAxes) {
    final values = <String>{};
    for (final row in atlas.rows) {
      values.add(row.values[axis.id]!.id);
    }
    result.add((label: _pluralize(axis.label), value: '${values.length}'));
  }
  result.add((
    label: 'Cells',
    value: '${atlas.rows.length * atlas.scenarios.length}',
  ));

  return result;
}

String _pluralize(String value) => value.endsWith('s') ? value : '${value}s';

String _humanize(String value) => value
    .split('-')
    .where((part) => part.isNotEmpty)
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join(' ');

ThemeData _viewerTheme(AtlasTheme theme) {
  final dark = theme.brightness == .dark;
  final base = ColorScheme.fromSeed(
    seedColor: dark ? const Color(0xff7895ff) : const Color(0xff3157d5),
    brightness: theme.brightness,
  );
  final colors = base.copyWith(
    primary: dark ? const Color(0xff7895ff) : const Color(0xff3157d5),
    primaryContainer: dark ? const Color(0xff293861) : const Color(0xffedf1ff),
    onPrimaryContainer: dark
        ? const Color(0xffdce4ff)
        : const Color(0xff2447bc),
    surface: theme.background,
    onSurface: dark ? const Color(0xfff1f3f5) : const Color(0xff20242a),
    surfaceContainerLowest: dark
        ? const Color(0xff15171c)
        : const Color(0xffffffff),
    surfaceContainerLow: dark
        ? const Color(0xff1d2026)
        : const Color(0xfff8f9fa),
    surfaceContainer: dark ? const Color(0xff262a31) : const Color(0xfff0f2f5),
    onSurfaceVariant: dark ? const Color(0xffaab0ba) : const Color(0xff69717c),
    outline: dark ? const Color(0xff555b66) : const Color(0xffc9cdd3),
    outlineVariant: dark ? const Color(0xff353a43) : const Color(0xffe1e4e8),
  );

  return ThemeData(
    splashFactory: NoSplash.splashFactory,
    useMaterial3: true,
    colorScheme: colors,
    brightness: theme.brightness,
    focusColor: colors.primary.withValues(alpha: 0.08),
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    scaffoldBackgroundColor: colors.surface,
    fontFamily: 'Roboto',
  );
}

TextStyle _textStyle({
  required Color color,
  required double fontSize,
  FontWeight weight = .w400,
  double height = 1.35,
  double letterSpacing = 0,
}) => .new(
  color: color,
  fontSize: fontSize,
  fontWeight: weight,
  letterSpacing: letterSpacing,
  height: height,
  fontFamily: 'Roboto',
);

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
