import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:mix_atlas_app/src/app_controller.dart';
import 'package:mix_atlas_app/src/data/capture_gateway.dart';

const _defaultRepository = 'btwld/remix';
const _defaultManifestPath = 'atlas/fortal/capture.json';

void main() {
  final repository =
      Platform.environment['MIX_ATLAS_LIVE_REPOSITORY'] ?? _defaultRepository;
  final manifestPath =
      Platform.environment['MIX_ATLAS_LIVE_MANIFEST'] ?? _defaultManifestPath;
  final ref = Platform.environment['MIX_ATLAS_LIVE_REF'];
  final expectedSha = Platform.environment['MIX_ATLAS_LIVE_SHA'];
  final pullNumber = RegExp(
    r'^(?:#|pull/)?([1-9][0-9]*)$',
  ).firstMatch(ref ?? '')?.group(1);
  final expectedRequestedRef = pullNumber == null ? ref : 'pull/$pullNumber';
  final missingBaselineRef =
      Platform.environment['MIX_ATLAS_LIVE_MISSING_BASELINE_REF'];
  final skipReason = ref == null || expectedSha == null
      ? 'Set MIX_ATLAS_LIVE_REF and MIX_ATLAS_LIVE_SHA to run the live '
            'public-GitHub verification.'
      : false;

  test('loads a v2 capture by mutable ref and immutable SHA', () async {
    final gateway = DefaultAtlasCaptureGateway();

    final byRef = await gateway.loadGitHub(
      repository: repository,
      ref: ref!,
      manifestPath: manifestPath,
    );
    final bySha = await gateway.loadGitHub(
      repository: byRef.receipt.repository,
      ref: expectedSha!,
      manifestPath: manifestPath,
    );

    expect(byRef.receipt.requestedRef, expectedRequestedRef);
    expect(byRef.receipt.resolvedCommit, expectedSha);
    expect(bySha.receipt.requestedRef, expectedSha);
    expect(bySha.receipt.resolvedCommit, expectedSha);
    expect(byRef.manifest.schemaVersion, 2);
    expect(byRef.files, isNotEmpty);
    expect(byRef.protocolThemes, isNotEmpty);
    expect(byRef.componentDocuments, isNotEmpty);
    expect(bySha.manifest.id, byRef.manifest.id);
    expect(bySha.files.keys, unorderedEquals(byRef.files.keys));
    for (final entry in byRef.files.entries) {
      expect(bySha.files[entry.key], entry.value, reason: entry.key);
    }
    switch (byRef.manifest.id) {
      case 'fortal':
        final fortalButton = byRef.componentDocuments.single;
        expect(byRef.files, hasLength(70));
        expect(byRef.protocolThemes, hasLength(2));
        expect(byRef.validatedStyleDocumentCount, 61);
        expect(fortalButton.id, 'button');
        expect(fortalButton.recipes, hasLength(20));
        expect(fortalButton.states, hasLength(6));
        expect(fortalButton.slots, hasLength(5));
        break;
      case 'hero-ui':
        final heroButton = byRef.componentDocuments.single;
        expect(byRef.files, hasLength(72));
        expect(byRef.protocolThemes, hasLength(2));
        expect(byRef.validatedStyleDocumentCount, 63);
        expect(heroButton.id, 'button');
        expect(heroButton.recipes, hasLength(21));
        expect(heroButton.states, hasLength(6));
        expect(heroButton.slots, hasLength(5));
        break;
    }
  }, skip: skipReason);

  test(
    'opens the live capture through the standalone app controller',
    () async {
      final controller = AtlasAppController(
        gateway: DefaultAtlasCaptureGateway(),
      );

      await controller.openGitHub(
        repository: repository,
        currentRef: ref!,
        baselineRef: ref,
        manifestPath: manifestPath,
      );

      expect(controller.loadState, AtlasLoadState.ready);
      expect(controller.loadError, isNull);
      expect(controller.hasCompatibleComparison, true);
      expect(controller.hasChanges, false);
      expect(controller.current?.receipt.resolvedCommit, expectedSha);
      expect(controller.reviewContext?.repository, repository);
      expect(controller.reviewContext?.baselineRef, ref);
      expect(controller.reviewContext?.currentRef, ref);
      expect(controller.reviewContext?.componentId, 'button');
      expect(controller.reviewContext?.recipeId, isNotNull);
      expect(controller.reviewContext?.stateId, isNotNull);
      expect(controller.reviewContext?.themeId, isNotNull);
      expect(controller.reviewContext?.slotId, isNotNull);
    },
    skip: skipReason,
  );

  test(
    'keeps a live current ref open when its baseline has no capture',
    () async {
      final controller = AtlasAppController(
        gateway: DefaultAtlasCaptureGateway(),
      );

      await controller.openGitHub(
        repository: repository,
        currentRef: ref!,
        baselineRef: missingBaselineRef!,
        manifestPath: manifestPath,
      );

      expect(controller.loadState, AtlasLoadState.ready);
      expect(controller.loadError, isNull);
      expect(controller.current?.receipt.resolvedCommit, expectedSha);
      expect(controller.baseline, isNull);
      expect(controller.baselineLoadError, isNotNull);
      expect(controller.hasCompatibleComparison, false);
      expect(controller.reviewContext?.baselineRef, missingBaselineRef);
      expect(controller.reviewContext?.currentRef, ref);
    },
    skip: missingBaselineRef == null
        ? 'Set MIX_ATLAS_LIVE_MISSING_BASELINE_REF to run the current-only '
              'public-GitHub verification.'
        : skipReason,
  );
}
