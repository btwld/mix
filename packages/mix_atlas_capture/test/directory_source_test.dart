import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_capture/src/artifacts/capture_bundle.dart';
import 'package:mix_atlas_capture/src/sources/directory_source.dart';

void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('mix_atlas_capture_');
  });

  tearDown(() => root.delete(recursive: true));

  test('reads only bounded files inside the selected directory', () async {
    await File('${root.path}/capture.json').writeAsString('{}');
    final source = await AtlasDirectorySource(root).resolve(
      const ArtifactRepositoryRequest(
        repository: 'local',
        ref: 'local',
        manifestPath: 'capture.json',
      ),
    );

    expect(source.receipt.kind, ArtifactSourceKind.local);
    expect(await source.read('capture.json', maxBytes: 2), hasLength(2));
    expect(
      () => source.read('capture.json', maxBytes: 1),
      throwsA(
        isA<ArtifactLoadException>().having(
          (error) => error.kind,
          'kind',
          ArtifactFailureKind.sourceRejected,
        ),
      ),
    );
  });

  test('rejects a symlink that escapes the selected directory', () async {
    final outside = await Directory.systemTemp.createTemp('mix_atlas_outside_');
    addTearDown(() => outside.delete(recursive: true));
    await File('${outside.path}/secret.json').writeAsString('{}');
    await Link(
      '${root.path}/secret.json',
    ).create('${outside.path}/secret.json');
    final source = await AtlasDirectorySource(root).resolve(
      const ArtifactRepositoryRequest(
        repository: 'local',
        ref: 'local',
        manifestPath: 'capture.json',
      ),
    );

    expect(
      () => source.read('secret.json', maxBytes: 16),
      throwsA(
        isA<ArtifactLoadException>().having(
          (error) => error.kind,
          'kind',
          ArtifactFailureKind.unsafePath,
        ),
      ),
    );
  });
}
