import 'dart:typed_data';

import '../artifacts/capture_bundle.dart';

abstract interface class ArtifactSource {
  Future<ResolvedArtifactSource> resolve(ArtifactRepositoryRequest request);
}

abstract interface class ResolvedArtifactSource {
  ArtifactSourceReceipt get receipt;

  Future<Uint8List> read(
    String repositoryRelativePath, {
    required int maxBytes,
  });
}
