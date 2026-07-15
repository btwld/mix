import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas/golden.dart';

import 'package:mix_atlas_app/src/app.dart';
import 'package:mix_atlas_app/src/app_controller.dart';
import 'package:mix_atlas_app/src/data/capture_gateway.dart';
import 'package:mix_atlas_app/src/models/destination.dart';

const _defaultRepository = 'btwld/remix';
const _defaultManifestPath = 'atlas/fortal/capture.json';
const _liveTimeout = Timeout(Duration(minutes: 2));
const _fortalComponentIds = [
  'accordion',
  'avatar',
  'badge',
  'button',
  'callout',
  'card',
  'checkbox',
  'dialog',
  'divider',
  'icon-button',
  'menu',
  'progress',
  'radio',
  'select',
  'slider',
  'spinner',
  'switch',
  'tabs',
  'textfield',
  'toggle',
  'tooltip',
];

void main() {
  late HttpOverrides? previousHttpOverrides;
  setUpAll(() async {
    await loadAtlasFonts();
    previousHttpOverrides = HttpOverrides.current;
    HttpOverrides.global = _LiveHttpOverrides();
  });
  tearDownAll(() => HttpOverrides.global = previousHttpOverrides);

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

  test(
    'loads a v2 capture by mutable ref and immutable SHA',
    () async {
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
          expect(
            byRef.catalog.components.map((component) => component.id),
            _fortalComponentIds,
          );
          expect(
            byRef.componentDocuments.map((component) => component.id),
            _fortalComponentIds,
          );
          expect(byRef.files, hasLength(110));
          expect(byRef.atlasMetadata, hasLength(42));
          expect(byRef.protocolThemes, hasLength(2));
          expect(byRef.componentDocuments, hasLength(21));
          expect(
            byRef.componentDocuments.fold<int>(
              0,
              (total, component) => total + component.recipes.length,
            ),
            148,
          );
          expect(
            byRef.componentDocuments.fold<int>(
              0,
              (total, component) =>
                  total + component.recipes.length * component.states.length,
            ),
            613,
          );
          expect(byRef.validatedStyleDocumentCount, 589);
          final fortalButton = byRef.componentDocuments.singleWhere(
            (component) => component.id == 'button',
          );
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
    },
    skip: skipReason,
    timeout: _liveTimeout,
  );

  testWidgets(
    'opens the live capture through the standalone app controller',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final controller = AtlasAppController(
        gateway: DefaultAtlasCaptureGateway(),
      );

      await tester.runAsync(
        () => controller.openGitHub(
          repository: repository,
          currentRef: ref!,
          baselineRef: ref,
          manifestPath: manifestPath,
        ),
      );

      expect(controller.loadState, AtlasLoadState.ready);
      expect(controller.loadError, isNull);
      expect(controller.hasCompatibleComparison, true);
      expect(controller.hasChanges, false);
      expect(controller.current?.receipt.resolvedCommit, expectedSha);
      expect(controller.reviewContext?.repository, repository);
      expect(controller.reviewContext?.baselineRef, ref);
      expect(controller.reviewContext?.currentRef, ref);
      final capture = controller.current!;
      if (capture.manifest.id == 'fortal') {
        expect(controller.reviewContext?.componentId, 'accordion');
        expect(controller.reviewContext?.recipeId, isNotNull);
        expect(controller.reviewContext?.stateId, isNotNull);
        expect(controller.reviewContext?.slotId, isNotNull);

        controller.selectComponent('button');
        expect(controller.reviewContext?.recipeId, isNotNull);
        expect(controller.reviewContext?.stateId, isNotNull);
        expect(controller.reviewContext?.slotId, isNotNull);

        controller.selectComponent('avatar');
        expect(controller.reviewContext?.recipeId, isNotNull);
        expect(controller.reviewContext?.stateId, isNotNull);
        expect(controller.reviewContext?.slotId, isNotNull);

        await tester.pumpWidget(AtlasApp(controller: controller));
        await tester.pump(const Duration(milliseconds: 250));
        for (final component in capture.componentDocuments) {
          controller.selectComponent(component.id);
          final recipe = component.recipes.last;
          final state = component.states.values.last;
          controller.selectCell(recipeId: recipe.id, stateId: state.id);
          for (final themeId in const ['light', 'dark']) {
            controller.selectTheme(themeId);
            await tester.pump(const Duration(milliseconds: 250));
            expect(
              find.byKey(ValueKey('cell-${recipe.id}-${state.id}')),
              findsOneWidget,
              reason: '${component.id}/$themeId',
            );
            expect(
              tester.takeException(),
              isNull,
              reason: '${component.id}/$themeId',
            );
          }
        }

        controller.selectComponent('button');
        controller.selectCell(recipeId: 'solid-size1', stateId: 'default');
        controller.selectTheme('light');
        await tester.pump(const Duration(milliseconds: 250));
        await tester.tap(find.byKey(const ValueKey('oracle-action')));
        await tester.pump(const Duration(milliseconds: 250));
        expect(
          find.byKey(const ValueKey('oracle-image-button-light')),
          findsOneWidget,
        );
        await tester.tap(find.byTooltip('Close oracle'));
        await tester.pump(const Duration(milliseconds: 250));

        controller.navigate(AtlasDestination.inspect);
        await tester.pump(const Duration(milliseconds: 250));
        expect(find.text('Inspect · Button'), findsOneWidget);
        await tester.tap(find.byTooltip('Back'));
        await tester.pump(const Duration(milliseconds: 250));
        expect(controller.destination, AtlasDestination.catalog);

        controller.navigate(AtlasDestination.compare);
        await tester.pump(const Duration(milliseconds: 250));
        expect(find.text('Compare · button'), findsOneWidget);
        await tester.tap(find.byTooltip('Back'));
        await tester.pump(const Duration(milliseconds: 250));
        expect(controller.destination, AtlasDestination.catalog);
        expect(tester.takeException(), isNull);
      } else {
        expect(controller.reviewContext?.componentId, 'button');
        expect(controller.reviewContext?.recipeId, isNotNull);
        expect(controller.reviewContext?.stateId, isNotNull);
        expect(controller.reviewContext?.slotId, isNotNull);
      }
      expect(controller.reviewContext?.themeId, isNotNull);
    },
    skip: skipReason != false,
    timeout: _liveTimeout,
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
    timeout: _liveTimeout,
  );
}

final class _LiveHttpOverrides extends HttpOverrides {}
