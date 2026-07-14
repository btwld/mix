import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_atlas_example/artifacts/capture_bundle.dart';
import 'package:mix_atlas_example/artifacts/capture_loader.dart';

import 'artifact_fixture.dart';
import 'capture_parser_test.dart' show throwsArtifactFailure;

void main() {
  group('portable component loader', () {
    test(
      'strict-decodes each supported slot into its expected Mix type',
      () async {
        final fixture = ArtifactFixture.create()..addPortableButtonCapture();

        final capture = await CaptureLoader(
          source: fixture.source(),
        ).load(fixtureRequest);

        expect(capture.componentDocuments.single.id, 'button');
        expect(capture.protocolThemes.keys, {'light', 'dark'});
        expect(
          capture
              .styleDocuments['styles/button/solid-size1/container.mix.json'],
          isA<FlexBoxStyler>(),
        );
        expect(
          capture.styleDocuments['styles/button/solid-size1/label.mix.json'],
          isA<TextStyler>(),
        );
        expect(
          capture.styleDocuments['styles/button/solid-size1/icon.mix.json'],
          isA<IconStyler>(),
        );
      },
    );

    test('rejects a supported slot document with the wrong Mix type', () {
      final fixture = ArtifactFixture.create()..addPortableButtonCapture();
      fixture.replaceJson('styles/button/solid-size1/label.mix.json', {
        'v': 1,
        'type': 'icon',
      });

      expect(
        () => CaptureLoader(source: fixture.source()).load(fixtureRequest),
        throwsArtifactFailure(ArtifactFailureKind.invalidProtocol),
      );
    });

    test('rejects an oracle that differs from the catalog asset', () {
      final fixture = ArtifactFixture.create();
      final document = validButtonComponentDocument();
      final oracles = document['oracles']! as List<Object?>;
      final light = oracles.first! as Map<String, Object?>;
      light['image'] = 'dark/button.png';
      fixture.addPortableButtonCapture(document: document);

      expect(
        () => CaptureLoader(source: fixture.source()).load(fixtureRequest),
        throwsArtifactFailure(ArtifactFailureKind.invalidComponent),
      );
    });

    test('does not allow a component to claim spinner support', () {
      final fixture = ArtifactFixture.create();
      final document = validButtonComponentDocument();
      final recipes = document['recipes']! as List<Object?>;
      final recipe = recipes.single! as Map<String, Object?>;
      final styles = recipe['styles']! as Map<String, Object?>;
      styles['spinner'] = {
        'status': 'supported',
        'evidence': 'declared',
        'document': 'styles/button/solid-size1/spinner.mix.json',
      };
      fixture.addPortableButtonCapture(document: document);
      fixture.replaceJson('styles/button/solid-size1/spinner.mix.json', {
        'v': 1,
        'type': 'box',
      });

      expect(
        () => CaptureLoader(source: fixture.source()).load(fixtureRequest),
        throwsArtifactFailure(ArtifactFailureKind.invalidComponent),
      );
    });
  });
}
