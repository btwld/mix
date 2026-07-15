import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mix_atlas_app/src/app.dart';
import 'package:mix_atlas_app/src/app_controller.dart';
import 'package:mix_atlas_app/src/data/capture_gateway.dart';

void main() {
  final root = Platform.environment['MIX_ATLAS_LIVE_LOCAL_ROOT'];
  final manifestPath =
      Platform.environment['MIX_ATLAS_LIVE_MANIFEST'] ??
      'atlas/fortal/capture.json';

  testWidgets(
    'loads a generated Fortal capture through the local app path',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final controller = AtlasAppController(
        gateway: DefaultAtlasCaptureGateway(),
      );

      await tester.runAsync(
        () => controller.openLocal(
          directory: Directory(root!),
          manifestPath: manifestPath,
        ),
      );

      expect(controller.loadError, isNull);
      expect(controller.loadState, AtlasLoadState.ready);
      expect(controller.hasCompatibleComparison, true);
      final capture = controller.current!;
      expect(capture.manifest.id, 'fortal');
      expect(capture.catalog.components, hasLength(21));
      expect(capture.files, hasLength(110));
      expect(capture.atlasMetadata, hasLength(42));
      expect(capture.componentDocuments, hasLength(21));
      expect(capture.validatedStyleDocumentCount, 589);
      expect(controller.reviewContext?.componentId, 'accordion');
      expect(controller.reviewContext?.recipeId, isNotNull);
      expect(controller.reviewContext?.stateId, isNotNull);
      expect(controller.reviewContext?.slotId, isNotNull);

      controller.selectComponent('avatar');
      controller.selectTheme('dark');
      await tester.pumpWidget(AtlasApp(controller: controller));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('21 captured components'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('cell-soft-size1-default')),
        findsOneWidget,
      );

      controller.selectComponent('button');
      await tester.pump();
      expect(controller.reviewContext?.recipeId, isNotNull);
      expect(controller.reviewContext?.stateId, isNotNull);
      expect(controller.reviewContext?.slotId, isNotNull);
      expect(
        find.byKey(const ValueKey('cell-solid-size1-default')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
    skip: root == null,
  );
}
