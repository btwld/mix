import 'dart:io';

import 'package:flutter/services.dart';

const gridExampleTestFontFamily = 'GridExampleRoboto';

Future<void>? _fontLoad;

Future<void> loadGridExampleTestFonts() {
  return _fontLoad ??= _loadGridExampleTestFonts();
}

Future<void> _loadGridExampleTestFonts() async {
  final repositoryRoot = _findAncestorContaining(
    Directory.current,
    'packages/mix_winds/example/assets/fonts/roboto/Roboto[wdth,wght].ttf',
  );
  final flutterRoot = _findAncestorContaining(
    File(Platform.resolvedExecutable).parent,
    'bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );

  await _loadFont(
    gridExampleTestFontFamily,
    File(
      '${repositoryRoot.path}/packages/mix_winds/example/assets/fonts/'
      'roboto/Roboto[wdth,wght].ttf',
    ),
  );
  await _loadFont(
    'MaterialIcons',
    File(
      '${flutterRoot.path}/bin/cache/artifacts/material_fonts/'
      'MaterialIcons-Regular.otf',
    ),
  );
}

Directory _findAncestorContaining(Directory start, String relativePath) {
  var current = start.absolute;
  while (true) {
    if (File('${current.path}/$relativePath').existsSync()) return current;
    final parent = current.parent;
    if (parent.path == current.path) {
      throw StateError('Could not find $relativePath from ${start.path}.');
    }
    current = parent;
  }
}

Future<void> _loadFont(String family, File file) async {
  final bytes = await file.readAsBytes();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.sublistView(bytes)));
  await loader.load();
}
