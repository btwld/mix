import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  group('style document inspection', () {
    test('preserves merge positions, selectors, pointers, and token uses', () {
      final inspection = _inspectStyle({
        'v': 1,
        'type': 'flex_box',
        'padding': {
          r'$merge': [
            {'top': 4},
            {
              'left': {r'$token': 'space.pad', 'kind': 'space'},
            },
          ],
        },
        'variants': [
          {
            'kind': 'widget_state',
            'state': 'hovered',
            'style': {
              'type': 'flex_box',
              'spacing': {r'$token': 'space.gap', 'kind': 'space'},
            },
          },
        ],
      });

      expect(
        inspection.values,
        contains(
          isA<MixProtocolValueEvidence>()
              .having((term) => term.property, 'property', 'padding.top')
              .having(
                (term) => term.jsonPointer,
                'pointer',
                r'/padding/$merge/0/top',
              )
              .having((term) => term.mergePath, 'merge path', [0])
              .having((term) => term.literalValue, 'literal', 4),
        ),
      );
      final left = inspection.values.singleWhere(
        (term) => term.property == 'padding.left',
      );
      expect(left.mergePath, [1]);
      expect(left.token?.kind, 'spaces');
      expect(left.token?.name, 'space.pad');
      expect(left.token?.jsonPointer, r'/padding/$merge/1/left/$token');

      final hovered = inspection.values.singleWhere(
        (term) => term.property == 'spacing',
      );
      expect(hovered.selectors.single.kind, 'widget_state');
      expect(hovered.selectors.single.value, 'hovered');
      expect(hovered.token?.kind, 'spaces');
      expect(inspection.valueTokens, hasLength(2));
    });

    test('accepts strict per-call icon and image resolvers', () {
      const icon = IconData(0xe88a, fontFamily: 'MaterialIcons');
      const image = AssetImage('assets/avatar.png');

      final iconInspection = _inspectStyle({
        'v': 1,
        'type': 'icon',
        'icon': 'home',
      }, resolveIcon: (name) => name == 'home' ? icon : null);
      final imageInspection = _inspectStyle({
        'v': 1,
        'type': 'image',
        'image': 'avatar',
      }, resolveImage: (name) => name == 'avatar' ? image : null);

      expect(
        iconInspection.values.singleWhere((term) => term.property == 'icon'),
        isA<MixProtocolValueEvidence>().having(
          (term) => term.literalValue,
          'literal value',
          'home',
        ),
      );
      expect(
        imageInspection.values.singleWhere((term) => term.property == 'image'),
        isA<MixProtocolValueEvidence>().having(
          (term) => term.literalValue,
          'literal value',
          'avatar',
        ),
      );
    });

    test('reports merge directives without flattening them into terms', () {
      final inspection = _inspectStyle({
        'v': 1,
        'type': 'flex',
        'spacing': {
          r'$merge': [4],
          'apply': [
            {'op': 'number_multiply', 'factor': 2},
          ],
        },
      });

      expect(inspection.values, hasLength(1));
      expect(inspection.values.single.property, 'spacing');
      expect(inspection.values.single.jsonPointer, r'/spacing/$merge/0');
      expect(inspection.directives, hasLength(1));
      expect(
        inspection.directives.single,
        isA<MixProtocolDirectiveEvidence>()
            .having((directive) => directive.property, 'property', 'spacing')
            .having(
              (directive) => directive.jsonPointer,
              'pointer',
              '/spacing/apply/0',
            )
            .having((directive) => directive.op, 'operation', 'number_multiply')
            .having((directive) => directive.parameters, 'parameters', {
              'factor': 2,
            }),
      );
      expect(
        () => inspection.directives.single.parameters['factor'] = 3,
        throwsUnsupportedError,
      );
    });

    test('reports breakpoint selector tokens at their exact pointers', () {
      final inspection = _inspectStyle({
        'v': 1,
        'type': 'box',
        'variants': [
          {
            'kind': 'context_breakpoint',
            'token': 'breakpoint.sidebar',
            'style': {
              'type': 'box',
              'decoration': {'color': '#112233'},
            },
          },
        ],
      });

      expect(inspection.selectors.single.tokenOccurrences, hasLength(1));
      expect(
        inspection.selectors.single.tokenOccurrences.single,
        isA<MixProtocolTokenOccurrence>()
            .having((token) => token.kind, 'kind', 'breakpoints')
            .having((token) => token.name, 'name', 'breakpoint.sidebar')
            .having(
              (token) => token.jsonPointer,
              'pointer',
              '/variants/0/token',
            ),
      );
    });

    test('emits empty selector evidence with complete selector context', () {
      final inspection = _inspectStyle({
        'v': 1,
        'type': 'box',
        'variants': [
          {
            'kind': 'widget_state',
            'state': 'hovered',
            'style': {
              'type': 'box',
              'variants': [
                {
                  'kind': 'widget_state',
                  'state': 'focused',
                  'style': {'type': 'box'},
                },
              ],
            },
          },
        ],
      });

      expect(inspection.selectors, hasLength(2));
      final focused = inspection.selectors.last;
      expect(focused.selectors.single.value, 'hovered');
      expect(focused.selector.value, 'focused');
      expect(focused.mergePath, isEmpty);
      expect(inspection.values, isEmpty);
    });

    test(
      'preserves nested merge ancestry and sorts array indices numerically',
      () {
        final inspection = _inspectStyle({
          'v': 1,
          'type': 'flex',
          'spacing': {
            r'$merge': [
              for (var index = 0; index < 12; index += 1)
                if (index == 1)
                  {
                    r'$merge': [0, 1, 2],
                    'apply': [
                      {'op': 'number_multiply', 'factor': 2},
                    ],
                  }
                else
                  index,
            ],
          },
        });

        expect(inspection.values.map((value) => value.mergePath), [
          [0],
          [1, 0],
          [1, 1],
          [1, 2],
          [2],
          [3],
          [4],
          [5],
          [6],
          [7],
          [8],
          [9],
          [10],
          [11],
        ]);
        expect(inspection.directives.single.mergePath, [1]);
      },
    );

    test('canonicalizes reordered compound and nested selector fields', () {
      final left = _selectorFrom({
        'kind': 'context_not',
        'variant': {
          'kind': 'context_not',
          'variant': {'kind': 'context_platform', 'platform': 'android'},
        },
      });
      final right = _selectorFrom({
        'variant': {
          'variant': {'platform': 'android', 'kind': 'context_platform'},
          'kind': 'context_not',
        },
        'kind': 'context_not',
      });

      expect(left.fields, right.fields);
      expect(left.value, right.value);
      expect(left.key, right.key);
    });

    test('canonicalizes reordered breakpoint selector fields', () {
      final left = _selectorFrom({
        'kind': 'context_breakpoint',
        'token': 'breakpoint.sidebar',
      });
      final right = _selectorFrom({
        'token': 'breakpoint.sidebar',
        'kind': 'context_breakpoint',
      });

      expect(left.fields, right.fields);
      expect(left.value, right.value);
      expect(left.key, right.key);
    });

    test('uses schema context for same-name cross-kind token references', () {
      final inspection = _inspectStyle({
        'v': 1,
        'type': 'text',
        'style': {
          'color': {r'$token': 'shared'},
          'fontSize': {r'$token': 'shared'},
        },
      });

      final occurrences = {
        for (final token in inspection.valueTokens)
          token.jsonPointer: token.kind,
      };
      expect(occurrences, {
        r'/style/color/$token': 'colors',
        r'/style/fontSize/$token': 'spaces',
      });
    });

    test('uses parent context for colliding property names', () {
      final inspection = _inspectStyle({
        'v': 1,
        'type': 'box',
        'padding': {
          'top': {r'$token': 'shared'},
        },
        'decoration': {
          'border': {
            'top': {r'$token': 'shared'},
          },
        },
      });

      final occurrences = {
        for (final token in inspection.valueTokens)
          token.jsonPointer: token.kind,
      };
      expect(occurrences, {
        r'/padding/top/$token': 'spaces',
        r'/decoration/border/top/$token': 'borders',
      });
    });

    test('distinguishes numeric radius fields from radius tokens', () {
      final inspection = _inspectStyle({
        'v': 1,
        'type': 'box',
        'decoration': {
          'color': {r'$token': 'shared'},
          'gradient': {
            'kind': 'radial',
            'center': 'center',
            'radius': {r'$token': 'shared'},
            'colors': ['#FF0000', '#0000FF'],
          },
        },
      });

      final radius = inspection.valueTokens.singleWhere(
        (token) => token.jsonPointer == r'/decoration/gradient/radius/$token',
      );
      expect(radius.kind, 'spaces');
    });

    test('selector fields are defensively copied', () {
      final nested = <String, Object?>{'kind': 'context_web'};
      final fields = <String, Object?>{
        'kind': 'context_not',
        'variant': nested,
      };
      final selector = MixProtocolSelectorContext(
        kind: 'context_not',
        value: 'context_web',
        jsonPointer: '/variants/0',
        fields: fields,
      );

      fields['kind'] = 'changed';
      nested['kind'] = 'changed';

      expect(selector.fields['kind'], 'context_not');
      expect(
        (selector.fields['variant'] as Map<String, Object?>)['kind'],
        'context_web',
      );
      expect(() => selector.fields['kind'] = 'changed', throwsUnsupportedError);
      expect(
        () => (selector.fields['variant'] as Map<String, Object?>)['kind'] =
            'changed',
        throwsUnsupportedError,
      );
    });

    test('rejects invalid protocol data instead of inspecting guesses', () {
      final result = inspectStyleDocument({'v': 1, 'type': 'not_a_style'});

      expect(result, isA<MixProtocolFailure<MixProtocolStyleInspection>>());
    });
  });

  group('theme document inspection', () {
    test('reports direct values, aliases, chains, and resolved values', () {
      final result = inspectThemeDocument({
        'v': 1,
        'type': 'theme',
        'colors': {
          'color.base': '#112233',
          'color.alias': {r'$token': 'color.base'},
          'color.deep': {r'$token': 'color.alias'},
        },
      });
      final inspection = switch (result) {
        MixProtocolSuccess<MixProtocolThemeInspection>(:final value) => value,
        MixProtocolFailure<MixProtocolThemeInspection>(:final errors) => fail(
          '$errors',
        ),
      };

      final direct = inspection.tokens.singleWhere(
        (token) => token.name == 'color.base',
      );
      final alias = inspection.tokens.singleWhere(
        (token) => token.name == 'color.deep',
      );
      expect(direct.declaration, MixProtocolTokenDeclaration.direct);
      expect(direct.jsonPointer, '/colors/color.base');
      expect(direct.declaredWireValue, '#112233');
      expect(direct.resolvedWireValue, '#112233');
      expect(alias.declaration, MixProtocolTokenDeclaration.alias);
      expect(alias.aliasChain, ['color.deep', 'color.alias', 'color.base']);
      expect(alias.declaredWireValue, {r'$token': 'color.alias'});
      expect(alias.resolvedWireValue, '#112233');
    });

    test('reports canonical immutable wire values for every token kind', () {
      final payload = <String, Object?>{
        'v': 1,
        'type': 'theme',
        'colors': {'base': '#101820'},
        'spaces': {'base': 8},
        'doubles': {'base': 0.64},
        'radii': {'base': 12},
        'textStyles': {
          'base': {'fontSize': 14, 'height': 1.4},
        },
        'shadows': {
          'base': [
            {
              'color': '#33000000',
              'offset': {'x': 0, 'y': 1},
              'blurRadius': 2,
            },
          ],
        },
        'boxShadows': {
          'base': [
            {
              'color': '#33000000',
              'offset': {'x': 0, 'y': 2},
              'blurRadius': 8,
              'spreadRadius': 1,
            },
          ],
        },
        'borders': {
          'base': {'color': '#008577', 'width': 2, 'style': 'solid'},
        },
        'fontWeights': {'base': 'w700'},
        'breakpoints': {
          'base': {'minWidth': 960},
        },
        'durations': {'base': 120},
      };
      for (final entry in payload.entries.toList()) {
        if (entry.key == 'v' || entry.key == 'type') continue;
        final declarations = Map<String, Object?>.from(entry.value! as Map);
        payload[entry.key] = declarations;
        declarations['alias'] = {
          r'$token': 'base',
          if (entry.key == 'spaces') 'kind': 'space',
          if (entry.key == 'doubles') 'kind': 'double',
        };
        declarations['deep'] = {
          r'$token': 'alias',
          if (entry.key == 'spaces') 'kind': 'space',
          if (entry.key == 'doubles') 'kind': 'double',
        };
      }

      final inspection = switch (inspectThemeDocument(payload)) {
        MixProtocolSuccess<MixProtocolThemeInspection>(:final value) => value,
        MixProtocolFailure<MixProtocolThemeInspection>(:final errors) => fail(
          '$errors',
        ),
      };

      for (final kind in payload.keys.where(
        (key) => key != 'v' && key != 'type',
      )) {
        final direct = inspection.tokens.singleWhere(
          (token) => token.kind == kind && token.name == 'base',
        );
        final alias = inspection.tokens.singleWhere(
          (token) => token.kind == kind && token.name == 'deep',
        );
        expect(alias.aliasChain, ['deep', 'alias', 'base']);
        expect(alias.resolvedWireValue, direct.resolvedWireValue);
        expect(alias.declaredWireValue, containsPair(r'$token', 'alias'));
      }

      final textStyle = inspection.tokens.singleWhere(
        (token) => token.kind == 'textStyles' && token.name == 'base',
      );
      final shadow = inspection.tokens.singleWhere(
        (token) => token.kind == 'shadows' && token.name == 'base',
      );
      expect(
        () =>
            (textStyle.resolvedWireValue! as Map<String, Object?>)['fontSize'] =
                16,
        throwsUnsupportedError,
      );
      expect(
        () => (shadow.resolvedWireValue! as List<Object?>).add(null),
        throwsUnsupportedError,
      );
      expect(
        () =>
            ((shadow.resolvedWireValue! as List<Object?>).single
                    as Map<String, Object?>)['blurRadius'] =
                4,
        throwsUnsupportedError,
      );
    });
  });
}

extension on MixProtocolStyleInspection {
  Iterable<MixProtocolValueEvidence> get values =>
      evidence.whereType<MixProtocolValueEvidence>();

  Iterable<MixProtocolDirectiveEvidence> get directives =>
      evidence.whereType<MixProtocolDirectiveEvidence>();

  Iterable<MixProtocolSelectorEvidence> get selectors =>
      evidence.whereType<MixProtocolSelectorEvidence>();

  Iterable<MixProtocolTokenOccurrence> get valueTokens =>
      values.map((value) => value.token).nonNulls;
}

MixProtocolStyleInspection _inspectStyle(
  Object? payload, {
  MixProtocolIconResolver? resolveIcon,
  MixProtocolImageResolver? resolveImage,
}) {
  return switch (inspectStyleDocument(
    payload,
    resolveIcon: resolveIcon,
    resolveImage: resolveImage,
  )) {
    MixProtocolSuccess<MixProtocolStyleInspection>(:final value) => value,
    MixProtocolFailure<MixProtocolStyleInspection>(:final errors) => fail(
      '$errors',
    ),
  };
}

MixProtocolSelectorContext _selectorFrom(Map<String, Object?> selector) {
  final inspection = _inspectStyle({
    'v': 1,
    'type': 'box',
    'variants': [
      {
        ...selector,
        'style': {'type': 'box'},
      },
    ],
  });

  return inspection.selectors.single.selector;
}
