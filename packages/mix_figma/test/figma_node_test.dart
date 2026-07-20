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

  test('flat plugin TEXT snapshots preserve typography and paint', () {
    final document = parseFigmaNodeDocument({
      'schema': 'mix_figma/figma-nodes/v1',
      'root': {
        'id': 'text:1',
        'name': 'Body',
        'type': 'TEXT',
        'fontName': {'family': 'Inter', 'style': 'Regular'},
        'fontSize': 16,
        'fontWeight': 500,
        'lineHeight': {'unit': 'PIXELS', 'value': 24},
        'letterSpacing': {'unit': 'PIXELS', 'value': 0.25},
        'fills': [
          {
            'type': 'SOLID',
            'visible': true,
            'color': {'r': 0.2, 'g': 0.4, 'b': 0.6, 'a': 1},
          },
        ],
      },
    });

    final result = buildProtocolStyleJsonFromNode(document.root);

    expect(result.diagnostics, isEmpty);
    expect(result.value, {
      'v': 1,
      'type': 'text',
      'style': {
        'color': '#336699',
        'fontFamily': 'Inter',
        'fontSize': 16,
        'fontWeight': 'w500',
        'height': 1.5,
        'letterSpacing': 0.25,
      },
    });
    expect(
      mixProtocol.decodeStyle<TextStyler>(result.value),
      isA<MixProtocolSuccess<TextStyler>>(),
    );
  });

  test('reference button maps to a strict Box style with a uniform border', () {
    final document = parseFigmaNodeDocument(_fixture('button.node.json'));
    final result = buildProtocolStyleJsonFromNode(document.root);

    expect(result.diagnostics, isEmpty);
    expect(
      mixProtocol.decodeStyle<BoxStyler>(result.value),
      isA<MixProtocolSuccess<BoxStyler>>(),
    );
    _expectCanonicalStyle<BoxStyler>(result.value);
  });

  test('auto-layout component nodes use the FlexBox style mapper', () {
    final result = buildProtocolStyleJsonFromNode(
      parseFigmaNodeDocument({
        'schema': 'mix_figma/figma-nodes/v1',
        'root': {
          'id': 'component:button',
          'name': 'Button',
          'type': 'COMPONENT',
          'layoutMode': 'HORIZONTAL',
          'children': <Object?>[],
        },
      }).root,
    );

    expect(result.value['type'], 'flex_box');
    expect(
      mixProtocol.decodeStyle<FlexBoxStyler>(result.value),
      isA<MixProtocolSuccess<FlexBoxStyler>>(),
    );
  });

  test('non-auto-layout component nodes use the StackBox style mapper', () {
    final result = buildProtocolStyleJsonFromNode(
      parseFigmaNodeDocument({
        'schema': 'mix_figma/figma-nodes/v1',
        'root': {
          'id': 'component:card',
          'name': 'Card',
          'type': 'COMPONENT',
          'layoutMode': 'NONE',
          'children': <Object?>[],
        },
      }).root,
    );

    expect(result.value['type'], 'stack_box');
    expect(
      mixProtocol.decodeStyle<StackBoxStyler>(result.value),
      isA<MixProtocolSuccess<StackBoxStyler>>(),
    );
  });

  test('actual plugin bound fields retain token terms', () {
    final result = buildProtocolStyleJsonFromNode(
      parseFigmaNodeDocument({
        'schema': 'mix_figma/figma-nodes/v1',
        'root': {
          'id': 'text:bound',
          'name': 'Bound text',
          'type': 'TEXT',
          'fontSize': 16,
          'letterSpacing': {'unit': 'PIXELS', 'value': 0.25},
          'boundVariables': {
            'fontSize': {'name': 'space.font.size', 'kind': 'spaces'},
            'letterSpacing': {'name': 'space.letter.spacing', 'kind': 'spaces'},
          },
          'children': <Object?>[],
        },
      }).root,
    );
    final style = (result.value['style']! as Map).cast<String, Object?>();

    expect(style['fontSize'], {r'$token': 'space.font.size', 'kind': 'space'});
    expect(style['letterSpacing'], {
      r'$token': 'space.letter.spacing',
      'kind': 'space',
    });
    _expectCanonicalStyle<TextStyler>(result.value);
  });

  test('actual plugin margin metadata emits a structured diagnostic', () {
    expect(
      _diagnosticCodes({
        'pluginData': {'mix_figma.margin': '{"left":8}'},
      }),
      contains('unsupported_margin'),
    );
  });

  test('actual plugin foreground metadata emits a structured diagnostic', () {
    expect(
      _diagnosticCodes({
        'pluginData': {'mix_figma.foregroundDecoration': '{"color":"#000000"}'},
      }),
      contains('unsupported_foreground_decoration'),
    );
  });

  test('actual plugin per-edge stroke fields emit a structured diagnostic', () {
    expect(
      _diagnosticCodes({
        'strokeTopWeight': 1,
        'strokeRightWeight': 2,
        'strokeBottomWeight': 1,
        'strokeLeftWeight': 2,
      }),
      contains('unsupported_per_edge_borders'),
    );
  });

  test('inner shadows emit a structured diagnostic', () {
    expect(
      _diagnosticCodes({
        'effects': [
          {'type': 'INNER_SHADOW', 'visible': true},
        ],
      }),
      contains('unsupported_inner_shadow'),
    );
  });

  test('sweep gradients in strokes emit a structured diagnostic', () {
    expect(
      _diagnosticCodes({
        'strokes': [
          {'type': 'GRADIENT_ANGULAR', 'visible': true},
        ],
      }),
      contains('unsupported_sweep_gradient'),
    );
  });

  test('absolute positioned children emit a structured diagnostic', () {
    expect(
      _diagnosticCodes({
        'children': [
          {
            'id': 'absolute',
            'name': 'Absolute',
            'type': 'RECTANGLE',
            'layoutPositioning': 'ABSOLUTE',
            'children': <Object?>[],
          },
        ],
      }),
      contains('unsupported_absolute_positioned_child'),
    );
  });
}

Set<String> _diagnosticCodes(Map<String, Object?> overrides) {
  final root = <String, Object?>{
    'id': 'node:root',
    'name': 'Node',
    'type': 'RECTANGLE',
    'children': <Object?>[],
    ...overrides,
  };
  final result = buildProtocolStyleJsonFromNode(
    parseFigmaNodeDocument({
      'schema': 'mix_figma/figma-nodes/v1',
      'root': root,
    }).root,
  );

  return result.diagnostics.map((item) => item.code).toSet();
}

void _expectCanonicalStyle<T extends Object>(Map<String, Object?> document) {
  final decoded = switch (mixProtocol.decodeStyle<T>(document)) {
    MixProtocolSuccess<T>(:final value) => value,
    MixProtocolFailure<T>(:final errors) => fail('$errors'),
  };
  final encoded = switch (mixProtocol.encodeStyle(decoded)) {
    MixProtocolSuccess<JsonMap>(:final value) => value,
    MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
  };

  expect(encoded, document);
}

Map<String, Object?> _fixture([String name = 'card.node.json']) =>
    jsonDecode(File('test/fixtures/style_docs/$name').readAsStringSync())
        as Map<String, Object?>;
