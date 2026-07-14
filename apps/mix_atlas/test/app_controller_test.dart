import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

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

  test('loads the main baseline once when current is also main', () async {
    final gateway = _RecordingGateway(baseline: baseline, changed: changed);
    final controller = AtlasAppController(gateway: gateway);

    await controller.openGitHub(repository: 'btwld/remix', currentRef: 'main');

    expect(gateway.githubRefs, ['main']);
    expect(controller.loadState, AtlasLoadState.ready);
    expect(controller.baseline, same(controller.current));
    expect(controller.hasChanges, false);
    expect(controller.reviewContext?.baselineRef, 'main');
    expect(controller.reviewContext?.currentRef, 'main');
  });

  test('a stale asynchronous load cannot overwrite a newer source', () async {
    final gateway = _StaleGateway(localCapture: baseline);
    final controller = AtlasAppController(gateway: gateway);
    final stale = controller.openGitHub(
      repository: 'btwld/remix',
      currentRef: 'feature',
    );

    await controller.openLocal(directory: Directory('/tmp/atlas-local'));
    gateway.main.complete(baseline);
    gateway.feature.complete(changed);
    await stale;

    expect(controller.loadState, AtlasLoadState.ready);
    expect(controller.current, same(baseline));
    expect(controller.reviewContext?.repository, '/tmp/atlas-local');
    expect(controller.reviewContext?.currentRef, 'local');
  });

  test(
    'review navigation preserves exact context and selection resets evidence',
    () async {
      final controller = AtlasAppController(
        gateway: _RecordingGateway(baseline: baseline, changed: changed),
      );
      await controller.openGitHub(
        repository: 'btwld/remix',
        currentRef: 'feature',
      );
      controller.selectCell(recipeId: 'solid-size1', stateId: 'hovered');
      controller.selectTheme('dark');
      controller.selectSlot('label');
      final evidence = controller.currentIndex!.propertyEvidence.singleWhere(
        (item) =>
            item.recipeId == 'solid-size1' &&
            item.themeId == 'dark' &&
            item.slotId == 'label' &&
            item.property == 'style.color',
      );
      controller.selectProperty(evidence);
      final selected = controller.reviewContext!;

      for (final destination in [
        AtlasDestination.changes,
        AtlasDestination.compare,
        AtlasDestination.inspect,
        AtlasDestination.tokenUsage,
      ]) {
        controller.navigate(destination);
        expect(controller.reviewContext, same(selected));
      }
      expect(controller.pop(), true);
      expect(controller.destination, AtlasDestination.inspect);
      expect(controller.reviewContext, same(selected));
      expect(selected.stateId, 'hovered');
      expect(selected.themeId, 'dark');
      expect(selected.property, 'style.color');
      expect(selected.tokenName, 'fortal.accent.9');

      controller.selectCell(recipeId: 'solid-size1', stateId: 'default');
      expect(controller.reviewContext?.property, isNull);
      expect(controller.reviewContext?.tokenName, isNull);
    },
  );

  test('retry repeats the last failed load and clears the error', () async {
    final gateway = _RetryGateway(capture: baseline);
    final controller = AtlasAppController(gateway: gateway);

    await controller.openGitHub(repository: 'btwld/remix', currentRef: 'main');
    expect(controller.loadState, AtlasLoadState.error);
    expect(controller.loadError, isA<AtlasCaptureException>());

    await controller.retry();
    expect(controller.loadState, AtlasLoadState.ready);
    expect(controller.loadError, isNull);
    expect(gateway.calls, 2);
  });

  test('opens the current capture when main has no capture yet', () async {
    final controller = AtlasAppController(
      gateway: _MissingBaselineGateway(currentCapture: changed),
    );

    await controller.openGitHub(
      repository: 'btwld/remix',
      currentRef: 'feature/first-capture',
    );

    expect(controller.loadState, AtlasLoadState.ready);
    expect(controller.current, same(changed));
    expect(controller.baseline, isNull);
    expect(controller.hasCompatibleComparison, false);
    expect(controller.reviewContext?.baselineRef, 'main');
    expect(controller.reviewContext?.currentRef, 'feature/first-capture');
  });

  test(
    'a stale pull-request response cannot replace a newer repository',
    () async {
      final gateway = _StalePullRequestGateway(capture: baseline);
      final controller = AtlasAppController(gateway: gateway);

      final stale = controller.loadPullRequests('btwld/old');
      final current = controller.loadPullRequests('btwld/current');
      gateway.current.complete(
        AtlasGitHubPullRequestList(
          pullRequests: const [
            AtlasGitHubPullRequest(
              number: 22,
              title: 'Current repository',
              headRepository: 'btwld/current',
              headSha: '2222222222222222222222222222222222222222',
              url: 'https://github.com/btwld/current/pull/22',
              baseRef: 'main',
            ),
          ],
          rateLimit: const AtlasGitHubRateLimit(
            remaining: 48,
            limit: 60,
            resetAt: null,
          ),
        ),
      );
      await current;
      gateway.stale.complete(
        AtlasGitHubPullRequestList(
          pullRequests: const [
            AtlasGitHubPullRequest(
              number: 11,
              title: 'Stale repository',
              headRepository: 'btwld/old',
              headSha: '1111111111111111111111111111111111111111',
              url: 'https://github.com/btwld/old/pull/11',
              baseRef: 'main',
            ),
          ],
          rateLimit: const AtlasGitHubRateLimit(
            remaining: 12,
            limit: 60,
            resetAt: null,
          ),
        ),
      );
      await stale;

      expect(controller.pullRequests.single.number, 22);
      expect(controller.pullRequestRateLimit?.remaining, 48);
      expect(controller.pullRequestError, isNull);
    },
  );
}

final class _RecordingGateway implements AtlasCaptureGateway {
  _RecordingGateway({required this.baseline, required this.changed});

  final AtlasCapture baseline;
  final AtlasCapture changed;
  final List<String> githubRefs = [];

  @override
  Future<AtlasCapture> loadGitHub({
    required String repository,
    required String ref,
    required String manifestPath,
  }) async {
    githubRefs.add(ref);

    return ref == 'main' ? baseline : changed;
  }

  @override
  Future<AtlasCapture> loadLocal({
    required Directory directory,
    required String manifestPath,
  }) async => baseline;

  @override
  Future<AtlasGitHubPullRequestList> listOpenPullRequests(
    String repository,
  ) async => _emptyPullRequestList();
}

final class _StaleGateway implements AtlasCaptureGateway {
  _StaleGateway({required this.localCapture});

  final AtlasCapture localCapture;
  final Completer<AtlasCapture> main = Completer();
  final Completer<AtlasCapture> feature = Completer();

  @override
  Future<AtlasCapture> loadGitHub({
    required String repository,
    required String ref,
    required String manifestPath,
  }) => ref == 'main' ? main.future : feature.future;

  @override
  Future<AtlasCapture> loadLocal({
    required Directory directory,
    required String manifestPath,
  }) async => localCapture;

  @override
  Future<AtlasGitHubPullRequestList> listOpenPullRequests(
    String repository,
  ) async => _emptyPullRequestList();
}

final class _RetryGateway implements AtlasCaptureGateway {
  _RetryGateway({required this.capture});

  final AtlasCapture capture;
  var calls = 0;

  @override
  Future<AtlasCapture> loadGitHub({
    required String repository,
    required String ref,
    required String manifestPath,
  }) async {
    calls += 1;
    if (calls == 1) {
      throw const AtlasCaptureException(
        AtlasCaptureFailureKind.network,
        'The network is offline.',
      );
    }

    return capture;
  }

  @override
  Future<AtlasCapture> loadLocal({
    required Directory directory,
    required String manifestPath,
  }) async => capture;

  @override
  Future<AtlasGitHubPullRequestList> listOpenPullRequests(
    String repository,
  ) async => _emptyPullRequestList();
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
  ) async => _emptyPullRequestList();
}

final class _StalePullRequestGateway implements AtlasCaptureGateway {
  _StalePullRequestGateway({required this.capture});

  final AtlasCapture capture;
  final Completer<AtlasGitHubPullRequestList> stale = Completer();
  final Completer<AtlasGitHubPullRequestList> current = Completer();

  @override
  Future<AtlasCapture> loadGitHub({
    required String repository,
    required String ref,
    required String manifestPath,
  }) async => capture;

  @override
  Future<AtlasCapture> loadLocal({
    required Directory directory,
    required String manifestPath,
  }) async => capture;

  @override
  Future<AtlasGitHubPullRequestList> listOpenPullRequests(String repository) =>
      repository == 'btwld/old' ? stale.future : current.future;
}

AtlasGitHubPullRequestList _emptyPullRequestList() =>
    AtlasGitHubPullRequestList(
      pullRequests: [],
      rateLimit: const AtlasGitHubRateLimit(
        remaining: null,
        limit: null,
        resetAt: null,
      ),
    );

Future<AtlasCapture> _loadFixture(String name) =>
    AtlasCaptureReader(
      source: AtlasDirectorySource(
        Directory(
          '../../packages/mix_atlas_capture/test/fixtures/$name',
        ).absolute,
      ),
    ).load(
      const AtlasRepositoryRequest(
        repository: 'local',
        ref: 'local',
        manifestPath: 'capture.json',
      ),
    );
