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
        inspection.terms,
        contains(
          isA<MixProtocolStyleTerm>()
              .having((term) => term.property, 'property', 'padding.top')
              .having(
                (term) => term.jsonPointer,
                'pointer',
                r'/padding/$merge/0/top',
              )
              .having((term) => term.mergeSource, 'merge source', 0)
              .having((term) => term.literalValue, 'literal', 4),
        ),
      );
      final left = inspection.terms.singleWhere(
        (term) => term.property == 'padding.left',
      );
      expect(left.mergeSource, 1);
      expect(left.token?.kind, 'spaces');
      expect(left.token?.name, 'space.pad');
      expect(left.token?.jsonPointer, r'/padding/$merge/1/left/$token');

      final hovered = inspection.terms.singleWhere(
        (term) => term.property == 'spacing',
      );
      expect(hovered.selectors.single.kind, 'widget_state');
      expect(hovered.selectors.single.value, 'hovered');
      expect(hovered.token?.kind, 'spaces');
      expect(inspection.tokenOccurrences, hasLength(2));
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
        iconInspection.terms.singleWhere((term) => term.property == 'icon'),
        isA<MixProtocolStyleTerm>().having(
          (term) => term.literalValue,
          'literal value',
          'home',
        ),
      );
      expect(
        imageInspection.terms.singleWhere((term) => term.property == 'image'),
        isA<MixProtocolStyleTerm>().having(
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

      expect(inspection.terms, hasLength(1));
      expect(inspection.terms.single.property, 'spacing');
      expect(inspection.terms.single.jsonPointer, r'/spacing/$merge/0');
      expect(inspection.directives, hasLength(1));
      expect(
        inspection.directives.single,
        isA<MixProtocolDirectiveInspection>()
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

      expect(inspection.tokenOccurrences, hasLength(1));
      expect(
        inspection.tokenOccurrences.single,
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
        for (final token in inspection.tokenOccurrences)
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
        for (final token in inspection.tokenOccurrences)
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

      final radius = inspection.tokenOccurrences.singleWhere(
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
      expect(direct.resolvedValue, const Color(0xFF112233));
      expect(alias.declaration, MixProtocolTokenDeclaration.alias);
      expect(alias.aliasChain, ['color.deep', 'color.alias', 'color.base']);
      expect(alias.resolvedValue, const Color(0xFF112233));
    });
  });
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
