import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

void main() {
  test('loads the committed baseline and changed Button captures', () async {
    final baseline = await _load('button_baseline');
    final changed = await _load('button_changed');

    expect(baseline.catalog.components.single.id, 'button');
    expect(changed.catalog.components.single.id, 'button');
    expect(baseline.componentDocuments.single.recipes, hasLength(1));
    expect(changed.componentDocuments.single.recipes, hasLength(1));
    expect(
      baseline.files['styles/button/solid-size1/label.mix.json'],
      isNot(changed.files['styles/button/solid-size1/label.mix.json']),
    );
  });
}

Future<AtlasCapture> _load(String fixture) {
  final directory = Directory('test/fixtures/$fixture').absolute;

  return AtlasCaptureReader(source: AtlasDirectorySource(directory)).load(
    const AtlasRepositoryRequest(
      repository: 'local',
      ref: 'local',
      manifestPath: 'capture.json',
    ),
  );
}
