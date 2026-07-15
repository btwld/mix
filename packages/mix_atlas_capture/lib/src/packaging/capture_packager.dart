import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

const _encoder = JsonEncoder.withIndent('  ');

/// A theme document included in a canonical capture.
final class AtlasCaptureThemeSpec {
  final String id;

  final String documentPath;
  const AtlasCaptureThemeSpec({required this.id, required this.documentPath});

  Map<String, Object?> toJson() => {'id': id, 'document': documentPath};
}

/// A portable component-v1 or component-v2 document in a canonical capture.
final class AtlasCaptureComponentSpec {
  final String id;

  final String documentPath;
  const AtlasCaptureComponentSpec({
    required this.id,
    required this.documentPath,
  });

  Map<String, Object?> toJson() => {'id': id, 'document': documentPath};
}

/// Producer and document metadata used to write capture v2.
final class AtlasCapturePackageMetadata {
  final String id;

  final String atlasVersion;
  final String mixProtocolVersion;
  final int mixProtocolFormat;
  final String flutterVersion;
  final String catalogPath;
  final List<AtlasCaptureThemeSpec> themes;
  final List<AtlasCaptureComponentSpec> components;
  final String protocolCoveragePath;
  const AtlasCapturePackageMetadata({
    required this.id,
    required this.atlasVersion,
    required this.mixProtocolVersion,
    required this.mixProtocolFormat,
    required this.flutterVersion,
    required this.catalogPath,
    required this.themes,
    required this.components,
    required this.protocolCoveragePath,
  });
}

/// Optional source-to-bundle mapping for a producer-specific staged layout.
final class AtlasCaptureAsset {
  final String sourcePath;

  final String destinationPath;
  const AtlasCaptureAsset({
    required this.sourcePath,
    required this.destinationPath,
  });
}

/// Complete input to one deterministic build or drift check.
final class AtlasCapturePackageInput {
  final Directory sourceDirectory;

  final Directory outputDirectory;
  final AtlasCapturePackageMetadata metadata;
  final List<AtlasCaptureAsset> assets;
  final Set<String> preservedPaths;
  AtlasCapturePackageInput({
    required this.sourceDirectory,
    required this.outputDirectory,
    required this.metadata,
    this.assets = const [],
    Set<String> preservedPaths = const {},
  }) : preservedPaths = Set.unmodifiable(preservedPaths);
}

/// Result of a build or non-mutating drift check.
final class AtlasCapturePackageResult {
  final int fileCount;

  final int totalBytes;
  final List<String> driftPaths;
  AtlasCapturePackageResult({
    required this.fileCount,
    required this.totalBytes,
    required List<String> driftPaths,
  }) : driftPaths = List.unmodifiable(driftPaths);

  bool get isCurrent => driftPaths.isEmpty;
}

/// Builds and validates canonical, hash-indexed capture v2 bundles.
abstract final class AtlasCapturePackager {
  static AtlasCapturePackageResult check(AtlasCapturePackageInput input) {
    final prepared = _prepare(input);
    final drift = <String>[];
    final expected = {
      for (final file in prepared.files) file.path: file.bytes,
      'capture.json': prepared.manifestBytes,
    };
    for (final entry in expected.entries) {
      final destination = _file(input.outputDirectory, entry.key);
      if (!destination.existsSync() ||
          !_bytesEqual(destination.readAsBytesSync(), entry.value)) {
        drift.add(entry.key);
      }
    }
    if (input.outputDirectory.existsSync()) {
      for (final entity in input.outputDirectory.listSync(recursive: true)) {
        if (entity is! File) continue;
        final path = _relative(input.outputDirectory, entity);
        if (!expected.containsKey(path) &&
            !input.preservedPaths.contains(path)) {
          drift.add(path);
        }
      }
    }
    drift.sort();

    return AtlasCapturePackageResult(
      fileCount: prepared.files.length + 1,
      totalBytes: prepared.totalBytes,
      driftPaths: drift.toSet().toList(growable: false),
    );
  }

  static _PreparedCapture _prepare(AtlasCapturePackageInput input) {
    final assets = input.assets.isEmpty ? _inferAssets(input) : input.assets;
    final seen = <String>{};
    final files = <_PackageFile>[];
    for (final asset in assets) {
      _validatePath(asset.sourcePath, name: 'sourcePath');
      _validatePath(asset.destinationPath, name: 'destinationPath');
      if (asset.destinationPath == 'capture.json') {
        throw ArgumentError.value(
          asset.destinationPath,
          'destinationPath',
          'capture.json is reserved for the generated manifest.',
        );
      }
      if (!seen.add(asset.destinationPath)) {
        throw ArgumentError('Duplicate destination: ${asset.destinationPath}');
      }
      final source = _file(input.sourceDirectory, asset.sourcePath);
      if (!source.existsSync()) {
        throw StateError('Missing validated Atlas source: ${source.path}');
      }
      files.add(
        _PackageFile(
          path: asset.destinationPath,
          bytes: source.readAsBytesSync(),
        ),
      );
    }
    files.sort((left, right) => left.path.compareTo(right.path));
    final metadata = input.metadata;
    final requiredPaths = {
      metadata.catalogPath,
      metadata.protocolCoveragePath,
      ...metadata.themes.map((theme) => theme.documentPath),
      ...metadata.components.map((component) => component.documentPath),
    };
    for (final path in requiredPaths) {
      _validatePath(path, name: 'metadata path');
      if (!seen.contains(path)) {
        throw StateError(
          'Capture metadata references an unindexed file: $path',
        );
      }
    }
    final manifest = <String, Object?>{
      'schema': 'mix_atlas/capture/v2',
      'id': metadata.id,
      'producer': {
        'atlas': metadata.atlasVersion,
        'mixProtocolVersion': metadata.mixProtocolVersion,
        'mixProtocolFormat': metadata.mixProtocolFormat,
        'flutter': metadata.flutterVersion,
      },
      'catalog': metadata.catalogPath,
      'themes': metadata.themes.map((theme) => theme.toJson()).toList(),
      'components': metadata.components
          .map((component) => component.toJson())
          .toList(),
      'protocolCoverage': metadata.protocolCoveragePath,
      'files': [
        for (final file in files)
          {
            'path': file.path,
            'sha256': sha256.convert(file.bytes).toString(),
            'bytes': file.bytes.length,
          },
      ],
    };
    final manifestBytes = utf8.encode('${_encoder.convert(manifest)}\n');

    return _PreparedCapture(
      files: files,
      manifestBytes: manifestBytes,
      expectedPaths: {...seen, 'capture.json'},
    );
  }

  static List<AtlasCaptureAsset> _inferAssets(AtlasCapturePackageInput input) {
    if (!input.sourceDirectory.existsSync()) {
      throw StateError(
        'Capture source does not exist: ${input.sourceDirectory.path}',
      );
    }
    final assets = <AtlasCaptureAsset>[];
    for (final entity in input.sourceDirectory.listSync(recursive: true)) {
      if (entity is! File) continue;
      final path = _relative(input.sourceDirectory, entity);
      if (path == 'capture.json') continue;
      assets.add(AtlasCaptureAsset(sourcePath: path, destinationPath: path));
    }
    assets.sort((left, right) => left.sourcePath.compareTo(right.sourcePath));

    return assets;
  }

  static void _removeUnexpected(
    AtlasCapturePackageInput input,
    Set<String> expected,
  ) {
    if (!input.outputDirectory.existsSync()) return;
    final files = input.outputDirectory
        .listSync(recursive: true)
        .whereType<File>()
        .toList();
    for (final file in files) {
      final path = _relative(input.outputDirectory, file);
      if (!expected.contains(path) && !input.preservedPaths.contains(path)) {
        file.deleteSync();
      }
    }
  }

  static AtlasCapturePackageResult build(AtlasCapturePackageInput input) {
    final prepared = _prepare(input);
    input.outputDirectory.createSync(recursive: true);
    _removeUnexpected(input, prepared.expectedPaths);
    for (final file in prepared.files) {
      final destination = _file(input.outputDirectory, file.path);
      destination.parent.createSync(recursive: true);
      destination.writeAsBytesSync(file.bytes, flush: true);
    }
    final manifest = _file(input.outputDirectory, 'capture.json');
    manifest.writeAsBytesSync(prepared.manifestBytes, flush: true);
    final checkResult = check(input);
    if (!checkResult.isCurrent) {
      throw StateError(
        'Packaged Atlas capture failed its own drift check: '
        '${checkResult.driftPaths.join(', ')}',
      );
    }

    return AtlasCapturePackageResult(
      fileCount: prepared.files.length + 1,
      totalBytes: prepared.totalBytes,
      driftPaths: const [],
    );
  }
}

final class _PreparedCapture {
  final List<_PackageFile> files;

  final List<int> manifestBytes;
  final Set<String> expectedPaths;
  const _PreparedCapture({
    required this.files,
    required this.manifestBytes,
    required this.expectedPaths,
  });

  int get totalBytes => files.fold(
    manifestBytes.length,
    (total, file) => total + file.bytes.length,
  );
}

final class _PackageFile {
  final String path;

  final List<int> bytes;
  const _PackageFile({required this.path, required this.bytes});
}

File _file(Directory root, String relativePath) =>
    .new([root.path, ...relativePath.split('/')].join(Platform.pathSeparator));

String _relative(Directory root, File file) => file.path
    .substring(root.path.length + 1)
    .replaceAll(Platform.pathSeparator, '/');

void _validatePath(String value, {required String name}) {
  if (value.isEmpty ||
      value.length > 512 ||
      value.startsWith('/') ||
      value.contains('\\') ||
      value.contains('\u0000') ||
      value
          .split('/')
          .any((part) => part.isEmpty || part == '.' || part == '..')) {
    throw ArgumentError.value(value, name, 'Expected a safe relative path.');
  }
}

bool _bytesEqual(List<int> left, List<int> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) return false;
  }

  return true;
}
