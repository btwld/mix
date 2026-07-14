import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import '../artifacts/capture_bundle.dart';
import '../artifacts/capture_parser.dart';
import 'artifact_source.dart';

final class ArtifactHttpResponse {
  final int statusCode;

  final Uint8List body;
  const ArtifactHttpResponse({required this.statusCode, required this.body});
}

abstract interface class ArtifactHttpClient {
  Future<ArtifactHttpResponse> get(Uri uri, {required int maxBytes});
}

final class IoArtifactHttpClient implements ArtifactHttpClient {
  const IoArtifactHttpClient();

  @override
  Future<ArtifactHttpResponse> get(Uri uri, {required int maxBytes}) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      final request = await client
          .getUrl(uri)
          .timeout(const Duration(seconds: 15));
      request
        ..followRedirects = true
        ..maxRedirects = 3
        ..headers.set(HttpHeaders.userAgentHeader, 'mix-atlas-spike/0.1')
        ..headers.set(HttpHeaders.acceptHeader, 'application/vnd.github+json');
      final response = await request.close().timeout(
        const Duration(seconds: 20),
      );
      if (response.contentLength > maxBytes) {
        throw ArtifactLoadException(
          .sourceRejected,
          'Remote response exceeds the allowed byte limit.',
          path: uri.toString(),
          statusCode: response.statusCode,
        );
      }
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in response.timeout(const Duration(seconds: 20))) {
        bytes.add(chunk);
        if (bytes.length > maxBytes) {
          throw ArtifactLoadException(
            .sourceRejected,
            'Remote response exceeds the allowed byte limit.',
            path: uri.toString(),
            statusCode: response.statusCode,
          );
        }
      }

      return ArtifactHttpResponse(
        statusCode: response.statusCode,
        body: bytes.takeBytes(),
      );
    } on ArtifactLoadException {
      rethrow;
    } on TimeoutException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ArtifactLoadException(
          .network,
          'GitHub did not respond before the request timed out.',
          path: uri.toString(),
          cause: error,
        ),
        stackTrace,
      );
    } on SocketException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ArtifactLoadException(
          .network,
          'GitHub could not be reached. Check the network connection and retry.',
          path: uri.toString(),
          cause: error,
        ),
        stackTrace,
      );
    } on HttpException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ArtifactLoadException(
          .network,
          'GitHub closed the request before it completed.',
          path: uri.toString(),
          cause: error,
        ),
        stackTrace,
      );
    } finally {
      client.close(force: true);
    }
  }
}

final class GitHubRepositorySource implements ArtifactSource {
  final ArtifactHttpClient _http;

  const GitHubRepositorySource({required ArtifactHttpClient http})
    : _http = http;

  @override
  Future<ResolvedArtifactSource> resolve(
    ArtifactRepositoryRequest request,
  ) async {
    final repositoryParts = request.repository.split('/');
    if (repositoryParts.length != 2 ||
        repositoryParts.any((part) => !_repositoryPart.hasMatch(part)) ||
        request.ref.trim().isEmpty ||
        request.ref.length > 256 ||
        request.ref.contains('\u0000')) {
      throw const ArtifactLoadException(
        .invalidRequest,
        'Use a repository in owner/name form and provide a non-empty ref.',
      );
    }
    validateArtifactPath(request.manifestPath, path: 'manifestPath');

    final owner = repositoryParts.first;
    final repository = repositoryParts.last;
    final commitUri = Uri(
      scheme: 'https',
      host: 'api.github.com',
      pathSegments: ['repos', owner, repository, 'commits', request.ref],
    );
    final response = await _http.get(
      commitUri,
      maxBytes: CaptureLimits.maxManifestBytes,
    );
    if (response.statusCode == HttpStatus.notFound ||
        response.statusCode == HttpStatus.unprocessableEntity) {
      throw ArtifactLoadException(
        .notFound,
        'Repository or ref was not found on GitHub.',
        path: request.ref,
        statusCode: response.statusCode,
      );
    }
    if (response.statusCode != HttpStatus.ok) {
      throw ArtifactLoadException(
        .sourceRejected,
        'GitHub rejected the ref lookup with HTTP ${response.statusCode}.',
        path: commitUri.toString(),
        statusCode: response.statusCode,
      );
    }
    final payload = decodeJsonObject(response.body, path: commitUri.toString());
    final sha = payload['sha'];
    if (sha is! String || !RegExp(r'^[a-f0-9]{40,64}$').hasMatch(sha)) {
      throw ArtifactLoadException(
        .sourceRejected,
        'GitHub returned an invalid commit identifier.',
        path: commitUri.toString(),
      );
    }

    return _ResolvedGitHubSource(
      http: _http,
      owner: owner,
      repository: repository,
      receipt: ArtifactSourceReceipt(
        repository: request.repository,
        requestedRef: request.ref,
        resolvedCommit: sha,
      ),
    );
  }
}

final class _ResolvedGitHubSource implements ResolvedArtifactSource {
  final String owner;

  final String repository;
  @override
  final ArtifactSourceReceipt receipt;
  final ArtifactHttpClient _http;

  const _ResolvedGitHubSource({
    required ArtifactHttpClient http,
    required this.owner,
    required this.repository,
    required this.receipt,
  }) : _http = http;

  @override
  Future<Uint8List> read(
    String repositoryRelativePath, {
    required int maxBytes,
  }) async {
    validateArtifactPath(repositoryRelativePath, path: repositoryRelativePath);
    final uri = Uri(
      scheme: 'https',
      host: 'raw.githubusercontent.com',
      pathSegments: [
        owner,
        repository,
        receipt.resolvedCommit,
        ...repositoryRelativePath.split('/'),
      ],
    );
    final response = await _http.get(uri, maxBytes: maxBytes);
    if (response.statusCode == HttpStatus.notFound) {
      throw ArtifactLoadException(
        .notFound,
        'Capture file was not found at the resolved commit.',
        path: repositoryRelativePath,
        statusCode: response.statusCode,
      );
    }
    if (response.statusCode != HttpStatus.ok) {
      throw ArtifactLoadException(
        .sourceRejected,
        'GitHub rejected the file request with HTTP ${response.statusCode}.',
        path: repositoryRelativePath,
        statusCode: response.statusCode,
      );
    }

    return response.body;
  }
}

final _repositoryPart = RegExp(r'^[A-Za-z0-9_.-]+$');
