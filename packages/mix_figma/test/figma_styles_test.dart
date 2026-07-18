import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/figma/figma_styles_parser.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_figma_styles.dart';

void main() {
  test('parses values-bearing local Figma styles', () {
    final document = parseFigmaStylesDocument(_fixture());

    expect(document.styles, hasLength(5));
    expect(document.styles.first.type.name, 'text');
    expect(document.styles.first.value['fontFamily'], 'Inter');
  });

  test('maps composites and reports every unsupported style', () {
    final result = buildProtocolThemeJsonFromFigmaStyles(
      parseFigmaStylesDocument(_fixture()),
    );

    expect(result.value['textStyles'], {
      'type.body': {
        'fontFamily': 'Inter',
        'fontSize': 14,
        'fontWeight': 'w400',
        'fontStyle': 'normal',
        'height': 1.4,
        'letterSpacing': 0.2,
      },
    });
    expect((result.value['boxShadows']! as Map)['shadow.box.raised'], [
      {
        'color': '#33000000',
        'offset': {'x': 0, 'y': 2},
        'blurRadius': 8,
        'spreadRadius': 1,
      },
    ]);
    expect(result.value['colors'], {'color.brand.paint': '#336699'});
    expect(result.styleFragments['gradient.brand'], {
      'v': 1,
      'type': 'box',
      'decoration': {
        'gradient': {
          'kind': 'linear',
          'colors': ['#336699', '#8DA4EF'],
          'stops': [0, 1],
        },
      },
    });
    expect(result.coverage.items, hasLength(5));
    expect(result.coverage.unsupportedCount, 1);
    expect(
      result.diagnostics.map((item) => item.code),
      contains('unsupported_inner_shadow'),
    );
  });
}

Map<String, Object?> _fixture() =>
    jsonDecode(
          File('test/fixtures/style_docs/figma_styles.json').readAsStringSync(),
        )
        as Map<String, Object?>;
