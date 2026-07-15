import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_capture/packaging.dart';

void main() {
  test('exposes the pure Dart capture packaging contract', () {
    final input = AtlasCapturePackageInput(
      sourceDirectory: Directory.systemTemp,
      outputDirectory: Directory.systemTemp,
      metadata: const AtlasCapturePackageMetadata(
        id: 'fixture',
        atlasVersion: '0.1.0',
        mixProtocolVersion: '1.0.0',
        mixProtocolFormat: 1,
        flutterVersion: '3.41.0',
        catalogPath: 'catalog.json',
        themes: [],
        components: [],
        protocolCoveragePath: 'coverage.json',
      ),
    );

    expect(input.metadata.id, 'fixture');
  });
}
