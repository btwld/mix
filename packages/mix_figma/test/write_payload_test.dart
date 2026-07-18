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
    const lock = MixFigmaLock(
      collectionIds: {'Core': 'collection-existing'},
      variableIds: {'colors/color.brand': 'variable-existing'},
    );
    final decoded = MixFigmaLock.fromJson(lock.toJson());

    expect(decoded.collectionIds, lock.collectionIds);
    expect(decoded.variableIds, lock.variableIds);
    expect(decoded.toJson()['schema'], 'mix_figma/lock/v1');
  });

  test('theme push payload reaches a byte-stable primitive fixed point', () {
    const lock = MixFigmaLock(
      collectionIds: {'Core': 'collection-existing'},
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
      modeId: 'mode:light',
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
    final color = ((((effect['effects']! as List).single! as Map)['color']));
    expect(color, isA<Map>());
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
