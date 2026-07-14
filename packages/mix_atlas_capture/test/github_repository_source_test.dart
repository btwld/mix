import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_capture/src/artifacts/capture_bundle.dart';
import 'package:mix_atlas_capture/src/sources/github_repository_source.dart';

import 'artifact_fixture.dart';
import 'capture_parser_test.dart' show throwsArtifactFailure;

void main() {
  group('GitHub repository source', () {
    test(
      'resolves a mutable ref and reads every file at only its SHA',
      () async {
        final client = FakeArtifactHttpClient((uri, _) async {
          if (uri.host == 'api.github.com') {
            return _response(HttpStatus.ok, '{"sha":"$fixtureCommit"}');
          }

          return _response(HttpStatus.ok, '{"schema":"fixture"}');
        });
        final source = GitHubRepositorySource(http: client);

        final resolved = await source.resolve(fixtureRequest);
        final bytes = await resolved.read(
          fixtureRequest.manifestPath,
          maxBytes: 1024,
        );

        expect(resolved.receipt.requestedRef, 'main');
        expect(resolved.receipt.resolvedCommit, fixtureCommit);
        expect(utf8.decode(bytes), contains('fixture'));
        expect(client.uris, hasLength(2));
        expect(client.uris.first.scheme, 'https');
        expect(client.uris.first.host, 'api.github.com');
        expect(client.uris.first.pathSegments, [
          'repos',
          'btwld',
          'remix',
          'commits',
          'main',
        ]);
        expect(client.uris.last.host, 'raw.githubusercontent.com');
        expect(client.uris.last.pathSegments.take(3), [
          'btwld',
          'remix',
          fixtureCommit,
        ]);
        expect(client.uris.last.pathSegments, isNot(contains('main')));
      },
    );

    test('reports a missing manifest at the resolved commit', () async {
      final client = FakeArtifactHttpClient((uri, _) async {
        if (uri.host == 'api.github.com') {
          return _response(HttpStatus.ok, '{"sha":"$fixtureCommit"}');
        }

        return _response(HttpStatus.notFound, 'missing');
      });
      final resolved = await GitHubRepositorySource(
        http: client,
      ).resolve(fixtureRequest);

      expect(
        () => resolved.read(fixtureRequest.manifestPath, maxBytes: 1024),
        throwsArtifactFailure(ArtifactFailureKind.notFound),
      );
    });

    test('reports a missing repository or ref', () {
      for (final statusCode in [
        HttpStatus.notFound,
        HttpStatus.unprocessableEntity,
      ]) {
        final client = FakeArtifactHttpClient(
          (_, _) async => _response(statusCode, 'missing'),
        );

        expect(
          () => GitHubRepositorySource(http: client).resolve(fixtureRequest),
          throwsArtifactFailure(ArtifactFailureKind.notFound),
          reason: 'HTTP $statusCode',
        );
      }
    });

    test('a network interruption can be retried by resolving again', () async {
      var attempts = 0;
      final client = FakeArtifactHttpClient((_, _) async {
        attempts += 1;
        if (attempts == 1) {
          throw const ArtifactLoadException(
            ArtifactFailureKind.network,
            'Connection interrupted.',
          );
        }

        return _response(HttpStatus.ok, '{"sha":"$fixtureCommit"}');
      });
      final source = GitHubRepositorySource(http: client);

      await expectLater(
        source.resolve(fixtureRequest),
        throwsArtifactFailure(ArtifactFailureKind.network),
      );
      final resolved = await source.resolve(fixtureRequest);

      expect(resolved.receipt.resolvedCommit, fixtureCommit);
      expect(attempts, 2);
    });

    test('full SHAs and repository URLs bypass ref resolution', () async {
      final client = FakeArtifactHttpClient(
        (_, _) async => throw StateError('HTTP should not be called'),
      );
      final source = GitHubRepositorySource(http: client);

      final resolved = await source.resolve(
        const ArtifactRepositoryRequest(
          repository: 'https://github.com/btwld/remix',
          ref: fixtureCommit,
          manifestPath: 'atlas/fortal/capture.json',
        ),
      );

      expect(resolved.receipt.repository, 'btwld/remix');
      expect(resolved.receipt.resolvedCommit, fixtureCommit);
      expect(client.uris, isEmpty);
    });

    test('PR URLs read fork captures from the immutable head SHA', () async {
      const forkSha = 'abcdef0123456789abcdef0123456789abcdef01';
      final client = FakeArtifactHttpClient((uri, _) async {
        if (uri.host == 'api.github.com') {
          return _response(
            HttpStatus.ok,
            _pullJson(
              number: 42,
              headRepository: 'contributor/remix',
              sha: forkSha,
            ),
          );
        }

        return _response(HttpStatus.ok, '{}');
      });
      final source = GitHubRepositorySource(http: client);
      final resolved = await source.resolve(
        const ArtifactRepositoryRequest(
          repository: 'https://github.com/btwld/remix/pull/42',
          ref: 'main',
          manifestPath: 'atlas/fortal/capture.json',
        ),
      );
      await resolved.read('atlas/fortal/capture.json', maxBytes: 1024);

      expect(resolved.receipt.repository, 'contributor/remix');
      expect(resolved.receipt.requestedRef, 'pull/42');
      expect(resolved.receipt.resolvedCommit, forkSha);
      expect(client.uris.first.pathSegments, [
        'repos',
        'btwld',
        'remix',
        'pulls',
        '42',
      ]);
      expect(client.uris.last.pathSegments.take(3), [
        'contributor',
        'remix',
        forkSha,
      ]);
    });

    test('PR numbers read same-repository captures at the head SHA', () async {
      final client = FakeArtifactHttpClient((uri, _) async {
        if (uri.host == 'api.github.com') {
          return _response(
            HttpStatus.ok,
            _pullJson(
              number: 42,
              headRepository: 'btwld/remix',
              sha: fixtureCommit,
            ),
          );
        }

        return _response(HttpStatus.ok, '{}');
      });
      final source = GitHubRepositorySource(http: client);
      final resolved = await source.resolve(
        const ArtifactRepositoryRequest(
          repository: 'btwld/remix',
          ref: '42',
          manifestPath: 'atlas/fortal/capture.json',
        ),
      );
      await resolved.read('atlas/fortal/capture.json', maxBytes: 1024);

      expect(resolved.receipt.repository, 'btwld/remix');
      expect(resolved.receipt.requestedRef, 'pull/42');
      expect(resolved.receipt.resolvedCommit, fixtureCommit);
      expect(client.uris.last.pathSegments.take(3), [
        'btwld',
        'remix',
        fixtureCommit,
      ]);
    });

    test('lists and caches open public PRs with rate-limit details', () async {
      final client = FakeArtifactHttpClient(
        (_, _) async => _response(
          HttpStatus.ok,
          '[${_pullJson(number: 7, headRepository: 'btwld/remix', sha: fixtureCommit)}]',
          headers: {
            'x-ratelimit-limit': '60',
            'x-ratelimit-remaining': '59',
            'x-ratelimit-reset': '2000000000',
          },
        ),
      );
      final source = GitHubRepositorySource(http: client);

      final first = await source.listOpenPullRequests('btwld/remix');
      final second = await source.listOpenPullRequests(
        'https://github.com/btwld/remix',
      );

      expect(first.pullRequests.single.number, 7);
      expect(first.rateLimit?.remaining, 59);
      expect(identical(first, second), true);
      expect(client.uris, hasLength(1));
    });

    test('does not retry the REST API before a rate-limit reset', () async {
      final reset = DateTime.now().toUtc().add(const Duration(hours: 1));
      final client = FakeArtifactHttpClient(
        (_, _) async => _response(
          HttpStatus.forbidden,
          '{}',
          headers: {
            'x-ratelimit-remaining': '0',
            'x-ratelimit-reset': '${reset.millisecondsSinceEpoch ~/ 1000}',
          },
        ),
      );
      final source = GitHubRepositorySource(http: client);

      await expectLater(
        source.listOpenPullRequests('btwld/remix'),
        throwsArtifactFailure(ArtifactFailureKind.rateLimited),
      );
      await expectLater(
        source.listOpenPullRequests('btwld/remix'),
        throwsArtifactFailure(ArtifactFailureKind.rateLimited),
      );
      expect(client.uris, hasLength(1));
    });
  });
}

typedef ArtifactHttpHandler =
    Future<ArtifactHttpResponse> Function(Uri uri, int maxBytes);

final class FakeArtifactHttpClient implements ArtifactHttpClient {
  FakeArtifactHttpClient(this.handler);

  final ArtifactHttpHandler handler;
  final List<Uri> uris = [];

  @override
  Future<ArtifactHttpResponse> get(Uri uri, {required int maxBytes}) {
    uris.add(uri);

    return handler(uri, maxBytes);
  }
}

ArtifactHttpResponse _response(
  int statusCode,
  String body, {
  Map<String, String> headers = const {},
}) {
  return ArtifactHttpResponse(
    statusCode: statusCode,
    body: Uint8List.fromList(utf8.encode(body)),
    headers: headers,
  );
}

String _pullJson({
  required int number,
  required String headRepository,
  required String sha,
}) => jsonEncode({
  'number': number,
  'title': 'Atlas update',
  'html_url': 'https://github.com/btwld/remix/pull/$number',
  'base': {'ref': 'main'},
  'head': {
    'sha': sha,
    'repo': {'full_name': headRepository},
  },
});
