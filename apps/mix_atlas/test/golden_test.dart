import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas/golden.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

import 'package:mix_atlas_app/src/app.dart';
import 'package:mix_atlas_app/src/app_controller.dart';
import 'package:mix_atlas_app/src/data/capture_gateway.dart';
import 'package:mix_atlas_app/src/models/destination.dart';

void main() {
  late AtlasCapture baseline;
  late AtlasCapture changed;

  setUpAll(() async {
    await loadAtlasFonts();
    baseline = await _loadFixture('button_baseline');
    changed = await _loadFixture('button_changed');
  });

  for (final destination in AtlasDestination.values) {
    testWidgets('${destination.name} canonical desktop golden', (tester) async {
      if (!AtlasGoldens.platforms.contains(Platform.operatingSystem)) {
        markTestSkipped(
          'Mix Atlas app goldens are generated on '
          '${AtlasGoldens.platforms}; rendering differs on '
          '${Platform.operatingSystem}.',
        );

        return;
      }

      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      tester.binding.platformDispatcher.defaultRouteNameTestValue =
          '/${destination.name}';
      addTearDown(
        tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
      );
      final controller = AtlasAppController(
        gateway: _GoldenGateway(baseline: baseline, changed: changed),
      );
      await controller.openGitHub(
        repository: 'btwld/remix',
        currentRef: 'feature/button-label',
      );
      if (destination == AtlasDestination.inspect ||
          destination == AtlasDestination.tokenUsage) {
        final evidence = controller.currentIndex!.propertyEvidence.firstWhere(
          (item) =>
              item.themeId == 'light' &&
              item.slotId == 'label' &&
              item.property == 'style.color',
        );
        controller.selectProperty(evidence);
      }
      await tester.pumpWidget(
        RepaintBoundary(
          key: const ValueKey('golden-root'),
          child: ColoredBox(
            color: const Color(0xFFF5F6F8),
            child: AtlasApp(controller: controller),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 250));

      await expectLater(
        find.byKey(const ValueKey('golden-root')),
        matchesGoldenFile('goldens/${destination.name}.png'),
      );
      expect(tester.takeException(), isNull);
    });
  }
}

final class _GoldenGateway implements AtlasCaptureGateway {
  const _GoldenGateway({required this.baseline, required this.changed});

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
