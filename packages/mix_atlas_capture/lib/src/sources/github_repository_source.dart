import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../artifacts/capture_bundle.dart';
import '../artifacts/capture_parser.dart';
import 'artifact_source.dart';

final class ArtifactHttpResponse {
  final int statusCode;

  final Uint8List body;
  final Map<String, String> headers;
  const ArtifactHttpResponse({
    required this.statusCode,
    required this.body,
    this.headers = const {},
  });
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
        ..headers.set(HttpHeaders.userAgentHeader, 'mix-atlas/0.1')
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
        headers: _selectedRateLimitHeaders(response.headers),
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

final class AtlasGitHubRateLimit {
  final int? remaining;

  final int? limit;
  final DateTime? resetAt;
  const AtlasGitHubRateLimit({
    required this.remaining,
    required this.limit,
    required this.resetAt,
  });
}

final class AtlasGitHubPullRequest {
  final int number;

  final String title;
  final String url;
  final String baseRef;
  final String headRepository;
  final String headSha;
  const AtlasGitHubPullRequest({
    required this.number,
    required this.title,
    required this.url,
    required this.baseRef,
    required this.headRepository,
    required this.headSha,
  });
}

final class AtlasGitHubPullRequestList {
  final List<AtlasGitHubPullRequest> pullRequests;

  final AtlasGitHubRateLimit? rateLimit;
  AtlasGitHubPullRequestList({
    required List<AtlasGitHubPullRequest> pullRequests,
    required this.rateLimit,
  }) : pullRequests = List.unmodifiable(pullRequests);
}

final class GitHubRepositorySource implements ArtifactSource {
  final ArtifactHttpClient _http;
  final Map<String, AtlasGitHubPullRequestList> _pullRequestCache = {};
  AtlasGitHubRateLimit? _rateLimit;

  GitHubRepositorySource({required ArtifactHttpClient http}) : _http = http;

  Future<AtlasGitHubPullRequest> _loadPullRequest(
    String owner,
    String repository,
    int number,
  ) async {
    _throwIfRateLimited();
    final uri = Uri(
      scheme: 'https',
      host: 'api.github.com',
      pathSegments: ['repos', owner, repository, 'pulls', '$number'],
    );
    final response = await _apiGet(uri, maxBytes: CaptureLimits.maxJsonBytes);
    if (response.statusCode == HttpStatus.notFound) {
      throw ArtifactLoadException(
        .notFound,
        'Pull request was not found on GitHub.',
        path: '$owner/$repository#$number',
        statusCode: response.statusCode,
      );
    }
    if (response.statusCode != HttpStatus.ok) {
      throw ArtifactLoadException(
        .sourceRejected,
        'GitHub rejected the pull-request lookup with HTTP '
        '${response.statusCode}.',
        path: uri.toString(),
        statusCode: response.statusCode,
      );
    }

    return _parsePullRequest(
      decodeJsonObject(response.body, path: uri.toString()),
      path: uri.toString(),
    );
  }

  Future<ArtifactHttpResponse> _apiGet(Uri uri, {required int maxBytes}) async {
    _throwIfRateLimited();
    final response = await _http.get(uri, maxBytes: maxBytes);
    _rateLimit = _rateLimitFrom(response.headers) ?? _rateLimit;
    if ((response.statusCode == HttpStatus.forbidden ||
            response.statusCode == HttpStatus.tooManyRequests) &&
        _rateLimit?.remaining == 0) {
      _throwRateLimited(uri.toString());
    }

    return response;
  }

  void _throwIfRateLimited() {
    final reset = _rateLimit?.resetAt;
    if (_rateLimit?.remaining == 0 &&
        reset != null &&
        reset.isAfter(DateTime.now().toUtc())) {
      _throwRateLimited('api.github.com');
    }
  }

  Never _throwRateLimited(String path) {
    final reset = _rateLimit?.resetAt;
    throw ArtifactLoadException(
      .rateLimited,
      reset == null
          ? 'GitHub API rate limit was exhausted.'
          : 'GitHub API rate limit was exhausted until '
                '${reset.toIso8601String()}.',
      path: path,
      statusCode: HttpStatus.forbidden,
    );
  }

  AtlasGitHubRateLimit? get rateLimit => _rateLimit;

  Future<AtlasGitHubPullRequestList> listOpenPullRequests(
    String repositoryInput,
  ) async {
    final repository = _parseRepository(repositoryInput);
    final key = '${repository.owner}/${repository.repository}';
    final cached = _pullRequestCache[key];
    if (cached != null) return cached;
    _throwIfRateLimited();
    final uri = Uri(
      scheme: 'https',
      host: 'api.github.com',
      pathSegments: ['repos', repository.owner, repository.repository, 'pulls'],
      queryParameters: const {'state': 'open', 'per_page': '50'},
    );
    final response = await _apiGet(uri, maxBytes: CaptureLimits.maxJsonBytes);
    if (response.statusCode == HttpStatus.notFound) {
      throw ArtifactLoadException(
        .notFound,
        'Repository was not found while listing open pull requests.',
        path: key,
        statusCode: response.statusCode,
      );
    }
    if (response.statusCode != HttpStatus.ok) {
      throw ArtifactLoadException(
        .sourceRejected,
        'GitHub rejected the pull-request list with HTTP '
        '${response.statusCode}.',
        path: uri.toString(),
        statusCode: response.statusCode,
      );
    }
    final decoded = jsonDecode(utf8.decode(response.body));
    if (decoded is! List<Object?> || decoded.length > 100) {
      throw ArtifactLoadException(
        .sourceRejected,
        'GitHub returned an invalid pull-request list.',
        path: uri.toString(),
      );
    }
    final result = AtlasGitHubPullRequestList(
      pullRequests: [
        for (final value in decoded)
          _parsePullRequest(value, path: uri.toString()),
      ],
      rateLimit: _rateLimit,
    );
    _pullRequestCache[key] = result;

    return result;
  }

  @override
  Future<ResolvedArtifactSource> resolve(
    ArtifactRepositoryRequest request,
  ) async {
    validateArtifactPath(request.manifestPath, path: 'manifestPath');
    final target = _parseTarget(request.repository, request.ref);
    if (target.pullNumber case final number?) {
      final pull = await _loadPullRequest(
        target.owner,
        target.repository,
        number,
      );
      final head = _parseRepository(pull.headRepository);

      return _ResolvedGitHubSource(
        http: _http,
        owner: head.owner,
        repository: head.repository,
        receipt: ArtifactSourceReceipt(
          repository: pull.headRepository,
          requestedRef: 'pull/${pull.number}',
          resolvedCommit: pull.headSha,
        ),
      );
    }
    final owner = target.owner;
    final repository = target.repository;
    if (_fullSha.hasMatch(target.ref)) {
      return _ResolvedGitHubSource(
        http: _http,
        owner: owner,
        repository: repository,
        receipt: ArtifactSourceReceipt(
          repository: '$owner/$repository',
          requestedRef: target.ref,
          resolvedCommit: target.ref,
        ),
      );
    }
    final commitUri = Uri(
      scheme: 'https',
      host: 'api.github.com',
      pathSegments: ['repos', owner, repository, 'commits', target.ref],
    );
    final response = await _apiGet(
      commitUri,
      maxBytes: CaptureLimits.maxManifestBytes,
    );
    if (response.statusCode == HttpStatus.notFound ||
        response.statusCode == HttpStatus.unprocessableEntity) {
      throw ArtifactLoadException(
        .notFound,
        'Repository or ref was not found on GitHub.',
        path: target.ref,
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
        repository: '$owner/$repository',
        requestedRef: target.ref,
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

({String owner, String repository, int? pullNumber, String ref}) _parseTarget(
  String repositoryInput,
  String refInput,
) {
  final repository = _parseRepository(repositoryInput);
  final repositoryPull = _pullNumberFrom(repositoryInput);
  final refPull = _pullNumberFrom(refInput);
  final pullNumber = repositoryPull ?? refPull;
  final ref = refInput.trim();
  if (pullNumber == null &&
      (ref.isEmpty ||
          ref.length > 256 ||
          ref.contains('\u0000') ||
          ref.contains('\\'))) {
    throw const ArtifactLoadException(
      .invalidRequest,
      'Provide a branch, tag, full SHA, PR URL, or PR number.',
    );
  }

  return (
    owner: repository.owner,
    repository: repository.repository,
    pullNumber: pullNumber,
    ref: ref,
  );
}

({String owner, String repository}) _parseRepository(String input) {
  final trimmed = input.trim();
  List<String> parts;
  final uri = Uri.tryParse(trimmed);
  if (uri != null &&
      (uri.scheme == 'https' || uri.scheme == 'http') &&
      uri.host.toLowerCase() == 'github.com') {
    parts = uri.pathSegments.where((part) => part.isNotEmpty).toList();
  } else {
    parts = trimmed.split('/');
  }
  if (parts.length < 2) {
    throw const ArtifactLoadException(
      .invalidRequest,
      'Use a public GitHub repository in owner/name or URL form.',
    );
  }
  final owner = parts[0];
  final repository = parts[1].replaceFirst(RegExp(r'\.git$'), '');
  if (!_repositoryPart.hasMatch(owner) ||
      !_repositoryPart.hasMatch(repository)) {
    throw const ArtifactLoadException(
      .invalidRequest,
      'GitHub owner and repository names contain unsupported characters.',
    );
  }

  return (owner: owner, repository: repository);
}

int? _pullNumberFrom(String input) {
  final trimmed = input.trim();
  final direct = RegExp(r'^(?:#|pull/)?([1-9][0-9]*)$').firstMatch(trimmed);
  if (direct != null) return int.parse(direct.group(1)!);
  final uri = Uri.tryParse(trimmed);
  if (uri == null || uri.host.toLowerCase() != 'github.com') return null;
  final parts = uri.pathSegments.where((part) => part.isNotEmpty).toList();
  if (parts.length < 4 || parts[2] != 'pull') return null;

  return int.tryParse(parts[3]);
}

AtlasGitHubPullRequest _parsePullRequest(
  Object? value, {
  required String path,
}) {
  if (value is! Map) {
    throw ArtifactLoadException(
      .sourceRejected,
      'GitHub returned an invalid pull-request object.',
      path: path,
    );
  }
  final json = value.cast<String, Object?>();
  final head = json['head'];
  final base = json['base'];
  if (head is! Map || base is! Map) {
    throw ArtifactLoadException(
      .sourceRejected,
      'GitHub pull request is missing head or base data.',
      path: path,
    );
  }
  final headJson = head.cast<String, Object?>();
  final baseJson = base.cast<String, Object?>();
  final headRepository = headJson['repo'];
  final repositoryJson = headRepository is Map
      ? headRepository.cast<String, Object?>()
      : const <String, Object?>{};
  final number = json['number'];
  final title = json['title'];
  final url = json['html_url'];
  final baseRef = baseJson['ref'];
  final fullName = repositoryJson['full_name'];
  final headSha = headJson['sha'];
  if (number is! int ||
      title is! String ||
      url is! String ||
      baseRef is! String ||
      fullName is! String ||
      headSha is! String ||
      !_fullSha.hasMatch(headSha)) {
    throw ArtifactLoadException(
      .sourceRejected,
      'GitHub returned incomplete pull-request data.',
      path: path,
    );
  }
  _parseRepository(fullName);

  return AtlasGitHubPullRequest(
    number: number,
    title: title,
    url: url,
    baseRef: baseRef,
    headRepository: fullName,
    headSha: headSha,
  );
}

AtlasGitHubRateLimit? _rateLimitFrom(Map<String, String> headers) {
  final remaining = int.tryParse(headers['x-ratelimit-remaining'] ?? '');
  final limit = int.tryParse(headers['x-ratelimit-limit'] ?? '');
  final resetSeconds = int.tryParse(headers['x-ratelimit-reset'] ?? '');
  if (remaining == null && limit == null && resetSeconds == null) return null;

  return AtlasGitHubRateLimit(
    remaining: remaining,
    limit: limit,
    resetAt: resetSeconds == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            resetSeconds * Duration.millisecondsPerSecond,
            isUtc: true,
          ),
  );
}

final _repositoryPart = RegExp(r'^[A-Za-z0-9_.-]+$');
final _fullSha = RegExp(r'^[a-fA-F0-9]{40,64}$');

Map<String, String> _selectedRateLimitHeaders(HttpHeaders headers) {
  final selected = <String, String>{};
  for (final name in [
    'x-ratelimit-remaining',
    'x-ratelimit-reset',
    'x-ratelimit-limit',
  ]) {
    final value = headers.value(name);
    if (value != null) selected[name] = value;
  }

  return selected;
}
