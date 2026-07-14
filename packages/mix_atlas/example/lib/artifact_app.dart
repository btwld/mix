import 'dart:async';

import 'package:flutter/material.dart';

import 'artifacts/capture_bundle.dart';
import 'artifacts/capture_loader.dart';
import 'artifacts/component_document.dart';
import 'portable_component_renderer.dart';

const defaultArtifactRequest = ArtifactRepositoryRequest(
  repository: 'btwld/remix',
  ref: 'main',
  manifestPath: 'atlas/fortal/capture.json',
);

const remoteSpikeArtifactRequest = ArtifactRepositoryRequest(
  repository: 'btwld/remix',
  ref: 'feat/mix-atlas-fortal-artifacts',
  manifestPath: 'atlas/fortal/capture.json',
);

typedef ArtifactClock = DateTime Function();

class ArtifactAtlasApp extends StatelessWidget {
  const ArtifactAtlasApp({
    required this.loader,
    this.initialRequest = defaultArtifactRequest,
    this.clock = DateTime.now,
    super.key,
  });

  final ArtifactCaptureLoader loader;
  final ArtifactRepositoryRequest initialRequest;
  final ArtifactClock clock;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF172033);
    const accent = Color(0xFF4968DB);

    return MaterialApp(
      home: ArtifactHome(
        loader: loader,
        initialRequest: initialRequest,
        clock: clock,
      ),
      title: 'Mix Atlas · Repository capture',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8DDE8)),
            borderRadius: .circular(9),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8DDE8)),
            borderRadius: .circular(9),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: .light,
          surface: const Color(0xFFF8F9FC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F3F8),
        textTheme: ThemeData.light().textTheme.apply(
          displayColor: ink,
          bodyColor: ink,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFFDDE2EC)),
            borderRadius: .circular(12),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum _LoadPhase { idle, loading, loaded, failed }

class ArtifactHome extends StatefulWidget {
  const ArtifactHome({
    required this.loader,
    required this.initialRequest,
    required this.clock,
    super.key,
  });

  final ArtifactCaptureLoader loader;
  final ArtifactRepositoryRequest initialRequest;
  final ArtifactClock clock;

  @override
  State<ArtifactHome> createState() => _ArtifactHomeState();
}

class _ArtifactHomeState extends State<ArtifactHome> {
  late final TextEditingController _repositoryController;
  late final TextEditingController _refController;
  late final TextEditingController _artifactController;
  _LoadPhase _phase = .idle;
  ArtifactRepositoryRequest? _lastRequest;
  LoadedCapture? _capture;
  ArtifactLoadException? _failure;
  DateTime? _loadedAt;

  @override
  void initState() {
    super.initState();
    _repositoryController = TextEditingController(
      text: widget.initialRequest.repository,
    );
    _refController = TextEditingController(text: widget.initialRequest.ref);
    _artifactController = TextEditingController(
      text: widget.initialRequest.manifestPath,
    );
  }

  Future<void> _open({ArtifactRepositoryRequest? request}) async {
    final nextRequest =
        request ??
        ArtifactRepositoryRequest(
          repository: _repositoryController.text.trim(),
          ref: _refController.text.trim(),
          manifestPath: _artifactController.text.trim(),
        );
    setState(() {
      _phase = .loading;
      _lastRequest = nextRequest;
      _failure = null;
    });
    try {
      final capture = await widget.loader.load(nextRequest);
      if (!mounted) return;
      setState(() {
        _capture = capture;
        _loadedAt = widget.clock();
        _phase = .loaded;
      });
    } on ArtifactLoadException catch (error) {
      if (!mounted) return;
      setState(() {
        _capture = null;
        _failure = error;
        _phase = .failed;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _capture = null;
        _failure = ArtifactLoadException(
          .sourceRejected,
          'The capture could not be opened because of an unexpected error.',
          cause: error,
        );
        _phase = .failed;
      });
    }
  }

  @override
  void dispose() {
    _repositoryController.dispose();
    _refController.dispose();
    _artifactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          spacing: 13,
          children: [
            _AtlasMark(),
            Text(
              'Repository captures',
              style: TextStyle(fontSize: 15, fontWeight: .w500),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: .only(right: 24),
            child: Center(child: _HeaderBadge(label: 'Standalone preview')),
          ),
        ],
        backgroundColor: const Color(0xFF172033),
        foregroundColor: Colors.white,
        titleSpacing: 24,
        toolbarHeight: 62,
      ),
      body: Column(
        children: [
          _RepositoryForm(
            repositoryController: _repositoryController,
            refController: _refController,
            artifactController: _artifactController,
            loading: _phase == .loading,
            onOpen: () => unawaited(_open()),
          ),
          Expanded(
            child: switch (_phase) {
              .idle => const _EntryState(),
              .loading => const _LoadingState(),
              .loaded => _LoadedState(capture: _capture!, loadedAt: _loadedAt!),
              .failed => _FailureState(
                failure: _failure!,
                onRetry: () => unawaited(_open(request: _lastRequest)),
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _AtlasMark extends StatelessWidget {
  const _AtlasMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      spacing: 9,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF5E7AEE),
            borderRadius: .circular(7),
          ),
          width: 28,
          height: 28,
          child: const Icon(Icons.grid_view_rounded, size: 16),
        ),
        const Text(
          'MIX ATLAS',
          style: TextStyle(fontSize: 14, fontWeight: .w800, letterSpacing: 1.2),
        ),
      ],
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.09),
        border: .all(color: Colors.white.withValues(alpha: 0.16)),
        borderRadius: .circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: .w600),
      ),
    );
  }
}

class _RepositoryForm extends StatelessWidget {
  const _RepositoryForm({
    required this.repositoryController,
    required this.refController,
    required this.artifactController,
    required this.loading,
    required this.onOpen,
  });

  final TextEditingController repositoryController;
  final TextEditingController refController;
  final TextEditingController artifactController;
  final bool loading;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: const Color(0xFFF8F9FC),
      child: Container(
        padding: const .fromLTRB(24, 14, 24, 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFDDE2EC))),
        ),
        child: Row(
          crossAxisAlignment: .end,
          children: [
            Expanded(
              flex: 3,
              child: _SourceField(
                key: const ValueKey('repository-field'),
                label: 'Repository',
                controller: repositoryController,
                hint: 'owner/repository',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _SourceField(
                key: const ValueKey('ref-field'),
                label: 'Ref',
                controller: refController,
                hint: 'main or commit SHA',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: _SourceField(
                key: const ValueKey('artifact-field'),
                label: 'Artifact',
                controller: artifactController,
                hint: 'path/to/capture.json',
              ),
            ),
            const SizedBox(width: 14),
            SizedBox(
              height: 40,
              child: FilledButton.icon(
                key: const ValueKey('open-fortal'),
                onPressed: loading ? null : onOpen,
                icon: loading
                    ? const SizedBox.square(
                        dimension: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.folder_open_rounded, size: 18),
                label: Text(loading ? 'Opening…' : 'Open Fortal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceField extends StatelessWidget {
  const _SourceField({
    required this.label,
    required this.controller,
    required this.hint,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const .only(left: 2, bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 10,
              fontWeight: .w700,
              letterSpacing: 0.7,
            ),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}

class _EntryState extends StatelessWidget {
  const _EntryState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Card(
          margin: const .all(32),
          child: Padding(
            padding: const .all(32),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 34,
                  color: Color(0xFF4968DB),
                ),
                const SizedBox(height: 18),
                Text(
                  'Open a trusted design-system capture',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontWeight: .w700),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Atlas resolves the repository ref to an immutable commit, '
                  'verifies every file, and displays the captured component '
                  'sheet without compiling the source application.',
                  style: TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                const Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _EvidenceChip(
                      icon: Icons.fingerprint,
                      label: 'Commit receipt',
                    ),
                    _EvidenceChip(
                      icon: Icons.verified_user_outlined,
                      label: 'SHA-256 integrity',
                    ),
                    _EvidenceChip(
                      icon: Icons.data_object,
                      label: 'Protocol diagnostics',
                    ),
                    _EvidenceChip(
                      icon: Icons.image_outlined,
                      label: 'Static component sheet',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EvidenceChip extends StatelessWidget {
  const _EvidenceChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(vertical: 8, horizontal: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5FA),
        borderRadius: .circular(8),
      ),
      child: Row(
        mainAxisSize: .min,
        spacing: 7,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF667085)),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: .min,
        spacing: 16,
        children: [
          CircularProgressIndicator(),
          Text(
            'Resolving ref and verifying capture…',
            style: TextStyle(color: Color(0xFF667085)),
          ),
        ],
      ),
    );
  }
}

class _FailureState extends StatelessWidget {
  const _FailureState({required this.failure, required this.onRetry});

  final ArtifactLoadException failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final guidance = _failureGuidance(failure.kind);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Card(
          key: const ValueKey('capture-failure'),
          margin: const .all(32),
          child: Padding(
            padding: const .all(28),
            child: Row(
              crossAxisAlignment: .start,
              spacing: 18,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0),
                    borderRadius: .circular(10),
                  ),
                  width: 42,
                  height: 42,
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFCC3D4A),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        guidance.title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontWeight: .w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        failure.message,
                        style: const TextStyle(height: 1.45),
                      ),
                      if (failure.path != null) ...[
                        const SizedBox(height: 8),
                        SelectableText(
                          failure.path!,
                          style: const TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Text(
                        guidance.action,
                        style: const TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        key: const ValueKey('retry-capture'),
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

({String title, String action}) _failureGuidance(ArtifactFailureKind kind) {
  return switch (kind) {
    .invalidRequest => (
      title: 'Repository details are invalid',
      action:
          'Use owner/repository, a valid ref, and a relative artifact path.',
    ),
    .network => (
      title: 'GitHub could not be reached',
      action: 'Check the connection and retry. No local build is required.',
    ),
    .rateLimited => (
      title: 'GitHub rate limit reached',
      action: 'Wait until the reported reset time before retrying.',
    ),
    .notFound => (
      title: 'Repository capture was not found',
      action: 'Check the repository, ref, and artifact path, then retry.',
    ),
    .unsupportedSchema => (
      title: 'Capture schema is not supported',
      action: 'Regenerate the capture with a compatible Atlas producer.',
    ),
    .integrity => (
      title: 'Capture integrity check failed',
      action: 'Regenerate and commit the bundle before trusting this capture.',
    ),
    .invalidProtocol => (
      title: 'Mix protocol validation failed',
      action: 'Review the reported document and producer protocol version.',
    ),
    .unsafePath => (
      title: 'Capture contains an unsafe path',
      action: 'Use normalized repository-relative paths in the manifest.',
    ),
    .malformedJson || .invalidCatalog || .invalidComponent => (
      title: 'Capture data is malformed',
      action: 'Validate the bundle with the producer packaging command.',
    ),
    .sourceRejected => (
      title: 'GitHub rejected the capture request',
      action: 'Review the response, repository visibility, and file size.',
    ),
  };
}

class _LoadedState extends StatefulWidget {
  const _LoadedState({required this.capture, required this.loadedAt});

  final LoadedCapture capture;
  final DateTime loadedAt;

  @override
  State<_LoadedState> createState() => _LoadedStateState();
}

class _LoadedStateState extends State<_LoadedState> {
  late String _componentId;
  late String _themeId;

  @override
  void initState() {
    super.initState();
    _selectDefaults();
  }

  void _selectDefaults() {
    _componentId = widget.capture.catalog.components.first.id;
    _themeId = widget.capture.catalog.themes.first.id;
  }

  @override
  void didUpdateWidget(covariant _LoadedState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.capture != widget.capture) _selectDefaults();
  }

  @override
  Widget build(BuildContext context) {
    final capture = widget.capture;
    final component = capture.catalog.components.firstWhere(
      (item) => item.id == _componentId,
    );
    final metadata = capture.atlasMetadata['${component.id}/$_themeId']!;

    return Column(
      children: [
        _SourceReceiptBar(capture: capture, loadedAt: widget.loadedAt),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final health = _CaptureHealth(capture: capture);
              final canvas = _CaptureCanvas(
                capture: capture,
                component: component,
                themeId: _themeId,
                metadata: metadata,
                onThemeChanged: (value) => setState(() => _themeId = value),
              );

              return Row(
                crossAxisAlignment: .stretch,
                children: [
                  SizedBox(
                    width: 220,
                    child: _ComponentNavigation(
                      capture: capture,
                      selectedId: _componentId,
                      onSelected: (value) {
                        setState(() => _componentId = value);
                      },
                    ),
                  ),
                  Expanded(child: canvas),
                  if (constraints.maxWidth >= 1080)
                    SizedBox(width: 330, child: health),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SourceReceiptBar extends StatelessWidget {
  const _SourceReceiptBar({required this.capture, required this.loadedAt});

  final LoadedCapture capture;
  final DateTime loadedAt;

  @override
  Widget build(BuildContext context) {
    final receipt = capture.receipt;

    return Container(
      padding: const .symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFDDE2EC))),
      ),
      height: 66,
      child: Row(
        spacing: 18,
        children: [
          const SizedBox(
            width: 210,
            child: Row(
              spacing: 10,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFF27A86B),
                    shape: .circle,
                  ),
                  child: SizedBox.square(dimension: 9),
                ),
                Flexible(
                  child: Text(
                    'Static repository capture',
                    style: TextStyle(fontSize: 13, fontWeight: .w700),
                    overflow: .ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _ReceiptDatum(
              label: 'SOURCE',
              value: '${receipt.repository} @ ${receipt.requestedRef}',
            ),
          ),
          Expanded(
            flex: 3,
            child: _ReceiptDatum(
              label: 'RESOLVED COMMIT',
              value: receipt.resolvedCommit,
              monospace: true,
            ),
          ),
          Expanded(
            flex: 2,
            child: _ReceiptDatum(
              label: 'LOADED',
              value: loadedAt.toUtc().toIso8601String(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptDatum extends StatelessWidget {
  const _ReceiptDatum({
    required this.label,
    required this.value,
    this.monospace = false,
  });

  final String label;
  final String value;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .start,
      spacing: 3,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8A93A5),
            fontSize: 9,
            fontWeight: .w700,
            letterSpacing: 0.65,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF3D4658),
            fontSize: 11,
            fontFamily: monospace ? 'monospace' : null,
          ),
          overflow: .ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}

class _ComponentNavigation extends StatelessWidget {
  const _ComponentNavigation({
    required this.capture,
    required this.selectedId,
    required this.onSelected,
  });

  final LoadedCapture capture;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .fromLTRB(16, 22, 16, 16),
      color: const Color(0xFFF8F9FC),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const .symmetric(horizontal: 8),
            child: Text(
              capture.catalog.label,
              style: const TextStyle(fontSize: 12, fontWeight: .w700),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: .symmetric(horizontal: 8),
            child: Text(
              'COMPONENTS',
              style: TextStyle(
                color: Color(0xFF8A93A5),
                fontSize: 9,
                fontWeight: .w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 7),
          for (final component in capture.catalog.components)
            _NavigationItem(
              label: component.label,
              selected: selectedId == component.id,
              onTap: () => onSelected(component.id),
            ),
          const Spacer(),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            '${capture.manifest.files.length} verified files',
            style: const TextStyle(color: Color(0xFF667085), fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            'Protocol ${capture.manifest.producer.mixProtocolVersion}',
            style: const TextStyle(color: Color(0xFF667085), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFE9EDFC) : Colors.transparent,
      borderRadius: .circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(8),
        child: Padding(
          padding: const .symmetric(vertical: 10, horizontal: 10),
          child: Row(
            spacing: 9,
            children: [
              Icon(
                Icons.smart_button_outlined,
                size: 18,
                color: selected
                    ? const Color(0xFF4968DB)
                    : const Color(0xFF667085),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? .w700 : .w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _CanvasMode { oracle, reconstructed }

class _CaptureCanvas extends StatefulWidget {
  const _CaptureCanvas({
    required this.capture,
    required this.component,
    required this.themeId,
    required this.metadata,
    required this.onThemeChanged,
  });

  final LoadedCapture capture;
  final CapturedComponent component;
  final String themeId;
  final CapturedAtlasMetadata metadata;
  final ValueChanged<String> onThemeChanged;

  @override
  State<_CaptureCanvas> createState() => _CaptureCanvasState();
}

class _CaptureCanvasState extends State<_CaptureCanvas> {
  _CanvasMode _mode = .oracle;
  String _stateId = 'default';
  Map<String, String> _axes = const {};

  PortableComponentDocument? get _document {
    for (final document in widget.capture.componentDocuments) {
      if (document.id == widget.component.id) return document;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _resetSelection();
  }

  void _resetSelection() {
    final document = _document;
    if (document == null) {
      _stateId = 'default';
      _axes = const {};

      return;
    }
    final recipe = document.recipes.first;
    _axes = {
      for (final entry in recipe.properties.entries)
        entry.key: entry.value! as String,
    };
    _stateId = document.states.containsKey('default')
        ? 'default'
        : document.states.keys.first;
  }

  PortableComponentRecipe _selectedRecipe(PortableComponentDocument document) {
    return document.recipes.firstWhere(
      (recipe) => recipe.properties.entries.every(
        (entry) => _axes[entry.key] == entry.value,
      ),
      orElse: () => document.recipes.first,
    );
  }

  void _selectAxis(
    PortableComponentDocument document,
    String axis,
    String value,
  ) {
    final recipe = document.recipes.firstWhere(
      (candidate) => candidate.properties[axis] == value,
    );
    setState(() {
      _axes = {
        for (final entry in recipe.properties.entries)
          entry.key: entry.value! as String,
      };
    });
  }

  @override
  void didUpdateWidget(covariant _CaptureCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.capture != widget.capture ||
        oldWidget.component.id != widget.component.id) {
      _mode = .oracle;
      _resetSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final capture = widget.capture;
    final component = widget.component;
    final themeId = widget.themeId;
    final metadata = widget.metadata;
    final asset = component.assets[themeId]!;
    final theme = capture.catalog.themes.firstWhere(
      (item) => item.id == themeId,
    );
    final dark = theme.brightness == 'dark';
    final document = _document;
    final recipe = document == null ? null : _selectedRecipe(document);

    return Container(
      padding: const .fromLTRB(20, 18, 20, 20),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Color(0xFFDDE2EC)),
          left: BorderSide(color: Color(0xFFDDE2EC)),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: .start,
                spacing: 3,
                children: [
                  Text(
                    component.label,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: .w700),
                  ),
                  Text(
                    '${metadata.rowCount} rows × ${metadata.columnCount} states',
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SegmentedButton<String>(
                key: const ValueKey('theme-switcher'),
                segments: [
                  for (final item in capture.catalog.themes)
                    ButtonSegment(
                      value: item.id,
                      icon: Icon(
                        item.brightness == 'dark'
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        size: 16,
                      ),
                      label: Text(item.label),
                    ),
                ],
                selected: {themeId},
                onSelectionChanged: (values) =>
                    widget.onThemeChanged(values.single),
                showSelectedIcon: false,
              ),
            ],
          ),
          if (document != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: .center,
              children: [
                SegmentedButton<_CanvasMode>(
                  key: const ValueKey('canvas-mode-switcher'),
                  segments: const [
                    ButtonSegment(
                      value: .oracle,
                      icon: Icon(Icons.image_outlined, size: 16),
                      label: Text('Oracle'),
                    ),
                    ButtonSegment(
                      value: .reconstructed,
                      icon: Icon(Icons.widgets_outlined, size: 16),
                      label: Text('Reconstructed'),
                    ),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (values) {
                    setState(() => _mode = values.single);
                  },
                  showSelectedIcon: false,
                ),
                if (_mode == .reconstructed) ...[
                  for (final property in document.properties.values)
                    if (property.kind == .enumeration)
                      _CompactSelector(
                        label: property.id,
                        value: _axes[property.id]!,
                        values: {
                          for (final candidate in document.recipes)
                            candidate.properties[property.id]! as String,
                        }.toList(),
                        onChanged: (value) =>
                            _selectAxis(document, property.id, value),
                      ),
                  _CompactSelector(
                    key: const ValueKey('component-state-selector'),
                    label: 'state',
                    value: _stateId,
                    values: document.states.keys.toList(),
                    onChanged: (value) => setState(() => _stateId = value),
                  ),
                ],
              ],
            ),
          ],
          const SizedBox(height: 15),
          Expanded(
            child: ClipRRect(
              borderRadius: .circular(11),
              child: Container(
                key: const ValueKey('capture-canvas'),
                color: dark ? const Color(0xFF17191D) : const Color(0xFFFFFFFF),
                width: .infinity,
                child: _mode == .oracle || document == null
                    ? InteractiveViewer(
                        maxScale: 4,
                        minScale: 0.6,
                        child: Padding(
                          padding: const .all(16),
                          child: Image.memory(
                            capture.file(asset.imagePath),
                            key: ValueKey('artifact-image-$themeId'),
                            semanticLabel:
                                '${component.label} ${theme.label} static capture',
                            fit: .contain,
                            gaplessPlayback: true,
                          ),
                        ),
                      )
                    : Center(
                        child: PortableComponentRenderer(
                          capture: capture,
                          component: document,
                          selection: PortableComponentSelection(
                            recipeId: recipe!.id,
                            stateId: _stateId,
                            themeId: themeId,
                            properties: const {'label': 'Button'},
                          ),
                          onActivate: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Local preview activation'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            spacing: 6,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 14,
                color: Color(0xFF667085),
              ),
              Text(
                _mode == .oracle || document == null
                    ? 'Static PNG · hash verified · ${asset.imagePath}'
                    : 'Portable JSON · strict decoded · no Remix runtime',
                style: const TextStyle(color: Color(0xFF667085), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactSelector extends StatelessWidget {
  const _CompactSelector({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: .all(color: const Color(0xFFD8DDE8)),
        borderRadius: .circular(8),
      ),
      height: 38,
      child: Row(
        mainAxisSize: .min,
        spacing: 7,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF8A93A5),
              fontSize: 9,
              fontWeight: .w700,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: [
                for (final item in values)
                  DropdownMenuItem(value: item, child: Text(item)),
              ],
              value: value,
              onChanged: (next) {
                if (next != null) onChanged(next);
              },
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _CaptureHealth extends StatelessWidget {
  const _CaptureHealth({required this.capture});

  final LoadedCapture capture;

  @override
  Widget build(BuildContext context) {
    final coverage = capture.protocolCoverage;
    final diagnostics = coverage.diagnostics.toList();

    return Container(
      color: Colors.white,
      child: ListView(
        padding: const .all(20),
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Text(
                  'Capture health',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: .w700),
                  overflow: .ellipsis,
                  maxLines: 1,
                ),
              ),
              const _StatusBadge(label: 'Trusted', positive: true),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Transport and protocol evidence',
            style: TextStyle(color: Color(0xFF667085), fontSize: 12),
          ),
          const SizedBox(height: 20),
          _HealthRow(
            icon: Icons.verified_outlined,
            label: 'Manifest integrity',
            value: '${capture.manifest.files.length} files verified',
            positive: true,
          ),
          _HealthRow(
            icon: Icons.palette_outlined,
            label: 'Theme documents',
            value: capture.themeTokenCounts.entries
                .map((entry) => '${entry.key} ${entry.value}')
                .join(' · '),
            positive: true,
          ),
          _HealthRow(
            icon: Icons.data_object,
            label: 'Built-in style fixtures',
            value: '${capture.validatedStyleDocumentCount} strict decoded',
            positive: true,
          ),
          if (capture.componentDocuments.isNotEmpty)
            _HealthRow(
              icon: Icons.account_tree_outlined,
              label: 'Portable component contract',
              value: _componentContractSummary(capture),
              positive: true,
            ),
          _HealthRow(
            icon: Icons.extension_outlined,
            label: 'Declared style coverage',
            value:
                '${coverage.supportedCount} supported · '
                '${coverage.unsupportedCount} unsupported',
            positive: coverage.unsupportedCount == 0,
            informational: coverage.unsupportedCount > 0,
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 14),
          const Text(
            'PROTOCOL DIAGNOSTICS',
            style: TextStyle(
              color: Color(0xFF8A93A5),
              fontSize: 9,
              fontWeight: .w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          if (diagnostics.isEmpty)
            const Text(
              'No protocol warnings or errors.',
              style: TextStyle(fontSize: 12),
            )
          else
            for (final diagnostic in diagnostics)
              _DiagnosticCard(diagnostic: diagnostic),
          const SizedBox(height: 14),
          Container(
            padding: const .all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E8),
              border: .all(color: const Color(0xFFF1DEAA)),
              borderRadius: .circular(9),
            ),
            child: const Text(
              'Unsupported custom styles are declared limitations. The '
              'verified PNG remains usable; Atlas does not execute the style.',
              style: TextStyle(
                color: Color(0xFF725D24),
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _componentContractSummary(LoadedCapture capture) {
  final documents = capture.componentDocuments.length;
  final recipes = capture.componentDocuments.fold<int>(
    0,
    (count, component) => count + component.recipes.length,
  );

  return '$documents ${documents == 1 ? 'document' : 'documents'} · '
      '$recipes ${recipes == 1 ? 'recipe' : 'recipes'}';
}

class _HealthRow extends StatelessWidget {
  const _HealthRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.positive,
    this.informational = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool positive;
  final bool informational;

  @override
  Widget build(BuildContext context) {
    final color = positive
        ? const Color(0xFF20895B)
        : informational
        ? const Color(0xFFB27714)
        : const Color(0xFFCC3D4A);

    return Padding(
      padding: const .only(bottom: 15),
      child: Row(
        crossAxisAlignment: .start,
        spacing: 10,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.09),
              borderRadius: .circular(8),
            ),
            width: 30,
            height: 30,
            child: Icon(icon, size: 16, color: color),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 3,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, fontWeight: .w600),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.positive});

  final String label;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final color = positive ? const Color(0xFF20895B) : const Color(0xFFB27714);

    return Container(
      padding: const .symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: .circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: .w700),
      ),
    );
  }
}

class _DiagnosticCard extends StatelessWidget {
  const _DiagnosticCard({required this.diagnostic});

  final ProtocolDiagnostic diagnostic;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('diagnostic-${diagnostic.probeId}'),
      padding: const .all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        border: .all(color: const Color(0xFFF1DEAA)),
        borderRadius: .circular(9),
      ),
      margin: const .only(bottom: 9),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  diagnostic.probeId,
                  style: const TextStyle(fontSize: 11, fontWeight: .w700),
                ),
              ),
              Text(
                diagnostic.code,
                style: const TextStyle(
                  color: Color(0xFF8A6C24),
                  fontSize: 9,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            diagnostic.message,
            style: const TextStyle(fontSize: 11, height: 1.35),
          ),
          if (diagnostic.path.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              diagnostic.path,
              style: const TextStyle(
                color: Color(0xFF8A6C24),
                fontSize: 9,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
