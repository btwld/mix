import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mix_component_contract/mix_component_contract.dart';
import 'package:test/test.dart';

void main() {
  group('portable component v2 parser', () {
    test('parses the materialized upstream fixture', () {
      final document = _parse(_fixture('component_v2.component.json'));

      expect(document.schema, ComponentDocumentSchema.v2);
      expect(document.id, 'fixture');
      expect(
        document.properties.values.map((property) => property.kind),
        containsAll(ComponentPropertyKind.values),
      );
      expect(document.styleLibrary, hasLength(6));
      expect(
        document.anatomy.nodes.values.map((node) => node.kind),
        containsAll({
          ComponentAnatomyNodeKind.box,
          ComponentAnatomyNodeKind.flexBox,
          ComponentAnatomyNodeKind.stackBox,
          ComponentAnatomyNodeKind.text,
          ComponentAnatomyNodeKind.icon,
          ComponentAnatomyNodeKind.image,
          ComponentAnatomyNodeKind.spinner,
          ComponentAnatomyNodeKind.fractionalPosition,
          ComponentAnatomyNodeKind.nestedComponent,
        }),
      );
      expect(document.states['selectedError']!.widgetStates, {
        'selected',
        'error',
      });
      expect(
        document.semantics.bindings.keys,
        containsAll({'label', 'enabled', 'selected', 'liveRegion'}),
      );
      expect(document.diagnostics.single.code, 'runtime.callback_omitted');
    });

    test('rejects unsafe token binding references', () {
      final json = _fixture('component_v2.component.json');
      final spinner = _node(json, 'spinner');
      final bindings = spinner['bindings']! as Map<String, Object?>;
      bindings['color'] = {'token': '../../secret'};

      expect(
        () => _parse(json),
        _throwsFailure(ArtifactFailureKind.invalidComponent),
      );
    });

    test('rejects statically unrenderable defaults', () {
      final invalidProgress = _fixture('component_v2.component.json');
      _property(invalidProgress, 'progress')['default'] = 2.0;
      expect(
        () => _parse(invalidProgress),
        throwsA(isA<ArtifactLoadException>()),
      );

      final invalidIcon = _fixture('component_v2.component.json');
      _property(invalidIcon, 'icon')['default'] = 'unregistered_icon';
      expect(() => _parse(invalidIcon), throwsA(isA<ArtifactLoadException>()));
    });

    test('enforces component-scoped style limits', () {
      final json = _fixture('component_v2.component.json');
      json['styles'] = {
        for (var index = 0; index < 2049; index += 1)
          'style/$index': {'v': 1, 'type': 'box'},
      };

      expect(
        () => _parse(json),
        _throwsFailure(ArtifactFailureKind.malformedJson),
      );
    });

    test('accepts producer scenario state IDs without a sentinel', () {
      final json = _fixture('component_v2.component.json');
      final states = (json['states']! as List<Object?>)
          .cast<Map<String, Object?>>();
      states.first['id'] = 'collapsed';

      expect(_parse(json).states.keys, contains('collapsed'));
    });

    test('keeps v1 documents compatible through the byte front door', () {
      final document = _parse(_fixture('button_v1.component.json'));

      expect(document.schema, ComponentDocumentSchema.v1);
      expect(document.semantics.role, 'button');
      expect(document.semantics.bindings['label']!.propertyId, 'label');
    });
  });
}

Map<String, Object?> _node(Map<String, Object?> json, String id) {
  final anatomy = json['anatomy']! as Map<String, Object?>;
  final nodes = (anatomy['nodes']! as List<Object?>)
      .cast<Map<String, Object?>>();

  return nodes.singleWhere((node) => node['id'] == id);
}

Map<String, Object?> _property(Map<String, Object?> json, String id) {
  final properties = (json['properties']! as List<Object?>)
      .cast<Map<String, Object?>>();

  return properties.singleWhere((property) => property['id'] == id);
}

PortableComponentDocument _parse(Map<String, Object?> value) =>
    parsePortableComponentDocument(
      Uint8List.fromList(utf8.encode(jsonEncode(value))),
      path: 'fixture.component.json',
    );

Map<String, Object?> _fixture(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync())
        as Map<String, Object?>;

Matcher _throwsFailure(ArtifactFailureKind kind) => throwsA(
  isA<ArtifactLoadException>().having((error) => error.kind, 'kind', kind),
);
