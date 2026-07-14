import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  group('style document inspection', () {
    test('preserves merge positions, selectors, pointers, and token uses', () {
      final result = inspectStyleDocument({
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
      final inspection = switch (result) {
        MixProtocolSuccess<MixProtocolStyleInspection>(:final value) => value,
        MixProtocolFailure<MixProtocolStyleInspection>(:final errors) => fail(
          '$errors',
        ),
      };

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
