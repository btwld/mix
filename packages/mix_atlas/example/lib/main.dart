import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mix_atlas/mix_atlas.dart';
import 'package:window_manager/window_manager.dart';

import 'catalog.dart';
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

  runApp(const AtlasExampleApp());
}

Future<void> _showWindow() async {
  await windowManager.show();
  await windowManager.focus();
}

class AtlasExampleApp extends StatelessWidget {
  const AtlasExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: AtlasCatalogViewer(catalog: exampleCatalog),
    title: 'Mix Atlas',
    debugShowCheckedModeBanner: false,
  );
}
