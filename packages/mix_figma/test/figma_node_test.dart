import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_figma/src/core/figma/figma_node_document.dart';
import 'package:mix_figma/src/core/protocol_json/style_from_figma_node.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  test('reference auto-layout card maps to a strict FlexBox style', () {
    final document = parseFigmaNodeDocument(_fixture());
    final result = buildProtocolStyleJsonFromNode(document.root);

    expect(result.diagnostics, isEmpty);
    expect(result.value, {
      'v': 1,
      'type': 'flex_box',
      'padding': {'left': 16, 'top': 12, 'right': 16, 'bottom': 12},
      'decoration': {
        'color': {r'$token': 'color.brand.primary'},
        'borderRadius': 12,
      },
      'direction': 'horizontal',
      'mainAxisAlignment': 'spaceBetween',
      'crossAxisAlignment': 'center',
      'spacing': {r'$token': 'space.stack.sm', 'kind': 'space'},
    });
    expect(
      mixProtocol.decodeStyle<FlexBoxStyler>(result.value),
      isA<MixProtocolSuccess<FlexBoxStyler>>(),
    );
  });

  test('bound node values become protocol token terms', () {
    final root = parseFigmaNodeDocument(_fixture()).root;
    final result = buildProtocolStyleJsonFromNode(root);
    final decoration = result.value['decoration']! as Map<String, Object?>;

    expect(decoration['color'], {r'$token': 'color.brand.primary'});
    expect(result.value['spacing'], {
      r'$token': 'space.stack.sm',
      'kind': 'space',
    });
  });

  test('known no-analog cases always emit structured diagnostics', () {
    final root = Map<String, Object?>.from(_fixture()['root']! as Map)
      ..['margin'] = 8
      ..['individualStrokeWeights'] = {'top': 1, 'right': 2}
      ..['foregroundDecoration'] = {'color': '#000000'}
      ..['effects'] = [
        {'type': 'INNER_SHADOW', 'visible': true},
      ]
      ..['fills'] = [
        {'type': 'GRADIENT_ANGULAR', 'visible': true},
      ];
    final children = (root['children']! as List<Object?>).toList();
    children.add({
      'id': 'absolute',
      'name': 'Absolute',
      'type': 'RECTANGLE',
      'layoutPositioning': 'ABSOLUTE',
      'children': <Object?>[],
    });
    root['children'] = children;
    final result = buildProtocolStyleJsonFromNode(
      parseFigmaNodeDocument({
        'schema': 'mix_figma/figma-nodes/v1',
        'root': root,
      }).root,
    );

    expect(
      result.diagnostics.map((item) => item.code).toSet(),
      containsAll({
        'unsupported_margin',
        'unsupported_inner_shadow',
        'unsupported_absolute_position',
        'unsupported_sweep_gradient',
        'unsupported_per_edge_borders',
        'unsupported_foreground_decoration',
      }),
    );
  });
}

Map<String, Object?> _fixture() =>
    jsonDecode(
          File('test/fixtures/style_docs/card.node.json').readAsStringSync(),
        )
        as Map<String, Object?>;
