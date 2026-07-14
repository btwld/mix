import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_capture/src/artifacts/capture_bundle.dart';
import 'package:mix_atlas_capture/src/artifacts/capture_loader.dart';
import 'package:mix_atlas_capture/src/artifacts/capture_parser.dart';

import 'artifact_fixture.dart';

void main() {
  group('capture parser and loader', () {
    test(
      'loads a hash-verified capture with partial protocol coverage',
      () async {
        final fixture = ArtifactFixture.create();
        final capture = await CaptureLoader(
          source: fixture.source(),
        ).load(fixtureRequest);

        expect(capture.receipt.resolvedCommit, fixtureCommit);
        expect(capture.catalog.label, 'Fortal Design System');
        expect(capture.catalog.components.single.label, 'Button');
        expect(capture.themeTokenCounts, {'light': 2, 'dark': 2});
        expect(capture.validatedStyleDocumentCount, 1);
        expect(capture.protocolCoverage.supportedCount, 3);
        expect(capture.protocolCoverage.unsupportedCount, 1);
        expect(
          capture.protocolCoverage.diagnostics.single.message,
          contains('RemixButtonStyler'),
        );
        expect(capture.file('light/button.png'), isNotEmpty);
      },
    );

    test('rejects path traversal before reading child files', () {
      final fixture = ArtifactFixture.create();
      final entries = fixture.manifest['files']! as List<Object?>;
      final first = entries.first! as Map<String, Object?>;
      first['path'] = '../outside.json';

      expect(
        () => parseCaptureManifest(
          (fixture.source() as MemoryArtifactSource).files[fixtureRequest
              .manifestPath]!,
        ),
        throwsArtifactFailure(ArtifactFailureKind.unsafePath),
      );
    });

    test('rejects an unsupported capture schema', () {
      final fixture = ArtifactFixture.create();
      fixture.manifest['schema'] = 'mix_atlas/capture/v999';
      final source = fixture.source() as MemoryArtifactSource;

      expect(
        () => parseCaptureManifest(source.files[fixtureRequest.manifestPath]!),
        throwsArtifactFailure(ArtifactFailureKind.unsupportedSchema),
      );
    });

    test('accepts capture v2 with an indexed component document', () {
      final fixture = ArtifactFixture.create();
      fixture.manifest['schema'] = 'mix_atlas/capture/v2';
      fixture.manifest['components'] = [
        {'id': 'button', 'document': 'components/button.component.json'},
      ];
      fixture.replaceJson('components/button.component.json', {
        'schema': 'mix_atlas/component/v1',
      });
      final source = fixture.source() as MemoryArtifactSource;

      expect(
        parseCaptureManifest(
          source.files[fixtureRequest.manifestPath]!,
        ).componentDocuments.single.id,
        'button',
      );
    });

    test('keeps capture v1 backward-compatible without components', () {
      final fixture = ArtifactFixture.create();
      final source = fixture.source() as MemoryArtifactSource;

      final manifest = parseCaptureManifest(
        source.files[fixtureRequest.manifestPath]!,
      );

      expect(manifest.schemaVersion, 1);
      expect(manifest.componentDocuments, isEmpty);
    });

    test('requires at least one component document in capture v2', () {
      final fixture = ArtifactFixture.create();
      fixture.manifest['schema'] = 'mix_atlas/capture/v2';
      fixture.manifest['components'] = <Object?>[];
      final source = fixture.source() as MemoryArtifactSource;

      expect(
        () => parseCaptureManifest(source.files[fixtureRequest.manifestPath]!),
        throwsArtifactFailure(ArtifactFailureKind.malformedJson),
      );
    });

    test('rejects duplicate component document identifiers', () {
      final fixture = ArtifactFixture.create();
      fixture.manifest['schema'] = 'mix_atlas/capture/v2';
      fixture.manifest['components'] = [
        {'id': 'button', 'document': 'components/button-a.json'},
        {'id': 'button', 'document': 'components/button-b.json'},
      ];
      fixture.replaceJson('components/button-a.json', {
        'schema': 'mix_atlas/component/v1',
      });
      fixture.replaceJson('components/button-b.json', {
        'schema': 'mix_atlas/component/v1',
      });
      final source = fixture.source() as MemoryArtifactSource;

      expect(
        () => parseCaptureManifest(source.files[fixtureRequest.manifestPath]!),
        throwsArtifactFailure(ArtifactFailureKind.malformedJson),
      );
    });

    test('rejects an unsafe component document path', () {
      final fixture = ArtifactFixture.create();
      fixture.manifest['schema'] = 'mix_atlas/capture/v2';
      fixture.manifest['components'] = [
        {'id': 'button', 'document': '../button.component.json'},
      ];
      final source = fixture.source() as MemoryArtifactSource;

      expect(
        () => parseCaptureManifest(source.files[fixtureRequest.manifestPath]!),
        throwsArtifactFailure(ArtifactFailureKind.unsafePath),
      );
    });

    test('requires component documents to be indexed by capture files', () {
      final fixture = ArtifactFixture.create();
      fixture.manifest['schema'] = 'mix_atlas/capture/v2';
      fixture.manifest['components'] = [
        {'id': 'button', 'document': 'components/button.component.json'},
      ];
      final source = fixture.source() as MemoryArtifactSource;

      expect(
        () => parseCaptureManifest(source.files[fixtureRequest.manifestPath]!),
        throwsArtifactFailure(ArtifactFailureKind.integrity),
      );
    });

    test('rejects an unsupported protocol version', () {
      final fixture = ArtifactFixture.create();
      final producer = fixture.manifest['producer']! as Map<String, Object?>;
      producer['mixProtocolVersion'] = '2.0.0';
      final source = fixture.source() as MemoryArtifactSource;

      expect(
        () => parseCaptureManifest(source.files[fixtureRequest.manifestPath]!),
        throwsArtifactFailure(ArtifactFailureKind.invalidProtocol),
      );
    });

    test('rejects an invalid theme after its hash passes', () async {
      final fixture = ArtifactFixture.create()
        ..replaceJson('themes/light.mix.json', {'v': 2, 'type': 'theme'});

      expect(
        () => CaptureLoader(source: fixture.source()).load(fixtureRequest),
        throwsArtifactFailure(ArtifactFailureKind.invalidProtocol),
      );
    });

    test('rejects a child file whose bytes no longer match the manifest', () {
      final fixture = ArtifactFixture.create();
      fixture.files['light/button.png']![0] = 0;

      expect(
        () => CaptureLoader(source: fixture.source()).load(fixtureRequest),
        throwsArtifactFailure(ArtifactFailureKind.integrity),
      );
    });
  });
}

Matcher throwsArtifactFailure(ArtifactFailureKind kind) {
  return throwsA(
    isA<ArtifactLoadException>().having((error) => error.kind, 'kind', kind),
  );
}
