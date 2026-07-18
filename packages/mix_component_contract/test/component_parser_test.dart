import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mix_component_contract/mix_component_contract.dart';
import 'package:test/test.dart';

void main() {
  group('portable component v1 parser', () {
    test('parses the bounded Button anatomy and evidence contract', () {
      final document = _parse(_fixture('button_v1.component.json'));

      expect(document.schema, ComponentDocumentSchema.v1);
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
      final value = _fixture('button_v1.component.json')
        ..['callback'] = 'run-me';

      expect(
        () => _parse(value),
        _throwsFailure(ArtifactFailureKind.malformedJson),
      );
    });

    test('rejects an anatomy cycle', () {
      final value = _fixture('button_v1.component.json');
      final anatomy = value['anatomy']! as Map<String, Object?>;
      final nodes = anatomy['nodes']! as List<Object?>;
      final label = nodes[3]! as Map<String, Object?>;
      label['children'] = ['root'];

      expect(
        () => _parse(value),
        _throwsFailure(ArtifactFailureKind.invalidComponent),
      );
    });

    test('requires structured diagnostics for unsupported slot styles', () {
      final value = _fixture('button_v1.component.json');
      final styles = _recipeStyles(value);
      final spinner = styles['spinner']! as Map<String, Object?>;
      spinner['diagnostics'] = <Object?>[];

      expect(
        () => _parse(value),
        _throwsFailure(ArtifactFailureKind.invalidComponent),
      );
    });

    test('rejects a recipe that omits a stable slot', () {
      final value = _fixture('button_v1.component.json');
      _recipeStyles(value).remove('label');

      expect(
        () => _parse(value),
        _throwsFailure(ArtifactFailureKind.invalidComponent),
      );
    });

    test('rejects more recipes than the document limit', () {
      final value = _fixture('button_v1.component.json');
      final recipe = (value['recipes']! as List<Object?>).single;
      value['recipes'] = [
        for (var index = 0; index < 257; index += 1)
          {...(recipe! as Map<String, Object?>), 'id': 'solid-size1-$index'},
      ];

      expect(
        () => _parse(value),
        _throwsFailure(ArtifactFailureKind.malformedJson),
      );
    });
  });
}

Map<String, Object?> _recipeStyles(Map<String, Object?> value) {
  final recipes = value['recipes']! as List<Object?>;
  final recipe = recipes.single! as Map<String, Object?>;

  return recipe['styles']! as Map<String, Object?>;
}

PortableComponentDocument _parse(Map<String, Object?> value) =>
    parsePortableComponentDocument(
      Uint8List.fromList(utf8.encode(jsonEncode(value))),
      path: 'components/button.component.json',
    );

Map<String, Object?> _fixture(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync())
        as Map<String, Object?>;

Matcher _throwsFailure(ArtifactFailureKind kind) => throwsA(
  isA<ArtifactLoadException>().having((error) => error.kind, 'kind', kind),
);
