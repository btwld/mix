import 'dart:io';

import 'package:mix_atlas_capture/mix_atlas_capture.dart';

abstract interface class AtlasCaptureGateway {
  Future<AtlasCapture> loadLocal({
    required Directory directory,
    required String manifestPath,
  });

  Future<AtlasCapture> loadGitHub({
    required String repository,
    required String ref,
    required String manifestPath,
  });

  Future<AtlasGitHubPullRequestList> listOpenPullRequests(String repository);
}

final class DefaultAtlasCaptureGateway implements AtlasCaptureGateway {
  final AtlasGitHubRepositorySource _github;
  final Map<String, Future<AtlasCapture>> _cache = {};

  DefaultAtlasCaptureGateway({AtlasHttpClient? http})
    : _github = AtlasGitHubRepositorySource(
        http: http ?? const AtlasIoHttpClient(),
      );

  @override
  Future<AtlasCapture> loadLocal({
    required Directory directory,
    required String manifestPath,
  }) {
    final key = 'local|${directory.absolute.path}|$manifestPath';

    return _cache.putIfAbsent(
      key,
      () => AtlasCaptureReader(source: AtlasDirectorySource(directory.absolute))
          .load(
            AtlasRepositoryRequest(
              repository: directory.absolute.path,
              ref: 'local',
              manifestPath: manifestPath,
            ),
          ),
    );
  }

  @override
  Future<AtlasCapture> loadGitHub({
    required String repository,
    required String ref,
    required String manifestPath,
  }) {
    final key = 'github|$repository|$ref|$manifestPath';

    return _cache.putIfAbsent(
      key,
      () => AtlasCaptureReader(source: _github).load(
        AtlasRepositoryRequest(
          repository: repository,
          ref: ref,
          manifestPath: manifestPath,
        ),
      ),
    );
  }

  @override
  Future<AtlasGitHubPullRequestList> listOpenPullRequests(String repository) =>
      _github.listOpenPullRequests(repository);
}
