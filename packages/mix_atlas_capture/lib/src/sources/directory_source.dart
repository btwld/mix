import 'dart:io';
import 'dart:typed_data';

import '../artifacts/capture_bundle.dart';
import '../artifacts/capture_parser.dart';
import 'artifact_source.dart';

/// Reads a capture from a user-selected local directory.
final class AtlasDirectorySource implements ArtifactSource {
  final Directory directory;

  const AtlasDirectorySource(this.directory);

  @override
  Future<ResolvedArtifactSource> resolve(
    ArtifactRepositoryRequest request,
  ) async {
    validateArtifactPath(request.manifestPath, path: 'manifestPath');
    try {
      final root = await directory.resolveSymbolicLinks();

      return _ResolvedDirectorySource(root: root);
    } on FileSystemException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ArtifactLoadException(
          .notFound,
          'The selected capture folder could not be opened.',
          path: directory.path,
          cause: error,
        ),
        stackTrace,
      );
    }
  }
}

final class _ResolvedDirectorySource implements ResolvedArtifactSource {
  final String root;

  const _ResolvedDirectorySource({required this.root});

  @override
  Future<Uint8List> read(
    String repositoryRelativePath, {
    required int maxBytes,
  }) async {
    validateArtifactPath(repositoryRelativePath, path: repositoryRelativePath);
    final candidate = File(
      [root, ...repositoryRelativePath.split('/')].join(Platform.pathSeparator),
    );
    try {
      final resolved = await candidate.resolveSymbolicLinks();
      final rootPrefix = root.endsWith(Platform.pathSeparator)
          ? root
          : '$root${Platform.pathSeparator}';
      if (!resolved.startsWith(rootPrefix)) {
        throw ArtifactLoadException(
          .unsafePath,
          'Capture files must remain inside the selected directory.',
          path: repositoryRelativePath,
        );
      }
      final file = File(resolved);
      final length = await file.length();
      if (length > maxBytes) {
        throw ArtifactLoadException(
          .sourceRejected,
          'Capture file exceeds the allowed byte limit.',
          path: repositoryRelativePath,
        );
      }
      final bytes = await file.readAsBytes();
      if (bytes.length > maxBytes) {
        throw ArtifactLoadException(
          .sourceRejected,
          'Capture file exceeds the allowed byte limit.',
          path: repositoryRelativePath,
        );
      }

      return bytes;
    } on ArtifactLoadException {
      rethrow;
    } on FileSystemException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ArtifactLoadException(
          .notFound,
          'Capture file was not found in the selected directory.',
          path: repositoryRelativePath,
          cause: error,
        ),
        stackTrace,
      );
    }
  }

  @override
  ArtifactSourceReceipt get receipt => .new(
    repository: root,
    requestedRef: 'local',
    resolvedCommit: 'local',
    kind: .local,
  );
}
