import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_component_contract/mix_component_contract.dart';
import 'package:mix_figma/src/core/protocol_json/component_set_payload.dart';

void main() {
  test('v1 Button recipes and states become a named variant grid', () {
    final component = _component('button_v1.component.json');
    final resolved = <String, Map<String, Object?>>{};
    for (final reference in component.recipes.single.styles.values) {
      if (reference.documentPath case final String path) {
        resolved[path] = {
          'v': 1,
          'type': path.contains('label')
              ? 'text'
              : path.contains('icon')
              ? 'icon'
              : 'flex_box',
        };
      }
    }

    final result = buildComponentSetPayload(
      component,
      resolvedSlotStyles: resolved,
    );
    final components = result.value['components']! as List<Object?>;

    expect(components, hasLength(6));
    expect(
      (components.first! as Map)['name'],
      'variant=solid,size=size1,state=default',
    );
    expect(
      result.diagnostics.map((item) => item.code),
      contains('unsupported_slot_primitive'),
    );
  });

  test('v2 bindings and embedded styles reach the component payload', () {
    final component = _component('component_v2.component.json');
    final result = buildComponentSetPayload(component);
    final components = result.value['components']! as List<Object?>;
    final first = (components.first! as Map).cast<String, Object?>();
    final anatomy = (first['anatomy']! as Map).cast<String, Object?>();
    final nodes = (anatomy['nodes']! as List<Object?>).cast<Map>();
    final spinner = nodes.singleWhere((node) => node['id'] == 'spinner');

    expect(components, hasLength(2));
    expect(
      ((spinner['bindings']! as Map)['color']! as Map)['token'],
      'color/fortal.accent.9',
    );
    expect((first['styles']! as Map).keys, containsAll(component.slots.keys));
  });
}

PortableComponentDocument _component(String name) {
  final bytes = File(
    '../mix_component_contract/test/fixtures/$name',
  ).readAsBytesSync();
  return parsePortableComponentDocument(
    Uint8List.fromList(bytes),
    path: 'fixtures/$name',
  );
}
