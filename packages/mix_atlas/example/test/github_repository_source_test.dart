import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_example/artifacts/capture_bundle.dart';
import 'package:mix_atlas_example/sources/github_repository_source.dart';

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

ArtifactHttpResponse _response(int statusCode, String body) {
  return ArtifactHttpResponse(
    statusCode: statusCode,
    body: Uint8List.fromList(utf8.encode(body)),
  );
}
