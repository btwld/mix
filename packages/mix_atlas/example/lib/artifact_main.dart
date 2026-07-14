import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

import 'artifact_app.dart';
import 'artifacts/capture_loader.dart';
import 'sources/github_repository_source.dart';
import 'window_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  unawaited(
    windowManager.waitUntilReadyToShow(
      atlasWindowOptions,
      () => unawaited(_showWindow()),
    ),
  );

  runApp(
    ArtifactAtlasApp(
      loader: CaptureLoader(
        source: GitHubRepositorySource(http: IoArtifactHttpClient()),
      ),
      initialRequest: remoteSpikeArtifactRequest,
    ),
  );
}

Future<void> _showWindow() async {
  await windowManager.show();
  await windowManager.focus();
}
