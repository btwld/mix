import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

void main() {
  late Directory root;
  late Directory source;
  late Directory output;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('atlas_packager_');
    source = await Directory('${root.path}/source').create();
    output = await Directory('${root.path}/output').create();
    await _write(source, 'catalog.json', '{}');
    await _write(source, 'protocol/coverage.json', '{}');
    await _write(source, 'themes/light.mix.json', '{}');
    await _write(source, 'components/button.component.json', '{}');
  });

  tearDown(() => root.delete(recursive: true));

  test('builds and checks a deterministic canonical v2 bundle', () async {
    final input = _input(source, output);

    final first = AtlasCapturePackager.build(input);
    final check = AtlasCapturePackager.check(input);
    final firstManifest = await File(
      '${output.path}/capture.json',
    ).readAsString();
    final second = AtlasCapturePackager.build(input);
    final secondManifest = await File(
      '${output.path}/capture.json',
    ).readAsString();

    expect(first.fileCount, 5);
    expect(first.driftPaths, isEmpty);
    expect(check.isCurrent, true);
    expect(firstManifest, secondManifest);
    expect(second.isCurrent, true);
    final decoded = jsonDecode(firstManifest) as Map<String, Object?>;
    expect(decoded['schema'], 'mix_atlas/capture/v2');
    expect((decoded['files']! as List<Object?>), hasLength(4));
  });

  test(
    'check reports changed, missing, and stale paths without writing',
    () async {
      final input = _input(source, output);
      AtlasCapturePackager.build(input);
      await _write(output, 'catalog.json', 'changed');
      await File('${output.path}/themes/light.mix.json').delete();
      await _write(output, 'styles/stale.mix.json', '{}');

      final result = AtlasCapturePackager.check(input);

      expect(result.isCurrent, false);
      expect(result.driftPaths, [
        'catalog.json',
        'styles/stale.mix.json',
        'themes/light.mix.json',
      ]);
      expect(
        await File('${output.path}/catalog.json').readAsString(),
        'changed',
      );
    },
  );

  test(
    'build removes stale generated files but preserves named documentation',
    () async {
      final input = _input(source, output, preservedPaths: {'README.md'});
      await _write(output, 'README.md', 'producer notes');
      await _write(output, 'styles/stale.mix.json', '{}');

      AtlasCapturePackager.build(input);

      expect(File('${output.path}/styles/stale.mix.json').existsSync(), false);
      expect(
        await File('${output.path}/README.md').readAsString(),
        'producer notes',
      );
    },
  );
}

AtlasCapturePackageInput _input(
  Directory source,
  Directory output, {
  Set<String> preservedPaths = const {},
}) => AtlasCapturePackageInput(
  sourceDirectory: source,
  outputDirectory: output,
  metadata: const AtlasCapturePackageMetadata(
    id: 'fortal',
    atlasVersion: '0.1.0',
    mixProtocolVersion: '1.0.0',
    mixProtocolFormat: 1,
    flutterVersion: '3.41.7',
    catalogPath: 'catalog.json',
    themes: [
      AtlasCaptureThemeSpec(id: 'light', documentPath: 'themes/light.mix.json'),
    ],
    components: [
      AtlasCaptureComponentSpec(
        id: 'button',
        documentPath: 'components/button.component.json',
      ),
    ],
    protocolCoveragePath: 'protocol/coverage.json',
  ),
  preservedPaths: preservedPaths,
);

Future<void> _write(Directory root, String path, String contents) async {
  final file = File('${root.path}/$path');
  await file.parent.create(recursive: true);
  await file.writeAsString(contents);
}
