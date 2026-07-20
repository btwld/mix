import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/dtcg/dtcg_parser.dart';
import 'package:mix_figma/src/core/dtcg/dtcg_writer.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_dtcg.dart';

void main() {
  group('DTCG 2025.10 and Tokens Studio', () {
    test('parser and writer preserve aliases and extensions', () {
      final input = _json('dtcg/light.tokens.json');
      final document = parseDtcgDocument(input);

      expect(document.extensions['com.btwld.mix'], {'mode': 'light'});
      expect(
        document.tokens['color.brand.accent']!.value,
        '{color.brand.primary}',
      );
      expect(document.tokens['space.stack.sm']!.mixGroup, 'spaces');
      expect(writeDtcgDocument(document), input);
    });

    test('maps every protocol theme group to the canonical golden', () {
      final document = parseDtcgDocument(_json('dtcg/light.tokens.json'));
      final result = buildProtocolThemeJsonFromDtcg(document);

      expect(result.diagnostics, isEmpty);
      expect(result.value, _json('theme_docs/light.theme.json'));
      expect(result.value.keys.toList(), [
        'v',
        'type',
        'colors',
        'spaces',
        'doubles',
        'radii',
        'textStyles',
        'shadows',
        'boxShadows',
        'borders',
        'fontWeights',
        'breakpoints',
        'durations',
      ]);
    });

    test('maps Tokens Studio legacy type/value tokens losslessly', () {
      final input = _json('dtcg/tokens_studio_legacy.tokens.json');
      final document = parseDtcgDocument(input);

      expect(document.tokens['global.color.brand']!.type, 'color');
      expect(
        document.tokens['global.color.accent']!.value,
        '{global.color.brand}',
      );
      expect(document.tokens['global.space.stack.sm']!.mixGroup, 'spaces');
      expect(writeDtcgDocument(document), input);

      final result = buildProtocolThemeJsonFromDtcg(document);
      expect(result.diagnostics, isEmpty);
      expect(result.value, {
        'v': 1,
        'type': 'theme',
        'colors': {
          'global.color.accent': {r'$token': 'global.color.brand'},
          'global.color.brand': '#336699',
        },
        'spaces': {'global.space.stack.sm': 8},
      });
    });
  });
}

Map<String, Object?> _json(String path) =>
    jsonDecode(File('test/fixtures/$path').readAsStringSync())
        as Map<String, Object?>;
