import 'dart:async';
import 'dart:io';

import 'package:mix_atlas/golden.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Canonical macOS 15 CI remains byte-exact. Other macOS versions can differ
  // by a handful of text-antialiasing pixels while rendering the same screen.
  if (!Platform.environment.containsKey('CI')) {
    AtlasGoldens.precisionTolerance = 0.0001;
  }
  configureAtlasGoldenComparator();
  await loadAtlasFonts();
  await testMain();
}
