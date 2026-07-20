import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_component_contract/mix_component_contract.dart';
import 'package:mix_figma/src/core/identity/mix_figma_lock.dart';
import 'package:mix_figma/src/core/protocol_json/component_set_payload.dart';

void main() {
  test('portable visual styles become concrete Figma node payloads', () {
    final component = _localComponent('button.component.json');

    final result = buildComponentSetPayload(component);
    final variants = (result.value['variants']! as List).cast<Map>();
    final root = (variants.first['root']! as Map).cast<String, Object?>();
    final label = _node((root['children']! as List).cast<Map>(), 'label');

    expect(root['layout'], {
      'mode': 'HORIZONTAL',
      'primaryAxisAlignItems': 'CENTER',
      'counterAxisAlignItems': 'CENTER',
      'itemSpacing': 8,
      'paddingTop': 10,
      'paddingRight': 16,
      'paddingBottom': 10,
      'paddingLeft': 16,
    });
    expect(root['style'], {
      'fills': [
        {
          'type': 'SOLID',
          'color': {
            'r': closeTo(0.2, 0.0001),
            'g': closeTo(0.4, 0.0001),
            'b': closeTo(0.6, 0.0001),
          },
          'opacity': 1.0,
          'visible': true,
        },
      ],
      'cornerRadius': 8,
    });
    expect(label['style'], {
      'fills': [
        {
          'type': 'SOLID',
          'color': {'r': 1.0, 'g': 1.0, 'b': 1.0},
          'opacity': 1.0,
          'visible': true,
        },
      ],
    });
    expect(label['text'], {
      'characters': 'Button',
      'fontName': {'family': 'Inter', 'style': 'Semi Bold'},
      'fontSize': 14,
      'lineHeight': {'unit': 'PERCENT', 'value': 140.0},
    });
  });

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

  test('v1 slot anatomy resolves to Figma primitives and state visibility', () {
    final component = _component('button_v1.component.json');
    final result = buildComponentSetPayload(
      component,
      resolvedSlotStyles: _resolvedStyles(component),
    );
    final variants = (result.value['variants']! as List).cast<Map>();

    expect(variants.map((variant) => variant['ref']), [
      'solid-size1-default',
      'solid-size1-disabled',
      'solid-size1-focused',
      'solid-size1-hovered',
      'solid-size1-loading',
      'solid-size1-pressed',
    ]);

    final defaultRoot = _root(variants, 'solid-size1-default');
    final defaultChildren = (defaultRoot['children']! as List).cast<Map>();
    final content = _node(defaultChildren, 'content');
    final spinner = _node(defaultChildren, 'spinner');
    final contentChildren = (content['children']! as List).cast<Map>();

    expect(content['kind'], 'FRAME');
    expect(content['layout'], {'mode': 'HORIZONTAL'});
    expect(content['visible'], isTrue);
    expect(_node(contentChildren, 'label')['kind'], 'TEXT');
    expect(
      (_node(contentChildren, 'label')['text']! as Map)['characters'],
      'Button',
    );
    expect(_node(contentChildren, 'leadingIcon')['kind'], 'UNSUPPORTED');
    expect(spinner['kind'], 'UNSUPPORTED');
    expect(spinner['visible'], isFalse);

    final loadingRoot = _root(variants, 'solid-size1-loading');
    final loadingChildren = (loadingRoot['children']! as List).cast<Map>();
    expect(_node(loadingChildren, 'content')['visible'], isFalse);
    expect(_node(loadingChildren, 'spinner')['visible'], isTrue);
    expect(
      result.diagnostics.map((item) => item.message),
      isNot(
        contains('Legacy slot anatomy requires a concrete Figma primitive.'),
      ),
    );
  });

  test('v2 bindings and embedded styles reach the component payload', () {
    final component = _component('component_v2.component.json');
    final result = buildComponentSetPayload(
      component,
      lock: MixFigmaLock(
        variableIds: {'colors/fortal.accent.9': 'variable:accent'},
      ),
    );
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

    final pluginVariants = (result.value['variants']! as List).cast<Map>();
    final root = (pluginVariants.first['root']! as Map).cast<String, Object?>();
    final spinnerPayload = _node(
      (root['children']! as List).cast<Map>(),
      'spinner',
    );
    expect(spinnerPayload['variableBindings'], {'fill': 'variable:accent'});

    final defaultRoot = _root(pluginVariants, 'primary-default');
    final selectedErrorRoot = _root(pluginVariants, 'primary-selectedError');
    expect(
      _node(
        (defaultRoot['children']! as List).cast<Map>(),
        'spinner',
      )['visible'],
      isFalse,
    );
    expect(
      _node(
        (selectedErrorRoot['children']! as List).cast<Map>(),
        'spinner',
      )['visible'],
      isTrue,
    );
  });
}

Map<String, Map<String, Object?>> _resolvedStyles(
  PortableComponentDocument component,
) {
  final result = <String, Map<String, Object?>>{};
  for (final reference in component.recipes.single.styles.values) {
    if (reference.documentPath case final String path) {
      result[path] = {
        'v': 1,
        'type': path.contains('label') ? 'text' : 'flex_box',
      };
    }
  }

  return result;
}

Map _root(List<Map> variants, String ref) =>
    (variants.singleWhere((variant) => variant['ref'] == ref)['root']! as Map);

Map _node(List<Map> nodes, String id) =>
    nodes.singleWhere((node) => node['id'] == id);

PortableComponentDocument _component(String name) {
  final bytes = File(
    '../mix_component_contract/test/fixtures/$name',
  ).readAsBytesSync();
  return parsePortableComponentDocument(
    Uint8List.fromList(bytes),
    path: 'fixtures/$name',
  );
}

PortableComponentDocument _localComponent(String name) {
  final bytes = File('test/fixtures/components/$name').readAsBytesSync();
  return parsePortableComponentDocument(
    Uint8List.fromList(bytes),
    path: 'fixtures/components/$name',
  );
}
