import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

import 'package:mix_atlas_app/src/app.dart';
import 'package:mix_atlas_app/src/app_controller.dart';
import 'package:mix_atlas_app/src/data/capture_gateway.dart';
import 'package:mix_atlas_app/src/models/destination.dart';

void main() {
  late AtlasCapture baseline;
  late AtlasCapture changed;

  setUpAll(() async {
    baseline = await _loadFixture('button_baseline');
    changed = await _loadFixture('button_changed');
  });

  testWidgets('starts with truthful local and GitHub source choices', (
    tester,
  ) async {
    final controller = AtlasAppController(
      gateway: _FixtureGateway(baseline: baseline, changed: changed),
    );

    await tester.pumpWidget(AtlasApp(controller: controller));

    expect(find.text('Open a design-system capture'), findsOneWidget);
    expect(find.byKey(const ValueKey('open-github')), findsOneWidget);
    expect(find.byKey(const ValueKey('open-folder')), findsOneWidget);
    expect(find.textContaining('never compiles'), findsOneWidget);
    _expectSourceFields(
      tester,
      repository: 'btwld/remix',
      baselineRef: 'main',
      currentRef: '#68',
      manifestPath: 'atlas/fortal/capture.json',
    );
  });

  testWidgets('can cancel capture validation and retain the source fields', (
    tester,
  ) async {
    final gateway = _PendingGateway();
    final controller = AtlasAppController(gateway: gateway);
    final load = controller.openGitHub(
      repository: 'example/design_system',
      baselineRef: 'release/next',
      currentRef: '#42',
      manifestPath: 'atlas/example/capture.json',
    );

    await tester.pumpWidget(AtlasApp(controller: controller));

    expect(
      find.byKey(const ValueKey('capture-loading-skeleton')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Validating capture files and protocol documents'),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('back-to-source-selection')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('back-to-source-selection')));
    await tester.pumpAndSettle();

    expect(controller.loadState, AtlasLoadState.empty);
    expect(find.text('Open a design-system capture'), findsOneWidget);
    _expectSourceFields(
      tester,
      repository: 'example/design_system',
      baselineRef: 'release/next',
      currentRef: '#42',
      manifestPath: 'atlas/example/capture.json',
    );

    gateway.capture.complete(baseline);
    await load;
    await tester.pump();

    expect(controller.loadState, AtlasLoadState.empty);
    expect(controller.current, isNull);
  });

  testWidgets('returns from a loaded capture without resetting its source', (
    tester,
  ) async {
    final controller = AtlasAppController(
      gateway: _FixtureGateway(baseline: baseline, changed: changed),
    );
    await controller.openGitHub(
      repository: 'example/design_system',
      baselineRef: 'release/next',
      currentRef: '#42',
      manifestPath: 'atlas/example/capture.json',
    );

    await tester.pumpWidget(AtlasApp(controller: controller));

    expect(
      find.byKey(const ValueKey('back-to-source-selection')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('back-to-source-selection')));
    await tester.pumpAndSettle();

    expect(controller.loadState, AtlasLoadState.empty);
    expect(controller.current, isNull);
    expect(find.text('Open a design-system capture'), findsOneWidget);
    _expectSourceFields(
      tester,
      repository: 'example/design_system',
      baselineRef: 'release/next',
      currentRef: '#42',
      manifestPath: 'atlas/example/capture.json',
    );
  });

  testWidgets('opens a selected PR against its actual base branch', (
    tester,
  ) async {
    final gateway = _SourceFormGateway(
      baseline: baseline,
      current: changed,
      pullRequestList: AtlasGitHubPullRequestList(
        pullRequests: const [
          AtlasGitHubPullRequest(
            number: 42,
            title: 'Design-system update',
            url: 'https://github.com/example/design_system/pull/42',
            baseRef: 'release/next',
            headRepository: 'contributor/design_system',
            headSha: '4242424242424242424242424242424242424242',
          ),
        ],
        rateLimit: null,
      ),
    );
    final controller = AtlasAppController(gateway: gateway);

    await tester.pumpWidget(AtlasApp(controller: controller));
    await tester.tap(find.byKey(const ValueKey('open-pull-requests')));
    await tester.pumpAndSettle();
    final pullRequest = find.byKey(const ValueKey('pull-request-42'));
    await tester.ensureVisible(pullRequest);
    await tester.tap(pullRequest);
    await tester.pumpAndSettle();

    expect(gateway.githubRefs, ['release/next', '#42']);
    expect(controller.reviewContext?.baselineRef, 'release/next');
    expect(controller.reviewContext?.currentRef, '#42');
  });

  testWidgets('opens an explicitly selected baseline revision', (tester) async {
    final gateway = _SourceFormGateway(baseline: baseline, current: changed);
    final controller = AtlasAppController(gateway: gateway);

    await tester.pumpWidget(AtlasApp(controller: controller));
    await tester.enterText(
      find.byKey(const ValueKey('baseline-ref-field')),
      'release/next',
    );
    await tester.enterText(
      find.byKey(const ValueKey('current-ref-field')),
      'feature/button',
    );
    await tester.tap(find.byKey(const ValueKey('open-github')));
    await tester.pumpAndSettle();

    expect(gateway.githubRefs, ['release/next', 'feature/button']);
    expect(controller.reviewContext?.baselineRef, 'release/next');
    expect(controller.reviewContext?.currentRef, 'feature/button');
  });

  testWidgets('shows remaining and reset GitHub API rate-limit data', (
    tester,
  ) async {
    final gateway = _SourceFormGateway(
      baseline: baseline,
      current: changed,
      pullRequestList: AtlasGitHubPullRequestList(
        pullRequests: const [],
        rateLimit: AtlasGitHubRateLimit(
          remaining: 42,
          limit: 60,
          resetAt: DateTime.utc(2026, 7, 14, 8),
        ),
      ),
    );
    final controller = AtlasAppController(gateway: gateway);

    await tester.pumpWidget(AtlasApp(controller: controller));
    await tester.tap(find.widgetWithText(OutlinedButton, 'Open PRs'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'GitHub API · 42/60 requests remaining · resets 2026-07-14 08:00 UTC',
      ),
      findsOneWidget,
    );
  });

  testWidgets('supports keyboard traversal and activation in the source form', (
    tester,
  ) async {
    final gateway = _SourceFormGateway(baseline: baseline, current: changed);
    final controller = AtlasAppController(gateway: gateway);

    await tester.pumpWidget(AtlasApp(controller: controller));
    for (var index = 0; index < 5; index += 1) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
    }

    expect(FocusManager.instance.highlightMode, FocusHighlightMode.traditional);
    expect(FocusManager.instance.primaryFocus, isNotNull);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(controller.loadState, AtlasLoadState.ready);
    expect(gateway.githubRefs, ['main', '#68']);
  });

  testWidgets('navigates Catalog, Changes, Compare, Inspect, and Token Usage', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final controller = AtlasAppController(
      gateway: _FixtureGateway(baseline: baseline, changed: changed),
    );
    await controller.openGitHub(
      repository: 'btwld/remix',
      currentRef: 'feature',
    );

    await tester.pumpWidget(AtlasApp(controller: controller));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Button'), findsWidgets);
    expect(
      find.byKey(const ValueKey('cell-solid-size1-default')),
      findsOneWidget,
    );
    expect(find.text('6 states'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Button, solid-size1, default, light'),
      findsOneWidget,
    );
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    await tester.tap(find.text('Changes').first);
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Declared changes'), findsOneWidget);
    expect(find.textContaining('label.mix.json'), findsOneWidget);

    await tester.tap(find.text('Compare').last);
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('Compare · button'), findsOneWidget);
    expect(
      find.textContaining('Contact-sheet oracle available'),
      findsNWidgets(2),
    );

    await tester.tap(find.text('Inspect').last);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.textContaining('label · text'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('style.color'), findsWidgets);
    expect(find.text('Runtime · Not captured'), findsOneWidget);

    await tester.tap(find.text('Open Token Usage'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('fortal.accent.9'), findsOneWidget);
    expect(find.textContaining('not predicted visual impact'), findsOneWidget);
    expect(find.text('Direct'), findsWidgets);
    await tester.tap(find.byTooltip('Return to previous review'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('Inspect · Button'), findsOneWidget);
    expect(controller.reviewContext?.property, 'style.color');
    expect(controller.reviewContext?.tokenName, 'fortal.accent.9');
    expect(tester.takeException(), isNull);
  });

  testWidgets('copies a declared change summary with revision evidence', (
    tester,
  ) async {
    String? clipboardText;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          clipboardText =
              (call.arguments as Map<Object?, Object?>)['text'] as String?;
        }

        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    final controller = AtlasAppController(
      gateway: _FixtureGateway(baseline: baseline, changed: changed),
    );
    await controller.openGitHub(
      repository: 'btwld/remix',
      currentRef: 'feature/button',
    );
    controller.navigate(AtlasDestination.changes);

    await tester.pumpWidget(AtlasApp(controller: controller));
    await tester.tap(find.byTooltip('Copy change summary'));
    await tester.pump();

    expect(clipboardText, contains('Mix Atlas declared change summary'));
    expect(clipboardText, contains('btwld/remix · main → feature/button'));
    expect(clipboardText, contains('label.mix.json'));
  });

  testWidgets('keeps controls usable at a compact desktop size', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final controller = AtlasAppController(
      gateway: _FixtureGateway(baseline: baseline, changed: changed),
    );
    await controller.openGitHub(repository: 'btwld/remix', currentRef: 'main');

    await tester.pumpWidget(AtlasApp(controller: controller));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byKey(const ValueKey('component-search')), findsOneWidget);
    expect(find.text('Catalog'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows rendered evidence without a portable component document', (
    tester,
  ) async {
    final partial = _withoutPortableComponents(baseline);
    final controller = AtlasAppController(
      gateway: _FixtureGateway(baseline: partial, changed: partial),
    );
    await controller.openGitHub(repository: 'btwld/remix', currentRef: 'main');

    await tester.pumpWidget(AtlasApp(controller: controller));

    expect(find.text('Rendered evidence'), findsOneWidget);
    expect(find.text('Portable inspection not captured'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('rendered-oracle-button-light')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('clears portable selection when opening rendered-only evidence', (
    tester,
  ) async {
    final mixed = _withRenderedOnlyAvatar(baseline);
    final controller = AtlasAppController(
      gateway: _FixtureGateway(baseline: mixed, changed: mixed),
    );
    await controller.openGitHub(repository: 'btwld/remix', currentRef: 'main');

    await tester.pumpWidget(AtlasApp(controller: controller));
    expect(controller.reviewContext?.componentId, 'button');
    expect(controller.reviewContext?.recipeId, isNotNull);

    await tester.tap(find.byKey(const ValueKey('component-avatar')));
    await tester.pump();

    expect(controller.reviewContext?.componentId, 'avatar');
    expect(controller.reviewContext?.recipeId, isNull);
    expect(controller.reviewContext?.stateId, isNull);
    expect(controller.reviewContext?.slotId, isNull);
    expect(
      find.byKey(const ValueKey('rendered-oracle-avatar-light')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('component-button')));
    await tester.pump();
    expect(controller.reviewContext?.recipeId, isNotNull);
    expect(
      find.byKey(const ValueKey('cell-solid-size1-default')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps current review available when main has no capture', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final controller = AtlasAppController(
      gateway: _MissingBaselineGateway(currentCapture: changed),
    );
    await controller.openGitHub(
      repository: 'btwld/remix',
      currentRef: 'feature/first-capture',
    );

    await tester.pumpWidget(AtlasApp(controller: controller));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Button'), findsWidgets);
    expect(find.text('Baseline unavailable'), findsOneWidget);
    expect(
      find.textContaining('Catalog and Inspect remain available'),
      findsOneWidget,
    );
    final changes = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Changes'),
    );
    expect(changes.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('guards a comparison route when the baseline is unavailable', (
    tester,
  ) async {
    final controller = AtlasAppController(
      gateway: _MissingBaselineGateway(currentCapture: changed),
    );
    await controller.openGitHub(
      repository: 'btwld/remix',
      currentRef: 'feature/first-capture',
    );
    controller.navigate(AtlasDestination.changes);

    await tester.pumpWidget(AtlasApp(controller: controller));

    expect(find.text('Comparison unavailable'), findsOneWidget);
    expect(
      find.text(
        'Changes require the main baseline capture. Catalog and Inspect remain available for the current revision.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  final failureTitles = <AtlasCaptureFailureKind, String>{
    AtlasCaptureFailureKind.network: 'Could not reach GitHub',
    AtlasCaptureFailureKind.rateLimited: 'GitHub rate limit reached',
    AtlasCaptureFailureKind.notFound: 'Capture not found',
    AtlasCaptureFailureKind.malformedJson: 'Capture JSON is malformed',
    AtlasCaptureFailureKind.unsafePath: 'Capture contains an unsafe file path',
    AtlasCaptureFailureKind.integrity: 'Capture integrity check failed',
    AtlasCaptureFailureKind.unsupportedSchema: 'Capture schema is unsupported',
  };
  for (final failure in failureTitles.entries) {
    testWidgets('shows a precise ${failure.key.name} source failure', (
      tester,
    ) async {
      final controller = AtlasAppController(
        gateway: _ErrorGateway(failure.key),
      );
      await controller.openGitHub(
        repository: 'btwld/remix',
        currentRef: 'feature',
      );

      await tester.pumpWidget(AtlasApp(controller: controller));

      expect(find.text(failure.value), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.textContaining('failure details'), findsOneWidget);
    });
  }
}

void _expectSourceFields(
  WidgetTester tester, {
  required String repository,
  required String baselineRef,
  required String currentRef,
  required String manifestPath,
}) {
  String value(String key) =>
      tester.widget<TextField>(find.byKey(ValueKey(key))).controller!.text;

  expect(value('repository-field'), repository);
  expect(value('baseline-ref-field'), baselineRef);
  expect(value('current-ref-field'), currentRef);
  expect(value('manifest-field'), manifestPath);
}

final class _FixtureGateway implements AtlasCaptureGateway {
  const _FixtureGateway({required this.baseline, required this.changed});

  final AtlasCapture baseline;
  final AtlasCapture changed;

  @override
  Future<AtlasCapture> loadGitHub({
    required String repository,
    required String ref,
    required String manifestPath,
  }) async => ref == 'main' ? baseline : changed;

  @override
  Future<AtlasCapture> loadLocal({
    required Directory directory,
    required String manifestPath,
  }) async => baseline;

  @override
  Future<AtlasGitHubPullRequestList> listOpenPullRequests(
    String repository,
  ) async =>
      AtlasGitHubPullRequestList(pullRequests: const [], rateLimit: null);
}

final class _PendingGateway implements AtlasCaptureGateway {
  final Completer<AtlasCapture> capture = Completer();

  @override
  Future<AtlasCapture> loadGitHub({
    required String repository,
    required String ref,
    required String manifestPath,
  }) => capture.future;

  @override
  Future<AtlasCapture> loadLocal({
    required Directory directory,
    required String manifestPath,
  }) => capture.future;

  @override
  Future<AtlasGitHubPullRequestList> listOpenPullRequests(
    String repository,
  ) async =>
      AtlasGitHubPullRequestList(pullRequests: const [], rateLimit: null);
}

final class _SourceFormGateway implements AtlasCaptureGateway {
  _SourceFormGateway({
    required this.baseline,
    required this.current,
    AtlasGitHubPullRequestList? pullRequestList,
  }) : pullRequestList =
           pullRequestList ??
           AtlasGitHubPullRequestList(pullRequests: const [], rateLimit: null);

  final AtlasCapture baseline;
  final AtlasCapture current;
  final AtlasGitHubPullRequestList pullRequestList;
  final List<String> githubRefs = [];

  @override
  Future<AtlasCapture> loadGitHub({
    required String repository,
    required String ref,
    required String manifestPath,
  }) async {
    githubRefs.add(ref);

    return ref.startsWith('release') ? baseline : current;
  }

  @override
  Future<AtlasCapture> loadLocal({
    required Directory directory,
    required String manifestPath,
  }) async => current;

  @override
  Future<AtlasGitHubPullRequestList> listOpenPullRequests(
    String repository,
  ) async => pullRequestList;
}

final class _ErrorGateway implements AtlasCaptureGateway {
  const _ErrorGateway(this.kind);

  final AtlasCaptureFailureKind kind;

  @override
  Future<AtlasCapture> loadGitHub({
    required String repository,
    required String ref,
    required String manifestPath,
  }) async => throw AtlasCaptureException(
    kind,
    'Specific ${kind.name} failure details.',
  );

  @override
  Future<AtlasCapture> loadLocal({
    required Directory directory,
    required String manifestPath,
  }) async => throw AtlasCaptureException(
    kind,
    'Specific ${kind.name} failure details.',
  );

  @override
  Future<AtlasGitHubPullRequestList> listOpenPullRequests(
    String repository,
  ) async => throw AtlasCaptureException(
    kind,
    'Specific ${kind.name} failure details.',
  );
}

final class _MissingBaselineGateway implements AtlasCaptureGateway {
  const _MissingBaselineGateway({required this.currentCapture});

  final AtlasCapture currentCapture;

  @override
  Future<AtlasCapture> loadGitHub({
    required String repository,
    required String ref,
    required String manifestPath,
  }) async {
    if (ref == 'main') {
      throw const AtlasCaptureException(
        AtlasCaptureFailureKind.notFound,
        'The baseline manifest does not exist.',
      );
    }

    return currentCapture;
  }

  @override
  Future<AtlasCapture> loadLocal({
    required Directory directory,
    required String manifestPath,
  }) async => currentCapture;

  @override
  Future<AtlasGitHubPullRequestList> listOpenPullRequests(
    String repository,
  ) async =>
      AtlasGitHubPullRequestList(pullRequests: const [], rateLimit: null);
}

Future<AtlasCapture> _loadFixture(String fixture) {
  final directory = Directory(
    '${Directory.current.parent.parent.path}/packages/'
    'mix_atlas_capture/test/fixtures/$fixture',
  );

  return AtlasCaptureReader(source: AtlasDirectorySource(directory)).load(
    const AtlasRepositoryRequest(
      repository: 'fixture',
      ref: 'fixture',
      manifestPath: 'capture.json',
    ),
  );
}

AtlasCapture _withoutPortableComponents(AtlasCapture source) => AtlasCapture(
  receipt: source.receipt,
  manifest: source.manifest,
  catalog: source.catalog,
  protocolCoverage: source.protocolCoverage,
  files: source.files,
  themeTokenCounts: source.themeTokenCounts,
  protocolThemes: source.protocolThemes,
  componentDocuments: const [],
  styleDocuments: source.styleDocuments,
  atlasMetadata: source.atlasMetadata,
  validatedStyleDocumentCount: source.validatedStyleDocumentCount,
);

AtlasCapture _withRenderedOnlyAvatar(AtlasCapture source) {
  final button = source.catalog.components.single;
  final avatar = AtlasCatalogComponent(
    id: 'avatar',
    label: 'Avatar',
    assets: {
      for (final entry in button.assets.entries)
        entry.key: AtlasComponentAsset(
          themeId: entry.value.themeId,
          imagePath: entry.value.imagePath,
          metadataPath: entry.value.metadataPath,
        ),
    },
  );

  return AtlasCapture(
    receipt: source.receipt,
    manifest: source.manifest,
    catalog: AtlasCatalog(
      id: source.catalog.id,
      label: source.catalog.label,
      themes: source.catalog.themes,
      components: [button, avatar],
    ),
    protocolCoverage: source.protocolCoverage,
    files: source.files,
    themeTokenCounts: source.themeTokenCounts,
    protocolThemes: source.protocolThemes,
    componentDocuments: source.componentDocuments,
    styleDocuments: source.styleDocuments,
    atlasMetadata: {
      ...source.atlasMetadata,
      for (final theme in source.catalog.themes)
        'avatar/${theme.id}': AtlasVisualOracleMetadata(
          componentId: 'avatar',
          themeId: theme.id,
          rowCount: 1,
          columnCount: 1,
        ),
    },
    validatedStyleDocumentCount: source.validatedStyleDocumentCount,
  );
}
