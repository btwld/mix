import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/identity/mix_figma_lock.dart';
import 'package:mix_figma/src/core/protocol_json/figma_style_payloads.dart';
import 'package:mix_figma/src/core/protocol_json/figma_variable_payload.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_figma_styles.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_figma_variables.dart';

void main() {
  final light = <String, Object?>{
    'v': 1,
    'type': 'theme',
    'colors': {
      'color.brand': '#336699',
      'color.accent': {r'$token': 'color.brand'},
    },
    'spaces': {'space.sm': 8},
    'doubles': {'opacity.disabled': 0.64},
    'radii': {'radius.card': 12},
    'textStyles': {
      'type.body': {
        'fontFamily': 'Inter',
        'fontSize': 14,
        'fontWeight': 'w400',
        'height': 1.4,
        'letterSpacing': -0.25,
      },
    },
    'boxShadows': {
      'shadow.raised': [
        {
          'color': '#33000000',
          'offset': {'x': 0, 'y': 2},
          'blurRadius': 8,
          'spreadRadius': 1,
        },
      ],
    },
    'fontWeights': {'weight.strong': 'w700'},
  };
  final dark = <String, Object?>{
    ...light,
    'colors': {
      'color.brand': '#8DA4EF',
      'color.accent': {r'$token': 'color.brand'},
    },
  };

  test('lock file preserves stable Figma identities', () {
    final lock = MixFigmaLock(
      collectionIds: {'Core': 'collection-existing'},
      modeIds: const {
        'Core': {
          'mode:dark': 'figma-mode-dark',
          'mode:light': 'figma-mode-light',
        },
      },
      variableIds: {'colors/color.brand': 'variable-existing'},
    );
    final decoded = MixFigmaLock.fromJson(lock.toJson());

    expect(decoded.collectionIds, lock.collectionIds);
    expect(decoded.variableIds, lock.variableIds);
    expect(decoded.toJson()['schema'], 'mix_figma/lock/v2');
  });

  test('theme push payload reaches a byte-stable primitive fixed point', () {
    final lock = MixFigmaLock(
      collectionIds: {'Core': 'collection-existing'},
      modeIds: const {
        'Core': {
          'mode:dark': 'figma-mode-dark',
          'mode:light': 'figma-mode-light',
        },
      },
      variableIds: {'colors/color.brand': 'variable-existing'},
    );
    final push = buildFigmaVariableWritePayload(
      {'light': light, 'dark': dark},
      collectionName: 'Core',
      lock: lock,
    );
    final json = push.value;
    final variables = (json['variables']! as List<Object?>).cast<Map>();

    expect((json['collection']! as Map)['id'], 'collection-existing');
    expect(
      ((json['collections']! as List).single! as Map)['modes'],
      containsAll(<Map<String, Object?>>[
        {'ref': 'mode:dark', 'sourceId': 'figma-mode-dark', 'name': 'dark'},
        {'ref': 'mode:light', 'sourceId': 'figma-mode-light', 'name': 'light'},
      ]),
    );
    expect(
      variables.singleWhere(
        (variable) => variable['key'] == 'colors/color.brand',
      )['id'],
      'variable-existing',
    );
    expect(
      variables.map((variable) => variable['key']),
      isNot(contains(startsWith('textStyles/'))),
    );
    final pulled = buildProtocolThemeJsonFromFigmaVariables(
      figmaVariablesDocumentFromWritePayload(json),
      modeId: 'figma-mode-light',
    );
    expect(pulled.value, {
      'v': 1,
      'type': 'theme',
      'colors': light['colors'],
      'spaces': light['spaces'],
      'doubles': light['doubles'],
      'radii': light['radii'],
      'fontWeights': light['fontWeights'],
    });
    expect(pulled.diagnostics, isEmpty);
  });

  test('composites route only to text/effect style payloads', () {
    final variables = buildFigmaVariableWritePayload({'light': light}).value;
    final styles = buildFigmaStylePayloads(light).value;
    final variableKeys = (variables['variables']! as List<Object?>)
        .cast<Map>()
        .map((item) => item['key']);
    final styleTypes = (styles['styles']! as List<Object?>).cast<Map>().map(
      (item) => item['styleType'],
    );

    expect(variableKeys, isNot(contains(startsWith('textStyles/'))));
    expect(variableKeys, isNot(contains(startsWith('boxShadows/'))));
    expect(styleTypes, containsAll(['TEXT', 'EFFECT']));
    final effect = ((styles['effectStyles']! as List).single! as Map);
    final textStyle = ((styles['textStyles']! as List).single! as Map);
    final effectValue = ((effect['effects']! as List).single! as Map);
    final color = effectValue['color'];
    expect(color, isA<Map>());
    expect(effectValue['blendMode'], 'NORMAL');
    expect(textStyle['letterSpacing'], {'unit': 'PIXELS', 'value': -0.25});
  });

  test('mode-invariant push diagnostics are reported once', () {
    final result = buildFigmaVariableWritePayload({
      'light': light,
      'dark': dark,
    });
    final keys = result.diagnostics
        .map(
          (item) =>
              '${item.severity.name}|${item.code}|${item.path}|${item.message}',
        )
        .toList();

    expect(keys.toSet(), hasLength(keys.length));
    expect(
      result.diagnostics.where(
        (item) => item.code == 'composite_token_uses_style_payload',
      ),
      hasLength(2),
    );
  });

  test('primitive aliases and composites reach a full golden fixed point', () {
    final variables = buildFigmaVariableWritePayload({
      'light': light,
      'dark': dark,
    }).value;
    final styles = buildFigmaStylePayloads(light).value;
    final pulledPrimitives = buildProtocolThemeJsonFromFigmaVariables(
      figmaVariablesDocumentFromWritePayload(variables),
      modeId: 'mode:light',
    ).value;
    final pulledComposites = buildProtocolThemeJsonFromFigmaStyles(
      figmaStylesDocumentFromWritePayload(styles),
    ).value;
    final pulled = <String, Object?>{
      ...pulledPrimitives,
      for (final group in [
        'colors',
        'spaces',
        'doubles',
        'radii',
        'textStyles',
        'shadows',
        'boxShadows',
        'borders',
        'fontWeights',
      ])
        if (pulledPrimitives[group] is Map || pulledComposites[group] is Map)
          group: {
            if (pulledPrimitives[group] is Map)
              ...(pulledPrimitives[group]! as Map),
            if (pulledComposites[group] is Map)
              ...(pulledComposites[group]! as Map),
          },
    };

    expect(pulled, light);
  });
}
