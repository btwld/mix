import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_example/artifacts/capture_bundle.dart';
import 'package:mix_atlas_example/artifacts/component_parser.dart';

import 'artifact_fixture.dart';
import 'capture_parser_test.dart' show throwsArtifactFailure;

void main() {
  group('portable component parser', () {
    test('parses the bounded Button anatomy and evidence contract', () {
      final document = parsePortableComponentDocument(
        _bytes(validButtonComponentDocument()),
        path: 'components/button.component.json',
      );

      expect(document.id, 'button');
      expect(document.properties, hasLength(7));
      expect(document.states, hasLength(6));
      expect(document.slots, hasLength(5));
      expect(document.anatomy.nodes, hasLength(6));
      expect(document.recipes.single.styleFor('container').isSupported, true);
      expect(document.recipes.single.styleFor('spinner').isSupported, false);
      expect(document.oracles, hasLength(2));
    });

    test('rejects unknown fields instead of silently ignoring them', () {
      final value = validButtonComponentDocument()..['callback'] = 'run-me';

      expect(
        () => parsePortableComponentDocument(
          _bytes(value),
          path: 'components/button.component.json',
        ),
        throwsArtifactFailure(ArtifactFailureKind.malformedJson),
      );
    });

    test('rejects an anatomy cycle', () {
      final value = validButtonComponentDocument();
      final anatomy = value['anatomy']! as Map<String, Object?>;
      final nodes = anatomy['nodes']! as List<Object?>;
      final label = nodes[3]! as Map<String, Object?>;
      label['children'] = ['root'];

      expect(
        () => parsePortableComponentDocument(
          _bytes(value),
          path: 'components/button.component.json',
        ),
        throwsArtifactFailure(ArtifactFailureKind.invalidComponent),
      );
    });

    test('requires structured diagnostics for unsupported slot styles', () {
      final value = validButtonComponentDocument();
      final recipes = value['recipes']! as List<Object?>;
      final recipe = recipes.single! as Map<String, Object?>;
      final styles = recipe['styles']! as Map<String, Object?>;
      final spinner = styles['spinner']! as Map<String, Object?>;
      spinner['diagnostics'] = <Object?>[];

      expect(
        () => parsePortableComponentDocument(
          _bytes(value),
          path: 'components/button.component.json',
        ),
        throwsArtifactFailure(ArtifactFailureKind.invalidComponent),
      );
    });

    test('rejects a recipe that omits a stable slot', () {
      final value = validButtonComponentDocument();
      final recipes = value['recipes']! as List<Object?>;
      final recipe = recipes.single! as Map<String, Object?>;
      final styles = recipe['styles']! as Map<String, Object?>;
      styles.remove('label');

      expect(
        () => parsePortableComponentDocument(
          _bytes(value),
          path: 'components/button.component.json',
        ),
        throwsArtifactFailure(ArtifactFailureKind.invalidComponent),
      );
    });

    test('rejects more recipes than the document limit', () {
      final value = validButtonComponentDocument();
      value['recipes'] = [
        for (var index = 0; index < 257; index += 1)
          portableButtonRecipe(id: 'solid-size1-$index'),
      ];

      expect(
        () => parsePortableComponentDocument(
          _bytes(value),
          path: 'components/button.component.json',
        ),
        throwsArtifactFailure(ArtifactFailureKind.malformedJson),
      );
    });
  });
}

Uint8List _bytes(Object? value) =>
    Uint8List.fromList(utf8.encode(jsonEncode(value)));
